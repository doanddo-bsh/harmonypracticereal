import "dart:math";
import 'package:music_notes/music_notes.dart';
import 'package:numerus/numerus.dart';
import "package:music_notes/music_notes.dart";
import 'modulBasic.dart';
import 'modulBasicMinor.dart';
import 'modulBorrowed.dart';

// get answer, 4note, conditionTonality
(String,List<Note>,Tonality) getProblem1(){

  String answer ;
  List<Note> problem ;
  Tonality condition ;

  // 문제별 확율 조정
  int intValue = Random().nextInt(11); // Value is >= 0 and < 11

  if (intValue == 0) {
    (answer, problem, condition) = basicProblem();
  } else if (intValue == 1) {
    (answer, problem, condition) = secondaryDominant7thProblem();
  } else if (intValue == 2) {
    (answer, problem, condition) = neapolitanProblem();
  } else if (intValue == 3) {
    (answer, problem, condition) = secondaryDiminished7thProblem();
  } else if (intValue == 4) {
    (answer, problem, condition) = augmentedSixthIt();
  } else if (intValue == 5) {
    (answer, problem, condition) = augmentedSixthFr();
  } else if (intValue == 6) {
    (answer, problem, condition) = augmentedSixthGr();
  } else if (intValue == 7) {
    (answer, problem, condition) = secondaryHalfDiminished7thProblem();
  } else if (intValue == 8) {
    (answer, problem, condition) = augmentedHalfSixthIt();
  } else if (intValue == 9) {
    (answer, problem, condition) = augmentedHalfSixthFr();
  } else if (intValue == 10) {
    (answer, problem, condition) = augmentedHalfSixthGr();
  } else {
    (answer, problem, condition) = basicProblem();
  }

  return (answer, problem, condition);
}

//
//
// int intValue = Random().nextInt(4); // Value is >= 0 and < 4.
// Note baseNote ;
// List<Note> finalProblem ;
// String answer;
//
// if (intValue == 0) {
// baseNote = baseFinal.sharp; // 1음 Fr 6/5
// answer = 'Fr 6/5';
// } else if (intValue == 1) {
// baseNote = baseFinalUp5Up1.flat; // 1음 Fr 6/5
// answer = 'Fr 6';
// } else if (intValue == 2) {
// baseNote = baseFinalUp5Up2; // 1음 Fr 6/5
// answer = 'Fr 4/2';
// } else {
// baseNote = baseFinalUp5Up3; // 1음 Fr 6/5
// answer = 'Fr 7/5';
// }
