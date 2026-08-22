import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/models/car_listing.dart';
import '../../../shared/widgets/car_listing_card.dart';
import '../../../shared/widgets/category_chip.dart';
import '../../auth/data/auth_storage.dart';
import '../../auth/models/auth_user.dart';

/// Screen — Home: greeting, quick search entry, category browsing,
/// a "Popular Cars" carousel and a "Recommended for you" list.
///
/// TODO: `kMockCarListings` (see shared/models/car_listing.dart) is mock
/// catalog data. Replace with a real CarRepository once a catalog/listing
/// endpoint exists on the backend — follow the `features/auth/data/`
/// pattern (ApiService -> Repository -> screen).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthStorage _authStorage = AuthStorage();

  CarCategory? _selectedCategory;
  AuthUser? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _authStorage.getUser();
    if (!mounted) return;
    setState(() => _currentUser = user);
  }

  void _selectCategory(CarCategory category) {
    setState(() {
      _selectedCategory = _selectedCategory == category ? null : category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final recommended = _selectedCategory == null
        ? kMockCarListings
        : kMockCarListings.where((car) => car.category == _selectedCategory).toList();

    // First name only, so the greeting doesn't wrap on small screens.
    final firstName = (_currentUser?.name ?? '').trim().split(' ').first;
    final greetingName = firstName.isEmpty ? 'there' : firstName;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.screenHorizontalPadding,
            AppDimensions.space16,
            AppDimensions.screenHorizontalPadding,
            AppDimensions.space32,
          ),
          children: [
            // --------------------------------------------------------
            // Header — greeting + avatar
            // --------------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hey, $greetingName 👋',
                        style: AppTextStyles.sectionTitle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ready for your next ride?',
                        style: AppTextStyles.footerText,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => context.go(AppRoutes.profile),
                  borderRadius: BorderRadius.circular(AppDimensions.avatarSizeMedium),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.iconCircleBackground,
                    ),
                    child: const Icon(Icons.person, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.space24),

            // --------------------------------------------------------
            // Quick search entry — hands off to the Search tab.
            // --------------------------------------------------------
            InkWell(
              onTap: () => context.go(AppRoutes.search),
              borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
              child: Container(
                height: AppDimensions.inputHeight,
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space20),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.textSecondary),
                    const SizedBox(width: AppDimensions.space12),
                    Text('Search cars, brands...', style: AppTextStyles.hint),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.space24),

            // --------------------------------------------------------
            // Category chips
            // --------------------------------------------------------
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: CarCategory.values.length,
                separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.space8),
                itemBuilder: (context, index) {
                  final category = CarCategory.values[index];
                  return CategoryChip(
                    label: category.label,
                    isSelected: _selectedCategory == category,
                    onTap: () => _selectCategory(category),
                  );
                },
              ),
            ),

            const SizedBox(height: AppDimensions.space32),

            // --------------------------------------------------------
            // Popular cars — horizontal carousel
            // --------------------------------------------------------
            _SectionHeader(
              title: 'Popular Cars',
              onSeeAll: () => context.go(AppRoutes.search),
            ),
            const SizedBox(height: AppDimensions.space16),
            SizedBox(
              height: 232,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: kMockCarListings.length,
                separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.space12),
                itemBuilder: (context, index) {
                  final car = kMockCarListings[index];
                  return PopularCarCard(
                    car: car,
                    onTap: () => _showComingSoon(context, car.name),
                  );
                },
              ),
            ),

            const SizedBox(height: AppDimensions.space32),

            // --------------------------------------------------------
            // Promo banner
            // --------------------------------------------------------
            const _PromoBanner(),

            const SizedBox(height: AppDimensions.space32),

            // --------------------------------------------------------
            // Recommended for you — vertical list
            // --------------------------------------------------------
            _SectionHeader(title: 'Recommended for you'),
            const SizedBox(height: AppDimensions.space16),

            if (recommended.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.space32),
                child: Center(
                  child: Text(
                    'No cars in this category yet.',
                    style: AppTextStyles.body,
                  ),
                ),
              )
            else
              for (final car in recommended) ...[
                CarListingTile(
                  car: car,
                  onTap: () => _showComingSoon(context, car.name),
                ),
                const SizedBox(height: AppDimensions.space12),
              ],
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String carName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$carName details — coming soon')),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.sectionTitle.copyWith(fontSize: 18)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text('See all', style: AppTextStyles.footerLink.copyWith(fontSize: 13)),
          ),
      ],
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.space24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get 20% off your\nfirst ride',
                  style: AppTextStyles.button.copyWith(fontSize: 18, height: 1.3),
                ),
                const SizedBox(height: AppDimensions.space8),
                Text(
                  'Use code MOTOVA20 at checkout',
                  style: AppTextStyles.bodyOnDark.copyWith(
                    fontSize: 13,
                    color: AppColors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_offer_outlined, color: AppColors.white, size: 26),
          ),
        ],
      ),
    );
  }
}
