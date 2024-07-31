// ignore_for_file: file_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_notes/music_notes.dart' as msc;
import '../problemFunc/colorList.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../problemFunc/admobClass.dart';
import '../problemFunc/problemFuncHarmony.dart';
import '../problemFunc/problemFuncDeco.dart';

// import '../problemFunc/resultPage.dart';
import '../../harmonyModul/modulProblemProbability.dart';
import '../problemFunc/resultPage.dart';
import '../problemFunc/providerCounter.dart';
import '../problemFunc/admobFunc.dart';
import 'package:provider/provider.dart';
import 'package:numerus/numerus.dart';


class tonalityProblemType4 extends StatefulWidget {
  final Function? problemCallFunction;

  final String stageType;
  final List<String>? problemTypes ;
  tonalityProblemType4(this.problemCallFunction, this.stageType,
      {this.problemTypes,super.key});

  @override
  State<tonalityProblemType4> createState() =>
      _tonalityProblemType4State();
}

class _tonalityProblemType4State extends State<tonalityProblemType4> {
  // for admob banner
  BannerAd? _banner;

  // final _random = new Random();

  // 변수 초기화
  int numberOfRight = 0;

  bool wrongProblemMode = false;

  List<List<dynamic>> wrongProblems = [];
  List<List<dynamic>> wrongProblemsSave = [];

  String? answerUser = null;

  Widget intervalNumberButton(String stringAnswer) {
    return ElevatedButton(
        onPressed: () {
          // for Full-page advertisement count solved problem
          Provider.of<CounterClass>(context, listen: false)
              .incrementSolvedProblemCount();

          setState(() {
            answerUser = stringAnswer;
          });
          showBottomResult(answerUser);
        },
        style: answerButtonDesign(),
        child: Text(
          stringAnswer,
          style: answerButtonTextDesign,
        ));
  }

