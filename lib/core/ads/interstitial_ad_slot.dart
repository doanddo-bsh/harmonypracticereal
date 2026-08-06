import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:harmonypracticereal/core/ads/ad_ids.dart';
import 'package:harmonypracticereal/core/ads/interstitial_trigger.dart';

/// 전면 광고 한 자리.
///
/// 전면 광고 하나의 수명주기(적재 · 표시 · 해제)를 이 객체가 통째로 쥔다.
/// 화면 쪽에서는 [InterstitialAdSlot] 을 하나 들고 `dispose()` 에서
/// [dispose] 만 불러 주면 되고, `InterstitialAd` 인스턴스를 직접 만질 일이
/// 없다.
///
/// 예전에는 문제 화면 4종과 홈 화면의 목록 4종이 각자 똑같은 `loadAd()` 를
/// 복제해 갖고 있었고(8벌), 어느 화면도 `State.dispose()` 에서 적재해 둔
/// 광고를 해제하지 않았다. 표시된 광고만 `onAdDismissedFullScreenContent`
/// 에서 해제됐으므로, **적재만 되고 끝내 표시되지 않은 광고**(화면을 떠나
/// 버린 경우, 기준을 넘겨 두 번 적재한 경우)는 그대로 남았다. 배너에서
/// 똑같이 겪은 누수(B2)를 전면 광고에서 반복하지 않도록, 생성자를 한 곳으로
/// 모으고 그 자리에서 모든 경로를 해제한다.
///
/// 해제 책임은 네 갈래뿐이고 전부 이 파일 안에 있다:
///
/// 1. 표시된 광고 — `onAdDismissedFullScreenContent` /
///    `onAdFailedToShowFullScreenContent` (구글 권장 지점).
/// 2. 표시되기 전에 다음 적재분이 도착한 광고 — [_keep] 에서 교체 직전.
/// 3. 슬롯이 죽은 뒤에 도착한 광고 — [_keep] 에서 즉시.
/// 4. 아직 표시되지 않은 채 화면이 닫힐 때 남은 광고 — [dispose].
///
/// AdMob 을 붙일 수 없는 환경(Android/iOS 가 아닌 곳, 위젯 테스트)에서는
/// 광고를 아예 만들지 않는다. [BannerAdSlot](banner_ad_slot.dart) 과 같은
/// 규칙이다.
class InterstitialAdSlot {
  InterstitialAd? _ad;
  bool _isDisposed = false;

  /// 지금 당장 띄울 수 있는 광고를 쥐고 있는가.
  ///
  /// 적재가 비동기라 [load] 직후에는 거의 항상 false 다. 테스트와 디버깅용.
  bool get hasAdReady => _ad != null;

  /// 다음에 띄울 광고를 적재한다.
  ///
  /// 비동기다. 이 호출이 돌아온 시점에는 [hasAdReady] 가 아직 false 다.
  void load() {
    if (_isDisposed) return;
    // Android/iOS 가 아니면 AdMob 네이티브 채널이 없다. 예전에는 단위 ID 가
    // null 이라 `!` 에서 죽었다. 그 보호막을 명시적인 가드로 옮긴다.
    if (!AdIds.adsAvailable) return;

    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: _keep,
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  /// 적재가 끝난 광고를 받아 다음 [showIfLoaded] 때까지 쥐고 있는다.
  void _keep(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      // 표시된 광고의 해제 지점. 둘 중 하나는 반드시 불린다.
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('InterstitialAd failed to show: $error');
        ad.dispose();
      },
      onAdDismissedFullScreenContent: (ad) => ad.dispose(),
    );

    debugPrint('$ad loaded.');

    if (_isDisposed) {
      // 화면이 이미 닫혔다. 여기서 놓으면 네이티브 객체가 그대로 남는다.
      ad.dispose();
      return;
    }

    // 아직 못 띄운 이전 적재분이 있으면 여기서 놓아 준다. 참조만 덮어쓰면
    // 그 광고를 해제할 수 있는 마지막 손잡이가 사라진다.
    _ad?.dispose();
    _ad = ad;
  }

  /// 쥐고 있는 광고가 있으면 띄우고 true 를 돌려준다. 없으면 아무것도 하지
  /// 않고 false.
  ///
  /// 띄운 광고의 해제는 [_keep] 이 달아 둔 전체화면 콜백이 맡으므로 여기서
  /// 참조를 놓는다(같은 광고를 두 번 띄우지 않기 위해서이기도 하다).
  bool showIfLoaded() {
    final ad = _ad;
    if (ad == null) return false;

    _ad = null;
    ad.show();
    return true;
  }

  /// 지금이 띄울 때면 **다음** 광고를 적재하고, **지난번** 적재분이 있으면
  /// 띄운다. 실제로 띄웠으면 true.
  ///
  /// 순서가 핵심이고 이건 종전 화면 코드의 동작 그대로다. [load] 가
  /// 비동기라 방금 부른 적재는 이 자리에서 끝나 있지 않다 — 그래서 실제로
  /// 뜨는 것은 언제나 **지난번에 적재해 둔** 광고다. 호출부가 누적 풀이 수를
  /// 되돌리는 것도 실제로 띄웠을 때(=true)뿐이어야 한다. 이걸 "고쳐서"
  /// 적재를 기다렸다 바로 띄우게 만들면 광고가 뜨는 빈도가 달라진다.
  ///
  /// [solvedProblemCount] 는 앱 전체 누적 풀이 수다
  /// (`shouldShowInterstitial` 참고).
  bool loadAndMaybeShow(int solvedProblemCount) {
    if (!shouldShowInterstitial(solvedProblemCount)) return false;

    load();
    return showIfLoaded();
  }

  /// 화면이 닫힐 때 부른다. 이후의 [load] 는 무시되고, 뒤늦게 도착하는
  /// 적재분도 [_keep] 에서 바로 해제된다.
  ///
  /// 여러 번 불려도 안전하다.
  void dispose() {
    _isDisposed = true;
    _ad?.dispose();
    _ad = null;
  }
}
