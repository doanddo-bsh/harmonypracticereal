# Phase 3: 리팩토링 및 디자인 현대화 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 13,000줄에 흩어진 중복·전역 상태를 domain/data/ui 3계층으로 정리하고, 하드코딩된 색상표를 Material 3 테마 시스템으로 승격해 다크모드를 지원한다. 화면 흐름과 문제 내용은 그대로 유지한다.

**Architecture:** Provider(ChangeNotifier)를 유지한 채 레이어만 가른다. `harmonyModul/` 의 순수 화성 로직은 `domain/harmony/` 로, 위젯 안에 박혀 있던 오답 보기 생성·풀이 세션 상태는 `domain/quiz/` 로 끌어낸다. `problemType1~4` 의 공통 껍데기(광고 배너 수명주기·정답 바텀시트·오답노트 누적·전면광고 트리거)는 `QuizPageScaffold` 하나로 합치고, 각 유형은 "무엇을 보여주고 무엇을 정답으로 치는지"만 남긴다. `colorList.dart` 의 전역 `Color` 변수 17개는 `ThemeExtension` 으로 옮겨 라이트/다크 두 벌을 만든다.

**Tech Stack:** Flutter Material 3, provider 6.x, flutter_screenutil, music_notes

**전제 조건:** Phase 1 완료(analyze error 0, 불변식 테스트 존재). Phase 2 완료 권장 — CI가 각 태스크의 회귀를 잡아준다.

---

## 이 단계에서 고치는 실제 버그 3건

리팩토링 중 발견된, 지금 사용자에게 영향이 있는 결함이다. 각각 테스트를 먼저 쓰고 고친다.

| # | 위치 | 증상 |
|---|---|---|
| B1 | `lib/page/problem/problemType1.dart:235` | 문제 이름 대소문자 오타 `'Dominant7thProblem'` — 엔진은 `'dominant7thProblem'` 을 반환한다. 속7화음 문제일 때 오답 보기가 의도와 다른 규칙으로 생성된다 (`problemType4.dart:259` 는 올바름) |
| B2 | `problemType1~4` 전체 | `initState` 에서 `BannerAd` 를 만들지만 `dispose()` 를 오버라이드하지 않는다. 문제 화면을 드나들 때마다 네이티브 배너 광고 객체가 누수된다 |
| B3 | `lib/harmonyModul/modulBasic.dart:92` / `modulBasicMinor.dart:90` | `getOneToSeven()` 이 동일 이름으로 두 파일에 중복 정의. 두 파일을 함께 import하는 곳에서 어느 쪽이 쓰이는지 불명확 |

---

## File Structure

목표 구조. 화살표는 이동을 뜻한다.

```
lib/
  main.dart                          진입점 (초기화만)
  app.dart                           MaterialApp + 테마 + Provider 등록      [신규]

  core/
    theme/
      app_colors.dart                ThemeExtension 정의 (라이트/다크)      [신규] ← colorList.dart
      app_theme.dart                 ThemeData 조립                        [신규]
    ads/
      ad_ids.dart                    광고 단위 ID (dart-define 주입)        ← admobClass.dart
      banner_ad_slot.dart            배너 위젯 + 수명주기 (B2 수정)          [신규]
      interstitial_trigger.dart      N문제마다 전면광고                     ← admobFunc.dart
    consent/
      consent_service.dart           UMP 동의                              ← initialization_helper.dart

  domain/
    harmony/
      tonality_source.dart           getOneToSeven / getOneToSix (B3 수정)  [신규 · Task 4]
      major_problems.dart            ← modulBasic.dart
      minor_problems.dart            ← modulBasicMinor.dart
      borrowed_problems.dart         ← modulBorrowed.dart
      problem_catalog.dart           난이도별 출제 확률 + 4성부 배치 계산     ← modulProblemProbability.dart
    quiz/
      distractor_generator.dart      오답 보기 생성 (B1 수정)               [신규]
      quiz_session.dart              풀이 세션 상태 (ChangeNotifier)        ← providerCounter.dart

  ui/
    loading/loading_page.dart        ← page/loadingPage.dart
    home/
      home_page.dart                 ← page/firstPageProblemTypeList.dart
      widgets/
        chord_type_selector.dart     ← page/problemFunc/multiDropDown.dart
    quiz/
      quiz_page_scaffold.dart        4개 유형 공통 껍데기                   [신규]
      problem_type1_page.dart        ← page/problem/problemType1.dart
      problem_type2_page.dart        ← page/problem/problemType2.dart
      problem_type3_page.dart        ← page/problem/problemType3.dart
      problem_type4_page.dart        ← page/problem/problemType4.dart
      widgets/
        staff_view.dart              오선보 렌더링                          ← problemFuncHarmony.dart
        answer_sheet.dart            정답/오답 바텀시트                     [신규]
        note_glyphs.dart             음표·조표 그리기 부품                   ← problemFuncDeco.dart
      result_page.dart               ← page/problemFunc/resultPage.dart
    settings/settings_page.dart      ← page/settingPage/settingPage.dart

test/
  harmony/harmony_engine_invariant_test.dart   (Phase 1에서 생성)
  quiz/distractor_generator_test.dart          [신규]
  quiz/quiz_session_test.dart                  [신규]
  ui/quiz_page_scaffold_test.dart              [신규]
  ui/theme_test.dart                           [신규]
```

**순서가 중요하다.** 태스크 1(기계적 이동)을 먼저 해야 이후 태스크의 diff가 읽힌다. 이동과 로직 변경을 한 커밋에 섞으면 리뷰가 불가능해진다.

---

## Task 1: 파일 이동 및 snake_case 개명 (로직 변경 없음)

**Files:** `lib/` 전체 이동. 내용 변경은 import 경로 수정만.

**철칙: 이 태스크에서는 파일 내용의 로직을 단 한 줄도 바꾸지 않는다.** import 경로와 파일명만 바꾼다.

- [ ] **Step 1: 브랜치 생성 및 기준선 기록**

```bash
cd /Users/s.bark/Downloads/A001_project/A006_harmony_proctice
git checkout -b phase3/refactor
flutter analyze 2>&1 | tail -3
flutter test 2>&1 | tail -3
```

두 출력을 메모한다. 이 태스크가 끝난 뒤 **똑같아야** 한다.

- [ ] **Step 2: 디렉터리 생성**

```bash
mkdir -p lib/core/{theme,ads,consent} \
         lib/domain/{harmony,quiz} \
         lib/data \
         lib/ui/{loading,home/widgets,quiz/widgets,settings}
```

- [ ] **Step 3: git mv 로 파일 이동**

```bash
# domain/harmony
git mv lib/harmonyModul/modulBasic.dart              lib/domain/harmony/major_problems.dart
git mv lib/harmonyModul/modulBasicMinor.dart         lib/domain/harmony/minor_problems.dart
git mv lib/harmonyModul/modulBorrowed.dart           lib/domain/harmony/borrowed_problems.dart
git mv lib/harmonyModul/modulProblemProbability.dart lib/domain/harmony/problem_catalog.dart

# domain/quiz
git mv lib/page/problemFunc/providerCounter.dart     lib/domain/quiz/quiz_session.dart

# core
git mv lib/page/problemFunc/colorList.dart           lib/core/theme/app_colors.dart
git mv lib/page/problemFunc/admobClass.dart          lib/core/ads/ad_ids.dart
git mv lib/page/problemFunc/admobFunc.dart           lib/core/ads/interstitial_trigger.dart
git mv lib/page/settingPage/initialization_helper.dart lib/core/consent/consent_service.dart

# ui
git mv lib/page/loadingPage.dart                     lib/ui/loading/loading_page.dart
git mv lib/page/firstPageProblemTypeList.dart        lib/ui/home/home_page.dart
git mv lib/page/problemFunc/multiDropDown.dart       lib/ui/home/widgets/chord_type_selector.dart
git mv lib/page/problem/problemType1.dart            lib/ui/quiz/problem_type1_page.dart
git mv lib/page/problem/problemType2.dart            lib/ui/quiz/problem_type2_page.dart
git mv lib/page/problem/problemType3.dart            lib/ui/quiz/problem_type3_page.dart
git mv lib/page/problem/problemType4.dart            lib/ui/quiz/problem_type4_page.dart
git mv lib/page/problemFunc/problemFuncHarmony.dart  lib/ui/quiz/widgets/staff_view.dart
git mv lib/page/problemFunc/problemFuncDeco.dart     lib/ui/quiz/widgets/note_glyphs.dart
git mv lib/page/problemFunc/problemFunc.dart         lib/ui/quiz/widgets/staff_geometry.dart
git mv lib/page/problemFunc/problemVarList.dart      lib/ui/quiz/widgets/note_tables.dart
git mv lib/page/problemFunc/resultPage.dart          lib/ui/quiz/result_page.dart
git mv lib/page/settingPage/settingPage.dart         lib/ui/settings/settings_page.dart
git mv lib/page/settingPage/initialize_screen.dart   lib/ui/loading/initialize_screen.dart

# 사용처 없는 실험 파일 제거
git rm lib/page/testPage1.dart

# 빈 디렉터리 정리
rmdir lib/harmonyModul lib/page/problem lib/page/problemFunc lib/page/settingPage lib/page 2>/dev/null || true
```

- [ ] **Step 4: 깨진 import 확인**

```bash
flutter analyze 2>&1 | grep -c "error"
flutter analyze 2>&1 | grep "error" | head -20
```

