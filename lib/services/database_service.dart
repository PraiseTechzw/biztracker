import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/business_data.dart';

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
}
