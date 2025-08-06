import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/business_data.dart';
import 'database_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

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
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '💰 Sale Recorded!',
      '${sale.productName} sold to ${sale.customerName} for \$${sale.totalAmount.toStringAsFixed(2)}',
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
      payload: 'sale_${sale.id}',
    );
  }

  // Low stock notifications
  Future<void> showLowStockNotification(Stock stock) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '⚠️ Low Stock Alert',
      '${stock.name} is running low (${stock.quantity} units left). Reorder level: ${stock.reorderLevel}',
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
      payload: 'stock_${stock.id}',
    );
  }

  // Out of stock notifications
  Future<void> showOutOfStockNotification(Stock stock) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '🚨 Out of Stock!',
      '${stock.name} is completely out of stock. Please restock immediately.',
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
      payload: 'stock_${stock.id}',
    );
  }

  // Expense notifications
  Future<void> showExpenseNotification(Expense expense) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '💸 Expense Recorded',
      '${expense.category}: ${expense.description} - \$${expense.amount.toStringAsFixed(2)}',
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
      payload: 'expense_${expense.id}',
    );
  }

  // Achievement notifications
  Future<void> showAchievementNotification(String title, String message) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '🎉 $title',
      message,
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
      payload: 'achievement',
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

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '📊 Daily Summary',
      'Sales: \$${totalSales.toStringAsFixed(2)} | Expenses: \$${totalExpenses.toStringAsFixed(2)} | Net: \$${netProfit.toStringAsFixed(2)}',
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
      payload: 'daily_summary',
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

  // Get unread notification count
  Future<int> getUnreadNotificationCount() async {
    final recentSales = await DatabaseService.getAllSales();
    final recentExpenses = await DatabaseService.getAllExpenses();
    final stocks = await DatabaseService.getAllStocks();

    int count = 0;

    // Count recent sales (last 24 hours)
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    count += recentSales
        .where((sale) => sale.saleDate.isAfter(yesterday))
        .length;

    // Count recent expenses (last 24 hours)
    count += recentExpenses
        .where((expense) => expense.expenseDate.isAfter(yesterday))
        .length;

    // Count low stock items
    count += stocks
        .where((stock) => stock.quantity <= stock.reorderLevel)
        .length;

    return count;
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}
