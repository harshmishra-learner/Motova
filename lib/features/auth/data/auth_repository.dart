import 'package:dio/dio.dart';

import '../models/auth_response.dart';
import '../models/reset_otp_response.dart';
import 'auth_api_service.dart';

class AuthRepository {
  AuthRepository({AuthApiService? apiService})
    : _apiService = apiService ?? AuthApiService();

  final AuthApiService _apiService;

  Future<AuthResponse> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.signup(
        name: name,
        email: email,
        password: password,
      );

      return AuthResponse.fromJson(_responseData(response));
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<AuthResponse> signin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.signin(
        email: email,
        password: password,
      );

      return AuthResponse.fromJson(_responseData(response));
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<AuthResponse> googleSignin({required String idToken}) async {
    try {
      final response = await _apiService.googleSignin(idToken: idToken);

      return AuthResponse.fromJson(_responseData(response));
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _apiService.forgotPassword(email: email);
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<ResetOtpResponse> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _apiService.verifyResetOtp(email: email, otp: otp);

      return ResetOtpResponse.fromJson(_responseData(response));
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      await _apiService.resetPassword(
        resetToken: resetToken,
        newPassword: newPassword,
      );
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Map<String, dynamic> _responseData(Response<dynamic> response) {
    final data = response.data;

    if (data is! Map) {
      throw const FormatException('Invalid server response.');
    }

    return Map<String, dynamic>.from(data);
  }

  Exception _handleDioError(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map) {
      final message = responseData['message']?.toString();

      if (message != null && message.isNotEmpty) {
        return Exception(message);
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return Exception('Connection timed out. Please try again.');
    }

    if (error.type == DioExceptionType.connectionError) {
      return Exception(
        'Unable to connect to the server. Please check your connection.',
      );
    }

    return Exception('Something went wrong. Please try again.');
  }
}
