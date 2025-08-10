import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/business_data.dart';
import 'database_service.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final NotificationPriority priority;
  final bool isRead;
  final String? payload;
  final Map<String, dynamic>? context;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.priority = NotificationPriority.normal,
    this.isRead = false,
    this.payload,
    this.context,
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
  reminder,
  goal,
  challenge,
  milestone,
  prediction,
  insight,
}

enum NotificationPriority { low, normal, high, urgent }

class SmartNotificationSchedule {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final List<int> daysOfWeek; // 1-7 (Monday-Sunday)
  final TimeOfDay time;
  final bool isActive;
  final Map<String, dynamic>? conditions;

  SmartNotificationSchedule({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.priority = NotificationPriority.normal,
    required this.daysOfWeek,
    required this.time,
    this.isActive = true,
    this.conditions,
  });
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // In-memory storage for notifications
  final List<NotificationItem> _notificationsList = [];
  final List<SmartNotificationSchedule> _schedules = [];

  // User preferences for notifications
  bool _notificationsEnabled = true;
  NotificationPriority _minimumPriority = NotificationPriority.low;
  List<NotificationType> _enabledTypes = NotificationType.values.toList();
  Map<String, TimeOfDay> _quietHours = {
    'start': const TimeOfDay(hour: 22, minute: 0),
    'end': const TimeOfDay(hour: 8, minute: 0),
  };

  // Notification channels
  static const String _salesChannelId = 'sales_notifications';
  static const String _stockChannelId = 'stock_notifications';
  static const String _expenseChannelId = 'expense_notifications';
  static const String _achievementChannelId = 'achievement_notifications';
  static const String _reminderChannelId = 'reminder_notifications';
  static const String _smartChannelId = 'smart_notifications';
  static const String _priorityChannelId = 'priority_notifications';

  // Getters
  List<NotificationItem> get notifications =>
      List.unmodifiable(_notificationsList);
  List<SmartNotificationSchedule> get schedules =>
      List.unmodifiable(_schedules);
  bool get notificationsEnabled => _notificationsEnabled;
  NotificationPriority get minimumPriority => _minimumPriority;
  List<NotificationType> get enabledTypes => List.unmodifiable(_enabledTypes);
  Map<String, TimeOfDay> get quietHours => Map.unmodifiable(_quietHours);

  Future<void> initialize() async {
    // Initialize timezone data
    tz.initializeTimeZones();

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

    // Request notification permissions
    await _requestPermissions();

    // Set up smart notification schedules
    await _setupSmartSchedules();

    // Set up periodic notifications
    await _setupPeriodicNotifications();

    // Start predictive notification analysis
    _startPredictiveAnalysis();
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
        await sendSmartNotification(
          title: '💰 Sale Recorded',
          message:
              '${sale.productName} sold to ${sale.customerName} for \$${sale.totalAmount.toStringAsFixed(2)}',
          type: NotificationType.sale,
          priority: NotificationPriority.high,
          context: {'sale_id': sale.id.toString()},
        );
      }

      // Load low stock items
      final stocks = await DatabaseService.getAllStocks();
      final lowStockItems = stocks
          .where((stock) => stock.quantity <= stock.reorderLevel)
          .toList();

      for (final stock in lowStockItems) {
        await sendSmartNotification(
          title: stock.quantity <= 0
              ? '🚨 Out of Stock!'
              : '⚠️ Low Stock Alert',
          message: stock.quantity <= 0
              ? '${stock.name} is completely out of stock. Please restock immediately.'
              : '${stock.name} is running low (${stock.quantity} units left). Reorder level: ${stock.reorderLevel}',
          type: NotificationType.stock,
          priority: NotificationPriority.high,
          context: {'stock_id': stock.id.toString()},
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
        await sendSmartNotification(
          title: '💸 Expense Recorded',
          message:
              '${expense.category}: ${expense.description} - \$${expense.amount.toStringAsFixed(2)}',
          type: NotificationType.expense,
          priority: NotificationPriority.normal,
          context: {'expense_id': expense.id.toString()},
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
        await sendSmartNotification(
          title: '🎉 Sales Milestone!',
          message: 'Congratulations! You\'ve reached \$1,000 in total sales!',
          type: NotificationType.achievement,
          priority: NotificationPriority.high,
        );
      }

      if (netProfit >= 1000 && netProfit < 5000) {
        await sendSmartNotification(
          title: '🎊 Profit Milestone!',
          message: 'Congratulations! You\'ve reached \$1,000 in total profit!',
          type: NotificationType.achievement,
          priority: NotificationPriority.high,
        );
      }
    } catch (e) {
      // Silent error handling for production
    }
  }

