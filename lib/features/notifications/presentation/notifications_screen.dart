import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/delete_confirmation_dialog.dart';
import '../../../shared/widgets/notification_list_item.dart';
import '../../../shared/widgets/overflow_menu_button.dart';
import '../models/notification_item.dart';

/// TODO(Day 16): replace mock data with real API-backed data.
final List<NotificationItem> _mockNotifications = [
  NotificationItem(
    id: '1',
    title: 'Booking Successful',
    description: 'Your car is ready! Check your email for the booking and pickup instructions.',
    timestamp: '10:00 am',
    icon: Icons.verified_outlined,
    section: NotificationSection.today,
    isUnread: true,
  ),
  NotificationItem(
    id: '2',
    title: 'Payment Notification',
    description: 'Your payment has been received and your booking is confirmed.',
    timestamp: '10:00 am',
    icon: Icons.receipt_long_outlined,
    section: NotificationSection.today,
    isUnread: true,
  ),
  NotificationItem(
    id: '3',
    title: 'Car Pickup time',
    description: 'Your scheduled car pickup time is approaching. Please be on time.',
    timestamp: '09:00 am',
    icon: Icons.access_time_outlined,
    section: NotificationSection.today,
  ),
  NotificationItem(
    id: '4',
    title: 'Cancellation Notice',
    description: 'Your reservation has been canceled or booking cancelled successfully.',
    timestamp: 'Yesterday',
    icon: Icons.description_outlined,
    section: NotificationSection.previous,
  ),
  NotificationItem(
    id: '5',
    title: 'Discount Notification',
    description: "Congratulations! You've unlocked a 10% discount on your next rental.",
    timestamp: 'Yesterday',
    icon: Icons.local_offer_outlined,
    section: NotificationSection.previous,
  ),
];

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Mutable local copy so delete can actually remove items.
  late List<NotificationItem> _notifications = List.of(_mockNotifications);

  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  void _enterSelectionMode() {
    setState(() => _isSelectionMode = true);
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedIds.clear();
    });
  }

  void _toggleItemSelected(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      final allSelected = _selectedIds.length == _notifications.length;
      if (allSelected) {
        _selectedIds.clear();
      } else {
        _selectedIds
          ..clear()
          ..addAll(_notifications.map((n) => n.id));
      }
    });
  }

  Future<void> _handleDeleteTap() async {
    if (_selectedIds.isEmpty) return;

    final confirmed = await showDeleteConfirmationDialog(context);
    if (confirmed != true) return;
    if (!mounted) return;

    setState(() {
      _notifications.removeWhere((n) => _selectedIds.contains(n.id));
      _isSelectionMode = false;
      _selectedIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasNotifications = _notifications.isNotEmpty;
    final unreadCount = _notifications.where((n) => n.isUnread).length;
    final todayItems =
        _notifications.where((n) => n.section == NotificationSection.today).toList();
    final previousItems =
        _notifications.where((n) => n.section == NotificationSection.previous).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            width: AppDimensions.backButtonSize,
            height: AppDimensions.backButtonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 16),
          ),
          onPressed: () {
            // In selection mode, back exits selection instead of the screen.
            if (_isSelectionMode) {
              _exitSelectionMode();
              return;
            }
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
          },
        ),
        title: const Text('Notification'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.space16),
            child: OverflowMenuButton(
              items: hasNotifications
                  ? [
                      _isSelectionMode
                          ? OverflowMenuItem(
                              label: 'Cancel selection',
                              onTap: _exitSelectionMode,
                            )
                          : OverflowMenuItem(
                              label: 'Select',
                              onTap: _enterSelectionMode,
                            ),
                    ]
                  : null,
            ),
          ),
        ],
      ),
      body: hasNotifications
          ? Column(
              children: [
                if (_isSelectionMode)
                  _SelectionBar(
                    allSelected: _selectedIds.length == _notifications.length,
                    selectedCount: _selectedIds.length,
                    onToggleAll: _toggleSelectAll,
                    onDelete: _handleDeleteTap,
                  ),
                Expanded(
                  child: _NotificationsList(
                    todayItems: todayItems,
                    previousItems: previousItems,
                    unreadCount: unreadCount,
                    isSelectionMode: _isSelectionMode,
                    selectedIds: _selectedIds,
                    onItemTap: _isSelectionMode ? _toggleItemSelected : null,
                  ),
                ),
              ],
            )
          : const _EmptyState(),
    );
  }
}

