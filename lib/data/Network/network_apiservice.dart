import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../app_exeption.dart';
import 'base_apiservice.dart';

class NetworkApiService extends Baseapiservice {
  @override
  Future<dynamic> getResponse(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      switch (response.statusCode) {
        case 200:
          return jsonDecode(response.body);
        case 400:
          throw const BadRequestException();
        case 401:
          throw const UnauthorizedException();
        case 404:
          throw const NotFoundException();
        case 429:
          throw const RateLimitException();
        default:
          if (response.statusCode >= 500) throw const ServerException();
          throw AppException(
            'Request failed (${response.statusCode}).',
            statusCode: response.statusCode,
          );
      }
    } on SocketException {
      throw const NoInternetException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    } on http.ClientException {
      throw const AppException('Could not connect to the weather service.');
    } on FormatException {
      throw const AppException('Invalid URL or response data.');
    }
  }
}
