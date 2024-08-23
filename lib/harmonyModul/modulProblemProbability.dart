import "dart:math";
import 'package:music_notes/music_notes.dart';
import 'modulBasic.dart';
import 'modulBasicMinor.dart';
import 'modulBorrowed.dart';
import '../page/problemFunc/problemFuncHarmony.dart';

List<String> wrongViewList = [
  'I','II','III','Iv','VI','V/I'
  ,'V4/2'
  ,'Vii "  7/I'
  ,'Vii " 7'
  ,'Vii "반  3/4/I'
  ,'Vii " 반 4/2'
  ,'V4/3'
  ,"Vii' 6/5"
  ,"Vii' 반 3/4"
  ,'V4/3'
  ,"Vii' 6/5"
  ,"Vii' 반 7"
  ,'V7'
  ,"Vii' 7"
  ,"Vii' 반 3/4"
  ,"V4/3"
  ,"Vii' 6/5"
  ,"Vii' 반 6/5"
  ,"V7"
];

final List<String> easyType134 = ["3화음", "속7화음"];
final List<String> easyType2 = ["속7화음"];

final List<String> mediumType134 = ["3화음", "부속7화음","부감7화음","부반감7화음"];
final List<String> mediumType2 = [ "부속7화음","부감7화음","부반감7화음"];

final List<String> hardType13 = [
  "3화음", "부속7화음", "부7화음", "나폴리화음",
  "부감7화음", "부반감7화음", "부증6화음", "차용화음"
];

final List<String> hardType2 = [
  "부속7화음", "부7화음",
  "부감7화음", "부반감7화음"
  // 프렌치랑 저먼만 들어가야함 augmentedHalfSixthFr augmentedHalfSixthGr
];

final List<String> hardType4 = [
  "3화음", "부속7화음", "부7화음",
  "부감7화음", "부반감7화음"
];



// // get answer, 4note, conditionTonality
// (List<String>,List<Note>,Tonality,List<Note>,String) getSuperEasyProblemType134(){
//
//   List<String> answer ;
//   List<Note> problem ;
//   Tonality condition ;
//   List<Note> problemOriginal ;
//   String problemName ;
//
//   // 문제별 확율 조정
//   int intValue = Random().nextInt(20); // Value is >= 0 and < 20
//
//   if (intValue<7){
//     (answer, problem, condition, problemOriginal, problemName) =
//         basicProblem();
//   } else if (intValue<14){
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblemMinor();
//   }else if (intValue<17){
//     (answer, problem, condition, problemOriginal, problemName) =
//     dominant7thProblem();
//   }else{
//     (answer, problem, condition, problemOriginal, problemName) =
//     dominant7thProblemMinor();
//   }
//
//   return (answer, problem, condition, problemOriginal, problemName);
// }
//
//
// // get answer, 4note, conditionTonality
// (List<String>,List<Note>,Tonality,List<Note>,String) getSuperEasyProblemType2(){
//
//   List<String> answer ;
//   List<Note> problem ;
//   Tonality condition ;
//   List<Note> problemOriginal ;
//   String problemName ;
//
//   // 문제별 확율 조정
//   int intValue = Random().nextInt(2); // Value is >= 0 and < 2
//
//   // List problemListEasy =
//   // [
//   //   dominant7thProblem(),dominant7thProblemMinor()
//   // ];
//   //
//   // (answer, problem, condition, problemOriginal, problemName) =
//   // problemListEasy[intValue];
//
//   if (intValue==0){
//     (answer, problem, condition, problemOriginal, problemName) =
//     dominant7thProblem();
//   }else if (intValue==1){
//     (answer, problem, condition, problemOriginal, problemName) =
//     dominant7thProblemMinor();
//   }else{
//     (answer, problem, condition, problemOriginal, problemName) =
//     dominant7thProblemMinor();
//   }
//
//   return (answer, problem, condition, problemOriginal, problemName);
// }

