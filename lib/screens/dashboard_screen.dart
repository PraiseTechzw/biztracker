import 'package:biztracker/screens/capital_screen.dart';
import 'package:biztracker/screens/sales_screen.dart';
import 'package:biztracker/screens/stock_screen.dart';
import 'package:biztracker/screens/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import '../utils/glassmorphism_theme.dart';
import '../utils/toast_utils.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../models/business_data.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';

enum ActivityType { sale, expense, capital, stock }

class ActivityItem {
  final ActivityType type;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final IconData icon;
  final Color color;

  ActivityItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.icon,
    required this.color,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  double totalCapital = 0.0;
  double totalStockValue = 0.0;
  double totalSales = 0.0;
  double totalExpenses = 0.0;
  double netProfit = 0.0;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  int unreadNotifications = 0;
  String businessName = '';
  List<ActivityItem> recentActivities = [];

  // Animation Controllers
  late AnimationController _cardAnimController;
  late AnimationController _headerAnimController;
  late AnimationController _notificationAnimController;
  late AnimationController _settingsAnimController;
  late AnimationController _greetingAnimController;
  late AnimationController _pulseAnimController;
  late AnimationController _slideAnimController;

  // Animations
  late Animation<double> _cardAnim;
  late Animation<double> _headerAnim;
  late Animation<double> _notificationAnim;
  late Animation<double> _settingsAnim;
  late Animation<double> _greetingAnim;
  late Animation<double> _pulseAnim;
  late Animation<Offset> _slideAnim;

