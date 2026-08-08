# P3-7: 문제 화면 4종 공통 껍데기 통합 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 문제 화면 4개(3,414줄)가 각자 복제해 갖고 있는 풀이 흐름·바텀시트·광고·결과 전환을 하나로 합쳐, 각 화면에는 "무엇을 그리는가"와 "정답이 무엇인가"만 남긴다.

**Architecture:** 한 번에 갈아엎지 않는다. **아래에서 위로** 세 겹을 차례로 뽑는다 — (1) 정답/오답 바텀시트, (2) 풀이 세션 상태기계, (3) 화면 껍데기. 각 겹은 독립적으로 되돌릴 수 있고, 각 겹이 끝날 때마다 유형 1에서 실기기로 확인한 뒤 나머지 3개로 확장한다. 위젯 트리를 재조립하는 마지막 겹이 가장 위험하므로 가장 마지막에 둔다.

**Tech Stack:** Flutter, provider(기존), flutter_screenutil, google_mobile_ads

**전제 조건:** Phase 3 Task 1~6 완료. 현재 `flutter analyze` 127 issues / 0 errors, `flutter test` 136/136.

---

## 착수 전 확인된 사실 (2026-08-05 실측)

**현재 규모**

```
problem_type1_page.dart    783줄
problem_type2_page.dart    838줄
problem_type3_page.dart    776줄
problem_type4_page.dart   1017줄
                          ─────
                          3,414줄
```

**네 파일이 모두 갖고 있는 것**

| | type1 | type2 | type3 | type4 |
|---|---|---|---|---|
| `showModalBottomSheet` | 3 | 3 | 3 | 3 |
| `wrongProblems` 참조 | 24 | 25 | 23 | 23 |
| `numberOfRight` 참조 | 6 | 6 | 6 | 6 |
| `criticalNumberSolved` | 1 | 1 | 1 | 1 |
| 전면광고 관련 | 6 | 6 | 6 | 6 |

**네 파일에 동일하게 복제된 메서드 7개**

`showBottomResult(...)` · `nextProblem(String, String)` · `showResult(String)` · `loadAd()` · `nextProblemResult()` · `wrongProblemNextProblem(String, String)` · `wrongProblemSolveStart(String)`

**동일한 상태 필드 3개**

```dart
int numberOfRight = 0;
bool wrongProblemMode = false;
List<List<dynamic>> wrongProblems = [];
```

**동일한 위젯 생성자**

```dart
final Function? problemCallFunction;
final String stageType;
final List<String>? problemTypes;
```

**실제로 다른 것은 두 가지뿐**

1. 문제 영역에 무엇을 그리는가 — 오선보 구성이 유형마다 다르다
2. 보기 버튼을 무엇으로 만드는가 — `List<String>`(1) / `String`(2) / `msc.Key`(3) / 코드 문자열(4)

**공통 진입점**

```dart
Widget resultPage(
  BuildContext context, bool wrongProblemMode, int numberOfRight,
  List<List<dynamic>> wrongProblemsSave, List<List<dynamic>> wrongProblems,
  Widget nextProblemResult, Widget wrongProblemSolveStart, onpressedNo,
)
```

---

## 테스트 전략

이 작업의 위험은 **로직이 아니라 레이아웃**이다. 여백이 밀리거나 악보가 잘리거나 버튼 위치가 틀어지는 것은 `flutter test` 로 잡히지 않는다. 그래서 세 층으로 방어한다.

### 1층 — 위젯 테스트 (자동, CI에서 매번)

Phase 3 Task 3 이후 **문제 화면을 `flutter test` 에서 띄울 수 있게 됐다.** `BannerAdSlot` 이 광고 단위 ID 가 null 인 플랫폼에서 빈 자리를 렌더하도록 바뀌었기 때문이다. 이 사실을 적극 활용한다.

각 겹마다 다음을 단언한다:

