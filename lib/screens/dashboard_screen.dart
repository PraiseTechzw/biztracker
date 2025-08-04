import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/database_service.dart';
import '../models/business_data.dart';
import 'capital_screen.dart';
import 'stock_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double totalCapital = 0.0;
  double totalStockValue = 0.0;
  double totalSales = 0.0;
  double totalExpenses = 0.0;
  double netProfit = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final capital = await DatabaseService.getTotalCapital();
      final stockValue = await DatabaseService.getTotalStockValue();
      final sales = await DatabaseService.getTotalSales();
      final expenses = await DatabaseService.getTotalExpenses();
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
      });
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
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'BizTracker',
                    style: TextStyle(
                      color: GlassmorphismTheme.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: GlassmorphismTheme.primaryGradient,
                    ),
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
                      else
                        Column(
                          children: [
                            _buildOverviewCards(),
                            const SizedBox(height: 24),
                            _buildQuickActions(),
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
          childAspectRatio: 1.2,
          children: [
            _buildOverviewCard(
              'Total Capital',
              totalCapital,
              Icons.account_balance_wallet,
              GlassmorphismTheme.primaryColor,
            ),
            _buildOverviewCard(
              'Stock Value',
              totalStockValue,
              Icons.inventory,
              GlassmorphismTheme.secondaryColor,
            ),
            _buildOverviewCard(
              'Total Sales',
              totalSales,
              Icons.trending_up,
              GlassmorphismTheme.accentColor,
            ),
            _buildOverviewCard(
              'Net Profit',
              netProfit,
              Icons.attach_money,
              netProfit >= 0 ? Colors.green : Colors.red,
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
    Color color,
  ) {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: GlassmorphismTheme.textSecondaryColor,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '\$${NumberFormat('#,##0.00').format(value)}',
            style: const TextStyle(
              color: GlassmorphismTheme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              'Add Capital',
              Icons.add_circle,
              () => _navigateToSection('capital'),
            ),
            _buildActionCard(
              'Manage Stock',
              Icons.inventory_2,
              () => _navigateToSection('stock'),
            ),
            _buildActionCard(
              'Record Sale',
              Icons.point_of_sale,
              () => _navigateToSection('sale'),
            ),
            _buildActionCard(
              'Add Expense',
              Icons.receipt_long,
              () => _navigateToSection('expense'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphismTheme.glassmorphismContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: GlassmorphismTheme.primaryColor, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: GlassmorphismTheme.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
          padding: const EdgeInsets.all(16),
          child: const Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: GlassmorphismTheme.textSecondaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'No recent activity',
                    style: TextStyle(
                      color: GlassmorphismTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToSection(String section) {
    switch (section) {
      case 'capital':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CapitalScreen()),
        );
        break;
      case 'stock':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StockScreen()),
        );
        break;
      case 'sale':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sales feature coming soon!'),
            backgroundColor: GlassmorphismTheme.primaryColor,
          ),
        );
        break;
      case 'expense':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense tracking coming soon!'),
            backgroundColor: GlassmorphismTheme.primaryColor,
          ),
        );
        break;
    }
  }
}