`Target of URI doesn't exist` 오류가 대량으로 나오는 게 정상이다. 다음 스텝에서 고친다.

- [ ] **Step 5: import 경로 일괄 치환**

```bash
cd lib
# 이전 상대경로들을 패키지 절대경로로 통일한다. 상대경로는 파일이 옮겨질 때마다 깨진다.
grep -rl "import '" . | while read -r f; do
  sed -i '' \
    -e "s|import '.*modulBasic\.dart'|import 'package:harmonypracticereal/domain/harmony/major_problems.dart'|g" \
    -e "s|import '.*modulBasicMinor\.dart'|import 'package:harmonypracticereal/domain/harmony/minor_problems.dart'|g" \
    -e "s|import '.*modulBorrowed\.dart'|import 'package:harmonypracticereal/domain/harmony/borrowed_problems.dart'|g" \
    -e "s|import '.*modulProblemProbability\.dart'|import 'package:harmonypracticereal/domain/harmony/problem_catalog.dart'|g" \
    -e "s|import '.*providerCounter\.dart'|import 'package:harmonypracticereal/domain/quiz/quiz_session.dart'|g" \
    -e "s|import '.*colorList\.dart'|import 'package:harmonypracticereal/core/theme/app_colors.dart'|g" \
    -e "s|import '.*admobClass\.dart'|import 'package:harmonypracticereal/core/ads/ad_ids.dart'|g" \
    -e "s|import '.*admobFunc\.dart'|import 'package:harmonypracticereal/core/ads/interstitial_trigger.dart'|g" \
    -e "s|import '.*initialization_helper\.dart'|import 'package:harmonypracticereal/core/consent/consent_service.dart'|g" \
    -e "s|import '.*loadingPage\.dart'|import 'package:harmonypracticereal/ui/loading/loading_page.dart'|g" \
    -e "s|import '.*firstPageProblemTypeList\.dart'|import 'package:harmonypracticereal/ui/home/home_page.dart'|g" \
    -e "s|import '.*multiDropDown\.dart'|import 'package:harmonypracticereal/ui/home/widgets/chord_type_selector.dart'|g" \
    -e "s|import '.*problemType1\.dart'|import 'package:harmonypracticereal/ui/quiz/problem_type1_page.dart'|g" \
    -e "s|import '.*problemType2\.dart'|import 'package:harmonypracticereal/ui/quiz/problem_type2_page.dart'|g" \
    -e "s|import '.*problemType3\.dart'|import 'package:harmonypracticereal/ui/quiz/problem_type3_page.dart'|g" \
    -e "s|import '.*problemType4\.dart'|import 'package:harmonypracticereal/ui/quiz/problem_type4_page.dart'|g" \
    -e "s|import '.*problemFuncHarmony\.dart'|import 'package:harmonypracticereal/ui/quiz/widgets/staff_view.dart'|g" \
    -e "s|import '.*problemFuncDeco\.dart'|import 'package:harmonypracticereal/ui/quiz/widgets/note_glyphs.dart'|g" \
    -e "s|import '.*problemFunc\.dart'|import 'package:harmonypracticereal/ui/quiz/widgets/staff_geometry.dart'|g" \
    -e "s|import '.*problemVarList\.dart'|import 'package:harmonypracticereal/ui/quiz/widgets/note_tables.dart'|g" \
    -e "s|import '.*resultPage\.dart'|import 'package:harmonypracticereal/ui/quiz/result_page.dart'|g" \
    -e "s|import '.*settingPage\.dart'|import 'package:harmonypracticereal/ui/settings/settings_page.dart'|g" \
    -e "s|import '.*initialize_screen\.dart'|import 'package:harmonypracticereal/ui/loading/initialize_screen.dart'|g" \
    "$f"
done
cd ..
```

> `problemFunc.dart` 치환 규칙은 `problemFuncHarmony.dart` / `problemFuncDeco.dart` 보다 **뒤에** 와야 한다. sed는 위에서부터 적용되므로 위 순서를 그대로 지킬 것.

- [ ] **Step 6: 남은 오류 수동 정리**

```bash
flutter analyze 2>&1 | grep "error" | head -30
```

남는 오류는 보통 다음 두 가지다:
- 주석 처리된 import 가 치환되며 이상해진 경우 → 해당 줄 삭제
- 위 목록에 없는 상대경로 → 해당 파일을 열어 `package:harmonypracticereal/...` 로 직접 수정

**error 0이 될 때까지 반복한다.**

- [ ] **Step 7: 테스트 import 경로도 갱신**

`test/harmony/harmony_engine_invariant_test.dart` 의 import 3줄을 교체:

```dart
import 'package:harmonypracticereal/domain/harmony/major_problems.dart';
import 'package:harmonypracticereal/domain/harmony/minor_problems.dart';
import 'package:harmonypracticereal/domain/harmony/problem_catalog.dart';
```

- [ ] **Step 8: 기준선과 동일한지 확인**

```bash
flutter analyze 2>&1 | tail -3
flutter test
```

기대: Step 1에서 메모한 것과 **error 0 동일**, 테스트 전부 PASS.
`file_names` 린트 경고는 사라졌을 것이다 (모두 snake_case가 되었으므로). `analysis_options.yaml` 의 `file_names: ignore` 줄을 지운다:

```yaml
analyzer:
  errors:
    non_constant_identifier_names: warning
    deprecated_member_use: warning
```

- [ ] **Step 9: 앱이 실제로 뜨는지 확인**

```bash
flutter run
```

로딩 → 홈 → 문제 유형 1~4 각각 1문제씩 풀기까지 확인한다.

- [ ] **Step 10: 커밋**

```bash
git add -A
git commit -m "refactor: 파일 구조를 core/domain/data/ui 계층으로 재배치 (로직 변경 없음)"
```

---

## Task 2: 오답 보기 생성기 추출 및 B1 버그 수정

**Files:**
- Create: `lib/domain/quiz/distractor_generator.dart`
- Create: `test/quiz/distractor_generator_test.dart`
- Modify: `lib/ui/quiz/problem_type1_page.dart` (`getViewListEasyType1` 제거)
- Modify: `lib/ui/quiz/problem_type4_page.dart` (`getViewListEasyType4` 제거)

**배경:** 오답 보기(distractor) 생성은 순수 로직인데 위젯 State 안에 들어 있어 테스트가 불가능하다. 여기에 B1 버그가 숨어 있다.

`problem_type1_page.dart` 의 `th7ProblemList` 마지막 항목이 `'Dominant7thProblem'` (대문자 D)인데, `major_problems.dart:460` 은 `'dominant7thProblem'` (소문자 d)을 반환한다. 따라서 **속7화음 문제에서는 "7화음 계열" 판정이 실패**하고, 3화음용 오답 규칙이 적용된다.

- [ ] **Step 1: 실패하는 테스트 작성**

