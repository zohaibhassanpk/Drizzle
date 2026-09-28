import 'package:flutter/material.dart';

import '../core/config/responsive_config.dart';
import '../resources/app_strings.dart';
import '../utils/routes/routes.dart';
import '../utils/routes/routes_name.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.splash,
      routes: AppRoutes.routes,
      builder: (context, child) =>
          ResponsiveProvider(child: child ?? const SizedBox.shrink()),
    );
  }
}
