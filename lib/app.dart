import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:harmonypracticereal/core/theme/app_theme.dart';
import 'package:harmonypracticereal/domain/quiz/quiz_session.dart';
import 'package:harmonypracticereal/ui/loading/loading_page.dart';

/// MaterialApp 조립. 예전에는 `main.dart` 의 `MyApp` 이었다.
///
/// StatefulWidget 인 이유는 [FirebaseAnalyticsObserver] 를 한 번만 만들기
/// 위해서다. 예전 코드는 build 마다 새로 만들었다.
class HarmonyApp extends StatefulWidget {
  const HarmonyApp({super.key});

  @override
  State<HarmonyApp> createState() => _HarmonyAppState();
}

class _HarmonyAppState extends State<HarmonyApp> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  late final FirebaseAnalyticsObserver _analyticsObserver =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterClass(),
      child: ScreenUtilInit(
        designSize: const Size(375, 844),
        builder: (context, child) => MaterialApp(
          title: 'itervalpractice',
          debugShowCheckedModeBanner: false,
          navigatorObservers: [_analyticsObserver],
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          builder: (context, child) => MediaQuery(
            // 사용자 글자 크기 설정이 악보 레이아웃을 깨뜨리므로 고정한다.
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          ),
          home: child,
        ),
        child: const LoadingPage(),
      ),
    );
  }
}
