import 'package:flutter/material.dart';
import '../../app/theme/app_dimensions.dart';

/// Which pre-colored logo asset to render.
enum MotovaLogoVariant { dark, light }

/// Reusable MOTOVA wordmark image.
/// Uses [MotovaLogoVariant.dark] (black) on light backgrounds —
/// Login, Sign Up, Forgot Password, OTP, Change Password.
/// Uses [MotovaLogoVariant.light] (white) on dark backgrounds — Onboarding.
class MotovaLogo extends StatelessWidget {
  final double width;
  final MotovaLogoVariant variant;

  const MotovaLogo({
    super.key,
    this.width = AppDimensions.logoWidthDefault,
    this.variant = MotovaLogoVariant.dark,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = variant == MotovaLogoVariant.dark
        ? 'assets/images/motova_logo_black.png'
        : 'assets/images/motova_logo_white.png';

    return Image.asset(
      assetPath,
      width: width,
      fit: BoxFit.contain,
      // Falls back to text if the asset is missing, so screens
      // don't crash while assets are still being added.
      errorBuilder: (context, error, stackTrace) => Text(
        'MOTOVA',
        style: TextStyle(
          fontSize: width / 6,
          fontWeight: FontWeight.w700,
          letterSpacing: 4,
          color: variant == MotovaLogoVariant.dark ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}