import 'package:flutter/material.dart';

/// Central color palette for the Motova app.
/// Derived from the wireframes: dark CTA (#20232A), light bg (#F8F8F8).
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFFF8F8F8);
  static const Color onboardingOverlayStart = Color(0xB3000000); // 70% black
  static const Color onboardingOverlayMid = Color(0x26000000); // 15% black

  // Brand / CTA
  static const Color primary = Color(0xFF20232A); // dark pill buttons
  static const Color primaryPressed = Color(0xFF15171C);

  // Neutrals
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF858585);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color linkAccent = Color(0xFF111111); // "Sign Up." / "Login." bold part

  // Inputs
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE1E1E1);
  static const Color borderFocused = Color(0xFF20232A);

  // Social buttons
  static const Color socialButtonBackground = Color(0xFFEDEDED);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color successSurface = Color(0xFFBBF2D0);
  static const Color error = Color(0xFFE53935);

  // Misc
  static const Color pageIndicatorActive = Color(0xFFFFFFFF);
  static const Color pageIndicatorInactive = Color(0x80FFFFFF); // 50% white
  static const Color checkboxFill = Color(0xFF20232A);
   // Notifications
  static const Color unreadDot = Color(0xFF2F80ED);
  static const Color iconCircleBackground = Color(0xFFF0F0F0);
  static const Color modalScrim = Color(0x99000000);
}