import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'page/loadingPage.dart';
import 'page/problemFunc/providerCounter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


// admob banner ref : https://deku.posstree.com/ko/flutter/admob/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //  WidgetsFlutterBinding.ensureInitialized();을 사용하여 Flutter가 초기화가 잘 되었는지 확인한 후
  // Firebase 초기화
  await Firebase.initializeApp();
  // 가로모드 막기
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]);
  // MobileAds 초기화
  MobileAds.instance.initialize(); //MobileAds.instance.initialize();을 호출하여 MobileAds를 초기화 합니다.
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Firebase Analytics 인스턴스 생성
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(create: (context)=>CounterClass(),
      child: ScreenUtilInit(
        designSize: const Size(375, 844),
        builder: (context, child) =>
            MaterialApp(
              title: 'itervalpractice',
              debugShowCheckedModeBanner: false,
              navigatorObservers: [
                FirebaseAnalyticsObserver(analytics: analytics),
              ],
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                useMaterial3: true,
              ),

              builder: (context, child){
                return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child!);
              },
               home: child,
        ),
        child: const LoadingPage(),
      ),
    );
  }
}