`test/quiz/distractor_generator_test.dart` 를 생성:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:harmonypracticereal/domain/quiz/distractor_generator.dart';

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

  group('isTriadProblem', () {
    test('3화음 문제만 참이다', () {
      expect(DistractorGenerator.isTriadProblem('basicProblem'), isTrue);
      expect(DistractorGenerator.isTriadProblem('basicProblemMinor'), isTrue);
      expect(DistractorGenerator.isTriadProblem('dominant7thProblem'), isFalse);
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
  });
}
```

- [ ] **Step 2: 테스트 실행해 실패 확인**

```bash
flutter test test/quiz/distractor_generator_test.dart
```

기대: FAIL — `Target of URI doesn't exist: 'package:harmonypracticereal/domain/quiz/distractor_generator.dart'`

- [ ] **Step 3: 구현 작성**

`lib/domain/quiz/distractor_generator.dart` 를 생성:

```dart
/// 문제 하나에 대한 오답 보기(distractor)를 만든다.
///
/// 위젯에서 분리한 순수 로직이다. 후보를 뽑는 방법은 [drawCandidate] 로
/// 주입받으므로 테스트에서 난수 없이 결정적으로 검증할 수 있다.
class DistractorGenerator {
  DistractorGenerator._();

  /// 화성 엔진이 3화음 문제에 붙이는 이름.
  static const triadProblemNames = <String>{
    'basicProblem',
    'basicProblemMinor',
  };

  /// 화성 엔진이 7화음 계열 문제에 붙이는 이름.
  ///
  /// 여기 값은 `lib/domain/harmony/` 의 각 함수가 반환하는 다섯 번째 요소와
  /// 글자 하나까지 같아야 한다. 과거 'Dominant7thProblem' 오타로 속7화음이
  /// 3화음 규칙을 타던 버그가 있었다.
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

  /// 후보를 다시 뽑는 최대 횟수. 이 횟수를 넘기면 종류를 가리지 않고 채운다.
  static const _maxRedrawsPerSlot = 6;

  /// 정답 1개 + 오답 3개, 총 4개 보기를 만든다.
  ///
  /// 3화음 문제면 오답 2개는 3화음에서, 1개는 7화음에서 뽑는다.
  /// 7화음 문제면 반대로 오답 2개는 7화음에서, 1개는 3화음에서 뽑는다.
  ///
  /// [drawCandidate] 는 (정답문자열9칸, 문제이름) 쌍을 반환해야 한다.
  static List<List<String>> buildChoices({
    required List<String> answer,
    required String problemName,
    required (List<String>, String) Function() drawCandidate,
  }) {
    final choices = <List<String>>[answer];
    final seen = <String>{answer.join(',')};

    final answerIsTriad = isTriadProblem(problemName);

    // 같은 종류에서 2개, 다른 종류에서 1개.
    _fillSlots(
      choices: choices,
      seen: seen,
      targetCount: 3,
      wantTriad: answerIsTriad,
      drawCandidate: drawCandidate,
    );
    _fillSlots(
      choices: choices,
      seen: seen,
      targetCount: 4,
      wantTriad: !answerIsTriad,
      drawCandidate: drawCandidate,
    );

    return choices;
  }

  static void _fillSlots({
    required List<List<String>> choices,
    required Set<String> seen,
    required int targetCount,
    required bool wantTriad,
    required (List<String>, String) Function() drawCandidate,
  }) {
    var redraws = 0;

    while (choices.length < targetCount) {
      final (candidateAnswer, candidateName) = drawCandidate();
      final key = candidateAnswer.join(',');

      if (seen.contains(key)) {
        redraws++;
        // 후보 풀이 좁아 계속 같은 값만 나오면 이 슬롯을 포기한다.
        // 포기하지 않으면 무한루프가 된다.
        if (redraws > _maxRedrawsPerSlot * 3) return;
        continue;
      }

      final matchesWantedKind =
          wantTriad ? isTriadProblem(candidateName) : isSeventhChordProblem(candidateName);

      if (matchesWantedKind || redraws >= _maxRedrawsPerSlot) {
        choices.add(candidateAnswer);
        seen.add(key);
        redraws = 0;
      } else {
        redraws++;
      }
    }
  }
}
```

- [ ] **Step 4: 테스트 통과 확인**

```bash
flutter test test/quiz/distractor_generator_test.dart
```

기대: 모든 테스트 PASS.

- [ ] **Step 5: problem_type1_page.dart를 새 생성기로 교체**

`lib/ui/quiz/problem_type1_page.dart` 의 `getViewListEasyType1` 메서드 전체(219~약 350줄)를 삭제하고 아래로 대체:

```dart
  List<List<String>> getViewListEasyType1(
      List<String> answer, String problemName) {
    return DistractorGenerator.buildChoices(
      answer: answer,
      problemName: problemName,
      drawCandidate: () {
        final candidate = widget.problemCallFunction!(widget.problemTypes)
            as (List<String>, List<msc.Note>, msc.Tonality, List<msc.Note>, String);
        return (candidate.$1, candidate.$5);
      },
    );
  }
```

파일 상단에 import 추가:

```dart
import 'package:harmonypracticereal/domain/quiz/distractor_generator.dart';
```

- [ ] **Step 6: 검증**

```bash
flutter analyze 2>&1 | tail -3
flutter test
flutter run
```

`flutter run` 후 **문제 유형 1의 hard 탭에서 속7화음 문제**를 여러 번 풀며 보기 4개가 매번 서로 다른지, 정답이 항상 보기 안에 있는지 확인한다. (B1 수정 효과 확인)

- [ ] **Step 7: 커밋**

```bash
git add lib/domain/quiz/distractor_generator.dart test/quiz/ lib/ui/quiz/problem_type1_page.dart
git commit -m "fix: 오답 보기 생성기 추출 및 문제 이름 대소문자 오타 수정 (B1)"
```

---

## Task 3: 배너 광고 수명주기 위젯화 및 B2 누수 수정

**Files:**
- Create: `lib/core/ads/banner_ad_slot.dart`
- Create: `test/ui/banner_ad_slot_test.dart`
- Modify: `lib/ui/quiz/problem_type1_page.dart` ~ `problem_type4_page.dart` (`_banner`, `_createBannerAd` 제거)
- Modify: `lib/ui/home/home_page.dart` (동일)

**배경(B2):** 네 개의 문제 화면 모두 `initState` 에서 `BannerAd(...)..load()` 를 만들지만 `dispose()` 를 오버라이드하지 않는다. 화면을 나갈 때 네이티브 광고 객체가 해제되지 않아 문제 화면을 반복해서 드나들면 누적된다.

- [ ] **Step 1: 실패하는 테스트 작성**

`test/ui/banner_ad_slot_test.dart` 를 생성:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:harmonypracticereal/core/ads/banner_ad_slot.dart';

void main() {
  testWidgets('광고를 못 만들면 빈 자리만 차지하고 앱은 계속 그려진다',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text('본문'),
              // 테스트 환경에는 AdMob 네이티브 채널이 없으므로 null 이 온다.
              BannerAdSlot(banner: null),
            ],
          ),
        ),
      ),
    );

    expect(find.text('본문'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('위젯이 사라질 때 넘겨받은 광고를 해제한다', (tester) async {
    var disposed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BannerAdSlot(
            banner: null,
            onDispose: () => disposed = true,
          ),
        ),
      ),
    );

    // 다른 화면으로 교체하면 State.dispose 가 불린다.
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('다른 화면'))),
    );

    expect(disposed, isTrue, reason: 'dispose 콜백이 반드시 호출돼야 한다');
  });

  test('배너 높이는 AdSize.banner 와 같다', () {
    expect(BannerAdSlot.slotHeight, AdSize.banner.height.toDouble());
  });
}
```

- [ ] **Step 2: 테스트 실행해 실패 확인**

```bash
flutter test test/ui/banner_ad_slot_test.dart
```

기대: FAIL — `banner_ad_slot.dart` 없음.

- [ ] **Step 3: 구현 작성**

`lib/core/ads/banner_ad_slot.dart` 를 생성:

```dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 배너 광고 자리.
///
/// 광고가 아직 안 붙었거나 로드에 실패해도 같은 높이를 유지하므로
/// 광고 유무에 따라 화면이 흔들리지 않는다.
///
/// 이 위젯이 사라질 때 [banner] 를 해제한다. 예전에는 각 문제 화면이
/// BannerAd 를 만들기만 하고 dispose 하지 않아 누수가 있었다.
class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({
    required this.banner,
    this.onDispose,
    super.key,
  });

  final BannerAd? banner;

  /// 테스트에서 해제 시점을 관찰하기 위한 훅.
  final VoidCallback? onDispose;

  static double get slotHeight => AdSize.banner.height.toDouble();

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  @override
  void dispose() {
    widget.banner?.dispose();
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banner = widget.banner;

    return SizedBox(
      height: BannerAdSlot.slotHeight,
      width: double.infinity,
      child: banner == null ? const SizedBox.shrink() : AdWidget(ad: banner),
    );
  }
}
```

- [ ] **Step 4: 테스트 통과 확인**

```bash
flutter test test/ui/banner_ad_slot_test.dart
```

기대: 3개 모두 PASS.

- [ ] **Step 5: 문제 화면 4개에서 배너 코드 교체**

`lib/ui/quiz/problem_type1_page.dart` ~ `problem_type4_page.dart` 각각에 대해:

(a) 상단 import 추가:
```dart
import 'package:harmonypracticereal/core/ads/banner_ad_slot.dart';
```

(b) `_createBannerAd()` 메서드는 그대로 두되, `dispose` 를 추가한다. State 클래스 안, `build` 메서드 바로 위에 삽입:

```dart
  @override
  void dispose() {
    _banner?.dispose();
    _banner = null;
    super.dispose();
  }
```

(c) `build` 안에서 `AdWidget(ad: _banner!)` 를 쓰는 부분을 찾아 교체한다. 먼저 위치를 확인:

```bash
grep -n "AdWidget" lib/ui/quiz/problem_type*.dart lib/ui/home/home_page.dart
```

각 위치의 `AdWidget(ad: _banner!)` 를 감싸고 있는 `SizedBox`/`Container` 통째로 아래로 바꾼다:

```dart
BannerAdSlot(banner: _banner),
```

> `_banner!` 의 `!` 때문에 광고 로드 전에 화면이 그려지면 크래시가 날 수 있다. `BannerAdSlot` 은 null 을 받아도 안전하므로 이 교체가 그 위험도 함께 없앤다.

- [ ] **Step 6: home_page.dart도 동일하게 처리**

```bash
grep -n "_banner\|AdWidget\|dispose" lib/ui/home/home_page.dart | head -20
```

`home_page.dart` 는 이미 `dispose` 가 있다(탭 컨트롤러용). 그 안에 `_banner?.dispose();` 한 줄을 추가하고, `AdWidget` 사용부를 `BannerAdSlot(banner: _banner)` 로 바꾼다.

- [ ] **Step 7: 누수가 없는지 확인**

```bash
grep -n "BannerAd(" lib/ | wc -l
grep -rn "_banner?.dispose()" lib/ | wc -l
```

기대: 두 숫자가 같다 (배너를 만드는 곳마다 해제하는 곳이 있다).

- [ ] **Step 8: 검증**

```bash
flutter analyze 2>&1 | tail -3
flutter test
flutter run --profile
```

`flutter run --profile` 상태에서 DevTools 메모리 탭을 열고, 문제 화면을 10번 들락날락한 뒤 `BannerAd` 인스턴스 수가 늘어나지 않는지 확인한다.

- [ ] **Step 9: 커밋**

```bash
git add lib/core/ads/banner_ad_slot.dart test/ui/banner_ad_slot_test.dart lib/ui/
git commit -m "fix: 배너 광고 수명주기를 BannerAdSlot으로 통합, 미해제 누수 수정 (B2)"
```

---

## Task 4: getOneToSeven 중복 제거 (B3)

**Files:**
- Create: `lib/domain/harmony/tonality_source.dart`
- Modify: `lib/domain/harmony/major_problems.dart:92-102` (삭제)
- Modify: `lib/domain/harmony/minor_problems.dart:90-110` (삭제)
- Create: `test/harmony/tonality_source_test.dart`

- [ ] **Step 1: 두 정의가 실제로 같은지 확인**

```bash
sed -n '92,102p' lib/domain/harmony/major_problems.dart
sed -n '90,110p' lib/domain/harmony/minor_problems.dart
```

두 `getOneToSeven()` 의 본문을 눈으로 대조한다. **다르면 이 태스크를 건너뛰고** 대신 `minor_problems.dart` 쪽을 `getOneToSevenMinor()` 로 개명해 이름 충돌만 없앤다 (동작을 바꾸면 안 된다).

- [ ] **Step 2: 실패하는 테스트 작성**

`test/harmony/tonality_source_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:harmonypracticereal/domain/harmony/tonality_source.dart';

