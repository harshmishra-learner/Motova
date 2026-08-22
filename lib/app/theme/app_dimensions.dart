/// Consistent spacing, radius, and sizing tokens.
/// Keeping these centralized means every new screen automatically
/// matches the wireframe's spacing rhythm without eyeballing it each time.
class AppDimensions {
  AppDimensions._();

  // Spacing scale
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;
  static const double space56 = 56;
  static const double space70 = 70;

  // Screen padding
  static const double screenHorizontalPadding = 24;

  // Radius
  static const double radiusInput = 18;
  static const double radiusButton = 32; // full pill
  static const double radiusOtpBox = 16;
  static const double radiusCard = 24;

  // Component heights
  static const double buttonHeight = 60;
  static const double inputHeight = 60;
  static const double otpBoxSize = 64;
  static const double socialButtonHeight = 56;

  // Icon / logo
  static const double logoWidthDefault = 150;
  static const double logoWidthHero = 190;
  static const double backButtonSize = 44;
  // Bottom nav + notifications + profile
  static const double bottomNavHeight = 64;
  static const double iconCircleSize = 40;
  static const double avatarSizeLarge = 96;
  static const double avatarSizeMedium = 72;
}