import "dart:math";
import 'package:music_notes/music_notes.dart';
import 'package:numerus/numerus.dart';
import "package:music_notes/music_notes.dart";


Tonality getConditionalTonalitMinor(String diminished7){

  final _random = new Random();

  List<Tonality> conditionList ;

  if (diminished7 == 'yes'){
    conditionList = [

      Note.a.minor
      ,Note.e.minor
      ,Note.b.minor
      ,Note.f.sharp.minor

      ,Note.c.sharp.minor
      ,Note.g.sharp.minor

      ,Note.d.minor
      ,Note.g.minor
      ,Note.c.minor
      ,Note.f.minor

      ,Note.b.flat.minor

      // ,Note.d.sharp.minor
      // ,Note.a.sharp.minor
      // ,Note.e.flat.minor
      // ,Note.a.flat.minor
    ];
  } else if (diminished7=='borrow'){
    conditionList = [
      Note.a.minor
      ,Note.e.minor
      ,Note.b.minor
      ,Note.f.sharp.minor

      ,Note.c.sharp.minor
      // ,Note.g.sharp.minor
      // ,Note.d.sharp.minor
      // ,Note.a.sharp.minor

      ,Note.d.minor
      ,Note.g.minor
      ,Note.c.minor
      ,Note.f.minor

      ,Note.b.flat.minor
      ,Note.e.flat.minor
      ,Note.a.flat.minor
    ];
  } else {
    conditionList = [
      Note.a.minor
      ,Note.e.minor
      ,Note.b.minor
      ,Note.f.sharp.minor

      ,Note.c.sharp.minor
      ,Note.g.sharp.minor
      ,Note.d.sharp.minor
      ,Note.a.sharp.minor

      ,Note.d.minor
      ,Note.g.minor
      ,Note.c.minor
      ,Note.f.minor

      ,Note.b.flat.minor
      ,Note.e.flat.minor
      ,Note.a.flat.minor
    ];
  }

  Tonality chosen = conditionList[_random.nextInt(conditionList.length)];

  return chosen;

}

int getOneToSeven(){

  final _random = new Random();

  List<int> oneToSeven = [1,2,3,4,5,6,7];

  int chosen = oneToSeven[_random.nextInt(oneToSeven.length)];

  return chosen;
}