- 화면이 예외 없이 렌더된다 (`tester.takeException()` 이 null)
- 진행률 텍스트가 `N/10` 형태로 나온다
- 보기 버튼이 정확히 4개 있다
- 보기를 탭하면 바텀시트가 뜨고, 정답/오답 문구가 맞다
- "다음문제" 를 누르면 진행률이 1 증가한다
- 오답 모드에서 앱바 제목이 바뀐다

**중요:** 이 테스트들은 리팩토링 **전에** 작성해 현재 동작을 고정한다. 리팩토링 후에도 같은 테스트가 통과해야 한다. 통과하지 않으면 동작이 바뀐 것이다.

### 2층 — 위젯 트리 구조 스냅샷 (자동)

레이아웃 회귀를 잡는 저비용 수단. 골든 이미지 테스트는 폰트·플랫폼 의존이 커서 CI 에서 불안정하므로 쓰지 않는다. 대신 **위젯 트리의 구조를 문자열로 덤프해 비교**한다.

```dart
String dumpStructure(WidgetTester tester) {
  final buffer = StringBuffer();
  for (final e in tester.allElements) {
    final w = e.widget;
    // 레이아웃에 영향을 주는 위젯만 추린다.
    if (w is Column || w is Row || w is SizedBox || w is Padding ||
        w is Expanded || w is Container || w is Scaffold) {
      buffer.writeln('${'  ' * e.depth}${w.runtimeType}');
    }
  }
  return buffer.toString();
}
```

리팩토링 전 덤프를 파일로 저장하고, 후에 비교한다. **완전히 같을 필요는 없다** — 껍데기를 뽑으면 트리 깊이는 바뀐다. 대신 **`Column` 의 자식 순서와 개수, `SizedBox` 높이 값의 나열**이 같은지를 본다. 이건 여백이 밀렸는지를 정확히 잡는다.

### 3층 — 실기기 스크린샷 대조 (수동, 각 겹마다)

궁극적 검증. 각 겹이 끝날 때마다:

1. 리팩토링 **전** 커밋에서 빌드해 유형 1~4 각각 캡처 (라이트 모드)
2. 리팩토링 **후** 빌드해 같은 화면 캡처
3. 나란히 비교

기기: Galaxy Z Fold (SM-F966N, `RFCYA16V64L`), Android 16. 커버 화면 1080×2520 으로 캡처된다(내부 화면은 꺼져 있으면 검게 나온다).

**캡처할 화면 6종:**
- 홈 → 유형 N 진입 직후 (문제 1/10)
- 보기 탭 후 정답 바텀시트
- 보기 탭 후 오답 바텀시트
- 다음문제 진행 후 (2/10)
- 10문제 완료 후 결과 화면
- 오답 다시 풀기 진입 직후

**광고는 클릭하지 않는다.** `--dart-define` 없이 빌드하면 구글 테스트 광고가 뜨므로(Phase 3 Task 6) 안전하다.

### 회귀 판정 기준

- 1층 실패 → 동작 변경. 즉시 중단하고 원인 규명
- 2층 차이 → 여백·순서 변경 가능성. 3층으로 확인
- 3층 육안 차이 → 되돌리고 원인 규명

---

## File Structure

| 파일 | 책임 | 신규/수정 |
|---|---|---|
| `test/ui/quiz_page_behavior_test.dart` | 리팩토링 전 동작 고정 (1층) | 신규 · Task 1 |
| `test/ui/quiz_layout_snapshot_test.dart` | 위젯 트리 구조 비교 (2층) | 신규 · Task 1 |
| `lib/ui/quiz/widgets/answer_result_sheet.dart` | 정답/오답 바텀시트 | 신규 · Task 2 |
| `lib/domain/quiz/quiz_flow.dart` | 풀이 세션 상태기계 | 신규 · Task 3 |
| `lib/ui/quiz/quiz_page_scaffold.dart` | 화면 껍데기 | 신규 · Task 5 |
| `lib/ui/quiz/problem_type1..4_page.dart` | 각 겹마다 축소 | 수정 |

---

## Task 1: 리팩토링 전 동작을 테스트로 고정

**아무것도 리팩토링하기 전에** 현재 동작을 테스트로 못박는다. 이 테스트가 이후 모든 작업의 안전망이다.