  void showBottomResult(String? answerInterval) {
    // 정답 계산
    String? answerUser = answerInterval;
    String answerReal = answerType4Code;

    // // 해석 해설
    // String commentaryResult = commentaryKeyReturn(randomNoteAnswer,
    //     answerRealKor);

    if (answerUser == answerReal) {
      setState(() {
        numberOfRight += 1;
      });

      showModalBottomSheet<void>(
        backgroundColor: color5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        enableDrag: false,
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 185.h,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 25.h,
                ),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '정답입니다!',
                          style: TextStyle(
                              color: color4,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                AutoSizeText(
                  '정답 : ${answerType4Code}',
                  maxLines: 1,
                  style: TextStyle(
                    color: color4,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                // nextProblem('다음문제','right')
                wrongProblemMode
                    ? (wrongProblemsSave.length != problemNumber)
                        ? wrongProblemNextProblem('다음문제', 'right')
                        : showResult('right')
                    : (problemNumber != 10)
                        ? nextProblem('다음문제', 'right')
                        : showResult('right'),
                // (problemNumber!=10)? nextProblem('다음문제') : showResult()
              ],
            ),
          );
        },
      );
    } else {
      wrongProblems += [
        [answer, problem, condition, problemOriginal, problemName]
      ];

      showModalBottomSheet<void>(
        backgroundColor: const Color(0xffd7b1b1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        enableDrag: false,
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 185.h,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 25.h,
                ),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '오답입니다',
                          style: TextStyle(
                              color: color6,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // commentaryToolTip(commentaryResult),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                AutoSizeText(
                  '정답 : ${answerType4Code}',
                  maxLines: 1,
                  style: TextStyle(
                    color: color6,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                // Text('정답은 ${answerRealKor} 입니다.'),
                // nextProblem('다음문제','wrong')
                wrongProblemMode
                    ? (wrongProblemsSave.length != problemNumber)
                        ? wrongProblemNextProblem('다음문제', 'wrong')
                        : showResult('wrong')
                    : (problemNumber != 10)
                        ? nextProblem('다음문제', 'wrong')
                        : showResult('wrong'),
                // (problemNumber!=10)? nextProblem('다음문제') : showResult()
              ],
            ),
          );
        },
      );
    }
  }

  // type4 get answer
  (String, List<String>) getType4Answer(
      List<msc.Note> problemOrg, String problemName, int chosenNumber) {

    print('getType4Answer work');
    print('problemOrg $problemOrg');
    print('problemName $problemName');
    print('chosenNumber $chosenNumber');

    String problemType4AnswerTemp = problemOrg[0].toString();

    String problemType4Answer;

    String m3Condition = letKnowM3m3M3m3(problemOrg);

    print('m3Condition $m3Condition');


    if (['basicProblem', 'basicProblemMinor'].contains(problemName)) {
      if (m3Condition == 'M3m3') {
        problemType4Answer = problemType4AnswerTemp;
      } else if (m3Condition == 'm3M3') {
        problemType4Answer = '${problemType4AnswerTemp}m';
      } else {
        problemType4Answer = '${problemType4AnswerTemp}dim';
      }
    } else if ([
      'secondaryDominant7thProblem',
      'secondaryDominant7thProblemMinor',
      'dominant7thProblem',
      'dominant7thProblemMinor'
    ].contains(problemName)) {
      problemType4Answer = '${problemType4AnswerTemp}7';
    } else if ([
      'secondaryDiminished7thProblem',
      'secondaryDiminished7thProblemMinor'
    ].contains(problemName)) {
      problemType4Answer = '${problemType4AnswerTemp}dim7';
    } else if ([
      'secondaryHalfDiminished7thProblem',
      'secondaryHalfDiminished7thProblemMinor'
    ].contains(problemName)) {
      problemType4Answer = '${problemType4AnswerTemp}m7(b5)';
    } else if ([
      // 부7화음 장조 1,4 M7
      // 2,3,6은 코드에 m7
      'secondary7thProblem'
    ].contains(problemName)) {
      if ([1,4].contains(chosenNumber)){
        problemType4Answer = '${problemType4AnswerTemp}M7';
      } else {
        problemType4Answer = '${problemType4AnswerTemp}m7';
      }
    } else if ([
      // 부7화음 마이너
      // 1 코드mM7
      // 3,6 코드M7
      // 4 코드m7
      'secondary7thProblemMinor'
    ].contains(problemName)) {
      if ([1].contains(chosenNumber)){
        problemType4Answer = '${problemType4AnswerTemp}mM7';
      } else if ([3,6].contains(chosenNumber)) {
        problemType4Answer = '${problemType4AnswerTemp}M7';
      } else {
        problemType4Answer = '${problemType4AnswerTemp}m7';
      }
      // problemType4Answer = '${problemType4AnswerTemp}mM7';
    }else {
      problemType4Answer = problemType4AnswerTemp;
    }

    List<String> wrongList = [
      problemType4AnswerTemp,
      '${problemType4AnswerTemp}m',
      '${problemType4AnswerTemp}dim',
      '${problemType4AnswerTemp}7',
      '${problemType4AnswerTemp}dim7',
      '${problemType4AnswerTemp}m7(b5)'
    ];

    wrongList.remove(problemType4Answer);
    wrongList.shuffle();

    print('problemType4Answer $problemType4Answer');

    return (problemType4Answer, wrongList.sublist(0, 2));
  }

  String letKnowM3m3M3m3(List<msc.Note> problemOrg) {
    msc.Note orgNote1 = problemOrg[0];
    msc.Note orgNote2 = problemOrg[1];
    msc.Note orgNote3 = problemOrg[2];

    msc.Note orgNote2Test;
    msc.Note orgNote3Test;

    String answerM3m3M3m3;

    // M3m3 test
    orgNote2Test = orgNote1.transposeBy(msc.Interval.M3);
    orgNote3Test = orgNote2.transposeBy(msc.Interval.M3);

    if (orgNote2Test == orgNote2) {
      answerM3m3M3m3 = 'M3m3';
    } else if (orgNote3Test == orgNote3) {
      answerM3m3M3m3 = 'm3M3';
    } else {
      answerM3m3M3m3 = 'm3m3';
    }
    return answerM3m3M3m3;
  }

  // 보기 만들때 앞대가리가 정확하게 똑같을때 뒤의 메이저 마이너가 겹치면 안됨
  List<String> getViewListEasyType4(
      String type4RealAnswer, List<String> wrongAnswerList) {
    List<String> viewListTemp = [];

    viewListTemp.add(type4RealAnswer);
    viewListTemp.addAll(wrongAnswerList);

    while (viewListTemp.length <= 3) {
      var problemElementsTemp;

      // if (widget.stageType=='custom'){
      //   problemElementsTemp = widget.problemCallFunction!(widget.problemTypes);
      // } else {
      //   problemElementsTemp = widget.problemCallFunction!();
      // }
      problemElementsTemp = widget.problemCallFunction!(widget.problemTypes);

      var answerTemp = problemElementsTemp.$1;
      var problemOriginalTemp = problemElementsTemp.$4;
      var problemNameTemp = problemElementsTemp.$5;

      String wrongAnswerTemp;
      List<String> wrongAnswerTempList;
      (wrongAnswerTemp, wrongAnswerTempList) =
          getType4Answer(problemOriginalTemp
              , problemNameTemp
              , romanToInt(answerTemp[0].toUpperCase())
          );

      if (wrongAnswerTemp != type4RealAnswer) {
        // 정답과 다르며
        if (!viewListTemp.contains(wrongAnswerTemp)) {
          // 다른 오답과 다른것 추가
          viewListTemp.add(wrongAnswerTemp);
        }
      }
    }

    viewListTemp.shuffle();

    print('type4RealAnswer $type4RealAnswer');
    print('viewListTemp $viewListTemp');

    return viewListTemp;
  }

  // type4 problem creator
  List<msc.Note> typeFourProblemCreator(
      List<msc.Note> problemTemp, List<msc.Note> problemOrgTemp) {
    msc.Note firstNote = problemOrgTemp[0];
    problemTemp.remove(firstNote);
    List<msc.Note> otherNotes = problemTemp;

    return [firstNote] + otherNotes;
  }

  double answerSizeHeight = 50.2.h;
  double heightToWidth = 0.3;

  Widget nextProblem(String buttonText, String rightWrong) {
    return ElevatedButton(
      onPressed: () {
        if (problemNumber == 10) {
          setState(() {
            problemNumber = 0;
          });
        }

        setState(() {
          positionedNoteListOld = positionedNoteList;
          positionedNoteList = [];
          while (positionedNoteList.isEmpty) {
            // 문제 보기 생성 ================================================
            // if (widget.stageType=='custom'){
            //   problemElements = widget.problemCallFunction!(widget.problemTypes);
            // } else {
            //   problemElements = widget.problemCallFunction!();
            // }
            problemElements = widget.problemCallFunction!(widget.problemTypes);
            answer = problemElements.$1;
            problem = problemElements.$2;
            condition = problemElements.$3;
            // print('condition $condition');

            print('answer $answer');

            problemOriginal = problemElements.$4;
            problemName = problemElements.$5;
            // print('problemName $problemName');
            // print('answer $answer');

            problemType4 = typeFourProblemCreator(problem, problemOriginal);

            if (positionedNoteListOld != positionedNoteList) {
              positionedNoteList = noteToPositionedNote(problemType4);
            }

            String answerType4CodeTemp;
            List<String> answerType4CodeTempList;

            (answerType4CodeTemp, answerType4CodeTempList) =
                getType4Answer(problemOriginal
                    , problemName
                    , romanToInt(answer[0].toUpperCase())
                );

            answerType4Code = answerType4CodeTemp;
            // (answerType4Code,[]) = getType4Answer(problemOriginal,problemName);

            viewList = [];
            viewList =
                getViewListEasyType4(answerType4Code, answerType4CodeTempList);

            answerUser = null;
            // 문제 보기 생성 ================================================
          }

          problemNumber += 1;
        });

        Navigator.pop(context);
      },
      style: nextProblemButtonStyle('easy', rightWrong),
      child: Text(
        buttonText,
        style: nextProblemButtonTextStyle,
      ),
    );
  }

  Widget showResult(String rightWrong) {
    // Navigator.pop(context);

    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);

        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          enableDrag: false,
          isDismissible: false,
          builder: (BuildContext context) {
            return resultPage(
              context,
              wrongProblemMode,
              numberOfRight,
              wrongProblemsSave,
              wrongProblems,
              nextProblemResult(),
              wrongProblemSolveStart('틀린 문제 다시 풀기'),
              () {
                wrongProblems = [];
                wrongProblemMode = false;
                numberOfRight = 0;
                Navigator.popUntil(
                    context, ModalRoute.withName("/FirstProblemTypeList"));
              },
            );
          },
        );
      },
      style: nextProblemButtonStyle('easy', rightWrong),
      child: Text(
        '결과보기',
        style: nextProblemButtonTextStyle,
      ),
    );
  }

  // for full screen ad
  InterstitialAd? _interstitialAd;

  final fullScreenAdUnitId = AdMobServiceFullScreen.fullScreenAdUnitId;

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

  Widget nextProblemResult() {
    return ElevatedButton(
        onPressed: () {
          // show full ad if problemSolvedCount more then 30
          if (Provider.of<CounterClass>(context, listen: false)
                  .solvedProblemCount >=
              criticalNumberSolved) {
            loadAd();
            if (_interstitialAd != null) {
              _interstitialAd?.show();
              Provider.of<CounterClass>(context, listen: false)
                  .resetSolvedProblemCount();
            }
          }

          numberOfRight = 0;
          wrongProblems = [];
          wrongProblemMode = false;

          setState(() {
            positionedNoteListOld = positionedNoteList;
            positionedNoteList = [];
            while (positionedNoteList.isEmpty) {
              // 문제 보기 생성 ================================================
              // if (widget.stageType=='custom'){
              //   problemElements = widget.problemCallFunction!(widget.problemTypes);
              // } else {
              //   problemElements = widget.problemCallFunction!();
              // }
              problemElements = widget.problemCallFunction!(widget.problemTypes);

              answer = problemElements.$1;
              problem = problemElements.$2;
              condition = problemElements.$3;
              problemOriginal = problemElements.$4;
              problemName = problemElements.$5;

              problemType4 = typeFourProblemCreator(problem, problemOriginal);

              if (positionedNoteListOld != positionedNoteList) {
                positionedNoteList = noteToPositionedNote(problemType4);
              }

              String answerType4CodeTemp;
              List<String> answerType4CodeTempList;

              (answerType4CodeTemp, answerType4CodeTempList) =
                  getType4Answer(problemOriginal
                      , problemName
                      , romanToInt(answer[0].toUpperCase())
                  );

              answerType4Code = answerType4CodeTemp;

              viewList = [];
              viewList = getViewListEasyType4(
                  answerType4Code, answerType4CodeTempList);

              answerUser = null;
              // 문제 보기 생성 ================================================
            }
          });

          setState(() {
            problemNumber = 1;
          });

          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Text(
          '네',
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ));
  }

  Widget wrongProblemNextProblem(String buttonText, String rightWrong) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          problemNumber += 1;

          // 문제 보기 생성 ================================================
          answer = wrongProblemsSave[problemNumber - 1][0];
          problem = wrongProblemsSave[problemNumber - 1][1];
          condition = wrongProblemsSave[problemNumber - 1][2];
          problemOriginal = wrongProblemsSave[problemNumber - 1][3];
          problemName = wrongProblemsSave[problemNumber - 1][4];

          problemType4 = typeFourProblemCreator(problem, problemOriginal);

          positionedNoteList = noteToPositionedNote(problemType4);

          String answerType4CodeTemp;
          List<String> answerType4CodeTempList;

          (answerType4CodeTemp, answerType4CodeTempList) =
              getType4Answer(problemOriginal
                  , problemName
                  , romanToInt(answer[0].toUpperCase())
              );

          answerType4Code = answerType4CodeTemp;

          viewList = [];
          viewList =
              getViewListEasyType4(answerType4Code, answerType4CodeTempList);

          answerUser = null;
          // 문제 보기 생성 ================================================
        });

        Navigator.pop(context);
      },
      style: nextProblemButtonStyle('easy', rightWrong),
      child: Text(
        buttonText,
        style: nextProblemButtonTextStyle,
      ),
    );
  }

  Widget wrongProblemSolveStart(String buttonText) {
    return ElevatedButton(
      onPressed: (wrongProblems.isEmpty)
          ? null
          : () {
              numberOfRight = 0;
              // back up
              wrongProblemsSave = wrongProblems;

              wrongProblems = [];

              setState(() {
                // 문제 보기 생성 ================================================
                answer = wrongProblemsSave[0][0];
                problem = wrongProblemsSave[0][1];
                condition = wrongProblemsSave[0][2];
                problemOriginal = wrongProblemsSave[0][3];
                problemName = wrongProblemsSave[0][4];

                problemType4 = typeFourProblemCreator(problem, problemOriginal);

                positionedNoteList = noteToPositionedNote(problemType4);

                // answerType4Code = getType4Answer(problemOriginal,problemName);
                String answerType4CodeTemp;
                List<String> answerType4CodeTempList;

                (answerType4CodeTemp, answerType4CodeTempList) =
                    getType4Answer(problemOriginal
                        , problemName
                        , romanToInt(answer[0].toUpperCase())
                    );

                answerType4Code = answerType4CodeTemp;
                viewList = [];
                viewList = getViewListEasyType4(
                    answerType4Code, answerType4CodeTempList);

                answerUser = null;
                // 문제 보기 생성 ================================================
              });

              setState(() {
                problemNumber = 1;
                wrongProblemMode = true;
              });

              Navigator.pop(context);
            },
      style: ElevatedButton.styleFrom(
          // minimumSize: Size(100.w,50.h),
          backgroundColor: Colors.yellow[200]),
      child: Text(
        '틀린 문제 다시 풀기',
        style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700]),
      ),
    );
  }

  int problemNumber = 1;

  late (
    List<String>,
    List<msc.Note>,
    msc.Tonality,
    List<msc.Note>,
    String
  ) problemElements;

  late List<String> answer;

  List<String> viewList = [];

  late List<msc.Note> problem;

  late msc.Tonality condition;

  late List<msc.Note> problemOriginal;

  late String problemName;

  late String answerType4Code;

  late List<String> answerType4CodeList;

  late List<msc.Note> problemType4;

  late List<msc.PositionedNote> positionedNoteList;

  late List<msc.PositionedNote> positionedNoteListOld;

  // Random().nextInt(4); // Value is >= 0 and < 4.

  List<String> tellWhatMiss = ['베이스 찾아', '테너 찾아', '알토 찾아', '소프 찾아'];

  Map<String, int> _romanToIntMap = {
    'I': 1,
    'V': 5,
    'X': 10,
    'L': 50,
    'C': 100,
    'D': 500,
    'M': 1000,
  };

  int romanToInt(String s) {
    print('s $s');
    int result = 0;
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && _romanToIntMap[s[i]]! > _romanToIntMap[s[i - 1]]!) {
        result += _romanToIntMap[s[i]]! - 2 * _romanToIntMap[s[i - 1]]!;
      } else {
        result += _romanToIntMap[s[i]]!;
      }
    }
    print('result $result');
    return result;
  }

  // 코드 만드는 방법
  // 코드 앞에는 다 대문자임
  // 기본은 대문자 M3 소문자 m3 이면 맨 앞에 시작되는 음이
  // 그대로 코드 이름이 됨
  // 기본은 m3 M3 이면 맨 앞에 시작되는 음이 코드가 되는데
  // 그 뒤에 소문자 m을 붙여줘
  // 속7 M3 m3 m3 면
  // 시작하는 음은 쓰고 그대로 가져와서
  // 그 옆에 7을 붙여

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 새로운 문제 생성
    positionedNoteList = [];
    while (positionedNoteList.isEmpty) {
      // 문제 보기 생성 ================================================
      // if (widget.stageType=='custom'){
      //   problemElements = widget.problemCallFunction!(widget.problemTypes);
      // } else {
      //   problemElements = widget.problemCallFunction!();
      // }
      problemElements = widget.problemCallFunction!(widget.problemTypes);

      answer = problemElements.$1;
      problem = problemElements.$2;
      condition = problemElements.$3;
      problemOriginal = problemElements.$4;
      problemName = problemElements.$5;

      print('answer $answer');
      // type four
      // problem 생성
      // 1번음이 base가 되게 수행
      problemType4 = typeFourProblemCreator(problem, problemOriginal);

      // if (positionedNoteListOld!=positionedNoteList){
      positionedNoteList = noteToPositionedNote(problemType4);
      // }

      String answerType4CodeTemp;
      List<String> answerType4CodeTempList;

      (answerType4CodeTemp, answerType4CodeTempList) =
          getType4Answer(
              problemOriginal
              , problemName
              , romanToInt(answer[0].toUpperCase())
          );

      answerType4Code = answerType4CodeTemp;
      // answerType4Code = getType4Answer(problemOriginal,problemName);

      viewList = [];
      viewList = getViewListEasyType4(answerType4Code, answerType4CodeTempList);

      answerUser = null;
      // 문제 보기 생성 ================================================
    }

    // for admob banner
    _createBannerAd();
  }

  // admob banner
  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.banner,
      adUnitId: AdMobServiceBanner.bannerAdUnitId!,
      listener: AdMobServiceBanner.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: wrongProblemMode
            ? Text("오답문제", style: appBarTitleStyle)
            : Text(widget.stageType,
                style: appBarTitleStyle,
              ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: appBarIcon,
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      body: Column(
        children: [
          lastRidingProgress(
            wrongProblemMode,
            problemNumber,
            wrongProblemsSave,
            widget.stageType,
            context,
          ),
          SizedBox(
            height: 5.h,
          ),
          // Text(widget.problemTypes.toString()),
          // Text(problemName.toString()),
          // Text(condition.toString()),
          Container(
            height: 425.h,
            width: double.infinity,
            decoration: BoxDecoration(
                // border: Border.all(color: Colors.black),
                ),
            child: Stack(
              children: [
                //////////////////////////////////////////////////
                // 높은 음 자리표
                Positioned(
                  top: (60 - 26.5).h,
                  bottom: 0.h,
                  left: 10.0.w,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/treble_clef_ff_cut.png',
                      height: 180.h,
                    ),
                  ),
                ),
                // 위에 오선
                returnLineHarmony(90.0, 26.5, -1, 'long'),
                returnLineHarmony(90.0, 26.5, 0, 'long'),
                returnLineHarmony(90.0, 26.5, 1, 'long'),
                returnLineHarmony(90.0, 26.5, 2, 'long'),
                returnLineHarmony(90.0, 26.5, 3, 'long'),

                // first note
                returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[0],
                    [90.0, 26.5, -1], 'high'),
                // seconde note
                returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[1],
                    [90.0, 26.5, -1], 'high'),
                //////////////////////////////////////////////////
                // 낮은음 자리표
                Positioned(
                  top: (60 + 26.5 * 7 + 29).h,
                  bottom: 0.h,
                  left: 13.0.w,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/low1.png',
                      height: 95.h,
                    ),
                  ),
                ),
                // 밑에 오선
                returnLineHarmony(90.0, 26.5, 7, 'long'),
                returnLineHarmony(90.0, 26.5, 8, 'long'),
                returnLineHarmony(90.0, 26.5, 9, 'long'),
                returnLineHarmony(90.0, 26.5, 10, 'long'),
                returnLineHarmony(90.0, 26.5, 11, 'long'),

                // first note
                returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[2],
                    [90.0, 26.5, -1], 'low'),
                // seconde note
                returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[3],
                    [90.0, 26.5, -1], 'low'),
              ],
            ),
          ),
          Container(
              width: 500,
              child: Divider(
                color: Colors.black12,
                thickness: 1.3,
                indent: 20,
                endIndent: 20,
              )),
          SizedBox(
            height: 10.h,
          ),
          AutoSizeText(
            '코드이름을 구하시오',
            style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
              width: 500,
              child: Divider(
                color: Colors.black12,
                thickness: 1.3,
                indent: 20,
                endIndent: 20,
              )),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              intervalNumberButton(viewList[0].toString()),
              intervalNumberButton(viewList[1].toString()),
              intervalNumberButton(viewList[2].toString()),
              intervalNumberButton(viewList[3].toString())
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
          SizedBox(
            height: 30.h,
          ),
        ],
      ),
    );
  }
}
