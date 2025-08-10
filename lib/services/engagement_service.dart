import 'package:flutter/material.dart';
import 'database_service.dart';
import 'notification_service.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final AchievementType type;
  final int requiredValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int points;
  final Color color;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
    required this.requiredValue,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.points,
    required this.color,
  });
}

enum AchievementType {
  sales,
  profit,
  stock,
  customer,
  consistency,
  milestone,
  special,
}

class Goal {
  final String id;
  final String title;
  final String description;
  final GoalType type;
  final double targetValue;
  final double currentValue;
  final DateTime deadline;
  final bool isCompleted;
  final DateTime? completedAt;
  final int rewardPoints;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.currentValue,
    required this.deadline,
    this.isCompleted = false,
    this.completedAt,
    required this.rewardPoints,
  });
}

enum GoalType {
  dailySales,
  weeklySales,
  monthlySales,
  dailyProfit,
  weeklyProfit,
  monthlyProfit,
  customerCount,
  stockValue,
  expenseReduction,
  consistency,
}

class BusinessChallenge {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final DateTime startDate;
  final DateTime endDate;
  final double targetValue;
  final double currentValue;
  final bool isActive;
  final bool isCompleted;
  final int rewardPoints;
  final List<String> participants;

  BusinessChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.targetValue,
    required this.currentValue,
    this.isActive = true,
    this.isCompleted = false,
    required this.rewardPoints,
    this.participants = const [],
  });
}

enum ChallengeType {
  salesSprint,
  profitBoost,
  customerAcquisition,
  inventoryOptimization,
  expenseControl,
  consistencyStreak,
}

class LeaderboardEntry {
  final String businessId;
  final String businessName;
  final int points;
  final int rank;
  final DateTime lastUpdated;

  LeaderboardEntry({
    required this.businessId,
    required this.businessName,
    required this.points,
    required this.rank,
    required this.lastUpdated,
  });
}

class EngagementService {
  static final EngagementService _instance = EngagementService._internal();
  factory EngagementService() => _instance;
  EngagementService._internal();

  // User progress and stats
  int _totalPoints = 0;
  int _level = 1;
  int _streak = 0;
  DateTime? _lastActivityDate;

  // Collections
  final List<Achievement> _achievements = [];
  final List<Goal> _goals = [];
  final List<BusinessChallenge> _challenges = [];
  final List<LeaderboardEntry> _leaderboard = [];

  // Getters
  int get totalPoints => _totalPoints;
  int get level => _level;
  int get streak => _streak;
  DateTime? get lastActivityDate => _lastActivityDate;
  List<Achievement> get achievements => List.unmodifiable(_achievements);
  List<Goal> get goals => List.unmodifiable(_goals);
  List<BusinessChallenge> get challenges => List.unmodifiable(_challenges);
  List<LeaderboardEntry> get leaderboard => List.unmodifiable(_leaderboard);

  Future<void> initialize() async {
    await _loadAchievements();
    await _loadGoals();
    await _loadChallenges();
    await _loadUserProgress();
    await _checkAchievements();
    await _checkGoals();
    await _checkChallenges();
  }

