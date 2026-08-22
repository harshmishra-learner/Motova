import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/models/car_listing.dart';
import '../../../shared/widgets/car_listing_card.dart';
import '../../../shared/widgets/category_chip.dart';

/// Screen — Search: a live text search over the car catalog, combined
/// with the same category filter chips used on Home.
///
/// TODO: `kMockCarListings` (see shared/models/car_listing.dart) is mock
/// catalog data. Once a real search/catalog endpoint exists on the
/// backend, replace the in-memory `where(...)` filtering below with a
/// debounced call through a `CarRepository`, following the
/// `features/auth/data/` pattern.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  CarCategory? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectCategory(CarCategory category) {
    setState(() {
      _selectedCategory = _selectedCategory == category ? null : category;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final results = kMockCarListings.where((car) {
      final matchesQuery = _query.isEmpty ||
          car.name.toLowerCase().contains(_query.toLowerCase()) ||
          car.category.label.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _selectedCategory == null || car.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    final hasActiveFilters = _query.isNotEmpty || _selectedCategory != null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenHorizontalPadding,
                AppDimensions.space16,
                AppDimensions.screenHorizontalPadding,
                AppDimensions.space16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Search', style: AppTextStyles.sectionTitle.copyWith(fontSize: 24)),
                  const SizedBox(height: AppDimensions.space16),

                  // ----------------------------------------------------
                  // Search field
                  // ----------------------------------------------------
                  TextField(
                    controller: _searchController,
                    style: AppTextStyles.input,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: 'Search cars, brands...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close, color: AppColors.textSecondary),
                              onPressed: _clearSearch,
                            ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space16),

                  // ----------------------------------------------------
                  // Category chips
                  // ----------------------------------------------------
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: CarCategory.values.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: AppDimensions.space8),
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
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.border),

            // --------------------------------------------------------
            // Results
            // --------------------------------------------------------
            Expanded(
              child: results.isEmpty
                  ? _NoResultsState(hasActiveFilters: hasActiveFilters)
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.screenHorizontalPadding,
                        AppDimensions.space16,
                        AppDimensions.screenHorizontalPadding,
                        AppDimensions.space32,
                      ),
                      children: [
                        Text(
                          '${results.length} ${results.length == 1 ? 'car' : 'cars'} found',
                          style: AppTextStyles.footerText,
                        ),
                        const SizedBox(height: AppDimensions.space16),
                        for (final car in results) ...[
                          CarListingTile(
                            car: car,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${car.name} details — coming soon')),
                              );
                            },
                          ),
                          const SizedBox(height: AppDimensions.space12),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResultsState extends StatelessWidget {
  final bool hasActiveFilters;

  const _NoResultsState({required this.hasActiveFilters});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenHorizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.iconCircleBackground,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              hasActiveFilters ? 'No matches found' : 'Start exploring',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: AppDimensions.space12),
            Text(
              hasActiveFilters
                  ? 'Try a different search term or clear the selected category.'
                  : 'Search by car name or filter by category to get started.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