void main() {
  test('getOneToSeven 은 1..7 범위만 반환한다', () {
    final seen = <int>{};
    for (var i = 0; i < 2000; i++) {
      final n = getOneToSeven();
      expect(n, greaterThanOrEqualTo(1));
      expect(n, lessThanOrEqualTo(7));
      seen.add(n);
    }
    expect(seen.length, 7, reason: '2000회면 1~7이 모두 나와야 한다');
  });

  test('getOneToSix 는 1..6 범위만 반환한다', () {
    final seen = <int>{};
    for (var i = 0; i < 2000; i++) {
      final n = getOneToSix();
      expect(n, greaterThanOrEqualTo(1));
      expect(n, lessThanOrEqualTo(6));
      seen.add(n);
    }
    expect(seen.length, 6, reason: '2000회면 1~6이 모두 나와야 한다');
  });
}
```

- [ ] **Step 3: 테스트 실패 확인**

```bash
flutter test test/harmony/tonality_source_test.dart
```

기대: FAIL — 파일 없음.

- [ ] **Step 4: 공통 모듈 생성**

Step 1에서 확인한 **원본 본문을 그대로 옮겨** `lib/domain/harmony/tonality_source.dart` 를 만든다. 아래는 원본이 단순 난수라는 전제의 형태다 — Step 1 출력과 다르면 원본을 따른다:

```dart
import 'dart:math';

final _random = Random();

/// 음계 도수 1~7 중 하나를 고른다.
///
/// 예전에는 major_problems.dart 와 minor_problems.dart 에 같은 이름으로
/// 각각 정의돼 있어, 두 파일을 함께 import 하면 어느 쪽이 쓰이는지
/// 알기 어려웠다.
int getOneToSeven() => _random.nextInt(7) + 1;

/// 음계 도수 1~6 중 하나를 고른다. 단조 전용 로직에서 쓴다.
int getOneToSix() => _random.nextInt(6) + 1;
```

- [ ] **Step 5: 중복 정의 삭제 및 import 연결**

`lib/domain/harmony/major_problems.dart` 에서 `getOneToSeven()` 정의를 삭제하고 상단에 추가:

```dart
import 'package:harmonypracticereal/domain/harmony/tonality_source.dart';
```

`lib/domain/harmony/minor_problems.dart` 에서 `getOneToSeven()` 과 `getOneToSix()` 정의를 삭제하고 같은 import 를 추가.

- [ ] **Step 6: 검증**

```bash
grep -rn "int getOneToSeven\|int getOneToSix" lib/
flutter analyze 2>&1 | tail -3
flutter test
```

기대: `grep` 결과는 `tonality_source.dart` 한 곳뿐. analyze error 0. **Phase 1의 불변식 테스트가 전부 PASS** — 이게 동작 보존의 증거다.

- [ ] **Step 7: 커밋**

```bash
git add lib/domain/harmony/ test/harmony/tonality_source_test.dart
git commit -m "refactor: getOneToSeven 중복 정의를 tonality_source로 통합 (B3)"
```

---

## Task 5: 색상표를 Material 3 테마로 승격 + 다크모드

**Files:**
- Rewrite: `lib/core/theme/app_colors.dart`
- Create: `lib/core/theme/app_theme.dart`
- Create: `lib/app.dart`
- Create: `test/ui/theme_test.dart`
- Modify: `lib/main.dart`

**배경:** `app_colors.dart` (구 `colorList.dart`)는 전역 `Color` 변수 17개다. 다크모드를 지원할 수 없고, 어떤 색이 어디 쓰이는지 주석에만 적혀 있다. `ThemeExtension` 으로 옮기면 라이트/다크 두 벌을 정의하고 `Theme.of(context)` 로 꺼내 쓸 수 있다.

- [ ] **Step 1: 현재 색상 정의 확인**

```bash
cat lib/core/theme/app_colors.dart
```

17개 색과 주석에 적힌 용도를 그대로 옮길 것이다. **색상값은 하나도 바꾸지 않는다** — 라이트 모드는 지금과 픽셀 단위로 같아야 한다.

- [ ] **Step 2: 실패하는 테스트 작성**

`test/ui/theme_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmonypracticereal/core/theme/app_colors.dart';
import 'package:harmonypracticereal/core/theme/app_theme.dart';

void main() {
  test('라이트 테마 색상은 기존 값과 동일하다', () {
    final c = AppColors.light;

    // 회귀 방지: 기존 colorList.dart 의 값을 그대로 고정한다.
    expect(c.correctText, const Color(0xff4b7947));
    expect(c.correctBackground, const Color(0xffacd0a8));
    expect(c.wrongText, const Color(0xff79474e));
    expect(c.easyAccent, const Color(0xff63af5b));
    expect(c.hardAccent, const Color(0xffe36d3f));
    expect(c.tileBorder, const Color(0xffdedede));
    expect(c.progressSuperEasy, const Color(0xfff2c35b));
    expect(c.progressEasy, const Color(0xff539706));
    expect(c.progressHard, const Color(0xffae2c1f));
    expect(c.tabSuperEasy, const Color(0xfff8b306));
    expect(c.tabEasy, const Color(0xff3f8a36));
    expect(c.tabHard, const Color(0xffc94040));
    expect(c.tabCustom, const Color(0xff656565));
  });

  test('다크 테마도 같은 필드를 모두 채운다', () {
    final d = AppColors.dark;

    // lerp/copyWith 가 동작하려면 어느 필드도 비어서는 안 된다.
    expect(d.correctText, isNotNull);
    expect(d.wrongText, isNotNull);
    expect(d.tabCustom, isNotNull);
  });

  test('라이트와 다크는 서로 다른 값을 가진다', () {
    expect(AppColors.light.correctBackground,
        isNot(AppColors.dark.correctBackground));
  });

  testWidgets('테마에서 AppColors 를 꺼낼 수 있다', (tester) async {
    late AppColors resolved;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) {
            resolved = Theme.of(context).extension<AppColors>()!;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolved.correctText, const Color(0xff4b7947));
  });

  testWidgets('다크 테마에서는 다크 색상이 나온다', (tester) async {
    late AppColors resolved;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: Builder(
          builder: (context) {
            resolved = Theme.of(context).extension<AppColors>()!;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolved.correctBackground, AppColors.dark.correctBackground);
  });
}
```

- [ ] **Step 3: 테스트 실패 확인**

```bash
flutter test test/ui/theme_test.dart
```

기대: FAIL — `AppColors` / `AppTheme` 없음.

- [ ] **Step 4: AppColors 작성**

`lib/core/theme/app_colors.dart` 전체를 교체:

```dart
import 'package:flutter/material.dart';

