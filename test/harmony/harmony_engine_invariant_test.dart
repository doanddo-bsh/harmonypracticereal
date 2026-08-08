// 과거 이력: neapolitanProblem 은 이 파일의 핵심 불변식
// ("problem 의 모든 음은 original 의 구성음이어야 한다") 을 위반해서
// expectValidProblem 대상에서 제외돼 있었다.
//
// 원인은 major_problems.dart 의 neapolitanProblem 이 3화음
// [근음, 3음, 5음] 을 담은 note3Origianl 을 만든 뒤 베이스를 고르고,
//   note3Origianl.remove(baseNote);
//   note3Origianl.add(baseFinaldownm2Up1);  // 3음을 중복으로 추가
//   note3Origianl.shuffle();
// 로 그 리스트를 "제자리에서" 변형한 다음, 변형된 리스트를 그대로
// 반환값의 4번째 원소(원화음/"original")로 돌려준 것이었다.
// 같은 파일의 neapolitanProblemMinor 는 처음부터 note3Shuffle 사본을
// 따로 두어 원화음을 보존하고 있었다 — 장조 쪽만 어긋나 있었다.
//
// 2026-08-05 (Phase 3 Task 4) 에 성부 배치용 사본 note3Shuffle 을
// 분리해 수정했다. 이제 neapolitanProblem 도 다른 생성기와 똑같이
// expectValidProblem 을 통과하므로 제외를 걷어냈고, 아래에 원화음이
// 실제로 ♭II 장3화음인지 검사하는 테스트를 추가했다.
//
// 참고: major_problems.dart 에 있던 인라인 주석 `// 확율 15, 70, 15` 는
// 각 분기의 확률이 아니라 Random().nextInt(100) 에 대한 누적 경계값
// (0~14, 15~69, 70~99)이었다. 실제 분포는 근음 15% / 3음 55% / 5음 30%
// 이고, 그래서 원화음이 깨지는 경우가 45% 였다. 수정 과정에서
// 오해를 부르지 않도록 소스 주석도 함께 고쳤다.

import 'package:flutter_test/flutter_test.dart';
import 'package:music_notes/music_notes.dart';

import 'package:harmonypracticereal/domain/harmony/major_problems.dart';
import 'package:harmonypracticereal/domain/harmony/minor_problems.dart';
import 'package:harmonypracticereal/domain/harmony/problem_catalog.dart';

/// 대부분의 불변식 검사에서 반복 횟수로 쓰는 기본값.
/// (Random() 기반 생성기이므로 낮은 확률의 분기까지 충분히 표본을
/// 뽑아내려면 몇 백 회는 돌려야 한다.)
const int kInvariantCheckIterations = 200;

/// 문제 생성 함수 하나를 [times]번 돌려 공통 불변식을 검사한다.
void expectValidProblem(
  (List<String>, List<Note>, Key, List<Note>, String) Function() generator,
  String expectedName, {
  int times = kInvariantCheckIterations,
}) {
  for (var i = 0; i < times; i++) {
    final (answer, problem, _, original, name) = generator();

    expect(answer.length, 9,
        reason: '$expectedName: 정답은 항상 9칸이어야 한다 (회차 $i)');
    expect(problem.length, 4,
        reason: '$expectedName: 출제는 항상 4성부여야 한다 (회차 $i)');
    expect(original.length, anyOf(3, 4),
        reason: '$expectedName: 원화음은 3화음 또는 7화음이어야 한다 (회차 $i)');
    expect(answer[0], isNotEmpty,
        reason: '$expectedName: 로마숫자가 비어 있으면 안 된다 (회차 $i)');
    expect(name, expectedName, reason: '문제 이름이 일치해야 한다 (회차 $i)');

    // 출제 4성부는 원화음의 구성음만으로 이루어져야 한다 (중복음 허용).
    for (final note in problem) {
      expect(original.contains(note), isTrue,
          reason: '$expectedName: $note 가 원화음 $original 에 없다 (회차 $i)');
    }
  }
}