//
// // get answer, 4note, conditionTonality
// (List<String>,List<Note>,Tonality,List<Note>,String) getEasyProblemType134(){
//
//   List<String> answer ;
//   List<Note> problem ;
//   Tonality condition ;
//   List<Note> problemOriginal ;
//   String problemName ;
//
//   // 문제별 확율 조정
//   int intValue = Random().nextInt(8); // Value is >= 0 and < 8
//
//   // List problemListEasy =
//   // [
//   //   basicProblem(),basicProblemMinor()
//   //   ,secondaryDominant7thProblem(),secondaryDominant7thProblemMinor()
//   //   ,secondaryDiminished7thProblem(),secondaryDiminished7thProblemMinor()
//   //   ,secondaryHalfDiminished7thProblem(),secondaryHalfDiminished7thProblemMinor()
//   // ];
//
//   if (intValue==0){
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblem();
//   } else if (intValue==1){
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblemMinor();
//   }else if (intValue==2){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblem();
//   }else if (intValue==3){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblemMinor();
//   }else if (intValue==4){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblem();
//   }else if (intValue==5){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblemMinor();
//   }else if (intValue==6){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblem();
//   }else if (intValue==7){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblemMinor();
//   }else{
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblem();
//   }
//
//   return (answer, problem, condition, problemOriginal, problemName);
// }
//
//
// // get answer, 4note, conditionTonality
// (List<String>,List<Note>,Tonality,List<Note>,String) getEasyProblemType2(){
//
//   List<String> answer ;
//   List<Note> problem ;
//   Tonality condition ;
//   List<Note> problemOriginal ;
//   String problemName ;
//
//   // 문제별 확율 조정
//   int intValue = Random().nextInt(6); // Value is >= 0 and < 6
//
//   // List problemListEasy =
//   // [
//   //   // basicProblem(),basicProblemMinor()
//   //   secondaryDominant7thProblem(),secondaryDominant7thProblemMinor()
//   //   ,secondaryDiminished7thProblem(),secondaryDiminished7thProblemMinor()
//   //   ,secondaryHalfDiminished7thProblem(),
//   //   secondaryHalfDiminished7thProblemMinor()
//   // ];
//   //
//   // (answer, problem, condition, problemOriginal, problemName) =
//   // problemListEasy[intValue];
//
//   if (intValue==0){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblem();
//   }else if (intValue==1){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblemMinor();
//   }else if (intValue==2){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblem();
//   }else if (intValue==3){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblemMinor();
//   }else if (intValue==4){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblem();
//   }else if (intValue==5){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblemMinor();
//   }else{
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblem();
//   }
//
//   return (answer, problem, condition, problemOriginal, problemName);
// }