/// 앱 고유 색상. Material 의 ColorScheme 으로 표현되지 않는 의미색만 담는다.
///
/// 예전에는 colorList.dart 의 전역 변수 17개였다. ThemeExtension 으로
/// 옮기면서 라이트/다크 두 벌을 갖게 됐다.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.easyAccent,
    required this.hardAccent,
    required this.answerNumberText,
    required this.correctText,
    required this.correctBackground,
    required this.wrongText,
    required this.wrongBackground,
    required this.tileBorder,
    required this.conditionText,
    required this.choiceFill,
    required this.progressSuperEasy,
    required this.progressEasy,
    required this.progressHard,
    required this.tabSuperEasy,
    required this.tabEasy,
    required this.tabHard,
    required this.tabCustom,
  });

  /// easy 진행바 / easy 버튼 눌렸을 때 반응색
  final Color easyAccent;

  /// hard 진행바 / hard 버튼 눌렸을 때 반응색
  final Color hardAccent;

  /// 정답 버튼 안 숫자 글자색
  final Color answerNumberText;

  /// 정답 바텀시트: 맞았을 때 글자색 / 배경색
  final Color correctText;
  final Color correctBackground;

  /// 정답 바텀시트: 틀렸을 때 글자색 / 배경색
  final Color wrongText;
  final Color wrongBackground;

  /// 홈 화면 타일 테두리
  final Color tileBorder;

  /// 홈 화면 조건 제시 글자색
  final Color conditionText;

  /// 홈 화면 보기 버튼 채우기색
  final Color choiceFill;

  /// 난이도별 진행바 색
  final Color progressSuperEasy;
  final Color progressEasy;
  final Color progressHard;

  /// 난이도별 탭 색
  final Color tabSuperEasy;
  final Color tabEasy;
  final Color tabHard;
  final Color tabCustom;

  /// 기존 colorList.dart 의 값을 그대로 옮긴 것. 값을 바꾸면 안 된다.
  static const light = AppColors(
    easyAccent: Color(0xff63af5b),
    hardAccent: Color(0xffe36d3f),
    answerNumberText: Colors.black54,
    correctText: Color(0xff4b7947),
    correctBackground: Color(0xffacd0a8),
    wrongText: Color(0xff79474e),
    wrongBackground: Color(0xffacd0a8),
    tileBorder: Color(0xffdedede),
    conditionText: Color(0xff424242),
    choiceFill: Color(0xFFF6F6F6),
    progressSuperEasy: Color(0xfff2c35b),
    progressEasy: Color(0xff539706),
    progressHard: Color(0xffae2c1f),
    tabSuperEasy: Color(0xfff8b306),
    tabEasy: Color(0xff3f8a36),
    tabHard: Color(0xffc94040),
    tabCustom: Color(0xff656565),
  );

  /// 어두운 배경 위에서 읽히도록 명도를 올리고 채도를 낮춘 값.
  static const dark = AppColors(
    easyAccent: Color(0xff8fd487),
    hardAccent: Color(0xffff9366),
    answerNumberText: Colors.white70,
    correctText: Color(0xffa8d6a3),
    correctBackground: Color(0xff2c4429),
    wrongText: Color(0xffe2a3ab),
    wrongBackground: Color(0xff4a2c31),
    tileBorder: Color(0xff3a3a3a),
    conditionText: Color(0xffcfcfcf),
    choiceFill: Color(0xff262626),
    progressSuperEasy: Color(0xffffd782),
    progressEasy: Color(0xff7fc44a),
    progressHard: Color(0xffe0655a),
    tabSuperEasy: Color(0xffffc94d),
    tabEasy: Color(0xff6fb765),
    tabHard: Color(0xffe0706f),
    tabCustom: Color(0xff9a9a9a),
  );

  @override
  AppColors copyWith({
    Color? easyAccent,
    Color? hardAccent,
    Color? answerNumberText,
    Color? correctText,
    Color? correctBackground,
    Color? wrongText,
    Color? wrongBackground,
    Color? tileBorder,
    Color? conditionText,
    Color? choiceFill,
    Color? progressSuperEasy,
    Color? progressEasy,
    Color? progressHard,
    Color? tabSuperEasy,
    Color? tabEasy,
    Color? tabHard,
    Color? tabCustom,
  }) {
    return AppColors(
      easyAccent: easyAccent ?? this.easyAccent,
      hardAccent: hardAccent ?? this.hardAccent,
      answerNumberText: answerNumberText ?? this.answerNumberText,
      correctText: correctText ?? this.correctText,
      correctBackground: correctBackground ?? this.correctBackground,
      wrongText: wrongText ?? this.wrongText,
      wrongBackground: wrongBackground ?? this.wrongBackground,
      tileBorder: tileBorder ?? this.tileBorder,
      conditionText: conditionText ?? this.conditionText,
      choiceFill: choiceFill ?? this.choiceFill,
      progressSuperEasy: progressSuperEasy ?? this.progressSuperEasy,
      progressEasy: progressEasy ?? this.progressEasy,
      progressHard: progressHard ?? this.progressHard,
      tabSuperEasy: tabSuperEasy ?? this.tabSuperEasy,
      tabEasy: tabEasy ?? this.tabEasy,
      tabHard: tabHard ?? this.tabHard,
      tabCustom: tabCustom ?? this.tabCustom,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      easyAccent: Color.lerp(easyAccent, other.easyAccent, t)!,
      hardAccent: Color.lerp(hardAccent, other.hardAccent, t)!,
      answerNumberText: Color.lerp(answerNumberText, other.answerNumberText, t)!,
      correctText: Color.lerp(correctText, other.correctText, t)!,
      correctBackground:
          Color.lerp(correctBackground, other.correctBackground, t)!,
      wrongText: Color.lerp(wrongText, other.wrongText, t)!,
      wrongBackground: Color.lerp(wrongBackground, other.wrongBackground, t)!,
      tileBorder: Color.lerp(tileBorder, other.tileBorder, t)!,
      conditionText: Color.lerp(conditionText, other.conditionText, t)!,
      choiceFill: Color.lerp(choiceFill, other.choiceFill, t)!,
      progressSuperEasy:
          Color.lerp(progressSuperEasy, other.progressSuperEasy, t)!,
      progressEasy: Color.lerp(progressEasy, other.progressEasy, t)!,
      progressHard: Color.lerp(progressHard, other.progressHard, t)!,
      tabSuperEasy: Color.lerp(tabSuperEasy, other.tabSuperEasy, t)!,
      tabEasy: Color.lerp(tabEasy, other.tabEasy, t)!,
      tabHard: Color.lerp(tabHard, other.tabHard, t)!,
      tabCustom: Color.lerp(tabCustom, other.tabCustom, t)!,
    );
  }
}

/// `Theme.of(context).extension<AppColors>()!` 을 짧게 쓰기 위한 확장.
extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
```

- [ ] **Step 5: AppTheme 작성**

`lib/core/theme/app_theme.dart` 를 생성:

```dart
import 'package:flutter/material.dart';
import 'package:harmonypracticereal/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static const _seed = Color(0xff63af5b);

  static ThemeData get light => _build(Brightness.light, AppColors.light);
  static ThemeData get dark => _build(Brightness.dark, AppColors.dark);

  static ThemeData _build(Brightness brightness, AppColors colors) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      extensions: <ThemeExtension<dynamic>>[colors],
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        showDragHandle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.tileBorder),
        ),
      ),
    );
  }
}
```

> `CardTheme` 는 Flutter 3.29 이후 `CardThemeData` 로 바뀌었다. `flutter analyze` 가 타입 오류를 내면 설치된 SDK에 맞는 쪽으로 고친다.

- [ ] **Step 6: 테스트 통과 확인**

```bash
flutter test test/ui/theme_test.dart
```

기대: 5개 모두 PASS. 실패하면 대개 Step 4의 색상값 오타다 — Step 1의 원본 출력과 대조한다.

- [ ] **Step 7: app.dart 분리 및 main.dart 정리**

`lib/app.dart` 를 생성:

```dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:harmonypracticereal/core/theme/app_theme.dart';
import 'package:harmonypracticereal/domain/quiz/quiz_session.dart';
import 'package:harmonypracticereal/ui/loading/loading_page.dart';

class HarmonyApp extends StatelessWidget {
  const HarmonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterClass(),
      child: ScreenUtilInit(
        designSize: const Size(375, 844),
        builder: (context, child) => MaterialApp(
          title: '화성 박사',
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
          ],
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          builder: (context, child) => MediaQuery(
            // 사용자 글자 크기 설정이 악보 레이아웃을 깨뜨리므로 고정한다.
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          ),
          home: child,
        ),
        child: const LoadingPage(),
      ),
    );
  }
}
```

`lib/main.dart` 전체를 교체:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:harmonypracticereal/app.dart';
import 'package:harmonypracticereal/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  unawaited(MobileAds.instance.initialize());

  runApp(const HarmonyApp());
}

/// Future 를 의도적으로 기다리지 않을 때 쓴다.
void unawaited(Future<void> future) {}
```

> `unawaited` 는 `dart:async` 에도 있다. `import 'dart:async';` 를 추가하고 위 로컬 정의를 지우는 쪽이 낫다.

- [ ] **Step 8: 전역 색상 변수 사용처를 컨텍스트 기반으로 교체**

```bash
grep -rn "color1\|color2\|color3\|color4\|color5\|color6\|color7\|color8\|color9\|color1[0-7]" lib/ | wc -l
grep -rn "color[0-9]" lib/ | head -20
```

각 사용처를 아래 대응표대로 바꾼다:

| 기존 | 변경 후 |
|---|---|
| `color1` | `context.colors.easyAccent` |
| `color2` | `context.colors.hardAccent` |
| `color3` | `context.colors.answerNumberText` |
| `color4` | `context.colors.correctText` |
| `color5` | `context.colors.correctBackground` |
| `color6` | `context.colors.wrongText` |
| `color7` | `context.colors.wrongBackground` |
| `color8` | `context.colors.tileBorder` |
| `color9` | `context.colors.conditionText` |
| `color10` | `context.colors.choiceFill` |
| `color11` | `context.colors.progressSuperEasy` |
| `color12` | `context.colors.progressEasy` |
| `color13` | `context.colors.progressHard` |
| `color14` | `context.colors.tabSuperEasy` |
| `color15` | `context.colors.tabEasy` |
| `color16` | `context.colors.tabHard` |
| `color17` | `context.colors.tabCustom` |

**주의:** `BuildContext` 가 없는 곳(전역 함수, `static` 필드 초기화)에서는 쓸 수 없다. 그런 곳은 함수 시그니처에 `BuildContext context` 를 추가하거나, 해당 값을 위젯 트리 안으로 옮긴다. `const` 로 선언된 위젯 안에서는 `const` 를 떼야 한다.

높은 번호부터 치환해야 `color1` 이 `color10` 을 잡아먹지 않는다:

```bash
cd lib
for pair in "color17:tabCustom" "color16:tabHard" "color15:tabEasy" "color14:tabSuperEasy" \
            "color13:progressHard" "color12:progressEasy" "color11:progressSuperEasy" \
            "color10:choiceFill" "color9:conditionText" "color8:tileBorder" \
            "color7:wrongBackground" "color6:wrongText" "color5:correctBackground" \
            "color4:correctText" "color3:answerNumberText" "color2:hardAccent" "color1:easyAccent"; do
  old="${pair%%:*}"; new="${pair##*:}"
  grep -rl "\b$old\b" . | xargs -r sed -i '' "s/\b$old\b/context.colors.$new/g"
done
cd ..
```

