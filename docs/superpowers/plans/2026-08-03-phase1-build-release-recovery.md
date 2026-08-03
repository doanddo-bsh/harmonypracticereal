# Phase 1: 빌드·출시 복구 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 「화성 박사」앱이 Google Play 업데이트 심사를 통과하고 iOS TestFlight에 다시 업로드될 수 있는 상태로 복구한다.

**Architecture:** 코드 로직은 건드리지 않는다. 이 단계는 (1) 툴체인/SDK 타깃 상향, (2) 의존성 메이저 업그레이드와 그로 인한 breaking change 대응, (3) 저장소만 클론해도 빌드되도록 Firebase 설정 파일화, (4) 프로덕션에 섞여 있는 GDPR 디버그 코드 제거 — 이 4가지만 다룬다. 각 태스크 끝에서 `flutter analyze`가 error 0을 유지해야 한다.

**Tech Stack:** Flutter 3.44.2 / Dart 3.12.2, Gradle 8.x + AGP 8.x + Kotlin 2.x, Firebase(core·analytics), google_mobile_ads, provider, music_notes

---

## 사전 확인 (실행 전 1회)

- [ ] **Step 0-1: 현재 상태를 기준선으로 기록**

```bash
cd /Users/s.bark/Downloads/A001_project/A006_harmony_proctice
flutter --version
flutter analyze 2>&1 | tail -3
```

기대 출력: `Flutter 3.44.2`, `204 issues found.` (error 0)
이 숫자를 메모해 둔다. 이후 태스크에서 error가 1개라도 생기면 즉시 되돌린다.

- [ ] **Step 0-2: 작업 브랜치 생성**

```bash
git checkout -b phase1/build-release-recovery
```

---

## File Structure

이 단계에서 만들거나 고치는 파일과 책임:

| 파일 | 책임 | 신규/수정 |
|---|---|---|
| `.gitignore` | Firebase 설정·키스토어 비밀정보 제외 | 수정 |
| `firebase.json`, `lib/firebase_options.dart` | FlutterFire CLI가 생성하는 플랫폼별 Firebase 설정 | 신규(생성물) |
| `lib/main.dart` | `Firebase.initializeApp(options:)` 로 명시 초기화, deprecated API 제거 | 수정 |
| `lib/page/settingPage/firebase_options.dart` | 빈 파일 — 삭제 | 삭제 |
| `android/app/build.gradle` | compileSdk/targetSdk 36, minSdk 23, Java 17, namespace 교정 | 수정 |
| `android/build.gradle`, `android/settings.gradle` | AGP 8 플러그인 선언 방식으로 이전 | 수정 |
| `android/gradle/wrapper/gradle-wrapper.properties` | Gradle 8.x | 수정 |
| `ios/Podfile` | `platform :ios, '15.0'` | 수정 |
| `ios/Runner.xcodeproj/project.pbxproj` | `IPHONEOS_DEPLOYMENT_TARGET = 15.0` | 수정 |
| `pubspec.yaml` | 의존성 메이저 업그레이드, `dependency_overrides` 제거 | 수정 |
| `lib/page/settingPage/initialization_helper.dart` | GDPR 디버그 설정 제거 (프로덕션 버그) | 수정 |
| `test/harmony/harmony_engine_invariant_test.dart` | 업그레이드 회귀 감지용 안전망 테스트 | 신규 |
| `analysis_options.yaml` | flutter_lints 6 기준 규칙 | 수정 |

---

## Task 1: 회귀 감지용 안전망 테스트 먼저 깔기

의존성을 올리기 **전에** 화성 엔진의 동작을 고정하는 테스트를 만든다. 이 테스트가 없으면 `music_notes` 업그레이드가 정답 문자열을 바꿔도 알아챌 방법이 없다.

**Files:**
- Test: `test/harmony/harmony_engine_invariant_test.dart` (생성)

**배경 지식 (테스트를 쓰기 위해 알아야 할 것):**

`lib/harmonyModul/` 의 모든 문제 생성 함수는 동일한 Dart record를 반환한다:

```dart
(List<String>, List<Note>, Tonality, List<Note>, String)
//     ↑            ↑          ↑          ↑        ↑
//  정답 9칸    출제 4성부   조성      원화음    문제이름
```

정답 9칸의 의미 (`lib/harmonyModul/modulBasic.dart:283` 참조):
`[R1, D1, N1, N2, S, R2, D2, N3, N4]`
- `R1` 로마숫자 (예: `'V'`), `D1` 감·증 기호 (`'⊙'`, `'∅'` 등), `N1`/`N2` 자리바꿈 숫자 (`'6'`, `'4'`)
- `S` 슬래시 (부화음일 때 `'/'`), `R2`~`N4` 는 슬래시 뒤 대상 화음

함수들은 내부에서 `Random()` 을 쓰므로 결과가 매번 다르다. 따라서 **값을 고정하는 테스트가 아니라, 몇 백 번 돌려도 항상 참인 성질(invariant)을 검사하는 테스트**를 쓴다.

- [ ] **Step 1: 실패하는 테스트 작성**

`test/harmony/harmony_engine_invariant_test.dart` 를 아래 내용으로 생성:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:music_notes/music_notes.dart';

import 'package:harmonypracticereal/harmonyModul/modulBasic.dart';
import 'package:harmonypracticereal/harmonyModul/modulBasicMinor.dart';
import 'package:harmonypracticereal/harmonyModul/modulProblemProbability.dart';

