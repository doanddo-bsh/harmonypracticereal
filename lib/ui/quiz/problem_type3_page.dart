
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_notes/music_notes.dart' as msc;
import 'package:harmonypracticereal/core/theme/app_colors.dart';
import 'package:harmonypracticereal/ui/quiz/quiz_page_scaffold.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/staff_geometry.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/staff_view.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/note_glyphs.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/answer_result_sheet.dart';
import "dart:math";
import 'package:harmonypracticereal/domain/harmony/problem_catalog.dart';
import 'package:harmonypracticereal/ui/quiz/result_page.dart';
import 'package:harmonypracticereal/domain/quiz/quiz_session.dart';
import 'package:harmonypracticereal/domain/quiz/quiz_flow.dart';
import 'package:provider/provider.dart';
import 'package:harmonypracticereal/core/ads/interstitial_ad_slot.dart';

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

  // 풀이 진행 상태(점수·오답 노트·오답 모드·문제 번호)는 전부 여기 있다.
  // 화면은 상태를 직접 만지지 않고 `flow` 에 시킨 뒤 setState 를 부른다.
  final QuizFlow flow = QuizFlow();

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
        flow.recordCorrect();
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
        action: nextStepButton('right'),
      );
    } else {
      flow.recordWrong(
          [answer, problem, condition, problemOriginal, problemName]);

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
  //
  // 적재·표시·해제는 InterstitialAdSlot 이 통째로 쥔다. 이 화면은 슬롯을
  // 하나 들고 아래 dispose() 에서 놓아 주는 것만 한다. 예전에는 화면마다
  // 같은 loadAd() 를 복제해 갖고 있으면서 아무도 해제하지 않았다(B2 와 같은
  // 누수).
  final InterstitialAdSlot _interstitial = InterstitialAdSlot();

  @override
  void dispose() {
    _interstitial.dispose();
    super.dispose();
  }

  Widget nextProblemResult() {
    return ElevatedButton(
        onPressed: () {
          // 전면광고는 앱 전체 누적 풀이 수가 기준이다(한 판의 점수가 아니다).
          // 적재가 비동기라 방금 부른 적재는 이 자리에서 끝나 있지 않다 —
          // 그래서 실제로 뜨는 것은 **지난번에 적재해 둔** 광고이고, 카운터도
          // 실제로 띄웠을 때만 되돌린다. 종전 그대로다.
          final counter = Provider.of<CounterClass>(context, listen: false);
          if (_interstitial.loadAndMaybeShow(counter.solvedProblemCount)) {
            counter.resetSolvedProblemCount();
          }

          flow.startNewStage();

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

                positionedNoteList = noteToPositionedNote(problem);

                viewList = [];
                viewList = getViewListEasyType3(condition);

                answerUser = null;
                // 문제 보기 생성 ================================================
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
    // 앱바·진행률·오선 그릇·배너는 네 화면이 똑같아 QuizPageScaffold 로 갔다.
    // 여기 남은 것은 "무엇을 그리는가" 뿐이다 — 오선 내용, 안내문·구분선,
    // 보기 버튼. 그 셋의 순서와 여백은 종전 build() 그대로다.
    return QuizPageScaffold(
      stageType: widget.stageType,
      wrongProblemMode: flow.wrongProblemMode,
      // 유형 2·3·4 는 붙여 쓴다. 띄어쓰기가 있는 것은 유형 1 뿐이다.
      wrongModeTitle: '오답문제',
      problemNumber: flow.problemNumber,
      wrongProblemsSave: flow.wrongProblemsSave,
      // Text(widget.problemTypes.toString()),
      // Text(problemName.toString()),
      // Text(condition.toString()),
      problemArea: _staff(context),
      betweenProblemAndAnswer: _prompt(context),
      answerArea: _answerButtons(context),
    );
  }

  /// 오선 영역 — 425.h 짜리 그릇 안에 들어갈 내용. 그릇은 껍데기가 만든다.
  Widget _staff(BuildContext context) {
    return Stack(
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
    );
  }

  /// 오선과 보기 버튼 **사이** — 구분선 · 안내문 · 화성 Row · 구분선 · 여백.
  ///
  /// 종전 build() 의 5개 자식을 순서·여백 그대로 옮겼다. **두 번째 구분선만
  /// `500.w` 다** — 첫 번째와 다른 유형 셋은 전부 생짜 `500` 이다. 실제로
  /// 폭이 달라 보이는 값이라 맞추지 않고 그대로 뒀다
  /// (QuizPageScaffold 주석의 표 · quiz_layout_snapshot_test 가 못 박는다).
  List<Widget> _prompt(BuildContext context) {
    return [
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
    ];
  }

  /// 보기 버튼 영역 — 유형 3 은 Row 하나다(유형 1 은 Column 이 감쌌다).
  Widget _answerButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        intervalNumberButton(viewList[0].format()),
        intervalNumberButton(viewList[1].format()),
        intervalNumberButton(viewList[2].format()),
        intervalNumberButton(viewList[3].format())
      ],
    );
  }
}
