// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'colorList.dart';
// import 'problemVarList.dart';
// import '../problemFunc/problemFunc.dart';

// appBar title style
TextStyle appBarTitleStyle =
const TextStyle(fontSize: 16,fontWeight: FontWeight.bold);

// appBar title icon
Icon appBarIcon = const Icon(Icons.arrow_back_ios,size: 16,);

// explain text style
TextStyle explainTextStyle =
const TextStyle(fontSize: 14,fontWeight: FontWeight.bold);

TextStyle explainTextStyle2 =
const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color(0xff931919));

// next problem button style
ButtonStyle nextProblemButtonStyle(String easyOrHard,String rightWrong){
  return ElevatedButton.styleFrom(
      backgroundColor: (rightWrong=='right')? color1: color2,
      foregroundColor: (rightWrong=='right')? color1 : color2,
      elevation: 3
  );
}

// next problem button text style
TextStyle nextProblemButtonTextStyle =
const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.white54)
;




// answer button text design
TextStyle answerButtonTextDesign =
TextStyle(color: color3);

// answer button design
ButtonStyle answerButtonDesign(realValue,buttonValue,easyOrHard,context){
  return
    ElevatedButton.styleFrom(
        backgroundColor:
        realValue==buttonValue ?
        const Color(0xffdadada) :
        Theme.of(context).colorScheme.onTertiary,
        foregroundColor: (easyOrHard=='easy')? color1 : color2,
        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
        )

    );
}

String classifyAccidentals(String accidentalOrigin){

  if (accidentalOrigin.contains('Natural'))
  {
    return 'n';
  } else if (accidentalOrigin.contains('Flat'))
  {
    return 'f';
  } else if (accidentalOrigin.contains
    ('Double flat'))
  { return 'df';
  } else if (accidentalOrigin.contains
    ('Double sharp'))
  { return 'ds';
  } else {
    return 's';
  }
}

// commentary function
String commentaryKeyReturn(List<dynamic> randomNoteAnswerSorted, String answerRealKor){

  // number
  String answerReal = randomNoteAnswerSorted[0].interval(randomNoteAnswerSorted[1]).toString();

  // commentary
  // 숫자(1~8), 알파벳(c,d,e,f,g,a,b), 알파벳(c,d,e,f,g,a,b) // ex 3cg
  String commentaryNumberTemp = answerReal.toString();
  String commentaryAlphabat1Temp = randomNoteAnswerSorted[0].note.baseNote
      .toString();
  String commentaryAlphabat2Temp = randomNoteAnswerSorted[1].note.baseNote
      .toString();

  String commentaryTarget =
      commentaryNumberTemp[commentaryNumberTemp.length - 1]
          + commentaryAlphabat1Temp[commentaryAlphabat1Temp.length - 1]
          + commentaryAlphabat2Temp[commentaryAlphabat2Temp.length - 1];

  String commentaryFirstAccidental =
  classifyAccidentals(randomNoteAnswerSorted[0].note.accidental.toString());

  String commentarySecondAccidental =
  classifyAccidentals(randomNoteAnswerSorted[1].note.accidental.toString());

  List<String> returnTarget = [commentaryTarget,commentaryFirstAccidental,
    commentarySecondAccidental];

  String? commentaryUpAccidentalResult =
  commentaryUpAccidental[returnTarget[2]];

  String? commentaryDownAccidentalResult =
  commentaryDownAccidental[returnTarget[1]];

  String commentaryBasicResult =
      '${commentaryBasic[returnTarget[0]][0]} $answerRealKor도 '
      '${commentaryBasic[returnTarget[0]][1]}'
  ;

  if ((commentaryUpAccidentalResult==null)&(commentaryDownAccidentalResult==null)){
    return commentaryBasicResult;
  } else if (commentaryUpAccidentalResult==null){
    return '${commentaryDownAccidentalResult!} $commentaryBasicResult';
  } else if (commentaryDownAccidentalResult==null){
    return '$commentaryUpAccidentalResult $commentaryBasicResult';
  } else {
    return '$commentaryDownAccidentalResult $commentaryUpAccidentalResult $commentaryBasicResult';
  }



}

