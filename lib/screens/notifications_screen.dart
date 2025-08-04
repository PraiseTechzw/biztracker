import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/glassmorphism_theme.dart';
import '../utils/formatters.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType { info, warning, success, error }

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    // Sample notifications - in a real app, these would come from a service
    notifications = [
      NotificationItem(
        id: '1',
        title: 'Low Stock Alert',
        message:
            'Product "Laptop" is running low on stock. Current quantity: 5',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.warning,
      ),
      NotificationItem(
        id: '2',
        title: 'High Sales Day',
        message: 'Congratulations! Today\'s sales exceeded \$1,000',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.success,
      ),
      NotificationItem(
        id: '3',
        title: 'Expense Reminder',
        message: 'Don\'t forget to record your monthly rent payment',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.info,
      ),
      NotificationItem(
        id: '4',
        title: 'Profit Milestone',
        message: 'Your business has reached \$10,000 in total profit!',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        type: NotificationType.success,
      ),
      NotificationItem(
        id: '5',
        title: 'System Update',
        message: 'BizTracker has been updated to version 1.0.1',
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        type: NotificationType.info,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [GlassmorphismTheme.backgroundColor, Color(0xFF1E293B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildNotificationsList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Notifications',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: _markAllAsRead,
            icon: const Icon(
              Icons.done_all,
              color: GlassmorphismTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    if (notifications.isEmpty) {
      return Center(
        child: GlassmorphismTheme.glassmorphismContainer(
          padding: const EdgeInsets.all(32),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_none,
                color: GlassmorphismTheme.textSecondaryColor,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'No notifications',
                style: TextStyle(
                  color: GlassmorphismTheme.textSecondaryColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'You\'re all caught up!',
                style: TextStyle(
                  color: GlassmorphismTheme.textSecondaryColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return GlassmorphismTheme.glassmorphismContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getNotificationColor(notification.type).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getNotificationIcon(notification.type),
              color: _getNotificationColor(notification.type),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          color: GlassmorphismTheme.textColor,
                          fontSize: 16,
                          fontWeight: notification.isRead
                              ? FontWeight.w500
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: GlassmorphismTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: TextStyle(
                    color: GlassmorphismTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  Formatters.getRelativeTime(notification.timestamp),
                  style: const TextStyle(
                    color: GlassmorphismTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: GlassmorphismTheme.textSecondaryColor,
            ),
            onSelected: (value) {
              if (value == 'mark_read') {
                _markAsRead(notification.id);
              } else if (value == 'delete') {
                _deleteNotification(notification.id);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_read',
                child: Text('Mark as read'),
              ),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return GlassmorphismTheme.accentColor;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.success:
        return Colors.green;
      case NotificationType.error:
        return Colors.red;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.warning:
        return Icons.warning_amber;
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.error:
        return Icons.error_outline;
    }
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = NotificationItem(
          id: notifications[index].id,
          title: notifications[index].title,
          message: notifications[index].message,
          timestamp: notifications[index].timestamp,
          type: notifications[index].type,
          isRead: true,
        );
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      notifications = notifications
          .map(
            (notification) => NotificationItem(
              id: notification.id,
              title: notification.title,
              message: notification.message,
              timestamp: notification.timestamp,
              type: notification.type,
              isRead: true,
            ),
          )
          .toList();
    });
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      notifications.removeWhere((n) => n.id == notificationId);
    });
  }
}
