import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmonypracticereal/core/ads/ad_ids.dart';

/// 이 테스트가 지키는 성질은 하나다:
/// **아무것도 주입하지 않은 빌드는 절대 실전 광고를 띄우지 않는다.**
///
/// 실수의 결과가 "광고가 안 나간다" 쪽이어야지 "남의 AdMob 계정에 가짜 노출이
/// 찍힌다" 쪽이면 안 된다. 예전 코드는 `kReleaseMode` 하나로 갈랐기 때문에
/// QA 용 릴리스 빌드가 그대로 실전 광고를 띄웠다.
///
/// `String.fromEnvironment` 는 컴파일 시점에 상수로 접혀서 런타임에 바꿀 수
/// 없다. 그래서 주입 경로는 테스트 안에서 같은 값을 다시 읽어 두 갈래로
/// 단언한다 — `--dart-define` 없이 돌리면 폴백을, 주면 주입값을 확인한다.
/// 어느 쪽이든 vacuous 하게 통과하지 않는다.
const _injectedBannerAndroid = String.fromEnvironment('ADMOB_BANNER_ANDROID');
const _injectedBannerIos = String.fromEnvironment('ADMOB_BANNER_IOS');
const _injectedInterstitialAndroid = String.fromEnvironment(
  'ADMOB_INTERSTITIAL_ANDROID',
);
const _injectedInterstitialIos = String.fromEnvironment(
  'ADMOB_INTERSTITIAL_IOS',
);

/// 구글 공식 테스트 계정의 퍼블리셔 ID. 이 접두사면 실전 광고가 아니다.
const _googleTestPublisher = 'ca-app-pub-3940256099942544';

void main() {
  group('주입이 없으면 구글 테스트 ID 로 폴백한다', () {
    test('dart-define 이 없으면 배너·전면 모두 테스트 ID 다', () {
      // CI 와 로컬 `flutter test` 는 --dart-define 을 주지 않는다.
      if (_injectedBannerAndroid.isEmpty) {
        expect(
          AdIds.bannerFor(TargetPlatform.android),
          AdIds.testBannerAndroid,
        );
      }
      if (_injectedBannerIos.isEmpty) {
        expect(AdIds.bannerFor(TargetPlatform.iOS), AdIds.testBannerIos);
      }
      if (_injectedInterstitialAndroid.isEmpty) {
        expect(
          AdIds.interstitialFor(TargetPlatform.android),
          AdIds.testInterstitialAndroid,
        );
      }
      if (_injectedInterstitialIos.isEmpty) {
        expect(
          AdIds.interstitialFor(TargetPlatform.iOS),
          AdIds.testInterstitialIos,
        );
      }

      // 위 네 갈래가 전부 건너뛰어져 아무것도 검증하지 않는 일이 없게 한다.
      expect(
        [
          _injectedBannerAndroid,
          _injectedBannerIos,
          _injectedInterstitialAndroid,
          _injectedInterstitialIos,
        ].where((v) => v.isEmpty),
        isNotEmpty,
        reason: '네 개를 전부 주입한 채로 이 테스트를 돌리면 폴백을 검증할 수 없다',
      );
    });

    test('폴백 상수 네 개는 전부 구글 테스트 퍼블리셔다', () {
      expect(AdIds.testBannerAndroid, startsWith('$_googleTestPublisher/'));
      expect(AdIds.testBannerIos, startsWith('$_googleTestPublisher/'));
      expect(
        AdIds.testInterstitialAndroid,
        startsWith('$_googleTestPublisher/'),
      );
      expect(AdIds.testInterstitialIos, startsWith('$_googleTestPublisher/'));
    });

    test('ID 는 절대 비지 않는다', () {
      for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
        expect(AdIds.bannerFor(platform), isNotEmpty);
        expect(AdIds.interstitialFor(platform), isNotEmpty);
      }
      expect(AdIds.banner, isNotEmpty);
      expect(AdIds.interstitial, isNotEmpty);
    });
  });

  group('주입하면 그 값을 쓴다', () {
    // `--dart-define=ADMOB_BANNER_ANDROID=...` 로 돌리면 이 갈래가 켜진다.
    test('ADMOB_BANNER_ANDROID', () {
      expect(
        AdIds.bannerFor(TargetPlatform.android),
        _injectedBannerAndroid.isEmpty
            ? AdIds.testBannerAndroid
            : _injectedBannerAndroid,
      );
    });

    test('ADMOB_BANNER_IOS', () {
      expect(
        AdIds.bannerFor(TargetPlatform.iOS),
        _injectedBannerIos.isEmpty ? AdIds.testBannerIos : _injectedBannerIos,
      );
    });

    test('ADMOB_INTERSTITIAL_ANDROID', () {
      expect(
        AdIds.interstitialFor(TargetPlatform.android),
        _injectedInterstitialAndroid.isEmpty
            ? AdIds.testInterstitialAndroid
            : _injectedInterstitialAndroid,
      );
    });

    test('ADMOB_INTERSTITIAL_IOS', () {
      expect(
        AdIds.interstitialFor(TargetPlatform.iOS),
        _injectedInterstitialIos.isEmpty
            ? AdIds.testInterstitialIos
            : _injectedInterstitialIos,
      );
    });

    test('한쪽 플랫폼만 주입해도 다른 쪽이 오염되지 않는다', () {
      // 안드로이드만 주입한 빌드에서 iOS 배너가 안드로이드 값을 물려받으면
      // 잘못된 계정에 노출이 찍힌다.
      if (_injectedBannerAndroid.isNotEmpty && _injectedBannerIos.isEmpty) {
        expect(AdIds.bannerFor(TargetPlatform.iOS), AdIds.testBannerIos);
      }
      expect(
        AdIds.bannerFor(TargetPlatform.android) ==
            AdIds.bannerFor(TargetPlatform.iOS),
        isFalse,
        reason: '두 플랫폼이 같은 단위 ID 를 쓰면 안 된다',
      );
    });
  });

  group('플랫폼 게이트', () {
    test('adsAvailable 은 호스트 OS 를 본다', () {
      // 테스트는 데스크톱에서 돈다 → 광고를 만들면 안 된다.
      // defaultTargetPlatform 을 봤다면 위젯 테스트에서 android 로 덮어써져
      // 채널도 없는 환경에서 광고 객체를 만들려 들었을 것이다.
      expect(AdIds.adsAvailable, Platform.isAndroid || Platform.isIOS);
      expect(
        AdIds.adsAvailable,
        isFalse,
        reason: '이 테스트는 데스크톱 호스트에서 도는 것을 전제로 한다',
      );
    });
  });

  group('실전 ID 가 소스에 다시 들어오지 않는다 (회귀 가드)', () {
    final libFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();

    test('lib/ 을 스캔할 수 있다', () {
      expect(libFiles.length, greaterThan(20));
    });

    test('lib/ 안의 광고 단위 ID 리터럴은 전부 구글 테스트 퍼블리셔다', () {
      final adUnitId = RegExp(r'ca-app-pub-(\d+)/\d+');
      final offenders = <String>[];

      for (final file in libFiles) {
        for (final match in adUnitId.allMatches(file.readAsStringSync())) {
          if (match.group(1) != '3940256099942544') {
            offenders.add('${file.path}: ${match.group(0)}');
          }
        }
      }

      expect(
        offenders,
        isEmpty,
        reason: '실전 광고 단위 ID 는 소스가 아니라 --dart-define 으로 들어와야 한다',
      );
    });
  });
}
