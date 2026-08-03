import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'page/loadingPage.dart';
import 'page/problemFunc/providerCounter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';

// admob banner ref : https://deku.posstree.com/ko/flutter/admob/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); // 가로모드 막기
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // late final FirebaseAnalytics analytics ;

  @override
  void initState() {
    super.initState();
    // analytics = FirebaseAnalytics.instance;
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(create: (context)=>CounterClass(),
      child: ScreenUtilInit(
        designSize: const Size(375, 844),
        builder: (context, child) => MaterialApp(
          title: 'itervalpractice',
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            // primaryColor: Colors.white,
            // canvasColor: Colors.white,
            // dialogBackgroundColor: Colors.white,
            useMaterial3: true,
            // dialogTheme: DialogTheme(
            //   backgroundColor: Colors.white,
            // ),
          ),

          builder: (context, child){
            return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.noScaling),
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

