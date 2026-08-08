import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:harmonypracticereal/core/ads/banner_ad_slot.dart';
import 'package:harmonypracticereal/core/theme/app_colors.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/note_glyphs.dart';

/// 문제 화면 4종의 **껍데기** — 앱바, 진행률, 오선이 놓이는 자리, 배너 광고.
///
/// ## 무엇을 뽑았고 무엇을 남겼나
///
/// 계획서(P3-7 Task 5)는 "네 `build()` 의 최상위 `Column` 이 같은 순서·같은
/// 여백인지 확인하라" 고 했다. **같지 않다.** 실측한 결과는 이렇다.
///
/// ```
///            자식 수  가운데(안내문·구분선) 영역
///   유형 1     13      구분선 · 안내문 · 1.h · 조성 Row · 구분선 · 10.h
///   유형 2     12      구분선 · 안내문 · Row · 구분선 · 높이 10.0 Container
///   유형 3     12      구분선 · 안내문 · Row · 구분선(500.w) · 10.h
///   유형 4     13      구분선 · 10.h · 안내문 · 10.h · SizedBox(500) · 10.h
/// ```
///
/// 가운데는 개수도 여백도 넷이 다 다르다. 그래서 **가운데는 뽑지 않는다** —
/// 여기서 매개변수로 흡수하려 들면 유형마다 켜고 끄는 깃발이 붙고, 그건
/// 정직한 복사본 넷보다 나쁘다.
///
/// 반면 **앞 3개와 뒤 3개는 네 화면이 글자까지 같다.**
///
/// ```
///   앞  lastRidingProgress(...)            ← 진행률 바
///       SizedBox(height: 5.h)
///       Container(425.h, ∞, staffSurface)  ← 오선 자리 (Stack 내용만 다르다)
///   뒤  Expanded(child: SizedBox())
///       BannerAdSlot()
///       SizedBox(height: 30.h)
/// ```
///
/// 앱바도 넷이 같다 — 단 하나, 오답 모드 제목이 유형 1 만 `오답 문제`
/// (띄어쓰기) 이고 나머지 셋은 `오답문제` 다. 껍데기가 제목을 정해 버리면 그
/// 차이가 조용히 사라지므로 [wrongModeTitle] 로 받는다.
/// (`test/ui/quiz_page_behavior_test.dart` 가 유형별로 못 박아 두었다.)
///
/// ## 여백
///
/// 여기 있는 `5.h` · `425.h` · `30.h` 는 전부 유형 1 의 현재 `build()` 에서
/// 그대로 옮겨 온 값이다. 새로 정한 것은 하나도 없다.
/// `test/ui/quiz_layout_snapshot_test.dart` 가 본문 `Column` 의 자식 순서와
/// 여백 나열을 고정한다.
class QuizPageScaffold extends StatelessWidget {
  const QuizPageScaffold({
    super.key,
    required this.stageType,
    required this.wrongProblemMode,
    required this.wrongModeTitle,
    required this.problemNumber,
    required this.wrongProblemsSave,
    required this.problemArea,
    required this.betweenProblemAndAnswer,
    required this.answerArea,
  });

  /// 앱바 제목이자 진행률 바의 색을 가르는 난이도 (`Easy`/`Medium`/`Hard`/…).
  final String stageType;

  /// 오답 다시 풀기 모드인가. 앱바 제목과 진행률 분모를 가른다.
  final bool wrongProblemMode;

  /// 오답 모드일 때 앱바에 적을 제목. 유형 1 은 `오답 문제`, 나머지는 `오답문제`.
  final String wrongModeTitle;

  /// 진행률의 분자. 1 부터 센다.
  final int problemNumber;

  /// 진행률의 분모를 정하는 목록.
  ///
  /// `lastRidingProgress` 가 오답 모드에서 `wrongProblemsSave.length` 를 분모로
  /// 쓰고, 일반 모드에서는 10 을 쓴다. 분모를 여기서 다시 계산하지 않고 이
  /// 목록을 그대로 넘기는 이유는 **계산을 옮기다 틀리지 않기 위해서**다
  /// (오답 모드의 percent 는 소수 첫째 자리로 반올림된다).
  final List<List<dynamic>> wrongProblemsSave;

  /// 오선 자리(425.h · 폭 무한 · staffSurface)에 들어갈 것. 보통 `Stack`.
  ///
  /// 유형마다 그리는 것이 실제로 다르므로 **내용만** 받고 그릇은 여기서 만든다.
  final Widget problemArea;

  /// 오선과 보기 버튼 **사이**에 그대로 끼워 넣을 자식들.
  ///
  /// 안내문·구분선·조성 표시가 여기 온다. 네 유형이 개수도 여백도 달라
  /// (클래스 주석의 표) 껍데기가 손대지 않고 받은 순서 그대로 편다.
  final List<Widget> betweenProblemAndAnswer;

  /// 보기 버튼 영역. 유형 1 은 `Column`, 나머지 셋은 `Row` 다.
  final Widget answerArea;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: wrongProblemMode
            ? Text(wrongModeTitle, style: appBarTitleStyle)
            : Text(stageType, style: appBarTitleStyle),
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
          lastRidingProgress(
            wrongProblemMode,
            problemNumber,
            wrongProblemsSave,
            stageType,
            context,
          ),
          SizedBox(height: 5.h),
          Container(
            height: 425.h,
            width: double.infinity,
            // 다크에서 밝은 '종이' 면. 오선·음표가 검은 잉크 PNG 라서
            // 어두운 면 위에서는 보이지 않는다. 라이트에서는 투명이라
            // 종전과 동일하다.
            decoration: BoxDecoration(color: context.colors.staffSurface),
            child: problemArea,
          ),
          ...betweenProblemAndAnswer,
          answerArea,

          const Expanded(child: SizedBox()),

          // admob banner
          const BannerAdSlot(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