// get answer, 4note, conditionTonality
// (List<String>,List<Note>,Tonality,List<Note>,String) getHardProblemType134(){
//
//   List<String> answer ;
//   List<Note> problem ;
//   Tonality condition ;
//   List<Note> problemOriginal ;
//   String problemName ;
//
//   // 문제별 확율 조정
//   int intValue = Random().nextInt(45); // Value is >= 0 and < 45
//
//   if (intValue<3){
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblem();
//   } else if (intValue<6){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblem();
//   }else if (intValue<9){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondary7thProblem();
//   }else if (intValue<12){
//     (answer, problem, condition, problemOriginal, problemName) =
//     neapolitanProblem();
//   }else if (intValue<15){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblem();
//   }else if (intValue<18){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblem();
//   }else if (intValue<19){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthIt();
//   }else if (intValue<20){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthFr();
//   }else if (intValue<21){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthGr();
//   }else if (intValue<24){
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblemBorrowed();
//   }else if (intValue<27){
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblemMinor();
//   }else if (intValue<30){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblemMinor();
//   }else if (intValue<33){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondary7thProblemMinor();
//   }else if (intValue<36){
//     (answer, problem, condition, problemOriginal, problemName) =
//     neapolitanProblemMinor();
//   }else if (intValue<39){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblemMinor();
//   }else if (intValue<42){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblemMinor();
//   }else if (intValue<45){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthItMinor();
//   }else if (intValue<48){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthFrMinor();
//   }else if (intValue<51){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthGrMinor();
//   }else{
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblem();
//   }
//
//   return (answer, problem, condition, problemOriginal, problemName);
// }
//
//
// // get answer, 4note, conditionTonality
// (List<String>,List<Note>,Tonality,List<Note>,String) getHardProblemType2(){
//
//   List<String> answer ;
//   List<Note> problem ;
//   Tonality condition ;
//   List<Note> problemOriginal ;
//   String problemName ;
//
//   // 문제별 확율 조정
//   int intValue = Random().nextInt(20); // Value is >= 0 and < 45
//
//   if (intValue<2){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblem();
//   } else if (intValue<4){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondary7thProblem();
//   }else if (intValue<6){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblem();
//   }else if (intValue<8){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblem();
//   }else if (intValue<9){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthFr();
//   }else if (intValue<10){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthGr();
//   }else if (intValue<12){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblemMinor();
//   }else if (intValue<14){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondary7thProblemMinor();
//   }else if (intValue<16){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblemMinor();
//   }else if (intValue<18){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblemMinor();
//   }else if (intValue<19){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthFrMinor();
//   }else if (intValue<20){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthGrMinor();
//   }else{
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblem();
//   }
//
//   return (answer, problem, condition, problemOriginal, problemName);
// }
//
// // secondary7thProblem 및 secondary7thProblemMinor 제외
// // get answer, 4note, conditionTonality
// (List<String>,List<Note>,Tonality,List<Note>,String)
// getHardProblemType13Temp(){
//
//   List<String> answer ;
//   List<Note> problem ;
//   Tonality condition ;
//   List<Note> problemOriginal ;
//   String problemName ;
//
//   // 문제별 확율 조정
//   int intValue = Random().nextInt(39); // Value is >= 0 and < 45
//
//   if (intValue<3){
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblem();
//   } else if (intValue<6){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblem();
//   }
//   // else if (intValue<9){
//   //   (answer, problem, condition, problemOriginal, problemName) =
//   //   secondary7thProblem();
//   // }
//   else if (intValue<9){
//     (answer, problem, condition, problemOriginal, problemName) =
//     neapolitanProblem();
//   }else if (intValue<12){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblem();
//   }else if (intValue<15){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblem();
//   }else if (intValue<16){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthIt();
//   }else if (intValue<17){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthFr();
//   }else if (intValue<18){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthGr();
//   }else if (intValue<21){
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblemBorrowed();
//   }else if (intValue<24){
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblemMinor();
//   }else if (intValue<27){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblemMinor();
//   }
//   // else if (intValue<33){
//   //   (answer, problem, condition, problemOriginal, problemName) =
//   //   secondary7thProblemMinor();
//   // }
//   else if (intValue<30){
//     (answer, problem, condition, problemOriginal, problemName) =
//     neapolitanProblemMinor();
//   }else if (intValue<33){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblemMinor();
//   }else if (intValue<36){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblemMinor();
//   }else if (intValue<37){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthItMinor();
//   }else if (intValue<38){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthFrMinor();
//   }else if (intValue<39){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthGrMinor();
//   }else{
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblem();
//   }
//
//   return (answer, problem, condition, problemOriginal, problemName);
// }
//
//
// // secondary7thProblem 및 secondary7thProblemMinor 제외
// // 증6제외
// // get answer, 4note, conditionTonality
// (List<String>,List<Note>,Tonality,List<Note>,String)
// getHardProblemType4Temp(){
//
//   List<String> answer ;
//   List<Note> problem ;
//   Tonality condition ;
//   List<Note> problemOriginal ;
//   String problemName ;
//
//   // 문제별 확율 조정
//   int intValue = Random().nextInt(11); // Value is >= 0 and < 45
//
//   if (intValue<1){
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblem();
//   } else if (intValue<2){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblem();
//   }
//   else if (intValue<3){
//     (answer, problem, condition, problemOriginal, problemName) =
//     neapolitanProblem();
//   }else if (intValue<4){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblem();
//   }else if (intValue<5){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblem();
//   }
//   else if (intValue<6){
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblemBorrowed();
//   }else if (intValue<7){
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblemMinor();
//   }else if (intValue<8){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblemMinor();
//   }
//   else if (intValue<9){
//     (answer, problem, condition, problemOriginal, problemName) =
//     neapolitanProblemMinor();
//   }else if (intValue<10){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblemMinor();
//   }else if (intValue<11){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblemMinor();
//   }else{
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblem();
//   }
//
//   return (answer, problem, condition, problemOriginal, problemName);
// }
//
// // secondary7thProblem 및 secondary7thProblemMinor 제외
// // get answer, 4note, conditionTonality
// (List<String>,List<Note>,Tonality,List<Note>,String) getHardProblemType2Temp(){
//
//   List<String> answer ;
//   List<Note> problem ;
//   Tonality condition ;
//   List<Note> problemOriginal ;
//   String problemName ;
//
//   // 문제별 확율 조정
//   int intValue = Random().nextInt(16); // Value is >= 0 and < 45
//
//   if (intValue<2){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblem();
//   } else if (intValue<4){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblem();
//   }else if (intValue<6){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblem();
//   }else if (intValue<7){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthFr();
//   }else if (intValue<8){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthGr();
//   }else if (intValue<10){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDominant7thProblemMinor();
//   }else if (intValue<12){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryDiminished7thProblemMinor();
//   }else if (intValue<14){
//     (answer, problem, condition, problemOriginal, problemName) =
//     secondaryHalfDiminished7thProblemMinor();
//   }else if (intValue<15){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthFrMinor();
//   }else if (intValue<16){
//     (answer, problem, condition, problemOriginal, problemName) =
//     augmentedHalfSixthGrMinor();
//   }else{
//     (answer, problem, condition, problemOriginal, problemName) =
//     basicProblem();
//   }
//
//   return (answer, problem, condition, problemOriginal, problemName);
// }


