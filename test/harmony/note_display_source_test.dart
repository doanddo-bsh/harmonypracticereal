// music_notes 값이 toString() 으로 화면에 나가는 것을 **호출부에서** 막는 테스트.
//
// 왜 별도 파일인가: 같은 디렉터리의 note_display_test.dart 는 라이브러리 계약만
// 고정한다 — format() 이 'A♯' 를 돌려주는지. 그런데 실제로 두 번 터진 회귀는
// 라이브러리가 아니라 **호출부**에 있었다.
//     Text('${condition}')            // problemType1.dart:853
//     Text('${condition}')            // problemType2.dart:792
//     intervalNumberButton(viewList[0].toString())
// format() 이 멀쩡해도 위젯이 toString() 을 쓰면 화면은 그대로 깨진다.
// 그 구멍을 닫으려고 lib/ 소스를 직접 읽어 검사한다.
//
// ── 이 테스트가 잡는 것 ────────────────────────────────────────────────
//  * music_notes 타입으로 **선언된** 변수를 문자열에 그대로 보간한 경우
//      '$condition', '${condition}', '${problem[i]}'
//  * 같은 변수에 .toString() 을 직접 호출한 경우
//      condition.toString(), viewList[0].toString()
//
// ── 이 테스트가 못 잡는 것 (중요, 과신 금지) ──────────────────────────
//  * 이건 파서가 아니라 **정규식 휴리스틱**이다. 타입 추론을 하지 않는다.
//  * 그래서 `final x = someNote;` 처럼 타입을 안 적은 변수는 추적 못 한다.
//    (아래 _trackedNames 는 명시적 타입 선언에서만 이름을 모은다.)
//  * 함수 반환값을 바로 보간하는 형태 — '${getTonality()}' — 도 못 잡는다.
//  * 주석 제거도 휴리스틱이라, 문자열 리터럴 안에 //가 들어 있으면
//    그 뒤를 주석으로 오인해 검사에서 빠질 수 있다 (거짓 음성).
//  * print/debugPrint 줄은 일부러 건너뛴다 — 개발자 콘솔용이라 사용자에게
//    보이지 않는다. 즉 print 안의 toString() 은 여기서 통과한다.
//  * 변수 이름이 아니라 타입만 바꾸면(예: dynamic 으로) 추적을 벗어난다.
//
// 즉 이 테스트는 "지금까지 실제로 발생한 형태"를 다시 못 들어오게 막는
// 그물이지, 완전한 보증이 아니다. 더 강한 보증이 필요하면 problemType 위젯을
// 실제로 pump 해서 렌더된 텍스트를 읽는 위젯 테스트를 써야 하는데,
// 그 페이지들은 Provider·ScreenUtil·AdMob 초기화까지 필요해 비용이 크다.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// music_notes 에서 온 타입 중, 화면에 그대로 내보내면 안 되는 것들.
/// (0.26 기준 전부 toString() 이 'Note(noteName: …)' 같은 디버그 표현이다.)
const _musicNotesTypes = [
  'Note',
  'Key',
  'Pitch',
  'Interval',
  'Accidental',
  'NoteName',
];

/// `//` 줄 주석과 `/* */` 블록 주석을 걷어낸다. (휴리스틱 — 위 주석 참고)
String _stripComments(String source) {
  final withoutBlocks = source.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '');
  return withoutBlocks
      .split('\n')
      .map((line) {
        final idx = line.indexOf('//');
        return idx == -1 ? line : line.substring(0, idx);
      })
      .join('\n');
}

/// 소스에서 music_notes 타입으로 **명시 선언된** 식별자 이름을 모은다.
/// 선언에서 뽑기 때문에 변수 이름을 바꿔도 같이 따라간다.
Set<String> _trackedNames(String source) {
  final types = _musicNotesTypes.join('|');
  final names = <String>{};

  // msc.Note foo / late msc.Key condition / final Note bar
  final scalar = RegExp(
    r'\b(?:late\s+)?(?:final\s+)?(?:msc\.)?(?:' + types + r')\??\s+([a-zA-Z_]\w*)',
  );
  // List<msc.Note> problem / List<Key>? viewList
  final list = RegExp(
    r'\bList<\s*(?:msc\.)?(?:' + types + r')\s*>\??\s+([a-zA-Z_]\w*)',
  );

  for (final m in scalar.allMatches(source)) {
    names.add(m.group(1)!);
  }
  for (final m in list.allMatches(source)) {
    names.add(m.group(1)!);
  }
  return names;
}

void main() {
  test('music_notes 값이 toString()/문자열 보간으로 화면에 나가지 않는다', () {
    final libDir = Directory('lib');
    expect(libDir.existsSync(), isTrue,
        reason: '프로젝트 루트에서 실행해야 한다 (lib/ 를 찾을 수 없다)');

    final offenders = <String>[];
    var scannedFiles = 0;
    var trackedTotal = 0;

    final dartFiles = libDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        // 생성 파일은 검사 대상이 아니다.
        .where((f) => !f.path.endsWith('firebase_options.dart'));

    for (final file in dartFiles) {
      final source = _stripComments(file.readAsStringSync());
      final tracked = _trackedNames(source);
      if (tracked.isEmpty) continue;

      scannedFiles++;
      trackedTotal += tracked.length;

      final lines = source.split('\n');
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        // 개발자 콘솔 출력은 사용자에게 보이지 않으므로 건너뛴다.
        if (line.contains('print(')) continue;

        for (final name in tracked) {
          final n = RegExp.escape(name);
          // 1) 문자열 보간에 알맹이 그대로: '$name' / '${name}' / '${name[i]}'
          final bareInterp = RegExp(
            r'\$\{?\s*' + n + r'\s*(?:\[[^\]]*\])?\s*\}|\$' + n + r'\b',
          );
          // 2) 직접 toString(): name.toString() / name[i].toString()
          final directToString = RegExp(
            r'\b' + n + r'\s*(?:\[[^\]]*\])?\s*\.toString\(\)',
          );

          if (bareInterp.hasMatch(line) || directToString.hasMatch(line)) {
            offenders.add(
              '${file.path}:${i + 1}  [$name]  ${line.trim()}',
            );
          }
        }
      }
    }

    // 그물이 실제로 뭔가를 보고 있는지 확인한다. 선언 패턴이 바뀌어
    // 추적 대상이 0이 되면 이 테스트는 조용히 무의미해지므로 여기서 막는다.
    expect(scannedFiles, greaterThan(0),
        reason: 'music_notes 타입 선언이 있는 파일을 하나도 못 찾았다 — '
            '선언 패턴이 바뀌었는지 확인하라 (_trackedNames)');
    expect(trackedTotal, greaterThan(20),
        reason: '추적 대상 식별자가 $trackedTotal 개뿐이다 — '
            '정규식이 더 이상 실제 선언을 잡지 못하는 것으로 보인다');

    expect(
      offenders,
      isEmpty,
      reason: 'music_notes 값을 표시용 문자열로 쓸 때는 toString() 이 아니라 '
          'format() 을 써야 한다.\n'
          '(0.26 의 toString() 은 "Note(noteName: NoteName.a, …)" 같은 '
          '디버그 표현이라 화면에 그대로 찍힌다.)\n'
          '문제 위치:\n  ${offenders.join('\n  ')}',
    );
  });
}
