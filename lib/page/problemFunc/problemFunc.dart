// ignore_for_file: file_names

import 'package:music_notes/music_notes.dart';
import 'problemVarList.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'problemFuncDeco.dart';

double buttonSizeBasic = 35.0.h ;

bool setEquals<T>(Set<T>? a, Set<T>? b) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (final T value in a) {
    if (!b.contains(value)) {
      return false;
    }
  }
  return true;
}


List<List<dynamic>> getRandomProblem(List<List<dynamic>> noteHeightList){

  int number1 = Random().nextInt(noteHeightList.length);
  int number2 = Random().nextInt(noteHeightList.length);

  return [noteHeightList[number1],noteHeightList[number2]];

}

List<List<dynamic>> getProblemListNote(
    List<List<dynamic>> noteHeightList,
    List<double> randomItems,
    ){

  // 새로운 문제 생성
  // note_height_list.shuffle();

  List<List<dynamic>> noteHeightListProblem = [];
  noteHeightListProblem =
    getRandomProblem(noteHeightList);

  // 이전 문제와 동일하지 않게 방지 하는 장치
  // 동일하면 while문이 계속 실행
  if (randomItems.isEmpty){
    while (
    // 이전 문제와 동일하지 않게 방지 하는 장치
    (noteHeightListProblem[0][1]-noteHeightListProblem[1][1]).abs()>7
    ){
      noteHeightListProblem =
          getRandomProblem(noteHeightList);
    }
  } else {
    while (
    // 이전 문제와 동일하지 않게 방지 하는 장치
    setEquals(
        [noteHeightListProblem[0][0],noteHeightListProblem[1][0]].toSet(),
        [randomItems[0],randomItems[1]].toSet())
    // 7음정 넘게 차이날 경우 다시 생성
    |((noteHeightListProblem[0][1]-noteHeightListProblem[1][1]).abs()>7)
    ){
      noteHeightListProblem =
          getRandomProblem(noteHeightList);
    }
  }
  return noteHeightListProblem;
}

// one both none
String accidentalsWhere(){
  // 양쪽음에 한쪽만 50, 양쪽다 30, 아무것도 20
  Random r1 = Random();
  if (r1.nextDouble() <=0.5){
    return 'one';
  } else if (r1.nextDouble() <=0.8){
    return 'both';
  } else {
    return 'none';
  }
}

// return sharp, flat, double flat, double sharp
String accidentals(){
  Random r2 = Random();
  if (r2.nextDouble() <=0.35){
    return 'sharp';
  } else if (r2.nextDouble() <=0.70){
    return 'flat';
  } else if (r2.nextDouble() <=0.85){
    return 'double flat';
  } else {
    return 'double sharp';
  }
}

// return sharp, flat
String accidentalsNoDouble(){
  Random r2 = Random();
  if (r2.nextDouble() <=0.5){
    return 'sharp';
  } else{
    return 'flat';
  }
}

List<String> accidentalsFinal(List<PositionedNote> randomNote){

  String accidentalWhere = accidentalsWhere();
  Random r3 = Random();

  var randomNote2 = [randomNote[1],randomNote[0]];

  if (accidentalWhere == 'none'){
    return ['none','none'];
  } else if (accidentalWhere == 'one'){
    if (r3.nextDouble() <=0.5){
      return [accidentals(),'none'];
    } else {
      return ['none',accidentals()];
    }
  } else {
    // no double
    if (noDiffDoubleList.contains(randomNote)|
        noDiffDoubleList.contains(randomNote2)){
      String fixAccidental = accidentalsNoDouble();
      return [fixAccidental,fixAccidental];
    } else {
      return [accidentalsNoDouble(),accidentalsNoDouble()];
    }
  }
}


PositionedNote addAccidental(PositionedNote inputNote, String accidental){
  if (accidental == 'none'){
    return inputNote;
  } else if (accidental == 'sharp'){
    return inputNote.note.sharp.inOctave(inputNote.octave);
  } else if (accidental == 'double sharp'){
    return inputNote.note.sharp.sharp.inOctave(inputNote.octave);
  } else if (accidental == 'flat'){
    return inputNote.note.flat.inOctave(inputNote.octave);
  } else {
    return inputNote.note.flat.flat.inOctave(inputNote.octave);
  }
}

// add line 시리즈
Widget returnLine(double top){
  return Positioned(
      top: top.h,
      left: 10.w,
      right: 10.w,
      child:
      Container(
        color: Colors.black,
        width: double.infinity,
        height: 2.0.h,
      )
  );
}

Widget addLineBasic(){
  return Container(
    color: Colors.black,
    height: 2.0.h,
    width: 50.w,
  );
}

