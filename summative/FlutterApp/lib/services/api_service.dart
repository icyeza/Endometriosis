import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prediction_model.dart';

class ApiService {
  late Dio _dio;
  late SharedPreferences _prefs;
  static const String _baseUrlKey = 'api_base_url';
  static const String _defaultBaseUrl = 'http://localhost:8000';

  ApiService() {
    _dio = Dio();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<String> getBaseUrl() async {
    await _initPreferences();
    return _prefs.getString(_baseUrlKey) ?? _defaultBaseUrl;
  }

  Future<void> setBaseUrl(String url) async {
    await _initPreferences();
    await _prefs.setString(_baseUrlKey, url);
  }

  Future<PredictionResponse> predict(PredictionRequest request) async {
    try {
      final baseUrl = await getBaseUrl();
      final url = '$baseUrl/predict';

      print('=== API Service ===');
      print('Sending POST to: $url');
      print('Request data: ${request.toJson()}');

      final response = await _dio.post(
        url,
        data: request.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {'Accept': 'application/json'},
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data type: ${response.data.runtimeType}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        print('Parsing response...');
        final parsed = PredictionResponse.fromJson(response.data);
        print('Successfully parsed response');
        return parsed;
      } else {
        throw ApiException(
          message: 'Failed to get prediction (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('DioException: ${e.type} - ${e.message}');
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      print('Unexpected error in predict: $e');
      print('Stack trace: $stackTrace');
      throw ApiException(message: 'An unexpected error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> getHealth() async {
    try {
      final baseUrl = await getBaseUrl();
      final url = '$baseUrl/health';

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          message: 'Health check failed (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Map<String, dynamic>> getModelInfo() async {
    try {
      final baseUrl = await getBaseUrl();
      final url = '$baseUrl/model-info';

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          message: 'Failed to get model info (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  ApiException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: 'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.sendTimeout:
        return ApiException(message: 'Request timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Response timeout. Please try again.');
      case DioExceptionType.badResponse:
        return ApiException(
          message:
              _extractErrorMessage(e.response?.data) ?? 'Server error occurred',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled');
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Connection error. Please check your internet connection.',
        );
      case DioExceptionType.unknown:
        return ApiException(
          message: 'An unexpected error occurred: ${e.message}',
        );
      default:
        return ApiException(message: 'An error occurred: ${e.message}');
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('detail')) {
        final detail = data['detail'];
        if (detail is List && detail.isNotEmpty) {
          final firstError = detail[0];
          if (firstError is Map && firstError.containsKey('msg')) {
            return firstError['msg'];
          }
        } else if (detail is String) {
          return detail;
        }
      }
      if (data.containsKey('message')) {
        return data['message'];
      }
    }
    return null;
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;
}