Note addSharpByTonalityMinor(Note baseBeforeAccident,Tonality
conditionalTonality){

  if (conditionalTonality == Note.a.minor)
  {
    return baseBeforeAccident;
  } else if ((conditionalTonality == Note.e.minor)&&
      ([Note.f].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.b.minor)&&
      ([Note.f,Note.c].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.f.sharp.minor)&&
      ([Note.f,Note.c,Note.g].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.c.sharp.minor)&&
      ([Note.f,Note.c,Note.g,Note.d].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.g.sharp.minor)&&
      ([Note.f,Note.c,Note.g,Note.d,Note.a].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.d.sharp.minor)&&
      ([Note.f,Note.c,Note.g,Note.d,Note.a,Note.e].contains
        (baseBeforeAccident)))
  {
    return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.a.sharp.minor)&&
      ([Note.f,Note.c,Note.g,Note.d,Note.a,Note.e,Note.b].contains
        (baseBeforeAccident)))
  {
    return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.d.minor)&&
      ([Note.b].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else if ((conditionalTonality == Note.g.minor)&&
      ([Note.b,Note.e].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else if ((conditionalTonality == Note.c.minor)&&
      ([Note.b,Note.e,Note.a].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else if ((conditionalTonality == Note.f.minor)&&
      ([Note.b,Note.e,Note.a,Note.d].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else if ((conditionalTonality == Note.b.flat.minor)&&
      ([Note.b,Note.e,Note.a,Note.d,Note.g].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else if ((conditionalTonality == Note.e.flat.minor)&&
      ([Note.b,Note.e,Note.a,Note.d,Note.g,Note.c].contains
        (baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else if ((conditionalTonality == Note.a.flat.minor)&&
      ([Note.b,Note.e,Note.a,Note.d,Note.g,Note.c,Note.f].contains
        (baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else {
    return baseBeforeAccident;
  }
}

// 정답 / 문제 return
(String,List<Note>,Tonality) basicProblemMinor(String conditionTonalityCondition){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonalitMinor(conditionTonalityCondition);
  int chosenInt1to7 = getOneToSeven();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  // 단조라서 7음일때 반음 올림 적용
  Note baseFinal ;
  // when 7 add sharp
  if (chosenInt1to7 == 7){
    Note baseFinalTemp = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;
    Note baseFinalTemp2 = baseFinalTemp.transposeBy(Interval.m2) ;
    baseFinal = baseFinalTemp2.respelledDownwards;
  } else {
    baseFinal = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;
  }

  Note baseFinalUp1 ;
  Note baseFinalUp2 ;

  if ([1,4].contains(chosenInt1to7)){
    baseFinalUp1 = baseFinal.transposeBy(Interval.m3);
    baseFinalUp2 = baseFinalUp1.transposeBy(Interval.M3);
  } else if ([3,5,6].contains(chosenInt1to7)){
    baseFinalUp1 = baseFinal.transposeBy(Interval.M3);
    baseFinalUp2 = baseFinalUp1.transposeBy(Interval.m3);
  } else {
    baseFinalUp1 = baseFinal.transposeBy(Interval.m3);
    baseFinalUp2 = baseFinalUp1.transposeBy(Interval.m3);
  }
  // 근음 + M3, m3, m3

  print('==========================================');
  print('chosenTonality ${chosenTonality}');
  print('chosenInt1to7 ${chosenInt1to7}');

  print('baseFinal ${baseFinal}');

  List<Note> note3Origianl = [baseFinal, baseFinalUp1, baseFinalUp2];

  List<Note> note3Shuffle = [baseFinal, baseFinalUp1, baseFinalUp2];

  // 최종 문제
  note3Shuffle.shuffle() ;

  print('note 3 original ${note3Origianl}');

  print('note 3 shuffle ${note3Shuffle}');

  // 정답 산출
  Note baseChosen = note3Shuffle[0];

  int baseNoteWhere = note3Origianl.indexOf(baseChosen) ;

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자
  String answerRome ;
  String addNumber ;

  if ([3,5,6].contains(chosenInt1to7)){
    answerRome = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    answerRome = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (baseNoteWhere == 0){
    addNumber = '';
  } else if (baseNoteWhere == 1){
    addNumber = '6';
  } else {
    addNumber = '6/4';
  }

  print('answer ${answerRome+' ' + addNumber}');

  // 추가음 결정
  // 1,4,5 -> 근음, 5음
  // 2,3,6 -> 근음, 3음
  // 7 -> 3음, 5음
  Note addNote ;
  final _random = new Random();
  if ([1,4,5].contains(chosenInt1to7)){
    List<Note> dominateList = [note3Origianl[0],note3Origianl[2]] ;
    addNote = dominateList[_random.nextInt(dominateList.length)];
  } else if ([2,3,6].contains(chosenInt1to7)){
    List<Note> dominateList = [note3Origianl[0],note3Origianl[1]] ;
    addNote = dominateList[_random.nextInt(dominateList.length)];
  } else {
    List<Note> dominateList = [note3Origianl[1],note3Origianl[2]] ;
    addNote = dominateList[_random.nextInt(dominateList.length)];
  }

  print('addNote ${addNote}');

  List<Note> note3ShuffleTemp = [note3Shuffle[1], note3Shuffle[2],addNote] ;
  note3ShuffleTemp.shuffle();

  List<Note> note4Shuffle =
      [note3Shuffle[0]] + note3ShuffleTemp;

  print('final problem ${note4Shuffle}');

  return (answerRome+addNumber,note4Shuffle,chosenTonality);
}

