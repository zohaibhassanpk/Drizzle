import 'package:flutter/material.dart';

import '../../../../core/config/responsive_config.dart';
import '../../../../resources/app_colors.dart';
import 'forecast_weather_icon.dart';

class DailyForecastData {
  const DailyForecastData({
    required this.day,
    required this.minimum,
    required this.maximum,
    required this.rainChance,
    required this.weatherId,
    required this.iconCode,
  });

  final String day;
  final int minimum;
  final int maximum;
  final int rainChance;
  final int? weatherId;
  final String? iconCode;
}

class DailyForecastList extends StatelessWidget {
  const DailyForecastList({super.key, required this.days});

  final List<DailyForecastData> days;

  @override
  Widget build(BuildContext context) {
    final lowest = days.map((day) => day.minimum).reduce((a, b) => a < b ? a : b);
    final highest = days.map((day) => day.maximum).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveConfig.width(14)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveConfig.radius(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.06),
            blurRadius: ResponsiveConfig.radius(14),
            offset: Offset(0, ResponsiveConfig.height(5)),
          ),
        ],
      ),
      child: Column(
        children: List.generate(days.length, (index) {
          final day = days[index];
          return Column(
            children: [
              _DailyRow(day: day, lowest: lowest, highest: highest),
              if (index != days.length - 1)
                const Divider(height: 1, color: AppColors.divider),
            ],
          );
        }),
      ),
    );
  }
}

class _DailyRow extends StatelessWidget {
  const _DailyRow({
    required this.day,
    required this.lowest,
    required this.highest,
  });

  final DailyForecastData day;
  final int lowest;
  final int highest;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveConfig.height(51),
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveConfig.width(48),
            child: Text(
              day.day,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: ResponsiveConfig.scale(13),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ForecastWeatherIcon(
            weatherId: day.weatherId,
            iconCode: day.iconCode,
            size: ResponsiveConfig.width(28),
          ),
          SizedBox(width: ResponsiveConfig.width(5)),
          SizedBox(
            width: ResponsiveConfig.width(43),
            child: Row(
              children: [
                Icon(
                  Icons.water_drop,
                  color: day.rainChance == 0
                      ? AppColors.disabledText
                      : AppColors.primaryBlue,
                  size: ResponsiveConfig.scale(12),
                ),
                Text(
                  '${day.rainChance}%',
                  style: TextStyle(
                    color: day.rainChance == 0
                        ? AppColors.disabledText
                        : AppColors.primaryBlue,
                    fontSize: ResponsiveConfig.scale(11),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: ResponsiveConfig.width(29),
            child: Text(
              '${day.minimum}°',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: ResponsiveConfig.scale(12),
              ),
            ),
          ),
          SizedBox(width: ResponsiveConfig.width(8)),
          Expanded(
            child: _TemperatureTrack(
              minimum: day.minimum,
              maximum: day.maximum,
              lowest: lowest,
              highest: highest,
            ),
          ),
          SizedBox(width: ResponsiveConfig.width(8)),
          SizedBox(
            width: ResponsiveConfig.width(29),
            child: Text(
              '${day.maximum}°',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: ResponsiveConfig.scale(13),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TemperatureTrack extends StatelessWidget {
  const _TemperatureTrack({
    required this.minimum,
    required this.maximum,
    required this.lowest,
    required this.highest,
  });

  final int minimum;
  final int maximum;
  final int lowest;
  final int highest;

  @override
  Widget build(BuildContext context) {
    final range = (highest - lowest).clamp(1, 100);
    final start = (minimum - lowest) / range;
    final width = (maximum - minimum).clamp(1, 100) / range;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: ResponsiveConfig.height(6),
          decoration: BoxDecoration(
            color: AppColors.temperatureTrack,
            borderRadius: BorderRadius.circular(ResponsiveConfig.radius(6)),
          ),
          child: Stack(
            children: [
              Positioned(
                left: constraints.maxWidth * start,
                width: constraints.maxWidth * width,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.skyBlue, AppColors.warmOrange],
                    ),
                    borderRadius: BorderRadius.circular(
                      ResponsiveConfig.radius(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
