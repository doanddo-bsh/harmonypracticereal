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
- Android: `applicationId`/`namespace` `com.seohwalee.harmonypracticereal`, compileSdk/targetSdk 36, minSdk 24
- iOS: 배포 타깃 15.0. Swift Package Manager로 이전 완료 — CocoaPods로 남아 있는 건 Flutter 자체 pod 하나뿐이라 `pod install`은 여전히 필요하다.
  번들 ID는 `com.example.harmonypracticereal`로, 템플릿 기본값처럼 보이지만 실제로 App Store에 게시된 ID다. 바꾸지 않는다.

## 처음 세팅

```bash
flutter pub get

# Firebase 네이티브 설정 파일 내려받기 (git에 없음)
dart pub global activate flutterfire_cli
flutterfire configure
```

Android 릴리스 서명이 필요하면 `android/key.properties`를 만든다 (`android/app/`이 아니라 `android/` 바로 아래):

```properties
storePassword=...
keyPassword=...
keyAlias=...
storeFile=../../keystore/<파일명>.jks
```

파일이 없으면 릴리스 빌드는 디버그 키로 자동 폴백한다 (빌드는 되지만 Play에 올릴 수 없다).

iOS 빌드 전에는 CocoaPods 설치가 한 번 필요하다:

```bash
cd ios && pod install && cd ..
```

## 자주 쓰는 명령

```bash
flutter analyze          # 정적 분석 (error 0 유지)
flutter test             # 화성 엔진 불변식 테스트 포함
flutter build appbundle --release
flutter build ios --release --no-codesign
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
