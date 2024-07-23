import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_notes/music_notes.dart';
import 'dart:math';

// add line 시리즈
Widget returnLineHarmony(
    double baseTop
    ,double intervalTop
    ,int multipleTop
    ,String longShort
    ,[double leftPosition = 1]
    ){

  double topFinal = baseTop + intervalTop * multipleTop;

  if (leftPosition ==1){
    leftPosition = 170.w;
  }

  // print('returnLineHarmony topFinal ${topFinal}');

  if (longShort == 'long'){
    return Positioned(
        top: topFinal.h,
        left: 10.w,
        right: 10.w,
        child:
        Container(
          color: Colors.black,
          width: double.infinity,
          height: 2.0.h,
        )
    );
  } else {
    return Positioned(
        top: topFinal.h,
        left: leftPosition,
        // right: 160.w,
        child:
        Container(
          color: Colors.black,
          width: 26.5.h*1.9,
          height: 2.0.h,
        )
    );
  }

}

PositionedNote returnNoAccidents(PositionedNote inputPositionedNote){
  if (inputPositionedNote.note.accidental.toString() == 'Natural ♮ (+0)'){
    return inputPositionedNote;
  } else if (inputPositionedNote.note.accidental.toString() == 'Sharp ♯ (+1)'){
    return inputPositionedNote.note.flat.inOctave(inputPositionedNote.octave);
  } else if (inputPositionedNote.note.accidental.toString() == 'Flat ♭ (-1)'){
    return inputPositionedNote.note.sharp.inOctave(inputPositionedNote.octave);
  } else if (inputPositionedNote.note.accidental.toString() == 'Double sharp 𝄪 (+2)'){
    return inputPositionedNote.note.flat.flat.inOctave(inputPositionedNote.octave);
  } else if (inputPositionedNote.note.accidental.toString() == 'Double flat 𝄫 (-2)'){
    return inputPositionedNote.note.sharp.sharp.inOctave(inputPositionedNote
        .octave);
  } else {
    return inputPositionedNote;
  }
}

