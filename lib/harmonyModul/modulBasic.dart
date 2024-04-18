import "dart:math";
import 'package:music_notes/music_notes.dart';

import "package:music_notes/music_notes.dart";



Tonality getConditionalTonality(){

  final _random = new Random();

  List<Tonality> conditionList = [
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

  Tonality chosen = conditionList[_random.nextInt(conditionList.length)];

  Note a = Note.f.respellByBaseNoteDistance(-3);

  return chosen;

}

int getOneToSeven(){

  final _random = new Random();

  List<int> oneToSeven = [1,2,3,4,5,6,7];

  int chosen = oneToSeven[_random.nextInt(oneToSeven.length)];

  return chosen;
}