  Future<void> _createNotificationChannels() async {
    // Sales notifications channel
    const AndroidNotificationChannel salesChannel = AndroidNotificationChannel(
      _salesChannelId,
      'Sales Notifications',
      description: 'Notifications about sales and revenue',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    // Stock notifications channel
    const AndroidNotificationChannel stockChannel = AndroidNotificationChannel(
      _stockChannelId,
      'Stock Notifications',
      description: 'Notifications about inventory and stock levels',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    // Expense notifications channel
    const AndroidNotificationChannel expenseChannel =
        AndroidNotificationChannel(
          _expenseChannelId,
          'Expense Notifications',
          description: 'Notifications about expenses and costs',
          importance: Importance.defaultImportance,
          playSound: true,
          enableVibration: true,
        );

    // Achievement notifications channel
    const AndroidNotificationChannel achievementChannel =
        AndroidNotificationChannel(
          _achievementChannelId,
          'Achievement Notifications',
          description:
              'Notifications about business achievements and milestones',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        );

    // Reminder notifications channel
    const AndroidNotificationChannel reminderChannel =
        AndroidNotificationChannel(
          _reminderChannelId,
          'Reminder Notifications',
          description: 'Smart reminders and scheduled notifications',
          importance: Importance.defaultImportance,
          playSound: true,
          enableVibration: true,
        );

    // Smart notifications channel
    const AndroidNotificationChannel smartChannel = AndroidNotificationChannel(
      _smartChannelId,
      'Smart Notifications',
      description: 'AI-powered insights and predictions',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    // Priority notifications channel
    const AndroidNotificationChannel priorityChannel =
        AndroidNotificationChannel(
          _priorityChannelId,
          'Priority Notifications',
          description: 'High priority business alerts',
          importance: Importance.max,
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

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(smartChannel);

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(priorityChannel);
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigate to specific screens
    if (response.payload != null) {
      if (response.payload!.startsWith('sale_')) {
        // Navigate to sales screen
        // TODO: Implement navigation logic
      } else if (response.payload!.startsWith('stock_')) {
        // Navigate to stock screen
        // TODO: Implement navigation logic
      } else if (response.payload!.startsWith('expense_')) {
        // Navigate to expenses screen
        // TODO: Implement navigation logic
      } else if (response.payload!.startsWith('achievement')) {
        // Navigate to dashboard
        // TODO: Implement navigation logic
      } else if (response.payload!.startsWith('daily_summary')) {
        // Navigate to reports screen
        // TODO: Implement navigation logic
      }
    }
  }

  Future<void> _requestPermissions() async {
    // Request notification permissions for Android 13+
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  Future<void> _setupPeriodicNotifications() async {
    try {
      // Set up daily business summary notification
      await _scheduleDailySummary();

      // Set up weekly low stock check
      await _scheduleWeeklyStockCheck();
    } catch (e) {
      // Silent fallback for production
    }
  }

  Future<void> _scheduleDailySummary() async {
    try {
      // Schedule daily summary at 9 PM
      final now = DateTime.now();
      final scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        21,
        0,
      ); // 9 PM

      // If it's already past 9 PM today, schedule for tomorrow
      final targetDate = scheduledDate.isBefore(now)
          ? scheduledDate.add(const Duration(days: 1))
          : scheduledDate;

      // Convert to TZDateTime
      final tz.TZDateTime scheduledTZ = tz.TZDateTime.from(
        targetDate,
        tz.local,
      );

      await _notifications.zonedSchedule(
        1001, // Unique ID for daily summary
        '📊 Daily Business Summary',
        'Check your daily sales, expenses, and stock updates',
        scheduledTZ,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _reminderChannelId,
            'Reminder Notifications',
            channelDescription: 'Notifications for business reminders',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'daily_summary',
      );
    } catch (e) {
      // Silent fallback for production
    }
  }

  Future<void> _scheduleWeeklyStockCheck() async {
    try {
      // Schedule weekly stock check every Monday at 10 AM
      final now = DateTime.now();
      final daysUntilMonday = (DateTime.monday - now.weekday) % 7;
      final nextMonday = now.add(Duration(days: daysUntilMonday));
      final scheduledDate = DateTime(
        nextMonday.year,
        nextMonday.month,
        nextMonday.day,
        10,
        0,
      ); // 10 AM

      // Convert to TZDateTime
      final tz.TZDateTime scheduledTZ = tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      );

      await _notifications.zonedSchedule(
        1002, // Unique ID for weekly stock check
        '📦 Weekly Stock Review',
        'Review your inventory levels and reorder items if needed',
        scheduledTZ,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _stockChannelId,
            'Stock Notifications',
            channelDescription: 'Notifications for stock updates and alerts',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'weekly_stock_check',
      );
    } catch (e) {
      // Silent fallback for production
    }
  }

  // Smart Notification Methods
  Future<void> sendSmartNotification({
    required String title,
    required String message,
    required NotificationType type,
    NotificationPriority priority = NotificationPriority.normal,
    Map<String, dynamic>? context,
    String? payload,
  }) async {
    if (!_notificationsEnabled) return;
    if (!_enabledTypes.contains(type)) return;
    if (priority.index < _minimumPriority.index) return;
    if (_isInQuietHours()) return;

    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
      priority: priority,
      context: context,
      payload: payload,
    );

    _notificationsList.insert(0, notification);

    // Determine channel based on type and priority
    String channelId = _getChannelId(type, priority);

    // Create notification details
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        _getChannelName(type),
        channelDescription: _getChannelDescription(type),
        importance: _getImportance(priority),
        priority: _getPriority(priority),
        icon: _getNotificationIcon(type),
        color: _getNotificationColor(type),
        enableVibration: true,
        playSound: true,
        showWhen: true,
        when: DateTime.now().millisecondsSinceEpoch,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // Show notification
    await _notifications.show(
      notification.hashCode,
      title,
      message,
      notificationDetails,
      payload: payload,
    );
  }

  // Contextual Alerts
  Future<void> sendContextualAlert({
    required String title,
    required String message,
    required NotificationType type,
    required Map<String, dynamic> context,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    // Analyze context to determine if notification should be sent
    if (_shouldSendContextualAlert(context)) {
      await sendSmartNotification(
        title: title,
        message: message,
        type: type,
        priority: priority,
        context: context,
      );
    }
  }

  // Smart Reminders
  Future<void> scheduleSmartReminder({
    required String title,
    required String message,
    required DateTime scheduledTime,
    NotificationType type = NotificationType.reminder,
    NotificationPriority priority = NotificationPriority.normal,
    Map<String, dynamic>? conditions,
  }) async {
    final schedule = SmartNotificationSchedule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      priority: priority,
      daysOfWeek: [scheduledTime.weekday],
      time: TimeOfDay.fromDateTime(scheduledTime),
      conditions: conditions,
    );

    _schedules.add(schedule);
    await _activateSchedule(schedule);
  }

  // Predictive Notifications
  Future<void> sendPredictiveNotification({
    required String title,
    required String message,
    required NotificationType type,
    required double confidence,
    Map<String, dynamic>? predictionData,
  }) async {
    if (confidence > 0.7) {
      // Only send if confidence is high
      await sendSmartNotification(
        title: title,
        message: message,
        type: type,
        priority: NotificationPriority.high,
        context: {
          'prediction': true,
          'confidence': confidence,
          'data': predictionData,
        },
      );
    }
  }

  // Priority-based Alerts
  Future<void> sendPriorityAlert({
    required String title,
    required String message,
    required NotificationType type,
    required NotificationPriority priority,
    Map<String, dynamic>? context,
  }) async {
    await sendSmartNotification(
      title: title,
      message: message,
      type: type,
      priority: priority,
      context: context,
    );
  }

  // Custom Notification Schedules
  Future<void> addCustomSchedule(SmartNotificationSchedule schedule) async {
    _schedules.add(schedule);
    if (schedule.isActive) {
      await _activateSchedule(schedule);
    }
  }

  Future<void> removeCustomSchedule(String scheduleId) async {
    _schedules.removeWhere((schedule) => schedule.id == scheduleId);
    await _notifications.cancel(scheduleId.hashCode.abs());
  }

  // Notification Preferences
  void updateNotificationPreferences({
    bool? enabled,
    NotificationPriority? minimumPriority,
    List<NotificationType>? enabledTypes,
    Map<String, TimeOfDay>? quietHours,
  }) {
    if (enabled != null) _notificationsEnabled = enabled;
    if (minimumPriority != null) _minimumPriority = minimumPriority;
    if (enabledTypes != null) _enabledTypes = enabledTypes;
    if (quietHours != null) _quietHours = quietHours;
  }

  // Helper Methods
  String _getChannelId(NotificationType type, NotificationPriority priority) {
    if (priority == NotificationPriority.urgent ||
        priority == NotificationPriority.high) {
      return _priorityChannelId;
    }

    switch (type) {
      case NotificationType.sale:
        return _salesChannelId;
      case NotificationType.stock:
        return _stockChannelId;
      case NotificationType.expense:
        return _expenseChannelId;
      case NotificationType.achievement:
      case NotificationType.milestone:
      case NotificationType.goal:
        return _achievementChannelId;
      case NotificationType.reminder:
      case NotificationType.prediction:
      case NotificationType.insight:
        return _reminderChannelId;
      case NotificationType.prediction:
      case NotificationType.insight:
        return _smartChannelId;
      default:
        return _reminderChannelId;
    }
  }

  String _getChannelName(NotificationType type) {
    switch (type) {
      case NotificationType.sale:
        return 'Sales Notifications';
      case NotificationType.stock:
        return 'Stock Notifications';
      case NotificationType.expense:
        return 'Expense Notifications';
      case NotificationType.achievement:
        return 'Achievement Notifications';
      case NotificationType.reminder:
      case NotificationType.prediction:
      case NotificationType.insight:
        return 'Reminder Notifications';
      case NotificationType.prediction:
      case NotificationType.insight:
        return 'Smart Notifications';
      default:
        return 'General Notifications';
    }
  }

  String _getChannelDescription(NotificationType type) {
    switch (type) {
      case NotificationType.sale:
        return 'Notifications about sales and revenue';
      case NotificationType.stock:
        return 'Notifications about inventory and stock levels';
      case NotificationType.expense:
        return 'Notifications about expenses and costs';
      case NotificationType.achievement:
        return 'Notifications about business achievements and milestones';
      case NotificationType.reminder:
      case NotificationType.prediction:
      case NotificationType.insight:
        return 'Smart reminders and scheduled notifications';
      case NotificationType.prediction:
      case NotificationType.insight:
        return 'AI-powered insights and predictions';
      default:
        return 'General business notifications';
    }
  }

  Importance _getImportance(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Importance.low;
      case NotificationPriority.normal:
        return Importance.defaultImportance;
      case NotificationPriority.high:
        return Importance.high;
      case NotificationPriority.urgent:
        return Importance.max;
    }
  }

  Priority _getPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Priority.low;
      case NotificationPriority.normal:
        return Priority.defaultPriority;
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.urgent:
        return Priority.max;
    }
  }

  String _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.sale:
        return '@mipmap/ic_launcher';
      case NotificationType.stock:
        return '@mipmap/ic_launcher';
      case NotificationType.expense:
        return '@mipmap/ic_launcher';
      case NotificationType.achievement:
        return '@mipmap/ic_launcher';
      case NotificationType.reminder:
      case NotificationType.prediction:
      case NotificationType.insight:
        return '@mipmap/ic_launcher';
      default:
        return '@mipmap/ic_launcher';
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.sale:
        return Colors.green;
      case NotificationType.stock:
        return Colors.orange;
      case NotificationType.expense:
        return Colors.red;
      case NotificationType.achievement:
        return Colors.purple;
      case NotificationType.reminder:
      case NotificationType.prediction:
      case NotificationType.insight:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  bool _isInQuietHours() {
    final now = TimeOfDay.now();
    final start = _quietHours['start']!;
    final end = _quietHours['end']!;

    if (start.hour < end.hour) {
      // Same day quiet hours (e.g., 10 PM to 8 AM)
      return now.hour >= start.hour || now.hour < end.hour;
    } else {
      // Overnight quiet hours (e.g., 10 PM to 8 AM)
      return now.hour >= start.hour && now.hour < end.hour;
    }
  }

  bool _shouldSendContextualAlert(Map<String, dynamic> context) {
    // Implement contextual logic here
    // For example, don't send stock alerts if user just checked stock
    // Don't send expense alerts if user just recorded an expense
    return true; // Placeholder
  }

  Future<void> _setupSmartSchedules() async {
    // Add default smart schedules
    final defaultSchedules = [
      SmartNotificationSchedule(
        id: 'daily_summary',
        title: 'Daily Business Summary',
        message: 'Check your daily business performance',
        type: NotificationType.reminder,
        priority: NotificationPriority.normal,
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7], // Every day
        time: const TimeOfDay(hour: 18, minute: 0), // 6 PM
      ),
      SmartNotificationSchedule(
        id: 'weekly_review',
        title: 'Weekly Business Review',
        message: 'Time for your weekly business analysis',
        type: NotificationType.reminder,
        priority: NotificationPriority.high,
        daysOfWeek: [1], // Monday
        time: const TimeOfDay(hour: 9, minute: 0), // 9 AM
      ),
    ];

    for (final schedule in defaultSchedules) {
      await addCustomSchedule(schedule);
    }
  }

  Future<void> _activateSchedule(SmartNotificationSchedule schedule) async {
    // Schedule the notification
    final now = DateTime.now();
    final scheduledTime = _getNextScheduledTime(schedule, now);

    if (scheduledTime != null) {
      await _scheduleNotification(schedule, scheduledTime);
    }
  }

  DateTime? _getNextScheduledTime(
    SmartNotificationSchedule schedule,
    DateTime from,
  ) {
    final today = from.weekday;
    final targetDays = schedule.daysOfWeek;

    // Find the next occurrence
    for (int i = 0; i < 7; i++) {
      int checkDay = (today + i) % 7;
      if (checkDay == 0) checkDay = 7; // Convert Sunday from 0 to 7

      if (targetDays.contains(checkDay)) {
        final targetDate = from.add(Duration(days: i));
        return DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          schedule.time.hour,
          schedule.time.minute,
        );
      }
    }

    return null;
  }

  Future<void> _scheduleNotification(
    SmartNotificationSchedule schedule,
    DateTime scheduledTime,
  ) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _getChannelId(schedule.type, schedule.priority),
        _getChannelName(schedule.type),
        channelDescription: _getChannelDescription(schedule.type),
        importance: _getImportance(schedule.priority),
        priority: _getPriority(schedule.priority),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // Generate a numeric ID from the string ID
    final numericId = schedule.id.hashCode.abs();

    await _notifications.zonedSchedule(
      numericId,
      schedule.title,
      schedule.message,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  void _startPredictiveAnalysis() {
    // Start background analysis for predictive notifications
    // This would analyze business patterns and send predictive alerts
    Future.delayed(const Duration(minutes: 30), () {
      _analyzeBusinessPatterns();
    });
  }

  Future<void> _analyzeBusinessPatterns() async {
    // Analyze sales patterns
    final sales = await DatabaseService.getAllSales();
    if (sales.isNotEmpty) {
      final recentSales = sales
          .where(
            (sale) => sale.saleDate.isAfter(
              DateTime.now().subtract(const Duration(days: 7)),
            ),
          )
          .toList();

      if (recentSales.isEmpty) {
        await sendPredictiveNotification(
          title: 'Sales Alert',
          message:
              'No sales recorded this week. Consider reviewing your strategy.',
          type: NotificationType.prediction,
          confidence: 0.8,
          predictionData: {'type': 'low_sales_week'},
        );
      }
    }

    // Analyze stock patterns
    final stocks = await DatabaseService.getAllStocks();
    final lowStockItems = stocks
        .where((stock) => stock.quantity <= stock.reorderLevel)
        .toList();

    if (lowStockItems.isNotEmpty) {
      await sendPredictiveNotification(
        title: 'Stock Alert',
        message: '${lowStockItems.length} items are running low on stock.',
        type: NotificationType.prediction,
        confidence: 0.9,
        predictionData: {'type': 'low_stock', 'count': lowStockItems.length},
      );
    }
  }

  // Sales notifications
  Future<void> showSaleNotification(Sale sale) async {
    await sendSmartNotification(
      title: '💰 Sale Recorded!',
      message:
          '${sale.productName} sold to ${sale.customerName} for \$${sale.totalAmount.toStringAsFixed(2)}',
      type: NotificationType.sale,
      priority: NotificationPriority.high,
      context: {'sale_id': sale.id.toString()},
    );
  }

  // Low stock notifications
  Future<void> showLowStockNotification(Stock stock) async {
    await sendSmartNotification(
      title: stock.quantity <= 0 ? '🚨 Out of Stock!' : '⚠️ Low Stock Alert',
      message: stock.quantity <= 0
          ? '${stock.name} is completely out of stock. Please restock immediately.'
          : '${stock.name} is running low (${stock.quantity} units left). Reorder level: ${stock.reorderLevel}',
      type: NotificationType.stock,
      priority: NotificationPriority.high,
      context: {'stock_id': stock.id.toString()},
    );
  }

  // Out of stock notifications
  Future<void> showOutOfStockNotification(Stock stock) async {
    await sendSmartNotification(
      title: '🚨 Out of Stock!',
      message:
          '${stock.name} is completely out of stock. Please restock immediately.',
      type: NotificationType.stock,
      priority: NotificationPriority.high,
      context: {'stock_id': stock.id.toString()},
    );
  }

  // Achievement notifications
  Future<void> showAchievementNotification(String title, String message) async {
    await sendSmartNotification(
      title: title,
      message: message,
      type: NotificationType.achievement,
      priority: NotificationPriority.high,
    );
  }

  // Reminder notifications
  Future<void> showReminderNotification(
    String title,
    String message, {
    String? payload,
  }) async {
    await sendSmartNotification(
      title: title,
      message: message,
      type: NotificationType.reminder,
      priority: NotificationPriority.normal,
      payload: payload,
    );
  }

  // Check and show low stock notifications
  Future<void> checkLowStockNotifications() async {
    try {
      final stocks = await DatabaseService.getAllStocks();
      final lowStockItems = stocks
          .where((stock) => stock.quantity <= stock.reorderLevel)
          .toList();

      for (final stock in lowStockItems) {
        if (stock.quantity <= 0) {
          await showOutOfStockNotification(stock);
        } else {
          await showLowStockNotification(stock);
        }
      }
    } catch (e) {
      // Silent error handling for production
    }
  }

  // Show daily summary notification
  Future<void> showDailySummaryNotification() async {
    try {
      final today = DateTime.now();
      final sales = await DatabaseService.getAllSales();
      final expenses = await DatabaseService.getAllExpenses();

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

      final message =
          'Sales: \$${totalSales.toStringAsFixed(2)} | Expenses: \$${totalExpenses.toStringAsFixed(2)} | Net: \$${netProfit.toStringAsFixed(2)}';

      await showReminderNotification(
        '📊 Daily Business Summary',
        message,
        payload: 'daily_summary',
      );
    } catch (e) {
      // Silent error handling for production
    }
  }

  // Show welcome notification
  Future<void> showWelcomeNotification() async {
    await showReminderNotification(
      '🎉 Welcome to BizTracker!',
      'Your business management app is ready. Start by adding your first product or recording a sale!',
      payload: 'welcome',
    );
  }

  // Expense notifications
  Future<void> showExpenseNotification(Expense expense) async {
    await sendSmartNotification(
      title: '💸 Expense Recorded',
      message:
          '${expense.category}: ${expense.description} - \$${expense.amount.toStringAsFixed(2)}',
      type: NotificationType.expense,
      priority: NotificationPriority.normal,
      context: {'expense_id': expense.id.toString()},
    );
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
        priority: _notificationsList[index].priority,
        isRead: true,
        payload: _notificationsList[index].payload,
        context: _notificationsList[index].context,
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
        priority: _notificationsList[i].priority,
        isRead: true,
        payload: _notificationsList[i].payload,
        context: _notificationsList[i].context,
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
