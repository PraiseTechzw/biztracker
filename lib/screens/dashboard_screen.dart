import 'package:biztracker/screens/capital_screen.dart';
import 'package:biztracker/screens/expenses_screen.dart';
import 'package:biztracker/screens/sales_screen.dart';
import 'package:biztracker/screens/stock_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/database_service.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
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
  late AnimationController _cardAnimController;
  late Animation<double> _cardAnim;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _loadBusinessName();
    _cardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _cardAnim = CurvedAnimation(
      parent: _cardAnimController,
      curve: Curves.easeOutBack,
    );
    _cardAnimController.forward();
  }

  @override
  void dispose() {
    _cardAnimController.dispose();
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
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Failed to load dashboard data: $e';
      });
    }
  }

  Future<void> _loadBusinessName() async {
    try {
      final profile = await DatabaseService.getBusinessProfile();
      setState(() {
        businessName = profile?.businessName ?? '';
      });
    } catch (e) {
      // Don't show error for business name, just use default
      setState(() {
        businessName = '';
      });
    }
  }

  void _openNotificationsScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
    // Refresh dashboard data when returning from notifications
    _loadDashboardData();
  }

  Future<void> _refreshData() async {
    await _loadDashboardData();
    await _loadBusinessName();
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
                        Row(
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
                                      color:
                                          GlassmorphismTheme.textSecondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildNotificationsIcon(
                              context,
                              unreadCount: unreadNotifications,
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.settings,
                                color: GlassmorphismTheme.textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
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
                              _buildQuickActions(),
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
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
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
              child: _buildActionCard(
                'Add Capital',
                Icons.account_balance_wallet,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CapitalScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Record Expense',
                Icons.receipt_long,
                Colors.orange,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExpensesScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Add Stock',
                Icons.inventory,
                Colors.green,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StockScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Record Sale',
                Icons.point_of_sale,
                Colors.purple,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SalesScreen()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphismTheme.glassmorphismContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: GlassmorphismTheme.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
                MaterialPageRoute(builder: (context) => const ExpensesScreen()),
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
        GlassmorphismTheme.glassmorphismContainer(
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
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: GlassmorphismTheme.primaryColor,
          ),
          tooltip: 'Notifications',
          onPressed: _openNotificationsScreen,
        ),
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
