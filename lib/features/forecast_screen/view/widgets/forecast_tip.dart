import 'package:flutter/material.dart';

import '../../../../core/config/responsive_config.dart';
import '../../../../resources/app_colors.dart';
import 'forecast_weather_icon.dart';

class ForecastTip extends StatelessWidget {
  const ForecastTip({super.key, required this.message, required this.hasRain});

  final String message;
  final bool hasRain;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveConfig.width(14)),
      decoration: BoxDecoration(
        color: AppColors.lightTint,
        borderRadius: BorderRadius.circular(ResponsiveConfig.radius(16)),
      ),
      child: Row(
        children: [
          ForecastWeatherIcon(
            weatherId: hasRain ? 500 : 800,
            iconCode: '01d',
            size: ResponsiveConfig.width(34),
          ),
          SizedBox(width: ResponsiveConfig.width(12)),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.labelText,
                fontSize: ResponsiveConfig.scale(12),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
