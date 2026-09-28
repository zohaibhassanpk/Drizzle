import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/responsive_config.dart';
import '../../../../resources/app_assets.dart';

/// The sun, cloud, rain, and horizon mark in the centre of the splash screen.
class SplashWeatherLogo extends StatelessWidget {
  const SplashWeatherLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveConfig.width(300),
      height: ResponsiveConfig.height(300),
      child: SvgPicture.asset(
      //    width: ResponsiveConfig.width(300),
      // height: ResponsiveConfig.width(300),

        AppAssets.splashLogo,
        fit: BoxFit.contain,
      ),
    );
  }
}