void main() {
  group('장조 문제 생성 불변식', () {
    test('basicProblem (3화음)', () {
      expectValidProblem(basicProblem, 'basicProblem');
    });

    test('dominant7thProblem (속7화음)', () {
      expectValidProblem(dominant7thProblem, 'dominant7thProblem');
    });

    test('secondaryDominant7thProblem (부속7화음)', () {
      expectValidProblem(
          secondaryDominant7thProblem, 'secondaryDominant7thProblem');
    });

    test('neapolitanProblem (나폴리화음)', () {
      expectValidProblem(neapolitanProblem, 'neapolitanProblem');
    });
  });

  group('나폴리화음 원화음의 화성학적 정합성', () {
    // expectValidProblem 은 "problem ⊆ original" 만 본다. 그것만으로는
    // original 이 엉뚱한 리스트여도 통과할 수 있으므로(예: 4성부를 그대로
    // 돌려주기), 원화음이 정말 ♭II 장3화음인지를 따로 못 박아 둔다.
    void expectFlatIITriad(
      (List<String>, List<Note>, Key, List<Note>, String) Function() generator,
      String label,
    ) {
      final figuredBassSeen = <String>{};

      for (var i = 0; i < kInvariantCheckIterations; i++) {
        final (answer, problem, key, original, _) = generator();

        // 1) 원화음은 [근음, 3음, 5음] 3개다.
        expect(original.length, 3,
            reason: '$label: 원화음은 3화음이어야 한다 (회차 $i)');

        final root = original[0];

        // 2) 근음은 그 조성의 **내림 2도**(♭II)다.
        //    - 음이름은 2도(예: C장조 → D)
        //    - 음높이는 그 2도보다 반음 낮다
        final diatonicSecond = addSharpByTonality(
          Note.parse(key.note.noteName.transposeBySize(const Size(2)).name),
          key,
        );
        expect(root.noteName, diatonicSecond.noteName,
            reason: '$label: 원화음 근음의 음이름은 $key 의 2도여야 한다 '
                '(근음 $root / 2도 $diatonicSecond, 회차 $i)');
        expect(root.semitones, diatonicSecond.semitones - 1,
            reason: '$label: 나폴리 근음은 2도보다 반음 낮아야 한다 '
                '(근음 $root / 2도 $diatonicSecond, 회차 $i)');

        // 3) 장3화음이다 — 근음 위 장3도와 완전5도.
        expect(original[1], root.transposeBy(Interval.M3),
            reason: '$label: 3음은 근음 위 장3도여야 한다 '
                '(원화음 $original, 회차 $i)');
        expect(original[2], root.transposeBy(Interval.P5),
            reason: '$label: 5음은 근음 위 완전5도여야 한다 '
                '(원화음 $original, 회차 $i)');

        // 4) 출제된 4성부는 이 3화음 안에서만 나오고, 세 구성음이 모두
        //    한 번 이상 등장한다.
        expect(problem.toSet(), original.toSet(),
            reason: '$label: 4성부는 원화음 세 음을 모두 써야 한다 '
                '(4성부 $problem / 원화음 $original, 회차 $i)');

        // 5) 자리표(N / N6 / N4·6)가 실제 베이스와 맞는다.
        final figured = '${answer[2]}${answer[3]}';
        final expectedBassIndex = switch (figured) {
          '' => 0, // 기본위치
          '6' => 1, // 1전위 — 3음이 베이스
          '46' => 2, // 2전위 — 5음이 베이스
          _ => -1,
        };
        expect(expectedBassIndex, isNot(-1),
            reason: '$label: 알 수 없는 자리표 "$figured" (회차 $i)');
        expect(problem.first, original[expectedBassIndex],
            reason: '$label: 자리표 "N$figured" 는 '
                '${original[expectedBassIndex]} 이 베이스여야 한다 '
                '(실제 베이스 ${problem.first}, 회차 $i)');
        figuredBassSeen.add(figured);
      }

      // 세 자리표가 모두 표본에 나와야 위 검사가 전 분기를 덮은 것이다.
      expect(figuredBassSeen, {'', '6', '46'},
          reason: '$label: 기본위치/1전위/2전위가 모두 표본에 나와야 한다');
    }

    test('neapolitanProblem 의 원화음은 ♭II 장3화음이다', () {
      expectFlatIITriad(neapolitanProblem, 'neapolitanProblem');
    });
  });

  group('단조 문제 생성 불변식', () {
    test('basicProblemMinor (3화음)', () {
      expectValidProblem(basicProblemMinor, 'basicProblemMinor');
    });

    test('dominant7thProblemMinor (속7화음)', () {
      expectValidProblem(dominant7thProblemMinor, 'dominant7thProblemMinor');
    });
  });

  group('커스텀 출제기', () {
    // getCustomProblemType 은 내부적으로 problemMajorMinorAll(functionMajor,
    // functionMinor) 를 호출하고, 그 함수가 고른 장조/단조 생성기가 반환한
    // problemName 을 그대로 통과시킨다 (modulProblemProbability.dart:553-,
    // 655-679 확인). 따라서 '3화음' 은 {basicProblem, basicProblemMinor},
    // '속7화음' 은 {dominant7thProblem, dominant7thProblemMinor} 로만
    // 이어지며, 이 두 항목만 선택했을 때 나올 수 있는 problemName 은
    // 정확히 아래 4개 집합이어야 한다.
    const allowedNames = {
      'basicProblem',
      'basicProblemMinor',
      'dominant7thProblem',
      'dominant7thProblemMinor',
    };

    test('선택한 화음 종류만 출제된다', () {
      for (var i = 0; i < kInvariantCheckIterations; i++) {
        final (answer, problem, _, original, name) =
            getCustomProblemType(['3화음', '속7화음']);

        expect(answer.length, 9);
        expect(problem.length, 4);
        expect(original.length, anyOf(3, 4));
        expect(allowedNames.contains(name), isTrue,
            reason: "getCustomProblemType(['3화음', '속7화음']) 는 "
                '$allowedNames 중 하나만 반환해야 하는데 "$name" 을 반환했다 '
                '(회차 $i)');
      }
    });

    // 이 테스트는 예외 없이 동작하는지만 확인하는 스모크 테스트라 표본
    // 개수가 덜 중요하므로, 위의 kInvariantCheckIterations(200)보다
    // 적은 50회만 돈다.
    test('단일 항목만 넘겨도 예외 없이 동작한다', () {
      for (var i = 0; i < 50; i++) {
        final (answer, _, _, _, name) = getCustomProblemType(['3화음']);
        expect(answer.length, 9);
        expect(name, anyOf('basicProblem', 'basicProblemMinor'),
            reason: "getCustomProblemType(['3화음']) 는 basicProblem 또는 "
                'basicProblemMinor 만 반환해야 하는데 "$name" 을 반환했다 '
                '(회차 $i)');
      }
    });
  });
}
