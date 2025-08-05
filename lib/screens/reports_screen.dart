import 'package:biztracker/models/business_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/database_service.dart';
import '../models/business_data.dart';
import '../widgets/chart_widget.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Profit> profits = [];
  List<Sale> sales = [];
  List<Expense> expenses = [];
  List<Stock> stocks = [];
  List<Capital> capitals = [];
  bool isLoading = true;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  String selectedReportType = 'Financial Summary';
  BusinessProfile? businessProfile;

  final List<String> reportTypes = [
    'Financial Summary',
    'Sales Analysis',
    'Expense Breakdown',
    'Inventory Report',
    'Cash Flow',
    'Performance Metrics',
  ];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await Future.wait([
        DatabaseService.getAllProfits(),
        DatabaseService.getAllSales(),
        DatabaseService.getAllExpenses(),
        DatabaseService.getAllStocks(),
        DatabaseService.getAllCapitals(),
        DatabaseService.getBusinessProfile(),
      ]);

      setState(() {
        profits = results[0] as List<Profit>;
        sales = results[1] as List<Sale>;
        expenses = results[2] as List<Expense>;
        stocks = results[3] as List<Stock>;
        capitals = results[4] as List<Capital>;
        businessProfile = results[5] as BusinessProfile?;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadAllData();
  }

  Future<void> _generateProfitReport() async {
    setState(() {
      isLoading = true;
    });

    try {
      final profit = await DatabaseService.calculateProfit(startDate, endDate);
      await DatabaseService.saveProfit(profit);
      await _loadAllData();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _exportReport() async {
    try {
      final summary = _getFinancialSummary();
      final analysis = _getSalesAnalysis();
      final breakdown = _getExpenseBreakdown();
      final inventory = _getInventoryReport();

      final report =
          '''
BUSINESS REPORT
${businessProfile?.businessName ?? 'Business Name'}
Generated on: ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}
Period: ${DateFormat('MMM dd, yyyy').format(startDate)} - ${DateFormat('MMM dd, yyyy').format(endDate)}

FINANCIAL SUMMARY
================
Total Revenue: \$${NumberFormat('#,##0.00').format(summary['totalRevenue'])}
Total Expenses: \$${NumberFormat('#,##0.00').format(summary['totalExpenses'])}
Net Profit: \$${NumberFormat('#,##0.00').format(summary['netProfit'])}
Profit Margin: ${summary['profitMargin'].toStringAsFixed(1)}%
Total Capital: \$${NumberFormat('#,##0.00').format(summary['totalCapital'])}
Stock Value: \$${NumberFormat('#,##0.00').format(summary['totalStockValue'])}

SALES ANALYSIS
==============
Total Sales: \$${NumberFormat('#,##0.00').format(analysis['totalSales'])}
Sales Count: ${analysis['salesCount']}
Paid Sales: \$${NumberFormat('#,##0.00').format(analysis['totalPaid'])}
Credit Sales: \$${NumberFormat('#,##0.00').format(analysis['totalCredit'])}
Partial Payments: \$${NumberFormat('#,##0.00').format(analysis['totalPartial'])}

Payment Methods:
- Cash: ${analysis['cashSales']} transactions
- Card: ${analysis['cardSales']} transactions
- Bank Transfer: ${analysis['bankSales']} transactions

EXPENSE BREAKDOWN
================
Total Expenses: \$${NumberFormat('#,##0.00').format(breakdown['totalExpenses'])}
Expenses Count: ${breakdown['expensesCount']}

Expense Categories:
${breakdown['categoryBreakdown'].entries.map((entry) => '- ${entry.key}: \$${NumberFormat('#,##0.00').format(entry.value)}').join('\n')}

INVENTORY REPORT
================
Total Items: ${inventory['totalItems']}
Total Value: \$${NumberFormat('#,##0.00').format(inventory['totalValue'])}
Total Cost: \$${NumberFormat('#,##0.00').format(inventory['totalCost'])}
Selling Value: \$${NumberFormat('#,##0.00').format(inventory['totalSellingValue'])}
Low Stock Items: ${inventory['lowStockItems']}

Inventory Categories:
${inventory['categoryBreakdown'].entries.map((entry) => '- ${entry.key}: ${entry.value} items').join('\n')}

PERFORMANCE METRICS
==================
Collection Rate: ${analysis['totalSales'] > 0 ? (analysis['totalPaid'] / analysis['totalSales'] * 100).toStringAsFixed(1) : '0.0'}%
Inventory Turnover: ${inventory['totalValue'] > 0 ? (summary['totalRevenue'] / inventory['totalValue']).toStringAsFixed(2) : '0.00'}x
ROI: ${summary['totalCapital'] > 0 ? (summary['netProfit'] / summary['totalCapital'] * 100).toStringAsFixed(1) : '0.0'}%

END OF REPORT
=============
''';

      // Show the report in a dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Business Report'),
          content: SingleChildScrollView(
            child: SelectableText(
              report,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating report: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Map<String, dynamic> _getFinancialSummary() {
    final periodSales = sales
        .where(
          (sale) =>
              sale.saleDate.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              sale.saleDate.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList();

    final periodExpenses = expenses
        .where(
          (expense) =>
              expense.expenseDate.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              expense.expenseDate.isBefore(
                endDate.add(const Duration(days: 1)),
              ),
        )
        .toList();

    final totalRevenue = periodSales.fold<double>(
      0.0,
      (sum, sale) => sum + sale.totalAmount,
    );
    final totalExpenses = periodExpenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
    final netProfit = totalRevenue - totalExpenses;
    final profitMargin = totalRevenue > 0
        ? (netProfit / totalRevenue) * 100.0
        : 0.0;
    final totalCapital = capitals.fold<double>(
      0.0,
      (sum, capital) => sum + capital.amount,
    );
    final totalStockValue = stocks.fold<double>(
      0.0,
      (sum, stock) => sum + stock.totalValue,
    );

    return {
      'totalRevenue': totalRevenue,
      'totalExpenses': totalExpenses,
      'netProfit': netProfit,
      'profitMargin': profitMargin,
      'totalCapital': totalCapital,
      'totalStockValue': totalStockValue,
      'salesCount': periodSales.length,
      'expensesCount': periodExpenses.length,
    };
  }

  Map<String, dynamic> _getSalesAnalysis() {
    final periodSales = sales
        .where(
          (sale) =>
              sale.saleDate.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              sale.saleDate.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList();

    final totalSales = periodSales.fold<double>(
      0.0,
      (sum, sale) => sum + sale.totalAmount,
    );
    final paidSales = periodSales
        .where((sale) => sale.paymentStatus == 'paid')
        .toList();
    final creditSales = periodSales
        .where((sale) => sale.paymentStatus == 'credit')
        .toList();
    final partialSales = periodSales
        .where((sale) => sale.paymentStatus == 'partial')
        .toList();

    final totalPaid = paidSales.fold<double>(
      0.0,
      (sum, sale) => sum + sale.amountPaid,
    );
    final totalCredit = creditSales.fold<double>(
      0.0,
      (sum, sale) => sum + sale.totalAmount,
    );
    final totalPartial = partialSales.fold<double>(
      0.0,
      (sum, sale) => sum + sale.amountPaid,
    );

    // Payment method breakdown
    final cashSales = periodSales
        .where((sale) => sale.paymentMethod == 'cash')
        .length;
    final cardSales = periodSales
        .where((sale) => sale.paymentMethod == 'card')
        .length;
    final bankSales = periodSales
        .where((sale) => sale.paymentMethod == 'bank_transfer')
        .length;

    return {
      'totalSales': totalSales,
      'totalPaid': totalPaid,
      'totalCredit': totalCredit,
      'totalPartial': totalPartial,
      'salesCount': periodSales.length,
      'paidCount': paidSales.length,
      'creditCount': creditSales.length,
      'partialCount': partialSales.length,
      'cashSales': cashSales,
      'cardSales': cardSales,
      'bankSales': bankSales,
    };
  }

  Map<String, dynamic> _getExpenseBreakdown() {
    final periodExpenses = expenses
        .where(
          (expense) =>
              expense.expenseDate.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              expense.expenseDate.isBefore(
                endDate.add(const Duration(days: 1)),
              ),
        )
        .toList();

    final totalExpenses = periodExpenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    // Category breakdown
    final categoryMap = <String, double>{};
    for (final expense in periodExpenses) {
      categoryMap[expense.category] =
          (categoryMap[expense.category] ?? 0.0) + expense.amount;
    }

    // Payment method breakdown
    final cashExpenses = periodExpenses
        .where((expense) => expense.paymentMethod == 'cash')
        .length;
    final cardExpenses = periodExpenses
        .where((expense) => expense.paymentMethod == 'card')
        .length;
    final bankExpenses = periodExpenses
        .where((expense) => expense.paymentMethod == 'bank_transfer')
        .length;

    return {
      'totalExpenses': totalExpenses,
      'expensesCount': periodExpenses.length,
      'categoryBreakdown': categoryMap,
      'cashExpenses': cashExpenses,
      'cardExpenses': cardExpenses,
      'bankExpenses': bankExpenses,
    };
  }

  Map<String, dynamic> _getInventoryReport() {
    final totalItems = stocks.length;
    final totalValue = stocks.fold<double>(
      0.0,
      (sum, stock) => sum + stock.totalValue,
    );
    final totalCost = stocks.fold<double>(
      0.0,
      (sum, stock) => sum + (stock.quantity * stock.unitCostPrice),
    );
    final totalSellingValue = stocks.fold<double>(
      0.0,
      (sum, stock) => sum + (stock.quantity * stock.unitSellingPrice),
    );
    final lowStockItems = stocks
        .where((stock) => stock.quantity <= stock.reorderLevel)
        .length;

    // Category breakdown
    final categoryMap = <String, int>{};
    for (final stock in stocks) {
      categoryMap[stock.category] = (categoryMap[stock.category] ?? 0) + 1;
    }

    return {
      'totalItems': totalItems,
      'totalValue': totalValue,
      'totalCost': totalCost,
      'totalSellingValue': totalSellingValue,
      'lowStockItems': lowStockItems,
      'categoryBreakdown': categoryMap,
    };
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
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: GlassmorphismTheme.primaryColor,
                          ),
                        )
                      : _buildReportsContent(),
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
          const Text(
            'Business Reports',
            style: TextStyle(
              color: GlassmorphismTheme.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _refreshData,
            icon: const Icon(
              Icons.refresh,
              color: GlassmorphismTheme.primaryColor,
            ),
          ),
          IconButton(
            onPressed: _exportReport,
            icon: const Icon(
              Icons.download,
              color: GlassmorphismTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsContent() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: GlassmorphismTheme.primaryColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportTypeSelector(),
            const SizedBox(height: 16),
            _buildDateRangeSelector(),
            const SizedBox(height: 24),
            _buildSelectedReport(),
            const SizedBox(height: 24),
            _buildChartsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeSelector() {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report Type',
            style: TextStyle(
              color: GlassmorphismTheme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: reportTypes.length,
              itemBuilder: (context, index) {
                final isSelected = selectedReportType == reportTypes[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedReportType = reportTypes[index];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? GlassmorphismTheme.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? GlassmorphismTheme.primaryColor
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      reportTypes[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : GlassmorphismTheme.textColor,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date Range',
            style: TextStyle(
              color: GlassmorphismTheme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start Date',
                      style: TextStyle(
                        color: GlassmorphismTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2020),
                          lastDate: endDate,
                        );
                        if (date != null) {
                          setState(() {
                            startDate = date;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: GlassmorphismTheme.surfaceColor.withOpacity(
                            0.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: GlassmorphismTheme.primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('MMM dd, yyyy').format(startDate),
                              style: const TextStyle(
                                color: GlassmorphismTheme.textColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'End Date',
                      style: TextStyle(
                        color: GlassmorphismTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: startDate,
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            endDate = date;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: GlassmorphismTheme.surfaceColor.withOpacity(
                            0.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: GlassmorphismTheme.primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('MMM dd, yyyy').format(endDate),
                              style: const TextStyle(
                                color: GlassmorphismTheme.textColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _generateProfitReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: GlassmorphismTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Generate Report'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedReport() {
    switch (selectedReportType) {
      case 'Financial Summary':
        return _buildFinancialSummary();
      case 'Sales Analysis':
        return _buildSalesAnalysis();
      case 'Expense Breakdown':
        return _buildExpenseBreakdown();
      case 'Inventory Report':
        return _buildInventoryReport();
      case 'Cash Flow':
        return _buildCashFlow();
      case 'Performance Metrics':
        return _buildPerformanceMetrics();
      default:
        return _buildFinancialSummary();
    }
  }

  Widget _buildFinancialSummary() {
    final summary = _getFinancialSummary();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Financial Summary', Icons.assessment),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Revenue',
                '\$${NumberFormat('#,##0.00').format(summary['totalRevenue'])}',
                Icons.trending_up,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Total Expenses',
                '\$${NumberFormat('#,##0.00').format(summary['totalExpenses'])}',
                Icons.trending_down,
                Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Net Profit',
                '\$${NumberFormat('#,##0.00').format(summary['netProfit'])}',
                Icons.account_balance_wallet,
                summary['netProfit'] >= 0 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Profit Margin',
                '${summary['profitMargin'].toStringAsFixed(1)}%',
                Icons.percent,
                summary['profitMargin'] >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('Business Overview', Icons.business),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Capital',
                '\$${NumberFormat('#,##0.00').format(summary['totalCapital'])}',
                Icons.account_balance,
                GlassmorphismTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Stock Value',
                '\$${NumberFormat('#,##0.00').format(summary['totalStockValue'])}',
                Icons.inventory,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Sales Count',
                '${summary['salesCount']}',
                Icons.shopping_cart,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Expenses Count',
                '${summary['expensesCount']}',
                Icons.receipt,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSalesAnalysis() {
    final analysis = _getSalesAnalysis();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Sales Analysis', Icons.analytics),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Sales',
                '\$${NumberFormat('#,##0.00').format(analysis['totalSales'])}',
                Icons.point_of_sale,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Sales Count',
                '${analysis['salesCount']}',
                Icons.shopping_cart,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('Payment Status', Icons.payment),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Paid',
                '\$${NumberFormat('#,##0.00').format(analysis['totalPaid'])}',
                Icons.check_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Credit',
                '\$${NumberFormat('#,##0.00').format(analysis['totalCredit'])}',
                Icons.credit_card,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Partial',
                '\$${NumberFormat('#,##0.00').format(analysis['totalPartial'])}',
                Icons.pending,
                Colors.yellow,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Paid Count',
                '${analysis['paidCount']}',
                Icons.check_circle_outline,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('Payment Methods', Icons.payment),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Cash',
                '${analysis['cashSales']}',
                Icons.money,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Card',
                '${analysis['cardSales']}',
                Icons.credit_card,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Bank Transfer',
                '${analysis['bankSales']}',
                Icons.account_balance,
                Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }

  Widget _buildExpenseBreakdown() {
    final breakdown = _getExpenseBreakdown();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Expense Breakdown', Icons.receipt_long),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Expenses',
                '\$${NumberFormat('#,##0.00').format(breakdown['totalExpenses'])}',
                Icons.trending_down,
                Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Expenses Count',
                '${breakdown['expensesCount']}',
                Icons.receipt,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('Expense Categories', Icons.category),
        const SizedBox(height: 16),
        ...breakdown['categoryBreakdown'].entries
            .map((entry) => _buildCategoryCard(entry.key, entry.value))
            .toList(),
        const SizedBox(height: 24),
        _buildSectionHeader('Payment Methods', Icons.payment),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Cash',
                '${breakdown['cashExpenses']}',
                Icons.money,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Card',
                '${breakdown['cardExpenses']}',
                Icons.credit_card,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Bank Transfer',
                '${breakdown['bankExpenses']}',
                Icons.account_balance,
                Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }

  Widget _buildInventoryReport() {
    final inventory = _getInventoryReport();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Inventory Overview', Icons.inventory),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Items',
                '${inventory['totalItems']}',
                Icons.inventory_2,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Total Value',
                '\$${NumberFormat('#,##0.00').format(inventory['totalValue'])}',
                Icons.attach_money,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Cost',
                '\$${NumberFormat('#,##0.00').format(inventory['totalCost'])}',
                Icons.shopping_cart,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Selling Value',
                '\$${NumberFormat('#,##0.00').format(inventory['totalSellingValue'])}',
                Icons.trending_up,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Low Stock Items',
                '${inventory['lowStockItems']}',
                Icons.warning,
                Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Container()),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('Category Breakdown', Icons.category),
        const SizedBox(height: 16),
        ...inventory['categoryBreakdown'].entries
            .map(
              (entry) => _buildCategoryCard(entry.key, entry.value.toDouble()),
            )
            .toList(),
      ],
    );
  }

  Widget _buildCashFlow() {
    final summary = _getFinancialSummary();
    final analysis = _getSalesAnalysis();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Cash Flow Summary', Icons.account_balance_wallet),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Cash Inflow',
                '\$${NumberFormat('#,##0.00').format(analysis['totalPaid'])}',
                Icons.trending_up,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Cash Outflow',
                '\$${NumberFormat('#,##0.00').format(summary['totalExpenses'])}',
                Icons.trending_down,
                Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Net Cash Flow',
                '\$${NumberFormat('#,##0.00').format(analysis['totalPaid'] - summary['totalExpenses'])}',
                Icons.account_balance,
                (analysis['totalPaid'] - summary['totalExpenses']) >= 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Outstanding',
                '\$${NumberFormat('#,##0.00').format(analysis['totalCredit'])}',
                Icons.pending,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('Cash Position', Icons.account_balance),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Capital',
                '\$${NumberFormat('#,##0.00').format(summary['totalCapital'])}',
                Icons.account_balance,
                GlassmorphismTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Available Cash',
                '\$${NumberFormat('#,##0.00').format(summary['totalCapital'] + analysis['totalPaid'] - summary['totalExpenses'])}',
                Icons.money,
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPerformanceMetrics() {
    final summary = _getFinancialSummary();
    final analysis = _getSalesAnalysis();
    final inventory = _getInventoryReport();

    // Calculate performance metrics
    final avgSaleValue = analysis['salesCount'] > 0
        ? analysis['totalSales'] / analysis['salesCount']
        : 0.0;
    final avgExpenseValue = summary['expensesCount'] > 0
        ? summary['totalExpenses'] / summary['expensesCount']
        : 0.0;
    final collectionRate = analysis['totalSales'] > 0
        ? (analysis['totalPaid'] / analysis['totalSales']) * 100
        : 0.0;
    final inventoryTurnover = summary['totalExpenses'] > 0
        ? summary['totalRevenue'] / inventory['totalValue']
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Performance Metrics', Icons.analytics),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Avg Sale Value',
                '\$${NumberFormat('#,##0.00').format(avgSaleValue)}',
                Icons.assessment,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Avg Expense',
                '\$${NumberFormat('#,##0.00').format(avgExpenseValue)}',
                Icons.receipt,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Collection Rate',
                '${collectionRate.toStringAsFixed(1)}%',
                Icons.payment,
                collectionRate >= 80 ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Inventory Turnover',
                '${inventoryTurnover.toStringAsFixed(2)}x',
                Icons.inventory,
                inventoryTurnover >= 1 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('Efficiency Ratios', Icons.trending_up),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Profit Margin',
                '${summary['profitMargin'].toStringAsFixed(1)}%',
                Icons.percent,
                summary['profitMargin'] >= 20 ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'ROI',
                '${summary['totalCapital'] > 0 ? (summary['netProfit'] / summary['totalCapital'] * 100).toStringAsFixed(1) : '0.0'}%',
                Icons.trending_up,
                summary['totalCapital'] > 0 &&
                        (summary['netProfit'] /
                                summary['totalCapital'] *
                                100) >=
                            10
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: GlassmorphismTheme.primaryColor, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: GlassmorphismTheme.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
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
            value,
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

  Widget _buildCategoryCard(String category, double value) {
    return GlassmorphismTheme.glassmorphismContainer(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: GlassmorphismTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.category,
              color: GlassmorphismTheme.primaryColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: GlassmorphismTheme.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${NumberFormat('#,##0.00').format(value)}',
                  style: const TextStyle(
                    color: GlassmorphismTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    final summary = _getFinancialSummary();
    final analysis = _getSalesAnalysis();
    final breakdown = _getExpenseBreakdown();
    final inventory = _getInventoryReport();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Visual Analytics', Icons.analytics),
        const SizedBox(height: 16),

        // Revenue vs Expenses Chart
        if (summary['totalRevenue'] > 0 || summary['totalExpenses'] > 0)
          ChartWidget(
            title: 'Revenue vs Expenses',
            type: ChartType.bar,
            data: {
              'Revenue': summary['totalRevenue'],
              'Expenses': summary['totalExpenses'],
            },
            height: 200,
          ),

        const SizedBox(height: 16),

        // Payment Methods Chart
        if (analysis['cashSales'] > 0 ||
            analysis['cardSales'] > 0 ||
            analysis['bankSales'] > 0)
          ChartWidget(
            title: 'Payment Methods',
            type: ChartType.pie,
            data: {
              'Cash': analysis['cashSales'].toDouble(),
              'Card': analysis['cardSales'].toDouble(),
              'Bank': analysis['bankSales'].toDouble(),
            },
            height: 200,
          ),

        const SizedBox(height: 16),

        // Expense Categories Chart
        if (breakdown['categoryBreakdown'].isNotEmpty)
          ChartWidget(
            title: 'Expense Categories',
            type: ChartType.doughnut,
            data: breakdown['categoryBreakdown'],
            height: 200,
          ),

        const SizedBox(height: 16),

        // Inventory Categories Chart
        if (inventory['categoryBreakdown'].isNotEmpty)
          ChartWidget(
            title: 'Inventory by Category',
            type: ChartType.pie,
            data: Map<String, double>.fromEntries(
              (inventory['categoryBreakdown'] as Map<String, int>).entries.map(
                (entry) => MapEntry(entry.key, entry.value.toDouble()),
              ),
            ),
            height: 200,
          ),
      ],
    );
  }
}
