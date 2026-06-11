
/// HTTP status codes
class HttpStatus {
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int conflict = 409;
  static const int internalServerError = 500;
  static const int serviceUnavailable = 503;
}

/// API Client for handling HTTP requests
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal();

  // TODO: Implement with http or dio package
  // final HttpClient _httpClient = HttpClient();
  // final Dio _dio = Dio();

  Future<void> initialize() async {
    // TODO: Setup HTTP client with interceptors, headers, etc.
    // _dio.options.baseUrl = AppConstants.apiBaseUrl;
    // _dio.options.connectTimeout = AppConstants.apiTimeout;
    // _dio.interceptors.add(LoggingInterceptor());
  }

  /// GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      // TODO: Implement GET request
      // final response = await _dio.get(
      //   endpoint,
      //   queryParameters: queryParameters,
      //   options: Options(headers: headers),
      // );
      // return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// POST request
  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      // TODO: Implement POST request
      // final response = await _dio.post(
      //   endpoint,
      //   data: body,
      //   options: Options(headers: headers),
      // );
      // return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// PUT request
  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      // TODO: Implement PUT request
      // final response = await _dio.put(
      //   endpoint,
      //   data: body,
      //   options: Options(headers: headers),
      // );
      // return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE request
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      // TODO: Implement DELETE request
      // final response = await _dio.delete(
      //   endpoint,
      //   options: Options(headers: headers),
      // );
      // return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Handle API response
  dynamic _handleResponse(dynamic response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.data;
    } else {
      throw ApiException(
        message: response.statusMessage ?? 'Unknown error',
        statusCode: response.statusCode,
      );
    }
  }

  /// Upload file
  Future<dynamic> uploadFile(
    String endpoint,
    String filePath, {
    Map<String, String>? additionalFields,
  }) async {
    try {
      // TODO: Implement file upload with multipart
    } catch (e) {
      rethrow;
    }
  }
}

/// API Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// API Response wrapper
class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;

  ApiResponse({
    this.data,
    this.message,
    required this.success,
    this.statusCode,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse(
      data: data,
      success: true,
      statusCode: HttpStatus.ok,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse(
      message: message,
      success: false,
      statusCode: statusCode,
    );
  }
}

/// HTTP Interceptor for logging (optional)
class LoggingInterceptor {
  // TODO: Implement request/response logging
  // void onRequest(RequestOptions options) {
  //   if (AppConstants.enableDebugLogging) {
  //     print('REQUEST: ${options.method} ${options.path}');
  //     print('Headers: ${options.headers}');
  //     print('Data: ${options.data}');
  //   }
  // }
}
