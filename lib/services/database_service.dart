import 'sqlite_database_service.dart';
import '../models/business_profile.dart';
import '../models/business_data_sqlite.dart';

/// Compatibility adapter exposing the legacy DatabaseService static API
/// while delegating to the new SQLiteDatabaseService implementation.
class DatabaseService {
  static final _db = SQLiteDatabaseService();

  // Business profile
  static Future<BusinessProfile?> getBusinessProfile() async {
    return _db.getFirstBusinessProfile();
  }

  static Future<int> saveBusinessProfile(BusinessProfile profile) async {
    if (profile.id != null) {
      return _db.updateBusinessProfile(profile);
    }
    return _db.insertBusinessProfile(profile);
  }

  static Future<void> clearBusinessProfile() => _db.clearBusinessProfile();

  // Capital
  static Future<int> addCapital(Capital capital) => _db.insertCapital(capital);
  static Future<List<Capital>> getAllCapitals() => _db.getAllCapitals();
  static Future<int> updateCapital(Capital capital) =>
      _db.updateCapital(capital);
  static Future<int> deleteCapital(int? id) => _db.deleteCapital(id);

  // Stock
  static Future<int> addStock(Stock stock) => _db.insertStock(stock);
  static Future<List<Stock>> getAllStocks() => _db.getAllStocks();
  static Future<int> updateStock(Stock stock) => _db.updateStock(stock);
  static Future<int> deleteStock(int? id) => _db.deleteStock(id);
  static Future<Stock?> getStockByBarcode(String barcode) =>
      _db.getStockByBarcode(barcode);

  // Sales
  static Future<int> addSale(Sale sale) => _db.addSale(sale);
  static Future<int> updateSale(Sale sale) => _db.updateSale(sale);
  static Future<int> deleteSale(int? id) => _db.deleteSale(id);
  static Future<List<Sale>> getAllSales() => _db.getAllSales();

  // Expenses
  static Future<int> addExpense(Expense expense) => _db.addExpense(expense);
  static Future<int> updateExpense(Expense expense) =>
      _db.updateExpense(expense);
  static Future<int> deleteExpense(int? id) => _db.deleteExpense(id);
  static Future<List<Expense>> getAllExpenses() => _db.getAllExpenses();

  // Profits
  static Future<int> saveProfit(Profit profit) => _db.saveProfit(profit);
  static Future<List<Profit>> getAllProfits() => _db.getAllProfits();
  static Future<Profit> calculateProfit(DateTime start, DateTime end) =>
      _db.calculateProfit(start, end);

  // Metrics & totals
  static Future<double> getTotalCapital() => _db.getTotalCapital();
  static Future<double> getTotalStockValue() => _db.getTotalStockValue();
  static Future<double> getTotalSales() => _db.getTotalSales();
  static Future<double> getTotalExpenses() => _db.getTotalExpenses();
  static Future<Map<String, dynamic>> getBusinessMetrics() =>
      _db.getBusinessMetrics();

  // App-level
  static Future<void> clearAllBusinessData() => _db.clearAllBusinessData();
  static Future<bool> hasCompleteBusinessProfile() =>
      _db.hasCompleteBusinessProfile();

  // Achievements flags
  static Future<bool> hasShownFirstSaleAchievement() =>
      _db.hasShownFirstSaleAchievement();
  static Future<void> markFirstSaleAchievementAsShown() =>
      _db.markFirstSaleAchievementAsShown();
  static Future<bool> hasShownProfitMilestoneAchievement() =>
      _db.hasShownProfitMilestoneAchievement();
  static Future<void> markProfitMilestoneAchievementAsShown() =>
      _db.markProfitMilestoneAchievementAsShown();
}
