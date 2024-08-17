// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'problemFunc/colorList.dart';
import 'settingPage/settingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'problem/problemType1.dart';
import 'problem/problemType2.dart';
import 'problem/problemType3.dart';
import 'problem/problemType4.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'problemFunc/admobClass.dart';
import 'problemFunc/admobFunc.dart';
import 'problemFunc/providerCounter.dart';

import 'package:provider/provider.dart';
import 'package:async_preferences/async_preferences.dart';
import 'settingPage/initialization_helper.dart';
import '../../harmonyModul/modulProblemProbability.dart';
import 'problemFunc/multiDropDown.dart';

class FirstProblemTypeList extends StatefulWidget {
  const FirstProblemTypeList({Key? key}) : super(key: key);

  @override
  State<FirstProblemTypeList> createState() => _FirstProblemTypeListState();
}

class _FirstProblemTypeListState extends State<FirstProblemTypeList>
    with SingleTickerProviderStateMixin {

  late TabController tabController = TabController(length: 4, vsync: this);

  // ios IDFS setting ref :
  // https://coicoitech.tistory
  // .com/entry/Flutter-Tip-AppTrackingTransparency-%EC%B6%94%EC%A0%81-
  // %ED%97%88%EC%9A%A9-dialog-%EB%9D%84%EC%9A%B0%EA%B8%B0

  // for admob banner
  BannerAd? _banner;

  // ios IDFS setting
  String _authStatus = 'Unknown';
  // ios IDFS setting end

  @override
  void initState() {
    super.initState();
    // ios IDFS setting
    WidgetsBinding.instance.addPostFrameCallback((_) =>initPlugin());
    // ios IDFS setting end

    // for admob banner
    _createBannerAd();

    // for tab bar
    tabController.addListener(() {});

    // gdpr
    _future = _isUnderGdpr();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        // appBar : AppBar(
        //   title: Text('화성박사'),
        //   actions: [
        //     FutureBuilder<bool>(
        //       future:_future,
        //       builder: (context,snapshot){
        //         if (snapshot.hasData && snapshot.data == true) {
        //           return IconButton(
        //               onPressed: (){
        //                 Navigator.push(context, MaterialPageRoute(
        //                     builder: (context) {
        //                       return SettingPage();
        //                     }
        //                 )
        //                 );
        //               },
        //               icon: Icon(Icons.settings)
        //           );
        //         } else {
        //           return SizedBox();
        //         }
        //       },
        //     ),
        //   ],
        // ),
        body: FutureBuilder<bool>(
            future: _future,
            builder: (context, snapshot) {
              return _body(snapshot);
            }
        )
    );
  }

  // ios IDFS setting
  Future<void> initPlugin() async { // 앱추적
    try{
      final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => _authStatus = '$status');
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined){
        await Future.delayed(const Duration(milliseconds: 200));
        final TrackingStatus status =
        await AppTrackingTransparency.requestTrackingAuthorization();
        setState(() => _authStatus = '$status');
      }
    } on PlatformException {
      setState(() => _authStatus = 'PlatformException was thrown');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  }
  // ios IDFS setting end

  // admob banner
  void _createBannerAd(){
    _banner = BannerAd(
      size: AdSize.banner
      , adUnitId: AdMobServiceBanner.bannerAdUnitId!
      , listener: AdMobServiceBanner.bannerAdListener
      , request: const AdRequest(),
    )..load();
  }

  // GDPR setting
  final _initializationHelper = InitializationHelper();
  late final Future<bool> _future ;

  Future<bool> _isUnderGdpr() async {
    final preferences = AsyncPreferences();
    return await preferences.getInt('IABTCF_gdprApplies') == 1;
  }

  Widget _body(var snapshot) {

    return SafeArea(
      child: Column(
        children: [
            Expanded(
              child: SizedBox(
                child: Column(
                  children: [
                    _tabBar(),
                    // Expanded 없으면 오류 발생
                    // Horizontal viewport was given unbounded height.
                    Expanded(child: _tabBarView()),
                    // _tabBarView(),
                  ],
                ),
              ),
            ),
          SizedBox(height: 10.h,),
          SizedBox(
            height: 18.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (snapshot.hasData && snapshot.data == true)
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 00.h, 0.w, 10.h),
                    child: IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) {return const SettingPage();}
                          )
                          );
                        },
                        icon: const Icon(Icons.privacy_tip_outlined)
                    ),
                  ),
                // ElevatedButton(onPressed: (){
                //   print(Provider.of<CounterClass>(context, listen: false).solvedProblemCount);
                // }, child: Text('show')),
                Padding(
                  padding: EdgeInsets.fromLTRB(3.w, 00.h, 30.w, 00.h),
                  child: Tooltip(
                    textStyle: const TextStyle(color: Colors.black54),
                    decoration: BoxDecoration(color: const Color(0xffeeeeee),
                        borderRadius: BorderRadius.circular(10)),
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: const Duration(milliseconds: 5000),
                    message:
                    'easy는 3화음과 속 7화음 까지 출제됩니다.\nmedium는 3화음과 모든 종류의 '
                        '7화음이 추가됩니다.\nhard는 3화음에서 고급 화성학까지 전부 출제됩니다.',
                    child: Icon(
                      Icons.info_outline,
                      size: 18.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h,),
          // admob banner
          Container(
            alignment: Alignment.center,
            width: _banner!.size.width.toDouble(),
            height: _banner!.size.height.toDouble(),
            child: AdWidget(
              ad: _banner!,
            ),
          ),
          SizedBox(height: 20.h,),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return TabBar(
      controller: tabController,
      // labelColor: Colors.orangeAccent, // 클릭한 텍스트 강조 컬러
      // unselectedLabelColor: Colors.blue, // 클릭 안된 텍스트 컬러
      indicatorColor: Colors.black38,
      indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 2),
          insets: EdgeInsets.symmetric(horizontal: 40)
      ),
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold
      ),
      tabs:  [
        Tab(child: Text('Easy',
          style: TextStyle(
            color: color14,
            // fontWeight: FontWeight.bold,
            // fontSize: 15,
          ),
        ),
        ),
        Tab(child: Text('Medium',
          style: TextStyle(
            color: color15,
            // fontWeight: FontWeight.bold,
            // fontSize: 15,
          ),
        ),
        ),
        Tab(child: Text('Hard',
          style: TextStyle(
            color: color16,
            // fontWeight: FontWeight.bold,
            // fontSize: 15
          ),
        )
        ),
        Tab(child: Text('Custom',
          style: TextStyle(
            color: color17,
            // fontWeight: FontWeight.bold,
            // fontSize: 15
          ),
        )
        ),
      ],
    );
  }

  Widget _tabBarView() {
    return TabBarView(
      controller: tabController,
      children: [
        ListViewEasy(),
        ListViewMedium(),
        ListViewHard(),
        ListViewCustom(),
      ],
    );
  }
}