// 덧줄용1
Widget addLine1(PositionedNote randomNote){

  // middle line
  List<PositionedNote> middleLine = [
    Note.c.inOctave(6),
    Note.a.inOctave(5),
    Note.f.inOctave(5),
    Note.d.inOctave(5),
    Note.b.inOctave(4),
    Note.g.inOctave(4),
    Note.e.inOctave(4),
    Note.c.inOctave(4),
    Note.a.inOctave(3),
    Note.c.inOctave(2),
    Note.a.inOctave(1),
  ];
  // low line
  List<PositionedNote> lowLine = [
    Note.b.inOctave(5),
    Note.d.inOctave(6),
  ];

  // high line
  List<PositionedNote> highLine = [
    Note.b.inOctave(3),
    Note.g.inOctave(3),
    Note.b.inOctave(1),

  ];

  if (middleLine.contains(randomNote)){
    return
      Positioned(
        top: 12.75.h,
        child: addLineBasic(),
      );
  } else if (lowLine.contains(randomNote)) {
    return
      Positioned(
        top: 24.5.h,
        child: addLineBasic(),
      );
  } else if (highLine.contains(randomNote)){
    return
      Positioned(
        top: 0.0.h,
        child: addLineBasic(),
      );
  }
  else {
    return const SizedBox();
  }
}

// 덧줄용3
Widget addLine3(PositionedNote randomNote, double left){

  // 위의 도 레 거나 high line
  List<PositionedNote> highLine = [
    Note.d.inOctave(6),
    Note.c.inOctave(6),
  ];
  // 아래의 라 솔 인 경우 low line
  List<PositionedNote> lowLine = [
    Note.a.inOctave(3),
    Note.g.inOctave(3),
    // Note.a.inOctave(1),
  ];

  List<PositionedNote> lowLowLine = [
    Note.a.inOctave(1),
  ];

  if (highLine.contains(randomNote)){
    return
      Positioned(
        top: 50.75.h, // [50.75,3,Note.a.inOctave(5)],
        left: left,
        child: SizedBox(
          height: 26.5.h,
          child: Stack(
            children: [
              Image.asset('assets/whole_note_lean_all_white.png'),
              Positioned(
                top: 12.75.h,
                child: addLineBasic(),
              )
            ],
          ),
        ),
      );
  } else if (lowLine.contains(randomNote)) {
    return
      Positioned(
        top: 209.75.h, // [50.75,3,Note.a.inOctave(5)],
        left: left,
        child: SizedBox(
          height: 26.5.h,
          child: Stack(
            children: [
              Image.asset('assets/whole_note_lean_all_white.png'),
              Positioned(
                top: 12.75.h,
                child: addLineBasic(),
              )
            ],
          ),
        ),
      );
  } else if (lowLowLine.contains(randomNote)) {
    return
      Positioned(
        top: 368.75.h, // [50.75,3,Note.a.inOctave(5)],
        left: left,
        child: SizedBox(
          height: 26.5.h,
          child: Stack(
            children: [
              Image.asset('assets/whole_note_lean_all_white.png'),
              Positioned(
                top: 12.75.h,
                child: addLineBasic(),
              )
            ],
          ),
        ),
      );
  }
  else {
    return const SizedBox();
  }
}


// 덧줄용2
Widget addLine2(PositionedNote randomNote, double left){

  // highhigh line
  List<PositionedNote> highHighLine = [
    Note.d.inOctave(6),
    Note.c.inOctave(6),
  ];
  // lowlow line
  List<PositionedNote> lowLowLine = [
    Note.a.inOctave(3),
    Note.g.inOctave(3),
  ];

  if (highHighLine.contains(randomNote)){
    return
      Positioned(
        top: 63.5.h,
        left: left,
        child: addLineBasic(),
      );
  } else if (lowLowLine.contains(randomNote)) {
    return
      Positioned(
        top: 222.5.h,
        left: left,
        child: addLineBasic(),
      );
  }
  else {
    return const SizedBox();
  }
}

