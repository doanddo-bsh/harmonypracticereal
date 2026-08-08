import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:harmonypracticereal/core/theme/app_theme.dart';
import 'package:harmonypracticereal/core/theme/theme_mode_controller.dart';
import 'package:harmonypracticereal/domain/quiz/quiz_session.dart';
import 'package:harmonypracticereal/ui/loading/loading_page.dart';

/// MaterialApp 조립. 예전에는 `main.dart` 의 `MyApp` 이었다.
///
/// StatefulWidget 인 이유는 [FirebaseAnalyticsObserver] 를 한 번만 만들기
/// 위해서다. 예전 코드는 build 마다 새로 만들었다.
class HarmonyApp extends StatefulWidget {
  const HarmonyApp({
    super.key,
    this.initialThemeMode = ThemeModePreference.defaultThemeMode,
  });

  /// `main()` 이 첫 프레임 **전에** 디스크에서 읽어 넘겨주는 값.
  ///
  /// 여기서 비동기로 읽지 않는 이유가 곧 '깜빡임이 없는' 이유다.
  /// [MaterialApp] 은 첫 build 에서 이미 확정된 [ThemeMode] 를 받는다.
  final ThemeMode initialThemeMode;

  @override
  State<HarmonyApp> createState() => _HarmonyAppState();
}

class _HarmonyAppState extends State<HarmonyApp> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  late final FirebaseAnalyticsObserver _analyticsObserver =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterClass()),
        ChangeNotifierProvider(
          create: (_) => ThemeModeController(initial: widget.initialThemeMode),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 844),
        // Consumer 는 MaterialApp 만 다시 그리기 위한 것이다. 설정에서
        // 테마를 바꾸면 여기부터 아래가 새 ThemeData 로 다시 칠해진다.
        builder: (context, child) => Consumer<ThemeModeController>(
          child: child,
          builder: (context, themeModeController, child) => MaterialApp(
            title: 'itervalpractice',
            debugShowCheckedModeBanner: false,
            navigatorObservers: [_analyticsObserver],
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeModeController.themeMode,
            builder: (context, child) => MediaQuery(
              // 사용자 글자 크기 설정이 악보 레이아웃을 깨뜨리므로 고정한다.
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.noScaling),
              child: child!,
            ),
            home: child,
          ),
        ),
        child: const LoadingPage(),
      ),
    );
  }
}
