// ignore_for_file: file_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../problemFunc/providerCounter.dart';
import 'package:music_notes/music_notes.dart' as msc;
import 'package:provider/provider.dart';
import '../problemFunc/colorList.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../problemFunc/admobClass.dart';
import '../problemFunc/admobFunc.dart';
import '../problemFunc/problemFunc.dart';
import '../problemFunc/problemFuncHarmony.dart';
import '../problemFunc/problemFuncDeco.dart';
import '../problemFunc/problemVarList.dart';
// import '../problemFunc/resultPage.dart';
import 'problemType1List.dart';
import "dart:math";
import '../../harmonyModul/modulBasic.dart';
import '../../harmonyModul/modulBasicMinor.dart';
import '../../harmonyModul/modulBorrowed.dart';
import '../../harmonyModul/modulProblemProbability.dart';
import '../problemFunc/resultPage.dart';

class tonalityProblemType1 extends StatefulWidget {
  const tonalityProblemType1({super.key});

  @override
  State<tonalityProblemType1> createState() => _tonalityProblemType1State();
}

class _tonalityProblemType1State extends State<tonalityProblemType1> {

  // for admob banner
  BannerAd? _banner;
  final _random = new Random();

  // 변수 초기화
  int numberOfRight = 0 ;
  bool wrongProblemMode = false ;

  List<List<dynamic>> wrongProblems = [];
  List<List<dynamic>> wrongProblemsSave = [];

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
  //         style: answerButtonTextDesign,
  //       )
  //   );
  // }

