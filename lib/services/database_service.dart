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

  // Achievement tracking
  static Future<bool> hasShownFirstSaleAchievement() async {
    final profile = await getBusinessProfile();
    return profile?.hasShownFirstSaleAchievement ?? false;
  }

  static Future<void> markFirstSaleAchievementAsShown() async {
    final profile = await getBusinessProfile();
    if (profile != null) {
      profile.hasShownFirstSaleAchievement = true;
      await updateBusinessProfile(profile);
    }
  }

  static Future<bool> hasShownProfitMilestoneAchievement() async {
    final profile = await getBusinessProfile();
    return profile?.hasShownProfitMilestoneAchievement ?? false;
  }

  static Future<void> markProfitMilestoneAchievementAsShown() async {
    final profile = await getBusinessProfile();
    if (profile != null) {
      profile.hasShownProfitMilestoneAchievement = true;
      await updateBusinessProfile(profile);
    }
  }

  // Capital operations
  static Future<void> addCapital(Capital capital) async {
    await isar.writeTxn(() async {
      await isar.capitals.put(capital);
    });
  }

  static Future<void> updateCapital(Capital capital) async {
    await isar.writeTxn(() async {
      await isar.capitals.put(capital);
    });
  }

  static Future<void> deleteCapital(Id capitalId) async {
    await isar.writeTxn(() async {
      await isar.capitals.delete(capitalId);
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

  // Inventory management with barcode support
  static Future<void> updateStockQuantityByBarcode(
    String barcode,
    double newQuantity,
  ) async {
    final stock = await getStockByBarcode(barcode);
    if (stock != null) {
      stock.quantity = newQuantity;
      stock.totalValue = newQuantity * stock.unitCostPrice;
      stock.updatedAt = DateTime.now();
      await updateStock(stock);
    }
  }

  static Future<void> addStockQuantityByBarcode(
    String barcode,
    double quantityToAdd,
  ) async {
    final stock = await getStockByBarcode(barcode);
    if (stock != null) {
      stock.quantity += quantityToAdd;
      stock.totalValue = stock.quantity * stock.unitCostPrice;
      stock.updatedAt = DateTime.now();
      await updateStock(stock);
    }
  }

  static Future<void> removeStockQuantityByBarcode(
    String barcode,
    double quantityToRemove,
  ) async {
    final stock = await getStockByBarcode(barcode);
    if (stock != null && stock.quantity >= quantityToRemove) {
      stock.quantity -= quantityToRemove;
      stock.totalValue = stock.quantity * stock.unitCostPrice;
      stock.updatedAt = DateTime.now();
      await updateStock(stock);
    }
  }

  static Future<List<Stock>> getStocksNeedingReorder() async {
    final stocks = await getAllStocks();
    return stocks
        .where((stock) => stock.quantity <= stock.reorderLevel)
        .toList();
  }

  static Future<Map<String, dynamic>> getInventoryReportByBarcode() async {
    final stocks = await getAllStocks();
    final barcodeStocks = stocks
        .where((stock) => stock.barcode != null && stock.barcode!.isNotEmpty)
        .toList();

    final totalBarcodeItems = barcodeStocks.length;
    final totalValue = barcodeStocks.fold<double>(
      0.0,
      (sum, stock) => sum + stock.totalValue,
    );
    final lowStockBarcodeItems = barcodeStocks
        .where((stock) => stock.quantity <= stock.reorderLevel)
        .length;

    return {
      'totalBarcodeItems': totalBarcodeItems,
      'totalValue': totalValue,
      'lowStockBarcodeItems': lowStockBarcodeItems,
      'barcodeCoverage': stocks.isNotEmpty
          ? (totalBarcodeItems / stocks.length) * 100
          : 0.0,
    };
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

  // Barcode operations for Stock
  static Future<Stock?> getStockByBarcode(String barcode) async {
    final stocks = await getAllStocks();
    try {
      return stocks.firstWhere((stock) => stock.barcode == barcode);
    } catch (e) {
      return null;
    }
  }

  static Future<List<Stock>> searchStocksByBarcode(String barcode) async {
    final stocks = await getAllStocks();
    return stocks
        .where(
          (stock) =>
              stock.barcode != null &&
              stock.barcode!.toLowerCase().contains(barcode.toLowerCase()),
        )
        .toList();
  }

  static Future<bool> isBarcodeExists(String barcode) async {
    final stock = await getStockByBarcode(barcode);
    return stock != null;
  }

  static Future<List<String>> getAllBarcodes() async {
    final stocks = await getAllStocks();
    return stocks
        .where((stock) => stock.barcode != null && stock.barcode!.isNotEmpty)
        .map((stock) => stock.barcode!)
        .toList();
  }

  static Future<Map<String, Stock>> getStocksByBarcodes(
    List<String> barcodes,
  ) async {
    final stocks = await getAllStocks();
    final stockMap = <String, Stock>{};

    for (final stock in stocks) {
      if (stock.barcode != null && barcodes.contains(stock.barcode)) {
        stockMap[stock.barcode!] = stock;
      }
    }

    return stockMap;
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

  static Future<void> updateSale(Sale sale) async {
    await isar.writeTxn(() async {
      await isar.sales.put(sale);
    });
  }

  static Future<void> deleteSale(Id saleId) async {
    await isar.writeTxn(() async {
      await isar.sales.delete(saleId);
    });
  }

  static Future<List<Sale>> getAllSales() async {
    return await isar.sales.where().sortBySaleDateDesc().findAll();
  }

  static Future<List<Sale>> getSalesByCustomer(String customerName) async {
    return await isar.sales
        .filter()
        .customerNameEqualTo(customerName)
        .sortBySaleDateDesc()
        .findAll();
  }

  // Barcode operations for Sales
  static Future<List<Sale>> getSalesByProductBarcode(String barcode) async {
    final stock = await getStockByBarcode(barcode);
    if (stock != null) {
      return await isar.sales
          .filter()
          .productNameEqualTo(stock.name)
          .sortBySaleDateDesc()
          .findAll();
    }
    return [];
  }

  static Future<Map<String, dynamic>> getSalesAnalyticsByBarcode(
    String barcode,
  ) async {
    final stock = await getStockByBarcode(barcode);
    if (stock == null) {
      return {
        'totalSales': 0.0,
        'totalQuantity': 0.0,
        'totalRevenue': 0.0,
        'averagePrice': 0.0,
        'salesCount': 0,
      };
    }

    final sales = await isar.sales
        .filter()
        .productNameEqualTo(stock.name)
        .findAll();

    final totalQuantity = sales.fold<double>(
      0.0,
      (sum, sale) => sum + sale.quantity,
    );
    final totalRevenue = sales.fold<double>(
      0.0,
      (sum, sale) => sum + sale.totalAmount,
    );
    final averagePrice = totalQuantity > 0 ? totalRevenue / totalQuantity : 0.0;

    return {
      'totalSales': totalQuantity,
      'totalQuantity': totalQuantity,
      'totalRevenue': totalRevenue,
      'averagePrice': averagePrice,
      'salesCount': sales.length,
      'stockInfo': {
        'name': stock.name,
        'currentQuantity': stock.quantity,
        'unitPrice': stock.unitSellingPrice,
        'category': stock.category,
      },
    };
  }

  static Future<List<Map<String, dynamic>>>
  getTopSellingProductsByBarcode() async {
    final stocks = await getAllStocks();
    final topProducts = <Map<String, dynamic>>[];

    for (final stock in stocks) {
      if (stock.barcode != null && stock.barcode!.isNotEmpty) {
        final analytics = await getSalesAnalyticsByBarcode(stock.barcode!);
        if (analytics['totalQuantity'] > 0) {
          topProducts.add({
            'barcode': stock.barcode,
            'name': stock.name,
            'totalQuantity': analytics['totalQuantity'],
            'totalRevenue': analytics['totalRevenue'],
            'currentStock': stock.quantity,
          });
        }
      }
    }

    // Sort by total quantity sold
    topProducts.sort(
      (a, b) => (b['totalQuantity'] as double).compareTo(
        a['totalQuantity'] as double,
      ),
    );
    return topProducts.take(10).toList();
  }

  static Future<List<Sale>> getCreditSales() async {
    final allSales = await getAllSales();
    return allSales
        .where((sale) => sale.totalAmount > sale.amountPaid)
        .toList();
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

  static Future<void> updateExpense(Expense expense) async {
    await isar.writeTxn(() async {
      await isar.expenses.put(expense);
    });
  }

  static Future<void> deleteExpense(Id expenseId) async {
    await isar.writeTxn(() async {
      await isar.expenses.delete(expenseId);
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
    final inventoryReport = await getInventoryReportByBarcode();

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
      'barcodeMetrics': inventoryReport,
    };
  }

  // Barcode utility functions
  static bool isValidBarcode(String barcode) {
    // Basic validation for common barcode formats
    if (barcode.isEmpty) return false;

    // Check for common barcode patterns
    final patterns = [
      RegExp(r'^\d{8,14}$'), // EAN-8, EAN-13, UPC
      RegExp(r'^\d{12}$'), // UPC-A
      RegExp(r'^\d{13}$'), // EAN-13
      RegExp(r'^[A-Z0-9]{8,}$'), // Code 128, Code 39
    ];

    return patterns.any((pattern) => pattern.hasMatch(barcode));
  }

  static Future<Map<String, dynamic>> getBarcodeStatistics() async {
    final stocks = await getAllStocks();
    final barcodeStocks = stocks
        .where((stock) => stock.barcode != null && stock.barcode!.isNotEmpty)
        .toList();

    final barcodeCategories = <String, int>{};
    for (final stock in barcodeStocks) {
      barcodeCategories[stock.category] =
          (barcodeCategories[stock.category] ?? 0) + 1;
    }

    final barcodeLengths = <int, int>{};
    for (final stock in barcodeStocks) {
      final length = stock.barcode!.length;
      barcodeLengths[length] = (barcodeLengths[length] ?? 0) + 1;
    }

    return {
      'totalItems': stocks.length,
      'itemsWithBarcode': barcodeStocks.length,
      'barcodeCoverage': stocks.isNotEmpty
          ? (barcodeStocks.length / stocks.length) * 100
          : 0.0,
      'barcodeCategories': barcodeCategories,
      'barcodeLengths': barcodeLengths,
      'uniqueBarcodes': barcodeStocks.map((s) => s.barcode!).toSet().length,
    };
  }

  static Future<List<Stock>> getDuplicateBarcodes() async {
    final stocks = await getAllStocks();
    final barcodeMap = <String, List<Stock>>{};

    for (final stock in stocks) {
      if (stock.barcode != null && stock.barcode!.isNotEmpty) {
        barcodeMap.putIfAbsent(stock.barcode!, () => []).add(stock);
      }
    }

    return barcodeMap.values
        .where((stocks) => stocks.length > 1)
        .expand((stocks) => stocks)
        .toList();
  }

  static Future<void> validateAndCleanBarcodes() async {
    final stocks = await getAllStocks();
    final invalidStocks = <Stock>[];

    for (final stock in stocks) {
      if (stock.barcode != null && stock.barcode!.isNotEmpty) {
        if (!isValidBarcode(stock.barcode!)) {
          invalidStocks.add(stock);
        }
      }
    }

    // You can implement cleaning logic here
    // For now, just log invalid barcodes
    if (invalidStocks.isNotEmpty) {
      print('Found ${invalidStocks.length} stocks with invalid barcodes');
    }
  }
}