/// 문제 생성 함수 하나를 [times]번 돌려 공통 불변식을 검사한다.
void expectValidProblem(
  (List<String>, List<Note>, Tonality, List<Note>, String) Function() generator,
  String expectedName, {
  int times = 200,
}) {
  for (var i = 0; i < times; i++) {
    final (answer, problem, tonality, original, name) = generator();

    expect(answer.length, 9,
        reason: '$expectedName: 정답은 항상 9칸이어야 한다 (회차 $i)');
    expect(problem.length, 4,
        reason: '$expectedName: 출제는 항상 4성부여야 한다 (회차 $i)');
    expect(original.length, anyOf(3, 4),
        reason: '$expectedName: 원화음은 3화음 또는 7화음이어야 한다 (회차 $i)');
    expect(answer[0], isNotEmpty,
        reason: '$expectedName: 로마숫자가 비어 있으면 안 된다 (회차 $i)');
    expect(name, expectedName, reason: '문제 이름이 일치해야 한다 (회차 $i)');

    // 출제 4성부는 원화음의 구성음만으로 이루어져야 한다 (중복음 허용).
    for (final note in problem) {
      expect(original.contains(note), isTrue,
          reason: '$expectedName: $note 가 원화음 $original 에 없다 (회차 $i)');
    }
  }
}

void main() {
  group('장조 문제 생성 불변식', () {
    test('basicProblem (3화음)', () {
      expectValidProblem(basicProblem, 'basicProblem');
    });

    test('dominant7thProblem (속7화음)', () {
      expectValidProblem(dominant7thProblem, 'dominant7thProblem');
    });

    test('secondaryDominant7thProblem (부속7화음)', () {
      expectValidProblem(
          secondaryDominant7thProblem, 'secondaryDominant7thProblem');
    });

    test('neapolitanProblem (나폴리화음)', () {
      expectValidProblem(neapolitanProblem, 'neapolitanProblem');
    });
  });

  group('단조 문제 생성 불변식', () {
    test('basicProblemMinor (3화음)', () {
      expectValidProblem(basicProblemMinor, 'basicProblemMinor');
    });

    test('dominant7thProblemMinor (속7화음)', () {
      expectValidProblem(dominant7thProblemMinor, 'dominant7thProblemMinor');
    });
  });

  group('커스텀 출제기', () {
    test('선택한 화음 종류만 출제된다', () {
      for (var i = 0; i < 200; i++) {
        final (answer, problem, _, original, _) =
            getCustomProblemType(['3화음', '속7화음']);

        expect(answer.length, 9);
        expect(problem.length, 4);
        expect(original.length, anyOf(3, 4));
      }
    });

    test('단일 항목만 넘겨도 예외 없이 동작한다', () {
      for (var i = 0; i < 50; i++) {
        final (answer, _, _, _, _) = getCustomProblemType(['3화음']);
        expect(answer.length, 9);
      }
    });
  });
}
```

- [ ] **Step 2: 테스트 실행 — 통과하는지, 실패하는지 확인**

```bash
flutter test test/harmony/harmony_engine_invariant_test.dart
```

기대: **전부 PASS.** 이건 새 기능을 만드는 테스트가 아니라 기존 동작을 고정하는 특성화(characterization) 테스트이므로 처음부터 통과해야 정상이다.

만약 실패한다면 — 예를 들어 `original.contains(note)` 가 깨진다면 — 그건 이 계획의 가정이 틀린 것이다. 실패한 함수 이름과 실제 값을 기록하고, 그 함수 하나만 `expectValidProblem` 대상에서 빼되 **왜 뺐는지 파일 상단에 주석으로 남긴다.** 나머지는 그대로 진행한다. 절대 assertion을 느슨하게 고쳐서 억지로 통과시키지 않는다.

- [ ] **Step 3: 기본 위젯 테스트가 깨져 있는지 확인**

```bash
flutter test 2>&1 | tail -20
```

`test/widget_test.dart` 는 Flutter 기본 카운터 앱 템플릿이라 이 프로젝트에서는 거의 확실히 실패한다. 실패하면 삭제한다 (Phase 3에서 진짜 위젯 테스트로 대체):

```bash
git rm test/widget_test.dart
```

- [ ] **Step 4: 다시 전체 테스트 실행**

```bash
flutter test
```

기대: 모든 테스트 PASS.

- [ ] **Step 5: 커밋**

```bash
git add test/
git commit -m "test: 화성 엔진 불변식 테스트 추가 (업그레이드 회귀 안전망)"
```

---

## Task 2: GDPR 동의창 디버그 설정 제거 (프로덕션 버그)

**Files:**
- Modify: `lib/page/settingPage/initialization_helper.dart:26-56`

**문제 설명:**

`initialize()` 안에 UMP(사용자 메시지 플랫폼) **디버그 설정이 그대로 출시 코드에 들어가 있다:**

```dart
ConsentInformation.instance.reset();                    // ← 매 실행 동의 상태 초기화
debugGeography: DebugGeography.debugGeographyEea,       // ← 모든 사용자를 EEA로 위장
testIdentifiers: ['411F25A5-...'],
```

결과: **한국 사용자도 앱을 켤 때마다 GDPR 동의 팝업을 다시 본다.** 광고 수익과 사용자 이탈에 직접 영향이 있고, AdMob 정책 위반 소지도 있다. 이건 SDK 업그레이드보다 먼저 고쳐야 한다.

- [ ] **Step 1: 현재 동작을 눈으로 확인**

```bash
flutter run
```

앱을 켜고 → 강제 종료 → 다시 켠다. GDPR 동의 팝업이 **매번** 뜨는지 확인한다. 뜬다면 버그가 재현된 것이다.

- [ ] **Step 2: 디버그 설정 제거**

`lib/page/settingPage/initialization_helper.dart` 의 `initialize()` 메서드 전체를 아래로 교체한다 (주석 처리된 옛 코드 블록 `// ###...` 포함해서 전부):

