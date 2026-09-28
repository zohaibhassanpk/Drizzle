import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/config/responsive_config.dart';
import '../../../resources/app_assets.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_strings.dart';
import '../../../utils/routes/routes_name.dart';

/// Explains why the city request failed and allows the user to retry it.
class SearchErrorScreen extends StatelessWidget {
  const SearchErrorScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveConfig.width(46)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: ResponsiveConfig.width(112),
                  height: ResponsiveConfig.width(112),
                  padding: EdgeInsets.all(ResponsiveConfig.width(28)),
                  decoration: const BoxDecoration(
                    color: AppColors.lightTint,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(AppAssets.cloudQuestion),
                ),
                SizedBox(height: ResponsiveConfig.height(28)),
                Text(
                  AppStrings.cityNotFoundTitle,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveConfig.scale(20),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: ResponsiveConfig.height(8)),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveConfig.scale(14),
                    height: 1.45,
                  ),
                ),
                SizedBox(height: ResponsiveConfig.height(28)),
                SizedBox(
                  width: double.infinity,
                  height: ResponsiveConfig.height(56),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      RouteNames.search,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveConfig.radius(16),
                        ),
                      ),
                    ),
                    child: Text(
                      AppStrings.tryAgain,
                      style: TextStyle(
                        fontSize: ResponsiveConfig.scale(16),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
