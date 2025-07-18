import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class HttpAdapter {
  Future<Map<String, dynamic>> get(String url, {Map<String, dynamic>? params});
  Future<Map<String, dynamic>> post(String url, {Map<String, dynamic>? data});
  Future<Map<String, dynamic>> put(String url, {Map<String, dynamic>? data});
  Future<Map<String, dynamic>> delete(String url);
}

class DioHttpAdapter implements HttpAdapter {
  final Dio _dio;

  DioHttpAdapter({String? baseUrl}) : _dio = Dio() {
    _dio.options.baseUrl = baseUrl ?? 'http://ec2-18-233-90-66.compute-1.amazonaws.com';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) {
          if (kDebugMode) {
            debugPrint(object.toString());
          }
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(_handleError(error));
        },
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> get(String url, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(url, queryParameters: params);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> post(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(url, data: data);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> put(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(url, data: data);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> delete(String url) async {
    try {
      final response = await _dio.delete(url);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data is Map<String, dynamic> ? response.data : {'data': response.data};
    } else {
      throw HttpException('HTTP ${response.statusCode}: ${response.statusMessage}');
    }
  }

  DioException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DioException(requestOptions: error.requestOptions, error: 'Timeout de conexão. Verifique sua internet.', type: error.type);
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        String message = 'Erro do servidor';

        if (statusCode == 401) {
          message = 'Não autorizado. Faça login novamente.';
        } else if (statusCode == 404) {
          message = 'Recurso não encontrado.';
        } else if (statusCode == 500) {
          message = 'Erro interno do servidor.';
        }

        return DioException(requestOptions: error.requestOptions, error: message, type: error.type, response: error.response);
      default:
        return DioException(requestOptions: error.requestOptions, error: 'Erro de conexão. Verifique sua internet.', type: error.type);
    }
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