```dart
  Future<FormError?> initialize() async {
    final completer = Completer<FormError?>();

    // 디버그 지역/테스트 기기 설정은 절대 넣지 않는다.
    // 넣으면 실제 사용자에게도 매 실행 동의창이 뜬다.
    final params = ConsentRequestParameters();

    ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        await _loadConsentForm();
      } else {
        // 표시할 메시지가 없으므로 여기서 광고 컴포넌트를 초기화한다.
        await _initialize();
      }
      completer.complete();
    }, (error) {
      completer.complete(error);
    });

    return completer.future;
  }
```

- [ ] **Step 3: 동의 상태 초기화가 코드 어디에도 남아있지 않은지 확인**

```bash
grep -rn "ConsentInformation.instance.reset\|DebugGeography\|ConsentDebugSettings\|testIdentifiers" lib/
```

기대 출력: **아무것도 나오지 않음.** 뭔가 나오면 그 위치도 제거한다.

- [ ] **Step 4: 동작 검증**

```bash
flutter run
```

앱 켜기 → 강제 종료 → 재실행. 이번엔 동의 팝업이 **다시 뜨지 않아야** 한다. (한국 IP 기준으로는 처음부터 안 뜰 수도 있다 — 그것도 정상이다.)
설정 화면에서 GDPR 항목이 여전히 동작하는지도 확인한다 (`SettingPage` → 개인정보 설정).

- [ ] **Step 5: 커밋**

```bash
git add lib/page/settingPage/initialization_helper.dart
git commit -m "fix: UMP 동의창 디버그 설정 제거 - 매 실행 동의 재요청 버그 수정"
```

---

## Task 3: Firebase 설정을 저장소 기준으로 정리

**Files:**
- Delete: `lib/page/settingPage/firebase_options.dart` (0바이트 빈 파일)
- Create: `lib/firebase_options.dart` (FlutterFire CLI 생성물)
- Create: `firebase.json` (FlutterFire CLI 생성물)
- Modify: `lib/main.dart:8-15`
- Modify: `.gitignore`

**문제 설명:**

지금 저장소를 클론하면 `android/app/google-services.json` 과 `ios/Runner/GoogleService-Info.plist` 가 **없어서 빌드가 실패한다.** `android/app/build.gradle` 마지막 줄의 `apply plugin: 'com.google.gms.google-services'` 가 그 파일을 요구하기 때문이다. Phase 2(CI/CD)의 전제 조건이기도 하다.

해결: FlutterFire CLI로 `lib/firebase_options.dart` 를 생성해 Dart 코드로 초기화한다. 네이티브 설정 파일은 여전히 필요하지만(Android google-services 플러그인, iOS Analytics), 그건 CI에서 시크릿으로 주입한다 — Phase 2에서 처리.

- [ ] **Step 1: FlutterFire CLI 설치 및 로그인 확인**

```bash
dart pub global activate flutterfire_cli
firebase login:list
```

`firebase login:list` 가 계정을 못 찾으면 사용자에게 아래를 직접 실행하도록 요청한다 (대화형 로그인이라 에이전트가 대신 못 함):

```
! firebase login
```

- [ ] **Step 2: firebase_options.dart 생성**

```bash
flutterfire configure \
  --project=<Firebase 프로젝트 ID> \
  --platforms=android,ios \
  --android-package-name=com.seohwalee.harmonypracticereal \
  --ios-bundle-id=<iOS 번들 ID>
```

`<Firebase 프로젝트 ID>` 와 `<iOS 번들 ID>` 를 모르면 아래로 확인한다:

```bash
firebase projects:list
grep -rn "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj | sort -u
```

이 명령은 `lib/firebase_options.dart`, `firebase.json` 을 만들고 `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist` 도 내려받는다.

- [ ] **Step 3: 생성 결과 확인**

```bash
ls -la lib/firebase_options.dart firebase.json android/app/google-services.json ios/Runner/GoogleService-Info.plist
head -20 lib/firebase_options.dart
```

기대: 4개 파일 모두 존재, `firebase_options.dart` 는 0바이트가 아니고 `class DefaultFirebaseOptions` 를 포함한다.

- [ ] **Step 4: 빈 파일 삭제**

```bash
git rm lib/page/settingPage/firebase_options.dart
grep -rn "settingPage/firebase_options" lib/
```

두 번째 명령의 기대 출력: 아무것도 없음 (`main.dart:10` 의 import는 이미 주석 처리 상태).

- [ ] **Step 5: main.dart에서 명시적 옵션으로 초기화**

`lib/main.dart` 의 8~15번째 줄 영역을 아래로 교체한다:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';

// admob banner ref : https://deku.posstree.com/ko/flutter/admob/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); // 가로모드 막기
  MobileAds.instance.initialize();
  runApp(const MyApp());
}
```

- [ ] **Step 6: .gitignore에 비밀정보 추가**

`.gitignore` 의 `# key` 섹션을 아래로 교체한다:

```
# key
/keystore
/android/key.properties
/android/app/key.properties

# Firebase - 네이티브 설정 파일은 커밋하지 않는다 (CI 시크릿으로 주입)
/android/app/google-services.json
/ios/Runner/GoogleService-Info.plist
/ios/firebase_app_id_file.json

# Fastlane
**/fastlane/report.xml
**/fastlane/Preview.html
**/fastlane/screenshots
**/fastlane/test_output
```

> `lib/firebase_options.dart` 는 **커밋한다.** 여기 들어가는 API 키는 클라이언트 식별자라 공개돼도 무방하며 (Firebase 공식 입장), 이게 커밋돼야 CI에서 Dart 빌드가 된다. 실제 보안은 Firebase 보안 규칙과 App Check으로 건다.

