import 'package:flutter/material.dart';

import '../../../../core/config/responsive_config.dart';
import '../../../../resources/app_colors.dart';

class WeatherExtraDetails extends StatelessWidget {
  const WeatherExtraDetails({super.key, required this.details});

  final Map<String, String> details;

  @override
  Widget build(BuildContext context) {
    final entries = details.entries.toList();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveConfig.width(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveConfig.radius(16)),
      ),
      child: Column(
        children: List.generate(entries.length, (index) {
          final entry = entries[index];
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveConfig.height(13),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: ResponsiveConfig.scale(12),
                        ),
                      ),
                    ),
                    Text(
                      entry.value,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: ResponsiveConfig.scale(13),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (index != entries.length - 1)
                const Divider(height: 1, color: AppColors.divider),
            ],
          );
        }),
      ),
    );
  }
}
