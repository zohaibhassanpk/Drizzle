import 'package:flutter/material.dart';

import '../../../../core/config/responsive_config.dart';
import '../../../../resources/app_colors.dart';

class ForecastHeader extends StatelessWidget {
  const ForecastHeader({
    super.key,
    required this.location,
    required this.subtitle,
    required this.onBack,
    required this.onRefresh,
  });

  final String location;
  final String subtitle;
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        ResponsiveConfig.width(20),
        ResponsiveConfig.height(16),
        ResponsiveConfig.width(20),
        ResponsiveConfig.height(18),
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
              _HeaderButton(icon: Icons.chevron_left, onTap: onBack),
              Expanded(
                child: Text(
                  location,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveConfig.scale(19),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _HeaderButton(icon: Icons.refresh_rounded, onTap: onRefresh),
            ],
          ),
          SizedBox(height: ResponsiveConfig.height(14)),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: ResponsiveConfig.scale(13),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveConfig.width(38),
      height: ResponsiveConfig.width(38),
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.2),
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