- [ ] **Step 7: 빌드 검증**

```bash
flutter clean && flutter pub get && flutter build apk --debug
```

기대: `✓ Built build/app/outputs/flutter-apk/app-debug.apk`

- [ ] **Step 8: 커밋**

```bash
git add lib/firebase_options.dart lib/main.dart firebase.json .gitignore
git add -u
git commit -m "chore: FlutterFire CLI 설정 도입 - firebase_options.dart로 명시적 초기화"
```

---

## Task 4: Android 툴체인 및 SDK 타깃 상향

**Files:**
- Modify: `android/gradle/wrapper/gradle-wrapper.properties`
- Modify: `android/settings.gradle`
- Modify: `android/build.gradle`
- Modify: `android/app/build.gradle`

**문제 설명:**

- `targetSdkVersion 34` — Play 콘솔이 업데이트 제출을 거부한다. 2026년 기준 요구 수준은 API 35 이상이며, 매년 8월 말 기준이 올라간다. **API 36을 목표로 한다.**
- `namespace "com.example.harmonypracticereal"` — applicationId 는 `com.seohwalee.harmonypracticereal` 인데 namespace 가 템플릿 그대로다. 생성되는 `BuildConfig` 패키지가 어긋난다.
- Gradle 7.5 + `apply plugin` 방식 — AGP 8 / Java 17 조합에서 동작하지 않는다.
- `minSdkVersion 21` — 최신 Firebase BOM 이 API 23 이상을 요구한다.
- `sourceCompatibility 1.8` — AGP 8 은 Java 17을 요구한다.

- [ ] **Step 1: Java 17 이상 사용 가능한지 확인**

```bash
java -version
flutter doctor -v 2>&1 | grep -A3 "Android toolchain"
```

기대: Java 17 이상. 아니면 진행 전에 JDK 17을 설치한다 (`brew install --cask temurin@17`).

- [ ] **Step 2: Gradle 래퍼 상향**

`android/gradle/wrapper/gradle-wrapper.properties` 의 `distributionUrl` 줄을 교체:

```
distributionUrl=https\://services.gradle.org/distributions/gradle-8.12-all.zip
```

- [ ] **Step 3: settings.gradle을 플러그인 선언 방식으로 전환**

`android/settings.gradle` 전체를 아래로 교체:

```groovy
pluginManagement {
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def flutterSdkPath = properties.getProperty("flutter.sdk")
        assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
        return flutterSdkPath
    }()

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.7.3" apply false
    id "org.jetbrains.kotlin.android" version "2.1.0" apply false
    id "com.google.gms.google-services" version "4.4.2" apply false
}

include ":app"
```

- [ ] **Step 4: 루트 build.gradle 정리**

`android/build.gradle` 전체를 아래로 교체 (buildscript 블록은 settings.gradle 로 옮겨졌으므로 삭제):

```groovy
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = "../build"
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
```

- [ ] **Step 5: 앱 build.gradle 교체**

`android/app/build.gradle` 전체를 아래로 교체:

```groovy
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    id "com.google.gms.google-services"
}

def localProperties = new Properties()
def localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader("UTF-8") { reader ->
        localProperties.load(reader)
    }
}

def flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
def flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.seohwalee.harmonypracticereal"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.seohwalee.harmonypracticereal"
        minSdk = 23
        targetSdk = 36
        versionCode = flutterVersionCode.toInteger()
        versionName = flutterVersionName
    }

    signingConfigs {
        release {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"]
                keyPassword = keystoreProperties["keyPassword"]
                storeFile = file(keystoreProperties["storeFile"])
                storePassword = keystoreProperties["storePassword"]
            }
        }
    }

    buildTypes {
        release {
            // key.properties 가 없으면 debug 키로 폴백해서 CI 빌드가 죽지 않게 한다.
            signingConfig = keystorePropertiesFile.exists()
                ? signingConfigs.release
                : signingConfigs.debug

            // 코드 난독화 및 크기 축소
            minifyEnabled = true
            shrinkResources = true
            proguardFiles getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation platform("com.google.firebase:firebase-bom:33.7.0")
    implementation "com.google.firebase:firebase-analytics"
}
```

> `key.properties` 경로가 `app/key.properties` → `key.properties` (android/ 바로 아래)로 바뀌었다. 기존 파일이 `android/app/key.properties` 에 있다면 옮긴다:
> ```bash
> [ -f android/app/key.properties ] && mv android/app/key.properties android/key.properties
> ```
> 그리고 `storeFile` 경로가 상대경로라면 한 단계 위로 바뀐 것에 맞게 수정한다. `cat android/key.properties` 로 확인.

- [ ] **Step 6: proguard 규칙 파일 존재 확인**

```bash
ls -la android/app/proguard-rules.pro
```

없으면 생성:

```bash
cat > android/app/proguard-rules.pro <<'EOF'
# Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
EOF
```

- [ ] **Step 7: Android 빌드 검증**

```bash
flutter clean && flutter pub get && flutter build appbundle --release
```

기대: `✓ Built build/app/outputs/bundle/release/app-release.aab`

에러가 나면 대부분 세 가지 중 하나다:
1. `Namespace not specified` → Step 5의 `namespace` 줄 누락
2. `Unsupported class file major version` → Java 17이 안 잡힌 것. `flutter build --verbose` 로 어떤 JDK를 쓰는지 확인
3. `File google-services.json is missing` → Task 3이 제대로 안 끝난 것

- [ ] **Step 8: targetSdk가 실제로 36으로 들어갔는지 검증**

```bash
unzip -p build/app/outputs/bundle/release/app-release.aab BUNDLE-METADATA/com.android.tools.build.gradle/app-metadata.properties 2>/dev/null || \
  grep -n "targetSdk" android/app/build.gradle
```

