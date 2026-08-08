import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:harmonypracticereal/app.dart';
import 'package:harmonypracticereal/core/ads/ad_content_policy.dart';
import 'package:harmonypracticereal/core/theme/theme_mode_controller.dart';
import 'package:harmonypracticereal/firebase_options.dart';

// admob banner ref : https://deku.posstree.com/ko/flutter/admob/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 가로모드 막기
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 광고 콘텐츠 등급 제한을 초기화보다 **먼저** 건다.
  // 2026-08-08 Families Policy(광고 콘텐츠) 로 배포가 거부된 데 대한 대응이다.
  // 자세한 배경은 AdContentPolicy 문서 주석 참고.
  await AdContentPolicy.apply();
  MobileAds.instance.initialize();

  // 저장된 테마 설정을 runApp() **전에** 읽는다.
  //
  // runApp() 이 호출되기 전에는 Flutter 가 프레임을 한 장도 그리지 않는다
  // (화면에는 네이티브 런치 스크린이 떠 있다). 그래서 여기서 기다리면
  // 첫 프레임부터 최종 테마로 칠해지고, 라이트→다크 깜빡임이 원천적으로
  // 생기지 않는다. 앱 안에서 FutureBuilder 로 읽었다면 로딩 화면이
  // 기본 테마로 한 번 그려진 뒤 바뀌었을 것이다.
  //
  // 지연은 SharedPreferences 채널 왕복 한 번이고, 바로 위 Firebase 초기화가
  // 그보다 훨씬 오래 걸린다. load() 는 어떤 예외도 던지지 않는다.
  final ThemeMode initialThemeMode = await ThemeModePreference.load();

  runApp(HarmonyApp(initialThemeMode: initialThemeMode));
}