- [ ] **Step 9: 컴파일 오류 정리**

```bash
flutter analyze 2>&1 | grep "error" | head -30
```

예상되는 오류와 대응:
- `Undefined name 'context'` → 그 함수에 `BuildContext context` 매개변수를 추가하고 호출부도 함께 수정
- `Invalid constant value` → 해당 위젯의 `const` 키워드 제거
- `The getter 'colors' isn't defined` → 그 파일에 `import 'package:harmonypracticereal/core/theme/app_colors.dart';` 추가

**error 0이 될 때까지 반복한다.**

- [ ] **Step 10: 라이트 모드 픽셀 동일성 확인**

```bash
flutter run
```

기기 설정을 **라이트 모드**로 두고 확인한다. 색이 리팩토링 전과 같아야 한다:
- 홈 화면 4개 탭의 탭 색 (노랑/초록/빨강/회색)
- 문제 화면 진행바 색
- 정답 바텀시트(초록 계열) / 오답 바텀시트

그다음 기기 설정을 **다크 모드**로 바꾸고 같은 화면을 돈다. 읽을 수 없는 대비(어두운 글자 위 어두운 배경)가 있으면 `AppColors.dark` 의 해당 값을 조정한다.

- [ ] **Step 11: 검증 및 커밋**

```bash
flutter analyze 2>&1 | tail -3
flutter test
git add -A
git commit -m "feat: 색상표를 ThemeExtension으로 승격하고 다크모드 지원 추가"
```

---

## Task 6: 광고 단위 ID를 빌드 시점 주입으로 전환

**Files:**
- Modify: `lib/core/ads/ad_ids.dart`
- Create: `test/ads/ad_ids_test.dart`
- Modify: `docs/RELEASE.md` (Phase 2 산출물)
- Modify: `.github/workflows/release-android.yml`, `release-ios.yml` (Phase 2 산출물)

**배경:** 실제 광고 단위 ID 4개가 공개 저장소 소스에 하드코딩돼 있다. 당장 보안 사고는 아니지만(광고 ID 자체는 비밀이 아니다), 테스트/실전 전환이 `kReleaseMode` 에만 묶여 있어 릴리스 빌드로 QA할 때 실제 광고에 노출이 찍힌다. `--dart-define` 으로 빼면 QA 빌드에서 테스트 ID를 쓸 수 있다.

- [ ] **Step 1: 실패하는 테스트 작성**

`test/ads/ad_ids_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:harmonypracticereal/core/ads/ad_ids.dart';

void main() {
  test('dart-define 이 없으면 항상 구글 테스트 ID를 쓴다', () {
    // 테스트 실행에는 --dart-define 을 주지 않는다.
    // 실수로 실전 ID가 노출되는 것보다 광고가 안 나오는 편이 안전하다.
    expect(AdIds.banner, startsWith('ca-app-pub-3940256099942544/'));
    expect(AdIds.interstitial, startsWith('ca-app-pub-3940256099942544/'));
  });

  test('ID 는 절대 비지 않는다', () {
    expect(AdIds.banner, isNotEmpty);
    expect(AdIds.interstitial, isNotEmpty);
  });
}
```

- [ ] **Step 2: 테스트 실패 확인**

```bash
flutter test test/ads/ad_ids_test.dart
```

기대: FAIL — `AdIds` 없음.

- [ ] **Step 3: 구현 작성**

`lib/core/ads/ad_ids.dart` 전체를 교체:

```dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 광고 단위 ID.
///
/// 실전 ID 는 빌드 시점에 `--dart-define` 으로 주입한다. 주입되지 않으면
/// 구글 공식 테스트 ID 로 폴백한다 — 실수로 실전 광고에 테스트 노출이
/// 찍히는 것보다 안전하다.
///
/// ```
/// flutter build appbundle --release \
///   --dart-define=ADMOB_BANNER_ANDROID=ca-app-pub-XXXX/YYYY \
///   --dart-define=ADMOB_INTERSTITIAL_ANDROID=ca-app-pub-XXXX/ZZZZ
/// ```
class AdIds {
  AdIds._();

  // 구글 공식 테스트 ID.
  // https://developers.google.com/admob/flutter/test-ads
  static const _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const _testBannerIos = 'ca-app-pub-3940256099942544/2934735716';
  static const _testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const _testInterstitialIos = 'ca-app-pub-3940256099942544/4411468910';

  static const _bannerAndroid =
      String.fromEnvironment('ADMOB_BANNER_ANDROID', defaultValue: '');
  static const _bannerIos =
      String.fromEnvironment('ADMOB_BANNER_IOS', defaultValue: '');
  static const _interstitialAndroid =
      String.fromEnvironment('ADMOB_INTERSTITIAL_ANDROID', defaultValue: '');
  static const _interstitialIos =
      String.fromEnvironment('ADMOB_INTERSTITIAL_IOS', defaultValue: '');

  static bool get _isIos {
    // 테스트(Flutter test) 환경에서는 Platform 이 호스트 OS 를 가리키므로
    // defaultTargetPlatform 을 먼저 본다.
    if (kIsWeb) return false;
    return Platform.isIOS || Platform.isMacOS;
  }

  static String get banner {
    final injected = _isIos ? _bannerIos : _bannerAndroid;
    if (injected.isNotEmpty) return injected;
    return _isIos ? _testBannerIos : _testBannerAndroid;
  }

  static String get interstitial {
    final injected = _isIos ? _interstitialIos : _interstitialAndroid;
    if (injected.isNotEmpty) return injected;
    return _isIos ? _testInterstitialIos : _testInterstitialAndroid;
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad loaded.'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('Ad failed to load: $error');
    },
    onAdOpened: (ad) => debugPrint('Ad opened'),
    onAdClosed: (ad) => debugPrint('Ad closed'),
  );
}
```

- [ ] **Step 4: 테스트 통과 확인**

```bash
flutter test test/ads/ad_ids_test.dart
```

기대: PASS. macOS에서 테스트가 돌면 `_isIos` 가 참이 되어 iOS 테스트 ID가 나온다 — 테스트는 접두사만 보므로 통과한다.

- [ ] **Step 5: 기존 사용처 교체**

```bash
grep -rn "AdMobServiceBanner\|AdMobServiceFullScreen" lib/
```

- `AdMobServiceBanner.bannerAdUnitId!` → `AdIds.banner`
- `AdMobServiceBanner.bannerAdListener` → `AdIds.bannerAdListener`
- `AdMobServiceFullScreen.fullScreenAdUnitId!` → `AdIds.interstitial`

```bash
cd lib
grep -rl "AdMobService" . | xargs sed -i '' \
  -e 's/AdMobServiceBanner\.bannerAdUnitId!/AdIds.banner/g' \
  -e 's/AdMobServiceBanner\.bannerAdListener/AdIds.bannerAdListener/g' \
  -e 's/AdMobServiceFullScreen\.fullScreenAdUnitId!/AdIds.interstitial/g'
cd ..
grep -rn "AdMobService" lib/
```

마지막 명령의 기대 출력: 없음.

- [ ] **Step 6: 실전 ID를 GitHub Secrets로 옮기고 워크플로에 연결**

원래 소스에 있던 실전 ID 4개:

```
ADMOB_BANNER_ANDROID       = ca-app-pub-7191096510845066/9834842939
ADMOB_BANNER_IOS           = ca-app-pub-7191096510845066/9643271244
ADMOB_INTERSTITIAL_ANDROID = ca-app-pub-7191096510845066/5895597923
ADMOB_INTERSTITIAL_IOS     = ca-app-pub-7191096510845066/4263468974
```

GitHub Secrets 에 등록:

```bash
gh secret set ADMOB_BANNER_ANDROID --body "ca-app-pub-7191096510845066/9834842939"
gh secret set ADMOB_BANNER_IOS --body "ca-app-pub-7191096510845066/9643271244"
gh secret set ADMOB_INTERSTITIAL_ANDROID --body "ca-app-pub-7191096510845066/5895597923"
gh secret set ADMOB_INTERSTITIAL_IOS --body "ca-app-pub-7191096510845066/4263468974"
```

`.github/workflows/release-android.yml` 의 "AAB 빌드" 스텝을 교체:

```yaml
      - name: AAB 빌드
        run: |
          flutter build appbundle --release \
            --dart-define=ADMOB_BANNER_ANDROID=${{ secrets.ADMOB_BANNER_ANDROID }} \
            --dart-define=ADMOB_INTERSTITIAL_ANDROID=${{ secrets.ADMOB_INTERSTITIAL_ANDROID }}
```

`ios/fastlane/Fastfile` 의 `build_app` 앞에 Flutter 빌드를 명시하도록 `release-ios.yml` 의 "TestFlight 업로드" 스텝 앞에 추가:

```yaml
      - name: Flutter iOS 빌드
        run: |
          flutter build ios --release --no-codesign \
            --dart-define=ADMOB_BANNER_IOS=${{ secrets.ADMOB_BANNER_IOS }} \
            --dart-define=ADMOB_INTERSTITIAL_IOS=${{ secrets.ADMOB_INTERSTITIAL_IOS }}
