import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/business_data.dart';
import 'database_service.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? payload;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.payload,
  });
}

enum NotificationType {
  info,
  warning,
  success,
  error,
  sale,
  stock,
  expense,
  achievement,
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // In-memory storage for notifications (in a real app, you'd use a database)
  final List<NotificationItem> _notificationsList = [];

  // Notification channels
  static const String _salesChannelId = 'sales_notifications';
  static const String _stockChannelId = 'stock_notifications';
  static const String _expenseChannelId = 'expense_notifications';
  static const String _achievementChannelId = 'achievement_notifications';
  static const String _reminderChannelId = 'reminder_notifications';

  Future<void> initialize() async {
    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // Combined initialization settings
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize the plugin
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels
    await _createNotificationChannels();

    // Load initial notifications from business data
    await _loadInitialNotifications();
  }

  Future<void> _loadInitialNotifications() async {
    try {
      // Load recent sales (last 7 days)
      final sales = await DatabaseService.getAllSales();
      final recentSales = sales
          .where(
            (sale) => sale.saleDate.isAfter(
              DateTime.now().subtract(const Duration(days: 7)),
            ),
          )
          .toList();

      for (final sale in recentSales.take(5)) {
        _addNotification(
          NotificationItem(
            id: 'sale_${sale.id}',
            title: '💰 Sale Recorded',
            message:
                '${sale.productName} sold to ${sale.customerName} for \$${sale.totalAmount.toStringAsFixed(2)}',
            timestamp: sale.saleDate,
            type: NotificationType.sale,
            payload: 'sale_${sale.id}',
          ),
        );
      }

      // Load low stock items
      final stocks = await DatabaseService.getAllStocks();
      final lowStockItems = stocks
          .where((stock) => stock.quantity <= stock.reorderLevel)
          .toList();

      for (final stock in lowStockItems) {
        _addNotification(
          NotificationItem(
            id: 'stock_${stock.id}',
            title: stock.quantity <= 0
                ? '🚨 Out of Stock!'
                : '⚠️ Low Stock Alert',
            message: stock.quantity <= 0
                ? '${stock.name} is completely out of stock. Please restock immediately.'
                : '${stock.name} is running low (${stock.quantity} units left). Reorder level: ${stock.reorderLevel}',
            timestamp: stock.updatedAt,
            type: NotificationType.stock,
            payload: 'stock_${stock.id}',
          ),
        );
      }

      // Load recent expenses (last 7 days)
      final expenses = await DatabaseService.getAllExpenses();
      final recentExpenses = expenses
          .where(
            (expense) => expense.expenseDate.isAfter(
              DateTime.now().subtract(const Duration(days: 7)),
            ),
          )
          .toList();

      for (final expense in recentExpenses.take(5)) {
        _addNotification(
          NotificationItem(
            id: 'expense_${expense.id}',
            title: '💸 Expense Recorded',
            message:
                '${expense.category}: ${expense.description} - \$${expense.amount.toStringAsFixed(2)}',
            timestamp: expense.expenseDate,
            type: NotificationType.expense,
            payload: 'expense_${expense.id}',
          ),
        );
      }

      // Check for achievements
      final totalSales = sales.fold<double>(
        0,
        (sum, sale) => sum + sale.totalAmount,
      );
      final totalExpenses = expenses.fold<double>(
        0,
        (sum, expense) => sum + expense.amount,
      );
      final netProfit = totalSales - totalExpenses;

      if (totalSales >= 1000 && totalSales < 5000) {
        _addNotification(
          NotificationItem(
            id: 'achievement_sales_1k',
            title: '🎉 Sales Milestone!',
            message: 'Congratulations! You\'ve reached \$1,000 in total sales!',
            timestamp: DateTime.now(),
            type: NotificationType.achievement,
            payload: 'achievement_sales_1k',
          ),
        );
      }

      if (netProfit >= 1000 && netProfit < 5000) {
        _addNotification(
          NotificationItem(
            id: 'achievement_profit_1k',
            title: '🎊 Profit Milestone!',
            message:
                'Congratulations! You\'ve reached \$1,000 in total profit!',
            timestamp: DateTime.now(),
            type: NotificationType.achievement,
            payload: 'achievement_profit_1k',
          ),
        );
      }
    } catch (e) {
      print('Error loading initial notifications: $e');
    }
  }

