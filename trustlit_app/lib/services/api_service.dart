import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// API Response Model
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final String? analysisId;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.analysisId,
  });
}

/// API Service for communicating with TrustLit Backend
class ApiService {
  // Base URL - configurable via build-time environment
  // Build with: flutter run --dart-define=API_BASE_URL=https://api.trustlit.com/api
  // For physical device on local network, use your computer's IP
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.29.229:3000/api',
  );

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Dio? _dio;
  bool _isInitialized = false;

  /// Initialize the API service
  void initialize() {
    // Prevent re-initialization
    if (_isInitialized) return;
    
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add logging interceptor for debug builds
    if (kDebugMode) {
      _dio!.interceptors.add(LogInterceptor(
        requestBody: false, // Don't log large base64 images
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
    
    _isInitialized = true;
  }

  /// Check if the backend is healthy
  Future<ApiResponse<Map<String, dynamic>>> healthCheck() async {
    try {
      final response = await _dio!.get('/health');

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: Map<String, dynamic>.from(response.data),
        );
      } else {
        return ApiResponse(
          success: false,
          error: 'Health check failed: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        error: _handleDioError(e),
      );
    } catch (e) {
      return ApiResponse(success: false, error: 'Connection error: $e');
    }
  }

  /// Analyze product images
  ///
  /// [frontImagePath] - Path to front product image
  /// [backImagePath] - Path to back product image (ingredients)
  /// [productType] - 'food' or 'cosmetic'
  Future<ApiResponse<Map<String, dynamic>>> analyzeProduct({
    required String frontImagePath,
    required String backImagePath,
    String productType = 'food',
  }) async {
    try {
      // Read images and convert to base64
      final frontImageBytes = await File(frontImagePath).readAsBytes();
      final backImageBytes = await File(backImagePath).readAsBytes();

      final frontImageBase64 = base64Encode(frontImageBytes);
      final backImageBase64 = base64Encode(backImageBytes);

      if (kDebugMode) {
        debugPrint('Sending analysis request...');
        debugPrint('Front image size: ${frontImageBytes.length} bytes');
        debugPrint('Back image size: ${backImageBytes.length} bytes');
      }

      final response = await _dio!.post(
        '/analyze',
        data: {
          'frontImageBase64': frontImageBase64,
          'backImageBase64': backImageBase64,
          'productType': productType,
        },
      );

      final responseData = response.data;

      if (response.statusCode == 200 && responseData['success'] == true) {
        return ApiResponse(
          success: true,
          data: Map<String, dynamic>.from(responseData['data']),
          analysisId: responseData['analysisId'],
        );
      } else {
        return ApiResponse(
          success: false,
          error: responseData['error'] ?? 'Analysis failed',
        );
      }
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        error: _handleDioError(e),
      );
    } catch (e) {
      return ApiResponse(success: false, error: 'Analysis error: $e');
    }
  }

  /// Analyze product images using multipart form data (alternative method)
  Future<ApiResponse<Map<String, dynamic>>> analyzeProductMultipart({
    required String frontImagePath,
    required String backImagePath,
    String productType = 'food',
  }) async {
    try {
      final formData = FormData.fromMap({
        'productType': productType,
        'frontImage': await MultipartFile.fromFile(
          frontImagePath,
          filename: 'front.jpg',
        ),
        'backImage': await MultipartFile.fromFile(
          backImagePath,
          filename: 'back.jpg',
        ),
      });

      final response = await _dio!.post('/analyze', data: formData);
      final responseData = response.data;

      if (response.statusCode == 200 && responseData['success'] == true) {
        return ApiResponse(
          success: true,
          data: Map<String, dynamic>.from(responseData['data']),
          analysisId: responseData['analysisId'],
        );
      } else {
        return ApiResponse(
          success: false,
          error: responseData['error'] ?? 'Analysis failed',
        );
      }
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        error: _handleDioError(e),
      );
    } catch (e) {
      return ApiResponse(success: false, error: 'Analysis error: $e');
    }
  }

  /// Handle Dio errors and return user-friendly messages
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server response timeout. Analysis may take longer for complex products.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['error'];
        if (statusCode == 429) {
          return 'Too many requests. Please wait a moment.';
        } else if (statusCode == 401) {
          return 'Server configuration error. Please contact support.';
        }
        return message ?? 'Server error: $statusCode';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'Cannot connect to server. Please check your connection.';
      default:
        return e.message ?? 'Network error occurred.';
    }
  }

  /// Update base URL (useful for switching between dev/prod)
  void setBaseUrl(String url) {
    _dio!.options.baseUrl = url;
  }

  // Note: dispose() removed to prevent singleton issues
  // The singleton Dio instance persists for app lifetime
}
