import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';
import '../models/car_listing.dart';

/// Compact card for horizontal carousels (e.g. Home's "Popular Cars").
class PopularCarCard extends StatelessWidget {
  final CarListing car;
  final VoidCallback? onTap;

  const PopularCarCard({super.key, required this.car, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: Container(
        width: 190,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusCard),
                  ),
                  child: Image.asset(
                    car.imageAsset,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: AppColors.iconCircleBackground,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.directions_car_outlined,
                        size: 36,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: AppDimensions.space8,
                  right: AppDimensions.space8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB020)),
                        const SizedBox(width: 2),
                        Text(
                          car.rating.toStringAsFixed(1),
                          style: AppTextStyles.caption.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space12,
                AppDimensions.space12,
                AppDimensions.space12,
                AppDimensions.space12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${car.category.label} · ${car.seats} seats',
                    style: AppTextStyles.footerText.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\$${car.pricePerDay.toStringAsFixed(0)}',
                          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(text: '/day', style: AppTextStyles.footerText),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-width row tile — used for vertical listings (Home's
/// "Recommended for you" and Search results).
class CarListingTile extends StatelessWidget {
  final CarListing car;
  final VoidCallback? onTap;

  const CarListingTile({super.key, required this.car, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.space12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusOtpBox),
              child: Image.asset(
                car.imageAsset,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 88,
                  height: 88,
                  color: AppColors.iconCircleBackground,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.directions_car_outlined,
                    size: 28,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          car.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(Icons.star_rounded, size: 15, color: Color(0xFFFFB020)),
                      const SizedBox(width: 2),
                      Text(
                        car.rating.toStringAsFixed(1),
                        style: AppTextStyles.footerText.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _MiniTag(icon: Icons.event_seat_outlined, label: '${car.seats} seats'),
                      const SizedBox(width: AppDimensions.space8),
                      _MiniTag(icon: Icons.settings_outlined, label: car.transmission),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          car.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.footerText.copyWith(fontSize: 12),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '\$${car.pricePerDay.toStringAsFixed(0)}',
                              style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800),
                            ),
                            TextSpan(text: '/day', style: AppTextStyles.footerText.copyWith(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(label, style: AppTextStyles.footerText.copyWith(fontSize: 12)),
      ],
    );
  }
}
