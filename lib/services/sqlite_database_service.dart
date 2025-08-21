import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/business_profile.dart';
import '../models/business_data_sqlite.dart';

class SQLiteDatabaseService {
  static Database? _database;
  static const String _databaseName = 'biztracker.db';
  static const int _databaseVersion = 1;

  // Singleton pattern
  static final SQLiteDatabaseService _instance =
      SQLiteDatabaseService._internal();
  factory SQLiteDatabaseService() => _instance;
  SQLiteDatabaseService._internal();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // Business Profile table
    await db.execute('''
      CREATE TABLE business_profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        businessName TEXT NOT NULL,
        businessType TEXT NOT NULL,
        businessDescription TEXT,
        phoneNumber TEXT,
        email TEXT,
        website TEXT,
        address TEXT,
        city TEXT,
        state TEXT,
        country TEXT,
        postalCode TEXT,
        taxId TEXT,
        registrationNumber TEXT,
        industry TEXT,
        currency TEXT,
        ownerName TEXT,
        ownerPhone TEXT,
        ownerEmail TEXT,
        isActive INTEGER DEFAULT 1,
        logoPath TEXT,
        bannerPath TEXT,
        hasShownFirstSaleAchievement INTEGER DEFAULT 0,
        hasShownProfitMilestoneAchievement INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Capital table
    await db.execute('''
      CREATE TABLE capital (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        amount REAL NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Stock table
    await db.execute('''
      CREATE TABLE stock (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        barcode TEXT,
        supplierName TEXT,
        supplierContact TEXT,
        imagePath TEXT,
        quantity REAL NOT NULL,
        unitCostPrice REAL NOT NULL,
        unitSellingPrice REAL NOT NULL,
        totalValue REAL NOT NULL,
        reorderLevel REAL NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Sales table
    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productName TEXT NOT NULL,
        quantity REAL NOT NULL,
        unitPrice REAL NOT NULL,
        totalAmount REAL NOT NULL,
        amountPaid REAL NOT NULL,
        customerName TEXT NOT NULL,
        customerPhone TEXT NOT NULL,
        notes TEXT NOT NULL,
        paymentStatus TEXT NOT NULL,
        paymentMethod TEXT NOT NULL,
        dueDate TEXT,
        lastPaymentDate TEXT,
        saleDate TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Expenses table
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        paymentMethod TEXT NOT NULL,
        expenseDate TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Profits table
    await db.execute('''
      CREATE TABLE profits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        revenue REAL NOT NULL,
        expenses REAL NOT NULL,
        netProfit REAL NOT NULL,
        profitMargin REAL NOT NULL,
        periodStart TEXT NOT NULL,
        periodEnd TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Upgrade database
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Add new tables or modify existing ones
    }
  }

  // Business Profile operations
  Future<int> insertBusinessProfile(BusinessProfile profile) async {
    final db = await database;
    return await db.insert('business_profiles', profile.toMap());
  }

  Future<List<BusinessProfile>> getAllBusinessProfiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('business_profiles');
    return List.generate(maps.length, (i) => BusinessProfile.fromMap(maps[i]));
  }