기대: `targetSdk = 36`

- [ ] **Step 9: 실기기/에뮬레이터 스모크 테스트**

```bash
flutter install --release
```

앱을 켜서 확인할 것:
- 로딩 화면 → 문제 유형 목록 진입
- 4개 난이도 탭(super easy / easy / hard / custom) 모두 열림
- 문제 유형 1~4 각각에서 문제 1개씩 풀어 정답/오답 바텀시트가 뜨는지
- 배너 광고 자리가 렌더되는지

- [ ] **Step 10: 커밋**

```bash
git add android/
git commit -m "build(android): AGP8/Gradle8.12/Java17 이전, targetSdk 36 상향, namespace 교정"
```

### 실행 결과 — 계획 대비 확정된 편차 (2026-08-04, 커밋 `c06a17b`)

계획에 적어둔 버전 핀은 Flutter 3.44.2에 맞지 않았다. 실제로 반영된 값과 근거:

| | 계획 | 실제 | 근거 |
|---|---|---|---|
| Gradle | 8.12 | **8.14.3** | Flutter 3.44.2 `DependencyVersionChecker.kt` 의 `warnGradleVersion = 8.14.0` |
| AGP | 8.7.3 | **8.11.1** | `warnAGPVersion = 8.11.1`. 또한 8.7.3 은 SDK 36 컴파일 불가 |
| Kotlin | 2.1.0 | **2.2.20** | `warnKGPVersion = 2.2.20` |
| minSdk | 23 | **`flutter.minSdkVersion` (= 24)** | 아래 참조 |

**minSdk 는 제품 결정이다 — 승인 후 확정.** `minSdk 21 → 24` 로 올라가 **Android 5.0 / 5.1 / 6.0 (API 21~23) 기기가 탈락**한다.

정확한 사정은 이렇다. `errorMinSdkVersion = 23` 은 **비포함(non-inclusive)** 비교(`version < 23`)라, `minSdk = 23` 자체는 오류가 아니라 경고만 난다. 진짜 걸림돌은 Flutter 의 자동 마이그레이터다 — `gradle_utils.dart` 의 정규식 `(?<=^\s*)minSdk(Version)?\s*=\s*(1[6789]|2[0123])(?=\s*(?://|$))` 이 리터럴 `23` 을 잡아 매 빌드마다 `flutter.minSdkVersion` 으로 되돌린다. 즉 23 을 고정하려면 빌드할 때마다 툴체인과 싸워야 한다.

API 21~23 의 2026년 잔존 점유율은 합쳐도 1% 미만이고, 대안(마이그레이터 우회)은 매 빌드 깨질 수 있는 편법이다. **24 로 간다.** Play 콘솔 업로드 시 "지원 기기 수 감소"가 표시되는 것은 예상된 결과다.

**계획에 없었지만 빌드에 반드시 필요했던 변경 4건** (사양 리뷰에서 전부 "필요함"으로 확인):

1. `async_preferences 0.9.0 → 2.0.0` — 0.9.0 이 제거된 v1 임베딩(`PluginRegistry.Registrar`)을 참조해 컴파일 불가. 공개 Dart API 와 네이티브 null 처리가 동일함을 확인해 GDPR 동작 변화 없음.
2. `shared_preferences_android`, `webview_flutter_android` 전이 의존성 상승 — 1번의 리졸버 결과이며 손으로 고친 것이 아니다. 두 구버전 모두 같은 v1 임베딩 벽에 걸린다.
3. `AndroidManifest.xml` 에 `tools:replace` 추가 — Firebase Analytics 와 AdMob 이 둘 다 `AD_SERVICES_CONFIG` 를 선언해 매니페스트 병합 실패. GMA 설정이 Analytics 설정의 상위집합(attribution + topics)이라 GMA 를 채택하는 것이 옳은 방향.
4. `MainActivity.kt` 를 `com/example/` → `com/seohwalee/` 로 이동 — 매니페스트의 `android:name=".MainActivity"` 는 `namespace` 기준으로 해석된다. namespace 만 고치고 클래스를 안 옮기면 **빌드는 되고 실행 시 죽는다.** 병합된 릴리스 매니페스트에서 `com.seohwalee.harmonypracticereal.MainActivity` 로 해석되는 것을 확인했다.

**Phase 2 CI 에 영향:** `pubspec.lock` 의 SDK 하한이 `dart: >=3.12.0` / `flutter: >=3.44.0` 으로 올라갔다. CI 워크플로의 `FLUTTER_VERSION` 은 **3.44 이상**이어야 한다.

### 실기기 스모크 테스트 결과 (2026-08-04)

**기기:** Galaxy Z Fold (SM-F966N), **Android 16 / API 36** — targetSdk 36 을 그 버전에서 직접 검증.
**대상:** 코드리뷰 지적사항까지 반영한 `a20af6d` 빌드.

| 항목 | 결과 |
|---|---|
| 설치 패키지 속성 | `targetSdk=36 minSdk=24 versionCode=16` |
| 앱 실행 | 크래시 없음. `topResumedActivity=com.seohwalee.harmonypracticereal/.MainActivity` — **namespace 이동이 옳았음이 실증됨** |
| 홈 화면 · 탭 4개 | 정상 (Easy/Medium/Hard/Custom, 색상 포함) |
| 오선보 렌더링 | 정상 (E major 샤프, F minor·C minor 플랫 포함) |
| 보기 버튼 생성 | 정상 |
| 정답/오답 바텀시트 | 정상 |
| 문제 진행 | 1/10 → 2/10 정상 |
| **배너 광고** | 표시됨. logcat 에 `I/flutter: Ad loaded.` |
| Firebase / AdMob 네이티브 | `measurement.dynamite`, `ads.dynamite` 둘 다 로드 |
| 강제종료 후 재실행 | GDPR 동의창 **재요청 없음** — Task 2 검증 완료 |

