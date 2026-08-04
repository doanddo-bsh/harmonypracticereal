import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmonypracticereal/core/theme/theme_mode_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 테마 설정의 저장·복원과 알림 계약을 고정한다.
///
/// 여기서 지키려는 것 세 가지:
///  1. 기본값이 [ThemeMode.system] 이다 — 이 값을 말없이 바꾸면 이미 설치된
///     사용자 전원의 첫 실행 외형이 바뀐다.
///  2. 디스크에 남는 표현이 enum index 가 아니라 문자열이다.
///  3. 값이 바뀔 때만 알린다.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // 매 테스트마다 빈 저장소에서 시작한다.
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('기본값', () {
    test('저장된 값이 없으면 ThemeMode.system 이다', () async {
      expect(await ThemeModePreference.load(), ThemeMode.system);
    });

    test('선언된 기본값 자체가 system 이다', () {
      expect(ThemeModePreference.defaultThemeMode, ThemeMode.system);
    });

    test('컨트롤러를 인자 없이 만들면 system 으로 시작한다', () {
      expect(ThemeModeController().themeMode, ThemeMode.system);
    });

    test('컨트롤러는 주입된 초기값을 그대로 쓴다', () {
      expect(
        ThemeModeController(initial: ThemeMode.dark).themeMode,
        ThemeMode.dark,
      );
    });
  });

  group('디스크 표현', () {
    test('세 값 모두 문자열로 오간다 (index 가 아니다)', () {
      expect(ThemeModePreference.encode(ThemeMode.light), 'light');
      expect(ThemeModePreference.encode(ThemeMode.dark), 'dark');
      expect(ThemeModePreference.encode(ThemeMode.system), 'system');
    });

    test('encode → decode 왕복이 항등이다', () {
      for (final mode in ThemeMode.values) {
        expect(
          ThemeModePreference.decode(ThemeModePreference.encode(mode)),
          mode,
          reason: '$mode 왕복 실패',
        );
      }
    });

    test('null 과 모르는 문자열은 기본값으로 떨어진다', () {
      expect(ThemeModePreference.decode(null), ThemeMode.system);
      expect(ThemeModePreference.decode(''), ThemeMode.system);
      expect(ThemeModePreference.decode('2'), ThemeMode.system);
      expect(ThemeModePreference.decode('DARK'), ThemeMode.system);
      expect(ThemeModePreference.decode('ThemeMode.dark'), ThemeMode.system);
    });

    test('저장된 값이 깨져 있어도 앱은 기본값으로 뜬다', () async {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(ThemeModePreference.key, '쓰레기값');

      expect(await ThemeModePreference.load(), ThemeMode.system);
    });

    test('키 이름이 문서화된 그대로다', () {
      expect(ThemeModePreference.key, 'settings.themeMode');
    });
  });

  group('저장 왕복', () {
    for (final mode in ThemeMode.values) {
      test('$mode 를 저장하면 다시 읽었을 때 같은 값이 나온다', () async {
        expect(await ThemeModePreference.save(mode), isTrue);
        expect(await ThemeModePreference.load(), mode);
      });
    }

    test('컨트롤러로 바꾼 값이 디스크에 남는다', () async {
      final controller = ThemeModeController();

      await controller.setThemeMode(ThemeMode.dark);

      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getString(ThemeModePreference.key), 'dark');
      // 다음 실행을 흉내낸다 — 새 컨트롤러가 저장된 값으로 시작한다.
      expect(
        ThemeModeController(initial: await ThemeModePreference.load()).themeMode,
        ThemeMode.dark,
      );
    });
  });

  group('알림', () {
    test('값이 바뀌면 알린다', () async {
      final controller = ThemeModeController();
      var notifications = 0;
      controller.addListener(() => notifications++);

      await controller.setThemeMode(ThemeMode.dark);

      expect(controller.themeMode, ThemeMode.dark);
      expect(notifications, 1);
    });

    test('같은 값을 다시 넣으면 알리지 않는다', () async {
      final controller = ThemeModeController(initial: ThemeMode.light);
      var notifications = 0;
      controller.addListener(() => notifications++);

      await controller.setThemeMode(ThemeMode.light);

      expect(notifications, 0);
    });

    test('연속으로 바꾸면 바뀐 횟수만큼 알린다', () async {
      final controller = ThemeModeController();
      var notifications = 0;
      controller.addListener(() => notifications++);

      await controller.setThemeMode(ThemeMode.light);
      await controller.setThemeMode(ThemeMode.dark);
      await controller.setThemeMode(ThemeMode.dark);
      await controller.setThemeMode(ThemeMode.system);

      expect(notifications, 3);
      expect(controller.themeMode, ThemeMode.system);
    });

    test('저장이 끝나기 전에 이미 알린다 (화면이 먼저 바뀐다)', () {
      final controller = ThemeModeController();
      var notified = false;
      controller.addListener(() => notified = true);

      // await 하지 않는다 — notifyListeners 가 첫 await 이전에 불려야 한다.
      controller.setThemeMode(ThemeMode.dark);

      expect(notified, isTrue);
      expect(controller.themeMode, ThemeMode.dark);
    });
  });
}
