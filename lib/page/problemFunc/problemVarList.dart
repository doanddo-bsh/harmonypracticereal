// ignore_for_file: file_names

import 'package:music_notes/music_notes.dart';
Map intervalNameKorEng = {
  '감' : 'd',
  '완전' : 'P',
  '증' : 'A',
  '겹감' : 'dd',
  '단' : 'm',
  '장' : 'M',
  '겹증' : 'AA',
};

Map intervalNameEngKor = {
  'd':'감',
  'P':'완전',
  'A':'증',
  'dd':'겹감',
  'm':'단',
  'M':'장',
  'AA':'겹증',
};

Map korToEngNote = {
  '도':Note.c,
  '레':Note.d,
  '미':Note.e,
  '파':Note.f,
  '솔':Note.g,
  '라':Note.a,
  '시':Note.b,
};

Map engToKorNote = {
  Note.c:'도',
  Note.d:'레',
  Note.e:'미',
  Note.f:'파',
  Note.g:'솔',
  Note.a:'라',
  Note.b:'시',
};

Map pitchNameEngToKr = {
  Note.d.inOctave(6):'레',
  Note.c.inOctave(6):'도',
  Note.b.inOctave(5):'시',
  Note.a.inOctave(5):'라',
  Note.g.inOctave(5):'솔',
  Note.f.inOctave(5):'파',
  Note.e.inOctave(5):'미',
  Note.d.inOctave(5):'레',
  Note.c.inOctave(5):'도',
  Note.b.inOctave(4):'시',
  Note.a.inOctave(4):'라',
  Note.g.inOctave(4):'솔',
  Note.f.inOctave(4):'파',
  Note.e.inOctave(4):'미',
  Note.d.inOctave(4):'레',
  Note.c.inOctave(4):'도',
  Note.b.inOctave(3):'시',
  Note.a.inOctave(3):'라',
  Note.g.inOctave(3):'솔',
};

List<List<dynamic>> note_height_list_fix =
[
  // topheigh, number, note
  [11.0,0,Note.d.inOctave(6)],
  [24.25,1,Note.c.inOctave(6)],
  [37.5,2,Note.b.inOctave(5)],
  [50.75,3,Note.a.inOctave(5)],
  [64.0,4,Note.g.inOctave(5)],
  [77.25,5,Note.f.inOctave(5)],
  [90.5,6,Note.e.inOctave(5)],
  [103.75,7,Note.d.inOctave(5)],
  [117.0,8,Note.c.inOctave(5)],
  [130.25,9,Note.b.inOctave(4)],
  [143.5,10,Note.a.inOctave(4)],
  [156.75,11,Note.g.inOctave(4)],
  [170.0,12,Note.f.inOctave(4)],
  [183.25,13,Note.e.inOctave(4)],
  [196.5,14,Note.d.inOctave(4)],
  [209.75,15,Note.c.inOctave(4)],
  [223.0,16,Note.b.inOctave(3)],
  [236.25,17,Note.a.inOctave(3)],
  [249.5,18,Note.g.inOctave(3)],
  [262.75,19,Note.f.inOctave(3)],
  [276.0,20,Note.e.inOctave(3)],
  [289.25,21,Note.d.inOctave(3)],
  [302.5,22,Note.c.inOctave(3)],
  [315.75,23,Note.b.inOctave(2)],
  [329.0,24,Note.a.inOctave(2)],
  [342.25,25,Note.g.inOctave(2)],
  [355.5,26,Note.f.inOctave(2)],
  [368.75,27,Note.e.inOctave(2)],
  [382.0,28,Note.d.inOctave(2)],
  [395.25,29,Note.c.inOctave(2)],
  [408.5,30,Note.b.inOctave(1)],
  [421.75,31,Note.a.inOctave(1)],
  [435.0,32,Note.g.inOctave(1)],
  [448.25,33,Note.f.inOctave(1)],
  [461.5,34,Note.e.inOctave(1)],
  [474.75,35,Note.d.inOctave(1)],
  [488.0,36,Note.c.inOctave(1)],
];

