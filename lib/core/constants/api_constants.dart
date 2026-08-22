class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://192.168.1.43:5000';

  static const String signup = '/api/v1/auth/signup';
  static const String signin = '/api/v1/auth/signin';
  static const String googleSignin = '/api/v1/auth/google';

  static const String forgotPassword =
      '/api/v1/auth/forgot-password';

  static const String verifyResetOtp =
      '/api/v1/auth/verify-reset-otp';

  static const String resetPassword =
      '/api/v1/auth/reset-password';
}