  void _addNotification(NotificationItem notification) {
    // Check if notification already exists
    final existingIndex = _notificationsList.indexWhere(
      (n) => n.id == notification.id,
    );
    if (existingIndex == -1) {
      _notificationsList.add(notification);
    }
  }

  Future<void> _createNotificationChannels() async {
    // Sales notifications channel
    const AndroidNotificationChannel salesChannel = AndroidNotificationChannel(
      _salesChannelId,
      'Sales Notifications',
      description: 'Notifications for sales activities',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    // Stock notifications channel
    const AndroidNotificationChannel stockChannel = AndroidNotificationChannel(
      _stockChannelId,
      'Stock Notifications',
      description: 'Notifications for stock updates and alerts',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    // Expense notifications channel
    const AndroidNotificationChannel expenseChannel =
        AndroidNotificationChannel(
          _expenseChannelId,
          'Expense Notifications',
          description: 'Notifications for expense tracking',
          importance: Importance.defaultImportance,
          playSound: true,
          enableVibration: true,
        );

    // Achievement notifications channel
    const AndroidNotificationChannel achievementChannel =
        AndroidNotificationChannel(
          _achievementChannelId,
          'Achievement Notifications',
          description: 'Notifications for business achievements',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        );

    // Reminder notifications channel
    const AndroidNotificationChannel reminderChannel =
        AndroidNotificationChannel(
          _reminderChannelId,
          'Reminder Notifications',
          description: 'Notifications for business reminders',
          importance: Importance.defaultImportance,
          playSound: true,
          enableVibration: true,
        );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(salesChannel);

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(stockChannel);

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(expenseChannel);

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(achievementChannel);

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(reminderChannel);
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - you can navigate to specific screens here
    print('Notification tapped: ${response.payload}');
  }

  // Sales notifications
  Future<void> showSaleNotification(Sale sale) async {
    final notification = NotificationItem(
      id: 'sale_${sale.id}',
      title: '💰 Sale Recorded!',
      message:
          '${sale.productName} sold to ${sale.customerName} for \$${sale.totalAmount.toStringAsFixed(2)}',
      timestamp: DateTime.now(),
      type: NotificationType.sale,
      payload: 'sale_${sale.id}',
    );

    _addNotification(notification);

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification.title,
      notification.message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _salesChannelId,
          'Sales Notifications',
          channelDescription: 'Notifications for sales activities',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF4CAF50),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: notification.payload,
    );
  }

