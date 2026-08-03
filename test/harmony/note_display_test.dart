// 화면에 보이는 음이름/조성 표기를 고정하는 테스트.
//
// 왜 필요한가: music_notes 는 toString() 을 "사람이 읽는 표기"가 아니라
// "디버그 표현"으로 취급하고, 버전마다 그 형식을 바꾼다.
//   0.13.0  Note.toString()  == 'A♯'
//   0.26.0  Note.toString()  == 'Note(noteName: NoteName.a, accidental: Accidental(semitones: 1))'
//   0.13.0  Tonality.toString() == 'C♯ major'
//   0.26.0  Key.toString()      == 'Key(note: Note(...), mode: TonalMode.major)'
//
// 이 변화는 **조용하다**. 정답과 오답 보기가 같은 함수를 거치므로 채점은
// 계속 맞고, 컴파일도 되고, 기존 불변식 테스트도 통과한다. 오직 화면에
// 찍히는 글자만 쓰레기가 된다. 실제로 0.13 → 0.26 업그레이드에서 이
// 방식으로 Accidental 과 Note/Key 가 두 번 연속 깨졌다.
//
// 그래서 앱은 표시용으로 toString() 대신 format() 을 쓴다. 아래 테스트는
// format() 의 출력이 0.13.0 시절 toString() 출력과 글자 단위로 같은지를
// 고정하고, 덤으로 디버그 표현이 새어나오지 않는지도 검사한다.

import 'package:flutter_test/flutter_test.dart';
import 'package:music_notes/music_notes.dart';

import 'package:harmonypracticereal/harmonyModul/modulBasic.dart';

/// 표시 문자열에 절대 나오면 안 되는 디버그 표현의 흔적.
/// (music_notes 가 다시 toString 형식을 바꾸거나, 코드가 실수로
/// format() 대신 toString() 을 쓰면 여기 걸린다.)
void expectNoDebugArtifacts(String rendered, String what) {
  for (final marker in const [
    'noteName:',
    'accidental:',
    'semitones:',
    'mode:',
    'Instance of',
    'NoteName.',
    'TonalMode.',
  ]) {
    expect(rendered.contains(marker), isFalse,
        reason: '$what 표시에 디버그 표현 "$marker" 가 새어나왔다: "$rendered"');
  }
}

void main() {
  group('음이름 표시 (Note.format)', () {
    test('임시표 기호 표기가 0.13.0 toString 과 동일하다', () {
      expect(Note.c.format(), 'C');
      expect(Note.c.sharp.format(), 'C♯');
      expect(Note.c.flat.format(), 'C♭');
      expect(Note.c.sharp.sharp.format(), 'C𝄪');
      expect(Note.c.flat.flat.format(), 'C𝄫');

      expect(Note.a.format(), 'A');
      expect(Note.a.sharp.format(), 'A♯');
      expect(Note.a.flat.format(), 'A♭');
      expect(Note.a.sharp.sharp.format(), 'A𝄪');
      expect(Note.a.flat.flat.format(), 'A𝄫');

      expect(Note.f.sharp.format(), 'F♯');
      expect(Note.e.flat.format(), 'E♭');
    });

    test('7음 전체가 대문자 한 글자로 시작한다', () {
      const expected = {
        NoteName.c: 'C',
        NoteName.d: 'D',
        NoteName.e: 'E',
        NoteName.f: 'F',
        NoteName.g: 'G',
        NoteName.a: 'A',
        NoteName.b: 'B',
      };
      for (final entry in expected.entries) {
        expect(Note(entry.key).format(), entry.value);
      }
    });

    test('디버그 표현이 새어나오지 않는다', () {
      for (final name in NoteName.values) {
        for (var semitones = -2; semitones <= 2; semitones++) {
          final note = Note(name, Accidental(semitones));
          expectNoDebugArtifacts(note.format(), 'Note');
        }
      }
    });
  });

  group('조성 표시 (Key.format)', () {
    test('"음이름 + 모드" 표기가 0.13.0 toString 과 동일하다', () {
      expect(Note.c.major.format(), 'C major');
      expect(Note.c.minor.format(), 'C minor');
      expect(Note.c.sharp.major.format(), 'C♯ major');
      expect(Note.c.sharp.minor.format(), 'C♯ minor');
      expect(Note.c.flat.major.format(), 'C♭ major');
      expect(Note.a.major.format(), 'A major');
      expect(Note.a.minor.format(), 'A minor');
      expect(Note.a.flat.major.format(), 'A♭ major');
      expect(Note.a.sharp.minor.format(), 'A♯ minor');
    });

    test('디버그 표현이 새어나오지 않는다', () {
      for (final name in NoteName.values) {
        for (var semitones = -2; semitones <= 2; semitones++) {
          final note = Note(name, Accidental(semitones));
          expectNoDebugArtifacts(note.major.format(), 'Key(major)');
          expectNoDebugArtifacts(note.minor.format(), 'Key(minor)');
        }
      }
    });
  });

  group('실제 출제기 결과를 표시 경로에 태워보기', () {
    // 위 테스트들은 music_notes 의 표시 API 계약만 본다. 이건 한 발 더 나아가
    // 실제 문제 생성기가 돌려준 조성/구성음을 화면에 쓰는 방식 그대로
    // format() 에 태워, 나오는 글자가 사람이 읽을 수 있는 형태인지 본다.
    // (problemType1~4 가 조성과 음이름을 이렇게 렌더링한다.)
    test('basicProblem 의 조성과 음이 사람이 읽는 표기로 나온다', () {
      for (var i = 0; i < 50; i++) {
        final (_, problem, condition, _, _) = basicProblem();

        final keyText = condition.format();
        expectNoDebugArtifacts(keyText, '조성 (회차 $i)');
        expect(keyText, matches(RegExp(r'^[A-G][♯♭𝄪𝄫]* (major|minor)$')),
            reason: '조성 표기가 "C♯ major" 꼴이어야 한다 (회차 $i): "$keyText"');

        for (final note in problem) {
          final noteText = note.format();
          expectNoDebugArtifacts(noteText, '음이름 (회차 $i)');
          expect(noteText, matches(RegExp(r'^[A-G][♯♭𝄪𝄫]*$')),
              reason: '음이름 표기가 "A♯" 꼴이어야 한다 (회차 $i): "$noteText"');
        }
      }
    });
  });

  group('임시표 분류 (Accidental 상수 비교)', () {
    // problemFuncHarmony.dart / problemFuncDeco.dart 가 임시표를 판정할 때
    // 쓰던 toString() 문자열 비교를 상수 비교로 바꾼 것이 유효한지 확인한다.
    test('semitones 로 임시표가 유일하게 식별된다', () {
      expect(Accidental.natural.semitones, 0);
      expect(Accidental.sharp.semitones, 1);
      expect(Accidental.flat.semitones, -1);
      expect(Accidental.doubleSharp.semitones, 2);
      expect(Accidental.doubleFlat.semitones, -2);

      expect(Note.c.sharp.accidental == Accidental.sharp, isTrue);
      expect(Note.c.flat.accidental == Accidental.flat, isTrue);
      expect(Note.c.accidental == Accidental.natural, isTrue);
      expect(Note.c.sharp.sharp.accidental == Accidental.doubleSharp, isTrue);
      expect(Note.c.flat.flat.accidental == Accidental.doubleFlat, isTrue);
    });
  });
}