// get answer, 4note, conditionTonality
(List<String>,List<Note>,Tonality,List<Note>,String) getCustomProblemType(
    List<String> selectedItems
    ){

  List<String> answer ;
  List<Note> problem ;
  Tonality condition ;
  List<Note> problemOriginal ;
  String problemName ;

  // 문제별 확율 조정
  int intValue = Random().nextInt(selectedItems.length); // Value is >= 0 and < selectedItems.length

  String selectedItem = selectedItems[intValue];

  if (selectedItem == '3화음'){
    (answer, problem, condition, problemOriginal, problemName) =
    problemMajorMinorAll(
        basicProblem,
        basicProblemMinor);
  } else if (selectedItem == '부속7화음'){
    (answer, problem, condition, problemOriginal, problemName) =
    problemMajorMinorAll(
        secondaryDominant7thProblem,
        secondaryDominant7thProblemMinor);
  } else if (selectedItem == '속7화음'){
    (answer, problem, condition, problemOriginal, problemName) =
    problemMajorMinorAll(
        dominant7thProblem,
        dominant7thProblemMinor);
  } else if (selectedItem == '부7화음'){
    (answer, problem, condition, problemOriginal, problemName) =
    problemMajorMinorAll(
        secondary7thProblem,
        secondary7thProblemMinor
    );
  } else if (selectedItem == '나폴리화음'){
    (answer, problem, condition, problemOriginal, problemName) =
    problemMajorMinorAll(
        neapolitanProblem,
        neapolitanProblemMinor);
  } else if (selectedItem == '부감7화음'){
    (answer, problem, condition, problemOriginal, problemName) =
    problemMajorMinorAll(
        secondaryDiminished7thProblem,
        secondaryDiminished7thProblemMinor);
  } else if (selectedItem == '감7화음'){
    (answer, problem, condition, problemOriginal, problemName) =
    problemMajorMinorAll(
        diminished7thProblem,
        diminished7thProblemMinor);
  } else if (selectedItem == '증6화음'){
    (answer, problem, condition, problemOriginal, problemName) =
    problemMajorMinorAllSix(
        augmentedSixthIt,
        augmentedSixthFr,
        augmentedSixthGr,
        augmentedSixthItMinor,
        augmentedSixthFrMinor,
        augmentedSixthGrMinor
    );
  } else if (selectedItem == '부반감7화음'){
    (answer, problem, condition, problemOriginal, problemName) =
    problemMajorMinorAll(
        secondaryHalfDiminished7thProblem,
        secondaryHalfDiminished7thProblemMinor);
  } else if (selectedItem == '반감7화음'){
    (answer, problem, condition, problemOriginal, problemName) =
    problemMajorMinorAll(
        halfDiminished7thProblem,
        halfDiminished7thProblemMinor);
  } else if (selectedItem == '부증6화음'){
    (answer, problem, condition, problemOriginal, problemName) =
    problemMajorMinorAllSix(
        augmentedHalfSixthIt,
        augmentedHalfSixthFr,
        augmentedHalfSixthGr,
        augmentedHalfSixthItMinor,
        augmentedHalfSixthFrMinor,
        augmentedHalfSixthGrMinor
    );
  } else if (selectedItem == '부증6화음_fg'){
    (answer, problem, condition, problemOriginal, problemName) =
    problemMajorMinorAllFour(
        augmentedHalfSixthFr,
        augmentedHalfSixthGr,
        augmentedHalfSixthFrMinor,
        augmentedHalfSixthGrMinor
    );
  } else if (selectedItem == '차용화음'){
    (answer, problem, condition, problemOriginal, problemName) =
        basicProblemBorrowed();
  } else {
    (answer, problem, condition, problemOriginal, problemName) =
    problemMajorMinorAll(
        basicProblem,
        basicProblemMinor);
  }

  return (answer, problem, condition, problemOriginal, problemName);
}

(List<String>,List<Note>,Tonality,List<Note>,String) problemMajorMinorAll
    (Function functionMajor,Function functionMinor){

  // final functionMajor;
  // final functionMinor;

  List<String> answer ;
  List<Note> problem ;
  Tonality condition ;
  List<Note> problemOriginal ;
  String problemName ;

  // 문제별 확율 조정
  int intValue = Random().nextInt(2); // Value is >= 0 and < 2

  if (intValue == 0){
    (answer, problem, condition, problemOriginal, problemName) =
    functionMajor();
  } else {
    (answer, problem, condition, problemOriginal, problemName) =
    functionMinor();
  }

  return (answer, problem, condition, problemOriginal, problemName);
}


