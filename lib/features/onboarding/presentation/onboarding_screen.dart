import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/motova_logo.dart';
import '../../../shared/widgets/primary_button.dart';

/// Screen 1 — full-screen car background with:
/// - Manual swipe
/// - Automatic image sliding
/// - Page indicators
/// - Get Started CTA
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  Timer? _autoSlideTimer;

  int _currentPage = 0;

  // ============================================================
  // ONBOARDING IMAGES
  // ============================================================
  final List<String> _onboardingImages = [
    'assets/images/onboarding_car.png',
    'assets/images/onboarding_car2.png',
  ];

  // ============================================================
  // INIT
  // ============================================================
  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 0,
    );

    _scheduleAutoSlide();
  }

  // ============================================================
  // DISPOSE
  // ============================================================
  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();

    super.dispose();
  }

  // ============================================================
  // AUTO SLIDE
  // ============================================================
  void _scheduleAutoSlide() {
    _autoSlideTimer?.cancel();

    // No need for auto-slide if there is only one image.
    if (_onboardingImages.length <= 1) {
      return;
    }

    _autoSlideTimer = Timer(
      const Duration(seconds: 5),
      () {
        if (!mounted || !_pageController.hasClients) {
          return;
        }

        final int nextPage =
            (_currentPage + 1) % _onboardingImages.length;

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  // ============================================================
  // PAGE CHANGE
  // ============================================================
  void _onPageChanged(int index) {
    if (!mounted) return;

    setState(() {
      _currentPage = index;
    });

    // Reset the 5-second timer whenever the page changes.
    //
    // This handles both:
    // 1. Manual swipe
    // 2. Automatic slide
    _scheduleAutoSlide();
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ======================================================
          // 1. BACKGROUND PAGE VIEW
          // ======================================================
          //
          // This is the widget responsible for manual swiping.
          //
          PageView.builder(
            controller: _pageController,

            // Explicitly allow horizontal scrolling.
            physics: const PageScrollPhysics(),

            itemCount: _onboardingImages.length,

            onPageChanged: _onPageChanged,

            itemBuilder: (context, index) {
              return SizedBox.expand(
                child: Image.asset(
                  _onboardingImages[index],
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.primary,
                    );
                  },
                ),
              );
            },
          ),

          // ======================================================
          // 2. GRADIENT OVERLAY
          // ======================================================
          //
          // IgnorePointer is IMPORTANT.
          //
          // It makes the gradient visible but prevents it from
          // receiving touch gestures.
          //
          // Therefore the PageView underneath can receive swipes.
          //
          IgnorePointer(
            child: SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.onboardingOverlayStart,
                      AppColors.onboardingOverlayMid,
                      AppColors.onboardingOverlayStart,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ======================================================
          // 3. CONTENT
          // ======================================================
          //
          // IgnorePointer makes the text/logo area transparent
          // to gestures.
          //
          // IMPORTANT:
          // The Get Started button is added separately below,
          // so it remains clickable.
          //
          IgnorePointer(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenHorizontalPadding,
                ),
                child: Column(
                  children: [
                    // ------------------------------------------------
                    // LOGO
                    // ------------------------------------------------
                    const SizedBox(
                      height: AppDimensions.space70,
                    ),

                    const MotovaLogo(
                      variant: MotovaLogoVariant.light,
                      width: AppDimensions.logoWidthHero,
                    ),

                    const Spacer(),

                    // ------------------------------------------------
                    // HEADING
                    // ------------------------------------------------
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Lets Start...',
                        style: AppTextStyles.heroHeading,
                      ),
                    ),

                    const SizedBox(
                      height: AppDimensions.space20,
                    ),

                    // ------------------------------------------------
                    // DESCRIPTION
                    // ------------------------------------------------
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Discover your next adventure with Motova. "
                        "we're here to provide you with a seamless experience.",
                        style: AppTextStyles.bodyOnDark,
                      ),
                    ),

                    const SizedBox(
                      height: AppDimensions.space40,
                    ),

                    // ------------------------------------------------
                    // PAGE INDICATORS
                    // ------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingImages.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            child: _PageIndicatorDot(
                              active: _currentPage == index,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(
                      height: AppDimensions.space56,
                    ),

                    // Space reserved for the button.
                    //
                    // The actual button is placed separately
                    // outside IgnorePointer below.
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                    ),

                    const SizedBox(
                      height: AppDimensions.space40,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ======================================================
          // 4. GET STARTED BUTTON
          // ======================================================
          //
          // This stays OUTSIDE IgnorePointer so it can receive
          // taps.
          //
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenHorizontalPadding,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.space40,
                  ),
                  child: PrimaryButton(
                    text: 'Get Started',
                    onPressed: () {
                      context.push(AppRoutes.login);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// PAGE INDICATOR
// ================================================================

class _PageIndicatorDot extends StatelessWidget {
  final bool active;

  const _PageIndicatorDot({
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 42 : 12,
      height: 12,
      decoration: BoxDecoration(
        color: AppColors.pageIndicatorActive,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}