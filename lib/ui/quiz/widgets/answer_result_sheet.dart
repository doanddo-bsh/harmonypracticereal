import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:harmonypracticereal/core/theme/app_colors.dart';

/// 보기를 고른 뒤 올라오는 정답/오답 바텀시트의 **껍데기**.
///
/// 문제 화면 4종이 각자 복제해 갖고 있던 `showBottomResult` 안의
/// `showModalBottomSheet` 여덟 벌(유형 × 정답/오답)에서 **그리는 부분만** 뽑았다.
/// 점수 증가·오답 적립·다음 문제 전환은 여기 없다 — 그건 각 화면에 그대로 있다.
///
/// 네 화면이 실제로 다른 것은 세 가지뿐이라, 받는 것도 그 셋(과 색을 가르는
/// 정답 여부)뿐이다.
///
/// * [headline] — 유형 1 만 오답 문구가 `오답입니다!`(느낌표) 이고 나머지 셋은
///   `오답입니다` 다. 시트가 문구를 정해 버리면 그 차이가 조용히 사라지므로
///   **문구는 받는다.**
/// * [answer] — 정답을 무엇으로 보여 주는가가 유형마다 다르다. 유형 1 은
///   오선 화성 표기(`showHarmonyFromListShowOnly`)를, 나머지는 문자열을 쓴다.
///   글자색도 호출부가 이미 알고 있으므로 위젯째 받는다.
/// * [action] — `다음문제` / `결과보기` 버튼. 어느 쪽을 놓을지는 화면의 진행
///   상태가 정하므로 판단을 여기로 끌고 오지 않는다.
///
/// 높이 185.h, 여백 25/3/7.h, 글자 20 굵게는 종전 값 그대로다.
/// `test/ui/answer_result_sheet_test.dart` 가 고정한다.
class AnswerResultSheet extends StatelessWidget {
  const AnswerResultSheet({
    super.key,
    required this.isCorrect,
    required this.headline,
    required this.answer,
    required this.action,
  });

  /// 맞혔는가. 문구와 배경의 색을 가른다.
  final bool isCorrect;

  /// 첫 줄에 크게 적을 문구.
  final String headline;

  /// 정답을 보여 주는 위젯.
  final Widget answer;

  /// 맨 아래 버튼.
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final headlineColor =
        isCorrect ? context.colors.correctText : context.colors.wrongText;

    return SizedBox(
      height: 185.h,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 25.h,
          ),
          Text(
            headline,
            style: TextStyle(
                color: headlineColor,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          SizedBox(
            height: 3.h,
          ),
          answer,
          SizedBox(
            height: 7.h,
          ),
          action,
        ],
      ),
    );
  }
}

/// [AnswerResultSheet] 를 종전과 같은 방식으로 띄운다.
///
/// 모달의 배경색·모서리·드래그 금지·바깥 탭 금지는 네 화면이 여덟 벌 모두
/// 똑같이 쓰던 값이다.
Future<void> showAnswerResultSheet({
  required BuildContext context,
  required bool isCorrect,
  required String headline,
  required Widget answer,
  required Widget action,
}) {
  return showModalBottomSheet<void>(
    backgroundColor: isCorrect
        ? context.colors.correctSheetBackground
        : context.colors.wrongSheetBackground,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
    enableDrag: false,
    isDismissible: false,
    context: context,
    builder: (BuildContext context) => AnswerResultSheet(
      isCorrect: isCorrect,
      headline: headline,
      answer: answer,
      action: action,
    ),
  );
}
