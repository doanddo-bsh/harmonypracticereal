import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmonypracticereal/core/theme/app_theme.dart';
import 'package:harmonypracticereal/core/theme/theme_mode_controller.dart';
import 'package:harmonypracticereal/ui/settings/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 설정 화면의 테마 섹션이 실제로 앱 밝기를 바꾸는지 본다.
///
/// 트리는 `app.dart` 와 같은 모양으로 세운다 —
/// ChangeNotifierProvider → Consumer → MaterialApp(themeMode:).
/// 그래야 '라디오를 누르면 정말로 다크로 칠해진다'까지 확인된다.
///
/// 주의: [SettingPage] 는 initState 에서 `AsyncPreferences` 로 UMP 의
/// `IABTCF_gdprApplies` 를 읽는다. 테스트 환경에는 그 네이티브 채널이 없어
/// Future 가 에러로 끝나지만, FutureBuilder 가 삼키고 GDPR 항목만
/// 렌더되지 않는다. 테마 섹션은 그 결과와 무관하게 항상 그려진다.
Widget _app(ThemeModeController controller) {
  return ChangeNotifierProvider<ThemeModeController>.value(
    value: controller,
    child: Consumer<ThemeModeController>(
      builder: (context, themeModeController, _) => MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeModeController.themeMode,
        home: const SettingPage(),
      ),
    ),
  );
}

Brightness _renderedBrightness(WidgetTester tester) {
  return Theme.of(tester.element(find.byType(SettingPage))).brightness;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('세 가지 선택지가 한국어로 모두 보인다', (tester) async {
    await tester.pumpWidget(_app(ThemeModeController()));
    await tester.pump();

    expect(find.text('라이트 모드'), findsOneWidget);
    expect(find.text('다크 모드'), findsOneWidget);
    expect(find.text('시스템 설정 따름'), findsOneWidget);
    expect(find.byType(RadioListTile<ThemeMode>), findsNWidgets(3));
  });

  testWidgets('현재 선택을 표시한다', (tester) async {
    await tester.pumpWidget(
      _app(ThemeModeController(initial: ThemeMode.dark)),
    );
    await tester.pump();

    final group = tester.widget<RadioGroup<ThemeMode>>(
      find.byType(RadioGroup<ThemeMode>),
    );
    expect(group.groupValue, ThemeMode.dark);
  });

  testWidgets('다크 모드를 고르면 앱이 실제로 어두워지고 저장된다', (tester) async {
    final controller = ThemeModeController();
    await tester.pumpWidget(_app(controller));
    await tester.pump();

    // 테스트 환경의 platformBrightness 는 light 라 system == light 로 그려진다.
    expect(_renderedBrightness(tester), Brightness.light);

    await tester.tap(find.text('다크 모드'));
    await tester.pumpAndSettle();

    expect(controller.themeMode, ThemeMode.dark);
    expect(_renderedBrightness(tester), Brightness.dark);
    expect(
      tester
          .widget<RadioGroup<ThemeMode>>(find.byType(RadioGroup<ThemeMode>))
          .groupValue,
      ThemeMode.dark,
    );
    expect(await ThemeModePreference.load(), ThemeMode.dark);
  });

  testWidgets('라이트 모드를 고르면 시스템이 다크여도 밝게 유지된다', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    final controller = ThemeModeController();
    await tester.pumpWidget(_app(controller));
    await tester.pump();

    // system 기본값이므로 처음에는 기기를 따라 어둡다.
    expect(_renderedBrightness(tester), Brightness.dark);

    await tester.tap(find.text('라이트 모드'));
    await tester.pumpAndSettle();

    expect(controller.themeMode, ThemeMode.light);
    expect(_renderedBrightness(tester), Brightness.light);
    expect(await ThemeModePreference.load(), ThemeMode.light);
  });
}
