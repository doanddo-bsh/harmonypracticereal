import "dart:math";
import 'package:music_notes/music_notes.dart';
import 'package:numerus/numerus.dart';
import "package:music_notes/music_notes.dart";



Tonality getConditionalTonality(String diminished7){

  final _random = new Random();

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
(String,List<Note>) secondaryDominant7thProblem(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('no');
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

  print('==========================================');
  print('chosenTonality ${chosenTonality}');
  print('chosenInt1to7 ${chosenInt1to7}');

  print('baseFinal ${baseFinal}');
  print('baseFinalUp5 ${baseFinalUp5}');

  List<Note> note4Origianl = [baseFinalUp5, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  List<Note> note4Shuffle = [baseFinalUp5, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  // 최종 문제
  note4Shuffle.shuffle() ;

  print('note 4 original ${note4Origianl}');

  print('note 4 shuffle ${note4Shuffle}');

  // 정답 산출
  Note baseChosen = note4Shuffle[0];

  int baseNoteWhere = note4Origianl.indexOf(baseChosen) ;

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자
  String answerRome ;
  String addNumber ;

  if ([1,4,5].contains(chosenInt1to7)){
    answerRome = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    answerRome = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (baseNoteWhere == 0){
    addNumber = '7';
  } else if (baseNoteWhere == 1){
    addNumber = '6/5';
  } else if (baseNoteWhere == 2){
    addNumber = '4/3';
  } else {
    addNumber = '4/2';
  }

  print('answer ${answerRome+' ' + addNumber}');

  return (answerRome+addNumber,note4Shuffle);
}


// 정답 / 문제 return
(String,List<Note>) basicProblem(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonality('no');
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

  if ([1,4,5].contains(chosenInt1to7)){
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

  return (answerRome+addNumber,note4Shuffle);
}

// 정답 / 문제 return
(String,List<Note>) neapolitanProblem(){

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

  print('==========================================');
  print('chosenTonality ${chosenTonality}');
  print('chosenInt1to7 ${2}');

  print('baseFinal ${baseFinal}');
  print('baseFinaldownm2 ${baseFinaldownm2}');
  // print('baseFinaldownm2temp ${baseFinaldownm2temp}');

  List<Note> note3Origianl =
  [baseFinaldownm2, baseFinaldownm2Up1, baseFinaldownm2Up2];

  print('note 3 original ${note3Origianl}');

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

  print('note 4 shuffle problem ${note4Shuffle}');

  // 정답 산출
  Note baseChosen = note4Shuffle[0];

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자
  String answerRome ;
  String addNumber ;

  if ([1,4,5].contains(chosenInt1to7)){
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

  print('answer ${'N ' + addNumber}');

  return (answerRome+addNumber,note4Shuffle);
}




// 정답 / 문제 return
(String,List<Note>) secondaryDiminished7thProblem(){

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

  print('==========================================');
  print('chosenTonality ${chosenTonality}');
  print('chosenInt1to7 ${chosenInt1to7}');

  print('baseFinal ${baseFinal}');
  print('baseFinalDownM2 ${baseFinalDownm2}');
  print('baseFinalDownm2Final ${baseFinalDownm2Final}');

  List<Note> note4Origianl = [baseFinalDownm2Final, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  List<Note> note4Shuffle = [baseFinalDownm2Final, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  // 최종 문제
  note4Shuffle.shuffle() ;

  print('note 4 original ${note4Origianl}');

  print('note 4 shuffle ${note4Shuffle}');

  // 정답 산출
  Note baseChosen = note4Shuffle[0];

  int baseNoteWhere = note4Origianl.indexOf(baseChosen) ;

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자
  String answerRome ;
  String addNumber ;

  if ([1,4,5].contains(chosenInt1to7)){
    answerRome = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    answerRome = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (baseNoteWhere == 0){
    addNumber = '7';
  } else if (baseNoteWhere == 1){
    addNumber = '6/5';
  } else if (baseNoteWhere == 2){
    addNumber = '3/4';
  } else {
    addNumber = '4/2';
  }

  print('answer Vii "  ${addNumber + '/' + answerRome}');

  return ('Vii "  ${addNumber + '/' + answerRome}',note4Shuffle);
}


// m3 m3 M3
// 정답 / 문제 return
(String,List<Note>) secondaryHalfDiminished7thProblem(){

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

  print('==========================================');
  print('chosenTonality ${chosenTonality}');
  print('chosenInt1to7 ${chosenInt1to7}');

  print('baseFinal ${baseFinal}');
  print('baseFinalDownM2 ${baseFinalDownm2}');
  print('baseFinalDownm2Final ${baseFinalDownm2Final}');

  List<Note> note4Origianl = [baseFinalDownm2Final, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  List<Note> note4Shuffle = [baseFinalDownm2Final, baseFinalUp5Up1, baseFinalUp5Up2,
    baseFinalUp5Up3];

  // 최종 문제
  note4Shuffle.shuffle() ;

  print('note 4 original ${note4Origianl}');

  print('note 4 shuffle ${note4Shuffle}');

  // 정답 산출
  Note baseChosen = note4Shuffle[0];

  int baseNoteWhere = note4Origianl.indexOf(baseChosen) ;

  // 대소문자 구분 1,4,5 대문자 / 2,3,6,7 소문자
  String answerRome ;
  String addNumber ;

  if ([1,4,5].contains(chosenInt1to7)){
    answerRome = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    answerRome = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (baseNoteWhere == 0){
    addNumber = '7';
  } else if (baseNoteWhere == 1){
    addNumber = '6/5';
  } else if (baseNoteWhere == 2){
    addNumber = '3/4';
  } else {
    addNumber = '4/2';
  }

  print('answer Vii "반  ${addNumber + '/' + answerRome}');

  return ('Vii "반 ${addNumber + '/' + answerRome}',note4Shuffle);
}

// 정답 / 문제 return
(String,List<Note>) augmentedSixthIt(){

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

  print('==========================================');
  print('chosenTonality ${chosenTonality}');
  print('chosenInt1to7 ${chosenInt1to7}');

  print('baseFinal ${baseFinal.sharp}');

  List<Note> note3Origianl =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2];

  // chose base
  // chose base 근, 3, 5  // 확율 15, 70, 15
  int intValue = Random().nextInt(2); // Value is >= 0 and < 2.
  Note baseNote ;
  int baseNoteWhere ;
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

  print('note 3 original ${note3Origianl}');
  print('base note ${baseNote}') ;

  List<Note> finalProblem = [baseNote] + note3Shuffle;

  print('finalProblem ${finalProblem}');

  String addNumber;

  // 정답 산출
  if (baseNote == baseFinalUp5Up1.flat){
    addNumber = '6';
  } else {
    addNumber = '6/4';
  }

  print('answer It  ${addNumber}');

  return ('It  ${addNumber}',finalProblem);
}


// 정답 / 문제 return
(String,List<Note>) augmentedSixthFr(){

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

  print('==========================================');
  print('chosenTonality ${chosenTonality}');
  print('chosenInt1to7 ${chosenInt1to7}');

  print('baseFinal ${baseFinal.sharp}');

  List<Note> note4Origianl =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];

  List<Note> note3Shuffle =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];
  // chose base
  // chose base 근, 3, 5  // 확율 15, 70, 15
  int intValue = Random().nextInt(4); // Value is >= 0 and < 4.
  Note baseNote ;
  List<Note> finalProblem ;
  String answer;

  if (intValue == 0) {
    baseNote = baseFinal.sharp; // 1음 Fr 6/5
    answer = 'Fr 6/5';
  } else if (intValue == 1) {
    baseNote = baseFinalUp5Up1.flat; // 1음 Fr 6/5
    answer = 'Fr 6';
  } else if (intValue == 2) {
    baseNote = baseFinalUp5Up2; // 1음 Fr 6/5
    answer = 'Fr 4/2';
  } else {
    baseNote = baseFinalUp5Up3; // 1음 Fr 6/5
    answer = 'Fr 7/5';
  }

  note3Shuffle.remove(baseNote);
  note3Shuffle.shuffle();
  finalProblem = [baseNote] + note3Shuffle;

  // 최종 문제
  note3Shuffle.shuffle() ;

  print('note 4 original ${note4Origianl}');
  print('base note ${baseNote}') ;

  print('finalProblem ${finalProblem}');

  print('answer It  ${answer}');

  return (answer,finalProblem);
}


// 정답 / 문제 return
(String,List<Note>) augmentedSixthGr(){

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

  print('==========================================');
  print('chosenTonality ${chosenTonality}');
  print('chosenInt1to7 ${chosenInt1to7}');

  print('baseFinal ${baseFinal.sharp}');

  List<Note> note4Origianl =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];

  List<Note> note3Shuffle =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];
  // chose base
  // chose base 근, 3, 5  // 확율 15, 70, 15
  int intValue = Random().nextInt(4); // Value is >= 0 and < 4.
  Note baseNote ;
  List<Note> finalProblem ;
  String answer;

  if (intValue == 0) {
    baseNote = baseFinal.sharp; // 1음 Fr 6/5
    answer = 'Ger 7/5';
  } else if (intValue == 1) {
    baseNote = baseFinalUp5Up1.flat;
    answer = 'Ger 6';
  } else if (intValue == 2) {
    baseNote = baseFinalUp5Up2;
    answer = 'Ger 4/3';
  } else {
    baseNote = baseFinalUp5Up3;
    answer = 'Ger 4/2';
  }

  note3Shuffle.remove(baseNote);
  note3Shuffle.shuffle();
  finalProblem = [baseNote] + note3Shuffle;

  // 최종 문제
  note3Shuffle.shuffle() ;

  print('note 4 original ${note4Origianl}');
  print('base note ${baseNote}') ;

  print('finalProblem ${finalProblem}');

  print('answer It  ${answer}');

  return (answer,finalProblem);
}



// 정답 / 문제 return
(String,List<Note>) augmentedHalfSixthIt(){

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

  print('==========================================');
  print('chosenTonality ${chosenTonality}');
  print('chosenInt1to7 ${chosenInt1to7}');

  print('baseBefore1Down ${baseBefore1Down}');
  print('baseFinal ${baseFinal.sharp}');

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

  print('note 3 original ${note3Origianl}');
  print('base note ${baseNote}') ;

  List<Note> finalProblem = [baseNote] + note3Shuffle;

  print('finalProblem ${finalProblem}');


  // 정답 산출
  String addNumber;
  String answerRome ;

  if ([1,4,5].contains(chosenInt1to7)){
    answerRome = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    answerRome = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (baseNote == baseFinalUp5Up1.flat){
    addNumber = '6';
  } else {
    addNumber = '6/4';
  }

  print('answer It  ${addNumber} / ${answerRome}');

  return ('It  ${addNumber} / ${answerRome}',finalProblem);
}


// 정답 / 문제 return
(String,List<Note>) augmentedHalfSixthFr(){

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

  print('==========================================');
  print('chosenTonality ${chosenTonality}');
  print('chosenInt1to7 ${chosenInt1to7}');
  print('baseBefore1Down ${baseBefore1Down}');

  print('baseFinal ${baseFinal.sharp}');

  List<Note> note4Origianl =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];

  List<Note> note3Shuffle =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];
  // chose base
  // chose base 근, 3, 5  // 확율 15, 70, 15
  int intValue = Random().nextInt(4); // Value is >= 0 and < 4.
  Note baseNote ;
  List<Note> finalProblem ;
  String answer;

  String answerRome ;

  if ([1,4,5].contains(chosenInt1to7)){
    answerRome = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    answerRome = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (intValue == 0) {
    baseNote = baseFinal.sharp; // 1음 Fr 6/5
    answer = 'Fr 6/5 / ${answerRome}';
  } else if (intValue == 1) {
    baseNote = baseFinalUp5Up1.flat; // 1음 Fr 6/5
    answer = 'Fr 6 / ${answerRome}';
  } else if (intValue == 2) {
    baseNote = baseFinalUp5Up2; // 1음 Fr 6/5
    answer = 'Fr 4/2 / ${answerRome}';
  } else {
    baseNote = baseFinalUp5Up3; // 1음 Fr 6/5
    answer = 'Fr 7/5 / ${answerRome}';
  }

  note3Shuffle.remove(baseNote);
  note3Shuffle.shuffle();
  finalProblem = [baseNote] + note3Shuffle;

  // 최종 문제
  note3Shuffle.shuffle() ;

  print('note 4 original ${note4Origianl}');
  print('base note ${baseNote}') ;

  print('finalProblem ${finalProblem}');

  print('answer It  ${answer}');

  return (answer,finalProblem);
}


// 정답 / 문제 return
(String,List<Note>) augmentedHalfSixthGr(){

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

  print('==========================================');
  print('chosenTonality ${chosenTonality}');
  print('chosenInt1to7 ${chosenInt1to7}');
  print('baseBeforeAccident ${baseBeforeAccident}');

  print('baseFinal ${baseFinal.sharp}');

  List<Note> note4Origianl =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];

  List<Note> note3Shuffle =
  [baseFinal.sharp, baseFinalUp5Up1.flat, baseFinalUp5Up2, baseFinalUp5Up3];
  // chose base
  // chose base 근, 3, 5  // 확율 15, 70, 15
  int intValue = Random().nextInt(4); // Value is >= 0 and < 4.
  Note baseNote ;
  List<Note> finalProblem ;
  String answer;

  String answerRome ;

  if ([1,4,5].contains(chosenInt1to7)){
    answerRome = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    answerRome = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (intValue == 0) {
    baseNote = baseFinal.sharp; // 1음 Fr 6/5
    answer = 'Ger 7/5 / ${answerRome}';
  } else if (intValue == 1) {
    baseNote = baseFinalUp5Up1.flat;
    answer = 'Ger 6 / ${answerRome}';
  } else if (intValue == 2) {
    baseNote = baseFinalUp5Up2;
    answer = 'Ger 4/3 / ${answerRome}';
  } else {
    baseNote = baseFinalUp5Up3;
    answer = 'Ger 4/2 / ${answerRome}';
  }

  note3Shuffle.remove(baseNote);
  note3Shuffle.shuffle();
  finalProblem = [baseNote] + note3Shuffle;

  // 최종 문제
  note3Shuffle.shuffle() ;

  print('note 4 original ${note4Origianl}');
  print('base note ${baseNote}') ;

  print('finalProblem ${finalProblem}');

  print('answer It  ${answer}');

  return (answer,finalProblem);
}
