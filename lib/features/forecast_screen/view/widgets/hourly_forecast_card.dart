import 'package:flutter/material.dart';

import '../../../../core/config/responsive_config.dart';
import '../../../../resources/app_colors.dart';
import 'forecast_weather_icon.dart';

class HourlyForecastCard extends StatelessWidget {
  const HourlyForecastCard({
    super.key,
    required this.time,
    required this.temperature,
    required this.rainChance,
    required this.weatherId,
    required this.iconCode,
    required this.isNow,
  });

  final String time;
  final int temperature;
  final int rainChance;
  final int? weatherId;
  final String? iconCode;
  final bool isNow;

  @override
  Widget build(BuildContext context) {
    final textColor = isNow ? Colors.white : AppColors.textPrimary;
    final secondaryColor = isNow ? Colors.white : AppColors.textSecondary;

    return Container(
      width: ResponsiveConfig.width(64),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveConfig.width(6),
        vertical: ResponsiveConfig.height(8),
      ),
      decoration: BoxDecoration(
        color: isNow ? null : AppColors.card,
        gradient: isNow
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryBlue, AppColors.skyBlue],
              )
            : null,
        borderRadius: BorderRadius.circular(ResponsiveConfig.radius(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.06),
            blurRadius: ResponsiveConfig.radius(12),
            offset: Offset(0, ResponsiveConfig.height(4)),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            maxLines: 1,
            style: TextStyle(
              color: secondaryColor,
              fontSize: ResponsiveConfig.scale(11),
            ),
          ),
          ForecastWeatherIcon(
            weatherId: weatherId,
            iconCode: iconCode,
            size: ResponsiveConfig.width(29),
          ),
          Text(
            '$temperature°',
            style: TextStyle(
              color: textColor,
              fontSize: ResponsiveConfig.scale(16),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: ResponsiveConfig.height(14),
            child: rainChance > 0
                ? Text(
                    '$rainChance%',
                    style: TextStyle(
                      color: isNow ? Colors.white : AppColors.primaryBlue,
                      fontSize: ResponsiveConfig.scale(10),
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
