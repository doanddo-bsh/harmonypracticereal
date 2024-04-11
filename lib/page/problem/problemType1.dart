// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../problemFunc/providerCounter.dart';
import 'package:music_notes/music_notes.dart';
import 'package:provider/provider.dart';
import '../problemFunc/colorList.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../problemFunc/admobClass.dart';
import '../problemFunc/admobFunc.dart';
import '../problemFunc/problemFunc.dart';
import '../problemFunc/problemFuncHarmony.dart';
import '../problemFunc/problemFuncDeco.dart';
import '../problemFunc/problemVarList.dart';
// import '../problemFunc/resultPage.dart';
import 'problemType1List.dart';


class tonalityProblemType1 extends StatefulWidget {
  const tonalityProblemType1({super.key});

  @override
  State<tonalityProblemType1> createState() => _tonalityProblemType1State();
}

class _tonalityProblemType1State extends State<tonalityProblemType1> {

  // for admob banner
  BannerAd? _banner;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 새로운 문제 생성

    // for admob banner
    _createBannerAd();

  }

  // admob banner
  void _createBannerAd(){
    _banner = BannerAd(
      size: AdSize.banner
      , adUnitId: AdMobServiceBanner.bannerAdUnitId!
      , listener: AdMobServiceBanner.bannerAdListener
      , request: const AdRequest(),
    )..load();
  }

  bool wrongProblemMode = false ;



  @override
  Widget build(BuildContext context) {


    Map<int, List<dynamic>> problemType1List =
    {
      // 문제번호 / 음표위치 / 정답  [-4,7,10,14]
      1:[[Note.e.sharp.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.c.inOctave(3)]
        ,[100.0,'I','','']
        ,'C'
        ,Note.c.major
      ],
      2:[[Note.c.inOctave(5)
        ,Note.g.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.e.inOctave(3)]
        ,[100.0,'I','6','',]
        ,'C/E'
        ,Note.c.major
      ],
      3:[[Note.e.inOctave(5)
        ,Note.g.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.g.inOctave(3)]
        ,[100.0,'I','4','6',]
        ,'C/G'
        ,Note.c.major],
      4:[[Note.a.inOctave(4)
        ,Note.f.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.d.inOctave(3)]
        ,[100.0,'ii','','',]
        ,'Dm'
        ,Note.c.major],
      5:[[Note.d.inOctave(4)
        ,Note.a.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.f.inOctave(3)]
        ,[100.0,'ii','6','',]
        ,'Dm/F'
        ,Note.c.major],
      6:[[Note.d.inOctave(5)
        ,Note.f.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.a.inOctave(3)]
        ,[100.0,'ii','4','6',]
        ,'Dm/A'
        ,Note.c.major],
      7:[[Note.b.inOctave(4)
        ,Note.g.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.e.inOctave(3)]
        ,[100.0,'iii','','',]
        ,'Em'
        ,Note.c.major],
      8:[[Note.b.inOctave(4)
        ,Note.g.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.g.inOctave(3)]
        ,[100.0,'iii','6','',]
        ,'Em/G'
        ,Note.c.major],
      9:[[Note.b.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.b.inOctave(2)]
        ,[100.0,'iii','4','6',]
        ,'Em/B'
        ,Note.c.major],
      10:[[Note.f.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.f.inOctave(2)]
        ,[100.0,'IV','','',]
        ,'F'
        ,Note.c.major],
      11:[[Note.c.inOctave(4)
        ,Note.f.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.a.inOctave(3)]
        ,[100.0,'IV','6','',]
        ,'F/A'
        ,Note.c.major],
      12:[[Note.f.inOctave(5)
        ,Note.a.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.c.inOctave(3)]
        ,[100.0,'IV','4','6',]
        ,'F/C'
        ,Note.c.major],
      13:[[Note.b.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.g.inOctave(2)]
        ,[100.0,'V','','',]
        ,'G'
        ,Note.c.major],
      14:[[Note.b.inOctave(4)
        ,Note.g.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.inOctave(2)]
        ,[100.0,'V','6','',]
        ,'G/B'
        ,Note.c.major],
      15:[[Note.g.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.d.inOctave(3)]
        ,[100.0,'V','4','6',]
        ,'G/D'
        ,Note.c.major],
      16:[[Note.a.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.e.inOctave(3)
        ,Note.a.inOctave(2)]
        ,[100.0,'vi','','',]
        ,'Am'
        ,Note.c.major],
      17:[[Note.e.inOctave(4)
        ,Note.a.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.c.inOctave(3)]
        ,[100.0,'vi','6','',]
        ,'Am/C'
        ,Note.c.major],
      18:[[Note.c.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.e.inOctave(2)]
        ,[100.0,'vi','4','6',]
        ,'Am/E'
        ,Note.c.major],
      19:[[Note.d.inOctave(4)
        ,Note.f.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.inOctave(2)]
        ,[100.0,'vii','','',]
        ,'Bm(5b)'
        ,Note.c.major],
      20:[[Note.d.inOctave(4)
        ,Note.b.inOctave(4)
        ,Note.f.inOctave(3)
        ,Note.d.inOctave(3)]
        ,[100.0,'vii','6','',]
        ,'Bm(5b)/D'
        ,Note.c.major],
      21:[[Note.d.inOctave(5)
        ,Note.d.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.f.inOctave(3)]
        ,[100.0,'vii','4','6',]
        ,'Bm(5b)/F'
        ,Note.c.major],
      22:[[Note.b.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.g.inOctave(2)]
        ,[100.0,'I','','',]
        ,'G'
        ,Note.g.major],
      23:[[Note.g.inOctave(5)
        ,Note.g.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.inOctave(2)]
        ,[100.0,'I','6','',]
        ,'G/B'
        ,Note.g.major],
      24:[[Note.d.inOctave(5)
        ,Note.g.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.d.inOctave(3)]
        ,[100.0,'I','4','6',]
        ,'G/D'
        ,Note.g.major],
      25:[[Note.a.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.e.inOctave(3)
        ,Note.a.inOctave(2)]
        ,[100.0,'ii','','',]
        ,'Am'
        ,Note.g.major],
      26:[[Note.a.inOctave(5)
        ,Note.a.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.c.inOctave(3)]
        ,[100.0,'ii','6','',]
        ,'Am/C'
        ,Note.g.major],
      27:[[Note.a.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.e.inOctave(2)]
        ,[100.0,'ii','4','6',]
        ,'Am/E'
        ,Note.g.major],
      28:[[Note.b.inOctave(4)
        ,Note.f.sharp.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.inOctave(2)]
        ,[100.0,'iii','','',]
        ,'Bm'
        ,Note.g.major],
      29:[[Note.b.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.f.sharp.inOctave(3)
        ,Note.d.inOctave(3)]
        ,[100.0,'iii','6','',]
        ,'Bm/D'
        ,Note.g.major],
      30:[[Note.b.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.f.sharp.inOctave(2)]
        ,[100.0,'iii','4','6',]
        ,'Bm/F#'
        ,Note.g.major],
      31:[[Note.c.inOctave(5)
        ,Note.g.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.c.inOctave(3)]
        ,[100.0,'IV','','',]
        ,'C'
        ,Note.g.major],
      32:[[Note.c.inOctave(5)
        ,Note.g.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.e.inOctave(3)]
        ,[100.0,'IV','6','',]
        ,'C/E'
        ,Note.g.major],
      33:[[Note.e.inOctave(5)
        ,Note.g.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.g.inOctave(3)]
        ,[100.0,'IV','4','6',]
        ,'C/G'
        ,Note.g.major],
      34:[[Note.d.inOctave(5)
        ,Note.f.sharp.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.d.inOctave(2)]
        ,[100.0,'V','','',]
        ,'D'
        ,Note.g.major],
      35:[[Note.d.inOctave(5)
        ,Note.a.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.f.sharp.inOctave(2)]
        ,[100.0,'V','6','',]
        ,'D/F#'
        ,Note.g.major],
      36:[[Note.d.inOctave(5)
        ,Note.f.sharp.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.a.inOctave(2)]
        ,[100.0,'V','4','6',]
        ,'D/A'
        ,Note.g.major],
      37:[[Note.e.inOctave(5)
        ,Note.g.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.e.inOctave(2)]
        ,[100.0,'vi','','',]
        ,'Em'
        ,Note.g.major],
      38:[[Note.g.inOctave(5)
        ,Note.b.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.g.inOctave(2)]
        ,[100.0,'vi','6','',]
        ,'Em/G'
        ,Note.g.major],
      39:[[Note.e.inOctave(5)
        ,Note.g.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.b.inOctave(2)]
        ,[100.0,'vi','4','6',]
        ,'Em/B'
        ,Note.g.major],
      40:[[Note.a.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.f.sharp.inOctave(2)]
        ,[100.0,'vii','','',]
        ,'F#m(5b)'
        ,Note.g.major],
      41:[[Note.f.sharp.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.a.inOctave(2)]
        ,[100.0,'vii','6','',]
        ,'F#m(5b)/A'
        ,Note.g.major],
      42:[[Note.a.inOctave(4)
        ,Note.c.inOctave(4)
        ,Note.f.sharp.inOctave(3)
        ,Note.c.inOctave(3)]
        ,[100.0,'vii','4','6',]
        ,'F#m(5b)/C'
        ,Note.g.major],
      43:[[Note.f.sharp.inOctave(4)
        ,Note.a.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.d.inOctave(2)]
        ,[100.0,'I','','',]
        ,'D'
        ,Note.d.major],
      44:[[Note.a.inOctave(5)
        ,Note.a.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.f.sharp.inOctave(2)]
        ,[100.0,'I','6','',]
        ,'D/F#'
        ,Note.d.major],
      45:[[Note.a.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.f.sharp.inOctave(3)
        ,Note.a.inOctave(2)]
        ,[100.0,'I','4','6',]
        ,'D/A'
        ,Note.d.major],
      46:[[Note.b.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.e.inOctave(3)]
        ,[100.0,'ii','','',]
        ,'Em'
        ,Note.d.major],
      47:[[Note.e.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.g.inOctave(3)
        ,Note.g.inOctave(2)]
        ,[100.0,'ii','6','',]
        ,'Em/G'
        ,Note.d.major],
      48:[[Note.b.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.b.inOctave(2)]
        ,[100.0,'ii','4','6',]
        ,'Em/B'
        ,Note.d.major],
      49:[[Note.a.inOctave(5)
        ,Note.a.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.f.sharp.inOctave(3)]
        ,[100.0,'iii','','',]
        ,'F#m'
        ,Note.d.major],
      50:[[Note.a.inOctave(4)
        ,Note.f.sharp.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.a.inOctave(3)]
        ,[100.0,'iii','6','',]
        ,'F#m/A'
        ,Note.d.major],
      51:[[Note.f.sharp.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.c.sharp.inOctave(3)]
        ,[100.0,'iii','4','6',]
        ,'F#m/C#'
        ,Note.d.major],
      52:[[Note.d.inOctave(4)
        ,Note.b.inOctave(4)
        ,Note.d.inOctave(3)
        ,Note.g.inOctave(2)]
        ,[100.0,'IV','','',]
        ,'G'
        ,Note.d.major],
      53:[[Note.g.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.g.inOctave(3)
        ,Note.b.inOctave(2)]
        ,[100.0,'IV','6','',]
        ,'G/B'
        ,Note.d.major],
      54:[[Note.b.inOctave(4)
        ,Note.g.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.d.inOctave(3)]
        ,[100.0,'IV','4','6',]
        ,'G/D'
        ,Note.d.major],
      55:[[Note.a.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.e.inOctave(3)
        ,Note.a.inOctave(2)]
        ,[100.0,'V','','',]
        ,'A'
        ,Note.d.major],
      56:[[Note.a.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.c.sharp.inOctave(3)]
        ,[100.0,'V','6','',]
        ,'A/C#'
        ,Note.d.major],
      57:[[Note.a.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.e.inOctave(3)
        ,Note.e.inOctave(2)]
        ,[100.0,'V','4','6',]
        ,'A/E'
        ,Note.d.major],
      58:[[Note.b.inOctave(4)
        ,Note.f.sharp.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.inOctave(3)]
        ,[100.0,'vi','','',]
        ,'Bm'
        ,Note.d.major],
      59:[[Note.d.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.f.sharp.inOctave(3)
        ,Note.d.inOctave(3)]
        ,[100.0,'vi','6','',]
        ,'Bm/D'
        ,Note.d.major],
      60:[[Note.b.inOctave(5)
        ,Note.b.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.f.sharp.inOctave(3)]
        ,[100.0,'vi','4','6',]
        ,'Bm/F#'
        ,Note.d.major],
      61:[[Note.e.inOctave(4)
        ,Note.g.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.c.sharp.inOctave(3)]
        ,[100.0,'vii','','',]
        ,'C#m(5b)'
        ,Note.d.major],
      62:[[Note.g.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.e.inOctave(3)
        ,Note.e.inOctave(2)]
        ,[100.0,'vii','6','',]
        ,'C#m(5b)/E'
        ,Note.d.major],
      63:[[Note.e.inOctave(5)
        ,Note.c.sharp.inOctave(5)
        ,Note.e.inOctave(4)
        ,Note.g.inOctave(3)]
        ,[100.0,'vii','4','6',]
        ,'C#m(5b)/G'
        ,Note.d.major],
      64:[[Note.c.sharp.inOctave(4)
        ,Note.a.inOctave(4)
        ,Note.e.inOctave(3)
        ,Note.a.inOctave(2)]
        ,[100.0,'I','','',]
        ,'A'
        ,Note.a.major],
      65:[[Note.e.inOctave(4)
        ,Note.a.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.c.sharp.inOctave(3)]
        ,[100.0,'I','6','',]
        ,'A/C#'
        ,Note.a.major],
      66:[[Note.c.sharp.inOctave(4)
        ,Note.a.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.e.inOctave(2)]
        ,[100.0,'I','4','6',]
        ,'A/E'
        ,Note.a.major],
      67:[[Note.d.inOctave(4)
        ,Note.b.inOctave(4)
        ,Note.f.sharp.inOctave(3)
        ,Note.b.inOctave(2)]
        ,[100.0,'ii','','',]
        ,'Bm'
        ,Note.a.major],
      68:[[Note.d.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.f.sharp.inOctave(3)
        ,Note.d.inOctave(2)]
        ,[100.0,'ii','6','',]
        ,'Bm/D'
        ,Note.a.major],
      69:[[Note.d.inOctave(4)
        ,Note.b.inOctave(4)
        ,Note.f.sharp.inOctave(3)
        ,Note.f.sharp.inOctave(2)]
        ,[100.0,'ii','4','6',]
        ,'Bm/F#'
        ,Note.a.major],
      70:[[Note.c.sharp.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.g.sharp.inOctave(3)
        ,Note.c.sharp.inOctave(3)]
        ,[100.0,'iii','','',]
        ,'C#m'
        ,Note.a.major],
      71:[[Note.g.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.c.sharp.inOctave(3)
        ,Note.e.inOctave(3)]
        ,[100.0,'iii','6','',]
        ,'C#m/E'
        ,Note.a.major],
      72:[[Note.c.sharp.inOctave(5)
        ,Note.e.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.g.sharp.inOctave(2)]
        ,[100.0,'iii','4','6',]
        ,'C#m/G'
        ,Note.a.major],
      73:[[Note.f.sharp.inOctave(4)
        ,Note.a.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.d.inOctave(3)]
        ,[100.0,'IV','','',]
        ,'D'
        ,Note.a.major],
      74:[[Note.d.inOctave(5)
        ,Note.a.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.f.sharp.inOctave(3)]
        ,[100.0,'IV','6','',]
        ,'D/F#'
        ,Note.a.major],
      75:[[Note.f.sharp.inOctave(4)
        ,Note.a.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.a.inOctave(3)]
        ,[100.0,'IV','4','6',]
        ,'D/A'
        ,Note.a.major],
      76:[[Note.e.inOctave(4)
        ,Note.g.sharp.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.e.inOctave(2)]
        ,[100.0,'V','','',]
        ,'E'
        ,Note.a.major],
      77:[[Note.e.inOctave(5)
        ,Note.b.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.g.sharp.inOctave(2)]
        ,[100.0,'V','6','',]
        ,'E/G#'
        ,Note.a.major],
      78:[[Note.g.sharp.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.e.inOctave(3)
        ,Note.b.inOctave(2)]
        ,[100.0,'V','4','6',]
        ,'E/B'
        ,Note.a.major],
      79:[[Note.c.sharp.inOctave(5)
        ,Note.a.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.f.sharp.inOctave(2)]
        ,[100.0,'vi','','',]
        ,'F#m'
        ,Note.a.major],
      80:[[Note.f.sharp.inOctave(5)
        ,Note.a.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.a.inOctave(2)]
        ,[100.0,'vi','6','',]
        ,'F#m/A'
        ,Note.a.major],
      81:[[Note.f.sharp.inOctave(5)
        ,Note.a.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.c.sharp.inOctave(3)]
        ,[100.0,'vi','4','6',]
        ,'F#m/C#'
        ,Note.a.major],
      82:[[Note.b.inOctave(5)
        ,Note.b.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.g.sharp.inOctave(2)]
        ,[100.0,'vii','','',]
        ,'G#m(5b)'
        ,Note.a.major],
      83:[[Note.b.inOctave(4)
        ,Note.g.sharp.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.b.inOctave(2)]
        ,[100.0,'vii','6','',]
        ,'G#m(5b)/B'
        ,Note.a.major],
      84:[[Note.g.sharp.inOctave(5)
        ,Note.b.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.d.inOctave(3)]
        ,[100.0,'vii','4','6',]
        ,'G#m(5b)/D'
        ,Note.a.major],
      85:[[Note.e.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.g.sharp.inOctave(3)
        ,Note.e.inOctave(3)]
        ,[100.0,'I','','',]
        ,'E'
        ,Note.e.major],
      86:[[Note.e.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.b.inOctave(3)
        ,Note.g.sharp.inOctave(3)]
        ,[100.0,'I','6','',]
        ,'E/G#'
        ,Note.e.major],
      87:[[Note.e.inOctave(5)
        ,Note.g.sharp.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.b.inOctave(3)]
        ,[100.0,'I','4','6',]
        ,'E/B'
        ,Note.e.major],
      88:[[Note.c.sharp.inOctave(5)
        ,Note.f.sharp.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.f.sharp.inOctave(3)]
        ,[100.0,'ii','','',]
        ,'F#m'
        ,Note.e.major],
      89:[[Note.c.sharp.inOctave(5)
        ,Note.f.sharp.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.a.inOctave(2)]
        ,[100.0,'ii','6','',]
        ,'F#m/A'
        ,Note.e.major],
      90:[[Note.f.sharp.inOctave(5)
        ,Note.a.inOctave(4)
        ,Note.a.inOctave(3)
        ,Note.c.sharp.inOctave(3)]
        ,[100.0,'ii','4','6',]
        ,'F#m/C'
        ,Note.e.major],
      91:[[Note.b.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.g.sharp.inOctave(3)
        ,Note.g.sharp.inOctave(2)]
        ,[100.0,'iii','','',]
        ,'G#m'
        ,Note.e.major],
      92:[[Note.b.inOctave(4)
        ,Note.d.inOctave(4)
        ,Note.g.sharp.inOctave(3)
        ,Note.b.inOctave(2)]
        ,[100.0,'iii','6','',]
        ,'G#m/B'
        ,Note.e.major],
      93:[[Note.b.inOctave(4)
        ,Note.g.sharp.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.d.inOctave(2)]
        ,[100.0,'iii','4','6',]
        ,'G#m/D'
        ,Note.e.major],
      94:[[Note.e.inOctave(4)
        ,Note.a.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.a.inOctave(2)]
        ,[100.0,'IV','','',]
        ,'A'
        ,Note.e.major],
      95:[[Note.e.inOctave(5)
        ,Note.a.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.c.sharp.inOctave(3)]
        ,[100.0,'IV','6','',]
        ,'A/C#'
        ,Note.e.major],
      96:[[Note.e.inOctave(4)
        ,Note.a.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.e.inOctave(2)]
        ,[100.0,'IV','4','6',]
        ,'A/E'
        ,Note.e.major],
      97:[[Note.f.sharp.inOctave(4)
        ,Note.b.inOctave(4)
        ,Note.d.sharp.inOctave(4)
        ,Note.b.inOctave(2)]
        ,[100.0,'V','','',]
        ,'B'
        ,Note.e.major],
      98:[[Note.f.sharp.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.b.inOctave(3)
        ,Note.d.sharp.inOctave(3)]
        ,[100.0,'V','6','',]
        ,'B/D#'
        ,Note.e.major],
      99:[[Note.f.sharp.inOctave(5)
        ,Note.b.inOctave(4)
        ,Note.d.sharp.inOctave(4)
        ,Note.f.sharp.inOctave(2)]
        ,[100.0,'V','4','6',]
        ,'B/F#'
        ,Note.e.major],
      100:[[Note.g.sharp.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.c.sharp.inOctave(3)]
        ,[100.0,'vi','','',]
        ,'C#m'
        ,Note.e.major],
      101:[[Note.e.inOctave(5)
        ,Note.g.sharp.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.e.inOctave(3)]
        ,[100.0,'vi','6','',]
        ,'C#m/e'
        ,Note.e.major],
      102:[[Note.g.sharp.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.g.sharp.inOctave(3)]
        ,[100.0,'vi','4','6',]
        ,'C#m/G#'
        ,Note.e.major],
      103:[[Note.f.sharp.inOctave(4)
        ,Note.a.inOctave(4)
        ,Note.f.sharp.inOctave(3)
        ,Note.d.sharp.inOctave(3)]
        ,[100.0,'vii','','',]
        ,'D#m(5b)'
        ,Note.e.major],
      104:[[Note.a.inOctave(4)
        ,Note.d.sharp.inOctave(4)
        ,Note.f.sharp.inOctave(3)
        ,Note.f.sharp.inOctave(2)]
        ,[100.0,'vii','6','',]
        ,'D#m(5b)/F#'
        ,Note.e.major],
      105:[[Note.f.sharp.inOctave(4)
        ,Note.a.inOctave(4)
        ,Note.d.sharp.inOctave(4)
        ,Note.a.inOctave(2)]
        ,[100.0,'vii','4','6',]
        ,'D#m(5b)/A'
        ,Note.e.major],
      106:[[Note.b.inOctave(4)
        ,Note.d.sharp.inOctave(4)
        ,Note.f.sharp.inOctave(3)
        ,Note.b.inOctave(2)]
        ,[100.0,'I','','',]
        ,'B'
        ,Note.b.major],
      107:[[Note.b.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.f.sharp.inOctave(3)
        ,Note.d.sharp.inOctave(3)]
        ,[100.0,'I','6','',]
        ,'B/D#'
        ,Note.b.major],
      108:[[Note.b.inOctave(4)
        ,Note.d.sharp.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.f.sharp.inOctave(2)]
        ,[100.0,'I','4','6',]
        ,'B/F#'
        ,Note.b.major],
      109:[[Note.e.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.g.sharp.inOctave(3)
        ,Note.c.sharp.inOctave(3)]
        ,[100.0,'ii','','',]
        ,'C#m'
        ,Note.b.major],
      110:[[Note.g.sharp.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.c.sharp.inOctave(3)
        ,Note.e.inOctave(3)]
        ,[100.0,'ii','6','',]
        ,'C#m/E'
        ,Note.b.major],
      111:[[Note.c.sharp.inOctave(5)
        ,Note.e.inOctave(4)
        ,Note.c.sharp.inOctave(3)
        ,Note.g.sharp.inOctave(3)]
        ,[100.0,'ii','4','6',]
        ,'C#m/G#'
        ,Note.b.major],
      112:[[Note.f.sharp.inOctave(4)
        ,Note.a.sharp.inOctave(4)
        ,Note.f.sharp.inOctave(3)
        ,Note.d.sharp.inOctave(3)]
        ,[100.0,'iii','','',]
        ,'D#m'
        ,Note.b.major],
      113:[[Note.f.sharp.inOctave(4)
        ,Note.d.sharp.inOctave(4)
        ,Note.a.sharp.inOctave(3)
        ,Note.f.sharp.inOctave(3)]
        ,[100.0,'iii','6','',]
        ,'D#m/F#'
        ,Note.b.major],
      114:[[Note.f.sharp.inOctave(4)
        ,Note.d.sharp.inOctave(4)
        ,Note.d.sharp.inOctave(4)
        ,Note.a.sharp.inOctave(2)]
        ,[100.0,'iii','4','6',]
        ,'D#m/A#'
        ,Note.b.major],
      115:[[Note.b.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.g.sharp.inOctave(3)
        ,Note.e.inOctave(3)]
        ,[100.0,'IV','','',]
        ,'E'
        ,Note.b.major],
      116:[[Note.b.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.e.inOctave(3)
        ,Note.g.sharp.inOctave(2)]
        ,[100.0,'IV','6','',]
        ,'E/G#'
        ,Note.b.major],
      117:[[Note.g.sharp.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.b.inOctave(2)]
        ,[100.0,'IV','4','6',]
        ,'E/B'
        ,Note.b.major],
      118:[[Note.c.sharp.inOctave(4)
        ,Note.a.sharp.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.f.sharp.inOctave(3)]
        ,[100.0,'V','','',]
        ,'F#'
        ,Note.b.major],
      119:[[Note.c.sharp.inOctave(5)
        ,Note.c.sharp.inOctave(4)
        ,Note.f.sharp.inOctave(3)
        ,Note.a.sharp.inOctave(2)]
        ,[100.0,'V','6','',]
        ,'F#/A#'
        ,Note.b.major],
      120:[[Note.f.sharp.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.a.sharp.inOctave(3)
        ,Note.c.sharp.inOctave(3)]
        ,[100.0,'V','4','6',]
        ,'F#/C#'
        ,Note.b.major],
      121:[[Note.b.inOctave(5)
        ,Note.b.inOctave(4)
        ,Note.d.sharp.inOctave(4)
        ,Note.g.sharp.inOctave(3)]
        ,[100.0,'vi','','',]
        ,'G#m'
        ,Note.b.major],
      122:[[Note.b.inOctave(4)
        ,Note.d.sharp.inOctave(4)
        ,Note.g.sharp.inOctave(3)
        ,Note.b.inOctave(2)]
        ,[100.0,'vi','6','',]
        ,'G#m/B'
        ,Note.b.major],
      123:[[Note.b.inOctave(4)
        ,Note.b.inOctave(3)
        ,Note.g.sharp.inOctave(3)
        ,Note.d.sharp.inOctave(2)]
        ,[100.0,'vi','4','6',]
        ,'G#m/D#'
        ,Note.b.major],
      124:[[Note.c.sharp.inOctave(5)
        ,Note.e.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.a.sharp.inOctave(3)]
        ,[100.0,'vii','','',]
        ,'A#m(5b)'
        ,Note.b.major],
      125:[[Note.a.sharp.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.c.sharp.inOctave(3)]
        ,[100.0,'vii','6','',]
        ,'A#m(5b)/C#'
        ,Note.b.major],
      126:[[Note.a.sharp.inOctave(4)
        ,Note.e.inOctave(4)
        ,Note.c.sharp.inOctave(4)
        ,Note.e.inOctave(3)]
        ,[100.0,'vii','4','6',]
        ,'A#m(5b)/E'
        ,Note.b.major],

    };

    int problemNumber = 106 ;

    // 4:[[-3,6,14,25],harmonyExpressionFinal(100,'VI','7','2','/','I','1','2'),],
    List<dynamic> problemInfo = problemType1List[problemNumber]!;
    List<dynamic> answerInfo = problemType1List[problemNumber]![1]!;

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

    Widget answerTest ;
    if (answerInfo.length == 8){
      answerTest = harmonyExpressionFinal(
          answerInfo[0]
          ,answerInfo[1]
          ,answerInfo[2]
          ,answerInfo[3]
          ,answerInfo[4]
          ,answerInfo[5]
          ,answerInfo[6]
          ,answerInfo[7]
      );
    } else {
      answerTest = harmonyExpressionFinal(
          answerInfo[0]
          ,answerInfo[1]
          ,answerInfo[2]
          ,answerInfo[3]
      );
    }
    // return Consumer<Counter>(
    //   builder: (context, counter, child) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: wrongProblemMode?
        Text("오답문제",
            style: appBarTitleStyle
        ) :
        Text("연습문제",
          style: appBarTitleStyle,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: appBarIcon,
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 450.h,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Stack(
              children: [
                //////////////////////////////////////////////////
                // 높은 음 자리표
                Positioned(
                  top: (60-26.5).h,
                  bottom: 0.h,
                  left: 10.0.w,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child:Image.asset('assets/treble_clef_ff_cut.png',
                      height: 180.h,
                    ),
                  ),
                ),
                // 위에 오선
                returnLineHarmony(90.0, 26.5, -1, 'long'),
                returnLineHarmony(90.0, 26.5, 0, 'long'),
                returnLineHarmony(90.0, 26.5, 1, 'long'),
                returnLineHarmony(90.0, 26.5, 2, 'long'),
                returnLineHarmony(90.0, 26.5, 3, 'long'),

                // first note
                returnNoteHarmonyFinal(90.5, 13.25, problemInfo[0][0]
                    , [90.0, 26.5, -1], 'high'),
                // seconde note
                returnNoteHarmonyFinal(90.5, 13.25, problemInfo[0][1]
                    , [90.0, 26.5, -1], 'high'),
                //////////////////////////////////////////////////
                // 낮은음 자리표
                Positioned(
                  top: (60+26.5*7+29).h,
                  bottom: 0.h,
                  left: 13.0.w,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child:Image.asset('assets/low1.png',
                      height: 95.h,
                    ),
                  ),
                ),
                // 밑에 오선
                returnLineHarmony(90.0, 26.5, 7, 'long'),
                returnLineHarmony(90.0, 26.5, 8, 'long'),
                returnLineHarmony(90.0, 26.5, 9, 'long'),
                returnLineHarmony(90.0, 26.5, 10, 'long'),
                returnLineHarmony(90.0, 26.5, 11, 'long'),

                // first note
                returnNoteHarmonyFinal(90.5, 13.25, problemInfo[0][2]
                    , [90.0, 26.5, -1], 'low'),
                // seconde note
                returnNoteHarmonyFinal(90.5, 13.25, problemInfo[0][3]
                    , [90.0, 26.5, -1], 'low'),
              ],
            ),
          ),
          // SizedBox(height: 30.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('정답 : '
                ,style: TextStyle(fontSize: 30.sp),
              ),
              answerTest,
            ],
          ),
          const Expanded(child: SizedBox()),

          // admob banner
          Container(
            alignment: Alignment.center,
            width: _banner!.size.width.toDouble(),
            height: _banner!.size.height.toDouble(),
            child: AdWidget(
              ad: _banner!,
            ),
          ),
          SizedBox(height: 30.h,),
        ],
      ),
    );
  }
}