List<List<dynamic>> note_height_list =
[
  // topheigh, number, note
  [11.0,0,Note.d.inOctave(6)],
  [24.25,1,Note.c.inOctave(6)],
  [37.5,2,Note.b.inOctave(5)],
  [50.75,3,Note.a.inOctave(5)],
  [64.0,4,Note.g.inOctave(5)],
  [77.25,5,Note.f.inOctave(5)],
  [90.5,6,Note.e.inOctave(5)],
  [103.75,7,Note.d.inOctave(5)],
  [117.0,8,Note.c.inOctave(5)],
  [130.25,9,Note.b.inOctave(4)],
  [143.5,10,Note.a.inOctave(4)],
  [156.75,11,Note.g.inOctave(4)],
  [170.0,12,Note.f.inOctave(4)],
  [183.25,13,Note.e.inOctave(4)],
  [196.5,14,Note.d.inOctave(4)],
  [209.75,15,Note.c.inOctave(4)],
  [223.0,16,Note.b.inOctave(3)],
  [236.25,17,Note.a.inOctave(3)],
  [249.5,18,Note.g.inOctave(3)],
  [262.75,19,Note.f.inOctave(3)],
  [276.0,20,Note.e.inOctave(3)],
  [289.25,21,Note.d.inOctave(3)],
  [302.5,22,Note.c.inOctave(3)],
  [315.75,23,Note.b.inOctave(2)],
  [329.0,24,Note.a.inOctave(2)],
  [342.25,25,Note.g.inOctave(2)],
  [355.5,26,Note.f.inOctave(2)],
  [368.75,27,Note.e.inOctave(2)],
  [382.0,28,Note.d.inOctave(2)],
  [395.25,29,Note.c.inOctave(2)],
  [408.5,30,Note.b.inOctave(1)],
  [421.75,31,Note.a.inOctave(1)],
  [435.0,32,Note.g.inOctave(1)],
  [448.25,33,Note.f.inOctave(1)],
  [461.5,34,Note.e.inOctave(1)],
  [474.75,35,Note.d.inOctave(1)],
  [488.0,36,Note.c.inOctave(1)],
];


// 더블 샵 및 더블 플랫이 나오지 않는 리스트
List<List<PositionedNote>> noDiffDoubleList = [
  [Note.e.inOctave(4),Note.f.inOctave(4)],
  [Note.e.inOctave(5),Note.f.inOctave(5)],

  [Note.b.inOctave(4),Note.c.inOctave(5)],
  [Note.b.inOctave(3),Note.c.inOctave(4)],
  [Note.b.inOctave(5),Note.c.inOctave(6)],

  [Note.d.inOctave(4),Note.f.inOctave(4)],
  [Note.d.inOctave(5),Note.f.inOctave(5)],

  [Note.e.inOctave(4),Note.g.inOctave(4)],
  [Note.e.inOctave(5),Note.g.inOctave(5)],

  [Note.a.inOctave(3),Note.c.inOctave(4)],
  [Note.a.inOctave(4),Note.c.inOctave(5)],
  [Note.a.inOctave(5),Note.c.inOctave(6)],

  [Note.b.inOctave(3),Note.d.inOctave(4)],
  [Note.b.inOctave(4),Note.d.inOctave(5)],
  [Note.b.inOctave(5),Note.d.inOctave(6)],

  [Note.f.inOctave(4),Note.b.inOctave(4)],
  [Note.f.inOctave(5),Note.b.inOctave(5)],
  [Note.f.inOctave(6),Note.b.inOctave(6)],

  [Note.b.inOctave(3),Note.f.inOctave(4)],
  [Note.b.inOctave(4),Note.f.inOctave(5)],
  [Note.b.inOctave(5),Note.f.inOctave(6)],

  [Note.e.inOctave(3),Note.c.inOctave(4)],
  [Note.e.inOctave(4),Note.c.inOctave(5)],
  [Note.e.inOctave(5),Note.c.inOctave(6)],

  [Note.b.inOctave(3),Note.g.inOctave(4)],
  [Note.b.inOctave(4),Note.g.inOctave(5)],
  [Note.b.inOctave(5),Note.g.inOctave(6)],

  [Note.a.inOctave(3),Note.f.inOctave(4)],
  [Note.a.inOctave(4),Note.f.inOctave(5)],

  [Note.d.inOctave(3),Note.c.inOctave(4)],
  [Note.d.inOctave(4),Note.c.inOctave(5)],
  [Note.d.inOctave(5),Note.c.inOctave(6)],

  [Note.e.inOctave(4),Note.d.inOctave(5)],

  [Note.g.inOctave(3),Note.f.inOctave(4)],
  [Note.g.inOctave(4),Note.f.inOctave(5)],

  [Note.a.inOctave(4),Note.g.inOctave(5)],
  [Note.a.inOctave(3),Note.g.inOctave(4)],

  [Note.b.inOctave(4),Note.a.inOctave(5)],
  [Note.b.inOctave(3),Note.a.inOctave(4)],
];

