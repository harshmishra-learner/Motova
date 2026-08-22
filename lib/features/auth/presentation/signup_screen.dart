import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/motova_logo.dart';
import '../../../shared/widgets/or_divider.dart';
import '../../../shared/widgets/password_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/social_login_button.dart';
import '../data/auth_repository.dart';
import '../data/auth_storage.dart';

/// Screen 3 — Sign Up: Full Name, Email, Password.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();
  final AuthStorage _authStorage = AuthStorage();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authResponse = await _authRepository.signup(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await _authStorage.saveSession(
        accessToken: authResponse.accessToken,
        user: authResponse.user,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      // Clears the auth stack and lands on the main app shell.
      context.go(AppRoutes.home);
    } catch (error) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  void _goToLogin(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontalPadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.space40),

                const Center(
                  child: MotovaLogo(),
                ),

                const SizedBox(height: AppDimensions.space32),

                Center(
                  child: Text(
                    'Sign Up',
                    style: AppTextStyles.screenHeading,
                  ),
                ),

                const SizedBox(height: AppDimensions.space32),

                AppTextField(
                  hintText: 'Full Name',
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validator: Validators.name,
                ),

                const SizedBox(height: AppDimensions.space16),

                AppTextField(
                  hintText: 'Email Address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),

                const SizedBox(height: AppDimensions.space16),

                PasswordField(
                  controller: _passwordController,
                  validator: Validators.password,
                ),

                const SizedBox(height: AppDimensions.space32),

                PrimaryButton(
                  text: 'Sign up',
                  isLoading: _isLoading,
                  onPressed: _handleSignup,
                ),

                const SizedBox(height: AppDimensions.space24),

                const OrDivider(),

                const SizedBox(height: AppDimensions.space24),

                SocialLoginButton(
                  provider: SocialProvider.apple,
                  label: 'Sign up using Apple',
                  onPressed: () {
                    // TODO(later): wire real Apple Sign-In.
                  },
                ),

                const SizedBox(height: AppDimensions.space16),

                SocialLoginButton(
                  provider: SocialProvider.google,
                  label: 'Sign up using Google',
                  onPressed: () {
                    // TODO(later): wire real Google Sign-In.
                  },
                ),

                const SizedBox(height: AppDimensions.space56),

                Center(
                  child: GestureDetector(
                    onTap: () => _goToLogin(context),
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: AppTextStyles.footerText,
                          ),
                          TextSpan(
                            text: 'Login.',
                            style: AppTextStyles.footerLink,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.space32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}