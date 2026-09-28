import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/services/location_service.dart';
import '../../../resources/app_strings.dart';

class CurrentLocationViewModel extends ChangeNotifier {
  CurrentLocationViewModel(this._locationService);

  final LocationService _locationService;

  bool isLoading = false;
  String? errorMessage;

  Future<LocationCoordinates?> getCurrentLocation() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      return await _locationService.getCurrentLocation();
    } on TimeoutException {
      errorMessage = AppStrings.locationTimedOut;
    } on LocationServiceException catch (error) {
      errorMessage = _messageFor(error.failure);
    } catch (_) {
      errorMessage = AppStrings.locationUnavailable;
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return null;
  }

  String _messageFor(LocationFailure failure) {
    switch (failure) {
      case LocationFailure.servicesDisabled:
        return AppStrings.locationServicesDisabled;
      case LocationFailure.permissionDenied:
        return AppStrings.locationPermissionDenied;
      case LocationFailure.permissionDeniedForever:
        return AppStrings.locationPermissionDeniedForever;
      case LocationFailure.unavailable:
        return AppStrings.locationUnavailable;
    }
  }
}