**Files:**
- Create: `test/ui/quiz_page_behavior_test.dart`
- Create: `test/ui/quiz_layout_snapshot_test.dart`

- [ ] **Step 1: 문제 화면이 위젯 테스트에서 뜨는지 먼저 확인**

`lib/ui/quiz/problem_type1_page.dart` 를 `flutter test` 에서 pump 할 수 있는지 확인하는 최소 테스트를 쓴다. 필요한 것: `MaterialApp` + `AppTheme.light` + `ScreenUtilInit` + `ChangeNotifierProvider<CounterClass>`. 생성자는 `tonalityProblemType1(problemCallFunction, stageType, problemTypes: ...)` 이다.

```bash
flutter test test/ui/quiz_page_behavior_test.dart
```

**뜨지 않으면 여기서 멈추고 보고한다.** 무엇이 막는지(플랫폼 채널, Firebase, ScreenUtil 초기화 등)가 이후 모든 태스크의 전제를 바꾼다. 억지로 우회하지 말 것.

- [ ] **Step 2: 동작 고정 테스트 작성 (1층)**

유형 1에 대해 아래를 단언한다. `problemCallFunction` 은 실제 `getCustomProblemType` 을 넘긴다 — 결정적 입력이 필요하면 고정 문제를 반환하는 함수를 주입한다.

- 렌더 시 예외 없음
- 진행률 `0/10` 표시
- 보기 버튼 4개
- 보기 탭 → 바텀시트 등장, `정답입니다!` 또는 `오답입니다!` 중 하나
- 다음문제 탭 → 진행률 증가
- 앱바 제목이 `stageType` 과 일치

- [ ] **Step 3: 구조 스냅샷 테스트 작성 (2층)**

계획서 "테스트 전략" 의 `dumpStructure` 를 쓰되, **비교 대상은 `Column` 자식 순서와 `SizedBox` 높이 나열**로 좁힌다. 현재 값을 기대값으로 하드코딩한다.

- [ ] **Step 4: 두 테스트를 유형 2·3·4 로 확장**

같은 검사를 나머지 세 화면에도 적용한다. 유형마다 보기 버튼 위젯이 다르므로 찾는 방법이 달라진다 — 각 유형에 맞는 finder 를 쓴다.

- [ ] **Step 5: 전체 검증**

```bash
flutter analyze
flutter test
```

기대: analyze 0 errors, 기존 136개 + 새 테스트 전부 통과.

- [ ] **Step 6: 실기기 기준선 캡처**

```bash
flutter build apk --release
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

"테스트 전략 3층" 의 6종 화면을 유형 1~4 각각에 대해 캡처해 `docs/screenshots/before/` 에 보관한다. 이후 각 겹의 비교 기준이 된다.

- [ ] **Step 7: 커밋**

```bash
git add test/ docs/screenshots/
git commit -m "test: 문제 화면 4종의 현재 동작·레이아웃을 테스트로 고정 (P3-7 안전망)"
```

---

## Task 2: 정답/오답 바텀시트 추출

가장 작고 가장 안전한 겹. 4× 복제된 `showBottomResult` 의 **시트 UI 부분만** 뽑는다. 상태 변경 로직은 아직 건드리지 않는다.

**Files:**
- Create: `lib/ui/quiz/widgets/answer_result_sheet.dart`
- Modify: `lib/ui/quiz/problem_type1_page.dart`

- [ ] **Step 1: 네 화면의 시트를 나란히 놓고 실제 차이를 적는다**

```bash
for f in 1 2 3 4; do
  echo "=== type$f ==="
  awk '/void showBottomResult/,/^  [A-Za-z]/' lib/ui/quiz/problem_type${f}_page.dart | head -80