// progress bar
Widget lastRidingProgress(
    wrongProblemMode,
    problemNumber,
    wrongProblemsSave,
    easyOrHard,
    context,
    ) {

  double percent =
  wrongProblemMode?
  double.parse((problemNumber / wrongProblemsSave.length).toStringAsFixed
    (1)) :
  problemNumber / 10 ;

  return Column(
    children: [
      const SizedBox(height: 3,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.zero,
            percent: percent,
            lineHeight: 20.h,
            center: wrongProblemMode?
            Text('$problemNumber/${wrongProblemsSave.length}',style: const TextStyle(fontSize: 12)) :
            Text('$problemNumber/10',style: const TextStyle(fontSize: 12),) ,
            backgroundColor: Colors.black12,
            progressColor: (easyOrHard=='easy')? color1 : color2,
          ),
        ],
      )
    ],
  );
}

// commentary Tooltip
Widget commentaryToolTip(String commentaryResult){
  return
    Padding(
      padding: EdgeInsets.fromLTRB(0.w, 0.h, 20.w, 0.h),
      child: Tooltip(
        margin: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
        verticalOffset: -120,
        height: 80,
        textStyle: const TextStyle(color: Colors.black54),
        decoration: BoxDecoration(color: const Color(0xffeeeeee),
            borderRadius: BorderRadius.circular(10)),
        triggerMode: TooltipTriggerMode.tap,
        showDuration: const Duration(milliseconds: 7000),
        message:
        commentaryResult,
        child: const Icon(
          Icons.info_outline,
          size: 18,
        ),
      ),
    );
}