(List<String>,List<Note>,Tonality,List<Note>,String) problemMajorMinorAllFour
    (Function func1,
    Function func2,
    Function func3,
    Function func4
    ){

  // final functionMajor;
  // final functionMinor;

  List<String> answer ;
  List<Note> problem ;
  Tonality condition ;
  List<Note> problemOriginal ;
  String problemName ;

  // 문제별 확율 조정
  int intValue = Random().nextInt(4); // Value is >= 0 and < 6

  if (intValue == 0){
    (answer, problem, condition, problemOriginal, problemName) =
    func1();
  } else if (intValue == 1) {
    (answer, problem, condition, problemOriginal, problemName) =
    func2();
  } else if (intValue == 2) {
    (answer, problem, condition, problemOriginal, problemName) =
    func3();
  } else if (intValue == 3) {
    (answer, problem, condition, problemOriginal, problemName) =
    func4();
  } else {
    (answer, problem, condition, problemOriginal, problemName) =
    func1();
  }

  return (answer, problem, condition, problemOriginal, problemName);
}

(List<String>,List<Note>,Tonality,List<Note>,String) problemMajorMinorAllSix
    (Function func1,
    Function func2,
    Function func3,
    Function func4,
    Function func5,
    Function func6
    ){

  // final functionMajor;
  // final functionMinor;

  List<String> answer ;
  List<Note> problem ;
  Tonality condition ;
  List<Note> problemOriginal ;
  String problemName ;

  // 문제별 확율 조정
  int intValue = Random().nextInt(6); // Value is >= 0 and < 6

  if (intValue == 0){
    (answer, problem, condition, problemOriginal, problemName) =
    func1();
  } else if (intValue == 1) {
    (answer, problem, condition, problemOriginal, problemName) =
    func2();
  } else if (intValue == 2) {
    (answer, problem, condition, problemOriginal, problemName) =
    func3();
  } else if (intValue == 3) {
    (answer, problem, condition, problemOriginal, problemName) =
    func4();
  } else if (intValue == 4) {
    (answer, problem, condition, problemOriginal, problemName) =
    func5();
  } else if (intValue == 5) {
    (answer, problem, condition, problemOriginal, problemName) =
    func6();
  } else {
    (answer, problem, condition, problemOriginal, problemName) =
    func1();
  }

  return (answer, problem, condition, problemOriginal, problemName);
}

(String,List<Note>,Tonality,List<Note>,String) getAugmentedSixth(){

  String answer ;
  List<Note> problem ;
  Tonality condition ;
  List<Note> problemOriginal ;
  String problemName ;

  // 문제별 확율 조정
  int intValue = Random().nextInt(3); // Value is >= 0 and < 3

  List problemList =
  [augmentedSixthIt(),augmentedSixthFr(),augmentedSixthGr()
  ];

  (answer, problem, condition, problemOriginal, problemName) = problemList[intValue];

  return (answer, problem, condition, problemOriginal, problemName);
}

(String,List<Note>,Tonality,List<Note>,String) getAugmentedSixthMinor(){

  String answer ;
  List<Note> problem ;
  Tonality condition ;
  List<Note> problemOriginal ;
  String problemName ;

  // 문제별 확율 조정
  int intValue = Random().nextInt(3); // Value is >= 0 and < 3

  List problemList =
  [augmentedSixthItMinor(),augmentedSixthFrMinor(),augmentedSixthGrMinor()
  ];

  (answer, problem, condition, problemOriginal, problemName) = problemList[intValue];

  return (answer, problem, condition, problemOriginal, problemName);
}

(String,List<Note>,Tonality,List<Note>,String) getAugmentedHalfSixth(){

  String answer ;
  List<Note> problem ;
  Tonality condition ;
  List<Note> problemOriginal ;
  String problemName ;

  // 문제별 확율 조정
  int intValue = Random().nextInt(3); // Value is >= 0 and < 3

  List problemList =
  [augmentedHalfSixthIt(),augmentedHalfSixthFr(),augmentedHalfSixthGr()
  ];

  (answer, problem, condition, problemOriginal, problemName) = problemList[intValue];

  return (answer, problem, condition, problemOriginal, problemName);
}

(String,List<Note>,Tonality,List<Note>,String) getAugmentedHalfSixthMinor(){

  String answer ;
  List<Note> problem ;
  Tonality condition ;
  List<Note> problemOriginal ;
  String problemName ;

  // 문제별 확율 조정
  int intValue = Random().nextInt(3); // Value is >= 0 and < 3

  List problemList =
  [augmentedHalfSixthItMinor(),augmentedHalfSixthFrMinor(),augmentedHalfSixthGrMinor()
  ];

  (answer, problem, condition, problemOriginal, problemName) = problemList[intValue];

  return (answer, problem, condition, problemOriginal, problemName);
}

