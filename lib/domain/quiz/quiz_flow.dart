/// 문제 화면 한 판의 진행 상태.
///
/// 문제 화면 4종(`problem_type1..4_page.dart`)이 **글자까지 똑같이** 복제해
/// 갖고 있던 상태 5개와 그 전이를 여기로 옮겼다. 옮기기 전 네 파일의
/// `nextProblem` / `wrongProblemNextProblem` / `showResult` /
/// `nextProblemResult` / `wrongProblemSolveStart` 를 나란히 놓고 비교했고,
/// **상태를 바꾸는 부분은 네 파일이 동일**했다. 달랐던 것은 "뽑은 문제를
/// 화면 필드에 적용하는" 유형별 블록(오선 배치·보기 생성)뿐이고, 그건 각
/// 화면에 그대로 남는다.
///
/// **위젯에 의존하지 않는다.** `setState` 도, `BuildContext` 도 모른다.
/// 화면은 이 객체를 고친 뒤 스스로 `setState` 를 부른다. 그래야 점수·오답
/// 노트·광고 경계를 위젯 없이 단위 테스트할 수 있다.
///
/// ## 상태
///
/// | | 뜻 |
/// |---|---|
/// | [problemNumber] | 지금 몇 번째 문제인가 (1부터) |
/// | [numberOfRight] | 이번 판에서 맞힌 개수 |
/// | [wrongProblemMode] | 오답 다시 풀기 판인가 |
/// | [wrongProblems] | 이번 판에서 틀린 문제들 (다음 판의 출제 목록 후보) |
/// | [wrongProblemsSave] | 오답 판에서 **출제 중인** 목록 |
///
/// ## 전이
///
/// ```
///                 recordCorrect / recordWrong
///                        ↓
///   [일반 모드] ──advanceToNextProblem──▶ [일반 모드]   (문제 10개까지)
///        │
///        │ hasNextProblem == false → 결과 화면
///        │
///        ├─ startNewStage() ─────────────▶ [일반 모드] 1번부터
///        ├─ startWrongProblemRound() ────▶ [오답 모드] 1번부터
///        └─ abandonStage() ──────────────▶ 화면을 떠난다
///
///   [오답 모드] ──advanceInWrongProblemRound──▶ [오답 모드]
///                                              (wrongProblemsSave.length 까지)
/// ```
///
/// 오답 판에서 맞힌 문제가 목록에서 "빠지는" 방식에 주의할 것. 목록에서
/// 지우는 것이 아니라, 판을 시작할 때 [wrongProblems] 를 통째로
/// [wrongProblemsSave] 로 옮기고 [wrongProblems] 를 비운 다음, **다시 틀린
/// 것만** 새로 담는다. 그래서 맞힌 것은 자연히 다음 판에 남지 않는다.
class QuizFlow {
  /// 일반 모드 한 판의 문제 수.
  static const int problemsPerStage = 10;

  int _numberOfRight = 0;
  bool _wrongProblemMode = false;
  int _problemNumber = 1;
  List<List<dynamic>> _wrongProblems = <List<dynamic>>[];
  List<List<dynamic>> _wrongProblemsSave = <List<dynamic>>[];

  /// 이번 판에서 맞힌 개수. 결과 화면의 점수가 이 값으로 계산된다.
  int get numberOfRight => _numberOfRight;

  /// 지금 오답 다시 풀기 판인가.
  bool get wrongProblemMode => _wrongProblemMode;

  /// 지금 몇 번째 문제인가. 1부터 센다.
  int get problemNumber => _problemNumber;

  /// 이번 판에서 틀린 문제들.
  ///
  /// **내부 리스트를 그대로 돌려준다** — `resultPage` 가 `List<List<dynamic>>`
  /// 를 그대로 받기 때문이다. 밖에서 고치지 말 것. 넣는 것은 [recordWrong],
  /// 비우는 것은 [startNewStage] · [startWrongProblemRound] · [abandonStage]
  /// 뿐이다.
  List<List<dynamic>> get wrongProblems => _wrongProblems;

