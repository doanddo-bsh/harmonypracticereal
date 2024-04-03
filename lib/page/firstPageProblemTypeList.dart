// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'problemFunc/colorList.dart';
import 'settingPage/settingPage.dart';

import 'problem/problemType1.dart';
// import 'easyProblem/easyProblemType1.dart';
// import 'easyProblem/easyProblemType2.dart';
// import 'easyProblem/easyProblemType3.dart';
// import 'hardProblem/hardProblemType1.dart';
// import 'hardProblem/hardProblemType2.dart';
// import 'hardProblem/hardProblemType3.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'problemFunc/admobClass.dart';
import 'problemFunc/admobFunc.dart';
import 'problemFunc/providerCounter.dart';

import 'package:provider/provider.dart';
import 'package:async_preferences/async_preferences.dart';
import 'settingPage/initialization_helper.dart';

class FirstProblemTypeList extends StatefulWidget {
  const FirstProblemTypeList({Key? key}) : super(key: key);

  @override
  State<FirstProblemTypeList> createState() => _FirstProblemTypeListState();
}

class _FirstProblemTypeListState extends State<FirstProblemTypeList>
    with SingleTickerProviderStateMixin {

  late TabController tabController = TabController(length: 2, vsync: this);

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
        // AppBar(
        //   title: Text('음정박사'),
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
          SizedBox(
            height: 590.h,
            child: Column(
              children: [
                ListViewEasy(),
                // _tabBarView(),
              ],
            ),
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

  // Widget _tabBar() {
  //   return TabBar(
  //     controller: tabController,
  //     // labelColor: Colors.orangeAccent, // 클릭한 텍스트 강조 컬러
  //     // unselectedLabelColor: Colors.blue, // 클릭 안된 텍스트 컬러
  //     indicatorColor: Colors.black38,
  //     indicator: const UnderlineTabIndicator(
  //         borderSide: BorderSide(width: 2),
  //         insets: EdgeInsets.symmetric(horizontal: 40)
  //     ),
  //     labelStyle: const TextStyle(
  //       fontSize: 18,
  //       fontWeight: FontWeight.bold,
  //     ),
  //     unselectedLabelStyle: const TextStyle(
  //         fontSize: 15,
  //         fontWeight: FontWeight.bold
  //     ),
  //     tabs:  [
  //       const Tab(child: Text('Easy',
  //         style: TextStyle(
  //           color: Color(0xff3f8a36),
  //           // fontWeight: FontWeight.bold,
  //           // fontSize: 15,
  //         ),
  //       ),
  //       ),
  //       const Tab(child: Text('Hard',
  //         style: TextStyle(
  //           color: Color(0xffc94040),
  //           // fontWeight: FontWeight.bold,
  //           // fontSize: 15
  //         ),
  //       )
  //       ),
  //     ],
  //   );
  // }

  // Widget _tabBarView() {
  //   return TabBarView(
  //     controller: tabController,
  //     children: [
  //       ListViewEasy(),
  //       ListViewHard(),
  //     ],
  //   );
  // }
}

class ListViewEasy extends StatefulWidget {
  ListViewEasy({Key? key}) : super(key: key);

  @override
  State<ListViewEasy> createState() => _ListViewEasyState();
}

class _ListViewEasyState extends State<ListViewEasy> {
  List<List<String>> mainTitleAndContentsEasy = [
    ['화성 문제 1','조성 표를 보고 조성 이름을 맞춰보세요'],
    ['화성 문제 2','조성 표를 보고 관계조 이름을 맞춰보세요'],
    ['화성 문제 3','조성 이름을 보고 조성 표를 찾아보세요'],
  ];

  List problemPage = [const tonalityProblemType1(),const tonalityProblemType1(),const tonalityProblemType1()];

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
          height: 530.h,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
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
                        height: 155.h,
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
                                    height: 73.h,
                                    width: 73.w,
                                    child: const Image(
                                        image: AssetImage('assets/music_2805328.png')
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
                                  SizedBox(
                                    width: 180.w,
                                    child: AutoSizeText(mainTitleAndContentsEasy[index][1],
                                      maxLines: 1,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 180.w,
                                  //   child: AutoSizeText
                                  //     (mainTitleAndContentsEasy[index][2],
                                  //     maxLines: 1,
                                  //   ),
                                  // ),
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
//   List problemPage = [const HardProblemType1(),const HardProblemType2(),const HardProblemType3()];
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
//                                         image: AssetImage('assets/musichard.png')
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

