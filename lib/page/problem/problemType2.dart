// ignore_for_file: file_names

import 'package:harmonypracticereal/page/problemFunc/colorList.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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

class tonalityProblemType2 extends StatefulWidget {

  final Function? problemCallFunction ;

  tonalityProblemType2(this.problemCallFunction,{super.key});

  @override
  State<tonalityProblemType2> createState() => _tonalityProblemType2State();
}

class _tonalityProblemType2State extends State<tonalityProblemType2> {

  // for admob banner
  BannerAd? _banner;
  // final _random = new Random();

  // 변수 초기화
  int numberOfRight = 0 ;
  bool wrongProblemMode = false ;

  List<List<dynamic>> wrongProblems = [];
  List<List<dynamic>> wrongProblemsSave = [];

  String? answerUser = null;

  Widget intervalNumberButton(String stringAnswer){
    return ElevatedButton(
        onPressed:(){
          setState(() {answerUser = stringAnswer;});
          showBottomResult(answerUser);
        },
        style: answerButtonDesign(),
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
          style: answerButtonTextDesign,
        )
    );
  }

  void showBottomResult(String? answerInterval){

    // 정답 계산
    String? answerUser = answerInterval;
    String answerReal = easyProblemType2Answer ;

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
                Text('정답 : $easyProblemType2Answer',
                  style: TextStyle(
                    color: color4,
                    fontSize : 14.0,
                    fontWeight: FontWeight.bold,
                  ),
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
      [[answer,problem,condition,problemOriginal, problemName, intValue]] ;


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
                Text('정답 : $easyProblemType2Answer',
                  style: TextStyle(
                    color: color6,
                    fontSize : 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7,),
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

  String getRandomNoteString(){

    int tempRandomInt = Random().nextInt(7); // Value is >= 0 and < 7

    List<msc.Note> note7 =
    [msc.Note.c
      ,msc.Note.d
      ,msc.Note.e
      ,msc.Note.f
      ,msc.Note.g
      ,msc.Note.a
      ,msc.Note.b
    ];

    msc.Note choicedNote = note7[tempRandomInt];

    int tempRandomInt2 = Random().nextInt(100); // Value is >= 0 and < 100

    if (tempRandomInt2<=30){
      return choicedNote.toString();
    } else if (tempRandomInt2<=60){
      return choicedNote.sharp.toString();
    } else if (tempRandomInt2<=90){
      return choicedNote.flat.toString();
    } else if (tempRandomInt2<=95){
      return choicedNote.sharp.sharp.toString();
    } else {
      return choicedNote.flat.flat.toString();
    }
  }

  List<String> getViewListEasyType2(String answer){

    List<String> viewListTemp = [];

    viewListTemp.add(answer);

    while(viewListTemp.length<=3){

      String wrongAnswerTemp = getRandomNoteString();

      if (wrongAnswerTemp!=answer){
        // 정답과 다르며
        if (!viewListTemp.contains(wrongAnswerTemp)){
          // 다른 오답과 다른것 추가
          viewListTemp.add(wrongAnswerTemp);
        }
      }
    }

    viewListTemp.shuffle();

    print('viewListTemp $viewListTemp');

    return viewListTemp;
  }

  double answerSizeHeight = 50.2.h;
  double heightToWidth = 0.3;

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
            // 문제 보기 생성 ================================================
            problemElements = widget.problemCallFunction!();

            answer = problemElements.$1;
            problem = problemElements.$2;
            condition = problemElements.$3;
            problemOriginal = problemElements.$4;
            problemName = problemElements.$5;
            intValue = Random().nextInt(4); // Value is >= 0 and < 4.

            easyProblemType2Answer = problem[intValue].toString();

            positionedNoteList =
                noteToPositionedNote(problem);

            viewList = [];
            viewList = getViewListEasyType2(easyProblemType2Answer);

            answerUser = null ;
            // 문제 보기 생성 ================================================
          }

          problemNumber += 1;

          print('#######################################');
          print('problem $problem');
          print('answer $answer');
          print('condition $condition');
          print('easyProblemType2Answer $easyProblemType2Answer');
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

          // show full ad if problemSolvedCount more then 30
          // if (Provider.of<CounterClass>(context, listen: false)
          //     .solvedProblemCount >= criticalNumberSolved) {
          //   loadAd();
          //   if (_interstitialAd != null) {
          //     _interstitialAd?.show();
          //     Provider.of<CounterClass>(context, listen: false)
          //         .resetSolvedProblemCount();
          //   }
          // }

          numberOfRight = 0 ;
          wrongProblems = [];
          wrongProblemMode = false ;

          setState(() {

            positionedNoteList = [];
            while (positionedNoteList.length==0){
              // 문제 보기 생성 ================================================
              problemElements = widget.problemCallFunction!();

              answer = problemElements.$1;
              problem = problemElements.$2;
              condition = problemElements.$3;
              problemOriginal = problemElements.$4;
              problemName = problemElements.$5;
              intValue = Random().nextInt(4); // Value is >= 0 and < 4.

              easyProblemType2Answer = problem[intValue].toString();

              positionedNoteList =
                  noteToPositionedNote(problem);

              viewList = [];
              viewList = getViewListEasyType2(easyProblemType2Answer);

              answerUser = null ;
              // 문제 보기 생성 ================================================
            }
            print('#######################################');
            print('problem $problem');
            print('answer $answer');
            print('condition $condition');
            print('easyProblemType2Answer $easyProblemType2Answer');
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

          // 문제 보기 생성 ================================================
          answer = wrongProblemsSave[problemNumber-1][0];
          problem = wrongProblemsSave[problemNumber-1][1];
          condition = wrongProblemsSave[problemNumber-1][2];
          problemOriginal = wrongProblemsSave[problemNumber-1][3];
          problemName = wrongProblemsSave[problemNumber-1][4];
          intValue = problemName = wrongProblemsSave[problemNumber-1][5];

          easyProblemType2Answer = problem[intValue].toString();

          positionedNoteList =
              noteToPositionedNote(problem);

          viewList = [];
          viewList = getViewListEasyType2(easyProblemType2Answer);

          answerUser = null ;
          // 문제 보기 생성 ================================================
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
          // 문제 보기 생성 ================================================
          answer = wrongProblemsSave[0][0];
          problem = wrongProblemsSave[0][1];
          condition = wrongProblemsSave[0][2];
          problemOriginal = wrongProblemsSave[0][3];
          problemName = wrongProblemsSave[0][4];
          intValue = wrongProblemsSave[0][5];

          easyProblemType2Answer = problem[intValue].toString();

          positionedNoteList =
              noteToPositionedNote(problem);

          viewList = [];
          viewList = getViewListEasyType2(easyProblemType2Answer);
          // 문제 보기 생성 ================================================

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
  List<String> viewList = [] ;
  late List<msc.Note> problem ;
  late msc.Tonality condition ;
  late List<msc.Note> problemOriginal ;
  late String problemName ;
  late String easyProblemType2Answer ;

  late List<msc.PositionedNote> positionedNoteList ;
  int intValue = 0;
  // Random().nextInt(4); // Value is >= 0 and < 4.

  List<String> tellWhatMiss = [
    '베이스에 들어갈 알맞은 음을 고르시오'
    ,'테너에 들어갈 알맞은 음을 고르시오'
    ,'알토에 들어갈 알맞은 음을 고르시오'
    ,'소프라노에 들어갈 알맞은 음을 고르시오'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 새로운 문제 생성
    positionedNoteList = [];
    while (positionedNoteList.length==0){
      // 문제 보기 생성 ================================================
      problemElements = widget.problemCallFunction!();

      answer = problemElements.$1;
      problem = problemElements.$2;
      condition = problemElements.$3;
      problemOriginal = problemElements.$4;
      problemName = problemElements.$5;
      intValue = Random().nextInt(4); // Value is >= 0 and < 4.

      easyProblemType2Answer = problem[intValue].toString();

      positionedNoteList =
          noteToPositionedNote(problem);

      viewList = [];
      viewList = getViewListEasyType2(easyProblemType2Answer);

      answerUser = null ;
      // 문제 보기 생성 ================================================
    }
    print('#######################################');
    print('problem $problem');
    print('answer $answer');
    print('condition $condition');
    print('easyProblemType2Answer $easyProblemType2Answer');
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
        Text("Basic",
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
          SizedBox(height: 5.h,),
          Container(
            height: 425.h,
            width: double.infinity,
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
                intValue==3?SizedBox():returnNoteHarmonyFinal(90.5, 13.25,
                    positionedNoteList[0]
                    , [90.0, 26.5, -1], 'high'),
                // seconde note
                intValue==2?SizedBox():returnNoteHarmonyFinal(90.5, 13.25,
                    positionedNoteList[1]
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
                intValue==1?SizedBox():returnNoteHarmonyFinal(90.5, 13.25,
                    positionedNoteList[2]
                    , [90.0, 26.5, -1], 'low'),
                // seconde note
                intValue==0?SizedBox():returnNoteHarmonyFinal(90.5, 13.25,
                    positionedNoteList[3]
                    , [90.0, 26.5, -1], 'low'),
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
          Container(width: 500,
              child: Divider(color: Colors.black12, thickness: 1.3,indent: 20,endIndent: 20,)),
          AutoSizeText('${tellWhatMiss[intValue]}'
            ,style: TextStyle(fontSize: 15.sp,color: Colors.black54,
                fontWeight: FontWeight.bold)
            ,maxLines: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  AutoSizeText('조 : '
                    ,style: TextStyle(fontSize: 15.sp,color: Colors.black54,
                        fontWeight: FontWeight.bold)
                    ,maxLines: 1,
                  ),
                  AutoSizeText('${condition}'
                    ,style: TextStyle(fontSize: 15.sp,color: Colors.black54,
                        fontWeight: FontWeight.bold)
                    ,maxLines: 1,
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 13,
                color: Colors.grey,
              ),
              Row(
                children: [
                  AutoSizeText('화성 :'
                    ,style: TextStyle(fontSize: 15.sp,color: Colors.black54,
                        fontWeight: FontWeight.bold)
                    ,maxLines: 1,
                  ),
                  showHarmonyFromListShowOnly(answer,answerButtonTextDesignBlack54)
                ],
              ),
            ],
          ),
          Container(width: 500,
              child: Divider(color: Colors.black12, thickness: 1.3,indent: 20,endIndent: 20,)),
          Container(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              intervalNumberButton(viewList[0])
              ,intervalNumberButton(viewList[1])
              ,intervalNumberButton(viewList[2])
              ,intervalNumberButton(viewList[3])
            ],
          )
          ,const Expanded(child: SizedBox()),

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