class ListViewEasy extends StatefulWidget {
  ListViewEasy({Key? key}) : super(key: key);

  @override
  State<ListViewEasy> createState() => _ListViewEasyState();
}

class _ListViewEasyState extends State<ListViewEasy> {
  List<List<String>> mainTitleAndContentsEasy = [
    ['화성 문제 1','화성의 이름','조성, 4성부 음'],
    ['화성 문제 2','빈칸 성부의 음','화성의 이름, 3성부 음'],
    ['화성 문제 3','조성','화성의 이름, 4성부 음'],
    ['화성 문제 4','코드 이름','4성부 음'],
  ];





  // for full screen ad
  InterstitialAd? _interstitialAd;

  final fullScreenAdUnitId = AdMobServiceFullScreen.fullScreenAdUnitId ;

  /// Loads an interstitial ad.
  void loadAd() {
    InterstitialAd.load(
        adUnitId: fullScreenAdUnitId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  List<String> problemTypes1 = [];
  List problemPage = [] ;

  @override
  void initState() {
    // TODO: implement initState

    loadAd();

    super.initState();

    // problemTypes1 = ["3화음", "속7화음"];

    problemPage = [
      // tonalityProblemType1(getSuperEasyProblemType134,'superEasy')
      tonalityProblemType1(getCustomProblemType,'Easy',problemTypes:easyType134)
      ,tonalityProblemType2(getCustomProblemType,'Easy',problemTypes:easyType2)
      ,tonalityProblemType3(getCustomProblemType,'Easy',problemTypes:easyType134)
      ,tonalityProblemType4(getCustomProblemType,'Easy',problemTypes:easyType134)];
  }

  // List problemPage = [ResultTestPage(),EasyProblemType2(),EasyProblemType3()];
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      // physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(10.w,10.h,10.w,0),
        itemCount:mainTitleAndContentsEasy.length,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: const EdgeInsets.all(7.5),
            child: GestureDetector(
              onTap: () {

                // show full ad if problemSolvedCount more then 30

                if (Provider.of<CounterClass>(context, listen: false)
                    .solvedProblemCount >= criticalNumberSolved) {
                  loadAd();

                  if (_interstitialAd != null) {
                    _interstitialAd?.show();

                    Provider.of<CounterClass>(context, listen: false)
                        .resetSolvedProblemCount();
                  }
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          return problemPage[index];
                          //   return
                          //   ChangeNotifierProvider<Counter>(
                          //   create: (_) {return Counter();} ,
                          //   child: problemPage[index]
                          //   );
                        }
                    )
                );
              },
              child: Container(
                  height: 137.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: color8,
                        width: 2.3
                    ),
                    borderRadius: BorderRadius.circular(17.0),
                  ),
                  child:Row(
                    children: [
                      SizedBox(
                        width: 105.w,
                        height: 105.h,
                        child: Stack(children: [
                          Center(
                            child: SizedBox(
                              height: 75.h,
                              width: 75.w,
                              child: const Image(
                                  image: AssetImage
                                    ('assets/harmonySuperEasyCut1'
                                      '.jpeg')
                                // ,fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                        ),
                      ),
                      // SizedBox(width: 10,),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            // SizedBox(height: 7,),
                            // SizedBox(height: 27.h,),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10,0,10,10),
                              width: 180.w,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(mainTitleAndContentsEasy[index][0],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),)
                              ),
                            ),
                            const SizedBox(height: 5,),
                            // SizedBox(
                            //   width: 180.w,
                            //   child: AutoSizeText(mainTitleAndContentsEasy[index][1],
                            //     maxLines: 3,
                            //   ),
                            // ),
                            SizedBox(
                              width: 180.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AutoSizeText('문제', maxLines: 1,
                                    style:TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),),
                                  SizedBox(width: 10.w,),
                                  Container(
                                    width: 2,
                                    height: 13,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10.w,),
                                  AutoSizeText
                                    (mainTitleAndContentsEasy[index][1], maxLines: 1,
                                    style:TextStyle(
                                      // fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(height: 4,),
                            Container(
                              width: 180.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AutoSizeText('조건', maxLines: 1,
                                    style:TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                  SizedBox(width: 10.w,),
                                  Container(
                                    width: 2,
                                    height: 13,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10.w,),
                                  AutoSizeText(
                                    mainTitleAndContentsEasy[index][2],
                                    maxLines: 1,
                                    style:TextStyle(
                                      // fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                      ),
                    ],
                  )
              ),
            ),
          );
        }

    );
  }
}


class ListViewMedium extends StatefulWidget {
  ListViewMedium({Key? key}) : super(key: key);

  @override
  State<ListViewMedium> createState() => _ListViewMediumState();
}

class _ListViewMediumState extends State<ListViewMedium> {
  // List<List<String>> mainTitleAndContentsEasy = [
  //   ['화성 문제 1','문제에 주어진 조성과\n4성부에 적힌 4개의 음을 보고\n화음의 이름을 구해보세요'],
  //   ['화성 문제 2','문제에 주어진 화음의 이름과\n4성부에 적힌 3개의 음을 보고\n나머지 1개의 음을 구해보세요'],
  //   ['화성 문제 3','문제에 주어진 화음의 이름과\n4성부에 적힌 4개의 음을 보고\n조성을 구해보세요'],
  //   ['화성 문제 4','4성부에 적힌 4개의 음을 보고\n코드의 이름을 구해보세요'],
  // ];
  List<List<String>> mainTitleAndContentsEasy = [
    ['화성 문제 1','화성의 이름','조성, 4성부 음'],
    ['화성 문제 2','빈칸 성부의 음','화성의 이름, 3성부 음'],
    ['화성 문제 3','조성','화성의 이름, 4성부 음'],
    ['화성 문제 4','코드 이름','4성부 음'],
  ];
  List problemPage = [
    tonalityProblemType1(getCustomProblemType,'Medium',problemTypes:mediumType134)
    ,tonalityProblemType2(getCustomProblemType,'Medium',problemTypes:mediumType2)
    ,tonalityProblemType3(getCustomProblemType,'Medium',problemTypes:mediumType134)
    ,tonalityProblemType4(getCustomProblemType,'Medium',problemTypes:mediumType134)];

  // for full screen ad
  InterstitialAd? _interstitialAd;

  final fullScreenAdUnitId = AdMobServiceFullScreen.fullScreenAdUnitId ;

  /// Loads an interstitial ad.
  void loadAd() {
    InterstitialAd.load(
        adUnitId: fullScreenAdUnitId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }


  @override
  void initState() {
    // TODO: implement initState

    loadAd();

    super.initState();
  }

  // List problemPage = [ResultTestPage(),EasyProblemType2(),EasyProblemType3()];
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      // physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(10.w,10.h,10.w,0),
        itemCount:mainTitleAndContentsEasy.length,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: const EdgeInsets.all(7.5),
            child: GestureDetector(
              onTap: () {

                // show full ad if problemSolvedCount more then 30
                if (Provider.of<CounterClass>(context, listen: false)
                    .solvedProblemCount >= criticalNumberSolved) {

                  loadAd();

                  if (_interstitialAd != null) {
                    _interstitialAd?.show();

                    Provider.of<CounterClass>(context, listen: false)
                        .resetSolvedProblemCount();
                  }
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          return problemPage[index];
                          //   return
                          //   ChangeNotifierProvider<Counter>(
                          //   create: (_) {return Counter();} ,
                          //   child: problemPage[index]
                          //   );
                        }
                    )
                );
              },
              child: Container(
                  height: 137.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: color8,
                        width: 2.3
                    ),
                    borderRadius: BorderRadius.circular(17.0),
                  ),
                  child:Row(
                    children: [
                      SizedBox(
                        width: 105.w,
                        height: 105.h,
                        child: Stack(children: [
                          Center(
                            child: SizedBox(
                              height: 75.h,
                              width: 75.w,
                              child: const Image(
                                  image: AssetImage('assets/harmonyMediumCut2.jpeg')
                                // ,fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                        ),
                      ),
                      // SizedBox(width: 10,),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            // SizedBox(height: 7,),
                            // SizedBox(height: 27.h,),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10,0,10,10),
                              width: 180.w,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(mainTitleAndContentsEasy[index][0],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),)
                              ),
                            ),
                            const SizedBox(height: 5,),
                            // SizedBox(
                            //   width: 180.w,
                            //   child: AutoSizeText(mainTitleAndContentsEasy[index][1],
                            //     maxLines: 3,
                            //   ),
                            // ),
                            SizedBox(
                              width: 180.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AutoSizeText('문제', maxLines: 1,
                                    style:TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),),
                                  SizedBox(width: 10.w,),
                                  Container(
                                    width: 2,
                                    height: 13,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10.w,),
                                  AutoSizeText
                                    (mainTitleAndContentsEasy[index][1], maxLines: 1,
                                    style:TextStyle(
                                      // fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(height: 4,),
                            Container(
                              width: 180.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AutoSizeText('조건', maxLines: 1,
                                    style:TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                  SizedBox(width: 10.w,),
                                  Container(
                                    width: 2,
                                    height: 13,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10.w,),
                                  AutoSizeText(
                                    mainTitleAndContentsEasy[index][2],
                                    maxLines: 1,
                                    style:TextStyle(
                                      // fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                      ),
                    ],
                  )
              ),
            ),
          );
        }

    );
  }
}

class ListViewHard extends StatefulWidget {
  ListViewHard({Key? key}) : super(key: key);

  @override
  State<ListViewHard> createState() => _ListViewHardState();
}

class _ListViewHardState extends State<ListViewHard> {
  // List<List<String>> mainTitleAndContentsHard = [
  //   ['화성 문제 1','문제에 주어진 조성과\n4성부에 적힌 4개의 음을 보고\n화음의 이름을 구해보세요'],
  //   ['화성 문제 2','문제에 주어진 화음의 이름과\n4성부에 적힌 3개의 음을 보고\n나머지 1개의 음을 구해보세요'],
  //   ['화성 문제 3','문제에 주어진 화음의 이름과\n4성부에 적힌 4개의 음을 보고\n조성을 구해보세요'],
  //   ['화성 문제 4','4성부에 적힌 4개의 음을 보고\n코드의 이름을 구해보세요'],
  // ];
  List<List<String>> mainTitleAndContentsEasy = [
    ['화성 문제 1','화성의 이름','조성, 4성부 음'],
    ['화성 문제 2','빈칸 성부의 음','화성의 이름, 3성부 음'],
    ['화성 문제 3','조성','화성의 이름, 4성부 음'],
    ['화성 문제 4','코드 이름','4성부 음'],
  ];

  List problemPage = [
    tonalityProblemType1(getCustomProblemType,'Hard',problemTypes:hardType13)
    ,tonalityProblemType2(getCustomProblemType,'Hard',problemTypes:hardType2)
    ,tonalityProblemType3(getCustomProblemType,'Hard',problemTypes:hardType13)
    ,tonalityProblemType4(getCustomProblemType,'Hard',problemTypes:hardType4)
  ];

  // for full screen ad
  InterstitialAd? _interstitialAd;

  final fullScreenAdUnitId = AdMobServiceFullScreen.fullScreenAdUnitId ;

  /// Loads an interstitial ad.
  void loadAd() {
    InterstitialAd.load(
        adUnitId: fullScreenAdUnitId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }


  @override
  void initState() {
    // TODO: implement initState

    loadAd();

    super.initState();
  }

  // List problemPage = [ResultTestPage(),EasyProblemType2(),EasyProblemType3()];
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      // physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(10.w,10.h,10.w,0),
        itemCount:mainTitleAndContentsEasy.length,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: const EdgeInsets.all(7.5),
            child: GestureDetector(
              onTap: () {

                // show full ad if problemSolvedCount more then 30
                if (Provider.of<CounterClass>(context, listen: false)
                    .solvedProblemCount >= criticalNumberSolved) {

                  loadAd();

                  if (_interstitialAd != null) {
                    _interstitialAd?.show();

                    Provider.of<CounterClass>(context, listen: false)
                        .resetSolvedProblemCount();
                  }
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          return problemPage[index];
                          //   return
                          //   ChangeNotifierProvider<Counter>(
                          //   create: (_) {return Counter();} ,
                          //   child: problemPage[index]
                          //   );
                        }
                    )
                );
              },
              child: Container(
                  height: 137.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: color8,
                        width: 2.3
                    ),
                    borderRadius: BorderRadius.circular(17.0),
                  ),
                  child:Row(
                    children: [
                      SizedBox(
                        width: 105.w,
                        height: 105.h,
                        child: Stack(children: [
                          Center(
                            child: SizedBox(
                              height: 75.h,
                              width: 75.w,
                              child: const Image(
                                  image: AssetImage('assets/harmonyHardCut2.jpeg')
                                // ,fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                        ),
                      ),
                      // SizedBox(width: 10,),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            // SizedBox(height: 7,),
                            // SizedBox(height: 27.h,),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10,0,10,10),
                              width: 180.w,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(mainTitleAndContentsEasy[index][0],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),)
                              ),
                            ),
                            const SizedBox(height: 5,),
                            // SizedBox(
                            //   width: 180.w,
                            //   child: AutoSizeText(mainTitleAndContentsEasy[index][1],
                            //     maxLines: 3,
                            //   ),
                            // ),
                            SizedBox(
                              width: 180.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AutoSizeText('문제', maxLines: 1,
                                    style:TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),),
                                  SizedBox(width: 10.w,),
                                  Container(
                                    width: 2,
                                    height: 13,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10.w,),
                                  AutoSizeText
                                    (mainTitleAndContentsEasy[index][1], maxLines: 1,
                                    style:TextStyle(
                                      // fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(height: 4,),
                            Container(
                              width: 180.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AutoSizeText('조건', maxLines: 1,
                                    style:TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                  SizedBox(width: 10.w,),
                                  Container(
                                    width: 2,
                                    height: 13,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10.w,),
                                  AutoSizeText(
                                    mainTitleAndContentsEasy[index][2],
                                    maxLines: 1,
                                    style:TextStyle(
                                      // fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                      ),
                    ],
                  )
              ),
            ),
          );
        }

    );
  }
}


class ListViewCustom extends StatefulWidget {
  ListViewCustom({Key? key}) : super(key: key);

  @override
  State<ListViewCustom> createState() => _ListViewCustomState();
}

class _ListViewCustomState extends State<ListViewCustom> {
  // List<List<String>> mainTitleAndContentsHard = [
  //   ['화성 문제 1','문제에 주어진 조성과\n4성부에 적힌 4개의 음을 보고\n화음의 이름을 구해보세요'],
  //   ['화성 문제 2','문제에 주어진 화음의 이름과\n4성부에 적힌 3개의 음을 보고\n나머지 1개의 음을 구해보세요'],
  //   ['화성 문제 3','문제에 주어진 화음의 이름과\n4성부에 적힌 4개의 음을 보고\n조성을 구해보세요'],
  //   ['화성 문제 4','4성부에 적힌 4개의 음을 보고\n코드의 이름을 구해보세요'],
  // ];
  List<List<String>> mainTitleAndContentsEasy = [
    ['화성 문제 1','화성의 이름','조성, 4성부 음'],
    ['화성 문제 2','빈칸 성부의 음','화성의 이름, 3성부 음'],
    ['화성 문제 3','조성','화성의 이름, 4성부 음'],
    ['화성 문제 4','코드 이름','4성부 음'],
  ];

  // for full screen ad
  InterstitialAd? _interstitialAd;

  final fullScreenAdUnitId = AdMobServiceFullScreen.fullScreenAdUnitId ;

  /// Loads an interstitial ad.
  void loadAd() {
    InterstitialAd.load(
        adUnitId: fullScreenAdUnitId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  // for multi drop down button
  List<String> _selectedItems = [];

  List<String> items7Only = [
    '부속7화음','속7화음','부7화음','부감7화음','감7화음','부반감7화음','반감7화음'
  ];

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> items = [
      "3화음",
      "부속7화음",
      "속7화음",
      "부7화음",
      "나폴리화음",
      "부감7화음",
      "감7화음",
      "증6화음",
      "부반감7화음",
      "반감7화음",
      "부증6화음",
      "차용"
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items, selectedItems: _selectedItems);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
        print('_selectedItems $_selectedItems');
        print('results $results');
      });
      _saveItems();
    }
  }

  // 데이터를 로컬에 저장하는 함수
  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', _selectedItems);
  }

  // 로컬에 저장된 데이터를 불러오는 함수
  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedItems = prefs.getStringList('items') ?? ["3화음"];
    });
  }

  // 아이템을 추가하는 함수
  // void _addItem(String item) {
  //   setState(() {
  //     _selectedItems.add(item);
  //   });
  //   _saveItems();
  // }


  @override
  void initState() {
    // TODO: implement initState

    loadAd();

    super.initState();

    _loadItems();
  }

  // List problemPage = [ResultTestPage(),EasyProblemType2(),EasyProblemType3()];
  @override
  Widget build(BuildContext context) {

    List problemPage = [
      tonalityProblemType1(getCustomProblemType,'Custom',problemTypes:_selectedItems)
      ,tonalityProblemType2(getCustomProblemType,'Custom',problemTypes:_selectedItems)
      ,tonalityProblemType3(getCustomProblemType,'Custom',problemTypes:_selectedItems)
      ,tonalityProblemType4(getCustomProblemType,'Custom',problemTypes:_selectedItems)
    ];

    return ListView.builder(
      // physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(10.w,10.h,10.w,0),
        itemCount:mainTitleAndContentsEasy.length + 1,
        itemBuilder: (BuildContext context, int index){
          if (index == 0){
            return Padding(
              padding: EdgeInsets.fromLTRB(10.w,0,10.w,0),
              child: ElevatedButton(
                onPressed: _showMultiSelect,
                child: const Text('버튼을 눌러 원하는 화성을 선택해주세요!'),
                style: ElevatedButton.styleFrom(
                  // backgroundColor: Color(0xffd3cccc), // Background color
                  // foregroundColor: Colors.white, // Text color
                  backgroundColor: Color(0xfff6f6f6), // Background color
                  foregroundColor: Colors.black38,
                  surfaceTintColor: Colors.transparent,
                  // Text color
                  // shadowColor: Colors.blueAccent, // Shadow color
                  // elevation: 2, // Elevation of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: Color(0xffdedede),
                      width: 2
                    ) // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  // Padding
                  textStyle: TextStyle(
                    inherit: false, // Ensure inherit is set to false
                    fontSize: 12.5,
                    letterSpacing: 1.5,// Text size
                    fontWeight: FontWeight.bold, // Text weight
                    color: Colors.white, // Text color to match onPrimary
                  ),
                elevation: 0
                ),
              ),
            );
          } else {

            int index_m1 = index-1;

            return Padding(
              padding: const EdgeInsets.all(7.5),
              child: GestureDetector(
                onTap: () {

                  // show full ad if problemSolvedCount more then 30
                  if (Provider.of<CounterClass>(context, listen: false)
                      .solvedProblemCount >= criticalNumberSolved) {

                    loadAd();

                    if (_interstitialAd != null) {
                      _interstitialAd?.show();

                      Provider.of<CounterClass>(context, listen: false)
                          .resetSolvedProblemCount();
                    }
                  }

                  if (
                        (index_m1==1) &
                        (!_selectedItems.any((element) =>
                            items7Only.contains(element)))
                      ){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(23, 0, 23,
                              0),
                          child: AlertDialog(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.transparent,
                            // title: const Text(''),
                            content: Padding(
                              padding: const EdgeInsets.only(top: 15.0,left: 10.0)
                              , // 위쪽
                              // 여백을 20픽셀로 설정
                              child: const Text(
                                '7화음을 포함해야 합니다',
                                style: TextStyle(
                                  color: Color(0xff5d5d5d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                                ),),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('확인',
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color:  Color(0xff2f2f2f),
                                  fontSize: 15
                                ),),
                              ),
                            ],
                            actionsPadding: EdgeInsets.fromLTRB(
                                3.w, 3.h, 10.w, 5.h),
                          ),
                        );
                      },
                    );
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) {
                              return problemPage[index_m1];
                            }
                        )
                    );
                  }

                },
                child: Container(
                    height: 137.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: color8,
                          width: 2.3
                      ),
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                    child:Row(
                      children: [
                        SizedBox(
                          width: 105.w,
                          height: 105.h,
                          child: Stack(children: [
                            Center(
                              child: SizedBox(
                                height: 75.h,
                                width: 75.w,
                                child: const Image(
                                    image: AssetImage('assets/harmonyCustomCut'
                                        '.jpeg')
                                  // ,fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                          ),
                        ),
                        // SizedBox(width: 10,),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              // SizedBox(height: 7,),
                              // SizedBox(height: 27.h,),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10,0,10,10),
                                width: 180.w,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(mainTitleAndContentsEasy[index_m1][0],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),)
                                ),
                              ),
                              const SizedBox(height: 5,),
                              // SizedBox(
                              //   width: 180.w,
                              //   child: AutoSizeText(mainTitleAndContentsEasy[index][1],
                              //     maxLines: 3,
                              //   ),
                              // ),
                              SizedBox(
                                width: 180.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AutoSizeText('문제', maxLines: 1,
                                      style:TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14
                                      ),),
                                    SizedBox(width: 10.w,),
                                    Container(
                                      width: 2,
                                      height: 13,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 10.w,),
                                    AutoSizeText
                                      (mainTitleAndContentsEasy[index_m1][1], maxLines: 1,
                                      style:TextStyle(
                                        // fontWeight: FontWeight.bold,
                                          fontSize: 14
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(height: 4,),
                              Container(
                                width: 180.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AutoSizeText('조건', maxLines: 1,
                                      style:TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14
                                      ),
                                    ),
                                    SizedBox(width: 10.w,),
                                    Container(
                                      width: 2,
                                      height: 13,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 10.w,),
                                    AutoSizeText(
                                      mainTitleAndContentsEasy[index_m1][2],
                                      maxLines: 1,
                                      style:TextStyle(
                                        // fontWeight: FontWeight.bold,
                                          fontSize: 14
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ],
                    )
                ),
              ),
            );
          }
        }

    );
  }
}