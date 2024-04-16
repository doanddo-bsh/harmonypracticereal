// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../problemFunc/providerCounter.dart';
import 'package:music_notes/music_notes.dart';
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


class tonalityProblemType1 extends StatefulWidget {
  const tonalityProblemType1({super.key});

  @override
  State<tonalityProblemType1> createState() => _tonalityProblemType1State();
}

class _tonalityProblemType1State extends State<tonalityProblemType1> {

  // for admob banner
  BannerAd? _banner;
  final _random = new Random();

  var problemListShow ;
  late List<int> problemShowKeyList ;
  late int problemShowNumber ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 새로운 문제 생성
    // 어떤 문제 리스트 쓸지 결정
    problemListShow =
    problemListList[_random.nextInt(problemListList
        .length)];

    // 해당 문제 리스트의 key list 획득
    problemShowKeyList =
    problemListShow.keys.toList();

    // 문제 리스트중 특정 key의 문제 추출
    problemShowNumber =
    problemShowKeyList[_random.nextInt(problemShowKeyList.length)];

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


    Map<int, List<dynamic>> problemType1List =
    {
      // 문제번호 / 음표위치 / 정답  [-4,7,10,14]
      189:[[Note.b.flat.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.b.flat.inOctave(2)]
        ,[100.0,'vii','4','6',]
        ,'Em(5b)/Bb'
        ,Note.f.major],
    };


    //
    // List<int> problemShowKeyList =
    // problemListShow.keys.toList();
    //
    // int problemShowNumber =
    // problemShowKeyList[_random.nextInt(problemShowKeyList.length)];
    //
    // int problemNumber = problemShowNumber ;

    // 4:[[-3,6,14,25],harmonyExpressionFinal(100,'VI','7','2','/','I','1','2'),],
    List<dynamic> problemInfo = problemListShow[problemShowNumber]!;
    List<dynamic> answerInfo = problemListShow[problemShowNumber]![1]!;

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

    Widget answerTest ;
    if (answerInfo.length == 8){
      answerTest = harmonyExpressionFinal(
          answerInfo[0]
          ,answerInfo[1]
          ,answerInfo[2]
          ,answerInfo[3]
          ,answerInfo[4]
          ,answerInfo[5]
          ,answerInfo[6]
          ,answerInfo[7]
      );
    } else {
      answerTest = harmonyExpressionFinal(
          answerInfo[0]
          ,answerInfo[1]
          ,answerInfo[2]
          ,answerInfo[3]
      );
    }
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
                returnNoteHarmonyFinal(90.5, 13.25, problemInfo[0][0]
                    , [90.0, 26.5, -1], 'high'),
                // seconde note
                returnNoteHarmonyFinal(90.5, 13.25, problemInfo[0][1]
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
                returnNoteHarmonyFinal(90.5, 13.25, problemInfo[0][2]
                    , [90.0, 26.5, -1], 'low'),
                // seconde note
                returnNoteHarmonyFinal(90.5, 13.25, problemInfo[0][3]
                    , [90.0, 26.5, -1], 'low'),
              ],
            ),
          ),
          // SizedBox(height: 30.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('정답 : '
                ,style: TextStyle(fontSize: 30.sp),
              ),
              answerTest,
            ],
          ),
          ElevatedButton(onPressed: (){
              setState(() {
                var (a,b) = problemReturn();
                problemListShow = a;
                problemShowNumber = b;
              });
            }, child: Text('다음문제')
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
