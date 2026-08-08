# 릴리스 절차

## 자동화 범위

| 트리거 | 워크플로 | 결과 |
|---|---|---|
| 모든 브랜치 push / master 대상 PR | `ci.yml` | analyze + test + 양 플랫폼 빌드 검증 (디버그/미서명) |
| `v*.*.*` 태그 push | `release-android.yml` | Play 내부 테스트 트랙에 초안 업로드 |
| 수동 | `android/fastlane` 의 `promote_to_production` | 내부 테스트 → 프로덕션 단계 출시 |

iOS 릴리스 워크플로는 아직 없다. TestFlight 업로드는 로컬에서 수동으로 한다.

## 릴리스하기

1. `pubspec.yaml` 의 version 을 올린다. **빌드 번호(`+N`)는 반드시 증가**시킨다.
2. 커밋하고 master 에 병합한다.
3. 태그를 만들어 푸시한다 (`git tag v1.2.1 && git push origin v1.2.1`).
   태그 이름과 `pubspec.yaml` 의 버전이 다르면 워크플로가 중단된다.
4. Actions 탭에서 릴리스 워크플로를 확인한다.
5. Play 콘솔에서 초안 릴리스를 검토하고 "출시 시작"을 누른다.

## GitHub Secrets 목록

저장소와 Actions 로그는 public 이다. 워크플로에서 시크릿은 반드시 `env:` 로
받아 쓰고, `run:` 본문이나 명령줄에 값을 직접 적지 않는다.

### 공통
- `GOOGLE_SERVICES_JSON` — `android/app/google-services.json` (base64)
- `GOOGLE_SERVICE_INFO_PLIST` — `ios/Runner/GoogleService-Info.plist` (base64)

### Android
- `ANDROID_KEYSTORE_BASE64` — 릴리스 키스토어 `.jks` (base64)
- `ANDROID_KEY_PROPERTIES` — `key.properties` 내용 (base64).
  `storeFile` 은 러너 경로(`/home/runner/work/_temp/release.jks`)여야 한다
- `PLAY_STORE_JSON_KEY` — Play Developer API 서비스 계정 JSON (원문)

### AdMob (실전 광고 단위 ID)
- `ADMOB_BANNER_ANDROID`
- `ADMOB_BANNER_IOS`
- `ADMOB_INTERSTITIAL_ANDROID`
- `ADMOB_INTERSTITIAL_IOS`

광고 단위 ID 는 비밀은 아니지만 소스에 두지 않는다. **주입되지 않으면 앱은
릴리스 빌드라도 구글 테스트 광고를 표시한다** — QA 용 릴리스 빌드가 실전
노출을 찍어 무효 트래픽으로 걸리는 것을 막기 위해 폴백 방향을 그렇게 잡았다
(`lib/core/ads/ad_ids.dart`).

뒤집어 말하면 **스토어에 올라갈 빌드에 이 값이 빠지면 광고 수익이 0 이 된다.**
`release-android.yml` 은 그래서 시크릿이 없으면 빌드를 실패시키고, 빌드 후에는
AAB 안에 실제로 그 문자열이 들어갔는지까지 확인한다.

로컬에서 실전 광고를 확인하려면 직접 넘긴다:

```bash
flutter build appbundle --release \
  --dart-define=ADMOB_BANNER_ANDROID=... \
  --dart-define=ADMOB_INTERSTITIAL_ANDROID=...
```

iOS 는 `ADMOB_BANNER_IOS` / `ADMOB_INTERSTITIAL_IOS` 를 같은 방식으로 넘긴다.
iOS 릴리스 워크플로가 생기기 전까지, 손으로 만든 iOS 빌드에 이 두 값을 빼먹지
않도록 주의한다.

## 로컬에서 릴리스 빌드 재현

```bash
flutter clean && flutter pub get
flutter build appbundle --release          # Android (테스트 광고)
cd ios && pod install && cd ..
flutter build ipa --release                # iOS (서명 필요)
```

`android/key.properties` 가 없으면 릴리스 빌드는 **조용히 디버그 키로** 서명된다.
그 AAB 는 Play 가 거부한다. CI 는 이를 잡으려고 빌드 후 서명자 SHA1 을 검증한다.
