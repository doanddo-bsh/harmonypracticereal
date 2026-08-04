import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:harmonypracticereal/domain/harmony/major_problems.dart';
import 'package:harmonypracticereal/domain/harmony/minor_problems.dart';
import 'package:harmonypracticereal/domain/quiz/distractor_generator.dart';

/// 9칸 정답 문자열을 만드는 헬퍼. 내용은 중요하지 않고 서로 다르기만 하면 된다.
List<String> _slot(String head) => [head, '', '', '', '', '', '', '', ''];

void main() {
  group('isSeventhChordProblem', () {
    test('엔진이 실제로 반환하는 이름을 7화음으로 인식한다', () {
      // major_problems.dart / minor_problems.dart 가 반환하는 실제 문자열이다.
      const namesFromEngine = [
        'dominant7thProblem',
        'dominant7thProblemMinor',
        'secondaryDominant7thProblem',
        'secondaryDominant7thProblemMinor',
        'secondaryDiminished7thProblem',
        'secondaryDiminished7thProblemMinor',
        'secondaryHalfDiminished7thProblem',
        'secondaryHalfDiminished7thProblemMinor',
      ];

      for (final name in namesFromEngine) {
        expect(DistractorGenerator.isSeventhChordProblem(name), isTrue,
            reason: '$name 은 7화음 계열로 인식돼야 한다');
      }
    });

    test('3화음 문제는 7화음으로 인식하지 않는다', () {
      expect(DistractorGenerator.isSeventhChordProblem('basicProblem'), isFalse);
      expect(
          DistractorGenerator.isSeventhChordProblem('basicProblemMinor'), isFalse);
    });

    test('대소문자가 달라도 같은 문제로 취급하지 않는다 - 오타 방지', () {
      // 과거 'Dominant7thProblem' 오타가 있었다. 엔진이 내는 이름과
      // 정확히 일치하는 것만 인정한다.
      expect(DistractorGenerator.isSeventhChordProblem('Dominant7thProblem'),
          isFalse);
    });
  });

  group('B1 회귀 방지 - 엔진이 내는 이름을 하드코딩하지 않고 실제로 확인한다', () {
    test('dominant7thProblem() 이 실제로 반환하는 이름이 7화음 집합에 있다', () {
      // 이 단언이 B1 의 핵심 증거다. 화면 코드에 있던 'Dominant7thProblem'
      // (대문자 D) 은 엔진이 내는 이름과 한 글자도 맞지 않는다.
      for (var i = 0; i < 30; i++) {
        final emitted = dominant7thProblem().$5;
        expect(emitted, 'dominant7thProblem');
        expect(DistractorGenerator.isSeventhChordProblem(emitted), isTrue,
            reason: '엔진이 낸 "$emitted" 가 7화음으로 인식되지 않는다');
        expect(DistractorGenerator.isTriadProblem(emitted), isFalse);
      }
    });

    test('dominant7thProblemMinor() 도 마찬가지다', () {
      for (var i = 0; i < 30; i++) {
        final emitted = dominant7thProblemMinor().$5;
        expect(emitted, 'dominant7thProblemMinor');
        expect(DistractorGenerator.isSeventhChordProblem(emitted), isTrue);
        expect(DistractorGenerator.isTriadProblem(emitted), isFalse);
      }
    });

    test('basicProblem() 이 내는 이름은 3화음으로 인식된다', () {
      for (var i = 0; i < 30; i++) {
        final emitted = basicProblem().$5;
        expect(emitted, 'basicProblem');
        expect(DistractorGenerator.isTriadProblem(emitted), isTrue);
      }
    });

    test('속7화음 정답은 7화음 분기를 탄다 - 3화음 규칙이 적용되지 않는다', () {
      // 엔진이 낸 이름을 그대로 넣어, 오답 2개가 7화음(=비3화음)에서
      // 먼저 채워지는지 본다. 3화음 분기를 탔다면 순서가 뒤집힌다.
      final emitted = dominant7thProblem().$5;

      final drawn = <String>[];
      var n = 0;
      final choices = DistractorGenerator.buildChoices(
        answer: _slot('V7'),
        problemName: emitted,
        random: Random(1),
        drawCandidate: () {
          n++;
          // 3화음 후보와 7화음 후보를 번갈아 준다.
          final name = n.isOdd ? 'basicProblem' : 'dominant7thProblem';
          drawn.add(name);
          return (_slot('c$n'), name);
        },
      );

      expect(choices.length, 4);
      // 채택된 오답의 종류 순서를 재구성한다.
      // 7화음 분기: 처음 두 오답은 비3화음, 마지막 하나가 3화음이어야 한다.
      // 후보가 홀수=3화음 / 짝수=7화음이므로 채택 순서는 c2, c4, c5 가 된다.
      expect(choices.map((c) => c.first).toSet(),
          {'V7', 'c2', 'c4', 'c5'},
          reason: '7화음 분기라면 비3화음 2개를 먼저 채우고 3화음 1개를 나중에 채운다');
    });

    test('3화음 정답은 반대 순서로 채운다', () {
      final emitted = basicProblem().$5;

      var n = 0;
      final choices = DistractorGenerator.buildChoices(
        answer: _slot('I'),
        problemName: emitted,
        random: Random(1),
        drawCandidate: () {
          n++;
          final name = n.isOdd ? 'basicProblem' : 'dominant7thProblem';
          return (_slot('c$n'), name);
        },
      );

      expect(choices.map((c) => c.first).toSet(), {'I', 'c1', 'c3', 'c4'},
          reason: '3화음 분기라면 3화음 2개를 먼저 채우고 비3화음 1개를 나중에 채운다');
    });
  });

  group('isTriadProblem', () {
    test('3화음 문제만 참이다', () {
      expect(DistractorGenerator.isTriadProblem('basicProblem'), isTrue);
      expect(DistractorGenerator.isTriadProblem('basicProblemMinor'), isTrue);
      expect(DistractorGenerator.isTriadProblem('dominant7thProblem'), isFalse);
    });

    test('차용/나폴리 등 3화음 집합에 없는 이름은 모두 "비3화음"으로 다룬다', () {
      // 기존 화면 코드도 basicProblemList 하나만 보고 그 밖을 전부
      // 반대편으로 취급했다. 이 동작을 그대로 유지한다.
      for (final name in const [
        'basicProblemBorrowed',
        'neapolitanProblem',
        'neapolitanProblemMinor',
        'secondary7thProblem',
        'secondary7thProblemMinor',
        'diminished7thProblem',
        'halfDiminished7thProblemMinor',
      ]) {
        expect(DistractorGenerator.isTriadProblem(name), isFalse,
            reason: '$name 은 3화음 집합에 없다');
      }
    });
  });

  group('buildChoices', () {
    test('정답 포함 총 4개 보기를 만든다', () {
      var callCount = 0;
      final choices = DistractorGenerator.buildChoices(
        answer: const ['V', '', '', '', '', '', '', '', ''],
        problemName: 'basicProblem',
        drawCandidate: () {
          callCount++;
          // 매번 다른 후보를 준다.
          return (['I$callCount', '', '', '', '', '', '', '', ''],
              callCount.isEven ? 'basicProblem' : 'dominant7thProblem');
        },
      );

      expect(choices.length, 4);
      expect(choices, contains(const ['V', '', '', '', '', '', '', '', '']));
    });

    test('중복 보기를 만들지 않는다', () {
      final choices = DistractorGenerator.buildChoices(
        answer: const ['V', '', '', '', '', '', '', '', ''],
        problemName: 'basicProblem',
        drawCandidate: () {
          // 항상 같은 후보만 반환해도 무한루프에 빠지지 않아야 한다.
          return (['I', '', '', '', '', '', '', '', ''], 'basicProblem');
        },
      );

      final asStrings = choices.map((c) => c.join(',')).toSet();
      expect(asStrings.length, choices.length,
          reason: '보기에 중복이 있으면 안 된다');
    });

    test('후보가 계속 같아도 무한루프에 빠지지 않는다', () {
      // 이 테스트가 타임아웃되면 루프 탈출 조건이 잘못된 것이다.
      expect(
        () => DistractorGenerator.buildChoices(
          answer: const ['V', '', '', '', '', '', '', '', ''],
          problemName: 'dominant7thProblem',
          drawCandidate: () =>
              (const ['V', '', '', '', '', '', '', '', ''], 'dominant7thProblem'),
        ),
        returnsNormally,
      );
    });

    test('정답은 항상 보기에 들어 있다', () {
      var n = 0;
      for (var seed = 0; seed < 20; seed++) {
        final choices = DistractorGenerator.buildChoices(
          answer: _slot('answer'),
          problemName: 'basicProblem',
          random: Random(seed),
          drawCandidate: () {
            n++;
            return (_slot('c$n'), n.isEven ? 'basicProblem' : 'neapolitanProblem');
          },
        );
        expect(choices.length, 4);
        expect(choices.map((c) => c.first), contains('answer'));
      }
    });
  });

  group('동작 보존 - 기존 cutUnlimitLoop 계수기 규칙', () {
    // 기존 코드(problem_type1_page.dart getViewListEasyType1)의 계수기는
    //  * 매 추첨마다 +1
    //  * 원하는 종류가 나와서 채택될 때는 리셋되지 않음
    //  * 종류가 안 맞아도 계수기가 5를 넘으면 채택하고 0으로 리셋
    //  * 두 번째 슬롯 루프로 넘어가도 계수기를 이어서 씀
    // 아래 두 테스트가 이 네 가지를 고정한다.

    test('원하는 종류가 안 나오면 6번째 추첨에서 다른 종류를 받아들인다', () {
      var draws = 0;
      final choices = DistractorGenerator.buildChoices(
        answer: _slot('I'),
        problemName: 'basicProblem', // 3화음 → 첫 루프는 3화음을 원한다
        random: Random(0),
        drawCandidate: () {
          draws++;
          // 3화음은 절대 안 나온다.
          return (_slot('c$draws'), 'neapolitanProblem');
        },
      );

      expect(choices.length, 4);
      // 첫 슬롯: 추첨 1~6, 6번째에서 채택(계수기 6>5) 후 0으로 리셋
      // 둘째 슬롯: 추첨 7~12, 12번째에서 채택 후 0으로 리셋
      // 셋째 슬롯: 반대 종류(비3화음)를 원하므로 추첨 13에서 바로 채택
      expect(draws, 13, reason: '기존 계수기라면 정확히 13번 추첨한다');
    });

    test('첫 루프에서 쌓인 계수기가 둘째 루프로 이어진다', () {
      var draws = 0;
      final choices = DistractorGenerator.buildChoices(
        answer: _slot('I'),
        problemName: 'basicProblem',
        random: Random(0),
        drawCandidate: () {
          draws++;
          // 항상 3화음만 나온다 → 둘째 루프(비3화음 요구)는 절대 못 맞춘다.
          return (_slot('c$draws'), 'basicProblemMinor');
        },
      );

      expect(choices.length, 4);
      // 첫 슬롯: 추첨 1에서 바로 채택(계수기 1, 리셋 안 함)
      // 둘째 슬롯: 추첨 2에서 바로 채택(계수기 2)
      // 셋째 슬롯: 계수기가 2에서 이어지므로 추첨 3,4,5,6 → 6에서 채택
      // 계수기를 슬롯마다 리셋했다면 9번 추첨했을 것이다.
      expect(draws, 6,
          reason: '계수기를 슬롯마다 리셋하면 9가 된다 - 기존 동작은 이어쓰기다');
    });
  });
}
