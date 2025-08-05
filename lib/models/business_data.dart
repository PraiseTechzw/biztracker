import 'package:isar/isar.dart';

part 'business_data.g.dart';

@collection
class Capital {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date;

  late double amount;
  late String description;
  late String type; // 'initial' or 'additional'

  @Index()
  late DateTime createdAt;
}

@collection
class Stock {
  Id id = Isar.autoIncrement;

  late String name;
  late String description;
  late String category;
  late String? supplierName;
  late String? supplierContact;
  late String? imagePath; // Path to stored image

  late double quantity;
  late double unitCostPrice; // Cost price per unit
  late double unitSellingPrice; // Selling price per unit
  late double totalValue; // Total value based on cost price
  late double reorderLevel; // Minimum stock level before reordering

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;
}

@collection
class Sale {
  Id id = Isar.autoIncrement;

  late String productName;
  late double quantity;
  late double unitPrice;
  late double totalAmount;
  late String customerName;
  late String notes;

  @Index()
  late DateTime saleDate;

  @Index()
  late DateTime createdAt;
}

@collection
class Expense {
  Id id = Isar.autoIncrement;

  late String category;
  late String description;
  late double amount;
  late String paymentMethod;

  @Index()
  late DateTime expenseDate;

  @Index()
  late DateTime createdAt;
}

@collection
class Profit {
  Id id = Isar.autoIncrement;

  late double revenue;
  late double expenses;
  late double netProfit;
  late double profitMargin;

  @Index()
  late DateTime periodStart;

  @Index()
  late DateTime periodEnd;

  @Index()
  late DateTime createdAt;
}
