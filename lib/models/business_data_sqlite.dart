class Capital {
  int? id;
  late DateTime date;
  late double amount;
  late String description;
  late String type; // 'initial' or 'additional'
  late DateTime createdAt;

  Capital({
    this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.type,
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'description': description,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Capital.fromMap(Map<String, dynamic> map) {
    return Capital(
      id: map['id'],
      date: DateTime.parse(map['date']),
      amount: map['amount'],
      description: map['description'],
      type: map['type'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class Stock {
  int? id;
  late String name;
  late String description;
  late String category;
  String? barcode; // Barcode/QR code for the item
  String? supplierName;
  String? supplierContact;
  String? imagePath; // Path to stored image
  late double quantity;
  late double unitCostPrice; // Cost price per unit
  late double unitSellingPrice; // Selling price per unit
  late double totalValue; // Total value based on cost price
  late double reorderLevel; // Minimum stock level before reordering
  late DateTime createdAt;
  late DateTime updatedAt;

  Stock({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    this.barcode,
    this.supplierName,
    this.supplierContact,
    this.imagePath,
    required this.quantity,
    required this.unitCostPrice,
    required this.unitSellingPrice,
    required this.totalValue,
    required this.reorderLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'barcode': barcode,
      'supplierName': supplierName,
      'supplierContact': supplierContact,
      'imagePath': imagePath,
      'quantity': quantity,
      'unitCostPrice': unitCostPrice,
      'unitSellingPrice': unitSellingPrice,
      'totalValue': totalValue,
      'reorderLevel': reorderLevel,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      barcode: map['barcode'],
      supplierName: map['supplierName'],
      supplierContact: map['supplierContact'],
      imagePath: map['imagePath'],
      quantity: map['quantity'],
      unitCostPrice: map['unitCostPrice'],
      unitSellingPrice: map['unitSellingPrice'],
      totalValue: map['totalValue'],
      reorderLevel: map['reorderLevel'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}

class Sale {
  int? id;
  late String productName;
  late double quantity;
  late double unitPrice;
  late double totalAmount;
  late double amountPaid; // Amount paid so far
  late String customerName;
  late String customerPhone; // Customer phone for credit tracking
  late String notes;
  late String paymentStatus; // 'paid', 'partial', 'credit'
  late String paymentMethod; // 'cash', 'card', 'bank_transfer', 'credit'
  DateTime? dueDate; // Due date for credit sales
  DateTime? lastPaymentDate; // Date of last payment
  late DateTime saleDate;
  late DateTime createdAt;

  Sale({
    this.id,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.amountPaid,
    required this.customerName,
    required this.customerPhone,
    required this.notes,
    required this.paymentStatus,
    required this.paymentMethod,
    this.dueDate,
    this.lastPaymentDate,
    required this.saleDate,
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalAmount': totalAmount,
      'amountPaid': amountPaid,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'notes': notes,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'dueDate': dueDate?.toIso8601String(),
      'lastPaymentDate': lastPaymentDate?.toIso8601String(),
      'saleDate': saleDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      productName: map['productName'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
      totalAmount: map['totalAmount'],
      amountPaid: map['amountPaid'],
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
      notes: map['notes'],
      paymentStatus: map['paymentStatus'],
      paymentMethod: map['paymentMethod'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      lastPaymentDate: map['lastPaymentDate'] != null
          ? DateTime.parse(map['lastPaymentDate'])
          : null,
      saleDate: DateTime.parse(map['saleDate']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class Expense {
  int? id;
  late String category;
  late String description;
  late double amount;
  late String paymentMethod;
  late DateTime expenseDate;
  late DateTime createdAt;

  Expense({
    this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.paymentMethod,
    required this.expenseDate,
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'expenseDate': expenseDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      category: map['category'],
      description: map['description'],
      amount: map['amount'],
      paymentMethod: map['paymentMethod'],
      expenseDate: DateTime.parse(map['expenseDate']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class Profit {
  int? id;
  late double revenue;
  late double expenses;
  late double netProfit;
  late double profitMargin;
  late DateTime periodStart;
  late DateTime periodEnd;
  late DateTime createdAt;

  Profit({
    this.id,
    required this.revenue,
    required this.expenses,
    required this.netProfit,
    required this.profitMargin,
    required this.periodStart,
    required this.periodEnd,
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'revenue': revenue,
      'expenses': expenses,
      'netProfit': netProfit,
      'profitMargin': profitMargin,
      'periodStart': periodStart.toIso8601String(),
      'periodEnd': periodEnd.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Profit.fromMap(Map<String, dynamic> map) {
    return Profit(
      id: map['id'],
      revenue: map['revenue'],
      expenses: map['expenses'],
      netProfit: map['netProfit'],
      profitMargin: map['profitMargin'],
      periodStart: DateTime.parse(map['periodStart']),
      periodEnd: DateTime.parse(map['periodEnd']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
