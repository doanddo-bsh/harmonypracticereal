import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_notes/music_notes.dart' as msc;
import 'package:provider/provider.dart';

import 'package:harmonypracticereal/core/theme/app_theme.dart';
import 'package:harmonypracticereal/domain/quiz/quiz_session.dart';

/// 문제 화면 4종이 `problemCallFunction` 으로 받는 레코드.
typedef ProblemRecord = (
  List<String>, // $1 answer  — 화성 표기 9칸
  List<msc.Note>, // $2 problem — 오선에 그릴 SATB
  msc.Key, // $3 condition — 조성
  List<msc.Note>, // $4 problemOriginal — 화음 구성음
  String, // $5 problemName
);

/// 실제 문제 생성기(`getCustomProblemType`) 대신 쓰는 **결정적** 대역.
///
/// 실물 생성기는 `Random()` 을 쓰므로 무엇이 정답인지 테스트가 알 수 없다.
/// 여기서는 호출 순서를 세어 매번 다른 문제를 돌려주되, 그 순서가 항상
/// 같도록 한다. 그래서 "화면이 지금 내고 있는 문제"를 테스트가 정확히 안다.
///
/// 각 화면이 정답을 뽑아내는 방법이 다르므로, 화면별 정답 문자열도 함께
/// 계산해 둔다.
///
/// * 유형 1 — 정답은 `answer` 리스트 그 자체(동일성 비교)다. 리스트 5번째
///   칸에 `A0`, `A1` … 일련번호를 넣어 화면에서 눈으로 구분할 수 있게 했다.
/// * 유형 3 — 정답은 `condition`. 호출마다 다른 조성을 쓴다.
/// * 유형 4 — 정답은 `problemOriginal` 의 근음에서 나오는 코드명. 호출마다
///   다른 근음을 쓴다.
///
/// * 유형 2 — 정답은 `problem[Random().nextInt(4)]` 이라 대역만으로는 고정할
///   수 없다. 다만 **화면이 어느 성부가 비었는지를 문구로 알려 주므로**
///   그 문구에서 `intValue` 를 되찾아 정답을 계산할 수 있다.
///   [type2AnswerLabel] 참고.
class StubProblemSource {
  int _calls = 0;

  int get callCount => _calls;

  /// 근음이 다른 다장조 3화음들. 유형 4 의 보기가 서로 달라야 하므로 필요하다.
  /// 같은 코드명만 나오면 `getViewListEasyType4` 의 `while` 이 끝나지 않는다
  /// (실제로 고정 문제를 주면 위젯 테스트가 영원히 멈춘다 — 아래 주석 참고).
  static const _triads = <List<msc.Note>>[
    [msc.Note.c, msc.Note.e, msc.Note.g],
    [msc.Note.d, msc.Note.f, msc.Note.a],
    [msc.Note.e, msc.Note.g, msc.Note.b],
    [msc.Note.f, msc.Note.a, msc.Note.c],
    [msc.Note.g, msc.Note.b, msc.Note.d],
    [msc.Note.a, msc.Note.c, msc.Note.e],
    [msc.Note.b, msc.Note.d, msc.Note.f],
  ];

  /// 위 3화음 각각을 `getType4Answer` 가 만들어 내는 코드명.
  /// (장3화음이면 근음 그대로, 단3화음이면 `m`, 감3화음이면 `dim`.)
  static const _chordCodes = <String>['C', 'Dm', 'Em', 'F', 'G', 'Am', 'Bdim'];

  static const _keys = <msc.Key>[
    msc.Key(msc.Note.c, msc.TonalMode.major),
    msc.Key(msc.Note.d, msc.TonalMode.major),
    msc.Key(msc.Note.e, msc.TonalMode.major),
    msc.Key(msc.Note.f, msc.TonalMode.major),
    msc.Key(msc.Note.g, msc.TonalMode.major),
    msc.Key(msc.Note.a, msc.TonalMode.major),
    msc.Key(msc.Note.b, msc.TonalMode.major),
  ];

  /// 유형 1 이 보기 버튼에 그리는 꼬리표. `n` 번째 호출의 문제를 가리킨다.
  ///
  /// **항상 두 글자**다. 자릿수가 늘면(`A9` → `A123`) 보기 버튼 안의 `Row` 가
  /// 넘쳐 `RenderFlex overflowed` 가 나고, 그건 화면 잘못이 아니라 대역
  /// 잘못이다. 36진수 두 자리면 1296번 호출까지 버틴다 — 가장 긴 테스트가
  /// 150번쯤 부르므로 충분하다.
  static String markerFor(int call) {
    const alphabet = '0123456789abcdefghijklmnopqrstuvwxyz';
    assert(call < alphabet.length * alphabet.length, '꼬리표가 모자란다');
    return '${alphabet[call ~/ alphabet.length]}${alphabet[call % alphabet.length]}';
  }

  /// 유형 3 의 정답 텍스트. `n` 번째 호출의 조성 표기.
  static String keyLabelFor(int call) => _keys[call % _keys.length].format();

  /// 유형 4 의 정답 코드명.
  static String chordCodeFor(int call) => _chordCodes[call % _chordCodes.length];

