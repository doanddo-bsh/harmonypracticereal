// 알려진 이슈: neapolitanProblem 은 이 파일의 핵심 불변식
// ("problem 의 모든 음은 original 의 구성음이어야 한다") 을 위반한다.
//
// 원인 (lib/harmonyModul/modulBasic.dart:588-641): neapolitanProblem 은
// 3화음 [근음, 3음, 5음] 을 담은 note3Origianl 을 만든 뒤, 베이스로 쓸 음
// (baseNote) 을 무작위로 고르고 나서
//   note3Origianl.remove(baseNote);
//   note3Origianl.add(baseFinaldownm2Up1);  // 3음을 중복으로 추가
// 로 "제자리에서" 리스트를 변형한 다음, 바로 그 변형된 리스트를
// 반환값의 5번째 원소(원화음/"original")로 돌려준다.
//
// baseNote 로 3음이 뽑혔을 때(intValue 15~69, 55% 확률)는 제거했다가
// 다시 3음을 넣는 꼴이라 우연히 3화음 구성이 보존되지만, baseNote 로
// 근음(intValue 0~14, 15%)이나 5음(intValue 70~99, 30%)이 뽑혔을 때
// (합쳐서 45% 확률)는 그 음이 결과에서 사라지고 3음이 중복으로 들어간다.
// 그런데 note4Shuffle(문제로 나가는 4성부)에는 baseNote 가 그대로
// 포함되므로, "문제의 모든 음은 원화음에 있어야 한다" 는 불변식이 깨진다.
//
// 주의: modulBasic.dart:592 의 소스 자체 주석 `// 확율 15, 70, 15` 는
// 오해의 소지가 있다 — 15/70/15 는 각 분기의 확률이 아니라
// Random().nextInt(100) 에 대한 누적 경계값(0~14, 15~69, 70~99)이다.
// 이걸 그대로 "15%, 70%, 15%" 로 읽으면 안 된다. 실제 분포는
// 근음 15% / 3음 55% / 5음 30% 이다.
//
// 실제 관측된 실패 예시 (회차마다 조성이 달라 음이름은 매번 다르다):
//   neapolitanProblem: A♭ 가 원화음 [D♭, F, F] 에 없다
//   neapolitanProblem: G♭ 가 원화음 [E♭, E♭, C♭] 에 없다
// (둘 다 근음/5음이 베이스로 뽑히고 3음이 중복으로 채워진 패턴이다.)
//
// 이 계획(Task 1)의 목적은 기존 동작을 있는 그대로 고정하는 것이므로,
// 이 버그를 여기서 고치지 않는다. neapolitanProblem 은 아래
// expectValidProblem(엄격한 불변식) 대상에서 제외하고, 실제로 항상
// 성립하는 더 약한 성질만 별도로 검증한다. (Phase 이후 버그 수정을
// 하게 되면 이 주석과 별도 테스트를 제거하고 다시 expectValidProblem
// 대상에 포함시킬 것.)

import 'package:flutter_test/flutter_test.dart';
import 'package:music_notes/music_notes.dart';

import 'package:harmonypracticereal/harmonyModul/modulBasic.dart';
import 'package:harmonypracticereal/harmonyModul/modulBasicMinor.dart';
import 'package:harmonypracticereal/harmonyModul/modulProblemProbability.dart';

/// 대부분의 불변식 검사에서 반복 횟수로 쓰는 기본값.
/// (Random() 기반 생성기이므로 낮은 확률의 분기까지 충분히 표본을
/// 뽑아내려면 몇 백 회는 돌려야 한다.)
const int kInvariantCheckIterations = 200;

/// 문제 생성 함수 하나를 [times]번 돌려 공통 불변식을 검사한다.
void expectValidProblem(
  (List<String>, List<Note>, Tonality, List<Note>, String) Function() generator,
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

    // neapolitanProblem 은 파일 상단 주석에 기록한 알려진 버그 때문에
    // expectValidProblem 의 "problem ⊆ original" 검사를 통과하지 못한다.
    // 대신 아래 별도 테스트에서, 실제로 항상 성립하는 성질만 검증한다.
    test('neapolitanProblem (나폴리화음) — 알려진 버그로 인해 완화된 검증', () {
      for (var i = 0; i < kInvariantCheckIterations; i++) {
        final (answer, problem, _, original, name) = neapolitanProblem();

        expect(answer.length, 9,
            reason: 'neapolitanProblem: 정답은 항상 9칸이어야 한다 (회차 $i)');
        expect(problem.length, 4,
            reason: 'neapolitanProblem: 출제는 항상 4성부여야 한다 (회차 $i)');
        expect(original.length, 3,
            reason: 'neapolitanProblem: 원화음은 항상 3화음이어야 한다 (회차 $i)');
        expect(answer[0], 'N',
            reason: '나폴리화음의 로마숫자 자리는 항상 N 이어야 한다 (회차 $i)');
        expect(name, 'neapolitanProblem',
            reason: '문제 이름이 일치해야 한다 (회차 $i)');

        // 주의: 여기서는 일부러 "problem 의 모든 음이 original 에 있다"
        // 는 검사를 하지 않는다 — 파일 상단 주석에 적은 버그 때문에
        // 30% 확률로 깨진다. 이 검사를 추가하고 싶다면 먼저
        // lib/harmonyModul/modulBasic.dart 의 neapolitanProblem 버그를
        // 고쳐야 한다.
      }
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
