import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:harmonypracticereal/core/ads/banner_ad_slot.dart';
import 'package:harmonypracticereal/ui/quiz/problem_type1_page.dart';
import 'package:harmonypracticereal/ui/quiz/problem_type2_page.dart';
import 'package:harmonypracticereal/ui/quiz/problem_type3_page.dart';
import 'package:harmonypracticereal/ui/quiz/problem_type4_page.dart';

import 'quiz_page_harness.dart';

/// P3-7 리팩토링 **전** 의 레이아웃을 못 박는 테스트 (계획서 "테스트 전략" 2층).
///
/// 계획서는 위젯 트리 전체를 덤프해 비교하자고 했지만, 780~1017줄짜리 화면의
/// 전체 덤프는 (1) 사람이 읽을 수 없고 (2) 오선·음표처럼 **문제 내용에 따라
/// 달라지는** 부분까지 끌고 들어와 엉뚱하게 깨진다. 늑대가 왔다고 자꾸 우는
/// 스냅샷은 다음 사람이 지운다. 그래서 **본문 최상위 `Column` 의 자식 나열**
/// 하나로 좁혔다.
///
/// 좁혀도 되는 이유: 이 리팩토링에서 실제로 밀릴 수 있는 것은 화면 껍데기의
/// 여백과 순서다 — Task 5 가 `QuizPageScaffold` 로 바로 이 `Column` 을 다시
/// 조립한다. 오선 내부는 각 화면에 그대로 남으므로 이 작업으로 바뀔 이유가
/// 없다.
///
/// **기대값은 "옳은 값" 이 아니라 "2026-08-05 현재 값" 이다.** 기대값을 고치기
/// 전에 반드시 실기기 화면과 대조할 것 — 통과시키려고 숫자를 바꾸는 것이 이
/// 계획에서 가장 위험한 행동이다.
void main() {
  /// 본문 최상위 `Column`.
  ///
  /// "배너 광고 자리를 직접 자식으로 갖는 유일한 `Column`" 으로 찾는다.
  /// 껍데기가 다른 위젯 안으로 들어가 트리 깊이가 바뀌어도 계속 찾힌다.
  Column bodyColumn(WidgetTester tester) {
    final hits = find.byType(Column).evaluate().where((element) {
      final column = element.widget as Column;
      return column.children.any((child) => child is BannerAdSlot);
    }).toList();
    expect(hits, hasLength(1), reason: '배너를 직접 갖는 Column 이 하나여야 한다');
    return hits.single.widget as Column;
  }

  /// 길이 값을 `5.h` 같은 설계 단위로 되돌린다.
  ///
  /// `.h` 는 화면 높이에 비례하므로 실제 값은 `4.739336…` 처럼 나온다.
  /// 그대로 적으면 읽을 수도, 화면 코드와 맞춰 볼 수도 없다. 비례 계수로
  /// 나누어 떨어지지 않으면(= `.h` 를 안 붙인 생짜 숫자면) 그대로 적는다.
  String describeLength(double? value, double scale, String suffix) {
    if (value == null) return 'null';
    if (!value.isFinite) return 'inf';
    final design = (value / scale).roundToDouble();
    if (design * scale == value) return '${design.toStringAsFixed(0)}$suffix';
    return value.toStringAsFixed(1);
  }

  String? heightOf(Widget widget) => switch (widget) {
        SizedBox(height: final h?) =>
          describeLength(h, ScreenUtil().scaleHeight, '.h'),
        Container(constraints: BoxConstraints(maxHeight: final h))
            when h.isFinite =>
          describeLength(h, ScreenUtil().scaleHeight, '.h'),
        _ => null,
      };

  /// 레이아웃에 영향을 주는 값만 한 줄로 적는다.
  String describe(Widget widget) {
    final sh = ScreenUtil().scaleHeight;
    final sw = ScreenUtil().scaleWidth;
    if (widget is SizedBox) {
      return 'SizedBox(w: ${describeLength(widget.width, sw, '.w')}, '
          'h: ${describeLength(widget.height, sh, '.h')})';
    }
    if (widget is Container) {
      final c = widget.constraints;
      if (c == null) return 'Container(제약 없음)';
      return 'Container(w: ${describeLength(c.maxWidth, sw, '.w')}, '
          'h: ${describeLength(c.maxHeight, sh, '.h')})';
    }
    return '${widget.runtimeType}';
  }

  /// [expectedChildren] 은 자식의 **순서**를, [expectedHeights] 는 **여백의
  /// 나열**을 본다. 둘을 나눠 두면 Task 5 에서 어떤 종류의 회귀인지 바로
  /// 갈린다 — 순서만 깨지면 앞의 것이, 여백이 밀리면 둘 다 깨진다.
  void snapshotTest(
    String name,
    Widget Function(StubProblemSource) build,
    List<String> expectedChildren,
    List<String> expectedHeights,
  ) {
    group(name, () {
      testWidgets('본문 Column 의 자식 순서가 그대로다', (tester) async {
        await pumpQuizPage(tester, build(StubProblemSource()));
        expect(bodyColumn(tester).children.map(describe).toList(),
            expectedChildren);
        expect(tester.takeException(), isNull);
      });

      testWidgets('본문 Column 의 여백 나열이 그대로다', (tester) async {
        await pumpQuizPage(tester, build(StubProblemSource()));
        expect(
          bodyColumn(tester).children.map(heightOf).whereType<String>().toList(),
          expectedHeights,
        );
      });
    });
  }

  snapshotTest(
    '유형1',
    (s) => tonalityProblemType1(s.call, 'Easy', problemTypes: const ['3화음']),
    const [
      'Column', // lastRidingProgress (진행률 바)
      'SizedBox(w: null, h: 5.h)',
      'Container(w: inf, h: 425.h)', // 오선 영역
      'SizedBox(w: 500.0, h: 25.0)', // Divider 자리
      'AutoSizeText', // '알맞은 화성을 구하시오'
      'SizedBox(w: null, h: 1.h)',
      'Row', // '조성 : C major'
      'Container(w: 500.0, h: 25.0)', // Divider 자리
      'SizedBox(w: null, h: 10.h)',
      'Column', // 보기 버튼 4개
      'Expanded',
      'BannerAdSlot',
      'SizedBox(w: null, h: 30.h)',
    ],
    const ['5.h', '425.h', '25.0', '1.h', '25.0', '10.h', '30.h'],
  );

  snapshotTest(
    '유형2',
    (s) => tonalityProblemType2(s.call, 'Easy', problemTypes: const ['3화음']),
    const [
      'Column',
      'SizedBox(w: null, h: 5.h)',
      'Container(w: inf, h: 425.h)',
      'Container(w: 500.0, h: inf)', // Divider 자리 (높이 지정 없음)
      'AutoSizeText', // '...에 들어갈 알맞은 음을 고르시오'
      'Row', // '조 : C major' + 제시 화성
      'Container(w: 500.0, h: inf)',
      'Container(w: inf, h: 10.0)',
      'Row', // 보기 버튼 4개
      'Expanded',
      'BannerAdSlot',
      'SizedBox(w: null, h: 30.h)',
    ],
    const ['5.h', '425.h', '10.0', '30.h'],
  );

  snapshotTest(
    '유형3',
    (s) => tonalityProblemType3(s.call, 'Easy', problemTypes: const ['3화음']),
    const [
      'Column',
      'SizedBox(w: null, h: 5.h)',
      'Container(w: inf, h: 425.h)',
      'Container(w: 500.0, h: inf)',
      'AutoSizeText', // '조성을 구하시오'
      'Row', // 제시 화성
      // 유형 3 만 `500.w`(= 480) 다. 나머지 셋은 생짜 `500`.
      'Container(w: 500.w, h: inf)',
      'SizedBox(w: null, h: 10.h)',
      'Row', // 보기 버튼 4개
      'Expanded',
      'BannerAdSlot',
      'SizedBox(w: null, h: 30.h)',
    ],
    const ['5.h', '425.h', '10.h', '30.h'],
  );

  snapshotTest(
    '유형4',
    (s) => tonalityProblemType4(s.call, 'Easy', problemTypes: const ['3화음']),
    const [
      'Column',
      'SizedBox(w: null, h: 5.h)',
      'Container(w: inf, h: 425.h)',
      'Container(w: 500.0, h: inf)',
      'SizedBox(w: null, h: 10.h)',
      'AutoSizeText', // '코드이름을 구하시오'
      'SizedBox(w: null, h: 10.h)',
      'SizedBox(w: 500.0, h: null)',
      'SizedBox(w: null, h: 10.h)',
      'Row', // 보기 버튼 4개
      'Expanded',
      'BannerAdSlot',
      'SizedBox(w: null, h: 30.h)',
    ],
    const ['5.h', '425.h', '10.h', '10.h', '10.h', '30.h'],
  );
}