  void showBottomResult(List<String>? userChoiceAnswer){

    // 정답 계산
    List<String>? answerUser = userChoiceAnswer;
    List<String> answerReal = answer ;
    // List<dynamic> resultAll = getResultAllEasy(randomNote, false);
    //
    // // 정답 배분/입력
    // List<dynamic> randomNoteAnswer = resultAll[0] ;
    // String answerReal = resultAll[1] ;
    // String answerRealKor = resultAll[2] ;

    // // 해석 해설
    // String commentaryResult = commentaryKeyReturn(randomNoteAnswer,
    //     answerRealKor);

    if (answerUser == answerReal){

      setState(() {
        numberOfRight += 1 ;
      });

      showModalBottomSheet<void>(
        backgroundColor: color5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)
            )
        ),
        enableDrag: false,
        isDismissible:false,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 185.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 27.h,),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('정답입니다!',
                          style: TextStyle(
                              color: color4,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // commentaryToolTip(commentaryResult,
                        // ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 7,),
                // Text('정답 : $answerReal',
                //   style: TextStyle(
                //     color: color4,
                //     fontSize : 14.0,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('정답 : '), showHarmonyFromListShowOnly(answerReal)],
                ),
                const SizedBox(height: 7,),
                // nextProblem('다음문제','right')
                wrongProblemMode?
                (wrongProblemsSave.length != problemNumber)?
                wrongProblemNextProblem('다음문제','right') :
                showResult('right') :
                (problemNumber!=10)?
                nextProblem('다음문제','right') :
                showResult('right'),
                // (problemNumber!=10)? nextProblem('다음문제') : showResult()
              ],
            ),
          );
        },
      );

    } else {

      wrongProblems +=
      [[answer,problem,condition,problemOriginal, problemName]] ;


      showModalBottomSheet<void>(
        backgroundColor: const Color(0xffd7b1b1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)
            )
        ),
        enableDrag: false,
        isDismissible:false,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 185.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 27.h,),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('오답입니다',
                          style: TextStyle(
                              color:color6,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0
                          ),
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
                const SizedBox(height: 7,),
                // Text('정답 : $answerReal',
                //   style: TextStyle(
                //     color: color6,
                //     fontSize : 14.0,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('정답 : '), showHarmonyFromListShowOnly(answerReal)],
                ),
                // Text('정답은 ${answerRealKor} 입니다.'),
                // nextProblem('다음문제','wrong')
                wrongProblemMode?
                (wrongProblemsSave.length != problemNumber)?
                wrongProblemNextProblem('다음문제','wrong') :
                showResult('wrong') :
                (problemNumber!=10)?
                nextProblem('다음문제','wrong') :
                showResult('wrong'),
                // (problemNumber!=10)? nextProblem('다음문제') : showResult()
              ],
            ),
          );
        },
      );
    }
  }

  // 오답 가져오는 규칙
  // 기본 문제
  // 오답 3개 중
  // 2개는 기본
  // 1개는 7화음중 아무거나

  // 7화음이면
  // 오답3개 중
  // 기본 1개
  // 2개는 아무 7화음
  List<List<String>> getViewListEasyType1(List<String> answer,String
  problemName){

    List<List<String>> viewListTemp = [];

    // basic problemName list
    List<String> basicProblemList = ['basicProblem','basicProblemMinor'];
    // 7th problemName list
    List<String> th7ProblemList = ['secondaryDominant7thProblem','secondaryDominant7thProblemMinor'
    ,'secondaryDiminished7thProblem','secondaryDiminished7thProblemMinor'
    ,'secondaryHalfDiminished7thProblem','secondaryHalfDiminished7thProblemMinor'];

    viewListTemp.add(answer);

    // 기본인 경우
    if (basicProblemList.contains(problemName)){

      while(viewListTemp.length<=2){

        (List<String>, List<msc.Note>, msc.Tonality,List<msc.Note>,String)
        wrongAnswerTemp = getEasyProblemType134();

        if ((!viewListTemp.contains(wrongAnswerTemp.$1))
            &(basicProblemList.contains(wrongAnswerTemp.$5!))
            ){
              viewListTemp.add(wrongAnswerTemp.$1);
              }
      }

      while(viewListTemp.length<=3){

        (List<String>, List<msc.Note>, msc.Tonality,List<msc.Note>,String)
        wrongAnswerTemp = getEasyProblemType134();

        if ((!viewListTemp.contains(wrongAnswerTemp.$1))
        &(th7ProblemList.contains(wrongAnswerTemp.$5!))){
          viewListTemp.add(wrongAnswerTemp.$1);
        }
      }
    } else {
      while(viewListTemp.length<=2){

        (List<String>, List<msc.Note>, msc.Tonality,List<msc.Note>,String)
        wrongAnswerTemp = getEasyProblemType134();

        if ((!viewListTemp.contains(wrongAnswerTemp.$1))
        &(th7ProblemList.contains(wrongAnswerTemp.$5!))){
          viewListTemp.add(wrongAnswerTemp.$1);
        }
      }

      while(viewListTemp.length<=3){

        (List<String>, List<msc.Note>, msc.Tonality,List<msc.Note>,String)
        wrongAnswerTemp = getEasyProblemType134();

        if ((!viewListTemp.contains(wrongAnswerTemp.$1))
        &(basicProblemList.contains(wrongAnswerTemp.$5!))){
          viewListTemp.add(wrongAnswerTemp.$1);
        }
      }
    }

    viewListTemp.shuffle();

    print('viewListTemp $viewListTemp');

    return viewListTemp;
  }




  Widget nextProblem(String buttonText,String rightWrong){
    return ElevatedButton(

      onPressed: (){
        if (problemNumber==10){
          setState(() {
            problemNumber = 0;
          });
        }

        setState(() {

          positionedNoteList = [];
          while (positionedNoteList.length==0){

            problemElements = getEasyProblemType134();

            answer = problemElements.$1;
            problem = problemElements.$2;
            condition = problemElements.$3;
            problemOriginal = problemElements.$4;
            problemName = problemElements.$5;

            positionedNoteList =
                noteToPositionedNote(problem);

            viewList = [];
            viewList = getViewListEasyType1(answer,problemName);

            answerUser = null ;

          }

          problemNumber += 1;

          print('#######################################');
          print('problem $problem');
          print('answer $answer');
          print('condition $condition');
          print('#######################################');
        });

        Navigator.pop(context);

      },
      style: nextProblemButtonStyle('easy',rightWrong),
      child: Text(buttonText,
        style: nextProblemButtonTextStyle,
      ),
    );
  }


  Widget showResult(String rightWrong){

    // Navigator.pop(context);

    return ElevatedButton(
      onPressed: (){

        Navigator.pop(context);

        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          enableDrag: false,
          isDismissible:false,
          builder: (BuildContext context) {
            return resultPage(context,
              wrongProblemMode,
              numberOfRight,
              wrongProblemsSave,
              wrongProblems,
              nextProblemResult(),
              wrongProblemSolveStart('틀린 문제 다시 풀기'),
                  (){
                wrongProblems = [];
                wrongProblemMode = false ;
                numberOfRight = 0 ;
                Navigator.popUntil
                  (context, ModalRoute.withName("/FirstProblemTypeList"));
              },
            );
          },
        );
      },
      style: nextProblemButtonStyle('easy',rightWrong),
      child: Text('결과보기',
        style: nextProblemButtonTextStyle,
      ),
    );
  }


  Widget nextProblemResult(){
    return ElevatedButton(

        onPressed: (){

          numberOfRight = 0 ;
          wrongProblems = [];
          wrongProblemMode = false ;

          setState(() {

            positionedNoteList = [];
            while (positionedNoteList.length==0){

              problemElements = getEasyProblemType134();

              answer = problemElements.$1;
              problem = problemElements.$2;
              condition = problemElements.$3;
              problemOriginal = problemElements.$4;
              problemName = problemElements.$5;

              positionedNoteList =
                  noteToPositionedNote(problem);

              viewList = [];
              viewList = getViewListEasyType1(answer,problemName);

              answerUser = null ;
            }
            print('#######################################');
            print('problem $problem');
            print('answer $answer');
            print('condition $condition');
            print('#######################################');
          });

          setState(() {
            problemNumber = 1 ;
          });

          Navigator.pop(context);

        },  style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        )
    ),
        child: Text('네',
          style: TextStyle(
              color: Colors.grey[700]
          ),
        )
    );
  }


  Widget wrongProblemNextProblem(String buttonText, String rightWrong){
    return ElevatedButton(
      onPressed: (){

        setState(() {

          problemNumber += 1;

          // 문제 적용
          // randomNoteNumber = wrongProblemsSave[problemNumber-1];
          // randomNoteNumber.sort();

          answer = wrongProblemsSave[problemNumber-1][0];
          problem = wrongProblemsSave[problemNumber-1][1];
          condition = wrongProblemsSave[problemNumber-1][2];
          problemOriginal = wrongProblemsSave[problemNumber-1][3];
          problemName = wrongProblemsSave[problemNumber-1][4];

          positionedNoteList =
              noteToPositionedNote(problem);

          viewList = [];
          viewList = getViewListEasyType1(answer,problemName);

          answerUser = null ;

        });

        Navigator.pop(context);

      },
      style: nextProblemButtonStyle('easy',rightWrong),
      child: Text(buttonText,
        style: nextProblemButtonTextStyle,
      ),
    );
  }


  Widget wrongProblemSolveStart(String buttonText){
    return ElevatedButton(

      onPressed: (wrongProblems.isEmpty) ? null:(){

        numberOfRight = 0 ;
        // back up
        wrongProblemsSave = wrongProblems ;

        wrongProblems = [] ;

        setState(() {
          // 문제 적용
          answer = wrongProblemsSave[0][0];
          problem = wrongProblemsSave[0][1];
          condition = wrongProblemsSave[0][2];
          problemOriginal = wrongProblemsSave[0][3];
          problemName = wrongProblemsSave[0][4];

          positionedNoteList =
              noteToPositionedNote(problem);

          viewList = [];
          viewList = getViewListEasyType1(answer,problemName);

          answerUser = null ;
        });

        setState(() {
          problemNumber = 1 ;
          wrongProblemMode = true ;
        });

        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        // minimumSize: Size(100.w,50.h),
          backgroundColor: Colors.yellow[200]
      ),
      child: Text('틀린 문제 다시 풀기',
        style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700]
        ),
      ),
    );
  }

  int problemNumber = 1 ;

  late (List<String>, List<msc.Note>, msc.Tonality,List<msc.Note>,String)
  problemElements ;
  late List<String> answer ;
  List<List<String>> viewList = [] ;
  late List<msc.Note> problem ;
  late msc.Tonality condition ;
  late List<msc.Note> problemOriginal ;
  late String problemName ;

  late List<msc.PositionedNote> positionedNoteList ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 새로운 문제 생성
    positionedNoteList = [];
    while (positionedNoteList.length==0){
      problemElements = getEasyProblemType134();
      answer = problemElements.$1;
      problem = problemElements.$2;
      condition = problemElements.$3;
      problemOriginal = problemElements.$4;
      problemName = problemElements.$5;

      positionedNoteList =
          noteToPositionedNote(problem);

      viewList = getViewListEasyType1(answer,problemName);
    }
    print('#######################################');
    print('problem $problem');
    print('answer $answer');
    print('condition $condition');
    print('#######################################');

    // for admob banner
    _createBannerAd();
  }

  // admob banner
  void _createBannerAd(){
    _banner = BannerAd(
      size: AdSize.banner
      , adUnitId: AdMobServiceBanner.bannerAdUnitId!
      , listener: AdMobServiceBanner.bannerAdListener
      , request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: wrongProblemMode?
        Text("오답문제",
            style: appBarTitleStyle
        ) :
        Text("연습문제",
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
            'easy',
            context,
          ),
          Container(
            height: 450.h,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Stack(
              children: [
                //////////////////////////////////////////////////
                // 높은 음 자리표
                Positioned(
                  top: (60-26.5).h,
                  bottom: 0.h,
                  left: 10.0.w,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child:Image.asset('assets/treble_clef_ff_cut.png',
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
                returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[0]
                    , [90.0, 26.5, -1], 'high'),
                // seconde note
                returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[1]
                    , [90.0, 26.5, -1], 'high'),
                //////////////////////////////////////////////////
                // 낮은음 자리표
                Positioned(
                  top: (60+26.5*7+29).h,
                  bottom: 0.h,
                  left: 13.0.w,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child:Image.asset('assets/low1.png',
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
                returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[2]
                    , [90.0, 26.5, -1], 'low'),
                // seconde note
                returnNoteHarmonyFinal(90.5, 13.25, positionedNoteList[3]
                    , [90.0, 26.5, -1], 'low'),
              ],
            ),
          ),
          Container(height: 13,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${condition}'
                ,style: TextStyle(fontSize: 22.sp),
              ),
              // answerTest,료
            ],
          ),
          Container(height: 15,),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // showHarmonyFromList(['I','⊙','4','6','/','V','⊙','2','4'])
                  showHarmonyFromList(viewList[0],(){
                    setState(() {answerUser = viewList[0];});
                    showBottomResult(answerUser);
                  })
                  ,showHarmonyFromList(viewList[1],(){
                    setState(() {answerUser = viewList[1];});
                    showBottomResult(answerUser);
                  })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  showHarmonyFromList(viewList[2],(){
                    setState(() {answerUser = viewList[2];});
                    showBottomResult(answerUser);
                  })
                  ,showHarmonyFromList(viewList[3],(){
                    setState(() {answerUser = viewList[3];});
                    showBottomResult(answerUser);
                  })
                ],
              )
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
          SizedBox(height: 30.h,),
        ],
      ),
    );
  }
}
