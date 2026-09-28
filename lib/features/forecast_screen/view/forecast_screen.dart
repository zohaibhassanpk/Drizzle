import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/config/responsive_config.dart';
import '../../../data/response/response_status.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_strings.dart';
import '../../search_screen/model/search_model.dart';
import '../model/forecastmodel.dart';
import '../viewmodel/forecast_viewmodel.dart';
import 'widgets/daily_forecast_list.dart';
import 'widgets/forecast_header.dart';
import 'widgets/forecast_tip.dart';
import 'widgets/hourly_forecast_card.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key, required this.request});

  final WeatherRequest request;

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadForecast());
  }

  void _loadForecast() {
    if (!mounted) return;

    final location = widget.request.location;
    if (location.lat == null || location.lon == null) return;

    context.read<ForecastViewModel>().getForecast(location.lat!, location.lon!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<ForecastViewModel>(
          builder: (context, viewModel, _) {
            final response = viewModel.forecastResponse;

            if (response.status == ResponseStatus.loading) {
              return const _ForecastLoading();
            }

            if (response.status == ResponseStatus.error ||
                response.data == null ||
                response.data!.list == null ||
                response.data!.list!.isEmpty) {
              return _ForecastError(
                message: response.message ?? AppStrings.forecastLoadError,
                onRetry: _loadForecast,
              );
            }

            return _ForecastContent(
              forecast: response.data!,
              countryName: widget.request.countryName,
              onRefresh: _loadForecast,
            );
          },
        ),
      ),
    );
  }
}

class _ForecastContent extends StatelessWidget {
  const _ForecastContent({
    required this.forecast,
    required this.countryName,
    required this.onRefresh,
  });

  final ForecastModel forecast;
  final String countryName;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final items = forecast.list!;
    final timezone = forecast.city?.timezone ?? 0;
    final hourlyItems = items.take(8).toList();
    final dailyItems = _createDailyForecast(items, timezone);
    final country = countryName.trim().isNotEmpty
        ? countryName
        : forecast.city?.country ?? '';
    final location = [
      forecast.city?.name,
      country,
    ].whereType<String>().where((value) => value.isNotEmpty).join(', ');
    final rainiestDay = dailyItems.reduce(
      (current, next) => next.rainChance > current.rainChance ? next : current,
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          ForecastHeader(
            location: location,
            subtitle:
                '${AppStrings.fiveDayForecast} · ${_headerDate(items.first, timezone)}',
            onBack: () => Navigator.pop(context),
            onRefresh: onRefresh,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              ResponsiveConfig.width(20),
              0,
              ResponsiveConfig.width(20),
              ResponsiveConfig.height(24),
            ),
            child: Column(
              children: [
                const _SectionTitle(
                  title: AppStrings.next24Hours,
                  trailing: AppStrings.everyThreeHours,
                ),
                SizedBox(
                  height: ResponsiveConfig.height(113),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    itemCount: hourlyItems.length,
                    separatorBuilder: (_, _) =>
                        SizedBox(width: ResponsiveConfig.width(10)),
                    itemBuilder: (context, index) {
                      final item = hourlyItems[index];
                      final weather = item.weather?.firstOrNull;

                      return HourlyForecastCard(
                        time: index == 0
                            ? AppStrings.now
                            : DateFormat('h a')
                                  .format(_localDate(item.dt, timezone)),
                        temperature: item.main?.temp?.round() ?? 0,
                        rainChance: ((item.pop ?? 0) * 100).round(),
                        weatherId: weather?.id,
                        iconCode: weather?.icon,
                        isNow: index == 0,
                      );
                    },
                  ),
                ),
                const _SectionTitle(
                  title: AppStrings.fiveDayForecast,
                  trailing: AppStrings.lowHigh,
                ),
                DailyForecastList(days: dailyItems),
                SizedBox(height: ResponsiveConfig.height(14)),
                ForecastTip(
                  hasRain: rainiestDay.rainChance > 0,
                  message: rainiestDay.rainChance > 0
                      ? AppStrings.rainTip(
                          rainiestDay.day.toLowerCase(),
                          rainiestDay.rainChance,
                        )
                      : AppStrings.noRainExpected,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DailyForecastData> _createDailyForecast(
    List<ForecastItem> items,
    int timezone,
  ) {
    final grouped = <DateTime, List<ForecastItem>>{};

    for (final item in items) {
      final date = _localDate(item.dt, timezone);
      final day = DateTime.utc(date.year, date.month, date.day);
      grouped.putIfAbsent(day, () => []).add(item);
    }

    return grouped.entries.take(5).toList().asMap().entries.map((entry) {
      final index = entry.key;
      final group = entry.value;
      final dayItems = group.value;
      final temperatures = dayItems
          .map((item) => item.main?.temp ?? 0)
          .toList();
      final rainChance = dayItems
          .map((item) => ((item.pop ?? 0) * 100).round())
          .reduce(math.max);
      final representative = dayItems.reduce(
        (current, next) =>
            _weatherPriority(next) > _weatherPriority(current) ? next : current,
      );
      final weather = representative.weather?.firstOrNull;

      return DailyForecastData(
        day: index == 0 ? 'Today' : DateFormat('EEE').format(group.key),
        minimum: temperatures.reduce(math.min).round(),
        maximum: temperatures.reduce(math.max).round(),
        rainChance: rainChance,
        weatherId: weather?.id,
        iconCode: weather?.icon,
      );
    }).toList();
  }

  int _weatherPriority(ForecastItem item) {
    final id = item.weather?.firstOrNull?.id ?? 800;
    if (id < 300) return 4;
    if (id < 600) return 3;
    if (id > 800) return 2;
    return 1;
  }

  String _headerDate(ForecastItem item, int timezone) {
    return DateFormat('EEE, d MMM').format(_localDate(item.dt, timezone));
  }

  DateTime _localDate(int? unixTime, int timezone) {
    return DateTime.fromMillisecondsSinceEpoch(
      ((unixTime ?? 0) + timezone) * 1000,
      isUtc: true,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ResponsiveConfig.height(18),
        bottom: ResponsiveConfig.height(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: ResponsiveConfig.scale(16),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            trailing,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: ResponsiveConfig.scale(12),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForecastLoading extends StatelessWidget {
  const _ForecastLoading();

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
            AppStrings.gettingForecast,
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

class _ForecastError extends StatelessWidget {
  const _ForecastError({required this.message, required this.onRetry});

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