```

- [ ] **Step 7: docs/RELEASE.md 시크릿 목록 갱신**

`docs/RELEASE.md` 의 "GitHub Secrets 목록" 에 섹션 추가:

```markdown
### AdMob (실전 광고 단위 ID)
- `ADMOB_BANNER_ANDROID`
- `ADMOB_BANNER_IOS`
- `ADMOB_INTERSTITIAL_ANDROID`
- `ADMOB_INTERSTITIAL_IOS`

이 값들이 주입되지 않으면 앱은 구글 테스트 광고를 표시한다.
로컬에서 실전 광고를 확인하려면 위 값을 `--dart-define` 으로 직접 넘긴다.
```

- [ ] **Step 8: 검증**

```bash
flutter analyze 2>&1 | tail -3
flutter test
# 테스트 광고로 뜨는지 확인
flutter run --release
# 실전 광고로 뜨는지 확인
flutter run --release \
  --dart-define=ADMOB_BANNER_ANDROID=ca-app-pub-7191096510845066/9834842939 \
  --dart-define=ADMOB_INTERSTITIAL_ANDROID=ca-app-pub-7191096510845066/5895597923
```

첫 번째 실행에서는 "Test Ad" 라벨이 붙은 배너가, 두 번째에서는 실제 광고가 떠야 한다.

- [ ] **Step 9: 커밋**

```bash
git add lib/core/ads/ad_ids.dart test/ads/ .github/ docs/RELEASE.md
git add -u
git commit -m "refactor: 광고 단위 ID를 dart-define 주입으로 전환, 미주입 시 테스트 ID 폴백"
```

---

## Task 7: 문제 화면 4종의 공통 껍데기 통합

**Files:**
- Create: `lib/ui/quiz/quiz_page_scaffold.dart`
- Create: `test/ui/quiz_page_scaffold_test.dart`
- Modify: `lib/ui/quiz/problem_type1_page.dart` ~ `problem_type4_page.dart`

**배경:** 네 파일 3,636줄 중 광고 배너 수명주기, 정답/오답 바텀시트 골격, 오답노트 누적(`wrongProblems` / `wrongProblemsSave`), 전면광고 트리거, 진행률 표시, 결과 화면 전환이 거의 동일하게 반복된다. 다른 것은 "문제를 어떻게 그리는가"와 "보기를 어떻게 만드는가" 두 가지뿐이다.

**이 태스크는 크다. 한 번에 4개를 다 옮기지 말고 type1 하나만 먼저 옮겨 검증한 뒤 나머지를 따라간다.**

- [ ] **Step 1: 실패하는 테스트 작성**

`test/ui/quiz_page_scaffold_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmonypracticereal/ui/quiz/quiz_page_scaffold.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: child);

  testWidgets('제목과 문제 본문을 그린다', (tester) async {
    await tester.pumpWidget(wrap(
      QuizPageScaffold(
        title: 'Easy',
        solvedCount: 0,
        totalCount: 10,
        problemBuilder: (context) => const Text('문제 본문'),
        answerBuilder: (context) => const Text('보기 영역'),
        banner: null,
      ),
    ));

    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('문제 본문'), findsOneWidget);
    expect(find.text('보기 영역'), findsOneWidget);
  });

  testWidgets('오답 모드에서는 제목이 "오답 문제" 가 된다', (tester) async {
    await tester.pumpWidget(wrap(
      QuizPageScaffold(
        title: 'Easy',
        isReviewingWrongAnswers: true,
        solvedCount: 3,
        totalCount: 10,
        problemBuilder: (context) => const SizedBox.shrink(),
        answerBuilder: (context) => const SizedBox.shrink(),
        banner: null,
      ),
    ));

    expect(find.text('오답 문제'), findsOneWidget);
    expect(find.text('Easy'), findsNothing);
  });

  testWidgets('진행률이 solvedCount/totalCount 로 표시된다', (tester) async {
    await tester.pumpWidget(wrap(
      QuizPageScaffold(
        title: 'Hard',
        solvedCount: 7,
        totalCount: 10,
        problemBuilder: (context) => const SizedBox.shrink(),
        answerBuilder: (context) => const SizedBox.shrink(),
        banner: null,
      ),
    ));

    expect(find.text('7 / 10'), findsOneWidget);
  });

  testWidgets('광고가 없어도 레이아웃이 깨지지 않는다', (tester) async {
    await tester.pumpWidget(wrap(
      QuizPageScaffold(
        title: 'Easy',
        solvedCount: 0,
        totalCount: 10,
        problemBuilder: (context) => const Text('문제'),
        answerBuilder: (context) => const Text('보기'),
        banner: null,
      ),
    ));

    expect(tester.takeException(), isNull);
  });
}
```

- [ ] **Step 2: 테스트 실패 확인**

```bash
flutter test test/ui/quiz_page_scaffold_test.dart
```

기대: FAIL — `quiz_page_scaffold.dart` 없음.

- [ ] **Step 3: 구현 작성**

`lib/ui/quiz/quiz_page_scaffold.dart` 를 생성:

```dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:harmonypracticereal/core/ads/banner_ad_slot.dart';
import 'package:harmonypracticereal/core/theme/app_colors.dart';

/// 문제 유형 1~4가 공유하는 화면 껍데기.
///
/// 앱바, 진행률, 문제 영역, 보기 영역, 배너 광고 자리의 배치를 담당한다.
/// "무엇을 그리는가" 는 [problemBuilder] / [answerBuilder] 로 주입받으므로
/// 이 위젯은 유형별 로직을 전혀 모른다.
class QuizPageScaffold extends StatelessWidget {
  const QuizPageScaffold({
    required this.title,
    required this.solvedCount,
    required this.totalCount,
    required this.problemBuilder,
    required this.answerBuilder,
    required this.banner,
    this.isReviewingWrongAnswers = false,
    this.onBack,
    super.key,
  });

  /// 난이도 이름. 오답 모드에서는 표시되지 않는다.
  final String title;

  /// 오답노트를 다시 푸는 중인지.
  final bool isReviewingWrongAnswers;

  final int solvedCount;
  final int totalCount;

  /// 오선보 등 문제 본문.
  final WidgetBuilder problemBuilder;

  /// 보기 버튼 영역.
  final WidgetBuilder answerBuilder;

  final BannerAd? banner;

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final progress = totalCount == 0 ? 0.0 : solvedCount / totalCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(isReviewingWrongAnswers ? '오답 문제' : title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: onBack ?? () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: colors.tileBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _progressColor(colors),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('$solvedCount / $totalCount'),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(child: Builder(builder: problemBuilder)),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Builder(builder: answerBuilder),
              ),
            ),
            BannerAdSlot(banner: banner),
          ],
        ),
      ),
    );
  }

  Color _progressColor(AppColors colors) {
    return switch (title.toLowerCase()) {
      'super easy' => colors.progressSuperEasy,
      'easy' => colors.progressEasy,
      'hard' => colors.progressHard,
      _ => colors.tabCustom,
    };
  }
}
```

- [ ] **Step 4: 테스트 통과 확인**

```bash
flutter test test/ui/quiz_page_scaffold_test.dart
```

기대: 4개 모두 PASS. `context.colors` 가 null 이라 실패하면 테스트의 `wrap()` 을 `MaterialApp(theme: AppTheme.light, home: child)` 로 고친다 (테스트 파일 상단에 `AppTheme` import 추가).

- [ ] **Step 5: problem_type1_page.dart의 build를 QuizPageScaffold로 교체**

`lib/ui/quiz/problem_type1_page.dart` 의 `build` 메서드 전체를 아래 형태로 바꾼다. **기존 build 안에 있던 위젯 트리는 지우지 말고 `problemBuilder` / `answerBuilder` 안으로 옮긴다.**

```dart
  @override
  Widget build(BuildContext context) {
    return QuizPageScaffold(
      title: widget.stageType,
      isReviewingWrongAnswers: wrongProblemMode,
      solvedCount: numberOfRight,
      totalCount: 10,
      banner: _banner,
      problemBuilder: (context) {
        // 기존 build 안의 오선보 렌더링 부분을 그대로 여기로 옮긴다.
        return _buildStaff(context);
      },
      answerBuilder: (context) {
        // 기존 build 안의 보기 버튼 부분을 그대로 여기로 옮긴다.
        return _buildAnswerButtons(context);
      },
    );
  }
```

옮긴 두 덩어리는 State 클래스의 private 메서드로 추출한다:

```dart
  Widget _buildStaff(BuildContext context) {
    // ... 기존 오선보 위젯 트리 ...
  }

  Widget _buildAnswerButtons(BuildContext context) {
    // ... 기존 보기 버튼 위젯 트리 ...
  }