  // Achievement System
  Future<void> _loadAchievements() async {
    _achievements.clear();

    // Sales Achievements
    _achievements.addAll([
      Achievement(
        id: 'first_sale',
        title: 'First Sale',
        description: 'Record your first sale',
        icon: '💰',
        type: AchievementType.sales,
        requiredValue: 1,
        points: 50,
        color: Colors.green,
      ),
      Achievement(
        id: 'sales_10',
        title: 'Sales Beginner',
        description: 'Record 10 sales',
        icon: '📈',
        type: AchievementType.sales,
        requiredValue: 10,
        points: 100,
        color: Colors.blue,
      ),
      Achievement(
        id: 'sales_50',
        title: 'Sales Pro',
        description: 'Record 50 sales',
        icon: '🏆',
        type: AchievementType.sales,
        requiredValue: 50,
        points: 250,
        color: Colors.purple,
      ),
      Achievement(
        id: 'sales_100',
        title: 'Sales Master',
        description: 'Record 100 sales',
        icon: '👑',
        type: AchievementType.sales,
        requiredValue: 100,
        points: 500,
        color: Colors.orange,
      ),
    ]);

    // Profit Achievements
    _achievements.addAll([
      Achievement(
        id: 'profit_100',
        title: 'Profit Starter',
        description: 'Reach \$100 in total profit',
        icon: '💵',
        type: AchievementType.profit,
        requiredValue: 100,
        points: 150,
        color: Colors.green,
      ),
      Achievement(
        id: 'profit_500',
        title: 'Profit Builder',
        description: 'Reach \$500 in total profit',
        icon: '💎',
        type: AchievementType.profit,
        requiredValue: 500,
        points: 300,
        color: Colors.blue,
      ),
      Achievement(
        id: 'profit_1000',
        title: 'Profit Champion',
        description: 'Reach \$1,000 in total profit',
        icon: '🏅',
        type: AchievementType.profit,
        requiredValue: 1000,
        points: 600,
        color: Colors.purple,
      ),
    ]);

    // Consistency Achievements
    _achievements.addAll([
      Achievement(
        id: 'streak_3',
        title: 'Getting Started',
        description: 'Use the app for 3 consecutive days',
        icon: '🔥',
        type: AchievementType.consistency,
        requiredValue: 3,
        points: 75,
        color: Colors.orange,
      ),
      Achievement(
        id: 'streak_7',
        title: 'Week Warrior',
        description: 'Use the app for 7 consecutive days',
        icon: '⚡',
        type: AchievementType.consistency,
        requiredValue: 7,
        points: 200,
        color: Colors.red,
      ),
      Achievement(
        id: 'streak_30',
        title: 'Monthly Master',
        description: 'Use the app for 30 consecutive days',
        icon: '🌟',
        type: AchievementType.consistency,
        requiredValue: 30,
        points: 1000,
        color: Colors.purple,
      ),
    ]);

    // Stock Achievements
    _achievements.addAll([
      Achievement(
        id: 'stock_10',
        title: 'Inventory Manager',
        description: 'Add 10 different stock items',
        icon: '📦',
        type: AchievementType.stock,
        requiredValue: 10,
        points: 150,
        color: Colors.teal,
      ),
      Achievement(
        id: 'stock_25',
        title: 'Stock Master',
        description: 'Add 25 different stock items',
        icon: '🏪',
        type: AchievementType.stock,
        requiredValue: 25,
        points: 300,
        color: Colors.indigo,
      ),
    ]);

    // Special Achievements
    _achievements.addAll([
      Achievement(
        id: 'complete_profile',
        title: 'Business Ready',
        description: 'Complete your business profile',
        icon: '✅',
        type: AchievementType.special,
        requiredValue: 1,
        points: 100,
        color: Colors.green,
      ),
      Achievement(
        id: 'first_report',
        title: 'Analyst',
        description: 'Generate your first business report',
        icon: '📊',
        type: AchievementType.special,
        requiredValue: 1,
        points: 150,
        color: Colors.blue,
      ),
    ]);
  }

  Future<void> _loadGoals() async {
    _goals.clear();

    // Add default goals
    final now = DateTime.now();
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    _goals.addAll([
      Goal(
        id: 'daily_sales_goal',
        title: 'Daily Sales Target',
        description: 'Achieve \$100 in daily sales',
        type: GoalType.dailySales,
        targetValue: 100,
        currentValue: 0,
        deadline: DateTime(now.year, now.month, now.day, 23, 59, 59),
        rewardPoints: 50,
      ),
      Goal(
        id: 'weekly_profit_goal',
        title: 'Weekly Profit Target',
        description: 'Achieve \$500 in weekly profit',
        type: GoalType.weeklyProfit,
        targetValue: 500,
        currentValue: 0,
        deadline: now.add(const Duration(days: 7)),
        rewardPoints: 200,
      ),
      Goal(
        id: 'monthly_sales_goal',
        title: 'Monthly Sales Target',
        description: 'Achieve \$2,000 in monthly sales',
        type: GoalType.monthlySales,
        targetValue: 2000,
        currentValue: 0,
        deadline: endOfMonth,
        rewardPoints: 500,
      ),
    ]);
  }

