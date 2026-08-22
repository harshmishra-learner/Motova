import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/otp_purpose.dart';

/// Screen 6 — Verification Success: green shield-check, "Successful"
class VerificationSuccessScreen extends StatelessWidget {
  final OtpPurpose purpose;
  final String? resetToken;

  const VerificationSuccessScreen({
    super.key,
    required this.purpose,
    this.resetToken,
  });

  void _handleNext(BuildContext context) {
    switch (purpose) {
      case OtpPurpose.signup:
        // New account — land on the app shell.
        context.go(AppRoutes.home);
        break;

      case OtpPurpose.passwordReset:
        // A reset token is required to change the password.
        if (resetToken == null || resetToken!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Reset session expired. Please request a new OTP.',
              ),
            ),
          );
          return;
        }

        // Pass reset token to Change Password screen.
        context.pushReplacement(
          AppRoutes.changePassword,
          extra: resetToken,
        );
        break;
    }
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

              // Title
              Center(
                child: Text(
                  'Verify Status',
                  style: AppTextStyles.sectionTitle,
                ),
              ),

              const SizedBox(
                height: AppDimensions.space56 * 1.4,
              ),

              // Success icon
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.successSurface,
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    size: 76,
                    color: AppColors.success,
                  ),
                ),
              ),

              const SizedBox(
                height: AppDimensions.space40,
              ),

              // Successful
              Center(
                child: Text(
                  'Successful',
                  style: AppTextStyles.sectionTitle,
                ),
              ),

              const SizedBox(
                height: AppDimensions.space16,
              ),

              // Description
              const Center(
                child: Text(
                  'Your OTP verification was successful. now you can proceed '
                  'with your account setup.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
              ),

              const SizedBox(
                height: AppDimensions.space40,
              ),

              // Next button
              PrimaryButton(
                text: 'Next',
                onPressed: () => _handleNext(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}