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
import '../../harmonyModul/modulBasic.dart';


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
      190:[[Note.b.flat.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.f.inOctave(3)
        ,Note.b.flat.inOctave(2)]
        ,[100.0,'I','','',]
        ,'Bb'
        ,Note.b.flat.major],
      191:[[Note.b.flat.inOctave(4)
        ,Note.f.inOctave(4)
        ,Note.f.inOctave(3)
        ,Note.d.inOctave(3)]
        ,[100.0,'I','6','',]
        ,'Bb/D'
        ,Note.b.flat.major],
      192:[[Note.b.flat.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.f.inOctave(2)]
        ,[100.0,'I','4','6',]
        ,'Bb/F'
        ,Note.b.flat.major],
      193:[[Note.g.inOctave(4)
        ,Note.e.flat.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.c.inOctave(3)]
        ,[100.0,'ii','','',]
        ,'Cm'
        ,Note.b.flat.major],
      194:[[Note.g.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.e.flat.inOctave(3)]
        ,[100.0,'ii','6','',]
        ,'Cm/Eb'
        ,Note.b.flat.major],
      195:[[Note.g.inOctave(4)
        ,Note.e.flat.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.g.inOctave(3)]
        ,[100.0,'ii','4','6',]
        ,'Cm/G'
        ,Note.b.flat.major],
      196:[[Note.f.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.d.inOctave(3)]
        ,[100.0,'iii','','',]
        ,'Dm'
        ,Note.b.flat.major],
      197:[[Note.a.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.f.inOctave(3)]
        ,[100.0,'iii','6','',]
        ,'Dm/F'
        ,Note.b.flat.major],
      198:[[Note.f.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.a.inOctave(2)]
        ,[100.0,'iii','4','6',]
        ,'Dm/A'
        ,Note.b.flat.major],
      199:[[Note.e.flat.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.g.inOctave(3)
        ,Note.e.flat.inOctave(3)]
        ,[100.0,'IV','','',]
        ,'Eb'
        ,Note.b.flat.major],
      200:[[Note.e.flat.inOctave(4)
        ,Note.b.flat.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.g.inOctave(3)]
        ,[100.0,'IV','6','',]
        ,'Eb/G'
        ,Note.b.flat.major],
      201:[[Note.e.flat.inOctave(4)
        ,Note.b.flat.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.b.flat.inOctave(2)]
        ,[100.0,'IV','4','6',]
        ,'Eb/Bb'
        ,Note.b.flat.major],
      202:[[Note.a.inOctave(4)
        ,Note.f.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.f.inOctave(3)]
        ,[100.0,'V','','',]
        ,'F'
        ,Note.b.flat.major],
      203:[[Note.f.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.a.inOctave(3)]
        ,[100.0,'V','6','',]
        ,'F/A'
        ,Note.b.flat.major],
      204:[[Note.a.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.f.inOctave(3)
        ,Note.c.inOctave(3)]
        ,[100.0,'V','4','6',]
        ,'F/C'
        ,Note.b.flat.major],
      205:[[Note.g.inOctave(4)
        ,Note.b.flat.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.g.inOctave(3)]
        ,[100.0,'vi','','',]
        ,'Gm'
        ,Note.b.flat.major],
      206:[[Note.g.inOctave(4)
        ,Note.b.flat.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.flat.inOctave(3)]
        ,[100.0,'vi','6','',]
        ,'Gm/Bb'
        ,Note.b.flat.major],
      207:[[Note.g.inOctave(4)
        ,Note.b.flat.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.d.inOctave(2)]
        ,[100.0,'vi','4','6',]
        ,'Gm/D'
        ,Note.b.flat.major],
      208:[[Note.c.inOctave(4)
        ,Note.e.flat.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.a.inOctave(3)]
        ,[100.0,'vii','','',]
        ,'Am(5b)'
        ,Note.b.flat.major],
      209:[[Note.c.inOctave(5)
        ,Note.e.flat.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.c.inOctave(3)]
        ,[100.0,'vii','6','',]
        ,'Am(5b)/C'
        ,Note.b.flat.major],
      210:[[Note.c.inOctave(4)
        ,Note.a.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.e.flat.inOctave(3)]
        ,[100.0,'vii','4','6',]
        ,'Am(5b)/Eb'
        ,Note.b.flat.major],
      211:[[Note.b.flat.inOctave(4)
        ,Note.g.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.e.flat.inOctave(3)]
        ,[100.0,'I','','',]
        ,'Eb'
        ,Note.e.flat.major],
      212:[[Note.b.flat.inOctave(4)
        ,Note.e.flat.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.g.inOctave(3)]
        ,[100.0,'I','6','',]
        ,'Eb/G'
        ,Note.e.flat.major],
      213:[[Note.e.flat.inOctave(5)
        ,Note.g.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.b.flat.inOctave(2)]
        ,[100.0,'I','4','6',]
        ,'Eb/Bb'
        ,Note.e.flat.major],
      214:[[Note.f.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.a.flat.inOctave(3)
        ,Note.f.inOctave(2)]
        ,[100.0,'ii','','',]
        ,'Fm'
        ,Note.e.flat.major],
      215:[[Note.f.inOctave(4)
        ,Note.c.inOctave(5)
        ,Note.a.flat.inOctave(3)
        ,Note.a.flat.inOctave(2)]
        ,[100.0,'ii','6','',]
        ,'Fm/Ab'
        ,Note.e.flat.major],
      216:[[Note.f.inOctave(4)
        ,Note.a.flat.inOctave(4)
        ,Note.a.flat.inOctave(3)
        ,Note.c.inOctave(3)]
        ,[100.0,'ii','4','6',]
        ,'Fm/C'
        ,Note.e.flat.major],
      217:[[Note.g.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.g.inOctave(2)]
        ,[100.0,'iii','','',]
        ,'Gm'
        ,Note.e.flat.major],
      218:[[Note.g.inOctave(4)
        ,Note.d.inOctave(5)
        ,Note.b.flat.inOctave(3)
        ,Note.b.flat.inOctave(2)]
        ,[100.0,'iii','6','',]
        ,'Gm/Bb'
        ,Note.e.flat.major],
      219:[[Note.g.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.d.inOctave(2)]
        ,[100.0,'iii','4','6',]
        ,'Gm/D'
        ,Note.e.flat.major],
      220:[[Note.a.flat.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.e.flat.inOctave(3)
        ,Note.a.flat.inOctave(2)]
        ,[100.0,'IV','','',]
        ,'Ab'
        ,Note.e.flat.major],
      221:[[Note.e.flat.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.a.flat.inOctave(3)
        ,Note.c.inOctave(3)]
        ,[100.0,'IV','6','',]
        ,'Ab/C'
        ,Note.e.flat.major],
      222:[[Note.a.flat.inOctave(4)
        ,Note.c.inOctave(5)
        ,Note.c.inOctave(4)
        ,Note.e.flat.inOctave(3)]
        ,[100.0,'IV','4','6',]
        ,'Ab/Eb'
        ,Note.e.flat.major],
      223:[[Note.f.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.b.flat.inOctave(2)]
        ,[100.0,'V','','',]
        ,'Bb'
        ,Note.e.flat.major],
      224:[[Note.f.inOctave(5)
        ,Note.f.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.d.inOctave(2)]
        ,[100.0,'V','6','',]
        ,'Bb/D'
        ,Note.e.flat.major],
      225:[[Note.f.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.f.inOctave(2)]
        ,[100.0,'V','4','6',]
        ,'Bb/F'
        ,Note.e.flat.major],
      226:[[Note.e.flat.inOctave(5)
        ,Note.e.flat.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.c.inOctave(3)]
        ,[100.0,'vi','','',]
        ,'Cm'
        ,Note.e.flat.major],
      227:[[Note.g.inOctave(4)
        ,Note.e.flat.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.e.flat.inOctave(3)]
        ,[100.0,'vi','6','',]
        ,'Cm/Eb'
        ,Note.e.flat.major],
      228:[[Note.c.inOctave(5)
        ,Note.e.flat.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.g.inOctave(2)]
        ,[100.0,'vi','4','6',]
        ,'Cm/G'
        ,Note.e.flat.major],
      229:[[Note.f.inOctave(5)
        ,Note.f.inOctave(4)
        ,Note.a.flat.inOctave(3)
        ,Note.d.inOctave(3)]
        ,[100.0,'vii','','',]
        ,'Dm(5b)'
        ,Note.e.flat.major],
      230:[[Note.d.inOctave(5)
        ,Note.f.inOctave(4)
        ,Note.a.flat.inOctave(3)
        ,Note.f.inOctave(3)]
        ,[100.0,'vii','6','',]
        ,'Dm(5b)/F'
        ,Note.e.flat.major],
      231:[[Note.f.inOctave(5)
        ,Note.f.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.a.flat.inOctave(2)]
        ,[100.0,'vii','4','6',]
        ,'Dm(5b)/Ab'
        ,Note.e.flat.major],
      232:[[Note.e.flat.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.a.flat.inOctave(3)
        ,Note.a.flat.inOctave(2)]
        ,[100.0,'I','','',]
        ,'Ab'
        ,Note.a.flat.major],
      233:[[Note.e.flat.inOctave(5)
        ,Note.e.flat.inOctave(4)
        ,Note.a.flat.inOctave(3)
        ,Note.c.inOctave(3)]
        ,[100.0,'I','6','',]
        ,'Ab/C'
        ,Note.a.flat.major],
      234:[[Note.a.flat.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.a.flat.inOctave(3)
        ,Note.e.flat.inOctave(2)]
        ,[100.0,'I','4','6',]
        ,'Ab/Eb'
        ,Note.a.flat.major],
      235:[[Note.f.inOctave(4)
        ,Note.d.flat.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.b.flat.inOctave(2)]
        ,[100.0,'ii','','',]
        ,'Bbm'
        ,Note.a.flat.major],
      236:[[Note.f.inOctave(4)
        ,Note.b.flat.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.d.flat.inOctave(2)]
        ,[100.0,'ii','6','',]
        ,'Bbm/Db'
        ,Note.a.flat.major],
      237:[[Note.f.inOctave(4)
        ,Note.d.flat.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.f.inOctave(2)]
        ,[100.0,'ii','4','6',]
        ,'Bbm/F'
        ,Note.a.flat.major],
      238:[[Note.c.inOctave(5)
        ,Note.e.flat.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.c.inOctave(3)]
        ,[100.0,'iii','','',]
        ,'Cm'
        ,Note.a.flat.major],
      239:[[Note.g.inOctave(4)
        ,Note.e.flat.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.e.flat.inOctave(2)]
        ,[100.0,'iii','6','',]
        ,'Cm/Eb'
        ,Note.a.flat.major],
      240:[[Note.c.inOctave(5)
        ,Note.e.flat.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.g.inOctave(2)]
        ,[100.0,'iii','4','6',]
        ,'Cm/G'
        ,Note.a.flat.major],
      241:[[Note.a.flat.inOctave(4)
        ,Note.d.flat.inOctave(4)
        ,Note.f.inOctave(3)
        ,Note.d.flat.inOctave(3)]
        ,[100.0,'IV','','',]
        ,'Db'
        ,Note.a.flat.major],
      242:[[Note.a.flat.inOctave(4)
        ,Note.d.flat.inOctave(4)
        ,Note.a.flat.inOctave(3)
        ,Note.f.inOctave(3)]
        ,[100.0,'IV','6','',]
        ,'Db/F'
        ,Note.a.flat.major],
      243:[[Note.a.flat.inOctave(4)
        ,Note.f.inOctave(4)
        ,Note.d.flat.inOctave(4)
        ,Note.a.flat.inOctave(2)]
        ,[100.0,'IV','4','6',]
        ,'Db/Ab'
        ,Note.a.flat.major],
      244:[[Note.e.flat.inOctave(4)
        ,Note.b.flat.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.e.flat.inOctave(3)]
        ,[100.0,'V','','',]
        ,'Eb'
        ,Note.a.flat.major],
      245:[[Note.e.flat.inOctave(5)
        ,Note.e.flat.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.g.inOctave(3)]
        ,[100.0,'V','6','',]
        ,'Eb/G'
        ,Note.a.flat.major],
      246:[[Note.e.flat.inOctave(4)
        ,Note.b.flat.inOctave(3)
        ,Note.g.inOctave(3)
        ,Note.b.flat.inOctave(2)]
        ,[100.0,'V','4','6',]
        ,'Eb/Bb'
        ,Note.a.flat.major],
      247:[[Note.f.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.a.flat.inOctave(3)
        ,Note.f.inOctave(3)]
        ,[100.0,'vi','','',]
        ,'Fm'
        ,Note.a.flat.major],
      248:[[Note.f.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.a.flat.inOctave(3)
        ,Note.a.flat.inOctave(2)]
        ,[100.0,'vi','6','',]
        ,'Fm/Ab'
        ,Note.a.flat.major],
      249:[[Note.a.flat.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.f.inOctave(3)
        ,Note.c.inOctave(3)]
        ,[100.0,'vi','4','6',]
        ,'Fm/C'
        ,Note.a.flat.major],
      250:[[Note.b.flat.inOctave(4)
        ,Note.d.flat.inOctave(4)
        ,Note.d.flat.inOctave(4)
        ,Note.g.inOctave(3)]
        ,[100.0,'vii','','',]
        ,'Gm(5b)'
        ,Note.a.flat.major],
      251:[[Note.b.flat.inOctave(4)
        ,Note.g.inOctave(4)
        ,Note.d.flat.inOctave(4)
        ,Note.b.flat.inOctave(3)]
        ,[100.0,'vii','6','',]
        ,'Gm(5b)/Bb'
        ,Note.a.flat.major],
      252:[[Note.b.flat.inOctave(4)
        ,Note.d.flat.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.d.flat.inOctave(3)]
        ,[100.0,'vii','4','6',]
        ,'Gm(5b)/Db'
        ,Note.a.flat.major],

    };

    problemListShow = problemType1List ;

    problemShowNumber = 252 ;

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
                // var (a,b) = problemReturn();
                // problemListShow = a;
                // problemShowNumber = b;
                Tonality condition = getConditionalTonality();
                int orderInt = getOneToSeven();

                print(condition);
                print(orderInt);
                print(condition.note.baseNote.transposeBySize(orderInt));

                // 여기서 간격에 맞춰서 음 3개더 생성
                // 음 4개 random 하게 순서 정하기
                // 순서에 맞춰서 제약 내에서 배치

                // test
                // Tonality a = Note.c.major;
                // print(a.note == Note.c);
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