  Future<void> _loadChallenges() async {
    _challenges.clear();

    // Add default challenges
    final now = DateTime.now();

    _challenges.addAll([
      BusinessChallenge(
        id: 'sales_sprint_week',
        title: 'Sales Sprint Week',
        description: 'Boost your sales this week!',
        type: ChallengeType.salesSprint,
        startDate: now,
        endDate: now.add(const Duration(days: 7)),
        targetValue: 1000,
        currentValue: 0,
        rewardPoints: 300,
      ),
      BusinessChallenge(
        id: 'profit_boost_month',
        title: 'Profit Boost Month',
        description: 'Increase your profit margin this month',
        type: ChallengeType.profitBoost,
        startDate: now,
        endDate: DateTime(now.year, now.month + 1, 0),
        targetValue: 1500,
        currentValue: 0,
        rewardPoints: 600,
      ),
    ]);
  }

  Future<void> _loadUserProgress() async {
    // Load user progress from database or shared preferences
    // For now, we'll use default values
    _totalPoints = 0;
    _level = 1;
    _streak = 0;
    _lastActivityDate = null;
  }

  // Progress Tracking
  Future<void> recordActivity() async {
    final today = DateTime.now();

    if (_lastActivityDate != null) {
      final difference = today.difference(_lastActivityDate!).inDays;

      if (difference == 1) {
        // Consecutive day
        _streak++;
        await _checkStreakAchievements();
      } else if (difference > 1) {
        // Streak broken
        _streak = 1;
      }
    } else {
      _streak = 1;
    }

    _lastActivityDate = today;
    await _saveUserProgress();
  }

  Future<void> addPoints(int points) async {
    _totalPoints += points;
    await _checkLevelUp();
    await _saveUserProgress();
  }

  Future<void> _checkLevelUp() async {
    final newLevel = (_totalPoints / 1000).floor() + 1;
    if (newLevel > _level) {
      _level = newLevel;

      // Show level up notification
      await NotificationService().sendSmartNotification(
        title: '🎉 Level Up!',
        message: 'Congratulations! You\'ve reached Level $_level!',
        type: NotificationType.achievement,
        priority: NotificationPriority.high,
      );
    }
  }

  // Achievement Checking
  Future<void> _checkAchievements() async {
    final sales = await DatabaseService.getAllSales();
    final profits = await DatabaseService.getAllProfits();
    final stocks = await DatabaseService.getAllStocks();
    final businessProfile = await DatabaseService.getBusinessProfile();

    // Check sales achievements
    for (final achievement in _achievements.where(
      (a) => a.type == AchievementType.sales && !a.isUnlocked,
    )) {
      if (sales.length >= achievement.requiredValue) {
        await _unlockAchievement(achievement);
      }
    }

    // Check profit achievements
    final totalProfit = profits.fold<double>(
      0,
      (sum, profit) => sum + profit.netProfit,
    );
    for (final achievement in _achievements.where(
      (a) => a.type == AchievementType.profit && !a.isUnlocked,
    )) {
      if (totalProfit >= achievement.requiredValue) {
        await _unlockAchievement(achievement);
      }
    }

    // Check stock achievements
    for (final achievement in _achievements.where(
      (a) => a.type == AchievementType.stock && !a.isUnlocked,
    )) {
      if (stocks.length >= achievement.requiredValue) {
        await _unlockAchievement(achievement);
      }
    }

    // Check special achievements
    for (final achievement in _achievements.where(
      (a) => a.type == AchievementType.special && !a.isUnlocked,
    )) {
      if (achievement.id == 'complete_profile' &&
          businessProfile?.isProfileComplete == true) {
        await _unlockAchievement(achievement);
      }
    }
  }

  Future<void> _checkStreakAchievements() async {
    for (final achievement in _achievements.where(
      (a) => a.type == AchievementType.consistency && !a.isUnlocked,
    )) {
      if (_streak >= achievement.requiredValue) {
        await _unlockAchievement(achievement);
      }
    }
  }

