import 'package:flutter/material.dart';

enum NotificationSection { today, previous }

/// A single notification entry.
/// TODO(Day 16): replace mock data with real API-backed model/repository.
class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String timestamp;
  final IconData icon;
  final bool isUnread;
  final NotificationSection section;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.icon,
    required this.section,
    this.isUnread = false,
  });
}