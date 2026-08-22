import 'auth_user.dart';

class AuthResponse {
  const AuthResponse({
    required this.user,
    required this.accessToken,
  });

  final AuthUser user;
  final String accessToken;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    if (data == null) {
      throw const FormatException(
        'Invalid authentication response: missing data.',
      );
    }

    final userJson = data['user'] as Map<String, dynamic>?;

    if (userJson == null) {
      throw const FormatException(
        'Invalid authentication response: missing user.',
      );
    }

    final accessToken = data['access_token']?.toString();

    if (accessToken == null || accessToken.isEmpty) {
      throw const FormatException(
        'Invalid authentication response: missing access token.',
      );
    }

    return AuthResponse(
      user: AuthUser.fromJson(userJson),
      accessToken: accessToken,
    );
  }
}