  Future<void> _unlockAchievement(Achievement achievement) async {
    final index = _achievements.indexWhere((a) => a.id == achievement.id);
    if (index != -1) {
      _achievements[index] = Achievement(
        id: achievement.id,
        title: achievement.title,
        description: achievement.description,
        icon: achievement.icon,
        type: achievement.type,
        requiredValue: achievement.requiredValue,
        isUnlocked: true,
        unlockedAt: DateTime.now(),
        points: achievement.points,
        color: achievement.color,
      );

      // Add points
      await addPoints(achievement.points);

      // Show notification
      await NotificationService().sendSmartNotification(
        title: '🏆 Achievement Unlocked!',
        message: '${achievement.title}: ${achievement.description}',
        type: NotificationType.achievement,
        priority: NotificationPriority.high,
      );
    }
  }

  // Goal Management
  Future<void> _checkGoals() async {
    final sales = await DatabaseService.getAllSales();
    final profits = await DatabaseService.getAllProfits();
    final now = DateTime.now();

    for (int i = 0; i < _goals.length; i++) {
      final goal = _goals[i];
      if (goal.isCompleted) continue;

      double currentValue = 0;

      switch (goal.type) {
        case GoalType.dailySales:
          final todaySales = sales
              .where(
                (sale) =>
                    sale.saleDate.day == now.day &&
                    sale.saleDate.month == now.month &&
                    sale.saleDate.year == now.year,
              )
              .toList();
          currentValue = todaySales.fold<double>(
            0,
            (sum, sale) => sum + sale.totalAmount,
          );
          break;

        case GoalType.weeklySales:
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekSales = sales
              .where(
                (sale) =>
                    sale.saleDate.isAfter(
                      weekStart.subtract(const Duration(days: 1)),
                    ) &&
                    sale.saleDate.isBefore(
                      weekStart.add(const Duration(days: 7)),
                    ),
              )
              .toList();
          currentValue = weekSales.fold<double>(
            0,
            (sum, sale) => sum + sale.totalAmount,
          );
          break;

        case GoalType.monthlySales:
          final monthSales = sales
              .where(
                (sale) =>
                    sale.saleDate.month == now.month &&
                    sale.saleDate.year == now.year,
              )
              .toList();
          currentValue = monthSales.fold<double>(
            0,
            (sum, sale) => sum + sale.totalAmount,
          );
          break;

        case GoalType.dailyProfit:
        case GoalType.weeklyProfit:
        case GoalType.monthlyProfit:
          // Calculate profit based on sales and expenses
          currentValue = await _calculateProfit(goal.type);
          break;

        default:
          break;
      }

      // Update goal progress
      _goals[i] = Goal(
        id: goal.id,
        title: goal.title,
        description: goal.description,
        type: goal.type,
        targetValue: goal.targetValue,
        currentValue: currentValue,
        deadline: goal.deadline,
        isCompleted: currentValue >= goal.targetValue,
        completedAt: currentValue >= goal.targetValue ? DateTime.now() : null,
        rewardPoints: goal.rewardPoints,
      );

      // Check if goal is completed
      if (_goals[i].isCompleted && !goal.isCompleted) {
        await _completeGoal(_goals[i]);
      }
    }
  }

