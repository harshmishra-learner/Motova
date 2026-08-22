import 'package:go_router/go_router.dart';

import 'app_shell.dart';
import '../features/auth/models/otp_purpose.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/otp_screen.dart';
import '../features/auth/presentation/verification_success_screen.dart';
import '../features/auth/presentation/change_password_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/vehicles/presentation/vehicles_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/edit_profile_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';
  static const String verificationSuccess = '/verification-success';
  static const String changePassword = '/change-password';

  // Bottom nav shell tabs
  static const String home = '/home';
  static const String search = '/search';
  static const String vehicles = '/vehicles';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  // Pushed outside the shell (no bottom nav)
  static const String editProfile = '/edit-profile';
}

/// Data passed from Forgot Password to the OTP screen.
class OtpRouteData {
  const OtpRouteData({
    required this.purpose,
    required this.email,
  });

  final OtpPurpose purpose;
  final String email;
}

/// Data passed from OTP verification to Verification Success.
class VerificationRouteData {
  const VerificationRouteData({
    required this.purpose,
    required this.resetToken,
  });

  final OtpPurpose purpose;
  final String resetToken;
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  routes: [
    // ============================================================
    // AUTH FLOW
    // ============================================================

    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),

    // ------------------------------------------------------------
    // Forgot Password
    // ------------------------------------------------------------

    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // ------------------------------------------------------------
    // OTP
    // ------------------------------------------------------------

    GoRoute(
      path: AppRoutes.otp,
      builder: (context, state) {
        final extra = state.extra;

        if (extra is OtpRouteData) {
          return OtpScreen(
            purpose: extra.purpose,
            email: extra.email,
          );
        }

        // Safe fallback.
        return const OtpScreen(
          purpose: OtpPurpose.passwordReset,
          email: '',
        );
      },
    ),

    // ------------------------------------------------------------
    // Verification Success
    // ------------------------------------------------------------

    GoRoute(
      path: AppRoutes.verificationSuccess,
      builder: (context, state) {
        final extra = state.extra;

        if (extra is VerificationRouteData) {
          return VerificationSuccessScreen(
            purpose: extra.purpose,
            resetToken: extra.resetToken,
          );
        }

        // Safe fallback.
        return const VerificationSuccessScreen(
          purpose: OtpPurpose.passwordReset,
          resetToken: '',
        );
      },
    ),

    // ------------------------------------------------------------
    // Change Password
    // ------------------------------------------------------------

    GoRoute(
      path: AppRoutes.changePassword,
      builder: (context, state) {
        final resetToken = state.extra is String
            ? state.extra as String
            : '';

        return ChangePasswordScreen(
          resetToken: resetToken,
        );
      },
    ),

    // ============================================================
    // EDIT PROFILE
    // ============================================================

    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => const EditProfileScreen(),
    ),

    // ============================================================
    // MAIN APP SHELL
    // ============================================================

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShellScreen(
          navigationShell: navigationShell,
        );
      },
      branches: [
        // --------------------------------------------------------
        // Home
        // --------------------------------------------------------

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // --------------------------------------------------------
        // Search
        // --------------------------------------------------------

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),

        // --------------------------------------------------------
        // Vehicles
        // --------------------------------------------------------

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.vehicles,
              builder: (context, state) => const VehiclesScreen(),
            ),
          ],
        ),

        // --------------------------------------------------------
        // Notifications
        // --------------------------------------------------------

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.notifications,
              builder: (context, state) {
                return const NotificationsScreen();
              },
            ),
          ],
        ),

        // --------------------------------------------------------
        // Profile
        // --------------------------------------------------------

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);