// commentary list
Map commentaryBasic = {
  "1cc"	:["반음이 0개이므로","음정입니다 \n(완전1도 음정의 기본 반음수는 0개)"],
  "1dd"	:["반음이 0개이므로","음정입니다 \n(완전1도 음정의 기본 반음수는 0개)"],
  "1ee"	:["반음이 0개이므로","음정입니다 \n(완전1도 음정의 기본 반음수는 0개)"],
  "1ff"	:["반음이 0개이므로","음정입니다 \n(완전1도 음정의 기본 반음수는 0개)"],
  "1gg"	:["반음이 0개이므로","음정입니다 \n(완전1도 음정의 기본 반음수는 0개)"],
  "1aa"	:["반음이 0개이므로","음정입니다 \n(완전1도 음정의 기본 반음수는 0개)"],
  "1bb"	:["반음이 0개이므로","음정입니다 \n(완전1도 음정의 기본 반음수는 0개)"],
  "2cd"	:["반음이 0개이므로","음정입니다 \n(장2도 음정의 기본 반음수는 0개)"],
  "2de"	:["반음이 0개이므로","음정입니다 \n(장2도 음정의 기본 반음수는 0개)"],
  "2ef"	:["반음이 1개이므로 간격이 줄어들어","음정입니다 \n(장2도 음정의 기본 반음수는 0개)"],
  "2fg"	:["반음이 0개이므로","음정입니다 \n(장2도 음정의 기본 반음수는 0개)"],
  "2ga"	:["반음이 0개이므로","음정입니다 \n(장2도 음정의 기본 반음수는 0개)"],
  "2ab"	:["반음이 0개이므로","음정입니다 \n(장2도 음정의 기본 반음수는 0개)"],
  "2bc"	:["반음이 1개이므로 간격이 줄어들어","음정입니다 \n(장2도 음정의 기본 반음수는 0개)"],
  "3ce"	:["반음이 0개이므로","음정입니다 \n(장3도 음정의 기본 반음수는 0개)"],
  "3df"	:["반음이 1개이므로 간격이 줄어들어","음정입니다 \n(장3도 음정의 기본 반음수는 0개)"],
  "3eg"	:["반음이 1개이므로 간격이 줄어들어","음정입니다 \n(장3도 음정의 기본 반음수는 0개)"],
  "3fa"	:["반음이 0개이므로","음정입니다 \n(장3도 음정의 기본 반음수는 0개)"],
  "3gb"	:["반음이 0개이므로","음정입니다 \n(장3도 음정의 기본 반음수는 0개)"],
  "3ac"	:["반음이 1개이므로 간격이 줄어들어","음정입니다 \n(장3도 음정의 기본 반음수는 0개)"],
  "3bd"	:["반음이 1개이므로 간격이 줄어들어","음정입니다 \n(장3도 음정의 기본 반음수는 0개)"],
  "4cf"	:["반음이 1개이므로","음정입니다 \n(완전4도 음정의 기본 반음수는 1개)"],
  "4dg"	:["반음이 1개이므로","음정입니다 \n(완전4도 음정의 기본 반음수는 1개)"],
  "4ea"	:["반음이 1개이므로","음정입니다 \n(완전4도 음정의 기본 반음수는 1개)"],
  "4fb"	:["반음이 0개이므로 간격이 늘어나","음정입니다 \n(완전4도 음정의 기본 반음수는 1개)"],
  "4gc"	:["반음이 1개이므로","음정입니다 \n(완전4도 음정의 기본 반음수는 1개)"],
  "4ad"	:["반음이 1개이므로","음정입니다 \n(완전4도 음정의 기본 반음수는 1개)"],
  "4be"	:["반음이 1개이므로","음정입니다 \n(완전4도 음정의 기본 반음수는 1개)"],
  "5cg"	:["반음이 1개이므로","음정입니다 \n(완전5도 음정의 기본 반음수는 1개)"],
  "5da"	:["반음이 1개이므로","음정입니다 \n(완전5도 음정의 기본 반음수는 1개)"],
  "5eb"	:["반음이 1개이므로","음정입니다 \n(완전5도 음정의 기본 반음수는 1개)"],
  "5fc"	:["반음이 1개이므로","음정입니다 \n(완전5도 음정의 기본 반음수는 1개)"],
  "5gd"	:["반음이 1개이므로","음정입니다 \n(완전5도 음정의 기본 반음수는 1개)"],
  "5ae"	:["반음이 1개이므로","음정입니다 \n(완전5도 음정의 기본 반음수는 1개)"],
  "5bf"	:["반음이 2개이므로 간격이 줄어들어","음정입니다 \n(완전5도 음정의 기본 반음수는 1개)"],
  "6ca"	:["반음이 1개이므로","음정입니다 \n(장6도 음정의 기본 반음수는 1개)"],
  "6db"	:["반음이 1개이므로","음정입니다 \n(장6도 음정의 기본 반음수는 1개)"],
  "6ec"	:["반음이 2개이므로 간격이 줄어들어","음정입니다 \n(장6도 음정의 기본 반음수는 1개)"],
  "6fd"	:["반음이 1개이므로","음정입니다 \n(장6도 음정의 기본 반음수는 1개)"],
  "6ge"	:["반음이 1개이므로","음정입니다 \n(장6도 음정의 기본 반음수는 1개)"],
  "6af"	:["반음이 2개이므로 간격이 줄어들어","음정입니다 \n(장6도 음정의 기본 반음수는 1개)"],
  "6bg"	:["반음이 2개이므로 간격이 줄어들어","음정입니다 \n(장6도 음정의 기본 반음수는 1개)"],
  "7cb"	:["반음이 1개이므로","음정입니다 \n(장7도 음정의 기본 반음수는 1개)"],
  "7dc"	:["반음이 2개이므로 간격이 줄어들어","음정입니다 \n(장7도 음정의 기본 반음수는 1개)"],
  "7ed"	:["반음이 2개이므로 간격이 줄어들어","음정입니다 \n(장7도 음정의 기본 반음수는 1개)"],
  "7fe"	:["반음이 1개이므로","음정입니다 \n(장7도 음정의 기본 반음수는 1개)"],
  "7gf"	:["반음이 2개이므로 간격이 줄어들어","음정입니다 \n(장7도 음정의 기본 반음수는 1개)"],
  "7ag"	:["반음이 2개이므로 간격이 줄어들어","음정입니다 \n(장7도 음정의 기본 반음수는 1개)"],
  "7ba"	:["반음이 2개이므로 간격이 줄어들어","음정입니다 \n(장7도 음정의 기본 반음수는 1개)"],
  "8cc"	:["반음이 2개이므로","음정입니다 \n(완전8도 음정의 기본 반음수는 2개)"],
  "8dd"	:["반음이 2개이므로","음정입니다 \n(완전8도 음정의 기본 반음수는 2개)"],
  "8ee"	:["반음이 2개이므로","음정입니다 \n(완전8도 음정의 기본 반음수는 2개)"],
  "8ff"	:["반음이 2개이므로","음정입니다 \n(완전8도 음정의 기본 반음수는 2개)"],
  "8gg"	:["반음이 2개이므로","음정입니다 \n(완전8도 음정의 기본 반음수는 2개)"],
  "8aa"	:["반음이 2개이므로","음정입니다 \n(완전8도 음정의 기본 반음수는 2개)"],
  "8bb"	:["반음이 2개이므로","음정입니다 \n(완전8도 음정의 기본 반음수는 2개)"],
};