  Future<double> _calculateProfit(GoalType type) async {
    final sales = await DatabaseService.getAllSales();
    final expenses = await DatabaseService.getAllExpenses();
    final now = DateTime.now();

    double totalSales = 0;
    double totalExpenses = 0;

    switch (type) {
      case GoalType.dailyProfit:
        final todaySales = sales
            .where(
              (sale) =>
                  sale.saleDate.day == now.day &&
                  sale.saleDate.month == now.month &&
                  sale.saleDate.year == now.year,
            )
            .toList();
        final todayExpenses = expenses
            .where(
              (expense) =>
                  expense.expenseDate.day == now.day &&
                  expense.expenseDate.month == now.month &&
                  expense.expenseDate.year == now.year,
            )
            .toList();

        totalSales = todaySales.fold<double>(
          0,
          (sum, sale) => sum + sale.totalAmount,
        );
        totalExpenses = todayExpenses.fold<double>(
          0,
          (sum, expense) => sum + expense.amount,
        );
        break;

      case GoalType.weeklyProfit:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekSales = sales
            .where(
              (sale) =>
                  sale.saleDate.isAfter(
                    weekStart.subtract(const Duration(days: 1)),
                  ) &&
                  sale.saleDate.isBefore(
                    weekStart.add(const Duration(days: 7)),
                  ),
            )
            .toList();
        final weekExpenses = expenses
            .where(
              (expense) =>
                  expense.expenseDate.isAfter(
                    weekStart.subtract(const Duration(days: 1)),
                  ) &&
                  expense.expenseDate.isBefore(
                    weekStart.add(const Duration(days: 7)),
                  ),
            )
            .toList();

        totalSales = weekSales.fold<double>(
          0,
          (sum, sale) => sum + sale.totalAmount,
        );
        totalExpenses = weekExpenses.fold<double>(
          0,
          (sum, expense) => sum + expense.amount,
        );
        break;

      case GoalType.monthlyProfit:
        final monthSales = sales
            .where(
              (sale) =>
                  sale.saleDate.month == now.month &&
                  sale.saleDate.year == now.year,
            )
            .toList();
        final monthExpenses = expenses
            .where(
              (expense) =>
                  expense.expenseDate.month == now.month &&
                  expense.expenseDate.year == now.year,
            )
            .toList();

        totalSales = monthSales.fold<double>(
          0,
          (sum, sale) => sum + sale.totalAmount,
        );
        totalExpenses = monthExpenses.fold<double>(
          0,
          (sum, expense) => sum + expense.amount,
        );
        break;

      default:
        break;
    }

    return totalSales - totalExpenses;
  }

  Future<void> _completeGoal(Goal goal) async {
    // Add points
    await addPoints(goal.rewardPoints);

    // Show notification
    await NotificationService().sendSmartNotification(
      title: '🎯 Goal Completed!',
      message: '${goal.title}: ${goal.description}',
      type: NotificationType.achievement,
      priority: NotificationPriority.high,
    );
  }

  // Challenge Management
  Future<void> _checkChallenges() async {
    final now = DateTime.now();

    for (int i = 0; i < _challenges.length; i++) {
      final challenge = _challenges[i];
      if (!challenge.isActive || challenge.isCompleted) continue;

      // Check if challenge is expired
      if (now.isAfter(challenge.endDate)) {
        _challenges[i] = BusinessChallenge(
          id: challenge.id,
          title: challenge.title,
          description: challenge.description,
          type: challenge.type,
          startDate: challenge.startDate,
          endDate: challenge.endDate,
          targetValue: challenge.targetValue,
          currentValue: challenge.currentValue,
          isActive: false,
          isCompleted: false,
          rewardPoints: challenge.rewardPoints,
          participants: challenge.participants,
        );
        continue;
      }

      // Update challenge progress
      double currentValue = await _getChallengeProgress(challenge);

      _challenges[i] = BusinessChallenge(
        id: challenge.id,
        title: challenge.title,
        description: challenge.description,
        type: challenge.type,
        startDate: challenge.startDate,
        endDate: challenge.endDate,
        targetValue: challenge.targetValue,
        currentValue: currentValue,
        isActive: true,
        isCompleted: currentValue >= challenge.targetValue,
        rewardPoints: challenge.rewardPoints,
        participants: challenge.participants,
      );

      // Check if challenge is completed
      if (_challenges[i].isCompleted && !challenge.isCompleted) {
        await _completeChallenge(_challenges[i]);
      }
    }
  }

  Future<double> _getChallengeProgress(BusinessChallenge challenge) async {
    final sales = await DatabaseService.getAllSales();
    final profits = await DatabaseService.getAllProfits();

    switch (challenge.type) {
      case ChallengeType.salesSprint:
        final challengeSales = sales
            .where(
              (sale) =>
                  sale.saleDate.isAfter(
                    challenge.startDate.subtract(const Duration(days: 1)),
                  ) &&
                  sale.saleDate.isBefore(
                    challenge.endDate.add(const Duration(days: 1)),
                  ),
            )
            .toList();
        return challengeSales.fold<double>(
          0,
          (sum, sale) => sum + sale.totalAmount,
        );

      case ChallengeType.profitBoost:
        final challengeProfits = profits
            .where(
              (profit) =>
                  profit.periodStart.isAfter(
                    challenge.startDate.subtract(const Duration(days: 1)),
                  ) &&
                  profit.periodEnd.isBefore(
                    challenge.endDate.add(const Duration(days: 1)),
                  ),
            )
            .toList();
        return challengeProfits.fold<double>(
          0,
          (sum, profit) => sum + profit.netProfit,
        );

      default:
        return 0;
    }
  }

