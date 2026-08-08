import 'dart:math';

final _random = Random();

/// 음계 도수 1~7 중 하나를 고른다.
///
/// 예전에는 major_problems.dart 와 minor_problems.dart 에 **글자 하나까지
/// 똑같은 본문**이 같은 이름으로 각각 정의돼 있었다. 두 파일을 함께
/// import 하는 borrowed_problems.dart / problem_catalog.dart 에서는
/// 이 이름이 모호해져, 그쪽에서 호출하는 순간 컴파일이 깨질 수 있었다.
int getOneToSeven() => _random.nextInt(7) + 1;

/// 음계 도수 1~6 중 하나를 고른다. 단조 전용 로직에서 쓴다.
///
/// (자연단음계의 7도 위에 3화음을 쌓으면 조성 밖으로 나가므로 단조 쪽
/// 생성기 대부분은 1~6 만 뽑는다.)
int getOneToSix() => _random.nextInt(6) + 1;
