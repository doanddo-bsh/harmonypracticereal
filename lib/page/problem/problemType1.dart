// ignore_for_file: file_names

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


class tonalityProblemType1 extends StatefulWidget {
  const tonalityProblemType1({super.key});

  @override
  State<tonalityProblemType1> createState() => _tonalityProblemType1State();
}

class _tonalityProblemType1State extends State<tonalityProblemType1> {

  // for admob banner
  BannerAd? _banner;
  final _random = new Random();

  late (String, List<msc.Note>, msc.Tonality) problemElements ;
  late String answer ;
  late List<msc.Note> problem ;
  late msc.Tonality condition ;

  late List<msc.PositionedNote> positionedNoteList ;


  String? answerUser = null;
  Widget intervalNumberButton(String stringAnswer){
    return ElevatedButton(
        onPressed:(){
          setState(() {answerUser = stringAnswer;});
          showBottomResult(answerUser);
        },
        style: answerButtonDesign(answerUser,stringAnswer,'easy',context),
        child: Text(
          stringAnswer,
          style: answerButtonTextDesign,
        )
    );
  }

  void showBottomResult(String? answerInterval){

    // 정답 계산
    String? answerUser = answerInterval;
    String answerReal = answer;
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

      // setState(() {
      //   numberOfRight += 1 ;
      // });

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
                Text('정답 : $answerReal',
                  style: TextStyle(
                    color: color4,
                    fontSize : 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7,),
                nextProblem('다음문제','right')
                // wrongProblemMode?
                // (wrongProblemsSave.length != problemNumber)?
                // wrongProblemNextProblem('다음문제','right') :
                // showResult('right') :
                // (problemNumber!=10)?
                // nextProblem('다음문제','right') :
                // showResult('right'),
                // (problemNumber!=10)? nextProblem('다음문제') : showResult()
              ],
            ),
          );
        },
      );

    } else {

      // wrongProblems += [randomNoteNumber] ;

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
                Text('정답 : $answerReal',
                  style: TextStyle(
                    color: color6,
                    fontSize : 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7,),
                // Text('정답은 ${answerRealKor} 입니다.'),
                nextProblem('다음문제','wrong')
                // wrongProblemMode?
                // (wrongProblemsSave.length != problemNumber)?
                // wrongProblemNextProblem('다음문제','wrong') :
                // showResult('wrong') :
                // (problemNumber!=10)?
                // nextProblem('다음문제','wrong') :
                // showResult('wrong'),
                // (problemNumber!=10)? nextProblem('다음문제') : showResult()
              ],
            ),
          );
        },
      );
    }
  }


  Widget nextProblem(String buttonText,String rightWrong){
    return ElevatedButton(

      onPressed: (){
        // if (problemNumber==10){
        //   setState(() {
        //     problemNumber = 0;
        //   });
        // }

        // List<List<dynamic>> noteHeightListProblem = getProblemListNote(
        //   note_height_list,
        //   randomItems,
        // );

        setState(() {
          positionedNoteList = [];
          while (positionedNoteList.length==0){

            problemElements = getEasyProblem();

            answer = problemElements.$1;
            problem = problemElements.$2;
            condition = problemElements.$3;

            positionedNoteList =
                noteToPositionedNote(problem);

            print('##########################################');
            print('condition $condition');
            print('problem satb 순서 ${problem[3]} ${problem[2]} '
                '${problem[1]} ${problem[0]}');
            print('positionedNoteList satb $positionedNoteList');
            print('answer $answer');

            answerUser = null ;
          }
        });

        Navigator.pop(context);

      },
      style: nextProblemButtonStyle('easy',rightWrong),
      child: Text(buttonText,
        style: nextProblemButtonTextStyle,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 새로운 문제 생성
    positionedNoteList = [];
    while (positionedNoteList.length==0){
      problemElements = getEasyProblem();
      answer = problemElements.$1;
      problem = problemElements.$2;
      condition = problemElements.$3;

      positionedNoteList =
          noteToPositionedNote(problem);

      print('problem $problem');
      print('positionedNoteList $positionedNoteList');
    }

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

  bool wrongProblemMode = false ;

  @override
  Widget build(BuildContext context) {
    //
    // Map<int, List<dynamic>> problemType1List =
    // {
    // //   // 문제번호 / 음표위치 / 정답  [-4,7,10,14]
    //   189:[[msc.Note.b.inOctave(5)
    //     ,msc.Note.b.inOctave(3)
    //     ,msc.Note.d.inOctave(4)
    //     ,msc.Note.d.inOctave(2)]
    //     ,[100.0,'vii','4','6',]
    //     ,'Em(5b)/Bb'
    //     ,msc.Note.f.major],
    //
    //
    // };
    //
    // Map<int, List<dynamic>> problemListShow = problemType1List ;
    //
    // int problemShowNumber = 189 ;

    // 4:[[-3,6,14,25],harmonyExpressionFinal(100,'VI','7','2','/','I','1','2'),],
    // List<dynamic> problemInfo = problemListShow[problemShowNumber]!;
    // List<dynamic> answerInfo = problemListShow[problemShowNumber]![1]!;

    // print(Note.c.sharp.inOctave(3)) ;
    // print(Note.c.sharp.inOctave(3).note.flat.inOctave(Note.c.sharp.inOctave(3).octave)) ;
    //
    // print(Note.c.flat.inOctave(3)) ;
    // print(Note.c.flat.inOctave(3).note.sharp
    //     .inOctave(Note.c.sharp.inOctave(3)
    //     .octave)) ;
    //
    // print(Note.c.inOctave(3).note.accidental.toString() == 'Natural ♮ (+0)') ;
    // print(Note.c.flat.flat.inOctave(3).note.accidental.toString() == 'Double flat 𝄫 (-2)') ;
    // print(Note.c.sharp.sharp.inOctave(3).note.accidental.toString()=='Double sharp 𝄪 (+2)') ;
    // print(Note.f.sharp.inOctave(4).note.accidental.toString()=="Sharp ♯ (+1)") ;
    // print(Note.f.flat.inOctave(4).note.accidental.toString()=="Flat ♭ (-1)") ;

    // Widget answerTest ;
    // if (answerInfo.length == 8){
    //   answerTest = harmonyExpressionFinal(
    //       answerInfo[0]
    //       ,answerInfo[1]
    //       ,answerInfo[2]
    //       ,answerInfo[3]
    //       ,answerInfo[4]
    //       ,answerInfo[5]
    //       ,answerInfo[6]
    //       ,answerInfo[7]
    //   );
    // } else {
    //   answerTest = harmonyExpressionFinal(
    //       answerInfo[0]
    //       ,answerInfo[1]
    //       ,answerInfo[2]
    //       ,answerInfo[3]
    //   );
    // }
    // return Consumer<Counter>(
    //   builder: (context, counter, child) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('조성 : ${condition}'
                ,style: TextStyle(fontSize: 30.sp),
              ),
              // answerTest,료
            ],
          ),
          // ElevatedButton(onPressed: (){
          //     setState(() {
          //
          //       positionedNoteList = [];
          //       while (positionedNoteList.length==0){
          //
          //         problemElements = getEasyProblem();
          //
          //         answer = problemElements.$1;
          //         problem = problemElements.$2;
          //         condition = problemElements.$3;
          //
          //         positionedNoteList =
          //             noteToPositionedNote(problem);
          //
          //         print('##########################################');
          //         print('condition $condition');
          //         print('problem satb 순서 ${problem[3]} ${problem[2]} '
          //             '${problem[1]} ${problem[0]}');
          //         print('positionedNoteList satb $positionedNoteList');
          //         print('answer $answer');
          //       }
          //
          //     });
          //   }, child: Text('다음문제')
          // )
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              intervalNumberButton(answer)
              ,intervalNumberButton('|')
              ,intervalNumberButton('||')
              ,intervalNumberButton('|||')
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
