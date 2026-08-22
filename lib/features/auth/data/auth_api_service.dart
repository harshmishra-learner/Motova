import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';

class AuthApiService {
  AuthApiService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  Future<Response<dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) {
    return _dio.post(
      ApiConstants.signup,
      data: {'name': name, 'email': email, 'password': password},
    );
  }

  Future<Response<dynamic>> signin({
    required String email,
    required String password,
  }) {
    return _dio.post(
      ApiConstants.signin,
      data: {'email': email, 'password': password},
    );
  }

  Future<Response<dynamic>> googleSignin({required String idToken}) {
    return _dio.post(ApiConstants.googleSignin, data: {'idToken': idToken});
  }

  Future<Response<dynamic>> forgotPassword({required String email}) {
    return _dio.post(ApiConstants.forgotPassword, data: {'email': email});
  }

  Future<Response<dynamic>> verifyResetOtp({
    required String email,
    required String otp,
  }) {
    return _dio.post(
      ApiConstants.verifyResetOtp,
      data: {'email': email, 'otp': otp},
    );
  }

  Future<Response<dynamic>> resetPassword({
    required String resetToken,
    required String newPassword,
  }) {
    return _dio.post(
      ApiConstants.resetPassword,
      data: {'resetToken': resetToken, 'newPassword': newPassword},
    );
  }
}
