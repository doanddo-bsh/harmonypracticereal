import "dart:math";
import 'package:music_notes/music_notes.dart';
import 'modulBasic.dart';
import 'modulBasicMinor.dart';


// 차용 문제를 위해
// major minor 50% 확율로 뽑는 함수
String majorOrMinor(){
  // chose base 근, 3, 5  // 확율 15, 70, 15
  int intValue = Random().nextInt(2); // Value is >= 0 and < 2.
  Note baseNote ;
  int baseNoteWhere ;

  if (intValue == 0) {
    return 'major';
  } else {
    return 'minor';
  }
}

// 차용 문제를 위해 15개 메이져 / 마이너 map 변수 생성
Map<Tonality,Tonality> majorMapMinor = {

  Note.a.minor:Note.a.major
  ,Note.e.minor:Note.e.major
  ,Note.b.minor:Note.b.major
  ,Note.f.sharp.minor:Note.f.sharp.major

  ,Note.c.sharp.minor:Note.c.sharp.major

  ,Note.d.minor:Note.d.major
  ,Note.g.minor:Note.g.major
  ,Note.c.minor:Note.c.major
  ,Note.f.minor:Note.f.major

  ,Note.b.flat.minor:Note.b.flat.major
  ,Note.e.flat.minor:Note.e.flat.major
  ,Note.a.flat.minor:Note.a.flat.major


  ,Note.a.major:Note.a.minor
  ,Note.e.major:Note.e.minor
  ,Note.b.major:Note.b.minor
  ,Note.f.sharp.major:Note.f.sharp.minor

  ,Note.c.sharp.major:Note.c.sharp.minor

  ,Note.d.major:Note.d.minor
  ,Note.g.major:Note.g.minor
  ,Note.c.major:Note.c.minor
  ,Note.f.major:Note.f.minor

  ,Note.b.flat.major:Note.b.flat.minor
  ,Note.e.flat.major:Note.e.flat.minor
  ,Note.a.flat.major:Note.a.flat.minor

};

// basic 차용문제
// 1. major minor 정하기
// major 로 정하면 조건 major, 문제 minor

(List<String>,List<Note>,Tonality,List<Note>,String) basicProblemBorrowed(){

  // major minor 결정
  String majorOrMinorChosen = majorOrMinor();


  List<String> answer ;
  List<Note> note4Answer ;
  Tonality chosenTonality ;
  List<Note> note4AnswerOriginal ;
  String problemName ;

  if (majorOrMinorChosen == 'major'){
    (answer,note4Answer,chosenTonality,note4AnswerOriginal,problemName) = basicProblem
      (conditionTonalityCondition:'borrow');
  } else {
    (answer,note4Answer,chosenTonality,note4AnswerOriginal,problemName) = basicProblemMinor
      (conditionTonalityCondition:'borrow');
  }
  Tonality chosenTonalityReal = majorMapMinor[chosenTonality]! ;


  return (answer,note4Answer,chosenTonalityReal,note4AnswerOriginal,'basicProblemBorrowed');
}