import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 광고 콘텐츠 정책 설정.
///
/// ## 왜 필요한가
///
/// 2026-08-08 Play 심사에서 **Families Policy Requirements: Ad Content** 로
/// 배포가 거부됐다. 사유는 "도박·경품 등 어린이에게 부적합한 광고가 나가고
/// 있으며, 앱의 콘텐츠 등급과 일치하지 않는다" 였다.
///
/// 원인은 단순하다 — 그때까지 앱은 `MobileAds.instance.initialize()` 만 호출하고
/// **광고 콘텐츠 등급을 전혀 제한하지 않았다.** `AdRequest()` 도 비어 있었다.
/// 그래서 AdMob 이 어떤 카테고리든 내보낼 수 있었다.
///
/// ## 무엇을 설정하는가
///
/// - `maxAdContentRating: G` — 전체 관람가 광고만 허용한다. 도박·경품·주류 등
///   민감 카테고리가 여기서 걸러진다. 거부 사유에 직접 대응하는 설정이다.
/// - `tagForChildDirectedTreatment: yes` — COPPA 상 **아동 대상 앱**으로 선언한다.
///   거부 메일이 *Families Policy* 를 인용했다는 것은 Play 가 이 앱을 어린이가
///   포함된 대상 연령으로 분류하고 있다는 뜻이므로, 그에 맞춘다.
///
/// `tagForUnderAgeOfConsent` 는 **설정하지 않는다.** Google 문서가 두 태그를
/// 동시에 true 로 두지 말라고 명시한다 — 서로 다른 규제(COPPA / GDPR)를 겨냥한
/// 플래그라 함께 켜면 동작이 정의되지 않는다.
///
/// ## 수익에 미치는 영향 — 알고 있어야 한다
///
/// 두 설정 모두 광고 인벤토리를 줄이고 맞춤 광고를 제한하므로 **eCPM 이
/// 떨어진다.** 이는 의도된 대가다. 심사를 통과하지 못하면 수익이 0 이다.
///
/// ## 코드만으로는 부족할 수 있다
///
/// 심사팀이 보는 것은 실제로 노출된 광고다. 아래 두 가지가 **AdMob 콘솔에서
/// 함께** 되어 있어야 확실하다. 코드로는 할 수 없다:
///
/// 1. AdMob → 차단 관리 → 민감한 카테고리에서 도박·경품 등을 차단
/// 2. 각 광고 단위의 콘텐츠 등급 설정 확인
///
/// ## 대상 연령을 13세 이상으로 바꾼다면
///
/// Play 콘솔의 대상 사용자층이 실제로는 어린이를 포함하지 않는다면,
/// 그 신고를 13세 이상으로 정정한 뒤 `tagForChildDirectedTreatment` 만
/// 빼는 편이 수익에 낫다. `maxAdContentRating: G` 는 그 경우에도 유지한다.
class AdContentPolicy {
  AdContentPolicy._();

  /// 광고 요청 정책을 적용한다.
  ///
  /// `MobileAds.instance.initialize()` **전에** 불러도 되고 후에 불러도 된다 —
  /// 설정은 SDK 에 저장되어 이후 모든 요청에 적용된다. main() 에서 초기화보다
  /// 먼저 부르는 이유는, 초기화 직후 곧바로 나가는 첫 요청까지 확실히
  /// 덮기 위해서다.
  static Future<void> apply() {
    return MobileAds.instance.updateRequestConfiguration(configuration);
  }

  /// 적용되는 설정. 테스트가 값을 직접 확인할 수 있도록 분리해 둔다.
  static RequestConfiguration get configuration => RequestConfiguration(
        maxAdContentRating: MaxAdContentRating.g,
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      );
}
