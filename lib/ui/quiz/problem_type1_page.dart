
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

// import 'package:harmonypracticereal/ui/quiz/result_page.dart';
import "dart:math";
import 'package:harmonypracticereal/domain/harmony/problem_catalog.dart';
import 'package:harmonypracticereal/ui/quiz/result_page.dart';
import 'package:harmonypracticereal/domain/quiz/distractor_generator.dart';
import 'package:harmonypracticereal/domain/quiz/quiz_session.dart';
import 'package:harmonypracticereal/domain/quiz/quiz_flow.dart';
import 'package:provider/provider.dart';
import 'package:harmonypracticereal/core/ads/interstitial_trigger.dart';

class tonalityProblemType1 extends StatefulWidget {
  final Function? problemCallFunction;
  final String stageType;
  final List<String>? problemTypes ;

  tonalityProblemType1(
      this.problemCallFunction
      , this.stageType
      , {this.problemTypes, super.key}
      )
  ;

  @override
  State<tonalityProblemType1> createState() => _tonalityProblemType1State();
}

class _tonalityProblemType1State extends State<tonalityProblemType1> {
  final _random = new Random();

  // 풀이 진행 상태(점수·오답 노트·오답 모드·문제 번호)는 전부 여기 있다.
  // 화면은 상태를 직접 만지지 않고 `flow` 에 시킨 뒤 setState 를 부른다.
  final QuizFlow flow = QuizFlow();

  List<String>? answerUser = null;

  // Widget intervalNumberButton(String stringAnswer){
  //   return ElevatedButton(
  //       onPressed:(){
  //         setState(() {answerUser = stringAnswer;});
  //         showBottomResult(answerUser);
  //       },
  //       style: answerButtonDesign(answerUser,stringAnswer,'easy',context),
  //       child: Text(
  //         stringAnswer,
  //         style: answerButtonTextDesign(context),
  //       )
  //   );
  // }

