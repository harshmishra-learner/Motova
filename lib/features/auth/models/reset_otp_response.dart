class ResetOtpResponse {
  const ResetOtpResponse({
    required this.resetToken,
  });

  final String resetToken;

  factory ResetOtpResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    if (data == null) {
      throw const FormatException(
        'Invalid OTP response: missing data.',
      );
    }

    final resetToken = data['reset_token']?.toString();

    if (resetToken == null || resetToken.isEmpty) {
      throw const FormatException(
        'Invalid OTP response: missing reset token.',
      );
    }

    return ResetOtpResponse(
      resetToken: resetToken,
    );
  }
}