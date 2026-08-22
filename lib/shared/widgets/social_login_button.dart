import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';

enum SocialProvider { apple, google }

/// Light-gray pill button for "Login/Sign up using Apple/Google".
class SocialLoginButton extends StatelessWidget {
  final SocialProvider provider;
  final String label;
  final VoidCallback? onPressed;

  const SocialLoginButton({
    super.key,
    required this.provider,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.socialButtonHeight,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          provider == SocialProvider.apple ? Icons.apple : Icons.g_mobiledata,
          size: provider == SocialProvider.apple ? 22 : 28,
          color: AppColors.textPrimary,
        ),
        label: Text(label, style: AppTextStyles.socialButton),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.socialButtonBackground,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          ),
        ),
      ),
    );
  }
}