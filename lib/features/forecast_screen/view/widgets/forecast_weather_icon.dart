import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../resources/app_assets.dart';

class ForecastWeatherIcon extends StatelessWidget {
  const ForecastWeatherIcon({
    super.key,
    required this.weatherId,
    required this.iconCode,
    this.size = 30,
  });

  final int? weatherId;
  final String? iconCode;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _asset,
      width: size,
      height: size,
    );
  }

  String get _asset {
    final id = weatherId ?? 800;

    if (id < 600) return AppAssets.rainLarge;
    if (id > 800) return AppAssets.cloud;
    if (iconCode?.endsWith('n') ?? false) return AppAssets.moon;
    return AppAssets.sun;
  }
}
