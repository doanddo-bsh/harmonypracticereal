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

  test('getOneToSeven 은 7 을, getOneToSix 는 6 을 넘지 않는다 - 경계 회귀', () {
    // 예전 minor_problems.dart 의 getOneToSix 는 내부 리스트 변수명이
    // oneToSeven 이라 6까지만 담는다는 사실이 이름에 가려져 있었다.
    // 두 함수를 한 곳으로 합치면서 경계를 명시적으로 고정해 둔다.
    var sawSeven = false;
    for (var i = 0; i < 2000; i++) {
      if (getOneToSix() == 7) sawSeven = true;
    }
    expect(sawSeven, isFalse, reason: 'getOneToSix 가 7 을 내면 안 된다');
  });
}
