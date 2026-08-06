import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:harmonypracticereal/core/theme/app_colors.dart';
import 'package:harmonypracticereal/core/theme/app_theme.dart';
import 'package:harmonypracticereal/ui/quiz/widgets/answer_result_sheet.dart';

/// P3-7 Task 2 — 네 화면에 복제돼 있던 정답/오답 바텀시트의 **껍데기**만 뽑은
/// `AnswerResultSheet` 를 고정한다.
///
/// 여기 적힌 값(185.h / 25.h / 3.h / 7.h, 모서리 15, 글자 20·굵게)은 "이래야
/// 옳다" 가 아니라 **2026-08-06 현재 네 화면이 실제로 그리던 값**이다.
///
/// 문구를 시트가 정하지 않고 **받는다**는 점이 중요하다. 유형 1 만 오답 문구가
/// `오답입니다!`(느낌표) 이고 나머지 셋은 `오답입니다` 다. 시트가 문구를
/// 결정하면 그 차이가 조용히 사라지고, 그건 사용자에게 보이는 변경이다.
void main() {
  /// 시트를 띄운다. 화면 크기를 못 박는 이유는 `quiz_page_harness.dart` 와
  /// 같다 — `.h` 값이 화면 높이에 비례하기 때문이다.
  Future<void> pumpSheet(
    WidgetTester tester, {
    required bool isCorrect,
    required String headline,
    required Widget answer,
    required Widget action,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 844),
        builder: (context, child) => MaterialApp(
          theme: AppTheme.light,
          home: child,
        ),
        child: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showAnswerResultSheet(
                  context: context,
                  isCorrect: isCorrect,
                  headline: headline,
                  answer: answer,
                  action: action,
                ),
                child: const Text('열기'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('열기'));
    // 시트 전환(250ms)을 넘긴다. `pumpAndSettle` 을 피하는 이유는
    // `quiz_page_behavior_test.dart` 와 같다.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  AppColors colorsOf(WidgetTester tester) =>
      tester.element(find.byType(AnswerResultSheet)).colors;

  Color headlineColor(WidgetTester tester, String headline) =>
      tester.widget<Text>(find.text(headline)).style!.color!;

  group('정답 시트', () {
    testWidgets('정답 배경색·정답 글자색으로 받은 문구를 그린다', (tester) async {
      await pumpSheet(
        tester,
        isCorrect: true,
        headline: '정답입니다!',
        answer: const Text('정답 : C'),
        action: const Text('다음문제'),
      );

      final colors = colorsOf(tester);
      expect(
        tester.widget<BottomSheet>(find.byType(BottomSheet)).backgroundColor,
        colors.correctSheetBackground,
      );
      expect(find.text('정답입니다!'), findsOneWidget);
      expect(headlineColor(tester, '정답입니다!'), colors.correctText);
      expect(find.text('정답 : C'), findsOneWidget);
      expect(find.text('다음문제'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('오답 시트', () {
    testWidgets('오답 배경색·오답 글자색으로 받은 문구를 그린다', (tester) async {
      await pumpSheet(
        tester,
        isCorrect: false,
        headline: '오답입니다',
        answer: const Text('정답 : C'),
        action: const Text('다음문제'),
      );

      final colors = colorsOf(tester);
      expect(
        tester.widget<BottomSheet>(find.byType(BottomSheet)).backgroundColor,
        colors.wrongSheetBackground,
      );
      expect(headlineColor(tester, '오답입니다'), colors.wrongText);
      expect(tester.takeException(), isNull);
    });

    testWidgets('문구는 시트가 정하지 않고 받는다 — 유형 1 의 느낌표가 살아남는다', (tester) async {
      await pumpSheet(
        tester,
        isCorrect: false,
        headline: '오답입니다!',
        answer: const SizedBox.shrink(),
        action: const SizedBox.shrink(),
      );

      expect(find.text('오답입니다!'), findsOneWidget);
      expect(find.text('오답입니다'), findsNothing);
    });
  });

  group('시트 뼈대', () {
    testWidgets('바깥 높이 185.h, 자식 나열과 여백이 종전과 같다', (tester) async {
      await pumpSheet(
        tester,
        isCorrect: true,
        headline: '정답입니다!',
        answer: const Text('정답 : C'),
        action: const Text('다음문제'),
      );

      final box = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(AnswerResultSheet),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(box.height, 185.h);
      expect(box.width, double.infinity);

      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(AnswerResultSheet),
          matching: find.byType(Column),
        ),
      );
      expect(column.mainAxisAlignment, MainAxisAlignment.start);
      expect(column.mainAxisSize, MainAxisSize.min);
      expect(
        column.children.map((w) => w is SizedBox ? w.height : null).toList(),
        [25.h, null, 3.h, null, 7.h, null],
        reason: '여백 25/3/7 사이에 문구·정답·버튼이 하나씩 들어간다',
      );
      // 문구는 시트가 만들고, 정답 표시와 버튼은 받은 위젯을 그대로 놓는다.
      expect((column.children[1] as Text).data, '정답입니다!');
      expect((column.children[3] as Text).data, '정답 : C');
      expect((column.children[5] as Text).data, '다음문제');
    });

    testWidgets('문구는 20 크기 굵은 글씨다', (tester) async {
      await pumpSheet(
        tester,
        isCorrect: true,
        headline: '정답입니다!',
        answer: const SizedBox.shrink(),
        action: const SizedBox.shrink(),
      );

      final style = tester.widget<Text>(find.text('정답입니다!')).style!;
      expect(style.fontSize, 20);
      expect(style.fontWeight, FontWeight.bold);
    });

    testWidgets('위쪽 모서리만 15 로 둥글고, 드래그·바깥 탭으로 닫히지 않는다', (tester) async {
      await pumpSheet(
        tester,
        isCorrect: true,
        headline: '정답입니다!',
        answer: const SizedBox.shrink(),
        action: const SizedBox.shrink(),
      );

      final sheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(
        sheet.shape,
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
      );
      expect(sheet.enableDrag, isFalse);

      // 바깥을 눌러도 닫히지 않는다(isDismissible: false).
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(AnswerResultSheet), findsOneWidget);
    });
  });
}