  /// 오답 판에서 출제 중인 목록. 진행률의 분모이자 점수의 분모다.
  List<List<dynamic>> get wrongProblemsSave => _wrongProblemsSave;

  /// 지금 문제 다음에 낼 문제가 남아 있는가. 없으면 결과 화면으로 간다.
  ///
  /// 종전 화면 코드의
  /// `wrongProblemMode ? (wrongProblemsSave.length != problemNumber)
  ///                   : (problemNumber != 10)` 와 같은 식이다.
  bool get hasNextProblem => _wrongProblemMode
      ? _wrongProblemsSave.length != _problemNumber
      : _problemNumber != problemsPerStage;

  /// '틀린 문제 다시 풀기' 버튼을 누를 수 있는가.
  bool get canStartWrongProblemRound => _wrongProblems.isNotEmpty;

  /// 정답을 골랐다.
  void recordCorrect() {
    _numberOfRight += 1;
  }

  /// 오답을 골랐다. [problemRecord] 는 다시 낼 때 문제를 되살릴 재료다.
  ///
  /// 화면이 넘긴 리스트를 **복사하지 않고 그대로** 담는다. 종전과 같다 —
  /// 화면은 호출할 때마다 새 리스트를 만들어 넘긴다.
  void recordWrong(List<dynamic> problemRecord) {
    _wrongProblems.add(problemRecord);
  }

  /// 일반 모드에서 '다음문제'.
  ///
  /// 10번에서 부르면 1번으로 돌아간다. 종전 화면의
  /// `if (problemNumber == 10) problemNumber = 0;` 를 옮긴 것이다. 실제로는
  /// 10번에서 '다음문제' 대신 '결과보기' 가 나오므로 닿지 않는 길이지만,
  /// 옮기면서 없애지는 않았다.
  void advanceToNextProblem() {
    if (_problemNumber == problemsPerStage) {
      _problemNumber = 0;
    }
    _problemNumber += 1;
  }

  /// 오답 모드에서 '다음문제'.
  ///
  /// 다음에 낼 문제의 [wrongProblemsSave] 안 인덱스를 돌려준다.
  int advanceInWrongProblemRound() {
    _problemNumber += 1;
    return _problemNumber - 1;
  }

  /// 결과 화면의 '네' — 같은 유형으로 새 판을 시작한다.
  void startNewStage() {
    _numberOfRight = 0;
    _wrongProblems = <List<dynamic>>[];
    _wrongProblemMode = false;
    _problemNumber = 1;
  }

  /// 결과 화면의 '틀린 문제 다시 풀기'.
  ///
  /// 첫 문제의 [wrongProblemsSave] 안 인덱스(항상 0)를 돌려준다.
  ///
  /// 이번 판의 오답 목록을 출제 목록으로 옮기고, 오답 목록은 **새 리스트로**
  /// 갈아 끼운다. 종전 코드는 `wrongProblemsSave = wrongProblems` 로 별칭을
  /// 만든 뒤 `wrongProblems` 를 새 리스트로 갈아 끼워 결과적으로 안전했는데,
  /// 그건 다음 사람이 `wrongProblems.clear()` 로 바꾸는 순간 출제 목록까지
  /// 지워지는 잠복이다. 여기서는 얕은 복사로 끊는다 — 담긴 문제 자체는
  /// 종전처럼 공유한다.
  int startWrongProblemRound() {
    _numberOfRight = 0;
    _wrongProblemsSave = List<List<dynamic>>.of(_wrongProblems);
    _wrongProblems = <List<dynamic>>[];
    _problemNumber = 1;
    _wrongProblemMode = true;
    return 0;
  }

  /// 결과 화면에서 화면을 떠난다(목록으로 돌아간다).
  ///
  /// 문제 번호는 건드리지 않는다. 종전과 같다 — 화면이 곧 사라지므로 의미가
  /// 없다.
  void abandonStage() {
    _numberOfRight = 0;
    _wrongProblems = <List<dynamic>>[];
    _wrongProblemMode = false;
  }
}