Widget returnNoteHarmony(
    double baseTop
    ,double intervalTop
    ,PositionedNote multipleTopPositionedNoteInput
    // ,int multipleTop
    ,List<dynamic> lineFiveInfo
    ,String highLow
    ){

    int multipleTop ;
    PositionedNote multipleTopPositionedNote = returnNoAccidents(multipleTopPositionedNoteInput);

    // sharp flat 제외
    // print(Note.c.sharp.inOctave(3)) ;
    // print(Note.c.sharp.inOctave(3).note.flat.inOctave(Note.c.sharp.inOctave(3).octave)) ;
    //
    // print(Note.c.flat.inOctave(3)) ;
    // print(Note.c.flat.inOctave(3).note.sharp
    //     .inOctave(Note.c.sharp.inOctave(3)
    //     .octave)) ;
    //
    // print(Note.c.inOctave(3).note.accidental.toString() == 'Natural ♮ (+0)') ;
    // print(Note.c.flat.flat.inOctave(3).note.accidental.toString() == 'Double flat 𝄫 (-2)') ;
    // print(Note.c.sharp.sharp.inOctave(3).note.accidental.toString()=='Double sharp 𝄪 (+2)') ;
    // print(Note.f.sharp.inOctave(4).note.accidental.toString()=="Sharp ♯ (+1)") ;
    // print(Note.f.flat.inOctave(4).note.accidental.toString()=="Flat ♭ (-1)") ;


    if (highLow == 'high'){
      multipleTop = notePositionMapHigh[multipleTopPositionedNote]! ;
    } else {
      multipleTop = notePositionMapLow[multipleTopPositionedNote]! ;
    }

    double topFinal = baseTop + intervalTop * multipleTop;

    List<double> middleLine;
    List<double> lowLine;
    List<double> highLine;
    List<double> twolinelow;
    List<double> twolinemiddle;
    List<double> twolinehigh ;

    // multipleTop 에 따른 덧줄 여부 결정
    if (highLow == 'high'){
      // middle line
      middleLine = [
        -5.0, 7.0
        // , 9.0, 13.0, 25.0
      ];
      // low line
      lowLine = [
        -6.0
        // , 12.0
      ];
      // high line
      highLine = [
        8.0
        // , 26.0
      ];
      twolinehigh = [
        9.0
      ];
      // high line
      twolinelow = [
        1000.0,
      ];
      // high line
      twolinemiddle = [
        1000.0,
      ];


    } else {
      // middle line
      middleLine = [
        11.0, 23.0,
      ];
      // low line
      lowLine = [
        10.0
      ];
      // high line
      highLine = [
        24.0
      ];
      twolinehigh = [
        9.0
      ];
      // high line
      twolinelow = [
        8.0,
      ];
      // high line
      twolinemiddle = [
        9.0,
      ];

    }

    double leftPosition = 170.w ;

    if (middleLine.contains(multipleTop)){
      return Stack(
          children: [
            Positioned(
              top:topFinal.h,
              left: leftPosition,
              child: SizedBox(
                height: 26.5.h,
                child: Stack(
                  children: [
                    Image.asset('assets/whole_note_lean.png'),
                    // addLine1(randomNote[0]),
                    // addLine1(noteInfo, highLow),
                  ],
                ),
              ),
            ),
            // middle line
            returnLineHarmony(
                baseTop + intervalTop*1
                , intervalTop
                , multipleTop
                , 'short'
                , leftPosition
            ),
          ]
      );
    } else if (lowLine.contains(multipleTop)) {
      return Stack(
          children: [
            Positioned(
              top:topFinal.h,
              left: leftPosition,
              child: SizedBox(
                height: 26.5.h,
                child: Stack(
                  children: [
                    Image.asset('assets/whole_note_lean.png'),
                    // addLine1(randomNote[0]),
                    // addLine1(noteInfo, highLow),
                  ],
                ),
              ),
            ),
            // low line
            returnLineHarmony(
                baseTop + intervalTop*2
                , intervalTop
                , multipleTop
                , 'short'
                , leftPosition
            ),
          ]
      );
    } else if (highLine.contains(multipleTop)){
      return Stack(
          children: [
            Positioned(
              top:topFinal.h,
              left: leftPosition,
              child: SizedBox(
                height: 26.5.h,
                child: Stack(
                  children: [
                    Image.asset('assets/whole_note_lean.png'),
                    // addLine1(randomNote[0]),
                    // addLine1(noteInfo, highLow),
                  ],
                ),
              ),
            ),
            // high line
            returnLineHarmony(
                baseTop + intervalTop*0
                , intervalTop
                , multipleTop, 'short'
                , leftPosition
            ),
          ]
      );
    } else if (twolinelow.contains(multipleTop)){
      return Stack(
          children: [
            Positioned(
              top:topFinal.h,
              left: leftPosition,
              child: SizedBox(
                height: 26.5.h,
                child: Stack(
                  children: [
                    Image.asset('assets/whole_note_lean.png'),
                  ],
                ),
              ),
            ),
            // low line
            returnLineHarmony(
                baseTop + intervalTop*2
                , intervalTop
                , multipleTop, 'short'
                , leftPosition
            ),
            returnLineHarmony(
                baseTop + intervalTop*2
                , intervalTop
                , multipleTop+2, 'short'
                , leftPosition
            ),
          ]
      );
    } else if (twolinemiddle.contains(multipleTop)){
      return Stack(
          children: [
            Positioned(
              top:topFinal.h,
              left: leftPosition,
              child: SizedBox(
                height: 26.5.h,
                child: Stack(
                  children: [
                    Image.asset('assets/whole_note_lean.png'),
                    // addLine1(randomNote[0]),
                    // addLine1(noteInfo, highLow),
                  ],
                ),
              ),
            ),
            // middle line
            returnLineHarmony(
                baseTop + intervalTop*1
                , intervalTop
                , multipleTop, 'short'
                , leftPosition
            ),
            returnLineHarmony(
                baseTop + intervalTop*2
                , intervalTop
                , multipleTop+1, 'short'
                , leftPosition
            ),
          ]
      );
    } else if (twolinehigh.contains(multipleTop)){
      return Stack(
          children: [
            Positioned(
              top:topFinal.h,
              left: leftPosition,
              child: SizedBox(
                height: 26.5.h,
                child: Stack(
                  children: [
                    Image.asset('assets/whole_note_lean.png'),
                    // addLine1(randomNote[0]),
                    // addLine1(noteInfo, highLow),
                  ],
                ),
              ),
            ),
            // middle line
            returnLineHarmony(
                baseTop + intervalTop*1
                , intervalTop
                , multipleTop-2, 'short'
                , leftPosition
            ),
            returnLineHarmony(
                baseTop + intervalTop*2
                , intervalTop
                , multipleTop-1, 'short'
                , leftPosition
            ),
          ]
      );
    } else {
      return Stack(
          children: [
            Positioned(
              top:topFinal.h,
              left: leftPosition,
              child: SizedBox(
                height: 26.5.h,
                child: Stack(
                  children: [
                    Image.asset('assets/whole_note_lean.png'),
                    // addLine1(randomNote[0]),
                    // addLine1(noteInfo, highLow),
                  ],
                ),
              ),
            ),
          ]
      );
    }
}


