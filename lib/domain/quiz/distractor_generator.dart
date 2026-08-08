import 'dart:math';

/// 문제 하나에 대한 오답 보기(distractor)를 만든다.
///
/// `problem_type1_page.dart` 의 `getViewListEasyType1` 에서 그대로 뽑아낸
/// 순수 로직이다. 후보를 뽑는 방법은 [drawCandidate] 로 주입받으므로
/// 테스트에서 난수 없이 결정적으로 검증할 수 있다.
///
/// **동작 보존이 이 클래스의 존재 이유다.** 아래 [buildChoices] 는 원본의
/// `cutUnlimitLoop` 계수기 규칙을 글자 그대로 옮긴 것이다. 규칙을 "정리"하면
/// 오답 종류의 분포가 바뀌므로 손대지 말 것.
class DistractorGenerator {
  DistractorGenerator._();

  /// 화성 엔진이 3화음 문제에 붙이는 이름.
  ///
  /// 원본 코드의 `basicProblemList` 와 같다. 분기는 오직 이 집합의
  /// 포함 여부로만 갈리며, 여기 없는 이름은 (차용화음·나폴리·부7화음 등
  /// 무엇이든) 전부 "반대편"으로 취급된다.
  static const triadProblemNames = <String>{
    'basicProblem',
    'basicProblemMinor',
  };

  /// 화성 엔진이 7화음 계열 문제에 붙이는 이름.
  ///
  /// 여기 값은 `lib/domain/harmony/` 의 각 함수가 반환하는 다섯 번째 요소와
  /// 글자 하나까지 같아야 한다. 화면 코드에는 'Dominant7thProblem'(대문자 D)
  /// 이라는 오타가 있었다 — 엔진은 'dominant7thProblem' 을 낸다 (B1).
  ///
  /// 주의: 이 집합은 **문서·검증용**이다. [buildChoices] 의 분기는 원본과
  /// 똑같이 [triadProblemNames] 만 본다. 이 집합을 분기에 쓰면
  /// `neapolitanProblem` / `basicProblemBorrowed` / `secondary7thProblem`
  /// 같은 이름들이 어느 쪽에도 안 들어가 동작이 달라진다.
  static const seventhChordProblemNames = <String>{
    'dominant7thProblem',
    'dominant7thProblemMinor',
    'secondaryDominant7thProblem',
    'secondaryDominant7thProblemMinor',
    'secondaryDiminished7thProblem',
    'secondaryDiminished7thProblemMinor',
    'secondaryHalfDiminished7thProblem',
    'secondaryHalfDiminished7thProblemMinor',
  };

  static bool isTriadProblem(String problemName) =>
      triadProblemNames.contains(problemName);

  static bool isSeventhChordProblem(String problemName) =>
      seventhChordProblemNames.contains(problemName);

  /// 원본의 `cutUnlimitLoop > 5` 임계값.
  ///
  /// 원하는 종류가 계속 안 나와도 6번째 추첨에서는 종류를 가리지 않고 받는다.
  static const _kindMismatchTolerance = 5;

  /// 같은 후보만 계속 나올 때 포기하는 기준.
  ///
  /// 원본에는 이 탈출구가 없어서, 후보 풀이 이미 뽑은 값들로만 이뤄지면
  /// while 루프가 영원히 돌았다(= UI 프리즈).
  ///
  /// **원본과 유일하게 다른 지점이다.** 임계값을 넘기면 보기를 4개 미만으로
  /// 돌려주므로, 호출부가 `viewList[3]` 을 그대로 인덱싱하면 예외가 난다.
  /// 즉 "무한 정지"를 "즉시 실패"로 바꾼 것이지, 없던 안전장치를 만든 게 아니다.
  /// 임계값을 500 으로 크게 잡아 원본이 정상 종료하던 경우의 결과는
  /// 한 건도 바뀌지 않는다(equivalence 테스트 20000회로 확인).
  /// 실제 문제 풀은 조성 × 도수 × 자리바꿈 조합이라 연속 500회 중복 추첨은
  /// 사실상 발생하지 않는다.
  static const _maxConsecutiveDuplicateDraws = 500;

  /// 정답 1개 + 오답 3개, 총 4개 보기를 만들어 섞어서 돌려준다.
  ///
  /// 3화음 문제면 오답 2개는 3화음에서, 1개는 3화음이 아닌 것에서 뽑는다.
  /// 3화음이 아닌 문제면 반대로 2개는 비3화음, 1개는 3화음에서 뽑는다.
  ///
  /// [drawCandidate] 는 (정답문자열9칸, 문제이름) 쌍을 반환해야 한다.
  /// [random] 은 마지막 셔플에만 쓰인다. 생략하면 매번 다르게 섞인다.
  static List<List<String>> buildChoices({
    required List<String> answer,
    required String problemName,
    required (List<String>, String) Function() drawCandidate,
    Random? random,
  }) {
    final choices = <List<String>>[answer];
    final seen = <String>{answer.join(',')};

    final answerIsTriad = isTriadProblem(problemName);

    // 원본에서 계수기는 두 슬롯 루프에 걸쳐 하나만 선언돼 이어서 쓰였다.
    // 첫 루프에서 쌓인 값이 둘째 루프의 첫 채택 시점을 앞당긴다.
    final counter = _MismatchCounter();

    // 슬롯 1~2: 정답과 같은 종류.
    _fillUntil(
      choices: choices,
      seen: seen,
      targetCount: 3,
      wantTriad: answerIsTriad,
      counter: counter,
      drawCandidate: drawCandidate,
    );

    // 슬롯 3: 정답과 다른 종류.
    _fillUntil(
      choices: choices,
      seen: seen,
      targetCount: 4,
      wantTriad: !answerIsTriad,
      counter: counter,
      drawCandidate: drawCandidate,
    );

    choices.shuffle(random);

    return choices;
  }

  static void _fillUntil({
    required List<List<String>> choices,
    required Set<String> seen,
    required int targetCount,
    required bool wantTriad,
    required _MismatchCounter counter,
    required (List<String>, String) Function() drawCandidate,
  }) {
    var consecutiveDuplicates = 0;

    while (choices.length < targetCount) {
      counter.value += 1;

      final (candidateAnswer, candidateName) = drawCandidate();
      final key = candidateAnswer.join(',');

      // 이미 나온 보기는 원본에서도 두 if 문이 모두 걸러냈다.
      if (seen.contains(key)) {
        consecutiveDuplicates += 1;
        if (consecutiveDuplicates > _maxConsecutiveDuplicateDraws) return;
        continue;
      }
      consecutiveDuplicates = 0;

      if (isTriadProblem(candidateName) == wantTriad) {
        // 원하는 종류가 나왔다. 원본은 이때 계수기를 리셋하지 않았다.
        choices.add(candidateAnswer);
        seen.add(key);
      } else if (counter.value > _kindMismatchTolerance) {
        // 종류가 안 맞아도 오래 못 채웠으면 받아들이고 계수기를 리셋한다.
        counter.value = 0;
        choices.add(candidateAnswer);
        seen.add(key);
      }
    }
  }
}

/// 두 슬롯 루프가 공유하는 계수기. 원본의 `int cutUnlimitLoop` 에 해당한다.
class _MismatchCounter {
  int value = 0;
}
