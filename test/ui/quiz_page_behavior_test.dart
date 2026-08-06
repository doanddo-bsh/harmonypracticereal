import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:harmonypracticereal/ui/quiz/problem_type1_page.dart';
import 'package:harmonypracticereal/ui/quiz/problem_type2_page.dart';
import 'package:harmonypracticereal/ui/quiz/problem_type3_page.dart';
import 'package:harmonypracticereal/ui/quiz/problem_type4_page.dart';

import 'quiz_page_harness.dart';

/// P3-7 리팩토링 **전** 의 동작을 못 박는 테스트 (계획서 "테스트 전략" 1층).
///
/// 여기 적힌 문구·개수·순서는 "이래야 옳다" 가 아니라 **"지금 이렇다"** 이다.
/// 리팩토링 뒤에도 그대로 통과해야 하고, 깨지면 동작이 바뀐 것이다.
/// 지금 어긋나 있는 것 — 유형 1 만 `오답입니다!` 에 느낌표가 있고 앱바가
/// `오답 문제`(띄어쓰기), 나머지는 `오답입니다` 와 `오답문제` — 도 일부러
/// 그대로 적었다. 껍데기를 합치면서 조용히 통일되면 그것도 동작 변경이다.
void main() {
  // ---------------------------------------------------------------- 공용 도구

  /// 바텀시트 전환(250ms)이 끝날 때까지 민다.
  ///
  /// `pumpAndSettle` 을 쓰지 않는 이유: 결과 화면의 Lottie 애니메이션이
  /// 멈추지 않아 영원히 기다리게 된다.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
  }

  /// 지금 떠 있는 바텀시트가 정답 시트인가.
  bool sheetSaysCorrect() => find.text('정답입니다!').evaluate().isNotEmpty;

  /// 보기 4개 중 [text] 를 품지 **않은** 첫 버튼.
  Finder optionWithout(String text) {
    final buttons = answerButtons();
    for (var i = 0; i < buttons.evaluate().length; i++) {
      final button = buttons.at(i);
      if (find.descendant(of: button, matching: find.text(text)).evaluate().isEmpty) {
        return button;
      }
    }
    fail('보기 4개가 모두 "$text" 를 품고 있다');
  }

  /// 보기 4개 중 [text] 를 품은 버튼.
  Finder optionWith(String text) => find
      .ancestor(of: find.text(text), matching: find.byType(ElevatedButton))
      .first;

  /// 시트에 적힌 `정답 : ...` 에서 정답 부분만 떼어 낸다.
  String answerShownInSheet() {
    final found = find.textContaining('정답 : ').evaluate();
    expect(found, hasLength(1));
    return (found.single.widget as Text).data!.substring('정답 : '.length);
  }

  // ------------------------------------------------------- 유형별 화면 만들기

  /// 유형별로 (화면 만들기, 정답 라벨, 오답 문구, 오답 모드 앱바 제목).
  ///
  /// `correctLabel` 은 대역의 몇 번째 호출이 지금 문제인지를 받아 정답
  /// 보기에 적힌 문자열을 돌려준다.
  ///
  /// 유형 2 만은 정답이 화면 안의 `problem[Random().nextInt(4)]` 라 대역으로
  /// 못 박히지 않아 오랫동안 null 이었고, 그래서 "정답/오답을 골라서" 하는
  /// 검사 다섯 개가 통째로 건너뛰어졌다. B6 — 오답 복습 2번째 문제에서 죽던
  /// TypeError — 가 정확히 그 구멍에 살았다. 지금은 [type2AnswerLabel] 이
  /// 화면이 스스로 내건 성부 안내 문구에서 `intValue` 를 되찾아 정답을
  /// 계산하므로, 유형 2 도 나머지와 같은 검사를 받는다.
  ///
  /// 유형 2 의 값은 **호출 시점의 화면**을 읽는다. 시트가 닫혀 있고 문제가
  /// 떠 있을 때 불러야 한다 — 아래 쓰임새는 모두 그렇다.
  final types = <String, ({
    Widget Function(StubProblemSource) build,
    String Function(int call)? correctLabel,
    String wrongHeadline,
    String wrongModeAppBarTitle,
    bool wrongModeStartCrashes,
  })>{
    '유형1': (
      build: (s) =>
          tonalityProblemType1(s.call, 'Easy', problemTypes: const ['3화음']),
      correctLabel: StubProblemSource.markerFor,
      wrongHeadline: '오답입니다!',
      wrongModeAppBarTitle: '오답 문제',
      wrongModeStartCrashes: false,
    ),
    '유형2': (
      build: (s) =>
          tonalityProblemType2(s.call, 'Easy', problemTypes: const ['3화음']),
      correctLabel: type2AnswerLabel,
      wrongHeadline: '오답입니다',
      wrongModeAppBarTitle: '오답문제',
      wrongModeStartCrashes: false,
    ),
    '유형3': (
      build: (s) =>
          tonalityProblemType3(s.call, 'Easy', problemTypes: const ['3화음']),
      correctLabel: StubProblemSource.keyLabelFor,
      wrongHeadline: '오답입니다',
      wrongModeAppBarTitle: '오답문제',
      wrongModeStartCrashes: false,
    ),
    '유형4': (
      build: (s) =>
          tonalityProblemType4(s.call, 'Easy', problemTypes: const ['3화음']),
      correctLabel: StubProblemSource.chordCodeFor,
      wrongHeadline: '오답입니다',
      wrongModeAppBarTitle: '오답문제',
      wrongModeStartCrashes: false,
    ),
  };

  types.forEach((name, type) {
    group(name, () {
      // ------------------------------------------------------- 첫 화면

      testWidgets('예외 없이 렌더되고, 진행률·앱바·보기 개수가 지금과 같다', (tester) async {
        await pumpQuizPage(tester, type.build(StubProblemSource()));

        expect(tester.takeException(), isNull);
        // 진행률은 0/10 이 아니라 1/10 에서 시작한다 (problemNumber = 1).
        expect(find.text('1/10'), findsOneWidget);
        expect(find.text('Easy'), findsOneWidget);
        expect(answerButtons(), findsNWidgets(4));
      });

      // ------------------------------------------- 보기 탭 → 시트 → 다음문제

      testWidgets('보기를 누르면 바텀시트가 뜨고, 다음문제로 진행률이 1 오른다', (tester) async {
        await pumpQuizPage(tester, type.build(StubProblemSource()));

        await tester.tap(answerButtons().first);
        await settle(tester);

        // 정답이든 오답이든 시트는 뜨고, 두 문구 중 정확히 하나만 나온다.
        expect(
          sheetSaysCorrect() ^
              find.text(type.wrongHeadline).evaluate().isNotEmpty,
          isTrue,
          reason: '정답 문구와 오답 문구 중 정확히 하나만 떠야 한다',
        );
        expect(find.textContaining('정답 : '), findsOneWidget);
        expect(find.text('다음문제'), findsOneWidget);

        await tester.tap(find.text('다음문제'));
        await settle(tester);

        expect(find.text('2/10'), findsOneWidget);
        expect(find.text('다음문제'), findsNothing);
        expect(answerButtons(), findsNWidgets(4));
        expect(tester.takeException(), isNull);
      });

      // ------------------------------------------------ 10문제 완주 → 결과

      testWidgets('10문제를 풀면 결과 화면이 뜨고 점수가 맞은 개수와 일치한다', (tester) async {
        await pumpQuizPage(tester, type.build(StubProblemSource()));

        var rightCount = 0;
        for (var i = 1; i <= 10; i++) {
          expect(find.text('$i/10'), findsOneWidget, reason: '$i번째 문제');

          await tester.tap(answerButtons().first);
          await settle(tester);
          if (sheetSaysCorrect()) rightCount++;

          if (i < 10) {
            await tester.tap(find.text('다음문제'));
          } else {
            // 10번째에는 '다음문제' 대신 '결과보기' 가 나온다.
            expect(find.text('다음문제'), findsNothing);
            await tester.tap(find.text('결과보기'));
          }
          await settle(tester);
        }

        expect(find.text('CLEAR'), findsOneWidget);
        expect(find.text('${rightCount * 10}점'), findsOneWidget);
        expect(find.text('($rightCount/10)'), findsOneWidget);
        expect(find.text('계속해서 문제를 푸시겠습니까?'), findsOneWidget);

        // 오답이 하나라도 있어야 '틀린 문제 다시 풀기' 가 살아난다.
        final retry = tester.widget<ElevatedButton>(
          find
              .ancestor(
                of: find.text('틀린 문제 다시 풀기'),
                matching: find.byType(ElevatedButton),
              )
              .first,
        );
        expect(retry.onPressed != null, rightCount < 10,
            reason: '오답 ${10 - rightCount}개');
        expect(tester.takeException(), isNull);
      });

      testWidgets("결과 화면에서 '네'를 누르면 새 스테이지가 1/10 부터 시작한다", (tester) async {
        await pumpQuizPage(tester, type.build(StubProblemSource()));

        for (var i = 1; i <= 10; i++) {
          await tester.tap(answerButtons().first);
          await settle(tester);
          await tester.tap(find.text(i < 10 ? '다음문제' : '결과보기'));
          await settle(tester);
        }
        expect(find.text('CLEAR'), findsOneWidget);

        await tester.tap(find.text('네'));
        await settle(tester);

        expect(find.text('CLEAR'), findsNothing);
        expect(find.text('1/10'), findsOneWidget);
        expect(find.text('Easy'), findsOneWidget);
        expect(answerButtons(), findsNWidgets(4));
        expect(tester.takeException(), isNull);
      });

      // ------------------------------- 정답을 미리 아는 유형(1·3·4)만 하는 것

      final correctLabel = type.correctLabel;
      if (correctLabel == null) return;

      testWidgets('정답 보기를 누르면 정답 시트가 뜬다', (tester) async {
        await pumpQuizPage(tester, type.build(StubProblemSource()));
        await tester.tap(optionWith(correctLabel(0)));
        await settle(tester);

        expect(find.text('정답입니다!'), findsOneWidget);
        expect(find.text(type.wrongHeadline), findsNothing);
        expect(find.textContaining('정답 : '), findsOneWidget);
      });

      testWidgets('오답 보기를 누르면 오답 시트가 뜬다', (tester) async {
        await pumpQuizPage(tester, type.build(StubProblemSource()));
        await tester.tap(optionWithout(correctLabel(0)));
        await settle(tester);

        expect(find.text(type.wrongHeadline), findsOneWidget);
        expect(find.text('정답입니다!'), findsNothing);
        expect(find.textContaining('정답 : '), findsOneWidget);
      });

      testWidgets('10문제를 전부 맞히면 100점이고 오답 다시 풀기가 잠긴다', (tester) async {
        final stub = StubProblemSource();
        await pumpQuizPage(tester, type.build(stub));

        // 지금 화면에 떠 있는 문제를 낸 대역 호출 번호. 첫 문제는 0번이고,
        // 그 뒤로는 '다음문제' 를 누르기 직전의 호출 수와 같다 (화면이
        // 다음 문제를 뽑을 때 대역을 가장 먼저 호출하기 때문).
        var call = 0;
        for (var i = 1; i <= 10; i++) {
          await tester.tap(optionWith(correctLabel(call)));
          await settle(tester);
          expect(find.text('정답입니다!'), findsOneWidget, reason: '$i번째');

          call = stub.callCount;
          await tester.tap(find.text(i < 10 ? '다음문제' : '결과보기'));
          await settle(tester);
        }

        expect(find.text('100점'), findsOneWidget);
        expect(find.text('(10/10)'), findsOneWidget);

        final retry = tester.widget<ElevatedButton>(
          find
              .ancestor(
                of: find.text('틀린 문제 다시 풀기'),
                matching: find.byType(ElevatedButton),
              )
              .first,
        );
        expect(retry.onPressed, isNull, reason: '오답이 없으면 비활성이어야 한다');
        expect(tester.takeException(), isNull);
      });

      testWidgets('10문제를 전부 틀리면 0점이고, 오답 모드로 다시 들어간다', (tester) async {
        final stub = StubProblemSource();
        await pumpQuizPage(tester, type.build(stub));

        var call = 0;
        for (var i = 1; i <= 10; i++) {
          await tester.tap(optionWithout(correctLabel(call)));
          await settle(tester);
          expect(find.text(type.wrongHeadline), findsOneWidget, reason: '$i번째');

          call = stub.callCount;
          await tester.tap(find.text(i < 10 ? '다음문제' : '결과보기'));
          await settle(tester);
        }

        expect(find.text('0점'), findsOneWidget);
        expect(find.text('(0/10)'), findsOneWidget);

        // 오답 모드 진입이 죽는 유형이 있으면 여기서 멈춘다. 지금은 네 유형
        // 모두 false 다 (유형 4 의 B5 가 고쳐진 뒤로).
        if (type.wrongModeStartCrashes) return;

        await tester.tap(find.text('틀린 문제 다시 풀기'));
        await settle(tester);

        // 오답 모드: 앱바 제목이 바뀌고, 진행률 분모가 오답 개수(10)가 된다.
        expect(find.text(type.wrongModeAppBarTitle), findsOneWidget);
        expect(find.text('Easy'), findsNothing);
        expect(find.text('1/10'), findsOneWidget);
        expect(answerButtons(), findsNWidgets(4));
        expect(tester.takeException(), isNull);
      });

      if (type.wrongModeStartCrashes) return;

      testWidgets('오답 모드에서 10문제를 다시 전부 맞히면 100점이 된다', (tester) async {
        final stub = StubProblemSource();
        await pumpQuizPage(tester, type.build(stub));

        // 1) 10문제를 전부 틀린다. 각 문제를 낸 호출 번호를 적어 둔다.
        final calls = <int>[0];
        var call = 0;
        for (var i = 1; i <= 10; i++) {
          await tester.tap(optionWithout(correctLabel(call)));
          await settle(tester);
          call = stub.callCount;
          if (i < 10) calls.add(call);
          await tester.tap(find.text(i < 10 ? '다음문제' : '결과보기'));
          await settle(tester);
        }
        await tester.tap(find.text('틀린 문제 다시 풀기'));
        await settle(tester);

        // 2) 오답 모드에서는 저장해 둔 문제가 순서대로 다시 나온다.
        for (var i = 1; i <= 10; i++) {
          expect(find.text('$i/10'), findsOneWidget, reason: '오답모드 $i번째');
          await tester.tap(optionWith(correctLabel(calls[i - 1])));
          await settle(tester);
          expect(find.text('정답입니다!'), findsOneWidget, reason: '오답모드 $i번째');
          await tester.tap(find.text(i < 10 ? '다음문제' : '결과보기'));
          await settle(tester);
        }

        // 오답 모드의 점수 분모는 10 이 아니라 오답 개수다(여기서는 마침 10).
        expect(find.text('100점'), findsOneWidget);
        expect(find.text('(10/10)'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });

  // ------------------------------------------------- 유형 2 의 판정 일관성

  group('유형2', () {
    testWidgets('시트가 알려주는 정답과 판정이 서로 어긋나지 않는다', (tester) async {
      // 유형 2 의 정답은 `problem[Random().nextInt(4)]` 라 대역으로 못 박을 수
      // 없다. 대신 "시트에 적힌 정답" 과 "누른 보기" 가 같을 때만 정답
      // 판정이 나오는지를 본다. 비교 로직이 망가지면 이게 깨진다.
      await pumpQuizPage(
        tester,
        tonalityProblemType2(StubProblemSource().call, 'Easy',
            problemTypes: const ['3화음']),
      );

      for (var i = 1; i <= 5; i++) {
        final tapped = tester
            .widget<Text>(find.descendant(
              of: answerButtons().first,
              matching: find.byType(Text),
            ))
            .data!;

        await tester.tap(answerButtons().first);
        await settle(tester);

        expect(
          sheetSaysCorrect(),
          tapped == answerShownInSheet(),
          reason: '$i번째: 누른 값 "$tapped", 시트가 말한 정답 "${answerShownInSheet()}"',
        );

        await tester.tap(find.text('다음문제'));
        await settle(tester);
      }
    });
  });
}