**R8 full mode 는 문제없다.** 이 테스트는 proguard 규칙을 축소하고 Firebase 를 BOM 32.7.3 으로 되돌린 **이후** 빌드에 대한 것이다. 문제가 생기면 `android/gradle.properties` 에 `android.enableR8.fullMode=false`.

미확인으로 남은 것: **전면광고**(20문제를 풀어야 뜬다), **iOS 실기기 동작**(Task 5 의 UIScene 마이그레이션 영향).

관찰된 무해한 로그: `Decoder init failed: c2.qti.vp9.decoder` — 구글 광고 모듈이 특정 VP9 동영상 광고를 이 기기 코덱으로 디코딩하지 못한 것. `com.google.android.gms.policy_ads_fdr_dynamite` 내부에서 발생하며 앱 코드와 무관하고, 배너는 정상 표시됐다.

---

## Task 5: iOS 배포 타깃 상향 및 Pod 재생성

**Files:**
- Modify: `ios/Podfile:2`
- Modify: `ios/Runner.xcodeproj/project.pbxproj` (`IPHONEOS_DEPLOYMENT_TARGET`)
- Modify: `ios/Podfile` (post_install 훅)

**문제 설명:** 현재 `IPHONEOS_DEPLOYMENT_TARGET = 13.0`, `platform :ios, '13.0'`. 최신 Firebase iOS SDK와 Google Mobile Ads SDK는 iOS 15.0 이상을 요구한다. 올리지 않으면 Task 6의 의존성 업그레이드가 CocoaPods 단계에서 실패한다.

- [ ] **Step 1: 현재 값 확인**

```bash
grep -n "platform :ios" ios/Podfile
grep -c "IPHONEOS_DEPLOYMENT_TARGET = 13.0" ios/Runner.xcodeproj/project.pbxproj
```

기대: `platform :ios, '13.0'` 과 3개 내외의 13.0 항목 (Debug/Release/Profile).

- [ ] **Step 2: Podfile 플랫폼 상향**

`ios/Podfile` 의 2번째 줄을 교체:

```ruby
platform :ios, '15.0'
```

- [ ] **Step 3: Podfile post_install 훅에 배포 타깃 강제 적용**

`ios/Podfile` 의 `post_install` 블록을 찾아 아래로 교체한다 (없으면 파일 맨 끝에 추가):

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      # AdMob/ATT 를 쓰므로 추적 권한 관련 심볼을 유지한다.
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_APP_TRACKING_TRANSPARENCY=1',
      ]
    end
  end
end
```

- [ ] **Step 4: Xcode 프로젝트 배포 타깃 일괄 치환**

```bash
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = 13.0;/IPHONEOS_DEPLOYMENT_TARGET = 15.0;/g' ios/Runner.xcodeproj/project.pbxproj
grep -c "IPHONEOS_DEPLOYMENT_TARGET = 15.0" ios/Runner.xcodeproj/project.pbxproj
```

기대: Step 1에서 센 것과 같은 개수가 15.0으로 나온다. `13.0` 이 하나도 남지 않았는지 확인:

```bash
grep -n "IPHONEOS_DEPLOYMENT_TARGET = 13" ios/Runner.xcodeproj/project.pbxproj
```

기대 출력: 없음.

- [ ] **Step 5: Pod 재설치**

```bash
cd ios && rm -rf Pods Podfile.lock && pod install --repo-update && cd ..
```

기대: `Pod installation complete!`

- [ ] **Step 6: iOS 빌드 검증 (서명 없이)**

```bash
flutter build ios --release --no-codesign
```

기대: `✓ Built build/ios/iphoneos/Runner.app`

- [ ] **Step 7: 커밋**

```bash
git add ios/
git commit -m "build(ios): 배포 타깃 15.0 상향 및 Podfile post_install 정비"
```

---

## Task 6: 의존성 메이저 업그레이드

**Files:**
- Modify: `pubspec.yaml`
- Modify: `analysis_options.yaml`
- Modify: `lib/main.dart:66` (deprecated `textScaleFactor`)
- Modify: `lib/page/problemFunc/resultPage.dart:67` (deprecated `withOpacity`)
- Modify: `lib/page/problemFunc/problemFuncDeco.dart:210` (deprecated `Tooltip.height`)

**주의:** 이 태스크는 한 번에 다 올리지 않는다. **그룹별로 올리고 매번 테스트를 돌린다.** 특히 `music_notes` 는 화성 로직의 핵심이라 breaking change 가 정답 문자열을 바꿀 수 있다.

- [ ] **Step 1: 현재 뒤처진 정도 파악**

```bash
flutter pub outdated
```

출력의 `Resolvable` / `Latest` 열을 기록한다. 이 계획에 적힌 버전과 다르면 **실제 출력값을 우선한다.**

- [ ] **Step 2: 그룹 A — 위험 낮은 의존성 먼저**

`pubspec.yaml` 의 해당 줄들을 교체:

```yaml
  cupertino_icons: ^1.0.8
  flutter_screenutil: ^5.9.3
  auto_size_text: ^3.0.0
  provider: ^6.1.5
  lottie: ^3.3.1
  percent_indicator: ^4.2.5
  numerus: ^2.2.0
  shared_preferences: ^2.5.5
```

그리고 `dependency_overrides` 블록 전체를 삭제한다:

```yaml
# 아래 블록을 통째로 지운다
dependency_overrides:
  archive: ^3.6.1
  win32: ^5.5.3
