import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:harmonypracticereal/core/ads/banner_ad_slot.dart';

/// B2 회귀 가드.
///
/// 예전에는 문제 화면 4종과 홈 화면이 각자 `BannerAd` 를 만들고 아무도
/// `dispose()` 하지 않아 화면을 드나들 때마다 네이티브 광고 객체가 쌓였다.
/// 지금은 [BannerAdSlot] 하나가 생성과 해제를 모두 쥐고 있다.
void main() {
  group('BannerAdSlot 위젯', () {
    testWidgets('광고를 못 만드는 환경에서도 앱은 계속 그려진다', (tester) async {
      // 테스트 환경에는 AdMob 네이티브 채널이 없고 배너 단위 ID 도 null 이라
      // 슬롯 안에서 BannerAd 가 아예 만들어지지 않는다.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('본문'),
                BannerAdSlot(),
              ],
            ),
          ),
        ),
      );

      expect(find.text('본문'), findsOneWidget);
      expect(find.byType(BannerAdSlot), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('광고가 없어도 배너 한 줄만큼 자리를 유지한다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Column(children: [BannerAdSlot()])),
        ),
      );

      final size = tester.getSize(find.byType(BannerAdSlot));
      expect(size.height, BannerAdSlot.slotHeight);
      expect(size.width, AdSize.banner.width.toDouble());
    });

    testWidgets('트리에서 빠졌다가 다시 들어와도 예외가 없다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: BannerAdSlot())),
      );
      // 화면 교체 → State.dispose 가 불리고 슬롯이 쥔 광고가 해제된다.
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('다른 화면'))),
      );
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: BannerAdSlot())),
      );

      expect(find.byType(BannerAdSlot), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    test('배너 높이는 AdSize.banner 와 같다', () {
      expect(BannerAdSlot.slotHeight, AdSize.banner.height.toDouble());
    });
  });

  group('B2 누수 회귀 가드 (lib/ 소스 스캔)', () {
    // 위젯 테스트로는 네이티브 해제를 관찰할 수 없다(테스트 환경에 채널이 없다).
    // 대신 "배너를 만드는 곳마다 해제하는 곳이 있다"를 소스 수준에서 못 박는다.
    late final List<File> libFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();

    test('lib/ 을 스캔할 수 있다', () {
      expect(libFiles.length, greaterThan(20));
    });

    test('BannerAd 를 만드는 곳은 banner_ad_slot.dart 한 곳뿐이다', () {
      final creators = <String>[];
      for (final file in libFiles) {
        final source = _stripComments(file.readAsStringSync());
        if (RegExp(r'\bBannerAd\s*\(').hasMatch(source)) {
          creators.add(file.path);
        }
      }

      expect(
        creators.map((p) => p.split(Platform.pathSeparator).last).toList(),
        ['banner_ad_slot.dart'],
        reason: '배너 생성을 여기저기 흩어 놓으면 해제 누락이 다시 생긴다',
      );
    });

    test('BannerAd 를 만드는 파일은 반드시 해제도 한다', () {
      for (final file in libFiles) {
        final source = _stripComments(file.readAsStringSync());
        if (!RegExp(r'\bBannerAd\s*\(').hasMatch(source)) continue;

        expect(
          RegExp(r'_banner\s*\?\.\s*dispose\s*\(\)').hasMatch(source),
          isTrue,
          reason: '${file.path} 가 BannerAd 를 만들지만 dispose 하지 않는다 (B2)',
        );
        expect(
          RegExp(r'void\s+dispose\s*\(\s*\)').hasMatch(source),
          isTrue,
          reason: '${file.path} 에 dispose 오버라이드가 없다 (B2)',
        );
      }
    });

    test('화면 코드에 AdWidget 을 직접 박아 두지 않는다', () {
      final direct = <String>[];
      for (final file in libFiles) {
        final source = _stripComments(file.readAsStringSync());
        if (file.path.endsWith('banner_ad_slot.dart')) continue;
        if (RegExp(r'\bAdWidget\s*\(').hasMatch(source)) {
          direct.add(file.path);
        }
      }

      expect(direct, isEmpty, reason: '배너 표시는 BannerAdSlot 을 거쳐야 한다');
    });
  });
}

/// 주석 안의 코드 조각이 스캔에 걸리지 않도록 걷어낸다.
String _stripComments(String source) => source
    .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
    .replaceAll(RegExp(r'^\s*//.*$', multiLine: true), '');
