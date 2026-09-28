import 'package:flutter/material.dart';

import '../../../core/config/responsive_config.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_strings.dart';
import '../../../utils/routes/routes_name.dart';
import 'widgets/splash_cloud.dart';
import 'widgets/splash_weather_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouteNames.search);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryBlue,
              AppColors.skyBlue,
              AppColors.lightSky,
            ],
            stops: [0, 0.58, 1],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: ResponsiveConfig.height(70),
              left: -ResponsiveConfig.width(28),
              child: SplashCloud(
                width: ResponsiveConfig.width(160),
                color: const Color(0xFFA9D2F8),
              ),
            ),
            Positioned(
              top: ResponsiveConfig.height(210),
              right: -ResponsiveConfig.width(42),
              child: SplashCloud(
                width: ResponsiveConfig.width(200),
                color: const Color(0xFFD5EAFB),
              ),
            ),
            Positioned(
              left: -ResponsiveConfig.width(54),
              bottom: ResponsiveConfig.height(80),
              child: SplashCloud(
                width: ResponsiveConfig.width(250),
                color: const Color(0xFFF7FCFF),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SplashWeatherLogo(),
                  SizedBox(height: ResponsiveConfig.height(14)),
                  Text(
                    AppStrings.appName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveConfig.scale(50),
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.8,
                    ),
                  ),
                  // SizedBox(height: ResponsiveConfig.height(0.09)),
                  Text(
                    AppStrings.splashSubtitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveConfig.scale(20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
