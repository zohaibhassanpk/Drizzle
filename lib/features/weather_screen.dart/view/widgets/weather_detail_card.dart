import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/responsive_config.dart';
import '../../../../resources/app_colors.dart';

class WeatherDetailCard extends StatelessWidget {
  const WeatherDetailCard({
    super.key,
    required this.label,
    required this.value,
    this.asset,
  });

  final String label;
  final String value;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.width(10)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveConfig.radius(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: ResponsiveConfig.radius(12),
            offset: Offset(0, ResponsiveConfig.height(4)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (asset != null) ...[
            Container(
              width: ResponsiveConfig.width(32),
              height: ResponsiveConfig.width(32),
              padding: EdgeInsets.all(ResponsiveConfig.width(7)),
              decoration: BoxDecoration(
                color: AppColors.lightTint,
                borderRadius: BorderRadius.circular(
                  ResponsiveConfig.radius(10),
                ),
              ),
              child: SvgPicture.asset(asset!),
            ),
            SizedBox(height: ResponsiveConfig.height(8)),
          ],
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: ResponsiveConfig.scale(11),
            ),
          ),
          SizedBox(height: ResponsiveConfig.height(3)),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: ResponsiveConfig.scale(17),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