```

(이 override 들은 오래된 의존성 트리를 억지로 맞추려던 것이다. 메이저 업그레이드 후에는 불필요하며, 남아 있으면 오히려 해석 충돌을 일으킨다.)

- [ ] **Step 3: 그룹 A 검증**

```bash
flutter pub get && flutter analyze 2>&1 | tail -3 && flutter test
```

기대: analyze error 0, 모든 테스트 PASS.
`dependency_overrides` 삭제 후 해석이 실패하면 그 패키지 이름을 기록하고 override 를 하나씩만 되살린다 — 전부 되살리지 않는다.

- [ ] **Step 4: 그룹 A 커밋**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore(deps): UI/저장소 계열 의존성 상향 및 dependency_overrides 제거"
```

- [ ] **Step 5: 그룹 B — music_notes (화성 로직 핵심)**

`pubspec.yaml`:

```yaml
  music_notes: ^0.20.0
```

> 정확한 최신 버전은 Step 1의 `flutter pub outdated` 출력을 따른다. 0.13 → 최신은 여러 메이저(0.x는 minor가 breaking)를 건너뛰므로 **반드시 한 단계씩 올린다:** 0.13 → 0.14 → 0.15 → ... 매 단계마다 Step 6을 반복한다.

- [ ] **Step 6: 그룹 B 검증 — 여기가 이 계획에서 가장 중요한 검증 지점**

```bash
flutter pub get && flutter analyze 2>&1 | tail -3 && flutter test test/harmony/
```

기대: analyze error 0, Task 1의 불변식 테스트 전부 PASS.

**테스트가 깨지면 그 버전에서 멈춘다.** `music_notes` 의 CHANGELOG 를 읽고 무엇이 바뀌었는지 확인한다:

```bash
find ~/.pub-cache/hosted/pub.dev -maxdepth 1 -name "music_notes-*" -exec cat {}/CHANGELOG.md \; | head -60
```

깨진 API를 고칠 수 없다고 판단되면 **직전 통과 버전에 고정하고 넘어간다.** `music_notes` 최신화는 이 계획의 필수 목표가 아니다 — Android/iOS 출시 복구가 목표다. pubspec에 이유를 주석으로 남긴다:

```yaml
  # 0.14.0 부터 Note.transposeBySize 시그니처가 변경되어 정답 산출이 깨짐.
  # Phase 3 리팩토링에서 대응 예정.
  music_notes: 0.13.0
```

- [ ] **Step 7: 그룹 B 커밋**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore(deps): music_notes 상향 (불변식 테스트 통과 확인)"
```

- [ ] **Step 8: 그룹 C — Firebase / AdMob (네이티브 연동)**

`pubspec.yaml`:

```yaml
  firebase_core: ^3.10.0
  firebase_analytics: ^11.4.0
  google_mobile_ads: ^5.3.1
  app_tracking_transparency: ^2.0.6
```

> `firebase_core` 3.x 는 `firebase_analytics` 11.x 와 짝이다. 버전 짝이 안 맞으면 `flutter pub get` 이 해석 실패로 알려준다.
> `google_mobile_ads` 는 메이저 업그레이드 시 UMP API가 자주 바뀌므로 **6.x가 아니라 5.x 최신부터 시도**한다.

- [ ] **Step 9: 그룹 C 검증**

```bash
flutter pub get && flutter analyze 2>&1 | tail -5
```

analyze 에 error 가 뜨면 대부분 `initialization_helper.dart` 의 UMP API 변경이다. `ConsentRequestParameters`, `ConsentForm.loadConsentForm`, `ConsentInformation.instance` 시그니처를 패키지 예제와 대조해 고친다:

```bash
find ~/.pub-cache/hosted/pub.dev -maxdepth 1 -name "google_mobile_ads-*" -exec cat {}/CHANGELOG.md \; | head -80
```

- [ ] **Step 10: 그룹 C 네이티브 빌드 검증 (양 플랫폼)**

```bash
flutter clean && flutter pub get
flutter build appbundle --release
cd ios && pod install --repo-update && cd ..
flutter build ios --release --no-codesign
```

기대: 양쪽 다 성공.

- [ ] **Step 11: 그룹 C 커밋**

```bash
git add pubspec.yaml pubspec.lock ios/Podfile.lock lib/
git commit -m "chore(deps): Firebase/AdMob SDK 상향 및 UMP API 대응"
```

- [ ] **Step 12: 그룹 D — 린트 규칙 현대화**

`pubspec.yaml` 의 dev_dependencies:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

`analysis_options.yaml` 전체를 아래로 교체:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  errors:
    # 파일명 규칙 위반은 Phase 3에서 일괄 개명하므로 지금은 경고로만 둔다.
    file_names: ignore
    # 기존 코드에 camelCase 아닌 식별자가 다수 있다. Phase 3에서 정리.
    non_constant_identifier_names: warning
    # deprecated 사용은 반드시 잡아야 한다 (다음 SDK에서 컴파일 실패로 이어짐).
    deprecated_member_use: warning
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "lib/firebase_options.dart"

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - avoid_print
    - use_build_context_synchronously
```

- [ ] **Step 13: deprecated API 3곳 수정**

`lib/main.dart` 의 `builder` 콜백을 교체 (`textScaleFactor` 는 제거 예정 API):

```dart
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.noScaling),
              child: child!,
            );
          },
```

`lib/page/problemFunc/resultPage.dart:67` 의 `withOpacity` 호출을 찾아 교체한다. 현재 형태를 먼저 확인:

```bash
sed -n '67p' lib/page/problemFunc/resultPage.dart
```