  /// `n` 번째 호출이 내놓는 SATB(레코드의 `$2 problem`).
  ///
  /// SATB 성부 배치는 5음-3음-근음-근음 순서다. 이러면 일곱 화음 모두
  /// `noteToPositionedNote` 가 항상 배치에 성공한다(100회 × 7화음 실측).
  /// 배치에 실패하면 화면의 `while` 이 다시 돌아 호출 순서가 어긋난다.
  ///
  /// 리스트는 부를 때마다 새로 만든다. 유형 4 의 `typeFourProblemCreator` 가
  /// 넘겨받은 `problem` 을 **제자리에서** 고치기 때문이다(계획서의 B5).
  /// 실제 생성기도 호출마다 새 리스트를 만들므로 이쪽이 현실과 같다.
  static List<msc.Note> satbFor(int call) {
    final triad = _triads[call % _triads.length];
    return <msc.Note>[triad[2], triad[1], triad[0], triad[0]];
  }

  ProblemRecord call([Object? _]) {
    final n = _calls++;
    final triad = _triads[n % _triads.length];
    final satb = satbFor(n);
    return (
      <String>['I', '', '', '', markerFor(n), '', '', '', ''],
      satb,
      _keys[n % _keys.length],
      List<msc.Note>.of(triad),
      'basicProblem',
    );
  }
}

/// 유형 2 화면이 "어느 성부가 비었는가" 를 알리는 문구. `intValue` 순서다.
///
/// `problem_type2_page.dart` 의 `tellWhatMiss` 를 그대로 옮겨 적었다. 화면이
/// 이 문구를 바꾸면 여기도 깨져야 한다 — 테스트가 정답을 알아내는 유일한
/// 통로이기 때문이다.
const type2VoicePrompts = <String>[
  '베이스에 들어갈 알맞은 음을 고르시오',
  '테너에 들어갈 알맞은 음을 고르시오',
  '알토에 들어갈 알맞은 음을 고르시오',
  '소프라노에 들어갈 알맞은 음을 고르시오',
];

/// 지금 유형 2 화면이 비워 둔 성부 번호(= 화면의 `intValue`).
///
/// 바텀시트가 떠 있어도 본문 문구는 그대로 있으므로, 시트가 닫힌 상태에서
/// 부르는 것을 전제로 한다.
int type2MissingVoiceOnScreen() {
  final found = <int>[
    for (var i = 0; i < type2VoicePrompts.length; i++)
      if (find.text(type2VoicePrompts[i]).evaluate().isNotEmpty) i,
  ];
  expect(found, hasLength(1),
      reason: '성부 안내 문구가 정확히 하나 떠 있어야 한다 (찾은 것: $found)');
  return found.single;
}

/// 지금 화면에 떠 있는 유형 2 문제의 **정답 라벨**.
///
/// 유형 2 의 정답은 화면 안에서 `problem[Random().nextInt(4)]` 로 정해져
/// 대역이 못 박을 수 없다. 그래서 오랫동안 유형 2 만 "정답/오답을 골라서"
/// 하는 검사가 통째로 빠져 있었고, B6(오답 복습 2번째 문제 TypeError)가 바로
/// 그 사각지대에서 살았다.
///
/// 화면에 손대지 않고 그 구멍을 메우는 통로가 하나 있다. 화면이 `intValue` 를
/// **문구로 공개**한다(`tellWhatMiss[intValue]`). 그 문구에서 `intValue` 를
/// 되찾고, 대역이 [call] 번째 호출에 내놓은 SATB 에서 정답을 계산한다.
/// 화면의 `easyProblemType2Answer = problem[intValue].format()` 과 같은 식이다.
///
/// [call] 은 지금 화면에 떠 있는 문제를 낸 대역 호출 번호다.
String type2AnswerLabel(int call) =>
    StubProblemSource.satbFor(call)[type2MissingVoiceOnScreen()].format();

/// 문제 화면을 실제 앱과 같은 방식으로 띄운다.
///
/// `lib/app.dart` 는 `MultiProvider` + `ScreenUtilInit` + `MaterialApp` 으로
/// 감싼다. 화면이 실제로 쓰는 것은 `CounterClass` 와 `ScreenUtil`, 그리고
/// `AppTheme` 의 색 확장뿐이다. `ThemeModeController` 와
/// `FirebaseAnalyticsObserver` 는 화면이 참조하지 않으므로 넣지 않는다.
///
/// 화면 크기를 못 박는 이유: `SizedBox(height: N.h)` 값이 화면 높이에 비례해
/// 결정되므로, 크기가 다르면 레이아웃 스냅샷 기대값이 달라진다.
Future<void> pumpQuizPage(WidgetTester tester, Widget page) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CounterClass())],
      child: ScreenUtilInit(
        designSize: const Size(375, 844),
        builder: (context, child) => MaterialApp(
          theme: AppTheme.light,
          home: child,
        ),
        child: page,
      ),
    ),
  );
  await tester.pump();
}

/// 보기 버튼들. 바텀시트가 떠 있으면 시트의 버튼도 잡히므로, 화면 본문
/// (`Scaffold` 의 `body`) 안쪽으로 한정한다.
Finder answerButtons() => find.descendant(
      of: find.byType(Scaffold),
      matching: find.byType(ElevatedButton),
    );