Map commentaryUpAccidental = {
  "s"	:"위에 있는 음에 붙은 샵으로 인해 음정간 간격이 늘어나고",
  "f"	:"위에 있는 음에 붙은 플렛으로 인해 음정간 간격이 줄어들고",
  "ds"	:"위에 있는 음에 붙은 더블샵으로 인해 음정간 간격이 늘어나고",
  "df"	:"위에 있는 음에 붙은 더블플렛으로 인해 음정간 간격이 줄어들고",
};

Map commentaryDownAccidental = {
  "s"	:"아래에 있는 음에 붙은 샵으로 인해 음정간 간격이 줄어들고 ",
  "f"	:"아래에 있는 음에 붙은 플렛으로 인해 음정간 간격이 늘어나고",
  "ds"	:"아래에 있는 음에 붙은 더블샵으로 인해 음정간 간격이 줄어들고",
  "df"	:"아래에 있는 음에 붙은 더블플렛으로 인해 음정간 간격이 늘어나고",
};

// type2 commentary map
Map<String,String> commentaryType2 = {
  "감1도":"감1도는 원음정에 비해 음의 간격이 줄어듭니다 (완전1도 음정의 기본 반음수는 0개)",
  "겹감1도":"겹감1도는 원음정에 비해 음의 간격이 2번 줄어듭니다 (완전1도 음정의 기본 반음수는 0개)",
  "겹증1도":"겹증1도는 원음정에 비해 음의 간격이 2번 늘어납니다 (완전1도 음정의 기본 반음수는 0개)",
  "완전1도":"완전1도는 반음이 0개입니다 (완전1도 음정의 기본 반음수는 0개)",
  "증1도":"증1도는 원음정에 비해 음의 간격이 늘어납니다 (완전1도 음정의 기본 반음수는 0개)",
  "감2도":"감2도는 원음정에 비해 음의 간격이 줄어듭니다 (장2도 음정의 기본 반음수는 0개)",
  "겹감2도":"겹감2도는 원음정에 비해 음의 간격이 2번 줄어듭니다 (장2도 음정의 기본 반음수는 0개)",
  "겹증2도":"겹증2도는 원음정에 비해 음의 간격이 2번 늘어납니다 (장2도 음정의 기본 반음수는 0개)",
  "단2도":"단2도는 반음이 1개입니다 (장2도 음정의 기본 반음수는 0개)",
  "장2도":"장2도는 반음이 0개입니다 (장2도 음정의 기본 반음수는 0개)",
  "증2도":"증2도는 원음정에 비해 음의 간격이 줄어듭니다 (장2도 음정의 기본 반음수는 0개)",
  "감3도":"감3도는 원음정에 비해 음의 간격이 줄어듭니다 (장3도 음정의 기본 반음수는 0개)",
  "겹감3도":"겹감3도는 원음정에 비해 음의 간격이 2번 줄어듭니다 (장3도 음정의 기본 반음수는 0개)",
  "겹증3도":"겹증3도는 원음정에 비해 음의 간격이 2번 늘어납니다 (장3도 음정의 기본 반음수는 0개)",
  "단3도":"단3도는 반음이 1개입니다 (장3도 음정의 기본 반음수는 0개)",
  "장3도":"장3도는 반음이 0개입니다 (장3도 음정의 기본 반음수는 0개)",
  "증3도":"증3도는 원음정에 비해 음의 간격이 늘어납니다 (장3도 음정의 기본 반음수는 0개)",
  "감4도":"감4도는 원음정에 비해 음의 간격이 줄어듭니다 (완전4도 음정의 기본 반음수는 1개)",
  "겹감4도":"겹감4도는 원음정에 비해 음의 간격이 2번 줄어듭니다 (완전4도 음정의 기본 반음수는 1개)",
  "겹증4도":"겹증4도는 원음정에 비해 음의 간격이 2번 늘어납니다 (완전4도 음정의 기본 반음수는 1개)",
  "완전4도":"완전4도는 반음이 1개입니다 (완전4도 음정의 기본 반음수는 1개)",
  "증4도":"증4도는 원음정에 비해 음의 간격이 늘어납니다 (완전4도 음정의 기본 반음수는 1개)",
  "감5도":"감5도는 원음정에 비해 음의 간격이 줄어듭니다 (완전5도 음정의 기본 반음수는 1개)",
  "겹감5도":"겹감5도는 원음정에 비해 음의 간격이 2번 줄어듭니다 (완전5도 음정의 기본 반음수는 1개)",
  "겹증5도":"겹증5도는 원음정에 비해 음의 간격이 2번 늘어납니다 (완전5도 음정의 기본 반음수는 1개)",
  "완전5도":"완전5도는 반음이 1개입니다 (완전5도 음정의 기본 반음수는 1개)",
  "증5도":"증5도는 원음정에 비해 음의 간격이 늘어납니다 (완전5도 음정의 기본 반음수는 1개)",
  "감6도":"감6도는 원음정에 비해 음의 간격이 줄어듭니다 (장6도 음정의 기본 반음수는 1개)",
  "겹감6도":"겹감6도는 원음정에 비해 음의 간격이 2번 줄어듭니다 (장6도 음정의 기본 반음수는 1개)",
  "겹증6도":"겹증6도는 원음정에 비해 음의 간격이 2번 늘어납니다 (장6도 음정의 기본 반음수는 1개)",
  "단6도":"단6도는 반음이 2개입니다 (장6도 음정의 기본 반음수는 1개)",
  "장6도":"장6도는 반음이 1개입니다 (장6도 음정의 기본 반음수는 1개)",
  "증6도":"증6도는 원음정에 비해 음의 간격이 늘어납니다 (장6도 음정의 기본 반음수는 1개)",
  "감7도":"감7도는 원음정에 비해 음의 간격이 줄어듭니다 (장7도 음정의 기본 반음수는 1개)",
  "겹감7도":"겹감7도는 원음정에 비해 음의 간격이 2번 줄어듭니다 (장7도 음정의 기본 반음수는 1개)",
  "겹증7도":"겹증7도는 원음정에 비해 음의 간격이 2번 늘어납니다 (장7도 음정의 기본 반음수는 1개)",
  "단7도":"단7도는 반음이 2개입니다 (장7도 음정의 기본 반음수는 2개)",
  "장7도":"장7도는 반음이 1개입니다 (장7도 음정의 기본 반음수는 1개)",
  "증7도":"증7도는 원음정에 비해 음의 간격이 늘어납니다 (장7도 음정의 기본 반음수는 1개)",
  "감8도":"감8도는 원음정에 비해 음의 간격이 줄어듭니다 (완전8도 음정의 기본 반음수는 2개)",
  "겹감8도":"겹감8도는 원음정에 비해 음의 간격이 2번 줄어듭니다 (완전8도 음정의 기본 반음수는 2개)",
  "완전8도":"완전8도는 반음이 2개입니다 (완전8도 음정의 기본 반음수는 0개)",
  "증8도":"증8도는 원음정에 비해 음의 간격이 늘어납니다 (완전8도 음정의 기본 반음수는 2개)",
  "겹증8도":"겹증8도는 원음정에 비해 음의 간격이 2번 늘어납니다 (완전8도 음정의 기본 반음수는 2개)",
};


