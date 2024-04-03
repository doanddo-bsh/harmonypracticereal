// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobServiceBanner {

  static String? get bannerAdUnitId{
    if (kReleaseMode){
      // 실전 모드
      if (Platform.isAndroid) {
        return 'ca-app-pub-7191096510845066/9834842939';
      } else if (Platform.isIOS){
        return 'ca-app-pub-7191096510845066/9643271244';
      }
    } else {
      // test mode
      // ref : https://developers.google.com/admob/flutter/test-ads?hl=ko
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else if (Platform.isIOS){
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    }
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad loaded.'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('Ad failed to load: $error');
    },
    onAdOpened: (ad) => debugPrint('Ad opened'),
    onAdClosed: (ad) => debugPrint('Ad closed'),
  );
}

class AdMobServiceFullScreen {

  static String? get fullScreenAdUnitId{
    if (kReleaseMode){
      // 실전 모드
      if (Platform.isAndroid) {
        return 'ca-app-pub-7191096510845066/5895597923';
      } else if (Platform.isIOS){
        return 'ca-app-pub-7191096510845066/4263468974';
      }
    } else {
      // test mode
      // ref : https://developers.google.com/admob/flutter/test-ads?hl=ko
      // ref : https://luvris2.tistory.com/714
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/1033173712';
      } else if (Platform.isIOS){
        return 'ca-app-pub-3940256099942544/4411468910';
      }
    }
  }
}