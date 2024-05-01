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

// List<PositionedNote>
void addPosition(List<Note> problem){
  print('problem ${problem}');

  Note order1 = problem[0];
  Note order2 = problem[1];
  Note order3 = problem[2];
  Note order4 = problem[3];

  print('order4 ${order4}');
  print('order4 ${order4.baseNote.toString()}');
  print('order4 ${order4.baseNote.name.toString()}');

  if (order4.baseNote.toString() == '1'){
    print('yes');
  } else {
    print('no');
  }
  // 최종 정답셋을 담는 그릇
  List<List<PositionedNote>> answerPositioned ;


  // 소프라노 정의
  List<PositionedNote> sopranoDominate ;
  if (['b','a','g','f','e'].contains(order4.baseNote.name.toString())){
    sopranoDominate = [order4.inOctave(5),order4.inOctave(4)];
  } else {
    sopranoDominate = [order4.inOctave(5)];
  }
}

// 소프라노 음을 넣으면 PositinoedNote 형식으로
// 알토 범위, 테너 범위, 베이스 범위를 지켜서
// 한 세트를 return 만약
// 범위에 맞지 않을 경우 false 리턴
getPositioned4NoteOrFalse(PositionedNote soprano,Note order3, Note order2,
    Note order1){

  // 다음 7개 음 가지고 오기
  String sopranoString = positionedNoteToString(soprano);
  String tenOctave = getNextNoteOctave(sopranoString, order3.baseNote.name
      .toString());

  if (tenOctave == '0'){
    return false ;
  }

  if (soprano==Note.a.inOctave(3)){
    return false;
  } else {
    return [];
  }
  // int sopranoIndex = noteStringList.indexOf(soprano);
}

// c,d,e,f,g,a,b // 2~5
// 리스트 생성
// input ex c4 -> 아래로 쭉 리스트 생성 7개
List<String> getNextNoteString(String noteString){
  List<String> noteStringList = [
    'b5',	'a5',	'g5',	'f5',	'e5',	'd5',	'c5',	'b4',	'a4',	'g4',	'f4',	'e4',	'd4',	'c4',	'b3',	'a3',	'g3',	'f3',	'e3',	'd3',	'c3',	'b2',	'a2',	'g2',	'f2',	'e2',	'd2',
  ];

  int noteStringIndex = noteStringList.indexOf(noteString);

  int lastRange ;
  if (noteStringIndex+8>noteStringList.length){
    lastRange = noteStringList.length;
  } else {
    lastRange = noteStringIndex+8;
  }


  List<String> targetStringNote =
  noteStringList.getRange(noteStringIndex+1, lastRange).toList();

  return targetStringNote;
}

// input ex 'a4', 'b'
String getNextNoteOctave(String upNoteOctave, String downNote){

  String downNoteOctave = '0' ;

  List<String> targetStringNote = getNextNoteString(upNoteOctave);

  int i = 0 ;
  while(i<targetStringNote.length) {
    if (targetStringNote[i].contains(downNote)){
      downNoteOctave = targetStringNote[i].substring(1,2);
    }
    i++;
  }

  print('downNoteOctave ${downNoteOctave}');

  return downNoteOctave;
}

// positioned note to string
String positionedNoteToString(PositionedNote thenote){
  String thenoteString = thenote.note.baseNote.name
      .toString() + thenote.octave.toString();
  return thenoteString;
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









