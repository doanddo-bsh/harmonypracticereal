/// 전면 광고를 띄우기 전에 요구하는 누적 풀이 수.
///
/// 광고 단위 ID 는 여기가 아니라 `ad_ids.dart` 의 `AdIds.interstitial` 에 있고,
/// 적재·표시·해제는 `interstitial_ad_slot.dart` 의 `InterstitialAdSlot` 이
/// 쥔다. 이 파일은 "언제 띄울지"만 들고 있고, "무엇을 어떻게 띄울지"는 들고
/// 있지 않다 — 그래서 `google_mobile_ads` 를 import 하지 않고, 순수 단위
/// 테스트로 경계값을 지킬 수 있다.
int criticalNumberSolved = 20;

/// 지금 전면 광고를 띄울 때인가.
///
/// [solvedProblemCount] 는 **앱 전체 누적 풀이 수**(`CounterClass
/// .solvedProblemCount`)다. 한 판 안의 `numberOfRight` 가 아니다 — 한 판은
/// 10문제뿐이라 그걸로 재면 광고는 영원히 뜨지 않고, 반대로 기준을 낮추면
/// 매 문제마다 뜬다. 어느 쪽으로 틀려도 앱이 죽지 않아 알아채기 어렵다.
///
/// 위젯 테스트는 한 화면에서 10문제까지만 풀고 `AdIds.adsAvailable` 이
/// false 라 광고 적재 코드에 닿지도 않는다. 그래서 이 경계는
/// `test/quiz/quiz_flow_test.dart` 의 단위 테스트로만 지켜진다.
bool shouldShowInterstitial(int solvedProblemCount) =>
    solvedProblemCount >= criticalNumberSolved;