// 변화표 추가
Widget addAccidentals(String whatAccidental, double top, double left){

  if (whatAccidental == 'none'){
    return const SizedBox();
  } else if (whatAccidental == 'sharp'){
    return Positioned(
      top: top-13.0.h,
      left: left-11.0.h,
      child: SizedBox(
        height: 54.h,
        width: 47.w,
        child: const Image(
          image: AssetImage('assets/sharp2.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  } else if (whatAccidental == 'double sharp'){
    return Positioned(
      top: top+3.5.h,
      left: left-2.0.h,
      child: SizedBox(
        height: 20.h,
        width: 20.w,
        child: const Image(
          image: AssetImage('assets/doubleSharp.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  } else if (whatAccidental == 'flat'){
    return Positioned(
      top: top-16.0.h,
      left: left+7.0.h,
      child: SizedBox(
        height: 41.h,
        width: 16.w,
        child: const Image(
          image: AssetImage('assets/flat2.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  } else {
    return Positioned(
      top: top-17.5.h,
      left: left-7.5.h,
      child: SizedBox(
        height: 45.h,
        width: 30.w,
        child: const Image(
          image: AssetImage('assets/doubleFlat.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}


// 화성 표현 함수

Widget romString(String rome,TextStyle textStyle){
  return rome==""?const SizedBox():Container(
    padding: EdgeInsets.fromLTRB(3.w, 0, 2.w, 0),
    height: 22.h,
    child: FittedBox(
        fit: BoxFit.contain,
        child:Text(rome,
          style: textStyle,
        )
    ),
  );
}

Widget dotString(String dot,TextStyle textStyle){
  return dot==""?const SizedBox():SizedBox(
    height: 22.h,
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 2.w, 0),
          height: 11.h,
          child:FittedBox(
              fit: BoxFit.contain,
              child:Text(dot,
                style: textStyle,)
          ),
        ),
      ],
    ),
  );
}

Widget numNumString(String num1, String num2,TextStyle textStyle){
  if (num1 == ""){
    return const SizedBox();
  } else {
    return SizedBox(
      height: 23.h,
      width: 10.w,
      child: Stack(
          children: [
            num2==""?const SizedBox():Positioned(
              top: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 2.w, 0),
                height: 13.h,
                child: FittedBox(
                    fit: BoxFit.contain,
                    child:Text(num2,
                      style: textStyle,)
                ),
              ),
            ),
            Positioned(
              top:10.h,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 2.w, 0),
                height: 13.h,
                child: FittedBox(
                    fit: BoxFit.contain,
                    child:Text(num1,
                      style: textStyle,)
                ),
              ),
            ),]
      ),
    );
  }
}

// double answerSizeHeight = 50.0.h;
// double heightToWidth = 0.5;
// Widget showHarmonyFromList(
//     List<String> answerList
//     ,onTapValue
//     ,TextStyle textStyle){
//   return InkWell(
//     onTap:onTapValue
//     ,child: Container(
//     alignment: Alignment.center,
//     height: 43.h,
//     width: 80.w,
//     decoration: BoxDecoration(
//         color: color10,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.7),
//             blurRadius: 4.0,
//             spreadRadius: -4.0,
//             offset: const Offset(4,4),
//           )
//         ]
//     ),
//     child:
//     Center(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           romString(answerList[0],textStyle),
//           dotString(answerList[1],textStyle),
//           numNumString(answerList[2],answerList[3],textStyle),
//           answerList[4]==""?SizedBox():Container(
//             padding: EdgeInsets.fromLTRB(0, 0, 3.w, 0),
//             height:22.h,
//             child:FittedBox(
//                 fit: BoxFit.contain,
//                 child:Text(answerList[4],
//                   style: textStyle,)
//             ),
//           ),
//           romString(answerList[5],textStyle),
//           dotString(answerList[6],textStyle),
//           numNumString(answerList[7],answerList[8],textStyle),
//         ],
//       ),
//     ),
//   ),
//   );
// }

Widget showHarmonyFromList(
    List<String> answerList
    ,onTapValue
    ,TextStyle textStyle){
  return ElevatedButton(
    onPressed:onTapValue
    ,style: answerButtonDesign()
    ,child: Container(
      alignment: Alignment.center,
      // height: 43.h,
      // width: 80.w,
      // decoration: BoxDecoration(
      //     color: color10,
      //     borderRadius: BorderRadius.circular(15),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey.withOpacity(0.7),
      //         blurRadius: 4.0,
      //         spreadRadius: -4.0,
      //         offset: const Offset(4,4),
      //       )
      //     ]
      // ),
     child:
    Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          romString(answerList[0],textStyle),
          dotString(answerList[1],textStyle),
          numNumString(answerList[2],answerList[3],textStyle),
          answerList[4]==""?const SizedBox():Container(
            padding: EdgeInsets.fromLTRB(0, 0, 3.w, 0),
            height:22.h,
            child:FittedBox(
                fit: BoxFit.contain,
                child:Text(answerList[4],
                  style: textStyle,)
            ),
          ),
          romString(answerList[5],textStyle),
          dotString(answerList[6],textStyle),
          numNumString(answerList[7],answerList[8],textStyle),
        ],
      ),
    ),
  ),
  );
}

Widget showHarmonyFromListShowOnly(
    List<String> answerList
    ,TextStyle textStyle){
  return Container(
    alignment: Alignment.center,
    height: 30.h,
    // width: 90.w,
    child:
    Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          romString(answerList[0],textStyle),
          dotString(answerList[1],textStyle),
          numNumString(answerList[2],answerList[3],textStyle),
          answerList[4]==""?const SizedBox():Container(
            padding: EdgeInsets.fromLTRB(0, 0, 3.w, 0),
            height:28.h,
            child:FittedBox(
                fit: BoxFit.contain,
                child:Text(answerList[4],
                  style: textStyle,)
            ),
          ),
          romString(answerList[5],textStyle),
          dotString(answerList[6],textStyle),
          numNumString(answerList[7],answerList[8],textStyle),
        ],
      ),
    ),
  );
}