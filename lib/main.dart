import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'page/loadingPage.dart';
import 'page/problemFunc/providerCounter.dart';

// admob banner ref : https://deku.posstree.com/ko/flutter/admob/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //  WidgetsFlutterBinding.ensureInitialized();을 사용하여 Flutter가 초기화가 잘 되었는지 확인한 후
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); // 가로모드 막기
  MobileAds.instance.initialize(); //MobileAds.instance.initialize();을 호출하여 MobileAds를 초기화 합니다.
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'itervalpractice',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
    //     useMaterial3: true,
    //   ),
    //   home: SecondePageProblem(),
    // );

    return ChangeNotifierProvider(create: (context)=>CounterClass(),
      child: ScreenUtilInit(
        designSize: const Size(375, 844),
        builder: (context, child) => MaterialApp(
          title: 'itervalpractice',
          debugShowCheckedModeBanner: false,
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
    // return ScreenUtilInit(
    //   designSize: const Size(375, 844),
    //   builder: (context, child) => MaterialApp(
    //     title: 'itervalpractice',
    //     debugShowCheckedModeBanner: false,
    //     theme: ThemeData(
    //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
    //       useMaterial3: true,
    //     ),
    //     builder: (context, child){
    //       return MediaQuery(
    //           data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
    //           child: child!);
    //     },
    //     home: child,
    //   ),
    //   child: const LoadingPage(),
    // );
  }
}

