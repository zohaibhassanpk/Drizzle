import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/config/responsive_config.dart';
import '../../../data/response/response_status.dart';
import '../../../resources/app_assets.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_strings.dart';
import '../../../utils/routes/routes_name.dart';
import '../../search_screen/model/search_model.dart';
import '../model/currentweathermodel.dart';
import '../view_model/current_weather_viewmodel.dart';
import 'widgets/current_weather_header.dart';
import 'widgets/weather_detail_card.dart';
import 'widgets/weather_extra_details.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key, required this.request});

  final WeatherRequest request;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadWeather());
  }

  void _loadWeather() {
    if (!mounted) return;

    final location = widget.request.location;
    if (location.lat == null || location.lon == null) return;

    context.read<CurrentWeatherViewModel>().getCurrentWeather(
      location.lat!,
      location.lon!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<CurrentWeatherViewModel>(
          builder: (context, viewModel, _) {
            final response = viewModel.weatherResponse;

            if (response.status == ResponseStatus.loading) {
              return const _WeatherLoading();
            }

            if (response.status == ResponseStatus.error ||
                response.data == null) {
              return _WeatherError(
                message: response.message ?? AppStrings.weatherLoadError,
                onRetry: _loadWeather,
              );
            }

            return _WeatherContent(
              weather: response.data!,
              request: widget.request,
              onRefresh: _loadWeather,
            );
          },
        ),
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({
    required this.weather,
    required this.request,
    required this.onRefresh,
  });

  final CurrentWeather weather;
  final WeatherRequest request;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final main = weather.main;

    return SingleChildScrollView(
      child: Column(
        children: [
          CurrentWeatherHeader(
            weather: weather,
            countryName: request.countryName,
            onBack: () => Navigator.pop(context),
            onRefresh: onRefresh,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              ResponsiveConfig.width(20),
              ResponsiveConfig.height(18),
              ResponsiveConfig.width(20),
              ResponsiveConfig.height(24),
            ),
            child: Column(
              children: [
                _CardRow(
                  height: 104,
                  left: WeatherDetailCard(
                    label: AppStrings.humidity,
                    value: '${main?.humidity ?? 0}%',
                    asset: AppAssets.humidity,
                  ),
                  right: WeatherDetailCard(
                    label: AppStrings.windSpeed,
                    value: '${_number(weather.wind?.speed)} m/s',
                    asset: AppAssets.wind,
                  ),
                ),
                SizedBox(height: ResponsiveConfig.height(6)),
                _CardRow(
                  height: 104,
                  left: WeatherDetailCard(
                    label: AppStrings.pressure,
                    value: '${main?.pressure ?? 0} hPa',
                    asset: AppAssets.pressure,
                  ),
                  right: WeatherDetailCard(
                    label: AppStrings.visibility,
                    value: '${_number((weather.visibility ?? 0) / 1000)} km',
                    asset: AppAssets.visibility,
                  ),
                ),
                SizedBox(height: ResponsiveConfig.height(6)),
                _CardRow(
                  height: 72,
                  left: WeatherDetailCard(
                    label: AppStrings.minimumTemperature,
                    value: '${main?.tempMin?.round() ?? 0}°C',
                  ),
                  right: WeatherDetailCard(
                    label: AppStrings.maximumTemperature,
                    value: '${main?.tempMax?.round() ?? 0}°C',
                  ),
                ),
                SizedBox(height: ResponsiveConfig.height(8)),
                WeatherExtraDetails(
                  details: {
                    AppStrings.cloudiness: '${weather.clouds?.all ?? 0}%',
                    AppStrings.windDirection: '${weather.wind?.deg ?? 0}°',
                    AppStrings.sunrise: _formatTime(
                      weather.sys?.sunrise,
                      weather.timezone,
                    ),
                    AppStrings.sunset: _formatTime(
                      weather.sys?.sunset,
                      weather.timezone,
                    ),
                  },
                ),
                SizedBox(height: ResponsiveConfig.height(12)),
                _ForecastButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RouteNames.forecast,
                    arguments: request,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _number(num? value) {
    if (value == null) return '0';
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  String _formatTime(int? unixTime, int? timezone) {
    if (unixTime == null) return '--';

    final localTime = DateTime.fromMillisecondsSinceEpoch(
      (unixTime + (timezone ?? 0)) * 1000,
      isUtc: true,
    );
    return DateFormat('h:mm a').format(localTime);
  }
}

class _CardRow extends StatelessWidget {
  const _CardRow({
    required this.height,
    required this.left,
    required this.right,
  });

  final double height;
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveConfig.height(height),
      child: Row(
        children: [
          Expanded(child: left),
          SizedBox(width: ResponsiveConfig.width(10)),
          Expanded(child: right),
        ],
      ),
    );
  }
}

class _ForecastButton extends StatelessWidget {
  const _ForecastButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: ResponsiveConfig.height(56),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveConfig.radius(16)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.forecastArrow,
              width: ResponsiveConfig.width(18),
            ),
            SizedBox(width: ResponsiveConfig.width(10)),
            Text(
              AppStrings.fiveDayForecast,
              style: TextStyle(
                fontSize: ResponsiveConfig.scale(16),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: ResponsiveConfig.width(10)),
            Icon(Icons.chevron_right, size: ResponsiveConfig.scale(22)),
          ],
        ),
      ),
    );
  }
}

class _WeatherLoading extends StatelessWidget {
  const _WeatherLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: ResponsiveConfig.width(52),
            height: ResponsiveConfig.width(52),
            child: const CircularProgressIndicator(
              color: AppColors.primaryBlue,
              strokeWidth: 4,
            ),
          ),
          SizedBox(height: ResponsiveConfig.height(24)),
          Text(
            AppStrings.gettingWeather,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: ResponsiveConfig.scale(20),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherError extends StatelessWidget {
  const _WeatherError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveConfig.width(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: ResponsiveConfig.scale(16),
              ),
            ),
            SizedBox(height: ResponsiveConfig.height(18)),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text(AppStrings.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
