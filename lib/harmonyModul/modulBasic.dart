// ignore_for_file: non_constant_identifier_names

import "dart:math";
import 'package:music_notes/music_notes.dart';
import 'package:numerus/numerus.dart';


// ⊙
// ∅


Tonality getConditionalTonality(String diminished7){

  final _random = Random();

  List<Tonality> conditionList ;

  if (diminished7 == 'yes'){
    conditionList = [

      Note.c.major
      ,Note.g.major
      ,Note.d.major
      ,Note.a.major

      ,Note.e.major
      ,Note.b.major

      ,Note.f.major
      ,Note.b.flat.major
      ,Note.e.flat.major
      ,Note.a.flat.major

      ,Note.d.flat.major

      // ,Note.f.sharp.major
      // ,Note.c.sharp.major
      // Note.g.flat.major
      // ,Note.c.flat.major
    ];
  } else if(diminished7 == 'borrow') {
    conditionList = [
      Note.c.major
      ,Note.g.major
      ,Note.d.major
      ,Note.a.major

      ,Note.e.major
      ,Note.b.major
      ,Note.f.sharp.major
      ,Note.c.sharp.major

      ,Note.f.major
      ,Note.b.flat.major
      ,Note.e.flat.major
      ,Note.a.flat.major

      // ,Note.d.flat.major
      // ,Note.g.flat.major
      // ,Note.c.flat.major

    ];
  } else {
    conditionList = [
      Note.c.major
      ,Note.g.major
      ,Note.d.major
      ,Note.a.major

      ,Note.e.major
      ,Note.b.major
      ,Note.f.sharp.major
      ,Note.c.sharp.major

      ,Note.f.major
      ,Note.b.flat.major
      ,Note.e.flat.major
      ,Note.a.flat.major

      ,Note.d.flat.major
      ,Note.g.flat.major
      ,Note.c.flat.major
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

Note addSharpByTonality(Note baseBeforeAccident,Tonality conditionalTonality){

  if (conditionalTonality == Note.c.major)
  {
    return baseBeforeAccident;
  } else if ((conditionalTonality == Note.g.major)&&
      ([Note.f].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.d.major)&&
      ([Note.f,Note.c].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.a.major)&&
      ([Note.f,Note.c,Note.g].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.e.major)&&
  ([Note.f,Note.c,Note.g,Note.d].contains(baseBeforeAccident)))
  {
  return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.b.major)&&
      ([Note.f,Note.c,Note.g,Note.d,Note.a].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.f.sharp.major)&&
      ([Note.f,Note.c,Note.g,Note.d,Note.a,Note.e].contains
        (baseBeforeAccident)))
  {
    return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.c.sharp.major)&&
      ([Note.f,Note.c,Note.g,Note.d,Note.a,Note.e,Note.b].contains
        (baseBeforeAccident)))
  {
    return baseBeforeAccident.sharp ;
  } else if ((conditionalTonality == Note.f.major)&&
      ([Note.b].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else if ((conditionalTonality == Note.b.flat.major)&&
      ([Note.b,Note.e].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else if ((conditionalTonality == Note.e.flat.major)&&
      ([Note.b,Note.e,Note.a].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else if ((conditionalTonality == Note.a.flat.major)&&
      ([Note.b,Note.e,Note.a,Note.d].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else if ((conditionalTonality == Note.d.flat.major)&&
      ([Note.b,Note.e,Note.a,Note.d,Note.g].contains(baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else if ((conditionalTonality == Note.g.flat.major)&&
      ([Note.b,Note.e,Note.a,Note.d,Note.g,Note.c].contains
        (baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else if ((conditionalTonality == Note.c.flat.major)&&
      ([Note.b,Note.e,Note.a,Note.d,Note.g,Note.c,Note.f].contains
        (baseBeforeAccident)))
  {
    return baseBeforeAccident.flat ;
  } else {
    return baseBeforeAccident;
  }
}

// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String) basicProblem(
    {String conditionTonalityCondition='no'}
    ) {

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality(conditionTonalityCondition);
  int chosenInt1to7 = getOneToSeven();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonality(baseBeforeAccident,chosenTonality) ;


  Note baseFinalUp1 ;
  Note baseFinalUp2 ;

  if ([1,4,5].contains(chosenInt1to7)){
    baseFinalUp1 = baseFinal.transposeBy(Interval.M3);
    baseFinalUp2 = baseFinalUp1.transposeBy(Interval.m3);
  } else if ([2,3,6].contains(chosenInt1to7)){
    baseFinalUp1 = baseFinal.transposeBy(Interval.m3);
    baseFinalUp2 = baseFinalUp1.transposeBy(Interval.M3);
  } else {
    baseFinalUp1 = baseFinal.transposeBy(Interval.m3);
    baseFinalUp2 = baseFinalUp1.transposeBy(Interval.m3);
  }
  // 근음 + M3, m3, m3



  List<Note> note3Origianl = [baseFinal, baseFinalUp1, baseFinalUp2];

  List<Note> note3Shuffle = [baseFinal, baseFinalUp1, baseFinalUp2];

  // 최종 문제
  note3Shuffle.shuffle() ;



  // 정답 산출
  Note baseChosen = note3Shuffle[0];

  int baseNoteWhere = note3Origianl.indexOf(baseChosen) ;

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자
  // String addNumber ;

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '' ;
  String D2 = '' ;
  String S = '' ;

  if ([1,4,5].contains(chosenInt1to7)){
    R1 = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    R1 = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (baseNoteWhere == 0){
    // addNumber = '';
  } else if (baseNoteWhere == 1){
    N1 = '6';
  } else {
    N1 = '4';
    N2 = '6';
    // addNumber = '6/4';
    // '∅ ⊙'
  }


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


  List<Note> note3ShuffleTemp = [note3Shuffle[1], note3Shuffle[2],addNote] ;
  note3ShuffleTemp.shuffle();

  List<Note> note4Shuffle =
      [note3Shuffle[0]] + note3ShuffleTemp;


  if ([7].contains(chosenInt1to7)){
    D1 = '⊙';
  }

  return ([R1,D1,N1,N2,S,R2,D2,N3,N4],note4Shuffle,chosenTonality,note3Origianl,'basicProblem');
}

// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String) secondaryDominant7thProblem(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '' ;
  String D2 = '' ;
  String S = '' ;

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('yes');
  int chosenInt1to7 = getOneToSeven();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonality(baseBeforeAccident,chosenTonality) ;

  // 완전 5도 이동 최종 근음
  Note baseFinalUp5 = baseFinal.transposeBy(Interval.P5);

  // 근음 + M3, m3, m3
  Note baseFinalUp5Up1 = baseFinalUp5.transposeBy(Interval.M3);
  Note baseFinalUp5Up2 = baseFinalUp5Up1.transposeBy(Interval.m3);
  Note baseFinalUp5Up3 = baseFinalUp5Up2.transposeBy(Interval.m3);


  List<Note> note4Origianl = [baseFinalUp5, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  List<Note> note4Shuffle = [baseFinalUp5, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  // 최종 문제
  note4Shuffle.shuffle() ;



  // 정답 산출
  Note baseChosen = note4Shuffle[0];

  int baseNoteWhere = note4Origianl.indexOf(baseChosen) ;

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자

  R1 = 'V';
  S = '/';

  if ([1,4,5].contains(chosenInt1to7)){
    R2 = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    R2 = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (baseNoteWhere == 0){
    N1 = '7';
    // addNumber = '7';
  } else if (baseNoteWhere == 1){
    N1 = '5';
    N2 = '6';
  } else if (baseNoteWhere == 2){
    N1 = '3';
    N2 = '4';
    // addNumber = '4/3';
  } else {
    N1 = '2';
    N2 = '4';
    // addNumber = '4/2';
  }


  // 'V' + addNumber+'/'+answerRome
  if (chosenInt1to7==1){
    // answerFinal = 'V${addNumber}';
    S = '';
    R2 = '';
  } else {
    // answerFinal = 'V${addNumber + ' / ' + answerRome}';
  }

  return (
      [R1,D1,N1,N2,S,R2,D2,N3,N4]
  ,note4Shuffle,chosenTonality
  ,note4Origianl,'secondaryDominant7thProblem');
}


// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String) dominant7thProblem(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '' ;
  String D2 = '' ;
  String S = '' ;

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('yes');
  int chosenInt1to7 = 1;

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonality(baseBeforeAccident,chosenTonality) ;

  // 완전 5도 이동 최종 근음
  Note baseFinalUp5 = baseFinal.transposeBy(Interval.P5);

  // 근음 + M3, m3, m3
  Note baseFinalUp5Up1 = baseFinalUp5.transposeBy(Interval.M3);
  Note baseFinalUp5Up2 = baseFinalUp5Up1.transposeBy(Interval.m3);
  Note baseFinalUp5Up3 = baseFinalUp5Up2.transposeBy(Interval.m3);


  List<Note> note4Origianl = [baseFinalUp5, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  List<Note> note4Shuffle = [baseFinalUp5, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  // 최종 문제
  note4Shuffle.shuffle() ;



  // 정답 산출
  Note baseChosen = note4Shuffle[0];

  int baseNoteWhere = note4Origianl.indexOf(baseChosen) ;

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자

  if ([1,4,5].contains(chosenInt1to7)){
// 대문자
  } else {
// 소문자
  }

  if (baseNoteWhere == 0){
    N1 = '7';
  } else if (baseNoteWhere == 1){
    N1 = '5';
    N2 = '6';
    // addNumber = '6/5';
  } else if (baseNoteWhere == 2){
    N1 = '3';
    N2 = '4';
    // addNumber = '4/3';
  } else {
    N1 = '2';
    N2 = '4';
    // addNumber = '4/2';
  }

  // 'V'+addNumber

  R1 = 'V';

  return ( [R1,D1,N1,N2,S,R2,D2,N3,N4],note4Shuffle,chosenTonality,note4Origianl,'dominant7thProblem');
}


// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String) secondary7thProblem(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '' ;
  String D2 = '' ;
  String S = '' ;

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('yes');

  final _random = new Random();

  List<int> oneToSevenNot5Not7 = [1,2,3,4,6];

  int chosen = oneToSevenNot5Not7[_random.nextInt(oneToSevenNot5Not7.length)];

  int chosenInt1to7 = chosen;

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonality(baseBeforeAccident,chosenTonality) ;

  // 완전 5도 이동 최종 근음
  // Note baseFinalUp5 = baseFinal.transposeBy(Interval.P5);

  Note baseFinalUp1 ;
  Note baseFinalUp2 ;
  Note baseFinalUp5Up3 ;

  if ([1,4].contains(chosenInt1to7)){
    baseFinalUp1 = baseFinal.transposeBy(Interval.M3);
    baseFinalUp2 = baseFinalUp1.transposeBy(Interval.m3);
    baseFinalUp5Up3 = baseFinalUp2.transposeBy(Interval.M3);
  } else {
    baseFinalUp1 = baseFinal.transposeBy(Interval.m3);
    baseFinalUp2 = baseFinalUp1.transposeBy(Interval.M3);
    baseFinalUp5Up3 = baseFinalUp2.transposeBy(Interval.m3);
  }

  // 근음 + M3, m3, M3
  // Note baseFinalUp5Up1 = baseFinal.transposeBy(Interval.M3);
  // Note baseFinalUp5Up2 = baseFinalUp5Up1.transposeBy(Interval.m3);

  // M m m M m
  // 1,2,3,4,6

  List<Note> note4Origianl = [baseFinal, baseFinalUp1, baseFinalUp2,
    baseFinalUp5Up3];

  List<Note> note4Shuffle = [baseFinal, baseFinalUp1, baseFinalUp2,
    baseFinalUp5Up3];

  // 최종 문제
  note4Shuffle.shuffle() ;

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자

  if ([1,4].contains(chosenInt1to7)){
    R1 = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    R1 = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  N1 = '7';

  return (
  [R1,D1,N1,N2,S,R2,D2,N3,N4]
  ,note4Shuffle
  ,chosenTonality
  ,note4Origianl
  ,'secondary7thProblem'
  );
}


// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String) neapolitanProblem(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '' ;
  String D2 = '' ;
  String S = '' ;

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('no');
  int chosenInt1to7 = 2; // 나폴리는 2로 고정

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonality(baseBeforeAccident,chosenTonality) ;

  // 완전 5도 이동 최종 근음
  Note baseFinaldownm2temp = baseFinal.transposeBy(-Interval.m2);
  Note baseFinaldownm2 = baseFinaldownm2temp.respellByBaseNote(baseFinal.baseNote);

  Note baseFinaldownm2Up1 ;
  Note baseFinaldownm2Up2 ;

  baseFinaldownm2Up1 = baseFinaldownm2.transposeBy(Interval.M3);
  baseFinaldownm2Up2 = baseFinaldownm2Up1.transposeBy(Interval.m3);

  // 근음 + M3, m3, m3

  List<Note> note3Origianl =
  [baseFinaldownm2, baseFinaldownm2Up1, baseFinaldownm2Up2];


  // chose base 근, 3, 5  // 확율 15, 70, 15
  int intValue = Random().nextInt(100); // Value is >= 0 and < 100.
  Note baseNote ;
  int baseNoteWhere ;

  if (intValue < 15) {
    baseNote = note3Origianl[0];
    baseNoteWhere = 0;
  } else if (intValue < 70) {
    baseNote = note3Origianl[1];
    baseNoteWhere = 1;
  } else {
    baseNote = note3Origianl[2];
    baseNoteWhere = 2;
  }

  note3Origianl.remove(baseNote);
  note3Origianl.add(baseFinaldownm2Up1);
  note3Origianl.shuffle();


  List<Note> note4Shuffle =
  [baseNote] + note3Origianl;


  // 정답 산출

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자

  if ([1,4,5].contains(chosenInt1to7)){
    R1 = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    R1 = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (baseNoteWhere == 0){
    // addNumber = '';
  } else if (baseNoteWhere == 1){
    N1 = '6';
  } else {
    N1 = '4';
    N2 = '6';
    // addNumber = '6/4';
  }

  R1 = 'N';

  // answerRome+addNumber

  return ([R1,D1,N1,N2,S,R2,D2,N3,N4],note4Shuffle,chosenTonality,note3Origianl,'neapolitanProblem');
}




// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String)
secondaryDiminished7thProblem(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '⊙' ;
  String D2 = '' ;
  String S = '' ;

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = getOneToSeven();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonality(baseBeforeAccident,chosenTonality) ;

  // 완전 5도 이동 최종 근음
  Note baseFinalDownm2 = baseFinal.transposeBy(-Interval.m2);

  Note baseFinalDownm2Final ;

  // flat 이 나오지 않도록 보정
  if (baseFinalDownm2.accidental == Accidental.flat){
    baseFinalDownm2Final = baseFinalDownm2.respelledDownwards;
  } else {
    baseFinalDownm2Final = baseFinalDownm2;
  }

  // 근음 + m3, m3, m3
  Note baseFinalUp5Up1 = baseFinalDownm2Final.transposeBy(Interval.m3);
  Note baseFinalUp5Up2 = baseFinalUp5Up1.transposeBy(Interval.m3);
  Note baseFinalUp5Up3 = baseFinalUp5Up2.transposeBy(Interval.m3);



  List<Note> note4Origianl = [baseFinalDownm2Final, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  List<Note> note4Shuffle = [baseFinalDownm2Final, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  // 최종 문제
  note4Shuffle.shuffle() ;



  // 정답 산출
  Note baseChosen = note4Shuffle[0];

  int baseNoteWhere = note4Origianl.indexOf(baseChosen) ;

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자

  if ([1,4,5].contains(chosenInt1to7)){
    R2 = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    R2 = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (baseNoteWhere == 0){
    // addNumber = '7';
    N1 = '7';
  } else if (baseNoteWhere == 1){
    N1 = '5';
    N2 = '6';
    // addNumber = '6/5';
  } else if (baseNoteWhere == 2){
    N1 = '4';
    N2 = '3';
    // addNumber = '3/4';
  } else {
    N1 = '2';
    N2 = '4';
    // addNumber = '4/2';
  }

  // 'Vii "  ${addNumber + '/' + answerRome}'

  // 'V' + addNumber+'/'+answerRome

  R1 = 'vii';
  S = '/';

  if (chosenInt1to7==1){
    // answerFinal = 'V${addNumber}';
    S = '';
    R2 = '';
  } else {
    // answerFinal = 'V${addNumber + ' / ' + answerRome}';
  }

  return ([R1,D1,N1,N2,S,R2,D2,N3,N4]
  ,note4Shuffle,
  chosenTonality,note4Origianl,'secondaryDiminished7thProblem');
}


// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String) diminished7thProblem(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '⊙' ;
  String D2 = '' ;
  String S = '' ;

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = 1;

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonality(baseBeforeAccident,chosenTonality) ;

  // 완전 5도 이동 최종 근음
  Note baseFinalDownm2 = baseFinal.transposeBy(-Interval.m2);

  Note baseFinalDownm2Final ;

  // flat 이 나오지 않도록 보정
  if (baseFinalDownm2.accidental == Accidental.flat){
    baseFinalDownm2Final = baseFinalDownm2.respelledDownwards;
  } else {
    baseFinalDownm2Final = baseFinalDownm2;
  }

  // 근음 + m3, m3, m3
  Note baseFinalUp5Up1 = baseFinalDownm2Final.transposeBy(Interval.m3);
  Note baseFinalUp5Up2 = baseFinalUp5Up1.transposeBy(Interval.m3);
  Note baseFinalUp5Up3 = baseFinalUp5Up2.transposeBy(Interval.m3);



  List<Note> note4Origianl = [baseFinalDownm2Final, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  List<Note> note4Shuffle = [baseFinalDownm2Final, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  // 최종 문제
  note4Shuffle.shuffle() ;



  // 정답 산출
  Note baseChosen = note4Shuffle[0];

  int baseNoteWhere = note4Origianl.indexOf(baseChosen) ;

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자

  if ([1,4,5].contains(chosenInt1to7)){
// 대문자
  } else {
// 소문자
  }

  if (baseNoteWhere == 0){
    N1 = '7';
  } else if (baseNoteWhere == 1){
    N1 = '5';
    N2 = '6';
  } else if (baseNoteWhere == 2){
    N1 = '4';
    N2 = '3';
    // addNumber = '3/4';
  } else {
    N1 = '2';
    N2 = '4';
    // addNumber = '4/2';
  }

  R1 = 'vii';

  return ([R1,D1,N1,N2,S,R2,D2,N3,N4],note4Shuffle,chosenTonality
  ,note4Origianl,'diminished7thProblem');
}



// m3 m3 M3
// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String)
secondaryHalfDiminished7thProblem(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '∅' ;
  String D2 = '' ;
  String S = '' ;

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = getOneToSeven();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonality(baseBeforeAccident,chosenTonality) ;

  // 완전 5도 이동 최종 근음
  Note baseFinalDownm2 = baseFinal.transposeBy(-Interval.m2);

  Note baseFinalDownm2Final ;

  // flat 이 나오지 않도록 보정
  if (baseFinalDownm2.accidental == Accidental.flat){
    baseFinalDownm2Final = baseFinalDownm2.respelledDownwards;
  } else {
    baseFinalDownm2Final = baseFinalDownm2;
  }

  // 근음 + m3 m3 M3
  Note baseFinalUp5Up1 = baseFinalDownm2Final.transposeBy(Interval.m3);
  Note baseFinalUp5Up2 = baseFinalUp5Up1.transposeBy(Interval.m3);
  Note baseFinalUp5Up3 = baseFinalUp5Up2.transposeBy(Interval.M3);



  List<Note> note4Origianl = [baseFinalDownm2Final, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  List<Note> note4Shuffle = [baseFinalDownm2Final, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  // 최종 문제
  note4Shuffle.shuffle() ;



  // 정답 산출
  Note baseChosen = note4Shuffle[0];

  int baseNoteWhere = note4Origianl.indexOf(baseChosen) ;

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자

  if ([1,4,5].contains(chosenInt1to7)){
    R2 = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    R2 = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (baseNoteWhere == 0){
    N1 = '7';
  } else if (baseNoteWhere == 1){
    N1 = '5';
    N2 = '6';
  } else if (baseNoteWhere == 2){
    N1 = '4';
    N2 = '3';
    // addNumber = '3/4';
  } else {
    N1 = '2';
    N2 = '4';
    // addNumber = '4/2';
  }

  R1 = 'vii';
  D1 = '∅';
  S = '/';
  // 'V' + addNumber+'/'+answerRome
  if (chosenInt1to7==1){
    // answerFinal = 'V${addNumber}';
    S = '';
    R2 = '';
  } else {
    // answerFinal = 'V${addNumber + ' / ' + answerRome}';
  }
// 'Vii "반 ${addNumber + '/' + answerRome}'
  return ([R1,D1,N1,N2,S,R2,D2,N3,N4],note4Shuffle,chosenTonality
  ,note4Origianl,'secondaryHalfDiminished7thProblem');
}


// m3 m3 M3
// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String) halfDiminished7thProblem(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '' ;
  String D2 = '' ;
  String S = '' ;

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = 1;

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonality(baseBeforeAccident,chosenTonality) ;

  // 완전 5도 이동 최종 근음
  Note baseFinalDownm2 = baseFinal.transposeBy(-Interval.m2);

  Note baseFinalDownm2Final ;

  // flat 이 나오지 않도록 보정
  if (baseFinalDownm2.accidental == Accidental.flat){
    baseFinalDownm2Final = baseFinalDownm2.respelledDownwards;
  } else {
    baseFinalDownm2Final = baseFinalDownm2;
  }

  // 근음 + m3 m3 M3
  Note baseFinalUp5Up1 = baseFinalDownm2Final.transposeBy(Interval.m3);
  Note baseFinalUp5Up2 = baseFinalUp5Up1.transposeBy(Interval.m3);
  Note baseFinalUp5Up3 = baseFinalUp5Up2.transposeBy(Interval.M3);



  List<Note> note4Origianl = [baseFinalDownm2Final, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  List<Note> note4Shuffle = [baseFinalDownm2Final, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  // 최종 문제
  note4Shuffle.shuffle() ;



  // 정답 산출
  Note baseChosen = note4Shuffle[0];

  int baseNoteWhere = note4Origianl.indexOf(baseChosen) ;

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자

  if ([1,4,5].contains(chosenInt1to7)){
// 대문자
  } else {
// 소문자
  }

  if (baseNoteWhere == 0){
    N1 = '7';
  } else if (baseNoteWhere == 1){
    N1 = '5';
    N2 = '6';
  } else if (baseNoteWhere == 2){
    N1 = '4';
    N2 = '3';
    // addNumber = '3/4';
  } else {
    N1 = '2';
    N2 = '4';
    // addNumber = '4/2';
  }

  // 'Vii "반 ${addNumber}'
  R1 = 'vii';
  D1 = '∅';

  return ([R1,D1,N1,N2,S,R2,D2,N3,N4],note4Shuffle,chosenTonality
  ,note4Origianl,'halfDiminished7thProblem');
}

// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String) augmentedSixthIt(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '' ;
  String D2 = '' ;
  String S = '' ;

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('no');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = 4;

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonality(baseBeforeAccident,chosenTonality) ;


  // 근음 + M3, m3, m3
  Note baseFinalUp5Up1 = baseFinal.transposeBy(Interval.M3);
  Note baseFinalUp5Up2 = baseFinalUp5Up1.transposeBy(Interval.m3);



  List<Note> note3Origianl =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2];

  // chose base
  // chose base 근, 3, 5  // 확율 15, 70, 15
  int intValue = Random().nextInt(2); // Value is >= 0 and < 2.
  Note baseNote ;
  List<Note> note3Shuffle ;

  if (intValue == 0) {
    baseNote = baseFinalUp5Up1.flat; // 3음 -> It6
    note3Shuffle = [baseFinal.sharp,baseFinalUp5Up2,baseFinalUp5Up2];
  } else {
    baseNote = baseFinalUp5Up2; // 5음 -> It6/4
    note3Shuffle = [baseFinal.sharp,baseFinalUp5Up1.flat,baseFinalUp5Up2];
  }

  // 최종 문제
  note3Shuffle.shuffle() ;


  List<Note> finalProblem = [baseNote] + note3Shuffle;



  // 정답 산출
  if (baseNote == baseFinalUp5Up1.flat){
    N1 = '6';
    // addNumber = '6';
  } else {
    N1 = '4';
    N2 = '6';
  }

  // 'It  ${addNumber}'

  R1 = 'It';

  return ([R1,D1,N1,N2,S,R2,D2,N3,N4],finalProblem,chosenTonality,note3Origianl,'augmentedSixthIt');
}


// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String) augmentedSixthFr(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '' ;
  String D2 = '' ;
  String S = '' ;

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('no');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = 4;

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonality(baseBeforeAccident,chosenTonality) ;


  // 근음 + M3, m3, m3
  Note baseFinalUp5Up1 = baseFinal.transposeBy(Interval.M3);
  Note baseFinalUp5Up2 = baseFinalUp5Up1.transposeBy(Interval.m3);
  Note baseFinalUp5Up3 = baseFinalUp5Up2.transposeBy(Interval.M2);



  List<Note> note4Origianl =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];

  List<Note> note3Shuffle =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];
  // chose base
  // chose base 근, 3, 5  // 확율 15, 70, 15
  int intValue = Random().nextInt(4); // Value is >= 0 and < 4.
  Note baseNote ;
  List<Note> finalProblem ;

  if (intValue == 0) {
    baseNote = baseFinal.sharp; // 1음 Fr 6/5
    // answer = 'Fr 6/5';
    N1 = '5';
    N2 = '6';
  } else if (intValue == 1) {
    baseNote = baseFinalUp5Up1.flat; // 1음 Fr 6/5
    // answer = 'Fr 6';
    N1 = '6';
    // N2 = '6';
  } else if (intValue == 2) {
    baseNote = baseFinalUp5Up2; // 1음 Fr 6/5
    N1 = '2';
    N2 = '4';
    // answer = 'Fr 4/2';
  } else {
    baseNote = baseFinalUp5Up3; // 1음 Fr 6/5
    N1 = '5';
    N2 = '7';
    // answer = 'Fr 7/5';
  }

  note3Shuffle.remove(baseNote);
  note3Shuffle.shuffle();
  finalProblem = [baseNote] + note3Shuffle;

  // 최종 문제
  note3Shuffle.shuffle() ;

  R1 = 'Fr';

  // answer

  return ([R1,D1,N1,N2,S,R2,D2,N3,N4],finalProblem,chosenTonality,note4Origianl,'augmentedSixthFr');
}


// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String) augmentedSixthGr(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '' ;
  String D2 = '' ;
  String S = '' ;

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('no');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = 4;

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonality(baseBeforeAccident,chosenTonality) ;


  // 근음 + M3, m3, m3
  Note baseFinalUp5Up1 = baseFinal.transposeBy(Interval.M3);
  Note baseFinalUp5Up2 = baseFinalUp5Up1.transposeBy(Interval.m3);
  Note baseFinalUp5Up3 = baseFinalUp5Up2.transposeBy(Interval.m3);



  List<Note> note4Origianl =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];

  List<Note> note3Shuffle =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];
  // chose base
  // chose base 근, 3, 5  // 확율 15, 70, 15
  int intValue = Random().nextInt(4); // Value is >= 0 and < 4.
  Note baseNote ;
  List<Note> finalProblem ;

  if (intValue == 0) {
    baseNote = baseFinal.sharp; // 1음 Fr 6/5
    // answer = 'Ger 7/5';
    N1 = '5';
    N2 = '7';
  } else if (intValue == 1) {
    baseNote = baseFinalUp5Up1.flat;
    // answer = 'Ger 6';
    N1 = '6';
    // N2 = '7';
  } else if (intValue == 2) {
    baseNote = baseFinalUp5Up2;
    // answer = 'Ger 4/3';
    N1 = '3';
    N2 = '4';
  } else {
    baseNote = baseFinalUp5Up3;
    // answer = 'Ger 4/2';
    N1 = '2';
    N2 = '4';
  }

  note3Shuffle.remove(baseNote);
  note3Shuffle.shuffle();
  finalProblem = [baseNote] + note3Shuffle;

  // 최종 문제
  note3Shuffle.shuffle() ;

  R1 = 'Ger';

  // answer

  return ([R1,D1,N1,N2,S,R2,D2,N3,N4],finalProblem,chosenTonality,note4Origianl,'augmentedSixthGr');
}



// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String) augmentedHalfSixthIt(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '' ;
  String D2 = '' ;
  String S = '' ;


  // 문제 결정 조를 결정함
  Tonality chosenTonality = getConditionalTonality('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  // 부증6화음은 7개음 모두 가능
  int chosenInt1to7 = getOneToSeven();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  // 조에 따른 조표 붙이기
  Note baseBefore1Down = addSharpByTonality(baseBeforeAccident,chosenTonality) ;

  // 근음을 1온음 아래로 이동
  Note baseFinal = baseBefore1Down.transposeBy(-Interval.M2);

  // 근음 + M3, m3, m3
  Note baseFinalUp5Up1 = baseFinal.transposeBy(Interval.M3);
  Note baseFinalUp5Up2 = baseFinalUp5Up1.transposeBy(Interval.m3);



  List<Note> note3Origianl =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2];

  // chose base
  int intValue = Random().nextInt(2); // Value is >= 0 and < 2.
  Note baseNote ;

  List<Note> note3Shuffle ;

  if (intValue == 0) {
    baseNote = baseFinalUp5Up1.flat; // 3음 -> It6
    note3Shuffle = [baseFinal.sharp,baseFinalUp5Up2,baseFinalUp5Up2];
  } else {
    baseNote = baseFinalUp5Up2; // 5음 -> It6/4
    note3Shuffle = [baseFinal.sharp,baseFinalUp5Up1.flat,baseFinalUp5Up2];
  }

  // 최종 문제
  note3Shuffle.shuffle() ;


  List<Note> finalProblem = [baseNote] + note3Shuffle;



  // 정답 산출
  // String addNumber;
  // String answerRome ;

  if ([1,4,5].contains(chosenInt1to7)){
    R2 = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    R2 = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (baseNote == baseFinalUp5Up1.flat){
    // addNumber = '6';
    N1 = '6';
  } else {
    // addNumber = '6/4';
    N1 = '4';
    N2 = '6';
  }

  // 'It  ${addNumber} / ${answerRome}'
  R1 = 'It';
  S = '/';

  if (chosenInt1to7 == 5){
    S = '';
    R2 = '';
  }

  return ([R1,D1,N1,N2,S,R2,D2,N3,N4],finalProblem,chosenTonality
  ,note3Origianl,'augmentedHalfSixthIt');
}


// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String) augmentedHalfSixthFr(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '' ;
  String D2 = '' ;
  String S = '' ;

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  // 부증6화음은 7개 음 모두 가능
  int chosenInt1to7 = getOneToSeven();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  // 조에 따른 조표 붙이기
  Note baseBefore1Down = addSharpByTonality(baseBeforeAccident,chosenTonality) ;

  // 근음을 1온음 아래로 이동
  Note baseFinal = baseBefore1Down.transposeBy(-Interval.M2);

  // 근음 + M3, m3, m3
  Note baseFinalUp5Up1 = baseFinal.transposeBy(Interval.M3);
  Note baseFinalUp5Up2 = baseFinalUp5Up1.transposeBy(Interval.m3);
  Note baseFinalUp5Up3 = baseFinalUp5Up2.transposeBy(Interval.M2);



  List<Note> note4Origianl =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];

  List<Note> note3Shuffle =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];
  // chose base
  // chose base 근, 3, 5  // 확율 15, 70, 15
  int intValue = Random().nextInt(4); // Value is >= 0 and < 4.
  Note baseNote ;
  List<Note> finalProblem ;

  // String answerRome ;

  if ([1,4,5].contains(chosenInt1to7)){
    R2 = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    R2 = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (intValue == 0) {
    baseNote = baseFinal.sharp; // 1음 Fr 6/5
    // answer = 'Fr 6/5 / ${answerRome}';
    N1 = '5';
    N2 = '6';
  } else if (intValue == 1) {
    baseNote = baseFinalUp5Up1.flat; // 1음 Fr 6/5
    // answer = 'Fr 6 / ${answerRome}';
    N1 = '6';
    // N2 = '6';
  } else if (intValue == 2) {
    baseNote = baseFinalUp5Up2; // 1음 Fr 6/5
    // answer = 'Fr 4/2 / ${answerRome}';
    N1 = '2';
    N2 = '4';
  } else {
    baseNote = baseFinalUp5Up3; // 1음 Fr 6/5
    // answer = 'Fr 7/5 / ${answerRome}';
    N1 = '5';
    N2 = '7';
  }

  note3Shuffle.remove(baseNote);
  note3Shuffle.shuffle();
  finalProblem = [baseNote] + note3Shuffle;

  // 최종 문제
  note3Shuffle.shuffle() ;

  // answer

  R1 = 'Fr';
  S = '/';

  if (chosenInt1to7 == 5){
    S = '';
    R2 = '';
  }

  return ([R1,D1,N1,N2,S,R2,D2,N3,N4],finalProblem,chosenTonality
  ,note4Origianl,'augmentedHalfSixthFr');
}


// 정답 / 문제 return
(List<String>,List<Note>,Tonality,List<Note>,String) augmentedHalfSixthGr(){

  String R1 = '' ;
  String R2 = '' ;
  String N1 = '' ;
  String N2 = '' ;

  String N3 = '' ;
  String N4 = '' ;
  String D1 = '' ;
  String D2 = '' ;
  String S = '' ;

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = getOneToSeven();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  // 조에 따른 조표 붙이기
  Note baseBefore1Down = addSharpByTonality(baseBeforeAccident,chosenTonality) ;

  // 근음을 1온음 아래로 이동
  Note baseFinal = baseBefore1Down.transposeBy(-Interval.M2);

  // 근음 + M3, m3, m3
  Note baseFinalUp5Up1 = baseFinal.transposeBy(Interval.M3);
  Note baseFinalUp5Up2 = baseFinalUp5Up1.transposeBy(Interval.m3);
  Note baseFinalUp5Up3 = baseFinalUp5Up2.transposeBy(Interval.m3);



  List<Note> note4Origianl =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];

  List<Note> note3Shuffle =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];
  // chose base
  // chose base 근, 3, 5  // 확율 15, 70, 15
  int intValue = Random().nextInt(4); // Value is >= 0 and < 4.
  Note baseNote ;
  List<Note> finalProblem ;


  if ([1,4,5].contains(chosenInt1to7)){
    R2 = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    R2 = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (intValue == 0) {
    baseNote = baseFinal.sharp; // 1음 Fr 6/5
    N1 = '5';
    N2 = '7';
    // answer = 'Ger 7/5 / ${answerRome}';
  } else if (intValue == 1) {
    baseNote = baseFinalUp5Up1.flat;
    N1 = '6';
    // N2 = '7';
    // answer = 'Ger 6 / ${answerRome}';
  } else if (intValue == 2) {
    baseNote = baseFinalUp5Up2;
    N1 = '3';
    N2 = '4';
    // answer = 'Ger 4/3 / ${answerRome}';
  } else {
    baseNote = baseFinalUp5Up3;
    // answer = 'Ger 4/2 / ${answerRome}';
    N1 = '2';
    N2 = '4';
  }

  note3Shuffle.remove(baseNote);
  note3Shuffle.shuffle();
  finalProblem = [baseNote] + note3Shuffle;

  // 최종 문제
  note3Shuffle.shuffle() ;



  // print('answer It  ${answer}');
  // answer
  R1 = 'Ger';
  S = '/';

  if (chosenInt1to7 == 5){
    S = '';
    R2 = '';
  }

  return ([R1,D1,N1,N2,S,R2,D2,N3,N4],finalProblem,chosenTonality
  ,note4Origianl,'augmentedHalfSixthGr');
}