  Future<BusinessProfile?> getBusinessProfile(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'business_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return BusinessProfile.fromMap(maps.first);
    }
    return null;
  }

  // Get the first business profile (for single-profile apps)
  Future<BusinessProfile?> getFirstBusinessProfile() async {
    final profiles = await getAllBusinessProfiles();
    if (profiles.isNotEmpty) {
      return profiles.first;
    }
    return null;
  }

  Future<int> updateBusinessProfile(BusinessProfile profile) async {
    final db = await database;
    return await db.update(
      'business_profiles',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  Future<int> deleteBusinessProfile(int id) async {
    final db = await database;
    return await db.delete(
      'business_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Capital operations
  Future<int> insertCapital(Capital capital) async {
    final db = await database;
    return await db.insert('capital', capital.toMap());
  }

  Future<List<Capital>> getAllCapital() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'capital',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Capital.fromMap(maps[i]));
  }

  // Alias for getAllCapital to match expected method name
  Future<List<Capital>> getAllCapitals() async {
    return getAllCapital();
  }

  Future<int> updateCapital(Capital capital) async {
    final db = await database;
    return await db.update(
      'capital',
      capital.toMap(),
      where: 'id = ?',
      whereArgs: [capital.id],
    );
  }

  Future<int> deleteCapital(int? id) async {
    if (id == null) return 0;
    final db = await database;
    return await db.delete('capital', where: 'id = ?', whereArgs: [id]);
  }

  // Stock operations
  Future<int> insertStock(Stock stock) async {
    final db = await database;
    return await db.insert('stock', stock.toMap());
  }

  Future<List<Stock>> getAllStock() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stock',
      orderBy: 'name',
    );
    return List.generate(maps.length, (i) => Stock.fromMap(maps[i]));
  }

  // Alias for getAllStock to match expected method name
  Future<List<Stock>> getAllStocks() async {
    return getAllStock();
  }

  Future<Stock?> getStockByBarcode(String barcode) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stock',
      where: 'barcode = ?',
      whereArgs: [barcode],
    );
    if (maps.isNotEmpty) {
      return Stock.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateStock(Stock stock) async {
    final db = await database;
    return await db.update(
      'stock',
      stock.toMap(),
      where: 'id = ?',
      whereArgs: [stock.id],
    );
  }

  Future<int> deleteStock(int? id) async {
    if (id == null) return 0;
    final db = await database;
    return await db.delete('stock', where: 'id = ?', whereArgs: [id]);
  }

  // Sales operations
  Future<int> insertSale(Sale sale) async {
    final db = await database;
    return await db.insert('sales', sale.toMap());
  }

  // Alias for insertSale to match expected method name
  Future<int> addSale(Sale sale) async {
    return insertSale(sale);
  }

  Future<List<Sale>> getAllSales() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sales',
      orderBy: 'saleDate DESC',
    );
    return List.generate(maps.length, (i) => Sale.fromMap(maps[i]));
  }

  Future<int> updateSale(Sale sale) async {
    final db = await database;
    return await db.update(
      'sales',
      sale.toMap(),
      where: 'id = ?',
      whereArgs: [sale.id],
    );
  }

  Future<int> deleteSale(int? id) async {
    if (id == null) return 0;
    final db = await database;
    return await db.delete('sales', where: 'id = ?', whereArgs: [id]);
  }

  // Expenses operations
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  // Alias for insertExpense to match expected method name
  Future<int> addExpense(Expense expense) async {
    return insertExpense(expense);
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      orderBy: 'expenseDate DESC',
    );
    return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int? id) async {
    if (id == null) return 0;
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // Profits operations
  Future<int> insertProfit(Profit profit) async {
    final db = await database;
    return await db.insert('profits', profit.toMap());
  }

  Future<List<Profit>> getAllProfits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'profits',
      orderBy: 'periodStart DESC',
    );
    return List.generate(maps.length, (i) => Profit.fromMap(maps[i]));
  }

  // Alias for insertProfit to match expected method name
  Future<int> saveProfit(Profit profit) async {
    return insertProfit(profit);
  }

  // Calculate profit for a given period
  Future<Profit> calculateProfit(DateTime startDate, DateTime endDate) async {
    final db = await database;

    // Get sales in period
    final salesResult = await db.rawQuery(
      'SELECT SUM(totalAmount) as total FROM sales WHERE saleDate BETWEEN ? AND ?',
      [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    // Get expenses in period
    final expensesResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE expenseDate BETWEEN ? AND ?',
      [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    final revenue = (salesResult.first['total'] as num?)?.toDouble() ?? 0.0;
    final expenses = (expensesResult.first['total'] as num?)?.toDouble() ?? 0.0;
    final netProfit = revenue - expenses;
    final profitMargin = revenue > 0 ? (netProfit / revenue) * 100 : 0.0;

    return Profit(
      revenue: revenue,
      expenses: expenses,
      netProfit: netProfit,
      profitMargin: profitMargin,
      periodStart: startDate,
      periodEnd: endDate,
    );
  }

  // Utility methods
  Future<bool> hasCompleteBusinessProfile() async {
    final profiles = await getAllBusinessProfiles();
    if (profiles.isEmpty) return false;

    final profile = profiles.first;
    return profile.businessName.isNotEmpty && profile.businessType.isNotEmpty;
  }

  // Dashboard summary methods
  Future<double> getTotalCapital() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM capital',
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTotalStockValue() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(totalValue) as total FROM stock',
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTotalSales() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(totalAmount) as total FROM sales',
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTotalExpenses() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses',
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // Achievement tracking methods
  Future<bool> hasShownFirstSaleAchievement() async {
    final profiles = await getAllBusinessProfiles();
    if (profiles.isEmpty) return false;
    return profiles.first.hasShownFirstSaleAchievement;
  }

  Future<void> markFirstSaleAchievementAsShown() async {
    final profiles = await getAllBusinessProfiles();
    if (profiles.isNotEmpty) {
      final profile = profiles.first;
      final db = await database;
      await db.update(
        'business_profiles',
        {'hasShownFirstSaleAchievement': 1},
        where: 'id = ?',
        whereArgs: [profile.id],
      );
    }
  }

  Future<bool> hasShownProfitMilestoneAchievement() async {
    final profiles = await getAllBusinessProfiles();
    if (profiles.isEmpty) return false;
    return profiles.first.hasShownProfitMilestoneAchievement;
  }

  Future<void> markProfitMilestoneAchievementAsShown() async {
    final profiles = await getAllBusinessProfiles();
    if (profiles.isNotEmpty) {
      final profile = profiles.first;
      final db = await database;
      await db.update(
        'business_profiles',
        {'hasShownProfitMilestoneAchievement': 1},
        where: 'id = ?',
        whereArgs: [profile.id],
      );
    }
  }

  // Alias for getAllCapital to match expected method name
  Future<List<Capital>> getAllCapitals() async {
    return getAllCapital();
  }

  // Business metrics for dashboard and settings
  Future<Map<String, dynamic>> getBusinessMetrics() async {
    final db = await database;

    // Get counts and totals
    final capitalResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM capital',
    );
    final stockResult = await db.rawQuery(
      'SELECT SUM(totalValue) as total FROM stock',
    );
    final salesResult = await db.rawQuery(
      'SELECT SUM(totalAmount) as total FROM sales',
    );
    final expensesResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses',
    );

    final totalCapital =
        (capitalResult.first['total'] as num?)?.toDouble() ?? 0.0;
    final totalStockValue =
        (stockResult.first['total'] as num?)?.toDouble() ?? 0.0;
    final totalSales = (salesResult.first['total'] as num?)?.toDouble() ?? 0.0;
    final totalExpenses =
        (expensesResult.first['total'] as num?)?.toDouble() ?? 0.0;

    return {
      'totalCapital': totalCapital,
      'totalStockValue': totalStockValue,
      'totalSales': totalSales,
      'totalExpenses': totalExpenses,
      'netWorth': totalCapital + totalStockValue,
      'profit': totalSales - totalExpenses,
    };
  }

  // Data management methods
  Future<void> clearAllBusinessData() async {
    final db = await database;
    await db.delete('capital');
    await db.delete('stock');
    await db.delete('sales');
    await db.delete('expenses');
    await db.delete('profits');
  }

  Future<void> clearBusinessProfile() async {
    final db = await database;
    await db.delete('business_profiles');
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