//
// // showBottomResult 내부에서
// // 음을 sort 한 뒤, 간격 및 한글 결과 내뱉는 함수
// // List<dynamic> randomNote
// List<dynamic> getResultAllEasy(List<dynamic> randomNote, bool inverseTF){
//
//   List<dynamic> randomNoteAnswer = [] ;
//
//   randomNoteAnswer.add(randomNote[0]);
//   randomNoteAnswer.add(randomNote[1]);
//
//   randomNoteAnswer.sort();
//
//   String answerReal;
//
//   String answerRealOriginal;
//
//   if (inverseTF){
//     // inverse True
//     answerReal = randomNoteAnswer[0].interval(randomNoteAnswer[1])
//         .inverted.toString();
//
//     answerRealOriginal = randomNoteAnswer[0].interval(randomNoteAnswer[1])
//         .toString();
//   } else {
//     // inverse False
//     answerReal = randomNoteAnswer[0].interval(randomNoteAnswer[1])
//         .toString();
//
//     answerRealOriginal = randomNoteAnswer[0].interval(randomNoteAnswer[1])
//         .inverted.toString();
//   }
//
//   String answerRealKor = '';
//
//   if (answerReal.length==2){
//     answerRealKor = intervalNameEngKor[answerReal.substring(0, 1)] +
//         answerReal.substring(1, 2);
//   } else {
//     answerRealKor = intervalNameEngKor[answerReal.substring(0, 2)] +
//         answerReal.substring(2, 3);
//   }
//
//   String answerRealOriginalKor = '';
//
//   if (answerRealOriginal.length==2){
//     answerRealOriginalKor = intervalNameEngKor[answerRealOriginal.substring(0, 1)] +
//         answerRealOriginal.substring(1, 2);
//   } else {
//     answerRealOriginalKor = intervalNameEngKor[answerRealOriginal.substring(0, 2)] +
//         answerRealOriginal.substring(2, 3);
//   }
//
//   return [randomNoteAnswer, answerReal, answerRealKor, answerRealOriginalKor];
// }
//
// List<dynamic> getResultAllHard(List<dynamic> randomNote,List<dynamic> accidentals, bool inverseTF){
//
//   List<dynamic> randomNoteAnswer = [] ;
//
//   randomNoteAnswer.add(addAccidental(randomNote[0], accidentals[0]));
//   randomNoteAnswer.add(addAccidental(randomNote[1], accidentals[1]));
//
//   randomNoteAnswer.sort();
//
//   String answerReal;
//
//   String answerRealOriginal;
//
//   if (inverseTF){
//     // inverse True
//     answerReal = randomNoteAnswer[0].interval(randomNoteAnswer[1])
//         .inverted.toString();
//
//     answerRealOriginal = randomNoteAnswer[0].interval(randomNoteAnswer[1])
//         .toString();
//   } else {
//     // inverse False
//     answerReal = randomNoteAnswer[0].interval(randomNoteAnswer[1])
//         .toString();
//
//     answerRealOriginal = randomNoteAnswer[0].interval(randomNoteAnswer[1])
//         .inverted.toString();
//   }
//
//   String answerRealKor = '';
//
//   if (answerReal.length==2){
//     answerRealKor = intervalNameEngKor[answerReal.substring(0, 1)] +
//         answerReal.substring(1, 2);
//   } else if (answerReal.length==3) {
//     answerRealKor = intervalNameEngKor[answerReal.substring(0, 2)] +
//         answerReal.substring(2, 3);
//   }
//
//   String answerRealOriginalKor = '';
//
//   if (answerRealOriginal.length==2){
//     answerRealOriginalKor = intervalNameEngKor[answerRealOriginal.substring(0, 1)] +
//         answerRealOriginal.substring(1, 2);
//   } else {
//     answerRealOriginalKor = intervalNameEngKor[answerRealOriginal.substring(0, 2)] +
//         answerRealOriginal.substring(2, 3);
//   }
//
//   return [randomNoteAnswer, answerReal, answerRealKor, answerRealOriginalKor];
// }
