
import 'package:harmonypracticereal/core/theme/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_notes/music_notes.dart' as msc;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:harmonypracticereal/core/ads/ad_ids.dart';
import 'package:harmonypracticereal/core/ads/banner_ad_slot.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/staff_geometry.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/staff_view.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/note_glyphs.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/answer_result_sheet.dart';

// import 'package:harmonypracticereal/ui/quiz/result_page.dart';
import "dart:math";
import 'package:harmonypracticereal/domain/harmony/problem_catalog.dart';
import 'package:harmonypracticereal/ui/quiz/result_page.dart';
import 'package:harmonypracticereal/domain/quiz/quiz_session.dart';
import 'package:harmonypracticereal/domain/quiz/quiz_flow.dart';
import 'package:provider/provider.dart';
import 'package:harmonypracticereal/core/ads/interstitial_trigger.dart';

class tonalityProblemType2 extends StatefulWidget {
  final Function? problemCallFunction;

  final String stageType;
  final List<String>? problemTypes ;

  tonalityProblemType2(this.problemCallFunction, this.stageType, {this.problemTypes,super.key});

  @override
  State<tonalityProblemType2> createState() => _tonalityProblemType2State();
}

class _tonalityProblemType2State extends State<tonalityProblemType2> {
  // final _random = new Random();

  // 풀이 진행 상태(점수·오답 노트·오답 모드·문제 번호)는 전부 여기 있다.
  // 화면은 상태를 직접 만지지 않고 `flow` 에 시킨 뒤 setState 를 부른다.
  final QuizFlow flow = QuizFlow();

  String? answerUser = null;

