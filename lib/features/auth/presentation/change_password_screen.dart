import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/motova_logo.dart';
import '../../../shared/widgets/password_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../data/auth_repository.dart';

/// Screen 7 — Change Password: New Password, Confirm Password.
class ChangePasswordScreen extends StatefulWidget {
  final String resetToken;

  const ChangePasswordScreen({
    super.key,
    required this.resetToken,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    // Validate both password fields first.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // resetToken is required by the backend.
    if (widget.resetToken.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your password reset session has expired. Please request a new OTP.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authRepository.resetPassword(
        resetToken: widget.resetToken,
        newPassword: _newPasswordController.text,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password reset successfully.',
          ),
        ),
      );

      // Clear the password-reset navigation stack
      // and take the user back to Login.
      context.go(AppRoutes.login);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
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
                  height: AppDimensions.space40,
                ),

                // Logo
                const Center(
                  child: MotovaLogo(),
                ),

                const SizedBox(
                  height: AppDimensions.space32,
                ),

                // Heading
                SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Change your password',
                      maxLines: 1,
                      softWrap: false,
                      style: AppTextStyles.screenHeading,
                    ),
                  ),
                ),

                const SizedBox(
                  height: AppDimensions.space16,
                ),

                const Text(
                  'Enter New Password and Log into your account',
                  style: AppTextStyles.body,
                ),

                const SizedBox(
                  height: AppDimensions.space40,
                ),

                // New Password
                PasswordField(
                  hintText: 'New Password',
                  controller: _newPasswordController,
                  validator: Validators.password,
                ),

                const SizedBox(
                  height: AppDimensions.space16,
                ),

                // Confirm Password
                PasswordField(
                  hintText: 'Confirm Password',
                  controller: _confirmPasswordController,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    _newPasswordController.text,
                  ),
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