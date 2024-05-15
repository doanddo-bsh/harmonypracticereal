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

int getOneToSix(){

  final _random = new Random();

  List<int> oneToSeven = [1,2,3,4,5,6];

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
(String,List<Note>,Tonality) basicProblemMinor({String
conditionTonalityCondition='no'}){

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


// 정답 / 문제 return
(String,List<Note>,Tonality) secondaryDominant7thProblemMinor(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonalitMinor('yes');
  int chosenInt1to7 = getOneToSix();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;

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

  if ([3,5,6].contains(chosenInt1to7)){
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

  String answerFinal ;
  if (chosenInt1to7==1){
    answerFinal = 'V${addNumber}';
  } else {
    answerFinal = 'V${addNumber + ' / ' + answerRome}';
  }

  print('answerFinal ${answerFinal}');

  return (answerFinal,note4Shuffle,chosenTonality);
}


// 정답 / 문제 return
(String,List<Note>,Tonality) dominant7thProblemMinor(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonalitMinor('yes');
  int chosenInt1to7 = 1;

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;

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

  if ([3,5,6].contains(chosenInt1to7)){
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

  String answerFinal ;
  if (chosenInt1to7==1){
    answerFinal = 'V${addNumber}';
  } else {
    answerFinal = 'V${addNumber + ' / ' + answerRome}';
  }

  print('answerFinal ${answerFinal}');

  return (answerFinal,note4Shuffle,chosenTonality);
}



// 정답 / 문제 return
(String,List<Note>,Tonality) neapolitanProblemMinor(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonalitMinor('no');
  int chosenInt1to7 = 2; // 나폴리는 2로 고정

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;

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

  String answerFinal ;
  answerFinal = 'N ${addNumber}';

  print('answerFinal ${answerFinal}');

  return (answerFinal,note4Shuffle,chosenTonality);
}



// 정답 / 문제 return
(String,List<Note>,Tonality) secondaryDiminished7thProblemMinor(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonalitMinor('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = getOneToSix();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;

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

  if ([3,5,6].contains(chosenInt1to7)){
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

  String answerFinal ;
  if (chosenInt1to7==1){
    answerFinal = "Vii' ${addNumber}";
  } else {
    answerFinal = "Vii' ${addNumber} / ${answerRome}";
  }

  print('answerFinal ${answerFinal}');

  return (answerFinal,note4Shuffle,chosenTonality);
}

// 정답 / 문제 return
(String,List<Note>,Tonality) diminished7thProblemMinor(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonalitMinor('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = 1;

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;

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

  if ([3,5,6].contains(chosenInt1to7)){
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

  String answerFinal ;
  if (chosenInt1to7==1){
    answerFinal = "Vii' ${addNumber}";
  } else {
    answerFinal = "Vii' ${addNumber} / ${answerRome}";
  }

  print('answerFinal ${answerFinal}');

  return (answerFinal,note4Shuffle,chosenTonality);
}




// 정답 / 문제 return
(String,List<Note>,Tonality) augmentedSixthItMinor(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonalitMinor('no');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = 4;

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;


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

  String answerFinal ;
  answerFinal = "It ${addNumber}";

  print('answerFinal ${answerFinal}');

  return (answerFinal,finalProblem,chosenTonality);
}



// 정답 / 문제 return
(String,List<Note>,Tonality) augmentedSixthFrMinor(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonalitMinor('no');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = 4;

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;


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

  String answerFinal;

  if (intValue == 0) {
    baseNote = baseFinal.sharp; // 1음 Fr 6/5
    answerFinal = 'Fr 6/5';
  } else if (intValue == 1) {
    baseNote = baseFinalUp5Up1.flat; // 1음 Fr 6/5
    answerFinal = 'Fr 6';
  } else if (intValue == 2) {
    baseNote = baseFinalUp5Up2; // 1음 Fr 6/5
    answerFinal = 'Fr 4/2';
  } else {
    baseNote = baseFinalUp5Up3; // 1음 Fr 6/5
    answerFinal = 'Fr 7/5';
  }

  note3Shuffle.remove(baseNote);
  note3Shuffle.shuffle();
  finalProblem = [baseNote] + note3Shuffle;

  // 최종 문제
  note3Shuffle.shuffle() ;

  print('note 4 original ${note4Origianl}');
  print('base note ${baseNote}') ;

  print('finalProblem ${finalProblem}');

  print('answerFinal ${answerFinal}');

  return (answerFinal,finalProblem,chosenTonality);
}



// 정답 / 문제 return
(String,List<Note>,Tonality) augmentedSixthGrMinor(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonalitMinor('no');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = 4;

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;


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
  String answerFinal;

  if (intValue == 0) {
    baseNote = baseFinal.sharp; // 1음 Fr 6/5
    answerFinal = 'Ger 7/5';
  } else if (intValue == 1) {
    baseNote = baseFinalUp5Up1.flat;
    answerFinal = 'Ger 6';
  } else if (intValue == 2) {
    baseNote = baseFinalUp5Up2;
    answerFinal = 'Ger 4/3';
  } else {
    baseNote = baseFinalUp5Up3;
    answerFinal = 'Ger 4/2';
  }

  note3Shuffle.remove(baseNote);
  note3Shuffle.shuffle();
  finalProblem = [baseNote] + note3Shuffle;

  // 최종 문제
  note3Shuffle.shuffle() ;

  print('note 4 original ${note4Origianl}');
  print('base note ${baseNote}') ;

  print('finalProblem ${finalProblem}');

  print('answerFinal  ${answerFinal}');

  return (answerFinal,finalProblem,chosenTonality);
}



// m3 m3 M3
// 정답 / 문제 return
(String,List<Note>,Tonality) secondaryHalfDiminished7thProblemMinor(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonalitMinor('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = getOneToSix();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;

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

  if ([3,5,6].contains(chosenInt1to7)){
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

  String answerFinal ;
  if (chosenInt1to7==1){
    answerFinal = "Vii' 반 ${addNumber}";
  } else {
    answerFinal = "Vii' 반 ${addNumber} / ${answerRome}";
  }

  print('answerFinal  ${answerFinal}');

  return (answerFinal,note4Shuffle,chosenTonality);
}

// m3 m3 M3
// 정답 / 문제 return
(String,List<Note>,Tonality) halfDiminished7thProblemMinor(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonalitMinor('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = 1;

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  Note baseFinal = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;

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

  if ([3,5,6].contains(chosenInt1to7)){
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

  String answerFinal ;
  if (chosenInt1to7==1){
    answerFinal = "Vii' 반 ${addNumber}";
  } else {
    answerFinal = "Vii' 반 ${addNumber} / ${answerRome}";
  }

  print('answerFinal  ${answerFinal}');

  return (answerFinal,note4Shuffle,chosenTonality);
}



// 정답 / 문제 return
(String,List<Note>,Tonality) augmentedHalfSixthItMinor(){

  // 문제 결정 조를 결정함
  Tonality chosenTonality = getConditionalTonalitMinor('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  // 부증6화음은 7개음 모두 가능
  int chosenInt1to7 = getOneToSix();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  // 조에 따른 조표 붙이기
  Note baseBefore1Down = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;

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

  if ([3,5,6].contains(chosenInt1to7)){
    answerRome = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    answerRome = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (baseNote == baseFinalUp5Up1.flat){
    addNumber = '6';
  } else {
    addNumber = '6/4';
  }

  String answerFinal ;
  if (chosenInt1to7==1){
    answerFinal = "It ${addNumber} / ${answerRome}";
  } else {
    answerFinal = "It ${addNumber} / ${answerRome}";
  }

  print('answerFinal  ${answerFinal}');

  return (answerFinal,finalProblem,chosenTonality);
}



// 정답 / 문제 return
(String,List<Note>,Tonality) augmentedHalfSixthFrMinor(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonalitMinor('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  // 부증6화음은 7개 음 모두 가능
  int chosenInt1to7 = getOneToSix();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  // 조에 따른 조표 붙이기
  Note baseBefore1Down = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;

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
  String answerFinal;

  String answerRome ;

  if ([3,5,6].contains(chosenInt1to7)){
    answerRome = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    answerRome = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (intValue == 0) {
    baseNote = baseFinal.sharp; // 1음 Fr 6/5
    answerFinal = 'Fr 6/5 / ${answerRome}';
  } else if (intValue == 1) {
    baseNote = baseFinalUp5Up1.flat; // 1음 Fr 6/5
    answerFinal = 'Fr 6 / ${answerRome}';
  } else if (intValue == 2) {
    baseNote = baseFinalUp5Up2; // 1음 Fr 6/5
    answerFinal = 'Fr 4/2 / ${answerRome}';
  } else {
    baseNote = baseFinalUp5Up3; // 1음 Fr 6/5
    answerFinal = 'Fr 7/5 / ${answerRome}';
  }

  note3Shuffle.remove(baseNote);
  note3Shuffle.shuffle();
  finalProblem = [baseNote] + note3Shuffle;

  // 최종 문제
  note3Shuffle.shuffle() ;

  print('note 4 original ${note4Origianl}');
  print('base note ${baseNote}') ;

  print('finalProblem ${finalProblem}');


  print('answerFinal  ${answerFinal}');

  return (answerFinal,finalProblem,chosenTonality);
}



// 정답 / 문제 return
(String,List<Note>,Tonality) augmentedHalfSixthGrMinor(){

  // 문제 결정
  Tonality chosenTonality = getConditionalTonalitMinor('yes');
  // Fsharp / Csharp / G flat, Cflat 제외

  int chosenInt1to7 = getOneToSix();

  // 근음 이동
  String noteName = chosenTonality.note.baseNote.transposeBySize
    (chosenInt1to7).name ;

  Note baseBeforeAccident = Note.parse(noteName);

  // 조에 따른 조표 붙이기
  Note baseBefore1Down = addSharpByTonalityMinor(baseBeforeAccident,chosenTonality) ;

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
  String answerFinal;

  String answerRome ;

  if ([3,5,6].contains(chosenInt1to7)){
    answerRome = chosenInt1to7.toRomanNumeralString()!.toUpperCase(); // 대문자
  } else {
    answerRome = chosenInt1to7.toRomanNumeralString()!.toLowerCase(); // 소문자
  }

  if (intValue == 0) {
    baseNote = baseFinal.sharp; // 1음 Fr 6/5
    answerFinal = 'Ger 7/5 / ${answerRome}';
  } else if (intValue == 1) {
    baseNote = baseFinalUp5Up1.flat;
    answerFinal = 'Ger 6 / ${answerRome}';
  } else if (intValue == 2) {
    baseNote = baseFinalUp5Up2;
    answerFinal = 'Ger 4/3 / ${answerRome}';
  } else {
    baseNote = baseFinalUp5Up3;
    answerFinal = 'Ger 4/2 / ${answerRome}';
  }

  note3Shuffle.remove(baseNote);
  note3Shuffle.shuffle();
  finalProblem = [baseNote] + note3Shuffle;

  // 최종 문제
  note3Shuffle.shuffle() ;

  print('note 4 original ${note4Origianl}');
  print('base note ${baseNote}') ;

  print('finalProblem ${finalProblem}');

  print('answerFinal  ${answerFinal}');

  return (answerFinal,finalProblem,chosenTonality);
}