  Future<void> _completeChallenge(BusinessChallenge challenge) async {
    // Add points
    await addPoints(challenge.rewardPoints);

    // Show notification
    await NotificationService().sendSmartNotification(
      title: '🏆 Challenge Completed!',
      message: '${challenge.title}: ${challenge.description}',
      type: NotificationType.achievement,
      priority: NotificationPriority.high,
    );
  }

  // Leaderboard System (for future multi-user support)
  Future<void> updateLeaderboard() async {
    // This would connect to a backend service for multi-user leaderboards
    // For now, we'll simulate with local data
    final businessProfile = await DatabaseService.getBusinessProfile();

    if (businessProfile != null) {
      final entry = LeaderboardEntry(
        businessId: businessProfile.id.toString(),
        businessName: businessProfile.businessName,
        points: _totalPoints,
        rank: 1, // Would be calculated by backend
        lastUpdated: DateTime.now(),
      );

      final index = _leaderboard.indexWhere(
        (e) => e.businessId == entry.businessId,
      );
      if (index != -1) {
        _leaderboard[index] = entry;
      } else {
        _leaderboard.add(entry);
      }

      // Sort by points
      _leaderboard.sort((a, b) => b.points.compareTo(a.points));

      // Update ranks
      for (int i = 0; i < _leaderboard.length; i++) {
        _leaderboard[i] = LeaderboardEntry(
          businessId: _leaderboard[i].businessId,
          businessName: _leaderboard[i].businessName,
          points: _leaderboard[i].points,
          rank: i + 1,
          lastUpdated: _leaderboard[i].lastUpdated,
        );
      }
    }
  }

  // Utility Methods
  Future<void> _saveUserProgress() async {
    // Save user progress to database or shared preferences
    // Implementation would depend on your storage solution
  }

  // Public Methods
  Future<void> checkForNewAchievements() async {
    await _checkAchievements();
    await _checkStreakAchievements();
  }

  Future<void> checkForGoalProgress() async {
    await _checkGoals();
  }

  Future<void> checkForChallengeProgress() async {
    await _checkChallenges();
  }

  List<Achievement> getUnlockedAchievements() {
    return _achievements
        .where((achievement) => achievement.isUnlocked)
        .toList();
  }

  List<Achievement> getLockedAchievements() {
    return _achievements
        .where((achievement) => !achievement.isUnlocked)
        .toList();
  }

  List<Goal> getActiveGoals() {
    return _goals
        .where(
          (goal) => !goal.isCompleted && DateTime.now().isBefore(goal.deadline),
        )
        .toList();
  }

  List<Goal> getCompletedGoals() {
    return _goals.where((goal) => goal.isCompleted).toList();
  }

  List<BusinessChallenge> getActiveChallenges() {
    return _challenges
        .where((challenge) => challenge.isActive && !challenge.isCompleted)
        .toList();
  }

  List<BusinessChallenge> getCompletedChallenges() {
    return _challenges.where((challenge) => challenge.isCompleted).toList();
  }

  double getGoalProgress(Goal goal) {
    if (goal.targetValue == 0) return 0;
    return (goal.currentValue / goal.targetValue).clamp(0.0, 1.0);
  }

  double getChallengeProgress(BusinessChallenge challenge) {
    if (challenge.targetValue == 0) return 0;
    return (challenge.currentValue / challenge.targetValue).clamp(0.0, 1.0);
  }

  int getPointsToNextLevel() {
    final pointsForCurrentLevel = (_level - 1) * 1000;
    return 1000 - (_totalPoints - pointsForCurrentLevel);
  }

  double getLevelProgress() {
    final pointsForCurrentLevel = (_level - 1) * 1000;
    final pointsInCurrentLevel = _totalPoints - pointsForCurrentLevel;
    return (pointsInCurrentLevel / 1000).clamp(0.0, 1.0);
  }
}