  Widget intervalNumberButton(String stringAnswer) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            // for Full-page advertisement count solved problem
            Provider.of<CounterClass>(context, listen: false)
                .incrementSolvedProblemCount();
            answerUser = stringAnswer;
          });
          showBottomResult(answerUser);
        },
        style: answerButtonDesign(context),
        // style: ElevatedButton.styleFrom(
        //   minimumSize: Size(80.w,43.h)
        //   ,shape: RoundedRectangleBorder(	//모서리를 둥글게
        //     borderRadius: BorderRadius.circular(15)
        //   )
        //   ,foregroundColor: color10
        //   ,backgroundColor: color10
        //     ,disabledBackgroundColor: color10
        //     ,disabledForegroundColor: color10
        //   ,shadowColor: Colors.grey.withOpacity(0.7)
        // ),
        child: Text(
          stringAnswer,
          style: answerButtonTextDesign(context),
        ));
  }

  void showBottomResult(String? answerInterval) {
    // 정답 계산
    String? answerUser = answerInterval;
    String answerReal = easyProblemType2Answer;

    // // 해석 해설
    // String commentaryResult = commentaryKeyReturn(randomNoteAnswer,
    //     answerRealKor);

    if (answerUser == answerReal) {
      setState(() {
        flow.recordCorrect();
      });

      showAnswerResultSheet(
        context: context,
        isCorrect: true,
        headline: '정답입니다!',
        answer: AutoSizeText(
          '정답 : $easyProblemType2Answer',
          maxLines: 1,
          style: TextStyle(
            color: context.colors.correctText,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        action: nextStepButton('right'),
      );
    } else {
      flow.recordWrong(
          [answer, problem, condition, problemOriginal, problemName, intValue]);

      showAnswerResultSheet(
        context: context,
        isCorrect: false,
        // 느낌표가 없다. 유형 1 만 '오답입니다!' 다.
        headline: '오답입니다',
        answer: AutoSizeText(
          '정답 : $easyProblemType2Answer',
          maxLines: 1,
          style: TextStyle(
            color: context.colors.wrongText,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Text('정답은 ${answerRealKor} 입니다.'),
        action: nextStepButton('wrong'),
      );
    }
  }

  /// 시트 아래에 놓을 버튼 — 다음 문제로 갈지, 결과 화면으로 갈지.
  Widget nextStepButton(String rightWrong) {
    if (!flow.hasNextProblem) return showResult(rightWrong);
    return flow.wrongProblemMode
        ? wrongProblemNextProblem('다음문제', rightWrong)
        : nextProblem('다음문제', rightWrong);
  }

  String getRandomNoteString() {
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

    msc.Note choicedNote = note7[tempRandomInt];

    int tempRandomInt2 = Random().nextInt(100); // Value is >= 0 and < 100

    if (tempRandomInt2 <= 30) {
      return choicedNote.format();
    } else if (tempRandomInt2 <= 60) {
      return choicedNote.sharp.format();
    } else if (tempRandomInt2 <= 90) {
      return choicedNote.flat.format();
    } else if (tempRandomInt2 <= 95) {
      return choicedNote.sharp.sharp.format();
    } else {
      return choicedNote.flat.flat.format();
    }
  }

  List<String> getViewListEasyType2(String answer) {
    List<String> viewListTemp = [];

    viewListTemp.add(answer);

    while (viewListTemp.length <= 3) {
      String wrongAnswerTemp = getRandomNoteString();

      if (wrongAnswerTemp != answer) {
        // 정답과 다르며
        if (!viewListTemp.contains(wrongAnswerTemp)) {
          // 다른 오답과 다른것 추가
          viewListTemp.add(wrongAnswerTemp);
        }
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
        setState(() {
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
            intValue = Random().nextInt(4); // Value is >= 0 and < 4.

            easyProblemType2Answer = problem[intValue].format();

            positionedNoteList = noteToPositionedNote(problem);

            viewList = [];
            viewList = getViewListEasyType2(easyProblemType2Answer);

            answerUser = null;
            // 문제 보기 생성 ================================================
          }

          flow.advanceToNextProblem();
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
              flow.wrongProblemMode,
              flow.numberOfRight,
              flow.wrongProblemsSave,
              flow.wrongProblems,
              nextProblemResult(),
              wrongProblemSolveStart('틀린 문제 다시 풀기'),
              () {
                flow.abandonStage();
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
          // 전면광고는 앱 전체 누적 풀이 수가 기준이다(한 판의 점수가 아니다).
          // `loadAd()` 는 비동기라 방금 부른 적재가 이 자리에서 끝나 있지
          // 않다 — 그래서 실제로 뜨는 것은 **지난번에 적재해 둔** 광고이고,
          // 카운터도 실제로 띄웠을 때만 되돌린다. 종전 그대로다.
          final counter = Provider.of<CounterClass>(context, listen: false);
          if (shouldShowInterstitial(counter.solvedProblemCount)) {
            loadAd();
            if (_interstitialAd != null) {
              _interstitialAd?.show();
              counter.resetSolvedProblemCount();
            }
          }

          flow.startNewStage();

          setState(() {
            positionedNoteList = [];
            while (positionedNoteList.isEmpty) {
              // // 문제 보기 생성 ================================================
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
              intValue = Random().nextInt(4); // Value is >= 0 and < 4.

              easyProblemType2Answer = problem[intValue].format();

              positionedNoteList = noteToPositionedNote(problem);

              viewList = [];
              viewList = getViewListEasyType2(easyProblemType2Answer);

              answerUser = null;
              // 문제 보기 생성 ================================================
            }
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
          final index = flow.advanceInWrongProblemRound();
          final saved = flow.wrongProblemsSave[index];

          // 문제 보기 생성 ================================================
          answer = saved[0];
          problem = saved[1];
          condition = saved[2];
          problemOriginal = saved[3];
          problemName = saved[4];
          // 예전에는 `intValue = problemName = saved[5];` 로 체인 대입이라
          // String 필드인 problemName 에 int 가 들어가 터졌다.
          // (오답 복습에서 2번째 문제로 넘어가는 순간 TypeError)
          // 같은 파일 wrongProblemSolveStart 는 처음부터 아래 형태였다.
          intValue = saved[5];

          easyProblemType2Answer = problem[intValue].format();

          positionedNoteList = noteToPositionedNote(problem);

          viewList = [];
          viewList = getViewListEasyType2(easyProblemType2Answer);

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
      onPressed: (!flow.canStartWrongProblemRound)
          ? null
          : () {
              // 순서 주의: 오답 목록이 출제 목록으로 넘어간 **뒤에야**
              // wrongProblemsSave 를 읽어야 한다.
              final index = flow.startWrongProblemRound();
              final saved = flow.wrongProblemsSave[index];

              setState(() {
                // 문제 보기 생성 ================================================
                answer = saved[0];
                problem = saved[1];
                condition = saved[2];
                problemOriginal = saved[3];
                problemName = saved[4];
                intValue = saved[5];

                easyProblemType2Answer = problem[intValue].format();

                positionedNoteList = noteToPositionedNote(problem);

                viewList = [];
                viewList = getViewListEasyType2(easyProblemType2Answer);
                // 문제 보기 생성 ================================================

                answerUser = null;
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

  late (
    List<String>,
    List<msc.Note>,
    msc.Key,
    List<msc.Note>,
    String
  ) problemElements;

  late List<String> answer;

  List<String> viewList = [];

  late List<msc.Note> problem;

  late msc.Key condition;

  late List<msc.Note> problemOriginal;

  late String problemName;

  late String easyProblemType2Answer;

  late List<msc.Pitch> positionedNoteList;

  int intValue = 0;

  // Random().nextInt(4); // Value is >= 0 and < 4.

  List<String> tellWhatMiss = [
    '베이스에 들어갈 알맞은 음을 고르시오',
    '테너에 들어갈 알맞은 음을 고르시오',
    '알토에 들어갈 알맞은 음을 고르시오',
    '소프라노에 들어갈 알맞은 음을 고르시오'
  ];

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
      intValue = Random().nextInt(4); // Value is >= 0 and < 4.

      easyProblemType2Answer = problem[intValue].format();

      positionedNoteList = noteToPositionedNote(problem);

      viewList = [];
      viewList = getViewListEasyType2(easyProblemType2Answer);

      answerUser = null;
      // 문제 보기 생성 ================================================
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: flow.wrongProblemMode
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
            flow.wrongProblemMode,
            flow.problemNumber,
            flow.wrongProblemsSave,
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
            // 다크에서 밝은 '종이' 면 (staffSurface 주석 참고).
            decoration: BoxDecoration(color: context.colors.staffSurface),
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
                intValue == 3
                    ? const SizedBox()
                    : returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[0],
                        [90.0, 26.5, -1], 'high'),
                // seconde note
                intValue == 2
                    ? const SizedBox()
                    : returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[1],
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
                intValue == 1
                    ? const SizedBox()
                    : returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[2],
                        [90.0, 26.5, -1], 'low'),
                // seconde note
                intValue == 0
                    ? const SizedBox()
                    : returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[3],
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
            '${tellWhatMiss[intValue]}',
            style: TextStyle(
                fontSize: 15.sp,
                color: context.colors.promptText,
                fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  AutoSizeText(
                    '조 : ',
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: context.colors.promptText,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  AutoSizeText(
                    condition.format(),
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: context.colors.promptText,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 13,
                color: context.colors.tileSeparator,
              ),
              Row(
                children: [
                  AutoSizeText(
                    '화성 :',
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: context.colors.promptText,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  showHarmonyFromListShowOnly(
                      answer, answerButtonTextDesignBlack54(context))
                ],
              ),
            ],
          ),
          Container(
              width: 500,
              child: Divider(
                color: context.colors.divider,
                thickness: 1.3,
                indent: 20,
                endIndent: 20,
              )),
          Container(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              intervalNumberButton(viewList[0]),
              intervalNumberButton(viewList[1]),
              intervalNumberButton(viewList[2]),
              intervalNumberButton(viewList[3])
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
