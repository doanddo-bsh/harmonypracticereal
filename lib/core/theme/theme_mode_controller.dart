import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 테마 설정값의 저장·복원.
///
/// **왜 `shared_preferences` 이고 `async_preferences` 가 아닌가.**
/// `async_preferences` 는 UMP SDK 가 네이티브 쪽에서 직접 써 넣는
/// `IABTCF_*` 키를 Dart 에서 **읽기만** 하려고 쓰는 통로다
/// (`settings_page` / `home_page` 의 `IABTCF_gdprApplies`).
/// 이 값은 우리가 쓰고 우리가 읽는 앱 설정이므로 플랫폼 표준 저장소를
/// 그대로 쓰는 `shared_preferences` 가 맞다.
class ThemeModePreference {
  ThemeModePreference._();

  /// 저장 키.
  ///
  /// 디스크에 실제로 남는 이름은 `flutter.settings.themeMode` 다 —
  /// `shared_preferences` 가 모든 키에 `flutter.` 접두사를 붙인다
  /// (Android 는 `FlutterSharedPreferences` XML, iOS 는 NSUserDefaults).
  /// UMP 의 `IABTCF_*` 는 접두사 없는 기본 저장소에 있으므로 충돌하지 않는다.
  static const String key = 'settings.themeMode';

  /// 저장된 값이 없거나 알아볼 수 없을 때 쓰는 값.
  ///
  /// 시스템 설정을 따르는 것이 테마 설정의 관례적 기대다. 이 값을 바꾸면
  /// **이미 설치된 사용자 전원**의 첫 실행 외형이 바뀐다 (아직 아무도
  /// 이 키를 저장한 적이 없기 때문이다).
  static const ThemeMode defaultThemeMode = ThemeMode.system;

  /// enum 의 `index` 가 아니라 문자열로 적는다.
  /// index 는 Flutter 가 `ThemeMode` 에 값을 추가하거나 순서를 바꾸면
  /// 저장된 값이 조용히 다른 뜻이 된다 — 마이그레이션 없이 외형이 뒤집힌다.
  static String encode(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };

  /// 모르는 문자열과 `null` 은 전부 [defaultThemeMode] 로 떨어뜨린다.
  static ThemeMode decode(String? raw) => switch (raw) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => defaultThemeMode,
      };

  /// 디스크에서 읽는다. 실패하면 [defaultThemeMode].
  ///
  /// 이 호출은 `main()` 이 `runApp()` **전에** await 한다. 여기서 던지면
  /// 앱이 아예 뜨지 않으므로 어떤 예외도 밖으로 내보내지 않는다.
  static Future<ThemeMode> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return decode(preferences.getString(key));
    } catch (_) {
      return defaultThemeMode;
    }
  }

  /// 디스크에 쓴다. 성공 여부를 돌려준다.
  ///
  /// 실패해도 화면은 이미 바뀐 뒤다 — 다음 실행에서 기본값으로 돌아가는
  /// 것 말고는 영향이 없으므로 사용자에게 알리지 않는다.
  static Future<bool> save(ThemeMode mode) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return await preferences.setString(key, encode(mode));
    } catch (_) {
      return false;
    }
  }
}

/// 지금 선택된 [ThemeMode] 를 들고 있고, 바뀌면 알린다.
///
/// **왜 `lib/core/theme/` 인가.** `lib/domain/` 은 화성학과 퀴즈 진행처럼
/// 이 앱이 무엇을 가르치는지에 대한 지식을 담는다 (`CounterClass` 도
/// 푼 문제 수라는 퀴즈 상태다). 테마 선택은 그 어느 쪽도 아니고,
/// [AppTheme] 이 만든 두 [ThemeData] 중 무엇을 쓸지 고르는 표현 계층
/// 배선이다. 이미 같은 디렉터리에 [AppColors]·[AppTheme] 이 있으므로
/// '테마'라는 한 관심사를 한 폴더에 둔다.
///
/// 값의 **초기치는 생성자로 주입받는다.** 스스로 비동기 로딩을 시작하지
/// 않는 것이 핵심이다 — 자세한 이유는 [ThemeModePreference.load] 와
/// `main()` 주석 참고.
class ThemeModeController extends ChangeNotifier {
  ThemeModeController({
    ThemeMode initial = ThemeModePreference.defaultThemeMode,
  }) : _themeMode = initial;

  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  /// 선택을 바꾸고 저장한다. 같은 값이면 아무것도 하지 않는다
  /// (라디오를 다시 눌렀다고 트리 전체를 다시 그릴 이유가 없다).
  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;
    _themeMode = mode;
    // 화면을 먼저 바꾸고 저장은 그 뒤에 한다. 디스크 쓰기를 기다리는 동안
    // 라디오가 굳어 보이면 안 된다.
    notifyListeners();
    await ThemeModePreference.save(mode);
  }
}
