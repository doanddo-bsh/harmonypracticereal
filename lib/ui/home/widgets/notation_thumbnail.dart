import 'package:flutter/material.dart';
import 'package:harmonypracticereal/core/theme/app_colors.dart';

/// 홈 화면 문제 타일의 악보 썸네일.
///
/// 썸네일 원본은 **투명 배경이 아닌 `.jpeg`** 이라 자체 흰 배경을 갖고 있다.
/// 라이트 모드에서는 카드도 흰색이라 묻혀서 보이지 않았지만, 다크모드에서는
/// 어두운 카드 위에 흰 사각형이 그대로 드러난다.
///
/// 에셋을 투명 PNG 로 다시 만드는 것이 근본 해결이지만, 그건 이미지 작업이
/// 필요하다. 대신 여기서는 곱셈 블렌드로 흰 배경만 악보 패널과 같은 크림색
/// (`staffSurface`) 으로 물들인다. 곱셈은 흰색(1.0)을 대상 색 그대로,
/// 검은색(0.0)을 검은색 그대로 남기므로 **음표와 오선의 잉크는 건드리지 않는다.**
/// 이 성질 때문에 `ColorFiltered` 반전과 달리 음표 모양이 바뀌지 않는다.
///
/// 라이트 모드에서는 `staffSurface` 가 투명이므로 필터를 적용하지 않는다 —
/// 즉 기존 화면과 픽셀 단위로 같다.
class NotationThumbnail extends StatelessWidget {
  const NotationThumbnail({
    required this.assetName,
    this.size,
    super.key,
  });

  /// `assets/` 아래 파일명. 예: `harmonySuperEasyCut1.jpeg`
  final String assetName;

  /// 정사각형 한 변. 지정하지 않으면 부모 크기를 채운다.
  final double? size;

  @override
  Widget build(BuildContext context) {
    final surface = context.colors.staffSurface;

    Widget image = Image(
      image: AssetImage('assets/$assetName'),
      fit: BoxFit.contain,
    );

    // staffSurface 가 투명이면(라이트 모드) 원본 그대로 둔다.
    if (surface.a > 0) {
      image = ColorFiltered(
        colorFilter: ColorFilter.mode(surface, BlendMode.multiply),
        child: image,
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: image,
      ),
    );
  }
}
