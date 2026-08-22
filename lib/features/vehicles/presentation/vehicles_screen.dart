import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/overflow_menu_button.dart';
import '../models/booking.dart';

/// Screen — Vehicles: the user's upcoming and past bookings.
///
/// TODO: `kMockBookings` (see features/vehicles/models/booking.dart) is
/// mock data. Replace with a real API-backed model/repository once a
/// bookings endpoint exists on the backend — follow the
/// `features/auth/data/` pattern.
class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  bool _showUpcoming = true;

  @override
  Widget build(BuildContext context) {
    final bookings = kMockBookings
        .where((b) => _showUpcoming
            ? b.status == BookingStatus.upcoming
            : b.status != BookingStatus.upcoming)
        .toList()
      ..sort((a, b) => _showUpcoming
          ? a.pickupDate.compareTo(b.pickupDate)
          : b.pickupDate.compareTo(a.pickupDate));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Vehicles'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppDimensions.space16),
            child: OverflowMenuButton(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontalPadding,
              vertical: AppDimensions.space12,
            ),
            child: _StatusToggle(
              showUpcoming: _showUpcoming,
              onChanged: (value) => setState(() => _showUpcoming = value),
            ),
          ),
          Expanded(
            child: bookings.isEmpty
                ? _EmptyBookingsState(showUpcoming: _showUpcoming)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenHorizontalPadding,
                      AppDimensions.space8,
                      AppDimensions.screenHorizontalPadding,
                      AppDimensions.space32,
                    ),
                    itemCount: bookings.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppDimensions.space12),
                    itemBuilder: (context, index) {
                      return _BookingCard(booking: bookings[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Segmented pill toggle between Upcoming / Completed bookings —
/// matches the app's dark-pill selection language used elsewhere
/// (e.g. the bottom nav bar, primary buttons).
class _StatusToggle extends StatelessWidget {
  final bool showUpcoming;
  final ValueChanged<bool> onChanged;

  const _StatusToggle({required this.showUpcoming, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.iconCircleBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
      ),
      child: Row(
        children: [
          Expanded(child: _ToggleSegment(
            label: 'Upcoming',
            isSelected: showUpcoming,
            onTap: () => onChanged(true),
          )),
          Expanded(child: _ToggleSegment(
            label: 'Completed',
            isSelected: !showUpcoming,
            onTap: () => onChanged(false),
          )),
        ],
      ),
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleSegment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.socialButton.copyWith(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;

  const _BookingCard({required this.booking});

  Color get _statusColor {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return const Color(0xFF2F80ED);
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.error;
    }
  }

  Color get _statusSurface {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return const Color(0xFFE8F1FD);
      case BookingStatus.completed:
        return AppColors.successSurface;
      case BookingStatus.cancelled:
        return const Color(0xFFFBE2E1);
    }
  }

  String get _formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final date = booking.pickupDate;
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking ${booking.bookingCode} details — coming soon')),
        );
      },
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
                booking.imageAsset,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.iconCircleBackground,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.directions_car_outlined,
                    size: 26,
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
                          booking.carName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusSurface,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                        ),
                        child: Text(
                          booking.status.label,
                          style: AppTextStyles.footerText.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(_formattedDate, style: AppTextStyles.footerText.copyWith(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          booking.pickupLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.footerText.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        booking.bookingCode,
                        style: AppTextStyles.footerText.copyWith(fontSize: 11),
                      ),
                      Text(
                        '\$${booking.totalPrice.toStringAsFixed(0)} total',
                        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800, fontSize: 13),
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

class _EmptyBookingsState extends StatelessWidget {
  final bool showUpcoming;

  const _EmptyBookingsState({required this.showUpcoming});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenHorizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.iconCircleBackground,
              ),
              child: Icon(
                showUpcoming ? Icons.directions_car_outlined : Icons.history,
                size: 56,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              showUpcoming ? 'NO UPCOMING BOOKINGS' : 'NO BOOKING HISTORY',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 18, letterSpacing: 1),
            ),
            const SizedBox(height: AppDimensions.space12),
            Text(
              showUpcoming
                  ? 'When you book a car, it will show up here.'
                  : 'Your completed rentals will appear here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
