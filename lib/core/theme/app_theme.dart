import 'package:flutter/material.dart';
import 'package:harmonypracticereal/core/theme/app_colors.dart';

/// 앱 전체 ThemeData 조립.
///
/// 라이트는 종전 `main.dart` 가 만들던 것과 **의도적으로 동일**하다:
/// `ColorScheme.fromSeed(seedColor: Colors.white)` + `useMaterial3`.
/// 여기에 [AppColors] 확장만 붙였다. 시드를 바꾸면 Scaffold 배경·AppBar·
/// 기본 버튼색이 전부 미묘하게 달라지므로, 출시 중인 앱과 픽셀 단위로
/// 같게 유지하기 위해 흰색 시드를 그대로 둔다.
///
/// `appBarTheme` / `bottomSheetTheme` / `cardTheme` 같은 컴포넌트 테마는
/// 일부러 넣지 않았다. 넣는 순간(예: `showDragHandle: true`) 지금 화면이
/// 달라진다. 이번 작업은 색 배선만 한다.
class AppTheme {
  AppTheme._();

  static const Color _seed = Colors.white;

  static final ThemeData light = _build(Brightness.light, AppColors.light);

  static final ThemeData dark = _build(Brightness.dark, AppColors.dark);

  static ThemeData _build(Brightness brightness, AppColors colors) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: brightness,
      ),
      extensions: <ThemeExtension<dynamic>>[colors],
    );
  }
}