`.withOpacity(X)` 를 `.withValues(alpha: X)` 로 바꾼다. 예:
```dart
// 변경 전: Colors.black.withOpacity(0.5)
// 변경 후: Colors.black.withValues(alpha: 0.5)
```

`lib/page/problemFunc/problemFuncDeco.dart:210` 의 `Tooltip(height: X)` 를 찾아 교체:

```bash
sed -n '205,215p' lib/page/problemFunc/problemFuncDeco.dart
```

```dart
// 변경 전: height: X,
// 변경 후: constraints: BoxConstraints(minHeight: X),
```

- [ ] **Step 14: 그룹 D 검증**

```bash
flutter pub get && flutter analyze 2>&1 | tail -5 && flutter test
```

기대: error 0, 테스트 PASS. `deprecated_member_use` 경고 개수가 Step 0-1 기준선보다 줄어야 한다.

- [ ] **Step 15: 그룹 D 커밋**

```bash
git add pubspec.yaml pubspec.lock analysis_options.yaml lib/
git commit -m "chore: flutter_lints 6 도입 및 deprecated API 제거"
```

---

## Task 7: 버전 올리고 최종 검증

**Files:**
- Modify: `pubspec.yaml:20`
- Modify: `README.md`

- [ ] **Step 1: 버전 상향**

`pubspec.yaml` 의 version 줄을 교체:

```yaml
version: 1.2.0+17
```

(Play 콘솔의 현재 최신 versionCode 를 먼저 확인하고, 그보다 큰 값을 쓴다. 저장소 기준 마지막이 `+16` 이므로 `+17`.)

- [ ] **Step 2: README를 실제 프로젝트 설명으로 교체**

`README.md` 전체를 아래로 교체:

```markdown
# 화성 박사 (Harmony Practice)

화성학 문제 풀이 연습 앱. 주어진 조성과 4성부 음 배치를 보고 로마숫자 화음 기호를 맞힌다.

## 다루는 개념

3화음 · 속7화음 · 부속7화음 · 부7화음 · 감7화음 · 부감7화음 · 반감7화음 · 부반감7화음 ·
나폴리화음 · 증6화음(It/Fr/Gr) · 차용화음 — 장조/단조 모두 지원.

## 문제 유형

| 유형 | 내용 |
|---|---|
| Type 1 | 화음 기호 구성요소를 직접 선택 |
| Type 2 | 음정 판별 |
| Type 3 | 화음 기호 객관식 |
| Type 4 | 화음 → 음 배치 |

난이도: super easy / easy / hard / custom(직접 선택)

## 개발 환경

- Flutter 3.44.2 이상 / Dart 3.12 이상
- JDK 17
- Android: compileSdk 36 / minSdk 23
- iOS: 15.0 이상

## 처음 세팅

```bash
flutter pub get

# Firebase 네이티브 설정 파일 내려받기 (git에 없음)
dart pub global activate flutterfire_cli
flutterfire configure
```

Android 릴리스 서명이 필요하면 `android/key.properties` 를 만든다:

```properties
storePassword=...
keyPassword=...
keyAlias=...
storeFile=../../keystore/<파일명>.jks
```

## 자주 쓰는 명령

```bash
flutter analyze          # 정적 분석 (error 0 유지)
flutter test             # 화성 엔진 불변식 테스트 포함
flutter build appbundle --release
flutter build ipa --release
```

## 디렉터리 구조

```
lib/
  harmonyModul/    화성 문제 생성 엔진 (순수 Dart, 테스트 대상)
  page/
    problem/       문제 유형 1~4 화면
    problemFunc/   악보 렌더링·정답 판정·광고 위젯
    settingPage/   설정 및 GDPR 동의
```

© 2024 seohwa lee
```

- [ ] **Step 3: 전체 검증 일괄 실행**

```bash
flutter clean
flutter pub get
flutter analyze 2>&1 | tail -3
flutter test
flutter build appbundle --release
cd ios && pod install && cd ..
flutter build ios --release --no-codesign
```

기대 — 이 5가지가 모두 참이어야 이 단계가 끝난 것이다:
1. analyze: **error 0**
2. test: **전부 PASS**
3. `build/app/outputs/bundle/release/app-release.aab` 생성됨
4. `build/ios/iphoneos/Runner.app` 생성됨
5. `grep "targetSdk" android/app/build.gradle` → `36`

- [ ] **Step 4: 실기기 스모크 테스트 (Android + iOS 각각)**

Task 4 Step 9와 같은 항목을 두 플랫폼에서 확인한다. 추가로:
- 앱 재실행 시 GDPR 팝업이 반복되지 않음 (Task 2 검증)
- custom 탭에서 화음 종류 선택 후 "전체 선택/해제" 버튼 동작 (최근 커밋 `7bb9a79` 기능)

- [ ] **Step 5: 커밋**

```bash
git add pubspec.yaml README.md
git commit -m "chore: 1.2.0+17 버전 상향 및 README 현행화"
```

- [ ] **Step 6: 병합**

```bash
git checkout main
git merge --no-ff phase1/build-release-recovery
```

---

## 완료 기준

이 단계가 끝나면 다음이 모두 참이다:

- [ ] `flutter analyze` error 0
- [ ] `flutter test` 전부 통과 (화성 엔진 불변식 테스트 존재)
- [ ] `flutter build appbundle --release` 성공, targetSdk 36
- [ ] `flutter build ios --release --no-codesign` 성공, 배포 타깃 15.0
- [ ] 저장소를 새로 클론 → `flutterfire configure` → 즉시 빌드 가능
- [ ] GDPR 동의창이 매 실행 반복되지 않음
- [ ] `dependency_overrides` 없음

**다음 단계:** `2026-08-03-phase2-cicd.md`
