import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/motova_logo.dart';
import '../../../shared/widgets/primary_button.dart';
import '../data/auth_repository.dart';
import '../models/otp_purpose.dart';

/// Screen 4 — Forgot Password: "Reset your password"
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    setState(() => _isLoading = true);

    try {
      // Call backend:
      // POST /api/v1/auth/forgot-password
      await _authRepository.forgotPassword(
        email: email,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      // Only move to OTP screen after the forgot-password
      // API request has completed successfully.
      context.push(
        AppRoutes.otp,
        extra: OtpRouteData(
          purpose: OtpPurpose.passwordReset,
          email: email,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: AppDimensions.space16,
                ),

                // Header
                Row(
                  children: [
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
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: AppDimensions.backButtonSize,
                          ),
                          child: const MotovaLogo(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: AppDimensions.space56,
                ),

                Text(
                  'Reset your password',
                  style: AppTextStyles.screenHeading,
                ),

                const SizedBox(
                  height: AppDimensions.space16,
                ),

                const Text(
                  "Enter the email address associated with your account and "
                  "we'll send you a link to reset your password.",
                  style: AppTextStyles.body,
                ),

                const SizedBox(
                  height: AppDimensions.space32,
                ),

                // Email
                AppTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),

                const SizedBox(
                  height: AppDimensions.space32,
                ),

                // Continue
                PrimaryButton(
                  text: 'Continue',
                  isLoading: _isLoading,
                  onPressed: _handleContinue,
                ),

                const SizedBox(
                  height: AppDimensions.space56 * 2,
                ),

                // Create account
                Center(
                  child: GestureDetector(
                    onTap: () => context.push(
                      AppRoutes.signup,
                    ),
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Create a ',
                            style: AppTextStyles.footerText,
                          ),
                          TextSpan(
                            text: 'New account',
                            style: AppTextStyles.footerLink,
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
      ),
    );
  }
}