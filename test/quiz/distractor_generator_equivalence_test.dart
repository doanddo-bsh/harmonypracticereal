// 특성화(characterization) 테스트.
//
// 리팩토링 전 `problem_type1_page.dart` 의 `getViewListEasyType1` 본문을
// 그대로 복사해 두고, 똑같은 후보 스트림을 두 구현에 흘려 결과가 한 글자도
// 다르지 않은지 확인한다. `DistractorGenerator` 를 "정리"하다가 오답 종류의
// 분포가 바뀌면 이 테스트가 잡는다.
//
// 아래 originalGetViewListEasyType1 은 **의도적으로 손대지 않은 사본**이다.
// 스타일 경고가 나더라도 고치지 말 것 — 원본과 달라지는 순간 기준선이 사라진다.
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:harmonypracticereal/domain/quiz/distractor_generator.dart';

/// problem_type1_page.dart 219~377 줄을 그대로 옮긴 것.
/// widget.problemCallFunction 호출만 draw 로 바꿨다.
List<List<String>> originalGetViewListEasyType1(
  List<String> answer,
  String problemName,
  (List<String>, String) Function() draw,
  Random shuffleRandom,
) {
  List<List<String>> viewListTemp = [];
  List<String> viewListTempString = [];

  List<String> basicProblemList = ['basicProblem', 'basicProblemMinor'];

  viewListTemp.add(answer);
  viewListTempString.add(answer.join(','));

  if (basicProblemList.contains(problemName)) {
    int cutUnlimitLoop = 0;

    while (viewListTemp.length <= 2) {
      cutUnlimitLoop += 1;
      final wrongAnswerTemp = draw();

      if ((!viewListTempString.contains(wrongAnswerTemp.$1.join(','))) &
          (basicProblemList.contains(wrongAnswerTemp.$2))) {
        viewListTemp.add(wrongAnswerTemp.$1);
        viewListTempString.add(wrongAnswerTemp.$1.join(','));
      }

      if ((!viewListTempString.contains(wrongAnswerTemp.$1.join(','))) &
          (cutUnlimitLoop > 5)) {
        cutUnlimitLoop = 0;
        viewListTemp.add(wrongAnswerTemp.$1);
        viewListTempString.add(wrongAnswerTemp.$1.join(','));
      }
    }

    while (viewListTemp.length <= 3) {
      cutUnlimitLoop += 1;
      final wrongAnswerTemp = draw();

      if ((!viewListTempString.contains(wrongAnswerTemp.$1.join(','))) &
          (!basicProblemList.contains(wrongAnswerTemp.$2))) {
        viewListTemp.add(wrongAnswerTemp.$1);
        viewListTempString.add(wrongAnswerTemp.$1.join(','));
      }

      if ((!viewListTempString.contains(wrongAnswerTemp.$1.join(','))) &
          (cutUnlimitLoop > 5)) {
        cutUnlimitLoop = 0;
        viewListTemp.add(wrongAnswerTemp.$1);
        viewListTempString.add(wrongAnswerTemp.$1.join(','));
      }
    }
  } else {
    int cutUnlimitLoop = 0;

    while (viewListTemp.length <= 2) {
      cutUnlimitLoop += 1;
      final wrongAnswerTemp = draw();

      if ((!viewListTempString.contains(wrongAnswerTemp.$1.join(','))) &
          (!basicProblemList.contains(wrongAnswerTemp.$2))) {
        viewListTemp.add(wrongAnswerTemp.$1);
        viewListTempString.add(wrongAnswerTemp.$1.join(','));
      }

      if (((!viewListTempString.contains(wrongAnswerTemp.$1.join(',')))) &
          (cutUnlimitLoop > 5)) {
        cutUnlimitLoop = 0;
        viewListTemp.add(wrongAnswerTemp.$1);
        viewListTempString.add(wrongAnswerTemp.$1.join(','));
      }
    }

    while (viewListTemp.length <= 3) {
      cutUnlimitLoop += 1;
      final wrongAnswerTemp = draw();

      if ((!viewListTempString.contains(wrongAnswerTemp.$1.join(','))) &
          (basicProblemList.contains(wrongAnswerTemp.$2))) {
        viewListTemp.add(wrongAnswerTemp.$1);
        viewListTempString.add(wrongAnswerTemp.$1.join(','));
      }

      if ((!viewListTempString.contains(wrongAnswerTemp.$1.join(','))) &
          (cutUnlimitLoop > 5)) {
        cutUnlimitLoop = 0;
        viewListTemp.add(wrongAnswerTemp.$1);
        viewListTempString.add(wrongAnswerTemp.$1.join(','));
      }
    }
  }

  viewListTemp.shuffle(shuffleRandom);

  return viewListTemp;
}

/// 엔진이 실제로 내는 이름들.
const allNames = <String>[
  'basicProblem',
  'basicProblemMinor',
  'basicProblemBorrowed',
  'neapolitanProblem',
  'neapolitanProblemMinor',
  'dominant7thProblem',
  'dominant7thProblemMinor',
  'secondaryDominant7thProblem',
  'secondaryDominant7thProblemMinor',
  'secondaryDiminished7thProblem',
  'secondaryDiminished7thProblemMinor',
  'secondaryHalfDiminished7thProblem',
  'secondaryHalfDiminished7thProblemMinor',
  'secondary7thProblem',
  'secondary7thProblemMinor',
  'diminished7thProblem',
  'diminished7thProblemMinor',
  'halfDiminished7thProblem',
  'halfDiminished7thProblemMinor',
];

void main() {
  test('원본과 새 구현이 같은 후보 스트림에서 같은 결과를 낸다', () {
    var mismatches = 0;
    final firstMismatch = <String>[];

    for (var trial = 0; trial < 20000; trial++) {
      // 같은 시드 → 두 구현에 완전히 동일한 후보 스트림을 준다.
      final poolSize = 3 + Random(trial).nextInt(30);
      final answerName = allNames[Random(trial * 7 + 1).nextInt(allNames.length)];
      final answer = ['ans$trial', '', '', '', '', '', '', '', ''];

      (List<String>, String) Function() makeStream() {
        final r = Random(trial * 31 + 5);
        return () {
          final i = r.nextInt(poolSize);
          return (
            ['cand$i', '', '', '', '', '', '', '', ''],
            allNames[r.nextInt(allNames.length)],
          );
        };
      }

      final oldResult = originalGetViewListEasyType1(
          answer, answerName, makeStream(), Random(trial));
      final newResult = DistractorGenerator.buildChoices(
        answer: answer,
        problemName: answerName,
        drawCandidate: makeStream(),
        random: Random(trial),
      );

      final o = oldResult.map((e) => e.join(',')).toList();
      final n = newResult.map((e) => e.join(',')).toList();
      if (o.toString() != n.toString()) {
        mismatches++;
        if (firstMismatch.isEmpty) {
          firstMismatch.add('trial $trial ($answerName): old=$o new=$n');
        }
      }
    }

    expect(mismatches, 0,
        reason: '20000회 중 $mismatches 회 불일치. 첫 사례: $firstMismatch');
  });
}