done
```

차이를 문서화한다. 배경색·문구·버튼은 같을 것이고, **정답을 무엇으로 표시하는가**만 다를 것이다. 예상과 다르면 그 차이를 보고한다.

- [ ] **Step 2: 실패하는 위젯 테스트 작성**

`AnswerResultSheet` 가 정답 모드에서 초록 배경 + `정답입니다!`, 오답 모드에서 분홍 배경 + `오답입니다!` 를 렌더하고, 주입된 정답 위젯을 표시하며, 버튼 콜백이 호출되는지 검사한다.

- [ ] **Step 3: 테스트 실패 확인**

```bash
flutter test test/ui/answer_result_sheet_test.dart
```

기대: FAIL — 파일 없음.

- [ ] **Step 4: `AnswerResultSheet` 구현**

정답 여부, 정답 표시 위젯, 하단 버튼 위젯을 받는다. 색은 `context.colors.correctSheetBackground` / `wrongSheetBackground` / `correctText` / `wrongText` 를 쓴다(Task 5에서 만든 것). **하드코딩된 색을 새로 넣지 않는다.**

- [ ] **Step 5: 유형 1을 새 시트로 교체**

`showBottomResult` 안의 `showModalBottomSheet` 두 벌(정답/오답)을 `AnswerResultSheet` 호출로 바꾼다. **상태 변경 코드(`setState`, `numberOfRight++`, `wrongProblems.add`)는 그대로 둔다.**

- [ ] **Step 6: 검증**

```bash
flutter analyze && flutter test
```

Task 1 의 동작 고정 테스트와 구조 스냅샷이 **모두 통과해야 한다.** 구조 스냅샷이 깨지면 시트 내부 레이아웃이 바뀐 것이니 원인을 찾는다.

- [ ] **Step 7: 실기기 확인 — 유형 1만**

빌드·설치 후 유형 1에서 정답·오답 시트를 각각 띄워 `docs/screenshots/before/` 와 대조한다.

- [ ] **Step 8: 커밋**

```bash
git commit -m "refactor(quiz): 정답/오답 바텀시트를 AnswerResultSheet 로 추출 (유형 1)"
```

- [ ] **Step 9: 유형 2·3·4 로 확장**

유형마다 따로 커밋한다. 각각 Step 6·7 을 반복한다.

---

## Task 3: 풀이 세션 상태기계 추출

가장 큰 이득. `numberOfRight`, `wrongProblems`, `wrongProblemMode` 와 그것을 다루는 전이 로직을 순수 Dart 클래스로 뽑는다. **위젯이 아니므로 단위 테스트가 쉽다.**

**Files:**
- Create: `lib/domain/quiz/quiz_flow.dart`
- Create: `test/quiz/quiz_flow_test.dart`
- Modify: `lib/ui/quiz/problem_type1_page.dart`

- [ ] **Step 1: 네 화면의 전이 로직을 읽고 상태기계를 그린다**

`nextProblem` / `wrongProblemNextProblem` / `showResult` / `nextProblemResult` / `wrongProblemSolveStart` 를 네 파일에서 모두 읽는다. **네 개가 정말 같은지 확인한다.** 다르면 그 차이가 의도된 것인지 복제 후 갈라진 것인지 판단하고 보고한다 — Phase 3 에서 이미 그런 사례(B1 오타)가 있었다.

상태기계를 문서화한다: 어떤 상태가 있고, 어떤 이벤트에 어떻게 전이하는가.

- [ ] **Step 2: 실패하는 단위 테스트 작성**

전이를 하나씩 단언한다. 최소한:

- 초기 상태: 푼 문제 0, 오답 없음, 일반 모드
- 정답 → 푼 문제 +1, 오답 목록 불변
- 오답 → 푼 문제 +1, 오답 목록 +1
- 10문제 도달 → 결과 상태
- 오답 다시 풀기 시작 → 오답 모드, 카운터 리셋, 오답 목록이 출제 목록이 됨
- 오답 모드에서 정답 → 해당 문제가 오답 목록에서 제거됨
- **`criticalNumberSolved`(20)마다 전면광고 신호** — 이 경계 조건을 정확히 확인할 것. 19, 20, 21 에서 각각 어떻게 되는가?

- [ ] **Step 3: 테스트 실패 확인 후 구현**

`QuizFlow` 를 만든다. `ChangeNotifier` 로 할지 순수 값 객체로 할지는 판단에 맡긴다 — **다만 위젯에 의존하지 않을 것.** 그래야 테스트가 쉽다.

- [ ] **Step 4: 유형 1을 `QuizFlow` 로 교체**

State 필드 3개를 `QuizFlow` 인스턴스 하나로 대체하고, 5개 메서드가 그것을 호출하도록 바꾼다. **버튼 위젯의 모양과 배치는 건드리지 않는다.**

- [ ] **Step 5: 검증**

```bash
flutter analyze && flutter test
```

Task 1 의 동작 고정 테스트가 통과해야 한다. **여기가 이 계획에서 가장 중요한 검증 지점이다** — 상태기계를 잘못 옮기면 점수가 틀리거나 오답노트가 새거나 전면광고가 매 문제마다 뜬다.

- [ ] **Step 6: 실기기 확인 — 한 스테이지 완주**

유형 1에서 **10문제를 전부 풀어** 결과 화면까지 간다. 그다음 "틀린 문제 다시 풀기" 를 눌러 오답 모드도 확인한다. 점수가 맞는지, 오답 개수가 맞는지 본다.

전면광고는 20문제째에 뜨므로 두 스테이지를 돌아야 확인된다. 여유가 되면 확인하고, 안 되면 그렇다고 보고한다.

- [ ] **Step 7: 커밋 후 유형 2·3·4 확장**

유형마다 따로 커밋. 각각 Step 5·6 반복.

---

## Task 4: 전면광고 트리거 통합

`loadAd()` 가 4× 복제돼 있다. Task 3 에서 `QuizFlow` 가 "지금 전면광고를 띄울 때인가" 를 알려주게 됐으므로, 광고를 **띄우는** 쪽만 뽑으면 된다.

**Files:**
- Modify: `lib/core/ads/interstitial_trigger.dart`
- Modify: `lib/ui/quiz/problem_type1..4_page.dart`

- [ ] **Step 1: 네 `loadAd()` 가 같은지 확인**

```bash
for f in 1 2 3 4; do
  awk '/void loadAd/,/^  }/' lib/ui/quiz/problem_type${f}_page.dart | md5