// List<PositionedNote>
List<PositionedNote> getSopranoPNDominateList(List<Note> problem){

  Note order4 = problem[3];

  // print('order4 ${order4}');
  // print('order4 ${order4.baseNote.toString()}');
  // print('order4 ${order4.baseNote.name.toString()}');

  List<PositionedNote> sopranoDominateList ;

  // 소프라노 정의
  if (['b','a','g','f','e'].contains(order4.baseNote.name.toString())){
    sopranoDominateList = [order4.inOctave(5),order4.inOctave(4)];
  } else {
    sopranoDominateList = [order4.inOctave(5)];
  }

  return sopranoDominateList;
}

// 소프라노 음을 넣으면 PositinoedNote 형식으로
// 알토 범위, 테너 범위, 베이스 범위를 지켜서
// 한 세트를 return 만약
// 범위에 맞지 않을 경우 false 리턴
getAltPN(PositionedNote soprano,List<Note> problem){

  Note order3 = problem[2];

  // print('order3 ${order3}');

  // #######################################################
  // 알토 구하기
  // 다음 7개 음 가지고 오기
  // print('PositionedNote soprano ${soprano}');
  String sopranoString = positionedNoteToString(soprano);
  String altOctave =
    getNextNoteOctave(sopranoString, order3.baseNote.name.toString());
  // print('altOctave ${altOctave}');

  if (altOctave == '0'){
    // print('return false');
    return false ;
  }

  PositionedNote altDominant = order3.inOctave(int.parse(altOctave));
  String altDominantString = positionedNoteToString(altDominant);
  PositionedNote altDominantStringPosition =
  stringToPositionedNote(altDominantString);

  // print('altDominant ${altDominant}');
  // print('altDominantString ${altDominantString}');
  // print('altDominantStringPosition ${altDominantStringPosition}');

  if (!altRange.contains(altDominantStringPosition)){
    // print('return false');
    return false ;
  }

  // print('input soprano $soprano');
  // print('altDominant $altDominant');

  return altDominant ;

}

getTenPN(var alto,List<Note> problem){

  if (alto == false){
    // print('return false');
    return false ;
  }

  Note order2 = problem[1];

  // print('order2 ${order2}');

  // #######################################################
  // 알토 구하기
  // 다음 7개 음 가지고 오기
  // print('PositionedNote alto ${alto}');
  String altoString = positionedNoteToString(alto);
  String tenOctave =
  getNextNoteOctave(altoString, order2.baseNote.name.toString());
  // print('tenOctave ${tenOctave}');

  if (tenOctave == '0'){
    // print('return false');
    return false ;
  }

  PositionedNote tenDominant = order2.inOctave(int.parse(tenOctave));
  String tenDominantString = positionedNoteToString(tenDominant);
  PositionedNote tenDominantStringPosition =
  stringToPositionedNote(tenDominantString);

  // print('tenDominant ${tenDominant}');
  // print('tenDominantString ${tenDominantString}');
  // print('tenDominantStringPosition ${tenDominantStringPosition}');

  if (!tenRange.contains(tenDominantStringPosition)){
    // print('return false');
    return false ;
  }

  return tenDominant ;

}

getBaseOctaveList(var ten,List<Note> problem){
  if (ten == false){
    // print('return false');
    return false ;
  }

  Note order1 = problem[0];

  // print('order1 ${order1}');

  // ten 기준으로 다음 음 모두 가져오기
  String tenString = positionedNoteToString(ten);
  List<String> nextStringNoteAll = getNextNoteStringAll(tenString);

  String nextOctave = '0' ;
  List<String> nextOctaveList = [] ;

  int i = 0 ;
  while(i<nextStringNoteAll.length) {
    if (nextStringNoteAll[i].contains(order1.baseNote.name.toString())){
      PositionedNote tempPN = stringToPositionedNote(nextStringNoteAll[i]);
      if (baseRange.contains(tempPN)){
        nextOctaveList.add(nextStringNoteAll[i].substring(1,2));
      }
    }
    i++;
  }

  if (nextOctaveList.length == 0){
    return false;
  }

  List<PositionedNote> nextBasePNList = [] ;

  i = 0 ;
  while(i<nextOctaveList.length) {
    nextBasePNList.add(order1.inOctave(int.parse(nextOctaveList[i])));
    i++;
  }

  return nextBasePNList ;
}