```

- [ ] **Step 6: type1 검증 — 여기서 반드시 눈으로 확인한다**

```bash
flutter analyze 2>&1 | tail -3
flutter run
```

문제 유형 1을 **4개 난이도 모두** 열어 확인:
- 오선보가 잘리거나 겹치지 않는가
- 보기 버튼 4개가 다 보이는가
- 진행률 바가 정답을 맞힐 때마다 차오르는가
- 10문제를 다 풀면 결과 화면으로 넘어가는가
- 오답노트 다시 풀기에서 제목이 "오답 문제" 로 바뀌는가
- 배너 광고 자리가 유지되는가

**하나라도 어긋나면 여기서 멈추고 고친다.** type2~4로 넘어가면 문제 원인을 찾기 어려워진다.

- [ ] **Step 7: type1 커밋**

```bash
git add lib/ui/quiz/quiz_page_scaffold.dart test/ui/quiz_page_scaffold_test.dart lib/ui/quiz/problem_type1_page.dart
git commit -m "refactor: 문제 유형 1을 QuizPageScaffold로 이전"
```

- [ ] **Step 8: type2를 같은 방식으로 이전**

Step 5와 동일하게 `problem_type2_page.dart` 를 옮긴다. Step 6과 동일하게 검증한다.

```bash
flutter analyze 2>&1 | tail -3 && flutter run
git add lib/ui/quiz/problem_type2_page.dart
git commit -m "refactor: 문제 유형 2를 QuizPageScaffold로 이전"
```

- [ ] **Step 9: type3를 같은 방식으로 이전**

```bash
flutter analyze 2>&1 | tail -3 && flutter run
git add lib/ui/quiz/problem_type3_page.dart
git commit -m "refactor: 문제 유형 3을 QuizPageScaffold로 이전"
```

- [ ] **Step 10: type4를 같은 방식으로 이전**

```bash
flutter analyze 2>&1 | tail -3 && flutter run
git add lib/ui/quiz/problem_type4_page.dart
git commit -m "refactor: 문제 유형 4를 QuizPageScaffold로 이전"
```

- [ ] **Step 11: 줄 수 감소 확인**

```bash
find lib -name "*.dart" -exec wc -l {} + | sort -rn | head -12
```

`problem_type*_page.dart` 4개의 합계가 이전 3,636줄보다 눈에 띄게 줄었는지 확인한다. 줄지 않았다면 공통화가 제대로 안 된 것이다.

---

## Task 8: 전체 포맷 정리 및 린트 잔여 경고 처리

이 태스크는 **마지막에** 한다. 앞에서 하면 모든 diff가 포맷 변경에 묻힌다.

**Files:** `lib/`, `test/` 전체

- [ ] **Step 1: 포맷 적용 전 상태 확인**

```bash
flutter analyze 2>&1 | tail -3
flutter test
git status --short
```

작업 트리가 깨끗하고 테스트가 전부 통과해야 한다.

- [ ] **Step 2: 포맷 적용**

```bash
dart format lib/ test/
```

- [ ] **Step 3: 포맷만 바뀌었는지 확인**

```bash
git diff --stat | tail -3
flutter analyze 2>&1 | tail -3
flutter test
```

기대: analyze error 0, 테스트 전부 PASS. 테스트가 깨지면 포맷 이외의 변경이 섞인 것이므로 `git checkout -- .` 로 되돌리고 원인을 찾는다.

- [ ] **Step 4: 포맷 커밋 (단독 커밋)**

```bash
git add -A
git commit -m "style: dart format 전체 적용"
```

- [ ] **Step 5: 잔여 경고 처리**

```bash
flutter analyze 2>&1 | grep "warning" | head -30
```

Phase 1 진단에서 확인된 미사용 변수들을 제거한다:
- `lib/ui/quiz/widgets/staff_view.dart` 의 `height`, `weight`, `middleLine`, `lowLine`, `highLine`, `twolinelow`, `twolinemiddle`, `twolinehigh`
- `lib/ui/quiz/widgets/staff_view.dart` 상단의 미사용 `import 'dart:math';`
- `lib/ui/loading/initialize_screen.dart` 의 미사용 `navigator`

`initialize_screen.dart` 의 `must_be_immutable` 경고도 고친다 — `targetWidget` 필드에 `final` 을 붙이고 생성자에 `super.key` 를 추가:

```dart
class InitializeScreen extends StatefulWidget {
  const InitializeScreen({required this.targetWidget, super.key});

  final Widget targetWidget;

  @override
  State<InitializeScreen> createState() => _InitializeScreenState();
}
```

`use_build_context_synchronously` (`initialize_screen.dart:39`) 는 async 간격 뒤 context 사용이다. 앞에 가드를 넣는다:

```dart
    if (!mounted) return;
    Navigator.of(context).pushReplacement(...);
```

- [ ] **Step 6: 최종 검증**

```bash
flutter analyze 2>&1 | tail -3
flutter test
```

기대: **error 0, warning 0.** info 는 남아도 된다. warning 이 남으면 Step 5로 돌아간다.

- [ ] **Step 7: 커밋**

```bash
git add -A
git commit -m "chore: 미사용 변수 제거 및 린트 경고 해소"
```

---

## Task 9: 최종 검증 및 병합

- [ ] **Step 1: 전체 검증**

```bash
flutter clean && flutter pub get
flutter analyze 2>&1 | tail -3
flutter test
flutter build appbundle --release
cd ios && pod install && cd ..
flutter build ios --release --no-codesign
```

기대: 6개 명령 모두 성공, analyze error 0 / warning 0.

- [ ] **Step 2: 리팩토링 전후 규모 비교**

```bash
find lib -name "*.dart" -exec wc -l {} + | tail -1
```

리팩토링 전 13,069줄과 비교한다. 파일 수는 늘고 총 줄 수는 줄어야 정상이다.

- [ ] **Step 3: 전체 회귀 테스트 (수동)**

실기기에서 아래를 전부 확인한다:

| 항목 | 확인 내용 |
|---|---|
| 로딩 | 로티 애니메이션 → 홈 화면 자동 전환 |
| 홈 4개 탭 | super easy / easy / hard / custom 모두 열림, 탭 색상 정상 |
| custom 탭 | 화음 종류 선택, "전체 선택 / 해제" 동작, 앱 재실행 후 선택 유지 |
| 문제 유형 1~4 | 각 난이도에서 10문제 완주, 진행률 정상 |
| 정답/오답 | 바텀시트 색상·문구 정상 |
| 오답노트 | 틀린 문제 다시 풀기 진입, 제목 "오답 문제" |
| 결과 화면 | 점수·정답률 표시, 다시 풀기 동작 |
| 광고 | 배너 표시, 20문제마다 전면광고 |
| 설정 | GDPR 항목 동작 |
| 다크모드 | 기기 설정 전환 시 전 화면 가독성 유지 |
| 화면 회전 | 세로 고정 유지 |

- [ ] **Step 4: PR 생성**

```bash
git push -u origin phase3/refactor
gh pr create --title "구조 리팩토링 및 디자인 현대화" --body "$(cat <<'EOF'
## 요약
- `lib/` 를 core / domain / data / ui 4계층으로 재배치, 전 파일 snake_case 개명
- 문제 유형 1~4의 공통 껍데기를 `QuizPageScaffold` 로 통합
- 전역 색상 변수 17개를 `ThemeExtension` 으로 승격, 다크모드 지원 추가
- 광고 단위 ID를 `--dart-define` 주입 방식으로 전환 (미주입 시 테스트 ID)

## 수정한 버그
- B1: 문제 이름 대소문자 오타로 속7화음 오답 보기가 잘못된 규칙으로 생성되던 문제
- B2: 배너 광고를 dispose 하지 않아 문제 화면 진입마다 누수되던 문제
- B3: `getOneToSeven()` 이 두 파일에 중복 정의돼 있던 문제

## 검증
- `flutter analyze` error 0 / warning 0
- `flutter test` 전부 통과 (화성 엔진 불변식 + 오답 생성기 + 테마 + 위젯)
- Android AAB / iOS 빌드 성공
- 실기기 전체 화면 회귀 확인

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

---

## 완료 기준

- [ ] `flutter analyze` error 0, warning 0
- [ ] `flutter test` 전부 통과 — 화성 엔진 불변식, 오답 생성기, 테마, `QuizPageScaffold`, `BannerAdSlot`
- [ ] `lib/` 아래 파일이 모두 snake_case, `harmonyModul` / `page` 디렉터리 없음
- [ ] `problem_type*_page.dart` 4개 합계 줄 수가 리팩토링 전보다 감소
- [ ] 다크모드에서 전 화면 가독성 유지
- [ ] 소스에 실전 광고 ID 하드코딩 없음
- [ ] B1·B2·B3 각각에 대응하는 테스트 존재

---

## 이 계획에서 의도적으로 하지 않은 것

- **Riverpod 전환** — Provider 유지로 결정됨. 레이어 분리만으로 테스트 가능성은 확보된다.
- **화면 흐름 재설계** — 정보구조와 내비게이션은 그대로 둔다. 전면 재설계는 별도 브레인스토밍이 필요하다.
- **`major_problems.dart` / `minor_problems.dart` 내부 로직 통합** — 두 파일 3,245줄에 장/단조 화성 규칙이 각각 하드코딩돼 있다. 통합하면 정답 산출이 바뀔 위험이 크고, 이득은 코드 길이뿐이다. 불변식 테스트가 충분히 촘촘해진 뒤 별도 단계로 다룬다.
- **record → 값 객체(`HarmonyProblem`) 전환** — 5요소 record `(List<String>, List<Note>, Tonality, List<Note>, String)` 를 쓰는 곳이 20군데가 넘는다. Task 7과 함께 하면 diff가 감당이 안 되므로 별도 단계로 미룬다.
- **`home_page.dart` 1,441줄 분해** — 난이도 탭 4개가 한 파일에 펼쳐져 있다. Task 7에서 문제 화면이 정리된 뒤 같은 방식(공통 탭 위젯 + 난이도별 설정)으로 다루는 편이 안전하다.
- **`SharedPreferences` 래퍼 도입** — 현재 저장 키는 `'items'` 하나뿐이라(`home_page.dart`) 래퍼를 만들 이득이 작다. 저장 항목이 늘어날 때 만든다.
