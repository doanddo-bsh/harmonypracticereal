import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:harmonypracticereal/core/ads/interstitial_ad_slot.dart';
import 'package:harmonypracticereal/core/ads/interstitial_trigger.dart';

/// 전면 광고 누수 가드.
///
/// 예전에는 문제 화면 4종과 홈 화면 목록 4종이 저마다 같은 `loadAd()` 를
/// 복제해 갖고 있었고(8벌), 아무도 `State.dispose()` 에서 적재해 둔 광고를
/// 놓아 주지 않았다. 표시된 광고만 전체화면 콜백에서 해제됐으므로 **끝내
/// 표시되지 않은** 광고는 그대로 남았다. 배너에서 똑같이 겪은 B2 를 전면
/// 광고에서 반복하지 않도록, 생성 지점이 하나뿐이고 그 파일이 해제까지
/// 책임진다는 사실을 소스 수준에서 못 박는다.
///
/// 실제 네이티브 해제는 여기서 관찰할 수 없다(테스트 환경에 AdMob 채널이
/// 없어 `AdIds.adsAvailable` 이 false 이고, 광고 객체가 아예 만들어지지
/// 않는다). 그래서 동작 검사는 "채널이 없어도 안 죽는다 · 없는 광고를
/// 띄웠다고 하지 않는다"까지고, 나머지는 소스 스캔이 지킨다.
void main() {
  group('InterstitialAdSlot', () {
    test('광고를 못 만드는 환경에서는 적재해도 띄울 광고가 없다', () {
      final slot = InterstitialAdSlot();
      addTearDown(slot.dispose);

      slot.load();

      // 적재는 비동기다. 실제 기기에서도 이 자리에서는 아직 false 다 —
      // 그래서 "지금 뜨는 광고는 언제나 지난번에 적재해 둔 것"이 된다.
      expect(slot.hasAdReady, isFalse);
      expect(slot.showIfLoaded(), isFalse);
    });

    test('기준 미만이면 아무것도 하지 않는다', () {
      final slot = InterstitialAdSlot();
      addTearDown(slot.dispose);

      expect(slot.loadAndMaybeShow(criticalNumberSolved - 1), isFalse);
    });

    test('기준을 넘겨도 적재분이 없으면 띄웠다고 하지 않는다', () {
      final slot = InterstitialAdSlot();
      addTearDown(slot.dispose);

      // 여기서 true 를 돌려주면 호출부가 누적 풀이 수를 되돌려 버린다.
      // 광고는 안 떴는데 카운터만 깎이는 상태가 된다.
      expect(slot.loadAndMaybeShow(criticalNumberSolved), isFalse);
      expect(slot.loadAndMaybeShow(criticalNumberSolved + 1), isFalse);
    });

    test('해제한 뒤에 적재를 불러도 죽지 않는다', () {
      final slot = InterstitialAdSlot();

      slot.dispose();
      slot.load();
      slot.dispose(); // 두 번 불러도 안전해야 한다.

      expect(slot.hasAdReady, isFalse);
      expect(slot.showIfLoaded(), isFalse);
    });
  });

  group('전면 광고 누수 회귀 가드 (lib/ 소스 스캔)', () {
    late final List<File> libFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();

    test('lib/ 을 스캔할 수 있다', () {
      expect(libFiles.length, greaterThan(20));
    });

    test('전면 광고를 만드는 곳은 interstitial_ad_slot.dart 한 곳뿐이다', () {
      final creators = <String>[];
      for (final file in libFiles) {
        final source = _stripComments(file.readAsStringSync());
        if (RegExp(r'\bInterstitialAd\s*\.\s*load\s*\(').hasMatch(source)) {
          creators.add(file.path);
        }
      }

      expect(
        creators.map((p) => p.split(Platform.pathSeparator).last).toList(),
        ['interstitial_ad_slot.dart'],
        reason: '적재를 여기저기 흩어 놓으면 해제 누락이 다시 생긴다',
      );
    });

    test('전면 광고를 만드는 파일은 반드시 해제도 한다', () {
      for (final file in libFiles) {
        final source = _stripComments(file.readAsStringSync());
        if (!RegExp(r'\bInterstitialAd\s*\.\s*load\s*\(').hasMatch(source)) {
          continue;
        }

        expect(
          RegExp(r'_ad\s*\?\.\s*dispose\s*\(\)').hasMatch(source),
          isTrue,
          reason: '${file.path} 가 전면 광고를 적재하지만 해제하지 않는다',
        );
        expect(
          RegExp(r'void\s+dispose\s*\(\s*\)').hasMatch(source),
          isTrue,
          reason: '${file.path} 에 dispose 가 없다',
        );
      }
    });

    test('화면 코드가 InterstitialAd 를 직접 들고 있지 않다', () {
      final holders = <String>[];
      for (final file in libFiles) {
        if (file.path.endsWith('interstitial_ad_slot.dart')) continue;
        final source = _stripComments(file.readAsStringSync());
        if (RegExp(r'\bInterstitialAd\b').hasMatch(source)) {
          holders.add(file.path);
        }
      }

      expect(
        holders.where((p) => !p.endsWith('interstitial_ad_slot.dart')).toList(),
        isEmpty,
        reason: '전면 광고 인스턴스는 InterstitialAdSlot 밖으로 새어 나가지 않는다',
      );
    });

    test('화면이 만든 슬롯 수만큼 해제도 있다', () {
      // 홈처럼 한 파일에 목록 4종이 각자 슬롯을 들고 있는 경우가 있어
      // "해제가 하나라도 있으면 통과"로는 부족하다. 개수를 맞춰 둔다.
      for (final file in libFiles) {
        if (file.path.endsWith('interstitial_ad_slot.dart')) continue;
        final source = _stripComments(file.readAsStringSync());

        final created = RegExp(
          r'InterstitialAdSlot\s*\(\s*\)',
        ).allMatches(source).length;
        if (created == 0) continue;

        final disposed = RegExp(
          r'_interstitial\s*\.\s*dispose\s*\(\s*\)',
        ).allMatches(source).length;

        expect(
          disposed,
          created,
          reason: '${file.path} 가 슬롯 $created 개를 만들지만 해제는 $disposed 개다',
        );
      }
    });
  });
}

/// 주석 안의 코드 조각이 스캔에 걸리지 않도록 걷어낸다.
String _stripComments(String source) => source
    .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
    .replaceAll(RegExp(r'^\s*//.*$', multiLine: true), '');
