import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/config/responsive_config.dart';
import '../../../data/response/response_status.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_strings.dart';
import '../../../utils/routes/routes_name.dart';
import '../model/search_model.dart';
import '../model_view/search_viewmodel.dart';

/// Shows progress while the app verifies the chosen city with the weather API.
class SearchLoadingScreen extends StatefulWidget {
  const SearchLoadingScreen({super.key, required this.request});

  final SearchRequest request;

  @override
  State<SearchLoadingScreen> createState() => _SearchLoadingScreenState();
}

class _SearchLoadingScreenState extends State<SearchLoadingScreen> {
  bool _requestStarted = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() => _requestStarted = true);
      context.read<SearchViewModel>().searchCity(
        widget.request.city,
        widget.request.countryCode,
      );
    });
  }

  void _handleResponse(SearchViewModel viewModel) {
    if (!_requestStarted || _hasNavigated) return;

    final response = viewModel.cityResponse;
    if (response.status == ResponseStatus.loading) return;

    _hasNavigated = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (response.status == ResponseStatus.completed &&
          response.data != null &&
          response.data!.isNotEmpty) {
        Navigator.pushReplacementNamed(
          context,
          RouteNames.currentWeather,
          arguments: WeatherRequest(
            location: response.data!.first,
            countryName: widget.request.countryName,
          ),
        );
        return;
      }

      Navigator.pushReplacementNamed(
        context,
        RouteNames.searchError,
        arguments: response.message ?? AppStrings.cityNotFoundMessage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<SearchViewModel>(
          builder: (context, viewModel, _) {
            _handleResponse(viewModel);

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: ResponsiveConfig.width(54),
                    height: ResponsiveConfig.width(54),
                    child: const CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                      strokeWidth: 4,
                    ),
                  ),
                  SizedBox(height: ResponsiveConfig.height(30)),
                  Text(
                    AppStrings.gettingWeather,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveConfig.scale(20),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: ResponsiveConfig.height(8)),
                  Text(
                    AppStrings.pleaseWait,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveConfig.scale(14),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
