import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/responsive_config.dart';
import '../../../../resources/app_assets.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/app_strings.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: ResponsiveConfig.width(56),
          height: ResponsiveConfig.width(56),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryBlue, AppColors.skyBlue],
            ),
            borderRadius: BorderRadius.circular(ResponsiveConfig.radius(18)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.28),
                blurRadius: ResponsiveConfig.radius(18),
                offset: Offset(0, ResponsiveConfig.height(8)),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            AppAssets.search,
            width: ResponsiveConfig.width(30),
            height: ResponsiveConfig.width(30),
          ),
        ),
        SizedBox(height: ResponsiveConfig.height(22)),
        Text(
          AppStrings.findWeather,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: ResponsiveConfig.scale(32),
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: ResponsiveConfig.height(6)),
        Text(
          AppStrings.selectCountryAndCity,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: ResponsiveConfig.scale(15),
          ),
        ),
      ],
    );
  }
}