done
```

md5 가 모두 같으면 그대로 뽑는다. 다르면 차이를 보고한다.

- [ ] **Step 2: `interstitial_trigger.dart` 에 로드·표시 함수를 넣는다**

이 파일은 이미 `criticalNumberSolved` 를 갖고 있다. 광고 인스턴스의 수명주기(`dispose` 포함)를 반드시 처리한다 — **Phase 3 Task 3 에서 배너 광고가 해제되지 않아 누수되던 것과 같은 실수를 반복하지 않는다.**

- [ ] **Step 3: 네 화면에서 `loadAd()` 제거**

- [ ] **Step 4: 검증 후 커밋**

`grep -rn "InterstitialAd" lib/` 로 생성 사이트가 하나인지 확인한다.

---

## Task 5: 화면 껍데기 통합 — 가장 위험한 단계

여기서 위젯 트리를 재조립한다. **유형 1만 먼저 하고 실기기로 확인한 뒤** 나머지로 확장한다.

**Files:**
- Create: `lib/ui/quiz/quiz_page_scaffold.dart`
- Modify: `lib/ui/quiz/problem_type1_page.dart`

- [ ] **Step 1: 네 `build()` 의 최상위 `Column` 자식을 나열해 비교한다**

```bash
for f in 1 2 3 4; do
  echo "=== type$f build 최상위 구조 ==="
  awk '/Widget build\(BuildContext/,0' lib/ui/quiz/problem_type${f}_page.dart | grep -nE "^\s{10}[A-Z][A-Za-z]*\(|^\s{10}const " | head -20
