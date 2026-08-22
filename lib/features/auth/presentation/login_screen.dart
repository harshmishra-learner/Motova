import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

/// Screen 2 — Login: "Ready to hit the road."
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();
  final AuthStorage _authStorage = AuthStorage();

  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authResponse = await _authRepository.signin(
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

  Future<void> _handleGoogleLogin() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final googleUser = await googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      final idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Unable to get Google ID token.');
      }

      final authResponse = await _authRepository.googleSignin(
        idToken: idToken,
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Responsive heading size.
    //
    // Normal/large phones:
    //   400+  -> 42
    //
    // Medium phones:
    //   360-399 -> 38
    //
    // Small phones:
    //   <360 -> 34
    //
    // FittedBox below guarantees that the text stays
    // on ONE LINE if the available width is smaller.
    final headingFontSize = screenWidth < 360
        ? 34.0
        : screenWidth < 400
            ? 38.0
            : 42.0;

    // Only reduce vertical spacing on short screens.
    final isSmallHeight = screenHeight < 700;

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
                // Top spacing
                SizedBox(
                  height: isSmallHeight
                      ? AppDimensions.space24
                      : AppDimensions.space40,
                ),

                // Logo
                const Center(
                  child: MotovaLogo(),
                ),

                SizedBox(
                  height: isSmallHeight
                      ? AppDimensions.space24
                      : AppDimensions.space40,
                ),

                // -------------------------------------------------
                // RESPONSIVE HEADING
                // Always remains on ONE LINE.
                // -------------------------------------------------
                SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ready to hit the road',
                      maxLines: 1,
                      softWrap: false,
                      style: AppTextStyles.screenHeading.copyWith(
                        fontSize: headingFontSize,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: isSmallHeight
                      ? AppDimensions.space24
                      : AppDimensions.space32,
                ),

                // Email
                AppTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),

                const SizedBox(
                  height: AppDimensions.space16,
                ),

                // Password
                PasswordField(
                  controller: _passwordController,
                  validator: Validators.password,
                ),

                const SizedBox(
                  height: AppDimensions.space16,
                ),

                // Remember Me + Forgot Password
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: AppDimensions.space8,
                          ),
                          Flexible(
                            child: Text(
                              'Remember Me',
                              style: AppTextStyles.caption,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    Flexible(
                      child: GestureDetector(
                        onTap: () =>
                            context.push(AppRoutes.forgotPassword),
                        child: Text(
                          'Forgot Password',
                          style: AppTextStyles.caption,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: isSmallHeight
                      ? AppDimensions.space24
                      : AppDimensions.space32,
                ),

                // Login button
                PrimaryButton(
                  text: 'Login',
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),

                const SizedBox(
                  height: AppDimensions.space24,
                ),

                // OR divider
                const OrDivider(),

                const SizedBox(
                  height: AppDimensions.space24,
                ),

                // Apple login
                SocialLoginButton(
                  provider: SocialProvider.apple,
                  label: 'Login using Apple',
                  onPressed: () {
                    // TODO(later): wire real Apple Sign-In.
                  },
                ),

                const SizedBox(
                  height: AppDimensions.space16,
                ),

                // Google login
                SocialLoginButton(
                  provider: SocialProvider.google,
                  label: 'Login using Google',
                  onPressed: _handleGoogleLogin,
                ),

                SizedBox(
                  height: isSmallHeight
                      ? AppDimensions.space32
                      : AppDimensions.space56,
                ),

                // Sign Up
                Center(
                  child: GestureDetector(
                    onTap: () => context.push(AppRoutes.signup),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: AppTextStyles.footerText,
                          ),
                          TextSpan(
                            text: 'Sign Up.',
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