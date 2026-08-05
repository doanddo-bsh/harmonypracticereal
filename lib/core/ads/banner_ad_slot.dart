import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:harmonypracticereal/core/ads/ad_ids.dart';

/// 배너 광고 자리.
///
/// 배너 하나의 수명주기(생성 · 표시 · 해제)를 이 위젯이 통째로 쥔다.
/// 화면 쪽에서는 `const BannerAdSlot()` 한 줄만 놓으면 되고, `BannerAd`
/// 인스턴스를 직접 들고 있을 필요가 없다.
///
/// 예전에는 문제 화면 4종과 홈 화면이 각자 `initState` 에서 `BannerAd` 를
/// 만들기만 하고 `dispose()` 를 오버라이드하지 않아, 화면을 드나들 때마다
/// 네이티브 광고 객체가 해제되지 않고 쌓였다(B2). 생성자를 한 곳으로 모아
/// 그 자리에서 바로 해제하도록 해 구조적으로 다시 새지 않게 한다.
///
/// AdMob 을 붙일 수 없는 환경(Android/iOS 가 아닌 곳, 위젯 테스트)에서는
/// 광고를 만들지 않고 같은 크기의 빈 자리만 남긴다. 광고 유무에 따라 화면이
/// 흔들리지 않도록 기존 화면들과 동일하게 항상 배너 크기를 차지한다.
class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({super.key});

  /// 광고가 붙지 않아도 유지하는 높이.
  static double get slotHeight => AdSize.banner.height.toDouble();

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  BannerAd? _banner;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    // Android/iOS 가 아니면 AdMob 네이티브 채널이 없다. 빈 자리만 남기고 넘어간다.
    if (!AdIds.adsAvailable) return;

    _banner = BannerAd(
      size: AdSize.banner,
      adUnitId: AdIds.banner,
      listener: _listener,
      request: const AdRequest(),
    )..load();
  }

  /// 배너 수명주기 로깅.
  ///
  /// 단위 ID 조회(`AdIds`)와 달리 이건 이 위젯 하나만 쓰는 설정이라
  /// 여기 둔다. ID 는 빌드 시점 값 조회고, 리스너는 런타임 동작이다.
  static final BannerAdListener _listener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad loaded.'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('Ad failed to load: $error');
    },
    onAdOpened: (ad) => debugPrint('Ad opened'),
    onAdClosed: (ad) => debugPrint('Ad closed'),
  );

  @override
  void dispose() {
    _banner?.dispose();
    _banner = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banner = _banner;

    return Container(
      alignment: Alignment.center,
      width: (banner?.size.width ?? AdSize.banner.width).toDouble(),
      height: (banner?.size.height ?? AdSize.banner.height).toDouble(),
      child: banner == null ? null : AdWidget(ad: banner),
    );
  }
}