done
```

**같은 순서·같은 여백인지 확인한다.** 다르면 껍데기에 매개변수로 노출할지, 아니면 각 화면에 남길지 판단한다.

- [ ] **Step 2: `QuizPageScaffold` 구현**

받는 것: 앱바 제목, 오답 모드 여부, 진행률(푼 개수/전체), 문제 영역 빌더, 보기 영역 빌더.

**여백을 새로 정하지 않는다.** Step 1 에서 읽은 현재 값을 그대로 옮긴다. `SizedBox(height: N.h)` 하나하나가 현재 화면과 같아야 한다.

- [ ] **Step 3: 유형 1을 껍데기로 교체**

기존 `build()` 안의 오선보 부분과 보기 버튼 부분을 각각 private 메서드로 뽑아 빌더로 넘긴다.

- [ ] **Step 4: 구조 스냅샷 비교 — 여기가 핵심**

```bash
flutter test test/ui/quiz_layout_snapshot_test.dart
```

**깨지는 것이 정상이다** — 껍데기를 뽑으면 트리 깊이가 바뀐다. 중요한 것은 **`SizedBox` 높이 나열과 `Column` 자식 순서가 같은가**이다. 스냅샷 테스트를 그 기준으로 갱신하되, **갱신 전에 반드시 육안으로 확인**한다. 테스트를 통과시키려고 기대값을 바꾸는 것은 이 태스크에서 가장 위험한 행동이다.

- [ ] **Step 5: 실기기 확인 — 유형 1 전체**

`docs/screenshots/before/` 의 유형 1 캡처 6종과 하나씩 대조한다. **하나라도 어긋나면 여기서 멈춘다.** 나머지 유형으로 넘어가면 원인 추적이 어려워진다.

- [ ] **Step 6: 커밋**

```bash
git commit -m "refactor(quiz): 유형 1을 QuizPageScaffold 로 이전"
```

- [ ] **Step 7~9: 유형 2 → 3 → 4 순차 이전**

각각 Step 4·5 를 반복하고 따로 커밋한다. **한 유형이 끝날 때마다 실기기로 확인한다.**

---

## Task 6: 마무리 및 규모 확인

- [ ] **Step 1: 줄 수 비교**

```bash
wc -l lib/ui/quiz/problem_type*_page.dart
```

기준: 3,414줄. 눈에 띄게 줄지 않았다면 공통화가 제대로 되지 않은 것이다.

- [ ] **Step 2: 남은 중복 확인**

```bash
for k in showModalBottomSheet wrongProblems numberOfRight criticalNumberSolved InterstitialAd; do
  echo "$k:"
  grep -c "$k" lib/ui/quiz/problem_type*_page.dart
done
```

- [ ] **Step 3: 전체 검증**

```bash
flutter clean && flutter pub get
flutter analyze
flutter test
flutter build appbundle --release
```

- [ ] **Step 4: 실기기 최종 회귀 — 4개 유형 × 6종 화면**

`docs/screenshots/before/` 전체와 대조한다.

- [ ] **Step 5: 커밋 및 CI 확인**

---

## 완료 기준

- [ ] `flutter analyze` 0 errors
- [ ] `flutter test` — Task 1 의 동작 고정 테스트 포함 전부 통과
- [ ] 문제 화면 4개 합계가 3,414줄에서 유의미하게 감소
- [ ] `showBottomResult` / `loadAd` / 상태 필드 3개가 각 화면에서 사라짐
- [ ] 실기기에서 4개 유형 × 6종 화면이 리팩토링 전과 동일
- [ ] CI 초록불

---

## 이 계획에서 의도적으로 하지 않는 것

- **`problem_type4_page.dart` 의 `typeFourProblemCreator` 제자리 변형(B5) 수정** — 별개 결함이며 이 리팩토링과 섞으면 원인 추적이 어려워진다.
- **보기 버튼 위젯의 통합** — 유형마다 타입이 달라(`List<String>` / `String` / `msc.Key` / 코드 문자열) 제네릭으로 묶으면 오히려 읽기 어려워진다. 각 화면에 남긴다.
- **오선보 렌더링 코드의 통합** — 유형마다 그리는 것이 실제로 다르다. 공통 부분이 있는지는 이 작업이 끝난 뒤 다시 본다.
- **클래스명 `tonalityProblemTypeN` 개명** — 소문자 시작이라 Dart 관례에 어긋나지만, 개명은 diff 를 부풀리기만 하고 이 작업의 목적과 무관하다.