int getDistanceInt(List<PositionedNote> listPositionedNote,int zeroOneTwe){

  int upNote = zeroOneTwe;
  int downNote = zeroOneTwe + 1;


  // ten base 간격이 12도까지 가능 / 그 이상일 경우 제외하는 로직 추가
  String baseNoteString = listPositionedNote[downNote].note.baseNote.name.toString();
  String baseOctaveString = listPositionedNote[downNote].octave.toString();
  PositionedNote baseNoteAndOctave = Note.parse(baseNoteString).inOctave(int.parse
    (baseOctaveString)) ;

  String tenNoteString = listPositionedNote[upNote].note.baseNote.name.toString();
  String tenOctaveString = listPositionedNote[upNote].octave.toString();
  PositionedNote tenNoteAndOctave = Note.parse(tenNoteString).inOctave(int
      .parse
    (tenOctaveString)) ;

  int distanceBtwBaseTen = (notePositionMapLow[baseNoteAndOctave]! -
      notePositionMapLow[tenNoteAndOctave]!).abs() + 1;
  // print('distanceBtwBaseTen $distanceBtwBaseTen');

  return distanceBtwBaseTen;
}

// 최종 note to pnote
List<PositionedNote> noteToPositionedNote(List<Note> problem){

  List<List<PositionedNote>> finalList = [] ;
  // 추가 필터
  // base ten 간격 12도까지 허용
  // 소프-알토 알토-테너 테너-베이스 간격 3도 이상 조건 맞는 대상만
  List<List<PositionedNote>> finalListFinal = [] ;

  // get soprano list
  List<PositionedNote> sopranoDomiList = getSopranoPNDominateList(problem);

  // 경우의 수가 2개밖에 안되므로 2개를 그냥 나누어서 수행
  if (sopranoDomiList.length == 1){
    // print('soprano 1');
    var altPn = getAltPN(sopranoDomiList[0],problem);
    var tenPn = getTenPN(altPn,problem);
    var basePn = getBaseOctaveList(tenPn, problem);

    if (basePn!=false){
      if (basePn.length == 1){
        finalList.add([sopranoDomiList[0],altPn,tenPn,basePn[0]]);
      } else {
        finalList.add([sopranoDomiList[0],altPn,tenPn,basePn[0]]);
        finalList.add([sopranoDomiList[0],altPn,tenPn,basePn[1]]);
      }
    }

  } else {
    // print('soprano 2');
    var altPn1 = getAltPN(sopranoDomiList[0],problem);
    var tenPn1 = getTenPN(altPn1,problem);
    var basePn1 = getBaseOctaveList(tenPn1, problem);

    var altPn2 = getAltPN(sopranoDomiList[1],problem);
    var tenPn2 = getTenPN(altPn2,problem);
    var basePn2 = getBaseOctaveList(tenPn2, problem);


    if (basePn1!=false){
      if (basePn1.length == 1){
        finalList.add([sopranoDomiList[0],altPn1,tenPn1,basePn1[0]]);
      } else {
        finalList.add([sopranoDomiList[0],altPn1,tenPn1,basePn1[0]]);
        finalList.add([sopranoDomiList[0],altPn1,tenPn1,basePn1[1]]);
      }
    }

    if (basePn2!=false){
      if (basePn2.length == 1){
        finalList.add([sopranoDomiList[1],altPn2,tenPn2,basePn2[0]]);
      } else {
        finalList.add([sopranoDomiList[1],altPn2,tenPn2,basePn2[0]]);
        finalList.add([sopranoDomiList[1],altPn2,tenPn2,basePn2[1]]);
      }
    }
  }


  int iterTemp = 0;
  List<PositionedNote> finalListEachTemp = [];

  List<PositionedNote> baseCutList = [
    const PositionedNote(Note.d,octave: 2)
    ,const PositionedNote(Note.c,octave: 2)
    ,const PositionedNote(Note.b,octave: 1)
    ,const PositionedNote(Note.a,octave: 1)
    ,const PositionedNote(Note.g,octave: 1)
    ,const PositionedNote(Note.f,octave: 1)
    ,const PositionedNote(Note.e,octave: 1)
    ,const PositionedNote(Note.d,octave: 1)
    ,const PositionedNote(Note.c,octave: 1)
  ];


  while(iterTemp<finalList.length) {
    finalListEachTemp = finalList[iterTemp];
    // 텐-베이스 간격 12도 이내 조건
    int DistanceBaseTen =
    getDistanceInt(finalListEachTemp,2);
    int DistanceTenAlt =
    getDistanceInt(finalListEachTemp,1);
    int DistanceAltSop =
    getDistanceInt(finalListEachTemp,0);

    if (
    (DistanceBaseTen<=12)
    &(DistanceBaseTen>2)
    &(DistanceTenAlt>2)
    &(DistanceAltSop>2)
    ){
      if (!baseCutList.contains(
          PositionedNote(Note.parse(finalListEachTemp[3].note.baseNote
            .name.toString()),
              octave:
          finalListEachTemp[3].octave)
          )){
        finalListFinal.add(finalListEachTemp);
      }
    }

    // print('나는 ${fruits[i]}를 좋아해');
    iterTemp++;
  }

  // print('finalList $finalList');

  List<PositionedNote> finalListPick ;
  // 한개만 내뱉게 수정
  if (finalListFinal.length>1){
    int intValue = Random().nextInt(finalListFinal.length);
    finalListPick = finalListFinal[intValue];
  } else if (finalListFinal.length==1){
    finalListPick = finalListFinal[0];
  } else {
    finalListPick = [];
  }

  return finalListPick;
}