  // Low stock notifications
  Future<void> showLowStockNotification(Stock stock) async {
    final notification = NotificationItem(
      id: 'stock_${stock.id}',
      title: stock.quantity <= 0 ? '🚨 Out of Stock!' : '⚠️ Low Stock Alert',
      message: stock.quantity <= 0
          ? '${stock.name} is completely out of stock. Please restock immediately.'
          : '${stock.name} is running low (${stock.quantity} units left). Reorder level: ${stock.reorderLevel}',
      timestamp: DateTime.now(),
      type: NotificationType.stock,
      payload: 'stock_${stock.id}',
    );

    _addNotification(notification);

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification.title,
      notification.message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _stockChannelId,
          'Stock Notifications',
          channelDescription: 'Notifications for stock updates and alerts',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFFFF9800),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: notification.payload,
    );
  }

  // Out of stock notifications
  Future<void> showOutOfStockNotification(Stock stock) async {
    final notification = NotificationItem(
      id: 'stock_${stock.id}',
      title: '🚨 Out of Stock!',
      message:
          '${stock.name} is completely out of stock. Please restock immediately.',
      timestamp: DateTime.now(),
      type: NotificationType.stock,
      payload: 'stock_${stock.id}',
    );

    _addNotification(notification);

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification.title,
      notification.message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _stockChannelId,
          'Stock Notifications',
          channelDescription: 'Notifications for stock updates and alerts',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFFF44336),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: notification.payload,
    );
  }

  // Expense notifications
  Future<void> showExpenseNotification(Expense expense) async {
    final notification = NotificationItem(
      id: 'expense_${expense.id}',
      title: '💸 Expense Recorded',
      message:
          '${expense.category}: ${expense.description} - \$${expense.amount.toStringAsFixed(2)}',
      timestamp: DateTime.now(),
      type: NotificationType.expense,
      payload: 'expense_${expense.id}',
    );

    _addNotification(notification);

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification.title,
      notification.message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _expenseChannelId,
          'Expense Notifications',
          channelDescription: 'Notifications for expense tracking',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFFE91E63),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: notification.payload,
    );
  }

  // Achievement notifications
  Future<void> showAchievementNotification(String title, String message) async {
    final notification = NotificationItem(
      id: 'achievement_${DateTime.now().millisecondsSinceEpoch}',
      title: '🎉 $title',
      message: message,
      timestamp: DateTime.now(),
      type: NotificationType.achievement,
      payload: 'achievement',
    );

    _addNotification(notification);

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification.title,
      notification.message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _achievementChannelId,
          'Achievement Notifications',
          channelDescription: 'Notifications for business achievements',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF9C27B0),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: notification.payload,
    );
  }

  // Daily summary notification
  Future<void> showDailySummaryNotification() async {
    final today = DateTime.now();
    final sales = await DatabaseService.getAllSales();
    final expenses = await DatabaseService.getAllExpenses();

    // Filter for today's data
    final todaySales = sales
        .where(
          (sale) =>
              sale.saleDate.year == today.year &&
              sale.saleDate.month == today.month &&
              sale.saleDate.day == today.day,
        )
        .toList();

    final todayExpenses = expenses
        .where(
          (expense) =>
              expense.expenseDate.year == today.year &&
              expense.expenseDate.month == today.month &&
              expense.expenseDate.day == today.day,
        )
        .toList();

    final totalSales = todaySales.fold<double>(
      0,
      (sum, sale) => sum + sale.totalAmount,
    );
    final totalExpenses = todayExpenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );
    final netProfit = totalSales - totalExpenses;

    final notification = NotificationItem(
      id: 'daily_summary_${today.millisecondsSinceEpoch}',
      title: '📊 Daily Summary',
      message:
          'Sales: \$${totalSales.toStringAsFixed(2)} | Expenses: \$${totalExpenses.toStringAsFixed(2)} | Net: \$${netProfit.toStringAsFixed(2)}',
      timestamp: DateTime.now(),
      type: NotificationType.info,
      payload: 'daily_summary',
    );

    _addNotification(notification);

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification.title,
      notification.message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _reminderChannelId,
          'Reminder Notifications',
          channelDescription: 'Notifications for business reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF2196F3),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: notification.payload,
    );
  }

  // Check for low stock and send notifications
  Future<void> checkLowStockNotifications() async {
    final stocks = await DatabaseService.getAllStocks();

    for (final stock in stocks) {
      if (stock.quantity <= 0) {
        await showOutOfStockNotification(stock);
      } else if (stock.quantity <= stock.reorderLevel) {
        await showLowStockNotification(stock);
      }
    }
  }

  // Get all notifications
  List<NotificationItem> getAllNotifications() {
    // Sort by timestamp (newest first)
    final sortedNotifications = List<NotificationItem>.from(_notificationsList);
    sortedNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sortedNotifications;
  }

  // Get unread notification count
  int getUnreadNotificationCount() {
    return _notificationsList
        .where((notification) => !notification.isRead)
        .length;
  }

  // Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notificationsList.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notificationsList[index] = NotificationItem(
        id: _notificationsList[index].id,
        title: _notificationsList[index].title,
        message: _notificationsList[index].message,
        timestamp: _notificationsList[index].timestamp,
        type: _notificationsList[index].type,
        isRead: true,
        payload: _notificationsList[index].payload,
      );
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    for (int i = 0; i < _notificationsList.length; i++) {
      _notificationsList[i] = NotificationItem(
        id: _notificationsList[i].id,
        title: _notificationsList[i].title,
        message: _notificationsList[i].message,
        timestamp: _notificationsList[i].timestamp,
        type: _notificationsList[i].type,
        isRead: true,
        payload: _notificationsList[i].payload,
      );
    }
  }

  // Delete notification
  void deleteNotification(String notificationId) {
    _notificationsList.removeWhere((n) => n.id == notificationId);
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    _notificationsList.clear();
    await _notifications.cancelAll();
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}
