import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/motova_logo.dart';
import '../../../shared/widgets/otp_input_box.dart';
import '../../../shared/widgets/primary_button.dart';
import '../data/auth_repository.dart';
import '../models/otp_purpose.dart';

/// Screen 5 — OTP: "Enter verification code"
class OtpScreen extends StatefulWidget {
  final OtpPurpose purpose;
  final String? email;

  const OtpScreen({
    super.key,
    required this.purpose,
    this.email,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthRepository _authRepository = AuthRepository();

  String _enteredCode = '';
  bool _isLoading = false;

  int _resendSecondsLeft =
      AppConstants.otpResendCooldownSeconds;

  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendCountdown() {
    _resendSecondsLeft =
        AppConstants.otpResendCooldownSeconds;

    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return;

        if (_resendSecondsLeft == 0) {
          timer.cancel();
          return;
        }

        setState(() {
          _resendSecondsLeft--;
        });
      },
    );
  }

  bool get _canResend => _resendSecondsLeft == 0;

  void _handleResend() {
    if (!_canResend) return;

    // Backend currently does not expose a dedicated resend endpoint.
    _startResendCountdown();

    setState(() {});
  }

  Future<void> _handleContinue() async {
    // OTP must contain exactly the configured number of digits.
    if (_enteredCode.length != AppConstants.otpLength) {
      return;
    }

    // ------------------------------------------------------------
    // SIGNUP FLOW
    // ------------------------------------------------------------

    if (widget.purpose == OtpPurpose.signup) {
      setState(() {
        _isLoading = true;
      });

      await Future<void>.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      context.push(
        AppRoutes.verificationSuccess,
        extra: VerificationRouteData(
          purpose: OtpPurpose.signup,
          resetToken: '',
        ),
      );

      return;
    }

    // ------------------------------------------------------------
    // PASSWORD RESET FLOW
    // ------------------------------------------------------------

    final email = widget.email;

    if (email == null || email.trim().isEmpty) {
      _showError(
        'Email information is missing. Please start the password reset again.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authRepository.verifyResetOtp(
        email: email.trim(),
        otp: _enteredCode,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Backend returns the short-lived reset_token here.
      context.push(
        AppRoutes.verificationSuccess,
        extra: VerificationRouteData(
          purpose: OtpPurpose.passwordReset,
          resetToken: response.resetToken,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showError(
        error.toString().replaceFirst(
              'Exception: ',
              '',
            ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppDimensions.space24,
              ),

              // --------------------------------------------------
              // Header
              // --------------------------------------------------

              Row(
                children: [
                  const Expanded(
                    child: Center(
                      child: MotovaLogo(),
                    ),
                  ),

                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.backButtonSize / 2,
                    ),
                    child: Container(
                      width: AppDimensions.backButtonSize,
                      height: AppDimensions.backButtonSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppDimensions.space40,
              ),

              // --------------------------------------------------
              // Heading
              // --------------------------------------------------

              Text(
                'Enter verification code',
                style: AppTextStyles.screenHeading,
              ),

              const SizedBox(
                height: AppDimensions.space16,
              ),

              const Text(
                'We have send a Code to your registered email ID',
                style: AppTextStyles.body,
              ),

              const SizedBox(
                height: AppDimensions.space40,
              ),

              // --------------------------------------------------
              // OTP Input
              // --------------------------------------------------

              OtpInputField(
                onChanged: (code) {
                  setState(() {
                    _enteredCode = code;
                  });
                },
                onCompleted: (code) {
                  setState(() {
                    _enteredCode = code;
                  });
                },
              ),

              const SizedBox(
                height: AppDimensions.space40,
              ),

              // --------------------------------------------------
              // Continue
              // --------------------------------------------------

              PrimaryButton(
                text: 'Continue',
                isLoading: _isLoading,
                onPressed: _handleContinue,
              ),

              const SizedBox(
                height: AppDimensions.space32,
              ),

              // --------------------------------------------------
              // Resend
              // --------------------------------------------------

              Center(
                child: GestureDetector(
                  onTap: _handleResend,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Didn't receive the OTP? ",
                          style: AppTextStyles.footerText,
                        ),
                        TextSpan(
                          text: _canResend
                              ? 'Resend.'
                              : 'Resend in ${_resendSecondsLeft}s',
                          style:
                              AppTextStyles.footerLink.copyWith(
                            color: _canResend
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: AppDimensions.space32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}