import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harmonypracticereal/core/theme/app_colors.dart';
import 'package:harmonypracticereal/core/theme/app_theme.dart';

void main() {
  // 이 값들은 '이전 colorList.dart 에 뭐라고 적혀 있었나'가 아니라
  // '이 커밋 직전에 화면에 실제로 칠해지던 값이 뭐였나'다. 죽은 상수
  // color3/color7/color9 는 여기 없다 — 아무것도 렌더링하지 않았다.
  group('라이트 테마는 종전 화면 색을 그대로 유지한다', () {
    final c = AppColors.light;

    test('easyAccent', () => expect(c.easyAccent, const Color(0xff63af5b)));
    test('hardAccent', () => expect(c.hardAccent, const Color(0xffe36d3f)));
    test('nextButtonLabel', () => expect(c.nextButtonLabel, Colors.white54));
    test('progressSuperEasy', () => expect(c.progressSuperEasy, const Color(0xfff2c35b)));
    test('progressEasy', () => expect(c.progressEasy, const Color(0xff539706)));
    test('progressHard', () => expect(c.progressHard, const Color(0xffae2c1f)));
    test('progressCustom', () => expect(c.progressCustom, const Color(0xff656565)));
    test('progressTrack', () => expect(c.progressTrack, Colors.black12));
    test('tabSuperEasy', () => expect(c.tabSuperEasy, const Color(0xfff8b306)));
    test('tabEasy', () => expect(c.tabEasy, const Color(0xff3f8a36)));
    test('tabHard', () => expect(c.tabHard, const Color(0xffc94040)));
    test('tabCustom', () => expect(c.tabCustom, const Color(0xff656565)));
    test('tabIndicator', () => expect(c.tabIndicator, Colors.black38));
    test('correctText', () => expect(c.correctText, const Color(0xff4b7947)));
    test('correctSheetBackground', () => expect(c.correctSheetBackground, const Color(0xffacd0a8)));
    test('wrongText', () => expect(c.wrongText, const Color(0xff79474e)));
    test('wrongSheetBackground', () => expect(c.wrongSheetBackground, const Color(0xffd7b1b1)));
    test('staffSurface', () => expect(c.staffSurface, Colors.transparent));
    test('promptText', () => expect(c.promptText, Colors.black54));
    test('divider', () => expect(c.divider, Colors.black12));
    test('choiceFill', () => expect(c.choiceFill, const Color(0xFFF6F6F6)));
    test('choiceLabel', () => expect(c.choiceLabel, Colors.black));
    test('pageBackground', () => expect(c.pageBackground, Colors.white));
    test('tileSurface', () => expect(c.tileSurface, Colors.white));
    test('tileBorder', () => expect(c.tileBorder, const Color(0xffdedede)));
    test('tileSeparator', () => expect(c.tileSeparator, Colors.grey));
    test('selectButtonFill', () => expect(c.selectButtonFill, const Color(0xfff6f6f6)));
    test('selectButtonLabel', () => expect(c.selectButtonLabel, Colors.black38));
    test('dialogSurface', () => expect(c.dialogSurface, Colors.white));
    test('dialogTitleText', () => expect(c.dialogTitleText, const Color(0xff3a3a3a)));
    test('dialogBodyText', () => expect(c.dialogBodyText, const Color(0xff797979)));
    test('dialogActionText', () => expect(c.dialogActionText, const Color(0xff2f2f2f)));
    test('selectorTitleText', () => expect(c.selectorTitleText, const Color(0xff424242)));
    test('checkboxActive', () => expect(c.checkboxActive, const Color(0xff969696)));
    test('checkboxCheck', () => expect(c.checkboxCheck, Colors.white));
    test('checkboxLabel', () => expect(c.checkboxLabel, const Color(0xff646464)));
    test('destructiveText', () => expect(c.destructiveText, const Color(0xffd04444)));
    test('confirmButtonFill', () => expect(c.confirmButtonFill, Colors.white));
    test('confirmButtonLabel', () => expect(c.confirmButtonLabel, Colors.black54));
    test('warningText', () => expect(c.warningText, const Color(0xff5d5d5d)));
    test('tooltipBackground', () => expect(c.tooltipBackground, const Color(0xffeeeeee)));
    test('tooltipText', () => expect(c.tooltipText, Colors.black54));
    test('resultSurface', () => expect(c.resultSurface, Colors.white));
    test('resultPanel', () => expect(c.resultPanel, Colors.lightGreen.withValues(alpha: 0.4)));
    test('resultBadge', () => expect(c.resultBadge, const Color(0xff6aab64)));
    test('resultBadgeLabel', () => expect(c.resultBadgeLabel, Colors.white));
    test('resultScoreText', () => expect(c.resultScoreText, Colors.black87));
    test('resultFooterPanel', () => expect(c.resultFooterPanel, Colors.grey[300]!));
    test('mutedLabel', () => expect(c.mutedLabel, Colors.grey[700]!));
    test('retryButtonFill', () => expect(c.retryButtonFill, Colors.yellow[200]!));
    test('splashBackground', () => expect(c.splashBackground, const Color(0xfffceec5)));
    test('splashText', () => expect(c.splashText, const Color(0xff373f2c)));
  });

  test('오답 바텀시트 배경은 정답 쪽과 확실히 구별된다', () {
    // 계획서 초판의 매핑표대로 옮겼다면 둘 다 0xffacd0a8 초록이 됐다.
    expect(AppColors.light.wrongSheetBackground,
        const Color(0xffd7b1b1));
    expect(AppColors.light.wrongSheetBackground,
        isNot(AppColors.light.correctSheetBackground));
    expect(AppColors.dark.wrongSheetBackground,
        isNot(AppColors.dark.correctSheetBackground));
  });

  test('다크는 라이트와 실제로 다른 팔레트다', () {
    // 브랜드 스플래시와 CLEAR 배지 글자만 의도적으로 같다.
    final same = <String>[
      if (AppColors.light.pageBackground == AppColors.dark.pageBackground)
        'pageBackground',
      if (AppColors.light.tileSurface == AppColors.dark.tileSurface)
        'tileSurface',
      if (AppColors.light.dialogSurface == AppColors.dark.dialogSurface)
        'dialogSurface',
      if (AppColors.light.correctSheetBackground ==
          AppColors.dark.correctSheetBackground)
        'correctSheetBackground',
      if (AppColors.light.promptText == AppColors.dark.promptText)
        'promptText',
    ];
    expect(same, isEmpty);
  });

  test('악보 면은 다크에서도 밝다 — 검은 잉크 PNG 를 위해 의도한 것', () {
    // 라이트에서는 투명(= 종전과 동일).
    expect(AppColors.light.staffSurface, Colors.transparent);
    // 다크에서는 종이. 밝기를 실제로 재서 회귀를 막는다.
    expect(AppColors.dark.staffSurface.computeLuminance(),
        greaterThan(0.7));
  });

  test('다크 팔레트의 어느 필드도 비어 있지 않다 (lerp 안전)', () {
    final lerped = AppColors.light.lerp(AppColors.dark, 0.5);
    expect(lerped, isA<AppColors>());
    expect(AppColors.light.copyWith(), isA<AppColors>());
  });

  testWidgets('라이트 ThemeData 에서 AppColors 를 꺼낼 수 있다',
      (tester) async {
    late AppColors resolved;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(builder: (context) {
          resolved = context.colors;
          return const SizedBox.shrink();
        }),
      ),
    );
    expect(resolved.correctText, const Color(0xff4b7947));
  });

  testWidgets('다크 ThemeData 에서는 다크 팔레트가 나온다', (tester) async {
    late AppColors resolved;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: Builder(builder: (context) {
          resolved = context.colors;
          return const SizedBox.shrink();
        }),
      ),
    );
    expect(resolved.correctSheetBackground,
        AppColors.dark.correctSheetBackground);
    expect(Theme.of(tester.element(find.byType(SizedBox))).brightness,
        Brightness.dark);
  });

  test('라이트 ColorScheme 시드는 종전과 같은 흰색이다', () {
    // 시드를 바꾸면 Scaffold 배경·AppBar·기본 버튼색이 전부 미묘하게
    // 달라진다. 출시본과 픽셀 단위로 같아야 하므로 고정한다.
    expect(AppTheme.light.colorScheme,
        ColorScheme.fromSeed(seedColor: Colors.white));
    expect(AppTheme.light.useMaterial3, isTrue);
    expect(AppTheme.dark.brightness, Brightness.dark);
  });
}
