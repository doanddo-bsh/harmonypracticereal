
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_notes/music_notes.dart' as msc;
import 'package:harmonypracticereal/core/theme/app_colors.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:harmonypracticereal/core/ads/ad_ids.dart';
import 'package:harmonypracticereal/core/ads/banner_ad_slot.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/staff_geometry.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/staff_view.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/note_glyphs.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/answer_result_sheet.dart';
import "dart:math";
import 'package:harmonypracticereal/domain/harmony/problem_catalog.dart';
import 'package:harmonypracticereal/ui/quiz/result_page.dart';
import 'package:harmonypracticereal/domain/quiz/quiz_session.dart';
import 'package:provider/provider.dart';
import 'package:harmonypracticereal/core/ads/interstitial_trigger.dart';

class tonalityProblemType3 extends StatefulWidget {
  final Function? problemCallFunction;

  final String stageType;
  final List<String>? problemTypes ;
  tonalityProblemType3(this.problemCallFunction, this.stageType,
      {this.problemTypes,super.key});

  @override
  State<tonalityProblemType3> createState() =>
      _tonalityProblemType3State();
}

class _tonalityProblemType3State extends State<tonalityProblemType3> {
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
        style: answerButtonDesign(context),
        child: Text(
          stringAnswer,
          style: answerButtonTextDesign(context),
        ));
  }

  void showBottomResult(String? answerInterval) {
    // 정답 계산
    String? answerUser = answerInterval;
    String answerReal = condition.format();

    // // 해석 해설
    // String commentaryResult = commentaryKeyReturn(randomNoteAnswer,
    //     answerRealKor);

    if (answerUser == answerReal) {
      setState(() {
        numberOfRight += 1;
      });

      showAnswerResultSheet(
        context: context,
        isCorrect: true,
        headline: '정답입니다!',
        // 여기만 AutoSizeText 가 아니라 Text 다(오답 시트는 AutoSizeText).
        // 굳이 맞추지 않고 종전 그대로 둔다.
        answer: Text(
          '정답 : ${condition.format()}',
          style: TextStyle(
            color: context.colors.correctText,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        // nextProblem('다음문제','right')
        action: wrongProblemMode
            ? (wrongProblemsSave.length != problemNumber)
                ? wrongProblemNextProblem('다음문제', 'right')
                : showResult('right')
            : (problemNumber != 10)
                ? nextProblem('다음문제', 'right')
                : showResult('right'),
        // (problemNumber!=10)? nextProblem('다음문제') : showResult()
      );
    } else {
      wrongProblems += [
        [answer, problem, condition, problemOriginal, problemName]
      ];

      showAnswerResultSheet(
        context: context,
        isCorrect: false,
        // 느낌표가 없다. 유형 1 만 '오답입니다!' 다.
        headline: '오답입니다',
        answer: AutoSizeText(
          '정답 : ${condition.format()}',
          maxLines: 1,
          style: TextStyle(
            color: context.colors.wrongText,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        action: wrongProblemMode
            ? (wrongProblemsSave.length != problemNumber)
                ? wrongProblemNextProblem('다음문제', 'wrong')
                : showResult('wrong')
            : (problemNumber != 10)
                ? nextProblem('다음문제', 'wrong')
                : showResult('wrong'),
        // (problemNumber!=10)? nextProblem('다음문제') : showResult()
      );
    }
  }

  msc.Key getTonality() {
    int tempRandomInt = Random().nextInt(7); // Value is >= 0 and < 7

    List<msc.Note> note7 = [
      msc.Note.c,
      msc.Note.d,
      msc.Note.e,
      msc.Note.f,
      msc.Note.g,
      msc.Note.a,
      msc.Note.b
    ];

    int sharpFlatNatural = Random().nextInt(3); // Value is >= 0 and < 3
    int majorMinor = Random().nextInt(2); // Value is >= 0 and < 2

    if (sharpFlatNatural == 0) {
      if (majorMinor == 0) {
        return note7[tempRandomInt].sharp.major;
      } else {
        return note7[tempRandomInt].sharp.minor;
      }
    } else if (sharpFlatNatural == 1) {
      if (majorMinor == 0) {
        return note7[tempRandomInt].flat.major;
      } else {
        return note7[tempRandomInt].flat.minor;
      }
    } else {
      if (majorMinor == 0) {
        return note7[tempRandomInt].major;
      } else {
        return note7[tempRandomInt].minor;
      }
    }
  }

  // 보기 만들때 앞대가리가 정확하게 똑같을때 뒤의 메이저 마이너가 겹치면 안됨
  List<msc.Key> getViewListEasyType3(msc.Key nowCondition) {
    List<msc.Key> viewListTemp = [];
    List<msc.Note> viewListTempNote = [];

    viewListTemp.add(nowCondition);
    viewListTempNote.add(nowCondition.note);

    while (viewListTemp.length <= 3) {
      msc.Key wrongAnswerTemp = getTonality();

      if ((!viewListTemp.contains(wrongAnswerTemp)) &
          (!viewListTempNote.contains(wrongAnswerTemp.note))) {
        // 정답과 다르며
        // 다른 오답과 다른것 추가
        // note는 달라야함
        viewListTemp.add(wrongAnswerTemp);
        viewListTempNote.add(wrongAnswerTemp.note);
      }
    }

    viewListTemp.shuffle();

    return viewListTemp;
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
          positionedNoteList = [];
          while (positionedNoteList.length == 0) {
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

            positionedNoteList = noteToPositionedNote(problem);

            viewList = [];
            viewList = getViewListEasyType3(condition);

            answerUser = null;
            // 문제 보기 생성 ================================================
          }

          problemNumber += 1;
        });

        Navigator.pop(context);
      },
      style: nextProblemButtonStyle(context, 'easy', rightWrong),
      child: Text(
        buttonText,
        style: nextProblemButtonTextStyle(context),
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
      style: nextProblemButtonStyle(context, 'easy', rightWrong),
      child: Text(
        '결과보기',
        style: nextProblemButtonTextStyle(context),
      ),
    );
  }

  // for full screen ad
  InterstitialAd? _interstitialAd;

  /// Loads an interstitial ad.
  void loadAd() {
    // Android/iOS 가 아니면 AdMob 네이티브 채널이 없다. 예전에는 단위 ID 가
    // null 이라 아래 `!` 에서 죽었다. 그 보호막을 명시적인 가드로 옮긴다.
    if (!AdIds.adsAvailable) return;

    InterstitialAd.load(
        adUnitId: AdIds.interstitial,
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
            positionedNoteList = [];
            while (positionedNoteList.length == 0) {
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

              positionedNoteList = noteToPositionedNote(problem);

              viewList = [];
              viewList = getViewListEasyType3(condition);

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
          style: TextStyle(color: context.colors.mutedLabel, fontSize: 14),
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

          positionedNoteList = noteToPositionedNote(problem);

          viewList = [];
          viewList = getViewListEasyType3(condition);

          answerUser = null;
          // 문제 보기 생성 ================================================
        });

        Navigator.pop(context);
      },
      style: nextProblemButtonStyle(context, 'easy', rightWrong),
      child: Text(
        buttonText,
        style: nextProblemButtonTextStyle(context),
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

                positionedNoteList = noteToPositionedNote(problem);

                viewList = [];
                viewList = getViewListEasyType3(condition);

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
          backgroundColor: context.colors.retryButtonFill),
      child: Text(
        '틀린 문제 다시 풀기',
        style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: context.colors.mutedLabel),
      ),
    );
  }

  int problemNumber = 1;

  late (
    List<String>,
    List<msc.Note>,
    msc.Key,
    List<msc.Note>,
    String
  ) problemElements;

  late List<String> answer;

  List<msc.Key> viewList = [];

  late List<msc.Note> problem;

  late msc.Key condition;

  late List<msc.Note> problemOriginal;

  late String problemName;

  late List<msc.Pitch> positionedNoteList;

  // Random().nextInt(4); // Value is >= 0 and < 4.

  List<String> tellWhatMiss = ['베이스 찾아', '테너 찾아', '알토 찾아', '소프 찾아'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 새로운 문제 생성
    positionedNoteList = [];
    while (positionedNoteList.length == 0) {
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

      positionedNoteList = noteToPositionedNote(problem);

      viewList = [];
      viewList = getViewListEasyType3(condition);

      answerUser = null;
      // 문제 보기 생성 ================================================
    }
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
            // 다크에서 밝은 '종이' 면. 오선·음표가 검은 잉크 PNG 라서
            // 어두운 면 위에서는 보이지 않는다. 라이트에서는 투명이라
            // 종전과 동일하다.
            decoration: BoxDecoration(
                color: context.colors.staffSurface,
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
          // SizedBox(height: 30.h,),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text('정답 : ${answer}'
          //       ,style: TextStyle(fontSize: 30.sp),
          //     ),
          //     // answerTest,
          //   ],
          // ),
          Container(
              width: 500,
              child: Divider(
                color: context.colors.divider,
                thickness: 1.3,
                indent: 20,
                endIndent: 20,
              )),
          AutoSizeText(
            '조성을 구하시오',
            style: TextStyle(
                fontSize: 15.sp,
                color: context.colors.promptText,
                fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                '화성 :',
                style: TextStyle(
                    fontSize: 15.sp,
                    color: context.colors.promptText,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
              showHarmonyFromListShowOnly(answer, answerButtonTextDesignBlack54(context))
            ],
          ),
          Container(
              width: 500.w,
              child: Divider(
                color: context.colors.divider,
                thickness: 1.3,
                indent: 20,
                endIndent: 20,
              )),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              intervalNumberButton(viewList[0].format()),
              intervalNumberButton(viewList[1].format()),
              intervalNumberButton(viewList[2].format()),
              intervalNumberButton(viewList[3].format())
            ],
          ),
          const Expanded(child: SizedBox()),
          // admob banner
          const BannerAdSlot(),
          SizedBox(
            height: 30.h,
          ),
        ],
      ),
    );
  }
}