  void showBottomResult(List<String>? userChoiceAnswer) {

    List<String>? answerUser = userChoiceAnswer;
    List<String> answerReal = answer;

    if (answerUser == answerReal) {
      setState(() {
        flow.recordCorrect();
      });

      showAnswerResultSheet(
        context: context,
        isCorrect: true,
        headline: '정답입니다!',
        answer: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              '정답 : ',
              maxLines: 1,
              style: TextStyle(
                  color: context.colors.correctText,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            showHarmonyFromListShowOnly(answerReal, answerRight(context))
          ],
        ),
        action: nextStepButton('right'),
      );
    } else {
      flow.recordWrong(
          [answer, problem, condition, problemOriginal, problemName]);

      showAnswerResultSheet(
        context: context,
        isCorrect: false,
        // 유형 1 만 느낌표가 붙어 있다. 나머지 셋은 '오답입니다' 다.
        headline: '오답입니다!',
        answer: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              '정답 : ',
              maxLines: 1,
              style: TextStyle(
                  color: context.colors.wrongText,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            showHarmonyFromListShowOnly(answerReal, answerWrong(context))
          ],
        ),
        action: nextStepButton('wrong'),
      );
    }
  }

  /// 시트 아래에 놓을 버튼 — 다음 문제로 갈지, 결과 화면으로 갈지.
  ///
  /// 종전에는 정답 시트와 오답 시트가 이 삼항식을 한 벌씩 갖고 있었다
  /// (네 화면 × 2 = 8벌). 판단은 `flow` 가 하고 여기서는 버튼만 고른다.
  Widget nextStepButton(String rightWrong) {
    if (!flow.hasNextProblem) return showResult(rightWrong);
    return flow.wrongProblemMode
        ? wrongProblemNextProblem('다음문제', rightWrong)
        : nextProblem('다음문제', rightWrong);
  }

  // 오답 가져오는 규칙 (DistractorGenerator 로 이관)
  // 기본(3화음) 문제면 오답 3개 중 2개는 3화음, 1개는 3화음이 아닌 것.
  // 3화음이 아닌 문제면 반대로 2개는 비3화음, 1개는 3화음.
  List<List<String>> getViewListEasyType1(
      List<String> answer, String problemName) {
    return DistractorGenerator.buildChoices(
      answer: answer,
      problemName: problemName,
      drawCandidate: () {
        final (
          List<String>,
          List<msc.Note>,
          msc.Key,
          List<msc.Note>,
          String
        ) candidate = widget.problemCallFunction!(widget.problemTypes);
        return (candidate.$1, candidate.$5);
      },
    );
  }

  Widget nextProblem(String buttonText, String rightWrong) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          positionedNoteList = [];
          while (positionedNoteList.isEmpty) {

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
            viewList = getViewListEasyType1(answer, problemName);

            answerUser = null;
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
              viewList = getViewListEasyType1(answer, problemName);

              answerUser = null;
            }
          });

          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Text(
          '네',
          style: TextStyle(
                color: context.colors.mutedLabel
                ,fontSize: 14
          ),
        ));
  }

  Widget wrongProblemNextProblem(String buttonText, String rightWrong) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          final index = flow.advanceInWrongProblemRound();
          final saved = flow.wrongProblemsSave[index];

          // 문제 적용
          // randomNoteNumber = wrongProblemsSave[problemNumber-1];
          // randomNoteNumber.sort();

          answer = saved[0];
          problem = saved[1];
          condition = saved[2];
          problemOriginal = saved[3];
          problemName = saved[4];

          positionedNoteList = noteToPositionedNote(problem);

          viewList = [];
          viewList = getViewListEasyType1(answer, problemName);

          answerUser = null;
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
                // 문제 적용
                answer = saved[0];
                problem = saved[1];
                condition = saved[2];
                problemOriginal = saved[3];
                problemName = saved[4];

                positionedNoteList = noteToPositionedNote(problem);

                viewList = [];
                viewList = getViewListEasyType1(answer, problemName);

                answerUser = null;
              });

              Navigator.pop(context);
            },
      style: ElevatedButton.styleFrom(
          // minimumSize: Size(70.w,50.h),
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

  List<List<String>> viewList = [];

  late List<msc.Note> problem;

  late msc.Key condition;

  late List<msc.Note> problemOriginal;

  late String problemName;

  late List<msc.Pitch> positionedNoteList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 새로운 문제 생성
    positionedNoteList = [];
    while (positionedNoteList.isEmpty) {
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

      viewList = getViewListEasyType1(answer, problemName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: flow.wrongProblemMode
            ? Text("오답 문제", style: appBarTitleStyle)
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

                // soperano
                returnNoteHarmonyFinal(
                    90.5,
                    13.25,
                    // msc.Pitch(msc.Note.b.flat,octave: 5)
                    positionedNoteList[0],
                    [90.0, 26.5, -1],
                    'high'),
                // alto
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

                // tener
                returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[2],
                    [90.0, 26.5, -1], 'low'),
                // base
                returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[3],
                    [90.0, 26.5, -1], 'low'),
              ],
            ),
          ),
          // Container(height: 20,),
          SizedBox(
              width: 500,
              height: 25,
              child: Divider(
                color: context.colors.divider,
                thickness: 1.3,
                indent: 20,
                endIndent: 20,
              )),
          AutoSizeText(
            '알맞은 화성을 구하시오',
            style: TextStyle(
                fontSize: 15.sp,
                color: context.colors.promptText,
                fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '조성 : ',
                style: TextStyle(
                    fontSize: 15.sp,
                    color: context.colors.promptText,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                condition.format(),
                style: TextStyle(
                    fontSize: 16.sp,
                    color: context.colors.promptText,
                    fontWeight: FontWeight.bold),
                // answerTest,료
              )
            ],
          ),
          Container(
              width: 500,
              height: 25,
              child: Divider(
                color: context.colors.divider,
                thickness: 1.3,
                indent: 20,
                endIndent: 20,
              )),
          SizedBox(
            height: 10.h,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // showHarmonyFromList(['I','⊙','4','6','/','V','⊙','2','4'])
                  showHarmonyFromList(context, viewList[0], () {
                    setState(() {
                      // for Full-page advertisement count solved problem
                      Provider.of<CounterClass>(context, listen: false)
                          .incrementSolvedProblemCount();
                      answerUser = viewList[0];
                    });
                    showBottomResult(answerUser);
                  }, answerButtonTextDesign(context)),
                  showHarmonyFromList(context, viewList[1], () {
                    setState(() {
                      Provider.of<CounterClass>(context, listen: false)
                          .incrementSolvedProblemCount();
                      answerUser = viewList[1];
                    });
                    showBottomResult(answerUser);
                  }, answerButtonTextDesign(context)),
                  showHarmonyFromList(context, viewList[2], () {
                    setState(() {
                      Provider.of<CounterClass>(context, listen: false)
                          .incrementSolvedProblemCount();
                      answerUser = viewList[2];
                    });
                    showBottomResult(answerUser);
                  }, answerButtonTextDesign(context)),
                  showHarmonyFromList(context, viewList[3], () {
                    setState(() {
                      Provider.of<CounterClass>(context, listen: false)
                          .incrementSolvedProblemCount();
                      answerUser = viewList[3];
                    });
                    showBottomResult(answerUser);
                  }, answerButtonTextDesign(context))
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     showHarmonyFromList(viewList[2],(){
              //       setState(() {answerUser = viewList[2];});
              //       showBottomResult(answerUser);
              //     })
              //     ,showHarmonyFromList(viewList[3],(){
              //       setState(() {answerUser = viewList[3];});
              //       showBottomResult(answerUser);
              //     })
              //   ],
              // )
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