  late ConfettiController _confettiController;
  bool _hasShownFirstSaleConfetti = false;
  bool _hasShownProfitMilestoneConfetti = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 4),
    );

    // Initialize animation controllers
    _cardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _notificationAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _settingsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _greetingAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _slideAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Initialize animations
    _cardAnim = CurvedAnimation(
      parent: _cardAnimController,
      curve: Curves.easeOutBack,
    );
    _headerAnim = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOutCubic,
    );
    _notificationAnim = CurvedAnimation(
      parent: _notificationAnimController,
      curve: Curves.elasticOut,
    );
    _settingsAnim = CurvedAnimation(
      parent: _settingsAnimController,
      curve: Curves.elasticOut,
    );
    _greetingAnim = CurvedAnimation(
      parent: _greetingAnimController,
      curve: Curves.easeOutQuart,
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseAnimController, curve: Curves.easeInOut),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _slideAnimController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Start animations
    _startHeaderAnimations();

    _loadDashboardData();
    _loadBusinessName();
    _loadRecentActivities();
    _loadNotificationCount();
  }

  void _startHeaderAnimations() async {
    // Start all animations immediately to ensure visibility
    _slideAnimController.forward();
    _greetingAnimController.forward();
    _notificationAnimController.forward();
    _settingsAnimController.forward();
    _headerAnimController.forward();
    _cardAnimController.forward();
    _pulseAnimController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _cardAnimController.dispose();
    _headerAnimController.dispose();
    _notificationAnimController.dispose();
    _settingsAnimController.dispose();
    _greetingAnimController.dispose();
    _pulseAnimController.dispose();
    _slideAnimController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      // Load all business data in parallel for better performance
      final results = await Future.wait([
        DatabaseService.getTotalCapital(),
        DatabaseService.getTotalStockValue(),
        DatabaseService.getTotalSales(),
        DatabaseService.getTotalExpenses(),
      ]);

      final capital = results[0] as double;
      final stockValue = results[1] as double;
      final sales = results[2] as double;
      final expenses = results[3] as double;
      final profit = sales - expenses;

      setState(() {
        totalCapital = capital;
        totalStockValue = stockValue;
        totalSales = sales;
        totalExpenses = expenses;
        netProfit = profit;
        isLoading = false;
      });

      // Check for achievements and show confetti
      _checkAchievements(sales, profit);

      // Trigger notification animation if there are unread notifications
      if (unreadNotifications > 0) {
        _notificationAnimController.forward();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Failed to load dashboard data: $e';
      });
    }
  }

  // Add a method to load notification count
  Future<void> _loadNotificationCount() async {
    try {
      final count = await NotificationService().getUnreadNotificationCount();
      setState(() {
        unreadNotifications = count;
      });
    } catch (e) {
      print('Error loading notification count: $e');
      setState(() {
        unreadNotifications = 0;
      });
    }
  }

  void _checkAchievements(double sales, double profit) {
    // Check for first sale achievement
    if (sales > 0 && !_hasShownFirstSaleConfetti) {
      _hasShownFirstSaleConfetti = true;
      ConfettiUtils.showAchievementConfetti(_confettiController);
      ToastUtils.showInfoToast('🎉 First sale recorded! Keep it up!');
    }

    // Check for profit milestones
    if (profit >= 1000 && !_hasShownProfitMilestoneConfetti) {
      _hasShownProfitMilestoneConfetti = true;
      ConfettiUtils.showMilestoneConfetti(_confettiController);
      ToastUtils.showInfoToast(
        '🎊 Congratulations! You\'ve reached \$1,000 in profit!',
      );
    } else if (profit >= 5000 && _hasShownProfitMilestoneConfetti) {
      ConfettiUtils.showMilestoneConfetti(_confettiController);
      ToastUtils.showInfoToast(
        '🎊 Amazing! You\'ve reached \$5,000 in profit!',
      );
    } else if (profit >= 10000 && _hasShownProfitMilestoneConfetti) {
      ConfettiUtils.showMilestoneConfetti(_confettiController);
      ToastUtils.showInfoToast(
        '🎊 Outstanding! You\'ve reached \$10,000 in profit!',
      );
    }
  }

  Future<void> _loadBusinessName() async {
    try {
      final profile = await DatabaseService.getBusinessProfile();
      final newBusinessName = profile?.businessName ?? '';

      if (newBusinessName != businessName) {
        // Animate the greeting when business name changes
        _greetingAnimController.reverse();
        await Future.delayed(const Duration(milliseconds: 300));

        setState(() {
          businessName = newBusinessName;
        });

        _greetingAnimController.forward();
      } else {
        setState(() {
          businessName = newBusinessName;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _loadRecentActivities() async {
    try {
      final activities = <ActivityItem>[];

      // Get recent sales (last 5)
      final recentSales = await DatabaseService.getAllSales();
      for (final sale in recentSales.take(5)) {
        activities.add(
          ActivityItem(
            type: ActivityType.sale,
            title: 'Sale recorded',
            subtitle: '${sale.productName} - ${sale.customerName}',
            amount: sale.totalAmount,
            date: sale.saleDate,
            icon: Icons.shopping_cart,
            color: Colors.green,
          ),
        );
      }

      // Get recent expenses (last 5)
      final recentExpenses = await DatabaseService.getAllExpenses();
      for (final expense in recentExpenses.take(5)) {
        activities.add(
          ActivityItem(
            type: ActivityType.expense,
            title: 'Expense recorded',
            subtitle: '${expense.category} - ${expense.description}',
            amount: expense.amount,
            date: expense.expenseDate,
            icon: Icons.receipt,
            color: Colors.red,
          ),
        );
      }

      // Get recent capital additions (last 5)
      final recentCapitals = await DatabaseService.getAllCapitals();
      for (final capital in recentCapitals.take(5)) {
        activities.add(
          ActivityItem(
            type: ActivityType.capital,
            title: 'Capital added',
            subtitle: capital.description,
            amount: capital.amount,
            date: capital.date,
            icon: Icons.account_balance_wallet,
            color: Colors.blue,
          ),
        );
      }

      // Get recent stock updates (last 5)
      final recentStocks = await DatabaseService.getAllStocks();
      for (final stock in recentStocks.take(5)) {
        activities.add(
          ActivityItem(
            type: ActivityType.stock,
            title: 'Stock updated',
            subtitle: '${stock.name} - Qty: ${stock.quantity}',
            amount: stock.unitSellingPrice * stock.quantity,
            date: stock.updatedAt,
            icon: Icons.inventory,
            color: Colors.orange,
          ),
        );
      }

      // Sort all activities by date (most recent first) and take top 10
      activities.sort((a, b) => b.date.compareTo(a.date));

      setState(() {
        recentActivities = activities.take(10).toList();
      });
    } catch (e) {
      // Handle error silently, activities will remain empty
    }
  }

  void _openNotificationsScreen() async {
    // Add a small bounce animation when opening notifications
    _notificationAnimController.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    _notificationAnimController.reverse();

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
    // Refresh dashboard data when returning from notifications
    _loadDashboardData();
  }

  Future<void> _refreshData() async {
    // Add a subtle animation when refreshing
    _headerAnimController.reverse();
    await Future.delayed(const Duration(milliseconds: 300));

    await _loadDashboardData();
    await _loadRecentActivities();

    // Restart header animations
    _headerAnimController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiUtils.buildConfettiWidget(
      controller: _confettiController,
      child: Scaffold(
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
                // Fixed Header - Doesn't scroll
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        GlassmorphismTheme.backgroundColor.withOpacity(0.95),
                        Color(0xFF1E293B).withOpacity(0.95),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              businessName.isNotEmpty
                                  ? 'Hello, $businessName!'
                                  : 'Welcome!',
                              style: const TextStyle(
                                color: GlassmorphismTheme.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Here\'s your business at a glance',
                              style: TextStyle(
                                color: GlassmorphismTheme.textSecondaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Notification icon - simplified
                      _buildNotificationsIcon(
                        context,
                        unreadCount: unreadNotifications,
                      ),
                      // Settings icon - simplified
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: GlassmorphismTheme.textColor,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable Content
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    color: GlassmorphismTheme.primaryColor,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FadeTransition(
                                  opacity: _cardAnim,
                                  child: _buildOverviewCards(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isLoading)
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: GlassmorphismTheme.primaryColor,
                                    ),
                                  )
                                else if (hasError)
                                  _buildErrorState()
                                else
                                  Column(
                                    children: [
                                      const SizedBox(height: 24),
                                      _buildQuickStats(),
                                      const SizedBox(height: 24),
                                      _buildRecentActivity(),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Business Overview',
          style: TextStyle(
            color: GlassmorphismTheme.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.15,
          children: [
            _buildOverviewCard(
              'Total Capital',
              totalCapital,
              Icons.account_balance_wallet,
              GlassmorphismTheme.primaryColor,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CapitalScreen()),
              ),
            ),
            _buildOverviewCard(
              'Stock Value',
              totalStockValue,
              Icons.inventory,
              GlassmorphismTheme.secondaryColor,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StockScreen()),
              ),
            ),
            _buildOverviewCard(
              'Total Sales',
              totalSales,
              Icons.trending_up,
              GlassmorphismTheme.accentColor,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SalesScreen()),
              ),
            ),
            _buildOverviewCard(
              'Total Expenses',
              totalExpenses,
              Icons.receipt_long,
              Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CapitalScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
    String title,
    double value,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    Widget card = GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: GlassmorphismTheme.textSecondaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '\$${NumberFormat('#,##0.00').format(value)}',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }

  Widget _buildQuickStats() {
    // Calculate real metrics
    final profitMargin = totalSales > 0 ? (netProfit / totalSales) * 100 : 0.0;
    final roi = totalCapital > 0 ? (netProfit / totalCapital) * 100 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Stats',
          style: TextStyle(
            color: GlassmorphismTheme.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Net Profit',
                '\$${NumberFormat('#,##0.00').format(netProfit)}',
                Icons.attach_money,
                netProfit >= 0 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Profit Margin',
                '${profitMargin.toStringAsFixed(1)}%',
                Icons.trending_up,
                netProfit >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'ROI',
                '${roi.toStringAsFixed(1)}%',
                Icons.analytics,
                GlassmorphismTheme.accentColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Capital Utilization',
                totalCapital > 0
                    ? '${((totalStockValue / totalCapital) * 100).toStringAsFixed(1)}%'
                    : '0%',
                Icons.account_balance,
                Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: GlassmorphismTheme.textSecondaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            color: GlassmorphismTheme.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        recentActivities.isEmpty
            ? GlassmorphismTheme.glassmorphismContainer(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: GlassmorphismTheme.textSecondaryColor,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No recent activity yet',
                      style: TextStyle(
                        color: GlassmorphismTheme.textSecondaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your recent business activity will appear here.',
                      style: TextStyle(
                        color: GlassmorphismTheme.textSecondaryColor,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentActivities.length,
                itemBuilder: (context, index) {
                  final activity = recentActivities[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassmorphismTheme.glassmorphismContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: activity.color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  activity.icon,
                                  color: activity.color,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activity.title,
                                      style: const TextStyle(
                                        color: GlassmorphismTheme.textColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      activity.subtitle,
                                      style: TextStyle(
                                        color: GlassmorphismTheme
                                            .textSecondaryColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                DateFormat('MM/dd HH:mm').format(activity.date),
                                style: TextStyle(
                                  color: GlassmorphismTheme.textSecondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${NumberFormat('#,##0.00').format(activity.amount)}',
                            style: TextStyle(
                              color: activity.color,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildErrorState() {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.withOpacity(0.7),
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load data',
            style: TextStyle(
              color: GlassmorphismTheme.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: const TextStyle(
              color: GlassmorphismTheme.textSecondaryColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshData,
            style: ElevatedButton.styleFrom(
              backgroundColor: GlassmorphismTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsIcon(BuildContext context, {int unreadCount = 0}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Simple notification icon
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: GlassmorphismTheme.primaryColor,
            size: 28,
          ),
          tooltip: 'Notifications ($unreadCount unread)',
          onPressed: _openNotificationsScreen,
        ),
        // Notification badge
        if (unreadCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
