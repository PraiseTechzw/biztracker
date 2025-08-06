import 'database_service.dart';

class AnalyticsService {
  // Get business summary
  static Future<Map<String, double>> getBusinessSummary() async {
    final capital = await DatabaseService.getTotalCapital();
    final stockValue = await DatabaseService.getTotalStockValue();
    final sales = await DatabaseService.getTotalSales();
    final expenses = await DatabaseService.getTotalExpenses();
    final netProfit = sales - expenses;

    return {
      'totalCapital': capital,
      'totalStockValue': stockValue,
      'totalSales': sales,
      'totalExpenses': expenses,
      'netProfit': netProfit,
      'profitMargin': sales > 0 ? (netProfit / sales) * 100 : 0,
    };
  }

    // Get monthly trends
  static Future<Map<String, dynamic>> getMonthlyTrends() async {
    final now = DateTime.now();
    final months = <String>[];
    final salesData = <double>[];
    final expensesData = <double>[];
    final profitData = <double>[];

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      months.add('${month.month}/${month.year}');
      
      final startDate = DateTime(month.year, month.month, 1);
      final endDate = DateTime(month.year, month.month + 1, 0);
      
      final profit = await DatabaseService.calculateProfit(startDate, endDate);
      
      salesData.add(profit.revenue);
      expensesData.add(profit.expenses);
      profitData.add(profit.netProfit);
    }

    return {
      'months': months,
      'sales': salesData,
      'expenses': expensesData,
      'profit': profitData,
    };
  }

  // Get top selling products
  static Future<List<Map<String, dynamic>>> getTopSellingProducts() async {
    final sales = await DatabaseService.getAllSales();
    final productSales = <String, double>{};

    for (final sale in sales) {
      productSales[sale.productName] =
          (productSales[sale.productName] ?? 0) + sale.totalAmount;
    }

    final sortedProducts = productSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedProducts
        .take(5)
        .map((entry) => {'productName': entry.key, 'totalSales': entry.value})
        .toList();
  }

  // Get expense categories breakdown
  static Future<List<Map<String, dynamic>>> getExpenseCategories() async {
    final expenses = await DatabaseService.getAllExpenses();
    final categoryExpenses = <String, double>{};

    for (final expense in expenses) {
      categoryExpenses[expense.category] =
          (categoryExpenses[expense.category] ?? 0) + expense.amount;
    }

    final sortedCategories = categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedCategories
        .map((entry) => {'category': entry.key, 'totalAmount': entry.value})
        .toList();
  }

  // Calculate business health score
  static Future<double> getBusinessHealthScore() async {
    final summary = await getBusinessSummary();

    double score = 0;

    // Profit margin (40% weight)
    final profitMargin = summary['profitMargin']!;
    if (profitMargin > 20) {
      score += 40;
    } else if (profitMargin > 10)
      score += 30;
    else if (profitMargin > 0)
      score += 20;
    else if (profitMargin > -10)
      score += 10;

    // Sales growth (30% weight)
    final sales = summary['totalSales']!;
    if (sales > 10000) {
      score += 30;
    } else if (sales > 5000)
      score += 20;
    else if (sales > 1000)
      score += 15;
    else if (sales > 0)
      score += 10;

    // Capital utilization (20% weight)
    final capital = summary['totalCapital']!;
    final stockValue = summary['totalStockValue']!;
    if (capital > 0) {
      final utilization = (stockValue / capital) * 100;
      if (utilization > 80) {
        score += 20;
      } else if (utilization > 60)
        score += 15;
      else if (utilization > 40)
        score += 10;
      else if (utilization > 20)
        score += 5;
    }

    // Expense control (10% weight)
    final expenses = summary['totalExpenses']!;
    if (sales > 0) {
      final expenseRatio = (expenses / sales) * 100;
      if (expenseRatio < 50) {
        score += 10;
      } else if (expenseRatio < 70)
        score += 7;
      else if (expenseRatio < 90)
        score += 5;
      else if (expenseRatio < 110)
        score += 2;
    }

    return score;
  }

  // Get business insights
  static Future<List<String>> getBusinessInsights() async {
    final insights = <String>[];
    final summary = await getBusinessSummary();

    final profitMargin = summary['profitMargin']!;
    final sales = summary['totalSales']!;
    final expenses = summary['totalExpenses']!;
    final capital = summary['totalCapital']!;

    if (profitMargin < 0) {
      insights.add(
        '⚠️ Your business is currently operating at a loss. Consider reducing expenses or increasing sales.',
      );
    } else if (profitMargin < 10) {
      insights.add(
        '📈 Your profit margin is low. Look for ways to increase revenue or reduce costs.',
      );
    } else if (profitMargin > 30) {
      insights.add(
        '🎉 Excellent profit margin! Your business is performing very well.',
      );
    }

    if (sales == 0) {
      insights.add(
        '🚀 No sales recorded yet. Start by adding your first sale to track revenue.',
      );
    } else if (sales < 1000) {
      insights.add(
        '💡 Consider marketing strategies to increase your sales volume.',
      );
    }

    if (expenses > sales * 0.8) {
      insights.add(
        '💰 Your expenses are high relative to sales. Review your cost structure.',
      );
    }

    if (capital == 0) {
      insights.add(
        '💼 Add your initial capital to get a complete view of your business finances.',
      );
    }

    return insights;
  }
}
