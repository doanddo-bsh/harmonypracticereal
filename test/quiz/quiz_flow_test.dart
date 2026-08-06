import 'package:flutter_test/flutter_test.dart';

import 'package:harmonypracticereal/core/ads/interstitial_trigger.dart';
import 'package:harmonypracticereal/domain/quiz/quiz_flow.dart';

/// `QuizFlow` 는 문제 화면 4종이 똑같이 복제해 갖고 있던 풀이 세션 상태기계다.
///
/// 여기 적힌 것은 "이래야 옳다" 가 아니라 **"화면 4개가 지금 하고 있는 것"** 이다.
/// 옮기기 전 네 파일의 `nextProblem` / `wrongProblemNextProblem` / `showResult` /
/// `nextProblemResult` / `wrongProblemSolveStart` 를 나란히 놓고 확인했고, 상태
/// 전이 부분은 네 파일이 글자까지 같았다 (다른 것은 "문제를 화면에 적용하는"
/// 유형별 블록뿐).
void main() {
  /// 오답 목록에 넣는 한 칸. 실제 화면은
  /// `[answer, problem, condition, problemOriginal, problemName]` 를 넣는다
  /// (유형 2 만 `intValue` 가 하나 더 붙는다). 상태기계는 내용을 보지 않으므로
  /// 테스트에서는 알아보기 쉬운 꼬리표 하나면 된다.
  List<dynamic> record(String tag) => <dynamic>[tag];

  group('초기 상태', () {
    test('푼 문제 0, 오답 없음, 일반 모드, 1번 문제', () {
      final flow = QuizFlow();

      expect(flow.numberOfRight, 0);
      expect(flow.wrongProblems, isEmpty);
      expect(flow.wrongProblemsSave, isEmpty);
      expect(flow.wrongProblemMode, isFalse);
      expect(flow.problemNumber, 1);
      expect(flow.hasNextProblem, isTrue);
      expect(flow.canStartWrongProblemRound, isFalse);
    });
  });

  group('일반 모드', () {
    test('정답이면 맞은 개수만 오르고 오답 목록은 그대로다', () {
      final flow = QuizFlow()..recordCorrect();

      expect(flow.numberOfRight, 1);
      expect(flow.wrongProblems, isEmpty);
      // 채점은 문제 번호를 건드리지 않는다 — 번호는 '다음문제' 가 올린다.
      expect(flow.problemNumber, 1);
    });

    test('오답이면 맞은 개수는 그대로고 오답 목록이 하나 는다', () {
      final flow = QuizFlow()..recordWrong(record('A'));

      expect(flow.numberOfRight, 0);
      expect(flow.wrongProblems, [
        ['A']
      ]);
      expect(flow.canStartWrongProblemRound, isTrue);
    });

    test("'다음문제' 는 번호를 1 올린다", () {
      final flow = QuizFlow()..advanceToNextProblem();

      expect(flow.problemNumber, 2);
    });

    test('9번까지는 다음 문제가 있고, 10번에서 없다', () {
      final flow = QuizFlow();

      for (var i = 1; i <= 9; i++) {
        expect(flow.problemNumber, i);
        expect(flow.hasNextProblem, isTrue, reason: '$i번 문제');
        flow.advanceToNextProblem();
      }

      expect(flow.problemNumber, 10);
      expect(flow.hasNextProblem, isFalse, reason: '10번에서는 결과 화면으로 간다');
    });

    test('10번에서 다시 진행하면 1번으로 돌아간다', () {
      // 지금 화면 코드의 `if (problemNumber == 10) problemNumber = 0;` 를 옮긴
      // 것이다. 실제로는 10번에서 '다음문제' 대신 '결과보기' 가 나오므로 닿지
      // 않는 길이지만, 옮기면서 없애지 않았다.
      final flow = QuizFlow();
      for (var i = 1; i <= 9; i++) {
        flow.advanceToNextProblem();
      }
      expect(flow.problemNumber, 10);

      flow.advanceToNextProblem();
      expect(flow.problemNumber, 1);
    });
  });

  group('오답 다시 풀기 시작', () {
    test('오답이 없으면 시작할 수 없다', () {
      expect(QuizFlow().canStartWrongProblemRound, isFalse);
    });

    test('오답 모드로 바뀌고 카운터가 초기화되며 오답 목록이 출제 목록이 된다', () {
      final flow = QuizFlow()
        ..recordCorrect()
        ..recordWrong(record('A'))
        ..recordWrong(record('B'));

      final firstIndex = flow.startWrongProblemRound();

      expect(firstIndex, 0, reason: '오답 모드의 첫 문제는 저장 목록의 0번');
      expect(flow.wrongProblemMode, isTrue);
      expect(flow.numberOfRight, 0);
      expect(flow.problemNumber, 1);
      expect(flow.wrongProblemsSave, [
        ['A'],
        ['B']
      ]);
      expect(flow.wrongProblems, isEmpty, reason: '오답 모드에서 새로 틀린 것만 담는다');
      expect(flow.canStartWrongProblemRound, isFalse);
    });

    test('오답 모드에서 새로 틀려도 출제 목록은 오염되지 않는다', () {
      // 화면 코드의 `wrongProblemsSave = wrongProblems` 는 복사가 아니라 별칭
      // 이었다. 지금은 곧바로 `wrongProblems` 를 새 리스트로 갈아 끼우기 때문에
      // 드러나지 않을 뿐이다. 여기서 그 잠복을 못 박는다.
      final flow = QuizFlow()
        ..recordWrong(record('A'))
        ..recordWrong(record('B'));
      flow.startWrongProblemRound();

      flow.recordWrong(record('B'));

      expect(flow.wrongProblemsSave, hasLength(2), reason: '출제 목록은 2개 그대로');
      expect(flow.wrongProblems, hasLength(1), reason: '다시 틀린 것은 1개');
    });

    test('진행 한계가 10이 아니라 오답 개수가 된다', () {
      final flow = QuizFlow()
        ..recordWrong(record('A'))
        ..recordWrong(record('B'))
        ..recordWrong(record('C'));
      flow.startWrongProblemRound();

      expect(flow.hasNextProblem, isTrue);
      expect(flow.advanceInWrongProblemRound(), 1);
      expect(flow.problemNumber, 2);
      expect(flow.hasNextProblem, isTrue);
      expect(flow.advanceInWrongProblemRound(), 2);
      expect(flow.problemNumber, 3);
      expect(flow.hasNextProblem, isFalse, reason: '오답 3개면 3번에서 결과 화면');
    });

    test('오답 1개면 첫 문제가 곧 마지막 문제다', () {
      final flow = QuizFlow()..recordWrong(record('A'));
      flow.startWrongProblemRound();

      expect(flow.hasNextProblem, isFalse);
    });
  });

  group('새 스테이지 / 그만두기', () {
    test("결과 화면 '네' 는 점수·오답·모드를 모두 되돌린다", () {
      final flow = QuizFlow()
        ..recordCorrect()
        ..recordWrong(record('A'));
      flow.startWrongProblemRound();
      flow.recordCorrect();

      flow.startNewStage();

      expect(flow.numberOfRight, 0);
      expect(flow.wrongProblems, isEmpty);
      expect(flow.wrongProblemMode, isFalse);
      expect(flow.problemNumber, 1);
      expect(flow.hasNextProblem, isTrue, reason: '분모가 다시 10으로 돌아온다');
    });

    test("결과 화면 '아니오'(나가기) 도 점수·오답·모드를 되돌린다", () {
      // 화면이 목록 화면까지 pop 하기 직전에 하는 정리. 문제 번호는 건드리지
      // 않는다 — 화면 자체가 사라지기 때문이다.
      final flow = QuizFlow()
        ..recordCorrect()
        ..recordWrong(record('A'))
        ..advanceToNextProblem();

      flow.abandonStage();

      expect(flow.numberOfRight, 0);
      expect(flow.wrongProblems, isEmpty);
      expect(flow.wrongProblemMode, isFalse);
      expect(flow.problemNumber, 2, reason: '번호는 그대로 둔다 (종전과 같다)');
    });
  });

  // -------------------------------------------------------- 전면광고 경계

  group('전면광고 경계', () {
    // 위젯 테스트는 한 화면에서 10문제까지만 풀고, `AdIds.adsAvailable` 이
    // false 라 `loadAd()` 안으로 들어가지도 않는다. 그래서 20 이라는 경계는
    // 여기서만 검사된다.
    tearDown(() => criticalNumberSolved = 20);

    test('19문제는 아직 아니고, 20·21문제면 띄운다', () {
      expect(shouldShowInterstitial(19), isFalse);
      expect(shouldShowInterstitial(20), isTrue);
      expect(shouldShowInterstitial(21), isTrue);
    });

    test('0문제에서는 띄우지 않는다', () {
      expect(shouldShowInterstitial(0), isFalse);
    });

    test('기준은 스테이지 점수가 아니라 앱 전체 누적 풀이 수다', () {
      // 한 스테이지는 10문제뿐이므로, 스테이지 안의 numberOfRight 로 재면
      // 광고는 영원히 뜨지 않는다. 반대로 기준을 1로 낮추면 매번 뜬다 —
      // 어느 쪽으로 틀려도 조용히 어긋나므로 여기서 못 박는다.
      final flow = QuizFlow();
      for (var i = 0; i < 10; i++) {
        flow.recordCorrect();
      }
      expect(shouldShowInterstitial(flow.numberOfRight), isFalse,
          reason: '스테이지 점수(10)로 재면 안 된다');

      criticalNumberSolved = 1;
      expect(shouldShowInterstitial(1), isTrue, reason: '기준값을 실제로 읽는다');
    });
  });

  // ------------------------------------------------- 한 스테이지 통째로

  group('한 스테이지 완주', () {
    test('10문제 중 3개를 틀리고, 다시 풀어 2개를 맞히는 흐름', () {
      final flow = QuizFlow();

      // 1) 일반 모드 10문제. 3·6·9번을 틀린다.
      const wrongAt = {3, 6, 9};
      for (var i = 1; i <= 10; i++) {
        expect(flow.problemNumber, i);
        if (wrongAt.contains(i)) {
          flow.recordWrong(record('Q$i'));
        } else {
          flow.recordCorrect();
        }
        if (i < 10) {
          expect(flow.hasNextProblem, isTrue, reason: '$i번');
          flow.advanceToNextProblem();
        } else {
          expect(flow.hasNextProblem, isFalse);
        }
      }

      // 결과 화면: 7/10
      expect(flow.numberOfRight, 7);
      expect(flow.wrongProblems, [
        ['Q3'],
        ['Q6'],
        ['Q9']
      ]);
      expect(flow.canStartWrongProblemRound, isTrue);

      // 2) 오답 모드 3문제. 2번째만 다시 틀린다.
      expect(flow.startWrongProblemRound(), 0);
      final retryQueue = flow.wrongProblemsSave;
      expect(retryQueue.map((e) => e.first), ['Q3', 'Q6', 'Q9']);

      flow.recordCorrect(); // Q3
      expect(flow.hasNextProblem, isTrue);
      expect(flow.advanceInWrongProblemRound(), 1);

      flow.recordWrong(record('Q6')); // Q6 다시 틀림
      expect(flow.hasNextProblem, isTrue);
      expect(flow.advanceInWrongProblemRound(), 2);

      flow.recordCorrect(); // Q9
      expect(flow.hasNextProblem, isFalse, reason: '오답 3개짜리 판의 마지막');

      // 결과 화면: 2/3
      expect(flow.numberOfRight, 2);
      expect(flow.wrongProblemsSave, hasLength(3), reason: '점수 분모');
      expect(flow.wrongProblems, [
        ['Q6']
      ], reason: '다시 틀린 것만 남는다');

      // 3) 한 번 더 오답 모드로 들어가면 Q6 하나짜리 판이 된다.
      expect(flow.startWrongProblemRound(), 0);
      expect(flow.wrongProblemsSave, [
        ['Q6']
      ]);
      expect(flow.numberOfRight, 0);
      expect(flow.problemNumber, 1);
      expect(flow.hasNextProblem, isFalse);
    });
  });
}
