import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/responsive_config.dart';
import '../../../../resources/app_assets.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/app_strings.dart';
import '../../model/currentweathermodel.dart';

class CurrentWeatherHeader extends StatelessWidget {
  const CurrentWeatherHeader({
    super.key,
    required this.weather,
    required this.countryName,
    required this.onBack,
    required this.onRefresh,
  });

  final CurrentWeather weather;
  final String countryName;
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final main = weather.main;
    final condition = weather.weather?.firstOrNull;
    final temperature = '${main?.temp?.round() ?? 0}°C';
    final feelsLike = '${main?.feelsLike?.round() ?? 0}°C';
    final isNight = condition?.icon?.endsWith('n') ?? false;
    final country = countryName.trim().isNotEmpty
        ? countryName
        : weather.sys?.country ?? '';
    final location = [
      weather.name,
      country,
    ].whereType<String>().where((value) => value.isNotEmpty).join(', ');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        ResponsiveConfig.width(20),
        ResponsiveConfig.height(18),
        ResponsiveConfig.width(20),
        ResponsiveConfig.height(22),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryBlue, AppColors.skyBlue, AppColors.lightSky],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(ResponsiveConfig.radius(32)),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _HeaderButton(icon: Icons.chevron_left, onPressed: onBack),
              Expanded(
                child: Text(
                  location,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveConfig.scale(18),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _HeaderButton(icon: Icons.refresh_rounded, onPressed: onRefresh),
            ],
          ),
          SizedBox(height: ResponsiveConfig.height(12)),
          SizedBox(
            width: ResponsiveConfig.width(72),
            height: ResponsiveConfig.width(72),
            child: SvgPicture.asset(
              isNight ? AppAssets.weatherMoonLarge : AppAssets.sun,
            ),
          ),
          SizedBox(height: ResponsiveConfig.height(4)),
          Text(
            temperature,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveConfig.scale(68),
              fontWeight: FontWeight.w300,
              height: 1,
            ),
          ),
          SizedBox(height: ResponsiveConfig.height(8)),
          Text(
            condition?.main ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveConfig.scale(21),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            _capitalize(condition?.description ?? ''),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: ResponsiveConfig.scale(14),
            ),
          ),
          SizedBox(height: ResponsiveConfig.height(10)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveConfig.width(14),
              vertical: ResponsiveConfig.height(7),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(ResponsiveConfig.radius(18)),
            ),
            child: Text(
              AppStrings.feelsLike(feelsLike),
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveConfig.scale(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveConfig.width(36),
      height: ResponsiveConfig.width(36),
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.20),
        ),
        icon: Icon(
          icon,
          color: Colors.white,
          size: ResponsiveConfig.scale(20),
        ),
      ),
    );
  }
}