// c,d,e,f,g,a,b // 2~5
// 리스트 생성
// input ex c4 -> 아래로 쭉 리스트 생성 7개
List<String> getNextNoteString7(String noteString){
  List<String> noteStringList = [
    'b5',	'a5',	'g5',	'f5',	'e5',	'd5',	'c5',	'b4',	'a4',	'g4',	'f4',	'e4',	'd4',	'c4',	'b3',	'a3',	'g3',	'f3',	'e3',	'd3',	'c3',	'b2',	'a2',	'g2',	'f2',	'e2',	'd2',
  ];

  int noteStringIndex = noteStringList.indexOf(noteString);

  int lastRange ;
  // 만약 더 길면?
  if (noteStringIndex+8 > noteStringList.length){
    lastRange = noteStringList.length;
  } else {
    lastRange = noteStringIndex+8;
  }

  List<String> targetStringNote =
  noteStringList.getRange(noteStringIndex+1, lastRange).toList();

  // print('targetStringNote $targetStringNote');

  return targetStringNote;
}

List<String> getNextNoteStringAll(String noteString){
  List<String> noteStringList = [
    'b5',	'a5',	'g5',	'f5',	'e5',	'd5',	'c5',	'b4',	'a4',	'g4',	'f4',	'e4',	'd4',	'c4',	'b3',	'a3',	'g3',	'f3',	'e3',	'd3',	'c3',	'b2',	'a2',	'g2',	'f2',	'e2',	'd2',
  ];

  int noteStringIndex = noteStringList.indexOf(noteString);

  List<String> targetStringNote =
  noteStringList.getRange(noteStringIndex+1, noteStringList.length).toList();

  return targetStringNote;
}

// input ex 'a4', 'b'
String getNextNoteOctave(String upNoteOctave, String downNote){

  String downNoteOctave = '0' ;

  List<String> targetStringNote = getNextNoteString7(upNoteOctave);

  int i = 0 ;
  while(i<targetStringNote.length) {
    if (targetStringNote[i].contains(downNote)){
      downNoteOctave = targetStringNote[i].substring(1,2);
    }
    i++;
  }

  // print('downNoteOctave ${downNoteOctave}');

  // print('downNoteOctave ${downNoteOctave}');
  return downNoteOctave;
}

// positioned note to string
String positionedNoteToString(PositionedNote thenote){
  String thenoteString = thenote.note.baseNote.name
      .toString() + thenote.octave.toString();
  return thenoteString;
}

// positioned note to string
PositionedNote stringToPositionedNote(String stringNoteInoctave){

  PositionedNote positionedNoteRlt =
  Note.parse(stringNoteInoctave.substring(0,1)).inOctave(int
      .parse(stringNoteInoctave.substring(1,2)));

  return positionedNoteRlt ;
}



// 알토 범위
List<PositionedNote> altRange = [
  Note.c.inOctave(5),

  Note.b.inOctave(4),
  Note.a.inOctave(4),
  Note.g.inOctave(4),
  Note.f.inOctave(4),
  Note.e.inOctave(4),
  Note.d.inOctave(4),
  Note.c.inOctave(4),

  Note.b.inOctave(3),
  Note.a.inOctave(3),
];
// 테너 범위
List<PositionedNote> tenRange = [
  Note.f.inOctave(4),
  Note.e.inOctave(4),
  Note.d.inOctave(4),
  Note.c.inOctave(4),

  Note.b.inOctave(3),
  Note.a.inOctave(3),
  Note.g.inOctave(3),
  Note.f.inOctave(3),
  Note.e.inOctave(3),
  Note.d.inOctave(3),
];
// 베이스 범위
List<PositionedNote> baseRange = [
  Note.b.inOctave(3),
  Note.a.inOctave(3),
  Note.g.inOctave(3),
  Note.f.inOctave(3),
  Note.e.inOctave(3),
  Note.d.inOctave(3),
  Note.c.inOctave(3),

  Note.b.inOctave(2),
  Note.a.inOctave(2),
  Note.g.inOctave(2),
  Note.f.inOctave(2),
  Note.e.inOctave(2),
  Note.d.inOctave(2),
];









