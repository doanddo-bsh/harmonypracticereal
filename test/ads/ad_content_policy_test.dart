import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:harmonypracticereal/core/ads/ad_content_policy.dart';

/// 2026-08-08 Play 심사가 **Families Policy Requirements: Ad Content** 로
/// 배포를 거부했다. 도박·경품 광고가 나가고 있었고, 앱은 광고 콘텐츠 등급을
/// 전혀 제한하지 않고 있었다.
///
/// 이 테스트는 그 대응 설정이 사라지거나 약해지는 것을 막는다.
/// 값 하나하나가 심사 결과에 직결되므로 느슨하게 검사하지 않는다.
void main() {
  group('광고 콘텐츠 정책', () {
    test('전체 관람가(G) 광고만 허용한다', () {
      // 거부 사유(도박·경품)에 직접 대응하는 설정.
      // 'PG'/'T'/'MA' 로 완화하면 다시 거부될 수 있다.
      expect(AdContentPolicy.configuration.maxAdContentRating,
          MaxAdContentRating.g);
    });

    test('아동 대상 앱으로 태그한다', () {
      // 거부 메일이 Families Policy 를 인용했다는 것은 Play 가 이 앱을
      // 어린이가 포함된 대상 연령으로 분류하고 있다는 뜻이다.
      expect(AdContentPolicy.configuration.tagForChildDirectedTreatment,
          TagForChildDirectedTreatment.yes);
    });

    test('동의연령 태그는 설정하지 않는다', () {
      // Google 문서가 tagForChildDirectedTreatment 와 동시에 true 로 두지
      // 말라고 명시한다. 서로 다른 규제(COPPA / GDPR)를 겨냥한 플래그라
      // 함께 켜면 동작이 정의되지 않는다.
      expect(AdContentPolicy.configuration.tagForUnderAgeOfConsent, isNull);
    });

    test('테스트 기기 목록을 코드에 박아두지 않는다', () {
      // 과거 UMP 설정에서 테스트 기기 ID 가 출시본에 남아 실제 사용자에게
      // 매 실행 동의창이 뜨던 사고가 있었다(Phase 1 Task 2). 같은 실수를
      // 광고 설정에서 반복하지 않는다.
      expect(AdContentPolicy.configuration.testDeviceIds, isNull);
    });
  });
}
