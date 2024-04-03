import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// add line 시리즈
Widget returnLineHarmony(
    double baseTop
    ,double intervalTop
    ,int multipleTop
    ,String longShort
    ){

  double topFinal = baseTop + intervalTop * multipleTop;

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
        left: 170.w,
        right: 155.w,
        child:
        Container(
          color: Colors.black,
          width: double.infinity,
          height: 2.0.h,
        )
    );
  }

}

Widget returnNoteHarmony(
    double baseTop
    ,double intervalTop
    ,int multipleTop
    ,List<dynamic> lineFiveInfo
    ,String highLow
    ){

    double topFinal = baseTop + intervalTop * multipleTop;

    List<double> middleLine;
    List<double> lowLine;
    List<double> highLine;
    List<double> twolinelow;
    List<double> twolinemiddle;

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
      // high line
      twolinelow = [
        8.0,
      ];
      // high line
      twolinemiddle = [
        9.0,
      ];

    }

    if (middleLine.contains(multipleTop)){
      return Stack(
          children: [
            Positioned(
              top:topFinal.h,
              left: 170.w,
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
            ),
          ]
      );
    } else if (lowLine.contains(multipleTop)) {
      return Stack(
          children: [
            Positioned(
              top:topFinal.h,
              left: 170.w,
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
                , multipleTop, 'short'
            ),
          ]
      );
    } else if (highLine.contains(multipleTop)){
      return Stack(
          children: [
            Positioned(
              top:topFinal.h,
              left: 170.w,
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
            ),
          ]
      );
    } else if (twolinelow.contains(multipleTop)){
      return Stack(
          children: [
            Positioned(
              top:topFinal.h,
              left: 170.w,
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
            ),
            returnLineHarmony(
                baseTop + intervalTop*2
                , intervalTop
                , multipleTop+2, 'short'
            ),
          ]
      );
    } else if (twolinemiddle.contains(multipleTop)){
      return Stack(
          children: [
            Positioned(
              top:topFinal.h,
              left: 170.w,
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
            ),
            returnLineHarmony(
                baseTop + intervalTop*2
                , intervalTop
                , multipleTop+1, 'short'
            ),
          ]
      );
    } else {
      return Stack(
          children: [
            Positioned(
              top:topFinal.h,
              left: 170.w,
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
