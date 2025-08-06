import '../models/business_data.dart';

class SearchFilterUtils {
  // Search stocks by name, description, category, supplier, or barcode
  static List<Stock> searchStocks(List<Stock> stocks, String query) {
    if (query.isEmpty) return stocks;

    return stocks.where((stock) {
      final name = stock.name.toLowerCase();
      final description = stock.description.toLowerCase();
      final category = stock.category.toLowerCase();
      final supplierName = stock.supplierName?.toLowerCase() ?? '';
      final barcode = stock.barcode?.toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();

      return name.contains(searchQuery) ||
          description.contains(searchQuery) ||
          category.contains(searchQuery) ||
          supplierName.contains(searchQuery) ||
          barcode.contains(searchQuery);
    }).toList();
  }

  // Search sales by product name or customer name
  static List<Sale> searchSales(List<Sale> sales, String query) {
    if (query.isEmpty) return sales;

    return sales.where((sale) {
      final productName = sale.productName.toLowerCase();
      final customerName = sale.customerName.toLowerCase();
      final searchQuery = query.toLowerCase();

      return productName.contains(searchQuery) ||
          customerName.contains(searchQuery);
    }).toList();
  }

  // Search expenses by category or description
  static List<Expense> searchExpenses(List<Expense> expenses, String query) {
    if (query.isEmpty) return expenses;

    return expenses.where((expense) {
      final category = expense.category.toLowerCase();
      final description = expense.description.toLowerCase();
      final searchQuery = query.toLowerCase();

      return category.contains(searchQuery) ||
          description.contains(searchQuery);
    }).toList();
  }

  // Filter stocks by cost price range
  static List<Stock> filterStocksByCostPrice(
    List<Stock> stocks,
    double minPrice,
    double maxPrice,
  ) {
    return stocks.where((stock) {
      return stock.unitCostPrice >= minPrice && stock.unitCostPrice <= maxPrice;
    }).toList();
  }

  // Filter stocks by selling price range
  static List<Stock> filterStocksBySellingPrice(
    List<Stock> stocks,
    double minPrice,
    double maxPrice,
  ) {
    return stocks.where((stock) {
      return stock.unitSellingPrice >= minPrice &&
          stock.unitSellingPrice <= maxPrice;
    }).toList();
  }

  // Filter stocks by category
  static List<Stock> filterStocksByCategory(
    List<Stock> stocks,
    String category,
  ) {
    if (category.isEmpty || category == 'All') return stocks;

    return stocks.where((stock) => stock.category == category).toList();
  }

  // Filter stocks by low stock (quantity <= reorder level)
  static List<Stock> filterLowStockItems(List<Stock> stocks) {
    return stocks
        .where((stock) => stock.quantity <= stock.reorderLevel)
        .toList();
  }

  // Filter sales by date range
  static List<Sale> filterSalesByDate(
    List<Sale> sales,
    DateTime startDate,
    DateTime endDate,
  ) {
    return sales.where((sale) {
      return sale.saleDate.isAfter(
            startDate.subtract(const Duration(days: 1)),
          ) &&
          sale.saleDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // Filter expenses by date range
  static List<Expense> filterExpensesByDate(
    List<Expense> expenses,
    DateTime startDate,
    DateTime endDate,
  ) {
    return expenses.where((expense) {
      return expense.expenseDate.isAfter(
            startDate.subtract(const Duration(days: 1)),
          ) &&
          expense.expenseDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // Filter expenses by category
  static List<Expense> filterExpensesByCategory(
    List<Expense> expenses,
    String category,
  ) {
    if (category.isEmpty || category == 'All') return expenses;

    return expenses.where((expense) => expense.category == category).toList();
  }

  // Get unique expense categories
  static List<String> getExpenseCategories(List<Expense> expenses) {
    final categories = expenses.map((e) => e.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  // Get unique stock categories
  static List<String> getStockCategories(List<Stock> stocks) {
    final categories = stocks.map((s) => s.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  // Sort stocks by various criteria
  static List<Stock> sortStocks(List<Stock> stocks, String sortBy) {
    final sortedStocks = List<Stock>.from(stocks);

    switch (sortBy) {
      case 'name':
        sortedStocks.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name_desc':
        sortedStocks.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'cost_price':
        sortedStocks.sort((a, b) => a.unitCostPrice.compareTo(b.unitCostPrice));
        break;
      case 'cost_price_desc':
        sortedStocks.sort((a, b) => b.unitCostPrice.compareTo(a.unitCostPrice));
        break;
      case 'selling_price':
        sortedStocks.sort(
          (a, b) => a.unitSellingPrice.compareTo(b.unitSellingPrice),
        );
        break;
      case 'selling_price_desc':
        sortedStocks.sort(
          (a, b) => b.unitSellingPrice.compareTo(a.unitSellingPrice),
        );
        break;
      case 'category':
        sortedStocks.sort((a, b) => a.category.compareTo(b.category));
        break;
      case 'category_desc':
        sortedStocks.sort((a, b) => b.category.compareTo(a.category));
        break;
      case 'quantity':
        sortedStocks.sort((a, b) => a.quantity.compareTo(b.quantity));
        break;
      case 'quantity_desc':
        sortedStocks.sort((a, b) => b.quantity.compareTo(a.quantity));
        break;
      case 'value':
        sortedStocks.sort((a, b) => a.totalValue.compareTo(b.totalValue));
        break;
      case 'value_desc':
        sortedStocks.sort((a, b) => b.totalValue.compareTo(a.totalValue));
        break;
      case 'date':
        sortedStocks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'date_desc':
        sortedStocks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return sortedStocks;
  }

  // Sort sales by various criteria
  static List<Sale> sortSales(List<Sale> sales, String sortBy) {
    final sortedSales = List<Sale>.from(sales);

    switch (sortBy) {
      case 'product':
        sortedSales.sort((a, b) => a.productName.compareTo(b.productName));
        break;
      case 'product_desc':
        sortedSales.sort((a, b) => b.productName.compareTo(a.productName));
        break;
      case 'amount':
        sortedSales.sort((a, b) => a.totalAmount.compareTo(b.totalAmount));
        break;
      case 'amount_desc':
        sortedSales.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
        break;
      case 'date':
        sortedSales.sort((a, b) => a.saleDate.compareTo(b.saleDate));
        break;
      case 'date_desc':
        sortedSales.sort((a, b) => b.saleDate.compareTo(a.saleDate));
        break;
      case 'customer':
        sortedSales.sort((a, b) => a.customerName.compareTo(b.customerName));
        break;
      case 'customer_desc':
        sortedSales.sort((a, b) => b.customerName.compareTo(a.customerName));
        break;
    }

    return sortedSales;
  }

  // Sort expenses by various criteria
  static List<Expense> sortExpenses(List<Expense> expenses, String sortBy) {
    final sortedExpenses = List<Expense>.from(expenses);

    switch (sortBy) {
      case 'category':
        sortedExpenses.sort((a, b) => a.category.compareTo(b.category));
        break;
      case 'category_desc':
        sortedExpenses.sort((a, b) => b.category.compareTo(a.category));
        break;
      case 'amount':
        sortedExpenses.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      case 'amount_desc':
        sortedExpenses.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'date':
        sortedExpenses.sort((a, b) => a.expenseDate.compareTo(b.expenseDate));
        break;
      case 'date_desc':
        sortedExpenses.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
        break;
      case 'description':
        sortedExpenses.sort((a, b) => a.description.compareTo(b.description));
        break;
      case 'description_desc':
        sortedExpenses.sort((a, b) => b.description.compareTo(a.description));
        break;
    }

    return sortedExpenses;
  }
}