class _SelectionBar extends StatelessWidget {
  final bool allSelected;
  final int selectedCount;
  final VoidCallback onToggleAll;
  final VoidCallback onDelete;

  const _SelectionBar({
    required this.allSelected,
    required this.selectedCount,
    required this.onToggleAll,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontalPadding,
            vertical: AppDimensions.space12,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: onToggleAll,
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: allSelected ? AppColors.primary : Colors.transparent,
                        border: allSelected ? null : Border.all(color: AppColors.border),
                      ),
                      child: allSelected
                          ? const Icon(Icons.check, size: 14, color: AppColors.white)
                          : null,
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    const Text('All', style: AppTextStyles.caption),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.space16),
              Text('$selectedCount Selected', style: AppTextStyles.caption),
              const Spacer(),
              InkWell(
                onTap: selectedCount == 0 ? null : onDelete,
                child: Container(
                  width: AppDimensions.backButtonSize,
                  height: AppDimensions.backButtonSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: selectedCount == 0 ? AppColors.textSecondary : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.border),
      ],
    );
  }
}

class _NotificationsList extends StatelessWidget {
  final List<NotificationItem> todayItems;
  final List<NotificationItem> previousItems;
  final int unreadCount;
  final bool isSelectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String>? onItemTap;

  const _NotificationsList({
    required this.todayItems,
    required this.previousItems,
    required this.unreadCount,
    required this.isSelectionMode,
    required this.selectedIds,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimensions.space32),
      children: [
        if (todayItems.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.screenHorizontalPadding,
              AppDimensions.space16,
              AppDimensions.screenHorizontalPadding,
              AppDimensions.space8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Today', style: AppTextStyles.sectionTitle.copyWith(fontSize: 16)),
                if (!isSelectionMode && unreadCount > 0)
                  Text('$unreadCount Unread Notification', style: AppTextStyles.footerText),
              ],
            ),
          ),
          for (final item in todayItems) ...[
            NotificationListItem(
              item: item,
              isSelectionMode: isSelectionMode,
              isSelected: selectedIds.contains(item.id),
              onTap: onItemTap == null ? null : () => onItemTap!(item.id),
            ),
            const Divider(height: 1, color: AppColors.border),
          ],
        ],
        if (previousItems.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.screenHorizontalPadding,
              AppDimensions.space16,
              AppDimensions.screenHorizontalPadding,
              AppDimensions.space8,
            ),
            child: Text('Previous', style: AppTextStyles.sectionTitle.copyWith(fontSize: 16)),
          ),
          for (final item in previousItems) ...[
            NotificationListItem(
              item: item,
              isSelectionMode: isSelectionMode,
              isSelected: selectedIds.contains(item.id),
              onTap: onItemTap == null ? null : () => onItemTap!(item.id),
            ),
            const Divider(height: 1, color: AppColors.border),
          ],
        ],
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.iconCircleBackground,
                  ),
                  child: const Icon(
                    Icons.notifications_off_outlined,
                    size: 56,
                    color: AppColors.textSecondary,
                  ),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: const Text('0', style: AppTextStyles.caption),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              'NO NOTIFICATIONS',
              style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 1),
            ),
            const SizedBox(height: AppDimensions.space12),
            const Text(
              "Clutter Cleared. We'll Notify You When There Is Something New.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}