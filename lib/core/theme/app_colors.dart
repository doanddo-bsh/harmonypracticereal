import 'package:flutter/material.dart';

/// 앱 고유 의미색. Material 의 ColorScheme 으로는 표현되지 않는 것만 담는다.
///
/// 예전에는 `colorList.dart` 의 전역 `Color` 변수 17개였다. 그 중 3개
/// (`color3`/`color7`/`color9`)는 선언만 되고 **한 번도 읽히지 않는** 죽은
/// 상수여서 옮기지 않고 버렸다. 대신 화면 파일에 하드코딩돼 있던 색들을
/// 여기로 끌어왔다.
///
/// **라이트 값은 종전에 실제로 렌더링되던 값 그대로다.** 주석이 아니라
/// 호출부를 보고 옮겼다. 값을 바꾸면 출시 중인 앱의 외형이 달라진다.
/// `test/ui/theme_test.dart` 가 전 필드를 고정한다.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.easyAccent,
    required this.hardAccent,
    required this.nextButtonLabel,
    required this.progressSuperEasy,
    required this.progressEasy,
    required this.progressHard,
    required this.progressCustom,
    required this.progressTrack,
    required this.tabSuperEasy,
    required this.tabEasy,
    required this.tabHard,
    required this.tabCustom,
    required this.tabIndicator,
    required this.correctText,
    required this.correctSheetBackground,
    required this.wrongText,
    required this.wrongSheetBackground,
    required this.staffSurface,
    required this.promptText,
    required this.divider,
    required this.choiceFill,
    required this.choiceLabel,
    required this.pageBackground,
    required this.tileSurface,
    required this.tileBorder,
    required this.tileSeparator,
    required this.selectButtonFill,
    required this.selectButtonLabel,
    required this.dialogSurface,
    required this.dialogTitleText,
    required this.dialogBodyText,
    required this.dialogActionText,
    required this.selectorTitleText,
    required this.checkboxActive,
    required this.checkboxCheck,
    required this.checkboxLabel,
    required this.destructiveText,
    required this.confirmButtonFill,
    required this.confirmButtonLabel,
    required this.warningText,
    required this.tooltipBackground,
    required this.tooltipText,
    required this.resultSurface,
    required this.resultPanel,
    required this.resultBadge,
    required this.resultBadgeLabel,
    required this.resultScoreText,
    required this.resultFooterPanel,
    required this.mutedLabel,
    required this.retryButtonFill,
    required this.splashBackground,
    required this.splashText,
  });

  // ─── 난이도 강조색 · 진행바 · 탭

  /// '다음문제'/'결과보기' 버튼(정답 시) 배경·전경.
  /// note_glyphs.nextProblemButtonStyle 이 렌더링한다. 구 color1.
  final Color easyAccent;

  /// '다음문제'/'결과보기' 버튼(오답 시) 배경·전경. 구 color2.
  final Color hardAccent;

  /// 위 버튼의 글자색. note_glyphs.nextProblemButtonTextStyle.
  final Color nextButtonLabel;

  /// Easy 진행바 채움색. note_glyphs.lastRidingProgress. 구 color11.
  /// 다크 값이 라이트보다 어두운 것은 의도다 — 막대 가운데 '3/10'
  /// 글자가 테마 기본색(다크에서 밝은색)을 상속하기 때문이다.
  final Color progressSuperEasy;

  /// Medium 진행바 채움색. 구 color12.
  final Color progressEasy;

  /// Hard 진행바 채움색. 구 color13.
  final Color progressHard;

  /// Custom 진행바 채움색. 라이트에서는 tabCustom 과 같은 값이었지만
  /// (둘 다 구 color17) 역할이 달라 — 탭 '글자' 대 막대 '채움' —
  /// 다크에서 반대 방향으로 가야 해서 필드를 갈랐다.
  final Color progressCustom;

  /// 진행바의 빈 부분.
  final Color progressTrack;

  /// 홈 TabBar 'Easy' 글자색. 구 color14.
  final Color tabSuperEasy;

  /// 홈 TabBar 'Medium' 글자색. 구 color15.
  final Color tabEasy;

  /// 홈 TabBar 'Hard' 글자색. 구 color16.
  final Color tabHard;

  /// 홈 TabBar 'Custom' 글자색. 구 color17.
  final Color tabCustom;

  /// 홈 TabBar 밑줄.
  final Color tabIndicator;

  // ─── 정답 / 오답 바텀시트

  /// '정답입니다!' 글자색 및 그 아래 정답 화성 표기색. 구 color4.
  final Color correctText;

  /// 정답 바텀시트 배경(showModalBottomSheet backgroundColor).
  /// 구 color5.
  final Color correctSheetBackground;

  /// '오답입니다!' 글자색 및 정답 화성 표기색. 구 color6.
  final Color wrongText;

  /// 오답 바텀시트 배경.
  ///
  /// 구 color7 이 아니다. color7 은 초록(0xffacd0a8)이었고 **한 번도
  /// 쓰이지 않았다**. 실제로 렌더링되던 값은 problem_type1~4 에
  /// 하드코딩돼 있던 이 분홍이다.
  final Color wrongSheetBackground;

  // ─── 문제 화면

  /// 오선보가 그려지는 영역의 배경.
  ///
  /// 라이트에서는 투명이라 Scaffold 배경이 그대로 비친다(종전과 동일).
  /// 다크에서는 밝은 '종이' 면을 깐다 — 음표·임시표·음자리표가 전부
  /// 검은 잉크 PNG 이고 오선도 Colors.black 이라 어두운 면 위에서는
  /// 아무것도 보이지 않기 때문이다. 색 반전 필터는 쓸 수 없다:
  /// 온음표의 속 빈 머리가 채워진 머리로 바뀌어 다른 음가로 읽힌다.
  final Color staffSurface;

  /// '알맞은 화성을 구하시오', '조성 : ' 등 문제 지시문 글자색.
  /// 제시 화성 표기(answerButtonTextDesignBlack54)도 같은 색이었다.
  final Color promptText;

  /// 문제 화면 가로 구분선.
  final Color divider;

  /// 보기 버튼 배경·surfaceTint. note_glyphs.answerButtonDesign.
  /// 구 color10.
  final Color choiceFill;

  /// 보기 버튼 안 로마숫자/숫자 글자색.
  /// note_glyphs.answerButtonTextDesign.
  final Color choiceLabel;

  // ─── 홈 화면

  /// 홈 Scaffold 배경.
  final Color pageBackground;

  /// 문제 타일 배경.
  final Color tileSurface;

  /// 문제 타일 테두리 및 Custom 탭 '화성 선택' 버튼 테두리.
  /// 구 color8 과, 값이 같은 하드코딩 한 곳을 합쳤다.
  final Color tileBorder;

  /// 타일 안 '문제 | 화성의 이름' 세로 구분 막대.
  final Color tileSeparator;

  /// Custom 탭 '버튼을 눌러 원하는 화성을 선택해주세요!' 배경.
  final Color selectButtonFill;

  /// 위 버튼 글자색(ElevatedButton foregroundColor).
  final Color selectButtonLabel;

  // ─── 다이얼로그

  /// AlertDialog 배경.
  final Color dialogSurface;

  /// '선택해주세요' 제목 글자색.
  final Color dialogTitleText;

  /// '문제를 위해 화성을 한개 이상 선택해주세요' 본문 글자색.
  final Color dialogBodyText;

  /// 다이얼로그 '확인' TextButton 글자색.
  final Color dialogActionText;

  /// '화성 종류' 다이얼로그 제목 글자색.
  /// 죽은 상수 color9 가 같은 값이었지만 그 상수는 쓰이지 않았고,
  /// 이 값은 chord_type_selector 에 하드코딩돼 있던 쪽이다.
  final Color selectorTitleText;

  /// 화성 선택 체크박스 활성 채움색.
  final Color checkboxActive;

  /// 체크 표시 색.
  final Color checkboxCheck;

  /// 체크박스 항목 글자색.
  final Color checkboxLabel;

  /// '취소' 글자색.
  final Color destructiveText;

  /// '화성 종류' 다이얼로그 '확인' ElevatedButton 배경.
  final Color confirmButtonFill;

  /// 위 버튼 글자색.
  final Color confirmButtonLabel;

  /// '7화음을 포함해야 합니다' 경고 글자색.
  final Color warningText;

  // ─── 툴팁

  /// 난이도 설명 / 해설 툴팁 배경.
  final Color tooltipBackground;

  /// 툴팁 글자색.
  final Color tooltipText;

  // ─── 결과 화면

  /// 결과 시트 전체 배경.
  final Color resultSurface;

  /// 점수 패널 배경.
  final Color resultPanel;

  /// 'CLEAR' 배지 배경.
  final Color resultBadge;

  /// 'CLEAR' 글자색. 배지 위라 라이트/다크가 같다.
  final Color resultBadgeLabel;

  /// 오답 다시풀기 모드의 점수 글자색.
  final Color resultScoreText;

  /// '계속해서 문제를 푸시겠습니까?' 패널 배경.
  final Color resultFooterPanel;

  /// 결과 화면 설명글, '네'/'아니오', '틀린 문제 다시 풀기' 글자색.
  final Color mutedLabel;

  /// '틀린 문제 다시 풀기' 버튼 배경.
  final Color retryButtonFill;

  // ─── 스플래시 — 브랜드색이라 라이트/다크가 같다

  /// 로딩 화면 배경.
  final Color splashBackground;

  /// '화 성 박 사' 및 저작권 문구 글자색.
  final Color splashText;

  /// 종전 렌더링 값 그대로.
  ///
  /// `const` 가 아니라 `final` 인 이유: `Colors.black54`,
  /// `Colors.grey[700]!`, `withValues(alpha:)` 같은 비-const 표현을
  /// 근사한 16진 리터럴로 갈아끼우지 않고 원본 그대로 두기 위해서다.
  /// 그래야 '값이 같다'를 눈으로가 아니라 표현식으로 보장할 수 있다.
  static final AppColors light = AppColors(
    easyAccent: const Color(0xff63af5b),
    hardAccent: const Color(0xffe36d3f),
    nextButtonLabel: Colors.white54,
    progressSuperEasy: const Color(0xfff2c35b),
    progressEasy: const Color(0xff539706),
    progressHard: const Color(0xffae2c1f),
    progressCustom: const Color(0xff656565),
    progressTrack: Colors.black12,
    tabSuperEasy: const Color(0xfff8b306),
    tabEasy: const Color(0xff3f8a36),
    tabHard: const Color(0xffc94040),
    tabCustom: const Color(0xff656565),
    tabIndicator: Colors.black38,
    correctText: const Color(0xff4b7947),
    correctSheetBackground: const Color(0xffacd0a8),
    wrongText: const Color(0xff79474e),
    wrongSheetBackground: const Color(0xffd7b1b1),
    staffSurface: Colors.transparent,
    promptText: Colors.black54,
    divider: Colors.black12,
    choiceFill: const Color(0xFFF6F6F6),
    choiceLabel: Colors.black,
    pageBackground: Colors.white,
    tileSurface: Colors.white,
    tileBorder: const Color(0xffdedede),
    tileSeparator: Colors.grey,
    selectButtonFill: const Color(0xfff6f6f6),
    selectButtonLabel: Colors.black38,
    dialogSurface: Colors.white,
    dialogTitleText: const Color(0xff3a3a3a),
    dialogBodyText: const Color(0xff797979),
    dialogActionText: const Color(0xff2f2f2f),
    selectorTitleText: const Color(0xff424242),
    checkboxActive: const Color(0xff969696),
    checkboxCheck: Colors.white,
    checkboxLabel: const Color(0xff646464),
    destructiveText: const Color(0xffd04444),
    confirmButtonFill: Colors.white,
    confirmButtonLabel: Colors.black54,
    warningText: const Color(0xff5d5d5d),
    tooltipBackground: const Color(0xffeeeeee),
    tooltipText: Colors.black54,
    resultSurface: Colors.white,
    resultPanel: Colors.lightGreen.withValues(alpha: 0.4),
    resultBadge: const Color(0xff6aab64),
    resultBadgeLabel: Colors.white,
    resultScoreText: Colors.black87,
    resultFooterPanel: Colors.grey[300]!,
    mutedLabel: Colors.grey[700]!,
    retryButtonFill: Colors.yellow[200]!,
    splashBackground: const Color(0xfffceec5),
    splashText: const Color(0xff373f2c),
  );

  /// 어두운 배경에서 읽히도록 다시 고른 값. 단순 반전이 아니다.
  static final AppColors dark = AppColors(
    easyAccent: const Color(0xff4e8f48),
    hardAccent: const Color(0xffb75531),
    nextButtonLabel: Colors.white70,
    progressSuperEasy: const Color(0xff7a5f14),
    progressEasy: const Color(0xff2f5a04),
    progressHard: const Color(0xff6e1c13),
    progressCustom: const Color(0xff4a4a4a),
    progressTrack: Colors.white24,
    tabSuperEasy: const Color(0xffffc94d),
    tabEasy: const Color(0xff7fc36f),
    tabHard: const Color(0xffe98080),
    tabCustom: const Color(0xffb0b0b0),
    tabIndicator: Colors.white54,
    correctText: const Color(0xffa9d6a3),
    correctSheetBackground: const Color(0xff23361f),
    wrongText: const Color(0xffe8adb4),
    wrongSheetBackground: const Color(0xff3b2326),
    staffSurface: const Color(0xfff5f2ec),
    promptText: const Color(0xffc9c9c9),
    divider: const Color(0xff3a3a3a),
    choiceFill: const Color(0xff2c2c2c),
    choiceLabel: const Color(0xffececec),
    pageBackground: const Color(0xff121212),
    tileSurface: const Color(0xff1d1d1d),
    tileBorder: const Color(0xff3a3a3a),
    tileSeparator: const Color(0xff707070),
    selectButtonFill: const Color(0xff262626),
    selectButtonLabel: const Color(0xffa8a8a8),
    dialogSurface: const Color(0xff26262a),
    dialogTitleText: const Color(0xffe8e8e8),
    dialogBodyText: const Color(0xffb5b5b5),
    dialogActionText: const Color(0xffd8d8d8),
    selectorTitleText: const Color(0xffe8e8e8),
    checkboxActive: const Color(0xff9a9a9a),
    checkboxCheck: const Color(0xff17171a),
    checkboxLabel: const Color(0xffcdcdcd),
    destructiveText: const Color(0xffef8f8f),
    confirmButtonFill: const Color(0xff3a3a40),
    confirmButtonLabel: const Color(0xffe0e0e0),
    warningText: const Color(0xffd0d0d0),
    tooltipBackground: const Color(0xff3c3c3c),
    tooltipText: const Color(0xffe4e4e4),
    resultSurface: const Color(0xff141414),
    resultPanel: const Color(0xff1e3318),
    resultBadge: const Color(0xff4a8544),
    resultBadgeLabel: Colors.white,
    resultScoreText: const Color(0xffefefef),
    resultFooterPanel: const Color(0xff262626),
    mutedLabel: const Color(0xffc8c8c8),
    retryButtonFill: const Color(0xff6a5a1c),
    splashBackground: const Color(0xfffceec5),
    splashText: const Color(0xff373f2c),
  );

  @override
  AppColors copyWith({
    Color? easyAccent,
    Color? hardAccent,
    Color? nextButtonLabel,
    Color? progressSuperEasy,
    Color? progressEasy,
    Color? progressHard,
    Color? progressCustom,
    Color? progressTrack,
    Color? tabSuperEasy,
    Color? tabEasy,
    Color? tabHard,
    Color? tabCustom,
    Color? tabIndicator,
    Color? correctText,
    Color? correctSheetBackground,
    Color? wrongText,
    Color? wrongSheetBackground,
    Color? staffSurface,
    Color? promptText,
    Color? divider,
    Color? choiceFill,
    Color? choiceLabel,
    Color? pageBackground,
    Color? tileSurface,
    Color? tileBorder,
    Color? tileSeparator,
    Color? selectButtonFill,
    Color? selectButtonLabel,
    Color? dialogSurface,
    Color? dialogTitleText,
    Color? dialogBodyText,
    Color? dialogActionText,
    Color? selectorTitleText,
    Color? checkboxActive,
    Color? checkboxCheck,
    Color? checkboxLabel,
    Color? destructiveText,
    Color? confirmButtonFill,
    Color? confirmButtonLabel,
    Color? warningText,
    Color? tooltipBackground,
    Color? tooltipText,
    Color? resultSurface,
    Color? resultPanel,
    Color? resultBadge,
    Color? resultBadgeLabel,
    Color? resultScoreText,
    Color? resultFooterPanel,
    Color? mutedLabel,
    Color? retryButtonFill,
    Color? splashBackground,
    Color? splashText,
  }) {
    return AppColors(
      easyAccent: easyAccent ?? this.easyAccent,
      hardAccent: hardAccent ?? this.hardAccent,
      nextButtonLabel: nextButtonLabel ?? this.nextButtonLabel,
      progressSuperEasy: progressSuperEasy ?? this.progressSuperEasy,
      progressEasy: progressEasy ?? this.progressEasy,
      progressHard: progressHard ?? this.progressHard,
      progressCustom: progressCustom ?? this.progressCustom,
      progressTrack: progressTrack ?? this.progressTrack,
      tabSuperEasy: tabSuperEasy ?? this.tabSuperEasy,
      tabEasy: tabEasy ?? this.tabEasy,
      tabHard: tabHard ?? this.tabHard,
      tabCustom: tabCustom ?? this.tabCustom,
      tabIndicator: tabIndicator ?? this.tabIndicator,
      correctText: correctText ?? this.correctText,
      correctSheetBackground: correctSheetBackground ?? this.correctSheetBackground,
      wrongText: wrongText ?? this.wrongText,
      wrongSheetBackground: wrongSheetBackground ?? this.wrongSheetBackground,
      staffSurface: staffSurface ?? this.staffSurface,
      promptText: promptText ?? this.promptText,
      divider: divider ?? this.divider,
      choiceFill: choiceFill ?? this.choiceFill,
      choiceLabel: choiceLabel ?? this.choiceLabel,
      pageBackground: pageBackground ?? this.pageBackground,
      tileSurface: tileSurface ?? this.tileSurface,
      tileBorder: tileBorder ?? this.tileBorder,
      tileSeparator: tileSeparator ?? this.tileSeparator,
      selectButtonFill: selectButtonFill ?? this.selectButtonFill,
      selectButtonLabel: selectButtonLabel ?? this.selectButtonLabel,
      dialogSurface: dialogSurface ?? this.dialogSurface,
      dialogTitleText: dialogTitleText ?? this.dialogTitleText,
      dialogBodyText: dialogBodyText ?? this.dialogBodyText,
      dialogActionText: dialogActionText ?? this.dialogActionText,
      selectorTitleText: selectorTitleText ?? this.selectorTitleText,
      checkboxActive: checkboxActive ?? this.checkboxActive,
      checkboxCheck: checkboxCheck ?? this.checkboxCheck,
      checkboxLabel: checkboxLabel ?? this.checkboxLabel,
      destructiveText: destructiveText ?? this.destructiveText,
      confirmButtonFill: confirmButtonFill ?? this.confirmButtonFill,
      confirmButtonLabel: confirmButtonLabel ?? this.confirmButtonLabel,
      warningText: warningText ?? this.warningText,
      tooltipBackground: tooltipBackground ?? this.tooltipBackground,
      tooltipText: tooltipText ?? this.tooltipText,
      resultSurface: resultSurface ?? this.resultSurface,
      resultPanel: resultPanel ?? this.resultPanel,
      resultBadge: resultBadge ?? this.resultBadge,
      resultBadgeLabel: resultBadgeLabel ?? this.resultBadgeLabel,
      resultScoreText: resultScoreText ?? this.resultScoreText,
      resultFooterPanel: resultFooterPanel ?? this.resultFooterPanel,
      mutedLabel: mutedLabel ?? this.mutedLabel,
      retryButtonFill: retryButtonFill ?? this.retryButtonFill,
      splashBackground: splashBackground ?? this.splashBackground,
      splashText: splashText ?? this.splashText,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      easyAccent: Color.lerp(easyAccent, other.easyAccent, t)!,
      hardAccent: Color.lerp(hardAccent, other.hardAccent, t)!,
      nextButtonLabel: Color.lerp(nextButtonLabel, other.nextButtonLabel, t)!,
      progressSuperEasy: Color.lerp(progressSuperEasy, other.progressSuperEasy, t)!,
      progressEasy: Color.lerp(progressEasy, other.progressEasy, t)!,
      progressHard: Color.lerp(progressHard, other.progressHard, t)!,
      progressCustom: Color.lerp(progressCustom, other.progressCustom, t)!,
      progressTrack: Color.lerp(progressTrack, other.progressTrack, t)!,
      tabSuperEasy: Color.lerp(tabSuperEasy, other.tabSuperEasy, t)!,
      tabEasy: Color.lerp(tabEasy, other.tabEasy, t)!,
      tabHard: Color.lerp(tabHard, other.tabHard, t)!,
      tabCustom: Color.lerp(tabCustom, other.tabCustom, t)!,
      tabIndicator: Color.lerp(tabIndicator, other.tabIndicator, t)!,
      correctText: Color.lerp(correctText, other.correctText, t)!,
      correctSheetBackground: Color.lerp(correctSheetBackground, other.correctSheetBackground, t)!,
      wrongText: Color.lerp(wrongText, other.wrongText, t)!,
      wrongSheetBackground: Color.lerp(wrongSheetBackground, other.wrongSheetBackground, t)!,
      staffSurface: Color.lerp(staffSurface, other.staffSurface, t)!,
      promptText: Color.lerp(promptText, other.promptText, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      choiceFill: Color.lerp(choiceFill, other.choiceFill, t)!,
      choiceLabel: Color.lerp(choiceLabel, other.choiceLabel, t)!,
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      tileSurface: Color.lerp(tileSurface, other.tileSurface, t)!,
      tileBorder: Color.lerp(tileBorder, other.tileBorder, t)!,
      tileSeparator: Color.lerp(tileSeparator, other.tileSeparator, t)!,
      selectButtonFill: Color.lerp(selectButtonFill, other.selectButtonFill, t)!,
      selectButtonLabel: Color.lerp(selectButtonLabel, other.selectButtonLabel, t)!,
      dialogSurface: Color.lerp(dialogSurface, other.dialogSurface, t)!,
      dialogTitleText: Color.lerp(dialogTitleText, other.dialogTitleText, t)!,
      dialogBodyText: Color.lerp(dialogBodyText, other.dialogBodyText, t)!,
      dialogActionText: Color.lerp(dialogActionText, other.dialogActionText, t)!,
      selectorTitleText: Color.lerp(selectorTitleText, other.selectorTitleText, t)!,
      checkboxActive: Color.lerp(checkboxActive, other.checkboxActive, t)!,
      checkboxCheck: Color.lerp(checkboxCheck, other.checkboxCheck, t)!,
      checkboxLabel: Color.lerp(checkboxLabel, other.checkboxLabel, t)!,
      destructiveText: Color.lerp(destructiveText, other.destructiveText, t)!,
      confirmButtonFill: Color.lerp(confirmButtonFill, other.confirmButtonFill, t)!,
      confirmButtonLabel: Color.lerp(confirmButtonLabel, other.confirmButtonLabel, t)!,
      warningText: Color.lerp(warningText, other.warningText, t)!,
      tooltipBackground: Color.lerp(tooltipBackground, other.tooltipBackground, t)!,
      tooltipText: Color.lerp(tooltipText, other.tooltipText, t)!,
      resultSurface: Color.lerp(resultSurface, other.resultSurface, t)!,
      resultPanel: Color.lerp(resultPanel, other.resultPanel, t)!,
      resultBadge: Color.lerp(resultBadge, other.resultBadge, t)!,
      resultBadgeLabel: Color.lerp(resultBadgeLabel, other.resultBadgeLabel, t)!,
      resultScoreText: Color.lerp(resultScoreText, other.resultScoreText, t)!,
      resultFooterPanel: Color.lerp(resultFooterPanel, other.resultFooterPanel, t)!,
      mutedLabel: Color.lerp(mutedLabel, other.mutedLabel, t)!,
      retryButtonFill: Color.lerp(retryButtonFill, other.retryButtonFill, t)!,
      splashBackground: Color.lerp(splashBackground, other.splashBackground, t)!,
      splashText: Color.lerp(splashText, other.splashText, t)!,
    );
  }
}

/// `Theme.of(context).extension<AppColors>()!` 를 짧게 쓰기 위한 확장.
extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
