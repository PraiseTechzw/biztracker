import 'package:flutter/material.dart';
import '../utils/glassmorphism_theme.dart';
import '../utils/formatters.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      isLoading = true;
    });

    try {
      final notificationService = NotificationService();
      final allNotifications = notificationService.getAllNotifications();

      setState(() {
        notifications = allNotifications;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Error loading notifications silently handled
    }
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
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: GlassmorphismTheme.textColor,
            ),
          ),
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
          if (notifications.isNotEmpty)
            IconButton(
              onPressed: _markAllAsRead,
              icon: const Icon(
                Icons.done_all,
                color: GlassmorphismTheme.textColor,
              ),
              tooltip: 'Mark all as read',
            ),
          if (notifications.isNotEmpty)
            IconButton(
              onPressed: _clearAllNotifications,
              icon: const Icon(
                Icons.clear_all,
                color: GlassmorphismTheme.textColor,
              ),
              tooltip: 'Clear all notifications',
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: GlassmorphismTheme.primaryColor,
        ),
      );
    }

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

    return RefreshIndicator(
      onRefresh: () async {
        _loadNotifications();
      },
      color: GlassmorphismTheme.primaryColor,
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
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
              if (!notification.isRead)
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
      case NotificationType.sale:
        return Colors.green;
      case NotificationType.stock:
        return Colors.orange;
      case NotificationType.expense:
        return Colors.red;
      case NotificationType.achievement:
        return Colors.purple;
      case NotificationType.reminder:
        return Colors.blue;
      case NotificationType.goal:
        return Colors.indigo;
      case NotificationType.challenge:
        return Colors.purple;
      case NotificationType.milestone:
        return Colors.amber;
      case NotificationType.prediction:
        return Colors.teal;
      case NotificationType.insight:
        return Colors.cyan;
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
      case NotificationType.sale:
        return Icons.shopping_cart;
      case NotificationType.stock:
        return Icons.inventory;
      case NotificationType.expense:
        return Icons.receipt;
      case NotificationType.achievement:
        return Icons.emoji_events;
      case NotificationType.reminder:
        return Icons.schedule;
      case NotificationType.goal:
        return Icons.flag;
      case NotificationType.challenge:
        return Icons.sports_esports;
      case NotificationType.milestone:
        return Icons.star;
      case NotificationType.prediction:
        return Icons.trending_up;
      case NotificationType.insight:
        return Icons.lightbulb;
    }
  }

  void _markAsRead(String notificationId) {
    final notificationService = NotificationService();
    notificationService.markAsRead(notificationId);
    _loadNotifications(); // Reload to update UI
  }

  void _markAllAsRead() {
    final notificationService = NotificationService();
    notificationService.markAllAsRead();
    _loadNotifications(); // Reload to update UI
  }

  void _deleteNotification(String notificationId) {
    final notificationService = NotificationService();
    notificationService.deleteNotification(notificationId);
    _loadNotifications(); // Reload to update UI
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: GlassmorphismTheme.surfaceColor,
          title: const Text(
            'Clear All Notifications',
            style: TextStyle(color: GlassmorphismTheme.textColor),
          ),
          content: const Text(
            'Are you sure you want to clear all notifications? This action cannot be undone.',
            style: TextStyle(color: GlassmorphismTheme.textSecondaryColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: GlassmorphismTheme.textSecondaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                final notificationService = NotificationService();
                notificationService.clearAllNotifications();
                _loadNotifications(); // Reload to update UI
                Navigator.of(context).pop();
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
