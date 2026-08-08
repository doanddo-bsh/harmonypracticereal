import 'dart:io';

import 'package:flutter/foundation.dart';

/// 광고 단위 ID.
///
/// 실전 ID 는 빌드 시점에 `--dart-define` 으로 주입한다. 주입되지 않으면
/// 구글 공식 테스트 ID 로 폴백한다.
///
/// **폴백 방향이 이 파일의 핵심이다.** 예전에는 `kReleaseMode` 하나로
/// 테스트/실전을 갈랐기 때문에, QA 용으로 만든 릴리스 빌드가 실제 광고를
/// 띄우고 노출을 찍었다(무효 트래픽 위험). 이제는 릴리스 빌드라도 ID 가
/// 주입되지 않았으면 테스트 광고가 뜬다 — 실수의 결과가 "광고가 안 나간다"
/// 쪽이지 "남의 계정에 가짜 노출이 찍힌다" 쪽이 아니게 만든다.
///
/// 실전 빌드는 `.github/workflows/release-android.yml` 이 GitHub Secrets 에서
/// 값을 주입한다. 로컬에서 실전 광고를 확인하려면 직접 넘긴다:
///
/// ```
/// flutter build appbundle --release \
///   --dart-define=ADMOB_BANNER_ANDROID=ca-app-pub-XXXX/YYYY \
///   --dart-define=ADMOB_INTERSTITIAL_ANDROID=ca-app-pub-XXXX/ZZZZ
/// ```
class AdIds {
  AdIds._();

  /// 구글 공식 테스트 단위 ID.
  /// https://developers.google.com/admob/flutter/test-ads
  ///
  /// 테스트에서 폴백 값을 문자열로 다시 적지 않도록 공개해 둔다.
  static const testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const testBannerIos = 'ca-app-pub-3940256099942544/2934735716';
  static const testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const testInterstitialIos = 'ca-app-pub-3940256099942544/4411468910';

  // 미주입 시 빈 문자열. 빈 문자열 = "실전 ID 없음" 이다.
  static const _bannerAndroid = String.fromEnvironment('ADMOB_BANNER_ANDROID');
  static const _bannerIos = String.fromEnvironment('ADMOB_BANNER_IOS');
  static const _interstitialAndroid = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_ANDROID',
  );
  static const _interstitialIos = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_IOS',
  );

  /// AdMob 네이티브 플러그인과 실제로 통신할 수 있는 환경인지.
  ///
  /// `dart:io` 의 [Platform] 은 "지금 어느 OS 위에서 진짜로 돌고 있는가"를
  /// 답한다. [defaultTargetPlatform] 을 쓰지 않는 이유가 여기 있다 — 그쪽은
  /// 위젯 테스트에서 `TargetPlatform.android` 로 덮어써지므로, 채널이 없는
  /// 테스트 환경에서 광고 객체를 만들려 들게 된다. 예전 코드가 광고 단위 ID
  /// 를 `null` 로 돌려주어 얻던 보호막을 이 플래그가 그대로 이어받는다.
  static bool get adsAvailable => Platform.isAndroid || Platform.isIOS;

  /// 이 빌드가 실제로 서 있는 플랫폼.
  ///
  /// [adsAvailable] 과 같은 출처(`dart:io`)를 쓴다. 게이트와 ID 선택이 서로
  /// 다른 플랫폼 판정을 보면 둘이 어긋날 여지가 생긴다.
  static TargetPlatform get _platform =>
      Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android;

  /// 지금 플랫폼의 배너 단위 ID. 절대 비지 않는다.
  static String get banner => bannerFor(_platform);

  /// 지금 플랫폼의 전면 광고 단위 ID. 절대 비지 않는다.
  static String get interstitial => interstitialFor(_platform);

  /// [platform] 의 배너 단위 ID.
  ///
  /// 순수 함수라 양쪽 분기를 호스트 OS 와 무관하게 테스트할 수 있다.
  /// iOS 가 아닌 값은 전부 Android 로 취급한다 — [adsAvailable] 이 그 둘만
  /// 통과시키므로 다른 값으로 불릴 일이 실행 경로에는 없다.
  static String bannerFor(TargetPlatform platform) =>
      platform == TargetPlatform.iOS
      ? _injectedOr(_bannerIos, testBannerIos)
      : _injectedOr(_bannerAndroid, testBannerAndroid);

  /// [platform] 의 전면 광고 단위 ID. [bannerFor] 와 같은 규칙을 따른다.
  static String interstitialFor(TargetPlatform platform) =>
      platform == TargetPlatform.iOS
      ? _injectedOr(_interstitialIos, testInterstitialIos)
      : _injectedOr(_interstitialAndroid, testInterstitialAndroid);

  static String _injectedOr(String injected, String testId) =>
      injected.isEmpty ? testId : injected;
}
