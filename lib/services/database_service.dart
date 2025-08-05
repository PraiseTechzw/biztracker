import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/business_data.dart';
import '../models/business_profile.dart';

class DatabaseService {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      CapitalSchema,
      StockSchema,
      SaleSchema,
      ExpenseSchema,
      ProfitSchema,
      BusinessProfileSchema,
    ], directory: dir.path);
  }

  static Future<void> close() async {
    await isar.close();
  }

  // Capital operations
  static Future<void> addCapital(Capital capital) async {
    await isar.writeTxn(() async {
      await isar.capitals.put(capital);
    });
  }

  static Future<List<Capital>> getAllCapitals() async {
    return await isar.capitals.where().sortByDateDesc().findAll();
  }

  static Future<double> getTotalCapital() async {
    final capitals = await getAllCapitals();
    return capitals.fold<double>(0.0, (sum, capital) => sum + capital.amount);
  }

  // Stock operations
  static Future<void> addStock(Stock stock) async {
    await isar.writeTxn(() async {
      await isar.stocks.put(stock);
    });
  }

  static Future<List<Stock>> getAllStocks() async {
    return await isar.stocks.where().sortByCreatedAtDesc().findAll();
  }

  static Future<void> updateStock(Stock stock) async {
    await isar.writeTxn(() async {
      await isar.stocks.put(stock);
    });
  }

  static Future<void> deleteStock(int id) async {
    await isar.writeTxn(() async {
      await isar.stocks.delete(id);
    });
  }

  static Future<double> getTotalStockValue() async {
    final stocks = await getAllStocks();
    return stocks.fold<double>(0.0, (sum, stock) => sum + stock.totalValue);
  }

  // Enhanced Stock operations
  static Future<List<Stock>> getStocksByCategory(String category) async {
    return await isar.stocks.filter().categoryEqualTo(category).findAll();
  }

  static Future<List<Stock>> getLowStockItems() async {
    final stocks = await getAllStocks();
    return stocks
        .where((stock) => stock.quantity <= stock.reorderLevel)
        .toList();
  }

  static Future<int> getLowStockCount() async {
    final lowStockItems = await getLowStockItems();
    return lowStockItems.length;
  }

  static Future<double> getTotalStockCost() async {
    final stocks = await getAllStocks();
    return stocks.fold<double>(
      0.0,
      (sum, stock) => sum + (stock.quantity * stock.unitCostPrice),
    );
  }

  static Future<double> getTotalStockSellingValue() async {
    final stocks = await getAllStocks();
    return stocks.fold<double>(
      0.0,
      (sum, stock) => sum + (stock.quantity * stock.unitSellingPrice),
    );
  }

  static Future<List<String>> getStockCategories() async {
    final stocks = await getAllStocks();
    final categories = stocks.map((stock) => stock.category).toSet().toList();
    categories.sort();
    return categories;
  }

  static Future<Map<String, dynamic>> getStockStatistics() async {
    final stocks = await getAllStocks();
    final totalItems = stocks.length;
    final totalValue = stocks.fold<double>(
      0.0,
      (sum, stock) => sum + stock.totalValue,
    );
    final lowStockCount = stocks
        .where((stock) => stock.quantity <= stock.reorderLevel)
        .length;
    final categories = stocks.map((stock) => stock.category).toSet().length;

    return {
      'totalItems': totalItems,
      'totalValue': totalValue,
      'lowStockCount': lowStockCount,
      'categories': categories,
    };
  }

  // Sale operations
  static Future<void> addSale(Sale sale) async {
    await isar.writeTxn(() async {
      await isar.sales.put(sale);
    });
  }

  static Future<List<Sale>> getAllSales() async {
    return await isar.sales.where().sortBySaleDateDesc().findAll();
  }

  static Future<double> getTotalSales() async {
    final sales = await getAllSales();
    return sales.fold<double>(0.0, (sum, sale) => sum + sale.totalAmount);
  }

  // Expense operations
  static Future<void> addExpense(Expense expense) async {
    await isar.writeTxn(() async {
      await isar.expenses.put(expense);
    });
  }

  static Future<List<Expense>> getAllExpenses() async {
    return await isar.expenses.where().sortByExpenseDateDesc().findAll();
  }

  static Future<double> getTotalExpenses() async {
    final expenses = await getAllExpenses();
    return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }

  // Profit calculations
  static Future<Profit> calculateProfit(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final sales = await isar.sales
        .filter()
        .saleDateBetween(startDate, endDate)
        .findAll();

    final expenses = await isar.expenses
        .filter()
        .expenseDateBetween(startDate, endDate)
        .findAll();

    final revenue = sales.fold<double>(
      0.0,
      (sum, sale) => sum + sale.totalAmount,
    );
    final totalExpenses = expenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
    final netProfit = revenue - totalExpenses;
    final profitMargin = revenue > 0 ? (netProfit / revenue) * 100.0 : 0.0;

    return Profit()
      ..revenue = revenue
      ..expenses = totalExpenses
      ..netProfit = netProfit
      ..profitMargin = profitMargin
      ..periodStart = startDate
      ..periodEnd = endDate
      ..createdAt = DateTime.now();
  }

  static Future<void> saveProfit(Profit profit) async {
    await isar.writeTxn(() async {
      await isar.profits.put(profit);
    });
  }

  static Future<List<Profit>> getAllProfits() async {
    return await isar.profits.where().sortByCreatedAtDesc().findAll();
  }

  // Business Profile operations
  static Future<void> saveBusinessProfile(BusinessProfile profile) async {
    await isar.writeTxn(() async {
      await isar.businessProfiles.put(profile);
    });
  }

  static Future<BusinessProfile?> getBusinessProfile() async {
    final profiles = await isar.businessProfiles.where().findAll();
    return profiles.isNotEmpty ? profiles.first : null;
  }

  static Future<void> updateBusinessProfile(BusinessProfile profile) async {
    await isar.writeTxn(() async {
      await isar.businessProfiles.put(profile);
    });
  }

  static Future<void> deleteBusinessProfile(int id) async {
    await isar.writeTxn(() async {
      await isar.businessProfiles.delete(id);
    });
  }

  static Future<bool> hasBusinessProfile() async {
    final profiles = await isar.businessProfiles.where().findAll();
    return profiles.isNotEmpty;
  }

  // Enhanced reporting methods
  static Future<List<Sale>> getSalesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await isar.sales
        .filter()
        .saleDateBetween(startDate, endDate)
        .sortBySaleDateDesc()
        .findAll();
  }

  static Future<List<Expense>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await isar.expenses
        .filter()
        .expenseDateBetween(startDate, endDate)
        .sortByExpenseDateDesc()
        .findAll();
  }

  static Future<Map<String, double>> getExpensesByCategory(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final expenses = await getExpensesByDateRange(startDate, endDate);
    final categoryMap = <String, double>{};

    for (final expense in expenses) {
      categoryMap[expense.category] =
          (categoryMap[expense.category] ?? 0.0) + expense.amount;
    }

    return categoryMap;
  }

  static Future<Map<String, int>> getSalesByPaymentMethod(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final sales = await getSalesByDateRange(startDate, endDate);
    final methodMap = <String, int>{};

    for (final sale in sales) {
      methodMap[sale.paymentMethod] = (methodMap[sale.paymentMethod] ?? 0) + 1;
    }

    return methodMap;
  }

  static Future<Map<String, double>> getSalesByProduct(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final sales = await getSalesByDateRange(startDate, endDate);
    final productMap = <String, double>{};

    for (final sale in sales) {
      productMap[sale.productName] =
          (productMap[sale.productName] ?? 0.0) + sale.totalAmount;
    }

    return productMap;
  }

  static Future<double> getTotalOutstandingCredit() async {
    final sales = await getAllSales();
    return sales
        .where((sale) => sale.paymentStatus == 'credit')
        .fold<double>(
          0.0,
          (sum, sale) => sum + (sale.totalAmount - sale.amountPaid),
        );
  }

  static Future<int> getTotalCustomers() async {
    final sales = await getAllSales();
    final customers = sales.map((sale) => sale.customerName).toSet();
    return customers.length;
  }

  static Future<Map<String, dynamic>> getBusinessMetrics() async {
    final totalSales = await getTotalSales();
    final totalExpenses = await getTotalExpenses();
    final totalCapital = await getTotalCapital();
    final totalStockValue = await getTotalStockValue();
    final totalOutstandingCredit = await getTotalOutstandingCredit();
    final totalCustomers = await getTotalCustomers();
    final lowStockCount = await getLowStockCount();

    return {
      'totalSales': totalSales,
      'totalExpenses': totalExpenses,
      'totalCapital': totalCapital,
      'totalStockValue': totalStockValue,
      'totalOutstandingCredit': totalOutstandingCredit,
      'totalCustomers': totalCustomers,
      'lowStockCount': lowStockCount,
      'netProfit': totalSales - totalExpenses,
      'profitMargin': totalSales > 0
          ? ((totalSales - totalExpenses) / totalSales) * 100
          : 0.0,
    };
  }
}
