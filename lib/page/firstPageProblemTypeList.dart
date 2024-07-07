// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'problemFunc/colorList.dart';
import 'settingPage/settingPage.dart';

import 'problem/problemType1.dart';
import 'problem/problemType2.dart';
import 'problem/problemEasyType3.dart';
import 'problem/problemEasyType4.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'problemFunc/admobClass.dart';
import 'problemFunc/admobFunc.dart';
import 'problemFunc/providerCounter.dart';

import 'package:provider/provider.dart';
import 'package:async_preferences/async_preferences.dart';
import 'settingPage/initialization_helper.dart';
import '../../harmonyModul/modulProblemProbability.dart';

class FirstProblemTypeList extends StatefulWidget {
  const FirstProblemTypeList({Key? key}) : super(key: key);

  @override
  State<FirstProblemTypeList> createState() => _FirstProblemTypeListState();
}

class _FirstProblemTypeListState extends State<FirstProblemTypeList>
    with SingleTickerProviderStateMixin {

  late TabController tabController = TabController(length: 3, vsync: this);

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

    print('snapshot.hasData && snapshot.data');
    print(snapshot.hasData);
    print(snapshot.data);
    print(snapshot.hasData && snapshot.data);

    return SafeArea(
      child: Column(
        children: [
            SizedBox(
              height: 670.h,
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
          Row(
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
                padding: EdgeInsets.fromLTRB(3.w, 00.h, 30.w, 10.h),
                child: Tooltip(
                  textStyle: const TextStyle(color: Colors.black54),
                  decoration: BoxDecoration(color: const Color(0xffeeeeee),
                      borderRadius: BorderRadius.circular(10)),
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: const Duration(milliseconds: 5000),
                  message:
                  'Easy는 3화음과 여러 종류의 7화음 까지 출제 됩니다.\nHard는 Easy에서 출제된 문제에 더해서\n고급 화성학 문제가 추가로 출제 됩니다.',
                  child: const Icon(
                    Icons.info_outline,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          // admob banner
          Container(
            alignment: Alignment.center,
            width: _banner!.size.width.toDouble(),
            height: _banner!.size.height.toDouble(),
            child: AdWidget(
              ad: _banner!,
            ),
          ),
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
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold
      ),
      tabs:  [
        const Tab(child: Text('SuperEasy',
          style: TextStyle(
            color: Color(0xfff8b306),
            // fontWeight: FontWeight.bold,
            // fontSize: 15,
          ),
        ),
        ),
        const Tab(child: Text('Easy',
          style: TextStyle(
            color: Color(0xff3f8a36),
            // fontWeight: FontWeight.bold,
            // fontSize: 15,
          ),
        ),
        ),
        const Tab(child: Text('Hard',
          style: TextStyle(
            color: Color(0xffc94040),
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
        ListViewSuperEasy(),
        ListViewEasy(),
        ListViewHard(),
      ],
    );
  }
}


class ListViewSuperEasy extends StatefulWidget {
  ListViewSuperEasy({Key? key}) : super(key: key);

  @override
  State<ListViewSuperEasy> createState() => _ListViewSuperEasyState();
}

class _ListViewSuperEasyState extends State<ListViewSuperEasy> {
  List<List<String>> mainTitleAndContentsEasy = [
    ['화성 문제 1','화성의 이름','조성, 4성부 음'],
    ['화성 문제 2','빈칸 성부의 음','화성의 이름, 3성부 음'],
    ['화성 문제 3','조성','화성의 이름, 4성부 음'],
    ['화성 문제 4','코드 이름','4성부 음'],
  ];

  List problemPage = [
    tonalityProblemType1(getSuperEasyProblemType134,'superEasy')
    ,tonalityProblemType2(getSuperEasyProblemType2,'superEasy')
    ,tonalityProblemEasyType3(getSuperEasyProblemType134,'superEasy')
    ,tonalityProblemEasyType4(getSuperEasyProblemType134,'superEasy')];

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

    return Column(
      children: [
        SizedBox(
          height: 620.h,
          child: ListView.builder(
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
                                          style: const TextStyle(
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
                                  Container(
                                    width: 180.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        AutoSizeText('문제', maxLines: 1,
                                          style:TextStyle(fontWeight: FontWeight.bold),),
                                        SizedBox(width: 10.w,),
                                        Container(
                                          width: 2,
                                          height: 13,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 10.w,),
                                        AutoSizeText
                                          (mainTitleAndContentsEasy[index][1], maxLines: 1,
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
                                        style:TextStyle(fontWeight: FontWeight.bold),),
                                        SizedBox(width: 10.w,),
                                        Container(
                                          width: 2,
                                          height: 13,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 10.w,),
                                        AutoSizeText
                                          (mainTitleAndContentsEasy[index][2], maxLines:
                                        1,),
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

          ),
        ),

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
  // List<List<String>> mainTitleAndContentsEasy = [
  //   ['화성 문제 1','문제에 주어진 조성과\n4성부에 적힌 4개의 음을 보고\n화음의 이름을 구해보세요'],
  //   ['화성 문제 2','문제에 주어진 화음의 이름과\n4성부에 적힌 3개의 음을 보고\n나머지 1개의 음을 구해보세요'],
  //   ['화성 문제 3','문제에 주어진 화음의 이름과\n4성부에 적힌 4개의 음을 보고\n조성을 구해보세요'],
  //   ['화성 문제 4','4성부에 적힌 4개의 음을 보고\n코드의 이름을 구해보세요'],
  // ];
  List<List<String>> mainTitleAndContentsEasy = [
    ['화성 문제 1','화성의 이름','조성과 4성부 음'],
    ['화성 문제 2','나머지 1개 음','화성과 4성부 중 3개의 음'],
    ['화성 문제 3','조성','화음의 이름과 4성부 음'],
    ['화성 문제 4','코드 이름','4성부 음'],
  ];
  List problemPage = [
    tonalityProblemType1(getEasyProblemType134,'easy')
    ,tonalityProblemType2(getEasyProblemType2,'easy')
    ,tonalityProblemEasyType3(getEasyProblemType134,'easy')
    ,tonalityProblemEasyType4(getEasyProblemType134,'easy')];

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

    return Column(
      children: [
        SizedBox(
          height: 620.h,
          child: ListView.builder(
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
                                        image: AssetImage('assets/harmonyEasyCut1.jpeg')
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
                                          style: const TextStyle(
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
                                  Container(
                                    width: 180.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        AutoSizeText('문제', maxLines: 1,),
                                        SizedBox(width: 6.w,),
                                        Container(
                                          width: 2,
                                          height: 13,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 6.w,),
                                        AutoSizeText
                                          (mainTitleAndContentsEasy[index][1], maxLines: 1,),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 180.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        AutoSizeText('조건', maxLines: 1,),
                                        SizedBox(width: 6.w,),
                                        Container(
                                          width: 2,
                                          height: 13,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 6.w,),
                                        AutoSizeText
                                          (mainTitleAndContentsEasy[index][2], maxLines:
                                        1,),
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

          ),
        ),

      ],
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
    ['화성 문제 1','화성의 이름','조성과 4성부 음'],
    ['화성 문제 2','나머지 1개 음','화성과 4성부 중 3개의 음'],
    ['화성 문제 3','조성','화음의 이름과 4성부 음'],
    ['화성 문제 4','코드 이름','4성부 음'],
  ];

  List problemPage = [
    tonalityProblemType1(getHardProblemType134,'hard')
    ,tonalityProblemType2(getHardProblemType2,'hard')
    ,tonalityProblemEasyType3(getHardProblemType134,'hard')
    ,tonalityProblemEasyType4(getHardProblemType134,'hard')];

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

    return Column(
      children: [
        SizedBox(
          height: 620.h,
          child: ListView.builder(
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
                                        image: AssetImage('assets/harmonyHardCut1.jpeg')
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
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16
                                          ),)
                                    ),
                                  ),
                                  // const SizedBox(height: 5,),
                                  const SizedBox(height: 5,),
                                  // SizedBox(
                                  //   width: 180.w,
                                  //   child: AutoSizeText(mainTitleAndContentsEasy[index][1],
                                  //     maxLines: 3,
                                  //   ),
                                  // ),
                                  Container(
                                    width: 180.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        AutoSizeText('문제', maxLines: 1,),
                                        SizedBox(width: 6.w,),
                                        Container(
                                          width: 2,
                                          height: 13,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 6.w,),
                                        AutoSizeText
                                          (mainTitleAndContentsEasy[index][1], maxLines: 1,),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 180.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        AutoSizeText('조건', maxLines: 1,),
                                        SizedBox(width: 6.w,),
                                        Container(
                                          width: 2,
                                          height: 13,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 6.w,),
                                        AutoSizeText
                                          (mainTitleAndContentsEasy[index][2], maxLines:
                                        1,),
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

          ),
        ),

      ],
    );
  }
}

//
// class ListViewHard extends StatefulWidget {
//   ListViewHard({Key? key}) : super(key: key);
//
//   @override
//   State<ListViewHard> createState() => _ListViewHardState();
// }
//
// class _ListViewHardState extends State<ListViewHard> {
//   List<List<String>> mainTitleAndContentsEasy = [
//     ['음정 문제 1','악보 위의 음정을 계산하여','정답을 맞춰보세요'],
//     ['음정 문제 2','주어진 음정을 보고 알맞은','계이름을 계산하여 맞춰보세요'],
//     ['음정 문제 3','주어진 음정의 자리바꿈 음정을','계산하여 정답을 맞춰보세요'],
//   ];
//
//   List   problemPage =
//   [
//     tonalityProblemType1(getEasyProblemType134)
//     ,tonalityProblemType1(getEasyProblemType134)
//     ,tonalityProblemType1(getEasyProblemType134)
//   ];
//   // [const HardProblemType1(),const HardProblemType2(),const HardProblemType3()];
//
//   // for full screen ad
//   InterstitialAd? _interstitialAd;
//
//   final fullScreenAdUnitId = AdMobServiceFullScreen.fullScreenAdUnitId ;
//
//   /// Loads an interstitial ad.
//   void loadAd() {
//     InterstitialAd.load(
//         adUnitId: fullScreenAdUnitId!,
//         request: const AdRequest(),
//         adLoadCallback: InterstitialAdLoadCallback(
//           // Called when an ad is successfully received.
//           onAdLoaded: (ad) {
//             ad.fullScreenContentCallback = FullScreenContentCallback(
//               // Called when the ad showed the full screen content.
//                 onAdShowedFullScreenContent: (ad) {},
//                 // Called when an impression occurs on the ad.
//                 onAdImpression: (ad) {},
//                 // Called when the ad failed to show full screen content.
//                 onAdFailedToShowFullScreenContent: (ad, err) {
//                   // Dispose the ad here to free resources.
//                   ad.dispose();
//                 },
//                 // Called when the ad dismissed full screen content.
//                 onAdDismissedFullScreenContent: (ad) {
//                   // Dispose the ad here to free resources.
//                   ad.dispose();
//                 },
//                 // Called when a click is recorded for an ad.
//                 onAdClicked: (ad) {});
//
//             debugPrint('$ad loaded.');
//             // Keep a reference to the ad so you can show it later.
//             _interstitialAd = ad;
//           },
//           // Called when an ad request failed.
//           onAdFailedToLoad: (LoadAdError error) {
//             debugPrint('InterstitialAd failed to load: $error');
//           },
//         ));
//   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//
//     loadAd();
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 530.h,
//           child: ListView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               padding: EdgeInsets.fromLTRB(10.w,10.h,10.w,0),
//               itemCount:mainTitleAndContentsEasy.length,
//               itemBuilder: (BuildContext context, int index){
//                 return Padding(
//                   padding: const EdgeInsets.all(7.5),
//                   child: GestureDetector(
//                     onTap: () {
//
//                       // show full ad if problemSolvedCount more then 30
//                       if (Provider.of<CounterClass>(context, listen: false)
//                           .solvedProblemCount >= criticalNumberSolved) {
//
//                         loadAd();
//
//                         if (_interstitialAd != null) {
//                           _interstitialAd?.show();
//
//                           Provider.of<CounterClass>(context, listen: false)
//                               .resetSolvedProblemCount();
//                         }
//                       }
//
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                               problemPage[index]
//                           )
//                       );
//                     },
//                     child: Container(
//                         height: 155.h,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(
//                               color: color8,
//                               width: 2.3
//                           ),
//                           borderRadius: BorderRadius.circular(17.0),
//                         ),
//                         child:Row(
//                           children: [
//                             SizedBox(
//                               width: 105.w,
//                               height: 105.h,
//                               child: Stack(children: [
//                                 Center(
//                                   child: SizedBox(
//                                     height: 73.h,
//                                     width: 73.w,
//                                     child: const Image(
//                                         image: AssetImage('assets/music_2805328.png')
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                               ),
//                             ),
//                             // SizedBox(width: 10,),
//                             Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children:[
//                                   // SizedBox(height: 15.h,),
//                                   Container(
//                                     margin: const EdgeInsets.fromLTRB(10,0,10,10),
//                                     width: 180.w,
//                                     child: Align(
//                                         alignment: Alignment.centerLeft,
//                                         child: Text(mainTitleAndContentsEasy[index][0],
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16
//                                           ),)
//                                     ),
//                                   ),
//                                   // const SizedBox(height: 7,),
//                                   SizedBox(
//                                     width: 180.w,
//                                     child: AutoSizeText(mainTitleAndContentsEasy[index][1],
//                                       maxLines: 1,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 180.w,
//                                     child: AutoSizeText
//                                       (mainTitleAndContentsEasy[index][2],
//                                       maxLines: 1,
//                                     ),
//                                   ),
//                                 ]
//                             ),
//
//                           ],
//                         )
//                     ),
//                   ),
//                 );
//               }
//
//           ),
//         ),
//       ],
//     );
//   }
// }

