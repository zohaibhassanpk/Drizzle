import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../core/config/responsive_config.dart';
import '../../../data/response/response_status.dart';
import '../../../resources/app_assets.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_strings.dart';
import '../../../utils/routes/routes_name.dart';
import '../model_view/current_location_viewmodel.dart';
import '../model_view/search_viewmodel.dart';
import '../model/search_model.dart';
import 'widgets/search_header.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _cityController = TextEditingController();
  Country? _selectedCountry;
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _cityController.dispose();
    super.dispose();
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveConfig.radius(24)),
        ),
      ),
      onSelect: (country) {
        setState(() {
          _selectedCountry = country;
          _cityController.clear();
        });
        context.read<SearchViewModel>().clearCitySearch();
      },
    );
  }

  void _onCityChanged(String city) {
    _searchDebounce?.cancel();

    if (_selectedCountry == null || city.trim().isEmpty) {
      context.read<SearchViewModel>().clearCitySearch();
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.read<SearchViewModel>().searchCity(
        city,
        _selectedCountry!.countryCode,
      );
    });
  }

  void _selectCity(CityLocation city) {
    _searchDebounce?.cancel();
    _cityController.text = city.name ?? '';
    context.read<SearchViewModel>().clearCitySearch();
    FocusScope.of(context).unfocus();
  }

  Future<void> _searchWeather() async {
    if (_selectedCountry == null) {
      _showMessage(AppStrings.selectCountryFirst);
      return;
    }

    final city = _cityController.text.trim();
    if (city.isEmpty) {
      _showMessage(AppStrings.searchCity);
      return;
    }

    await Navigator.pushNamed(
      context,
      RouteNames.searchLoading,
      arguments: SearchRequest(
        city: city,
        countryCode: _selectedCountry!.countryCode,
        countryName: _selectedCountry!.name,
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    final viewModel = context.read<CurrentLocationViewModel>();
    final coordinates = await viewModel.getCurrentLocation();

    if (!mounted) return;

    if (coordinates == null) {
      _showMessage(viewModel.errorMessage ?? AppStrings.locationUnavailable);
      return;
    }

    await Navigator.pushNamed(
      context,
      RouteNames.currentWeather,
      arguments: WeatherRequest(
        location: CityLocation(
          lat: coordinates.latitude,
          lon: coordinates.longitude,
        ),
        countryName: '',
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final cityEnabled = _selectedCountry != null;
    final locationViewModel = context.watch<CurrentLocationViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<SearchViewModel>(
          builder: (context, viewModel, _) {
            final isLoading =
                viewModel.cityResponse.status == ResponseStatus.loading;
            final errorMessage =
                viewModel.cityResponse.status == ResponseStatus.error
                ? viewModel.cityResponse.message
                : null;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                ResponsiveConfig.width(40),
                ResponsiveConfig.height(40),
                ResponsiveConfig.width(40),
                ResponsiveConfig.height(24),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      ResponsiveConfig.screenHeight -
                      ResponsiveConfig.height(88),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SearchHeader(),
                    SizedBox(height: ResponsiveConfig.height(40)),
                    _FieldLabel(text: AppStrings.country),
                    SizedBox(height: ResponsiveConfig.height(8)),
                    _CountryField(
                      country: _selectedCountry,
                      onTap: _selectCountry,
                    ),
                    SizedBox(height: ResponsiveConfig.height(18)),
                    _FieldLabel(text: AppStrings.city),
                    SizedBox(height: ResponsiveConfig.height(8)),
                    _CityField(
                      controller: _cityController,
                      enabled: cityEnabled,
                      onChanged: _onCityChanged,
                      onSubmitted: (_) => _searchWeather(),
                    ),
                    SizedBox(height: ResponsiveConfig.height(8)),
                    Text(
                      cityEnabled
                          ? AppStrings.searchingIn(_selectedCountry!.name)
                          : AppStrings.selectCountryFirst,
                      style: TextStyle(
                        color: AppColors.hintText,
                        fontSize: ResponsiveConfig.scale(12),
                      ),
                    ),
                    if (errorMessage != null) ...[
                      SizedBox(height: ResponsiveConfig.height(8)),
                      Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: ResponsiveConfig.scale(12),
                        ),
                      ),
                    ],
                    if (isLoading) ...[
                      SizedBox(height: ResponsiveConfig.height(12)),
                      const _SearchStatus(message: AppStrings.searchingCities),
                    ],
                    if (viewModel.cityResponse.status ==
                            ResponseStatus.completed &&
                        viewModel.cityResponse.data!.isNotEmpty) ...[
                      SizedBox(height: ResponsiveConfig.height(12)),
                      _SearchCompleteMessage(
                        message: AppStrings.citySearchComplete,
                      ),
                      SizedBox(height: ResponsiveConfig.height(6)),
                      _CitySuggestions(
                        cities: viewModel.cityResponse.data!,
                        onSelected: _selectCity,
                      ),
                    ],
                    // A fixed responsive gap keeps this scrollable form simple.
                    // Spacer cannot be used inside SingleChildScrollView.
                    SizedBox(height: ResponsiveConfig.height(120)),
                    _GetWeatherButton(
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _searchWeather,
                    ),
                    SizedBox(height: ResponsiveConfig.height(10)),
                    TextButton.icon(
                      onPressed: locationViewModel.isLoading
                          ? null
                          : _useCurrentLocation,
                      icon: locationViewModel.isLoading
                          ? SizedBox(
                              width: ResponsiveConfig.width(16),
                              height: ResponsiveConfig.width(16),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryBlue,
                              ),
                            )
                          : Icon(
                              Icons.location_on_outlined,
                              size: ResponsiveConfig.scale(18),
                              color: AppColors.primaryBlue,
                            ),
                      label: Text(
                        locationViewModel.isLoading
                            ? AppStrings.gettingLocation
                            : AppStrings.useCurrentLocation,
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: ResponsiveConfig.scale(15),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: AppColors.labelText,
      fontSize: ResponsiveConfig.scale(13),
      fontWeight: FontWeight.w600,
    ),
  );
}

class _CountryField extends StatelessWidget {
  const _CountryField({required this.country, required this.onTap});

  final Country? country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveConfig.radius(16)),
        child: Container(
          height: ResponsiveConfig.height(56),
          padding: EdgeInsets.symmetric(horizontal: ResponsiveConfig.width(16)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveConfig.radius(16)),
            border: Border.all(color: AppColors.primaryBlue),
          ),
          child: Row(
            children: [
              Text(
                country?.flagEmoji ?? '🏳️',
                style: TextStyle(fontSize: ResponsiveConfig.scale(21)),
              ),
              SizedBox(width: ResponsiveConfig.width(12)),
              Expanded(
                child: Text(
                  country?.name ?? AppStrings.selectCountry,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveConfig.scale(16),
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
                size: ResponsiveConfig.scale(20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CityField extends StatelessWidget {
  const _CityField({
    required this.controller,
    required this.enabled,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: AppStrings.searchCity,
        hintStyle: TextStyle(
          color: enabled ? AppColors.textSecondary : AppColors.disabledText,
          fontSize: ResponsiveConfig.scale(15),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.all(ResponsiveConfig.width(17)),
          child: SvgPicture.asset(AppAssets.searchField),
        ),
        filled: true,
        fillColor: enabled ? AppColors.card : AppColors.disabledBackground,
        contentPadding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(
          height: ResponsiveConfig.height(56),
        ),
        border: _border(AppColors.fieldBorder),
        enabledBorder: _border(AppColors.fieldBorder),
        disabledBorder: _border(AppColors.disabledBackground),
        focusedBorder: _border(AppColors.primaryBlue),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(ResponsiveConfig.radius(16)),
    borderSide: BorderSide(color: color),
  );
}

class _SearchStatus extends StatelessWidget {
  const _SearchStatus({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: ResponsiveConfig.width(14),
        height: ResponsiveConfig.width(14),
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      SizedBox(width: ResponsiveConfig.width(8)),
      Text(
        message,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: ResponsiveConfig.scale(12),
        ),
      ),
    ],
  );
}

class _CitySuggestions extends StatelessWidget {
  const _CitySuggestions({required this.cities, required this.onSelected});

  final List<CityLocation> cities;
  final ValueChanged<CityLocation> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveConfig.radius(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.08),
            blurRadius: ResponsiveConfig.radius(14),
            offset: Offset(0, ResponsiveConfig.height(4)),
          ),
        ],
      ),
      child: Column(
        children: cities
            .map(
              (city) => ListTile(
                onTap: () => onSelected(city),
                leading: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryBlue,
                ),
                title: Text(city.name ?? ''),
                subtitle: Text(city.state ?? city.country ?? ''),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SearchCompleteMessage extends StatelessWidget {
  const _SearchCompleteMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Text(
    message,
    style: TextStyle(
      color: AppColors.textSecondary,
      fontSize: ResponsiveConfig.scale(12),
    ),
  );
}

class _GetWeatherButton extends StatelessWidget {
  const _GetWeatherButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: ResponsiveConfig.height(58),
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.buttonBlue],
        ),
        borderRadius: BorderRadius.circular(ResponsiveConfig.radius(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.32),
            blurRadius: ResponsiveConfig.radius(16),
            offset: Offset(0, ResponsiveConfig.height(8)),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveConfig.radius(16)),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                AppStrings.getWeather,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveConfig.scale(17),
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    ),
  );
}