Widget addAccidentals(String accidental, double top, double left){

  double height = 25.h;
  double weight = 20.w;

  if (accidental == 'Natural ♮ (+0)'){
    return const SizedBox();
  } else if (accidental == 'Sharp ♯ (+1)'){
    return Positioned(
      top: top-10.0.h,
      left: left-11.0.h,
      child: SizedBox(
        height: 48.h,
        width: 48.h/1,
        child: const Image(
          image: AssetImage('assets/sharp2.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  } else if (accidental == 'Double sharp 𝄪 (+2)'){
    return Positioned(
      top: top+3.5.h,
      left: left-2.0.h,
      child: SizedBox(
        height: 19.h,
        width: 19.h*1.1,
        child: const Image(
          image: AssetImage('assets/doubleSharp.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  } else if (accidental == 'Flat ♭ (-1)'){
    return Positioned(
      top: top-16.0.h,
      left: left+7.0.h,
      child: SizedBox(
        height: 41.h,
        width: 16.h,
        child: const Image(
          image: AssetImage('assets/flat2.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  } else if (accidental == 'Double flat 𝄫 (-2)'){
    return Positioned(
      top: top-17.5.h,
      left: left-7.5.h,
      child: SizedBox(
        height: 45.h,
        width: 30.h,
        child: const Image(
          image: AssetImage('assets/doubleFlat.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  } else {
    return SizedBox();
  }
}

Widget returnAccidents(
    double baseTop
    ,double intervalTop
    ,PositionedNote multipleTopPositionedNoteInput
    // ,int multipleTop
    ,List<dynamic> lineFiveInfo
    ,String highLow
    ){

  double leftPosition = 150.w ;

  String accidental = multipleTopPositionedNoteInput.note.accidental.toString() ;

  int multipleTop ;
  PositionedNote multipleTopPositionedNote = returnNoAccidents(multipleTopPositionedNoteInput);

  if (highLow == 'high'){
    multipleTop = notePositionMapHigh[multipleTopPositionedNote]! ;
  } else {
    multipleTop = notePositionMapLow[multipleTopPositionedNote]! ;
  }

  double topFinal = baseTop + intervalTop * multipleTop;

  List<double> middleLine;
  List<double> lowLine;
  List<double> highLine;
  List<double> twolinelow;
  List<double> twolinemiddle;
  List<double> twolinehigh ;

  // multipleTop 에 따른 덧줄 여부 결정
  if (highLow == 'high'){
    // middle line
    middleLine = [
      -5.0, 7.0
      // , 9.0, 13.0, 25.0
    ];
    // low line
    lowLine = [
      -6.0
      // , 12.0
    ];
    // high line
    highLine = [
      8.0
      // , 26.0
    ];
    // high line
    twolinehigh = [
      9.0,
    ];

    twolinelow = [
      1000.0,
    ];
    // high line
    twolinemiddle = [
      1000.0,
    ];
  } else {
    // middle line
    middleLine = [
      11.0, 23.0,
    ];
    // low line
    lowLine = [
      10.0
    ];
    // high line
    highLine = [
      24.0
    ];
    twolinehigh = [
      1000.0,
    ];
    // high line
    twolinelow = [
      8.0,
    ];
    // high line
    twolinemiddle = [
      9.0,
    ];

  }



  if (accidental == 'Natural ♮ (+0)'){
    return SizedBox();
  // } else if (middleLine.contains(multipleTop)){
  //   return Stack(
  //       children: [
  //         addAccidentals(accidental, topFinal.h, leftPosition),
  //         // middle line
  //         returnLineHarmony(
  //             baseTop + intervalTop*1
  //             , intervalTop
  //             , multipleTop
  //             , 'short'
  //             , leftPosition
  //         ),
  //       ]
  //   );
  // } else if (lowLine.contains(multipleTop)) {
  //   return Stack(
  //       children: [
  //         addAccidentals(accidental, topFinal.h, leftPosition),
  //         // low line
  //         returnLineHarmony(
  //             baseTop + intervalTop*2
  //             , intervalTop
  //             , multipleTop
  //             , 'short'
  //             , leftPosition
  //         ),
  //       ]
  //   );
  // } else if (highLine.contains(multipleTop)){
  //   return Stack(
  //       children: [
  //         addAccidentals(accidental, topFinal.h, leftPosition),
  //         // high line
  //         returnLineHarmony(
  //             baseTop + intervalTop*0
  //             , intervalTop
  //             , multipleTop, 'short'
  //             , leftPosition
  //         ),
  //       ]
  //   );
  // } else if (twolinelow.contains(multipleTop)){
  //   return Stack(
  //       children: [
  //         addAccidentals(accidental, topFinal.h, leftPosition),
  //         // low line
  //         returnLineHarmony(
  //             baseTop + intervalTop*2
  //             , intervalTop
  //             , multipleTop, 'short'
  //             , leftPosition
  //         ),
  //         returnLineHarmony(
  //             baseTop + intervalTop*2
  //             , intervalTop
  //             , multipleTop+2, 'short'
  //             , leftPosition
  //         ),
  //       ]
  //   );
  // } else if (twolinemiddle.contains(multipleTop)){
  //   return Stack(
  //       children: [
  //         addAccidentals(accidental, topFinal.h, leftPosition),
  //         // middle line
  //         returnLineHarmony(
  //             baseTop + intervalTop*1
  //             , intervalTop
  //             , multipleTop, 'short'
  //             , leftPosition
  //         ),
  //         returnLineHarmony(
  //             baseTop + intervalTop*2
  //             , intervalTop
  //             , multipleTop+1, 'short'
  //             , leftPosition
  //         ),
  //       ]
  //   );
  // } else if (twolinehigh.contains(multipleTop)){
  //   return Stack(
  //       children: [
  //         addAccidentals(accidental, topFinal.h, leftPosition),
  //         // middle line
  //         returnLineHarmony(
  //             baseTop + intervalTop*1
  //             , intervalTop
  //             , multipleTop-2, 'short'
  //             , leftPosition
  //         ),
  //         returnLineHarmony(
  //             baseTop + intervalTop*2
  //             , intervalTop
  //             , multipleTop-1, 'short'
  //             , leftPosition
  //         ),
  //       ]
  //   );
  }
  else {
    return Stack(
        children: [
          addAccidentals(accidental, topFinal.h, leftPosition),
        ]
    );
  }
}


// sharp flat add
Widget returnNoteHarmonyFinal(
    double baseTop
    ,double intervalTop
    ,PositionedNote multipleTopPositionedNoteInput
    // ,int multipleTop
    ,List<dynamic> lineFiveInfo
    ,String highLow
    ){

  return Stack(
    children: [
      returnNoteHarmony(
          baseTop
          ,intervalTop
          ,multipleTopPositionedNoteInput
          ,lineFiveInfo
          ,highLow
      ),
      returnAccidents(
          baseTop
          ,intervalTop
          ,multipleTopPositionedNoteInput
          ,lineFiveInfo
          ,highLow
      )
    ],
  );
}

Widget harmonyExpressionFinal(
    double mainSize
    ,String roman
    ,String upNumber
    ,String downNumber
    ,[
      String slash = 'none'
    ,String roman2 = 'none'
    ,String upNumber2 = 'none'
    ,String downNumber2 = 'none'
    ]
    ){

  double slashSize = mainSize*30/100;
  double sizedBoxSpace = mainSize*5/100;

  if (slash == 'none'){
    return harmonyExpression(mainSize,roman,upNumber,downNumber);
  } else {
    return Row(
      children: [
        harmonyExpression(mainSize,roman,upNumber,downNumber)
        ,SizedBox(width: sizedBoxSpace.w,)
        ,Text('/', style: TextStyle(fontSize: slashSize.sp),)
        ,SizedBox(width: sizedBoxSpace.w,)
        ,harmonyExpression(mainSize,roman2,upNumber2,downNumber2)
      ],
    );
  }
}


Widget harmonyExpression(
    double mainSize
    ,String roman
    ,String upNumber
    ,String downNumber
    ){

  double firstSizedBoxSize = mainSize*40/100;
  double romanTextSize = mainSize*30/100;
  double secondSizedBoxSize = mainSize*5/100;
  double thirdSizedBoxSize = mainSize*15/100;
  double numberTextSize = mainSize*12.5/100;

  return Container(
    child: Row(
      children: [
        SizedBox(
          height: firstSizedBoxSize.h,
          // width: firstSizedBoxSize.h,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(roman,
              style: TextStyle(fontSize: romanTextSize.sp),
            ),
          ),
        ),
        SizedBox(width: secondSizedBoxSize.h,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: thirdSizedBoxSize.h,
              // width: thirdSizedBoxSize.h,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(downNumber,
                  style: TextStyle(fontSize: numberTextSize.sp),
                ),
              ),
            ),
            SizedBox(
              height: thirdSizedBoxSize.h,
              // width: thirdSizedBoxSize.h,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(upNumber,
                  style: TextStyle(fontSize: numberTextSize.sp),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}



Map<PositionedNote, int> notePositionMapHigh =
{
  Note.d.inOctave(6):-8,
  Note.c.inOctave(6):-7,
  Note.b.inOctave(5):-6,
  Note.a.inOctave(5):-5,
  Note.g.inOctave(5):-4,
  Note.f.inOctave(5):-3,
  Note.e.inOctave(5):-2,
  Note.d.inOctave(5):-1,
  Note.c.inOctave(5):0,
  Note.b.inOctave(4):1,
  Note.a.inOctave(4):2,
  Note.g.inOctave(4):3,
  Note.f.inOctave(4):4,
  Note.e.inOctave(4):5,
  Note.d.inOctave(4):6,
  Note.c.inOctave(4):7,
  Note.b.inOctave(3):8,
  Note.a.inOctave(3):9,
  Note.g.inOctave(3):10,
  Note.f.inOctave(3):11,
  Note.e.inOctave(3):12,
  Note.d.inOctave(3):13,
  Note.c.inOctave(3):14,
  Note.b.inOctave(2):15,
  Note.a.inOctave(2):16,
  Note.g.inOctave(2):17,
  Note.f.inOctave(2):18,
  Note.e.inOctave(2):19,
  Note.d.inOctave(2):20,
  Note.c.inOctave(2):21,
  Note.b.inOctave(1):22,
  Note.a.inOctave(1):23,
  Note.g.inOctave(1):24,
  Note.f.inOctave(1):25,
  Note.e.inOctave(1):26,
  Note.d.inOctave(1):27,
  Note.c.inOctave(1):28,
};

Map<PositionedNote, int> notePositionMapLow =
{
  Note.d.inOctave(6):-4,
  Note.c.inOctave(6):-3,
  Note.b.inOctave(5):-2,
  Note.a.inOctave(5):-1,
  Note.g.inOctave(5):0,
  Note.f.inOctave(5):1,
  Note.e.inOctave(5):2,
  Note.d.inOctave(5):3,
  Note.c.inOctave(5):4,
  Note.b.inOctave(4):5,
  Note.a.inOctave(4):6,
  Note.g.inOctave(4):7,
  Note.f.inOctave(4):8,
  Note.e.inOctave(4):9,
  Note.d.inOctave(4):10,
  Note.c.inOctave(4):11,
  Note.b.inOctave(3):12,
  Note.a.inOctave(3):13,
  Note.g.inOctave(3):14,
  Note.f.inOctave(3):15,
  Note.e.inOctave(3):16,
  Note.d.inOctave(3):17,
  Note.c.inOctave(3):18,
  Note.b.inOctave(2):19,
  Note.a.inOctave(2):20,
  Note.g.inOctave(2):21,
  Note.f.inOctave(2):22,
  Note.e.inOctave(2):23,
  Note.d.inOctave(2):24,
  Note.c.inOctave(2):25,
  Note.b.inOctave(1):26,
  Note.a.inOctave(1):27,
  Note.g.inOctave(1):28,
  Note.f.inOctave(1):29,
  Note.e.inOctave(1):30,
  Note.d.inOctave(1):31,
  Note.c.inOctave(1):32,
};



// // 어떤 문제 리스트 쓸지 결정
// problemListShow =
// problemListList[_random.nextInt(problemListList
//     .length)];
//
// // 해당 문제 리스트의 key list 획득
// problemShowKeyList =
// problemListShow.keys.toList();
//
// // 문제 리스트중 특정 key의 문제 추출
// problemShowNumber =
// problemShowKeyList[_random.nextInt(problemShowKeyList.length)];