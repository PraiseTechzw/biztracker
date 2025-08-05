import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../utils/glassmorphism_theme.dart';
import '../services/database_service.dart';
import '../models/business_data.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Sale> sales = [];
  List<Stock> stocks = [];
  bool isLoading = true;
  double totalSales = 0.0;
  double totalProfit = 0.0;
  double totalPaid = 0.0;
  double totalCredit = 0.0;
  String selectedPaymentFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final salesData = await DatabaseService.getAllSales();
      final stocksData = await DatabaseService.getAllStocks();

      // Calculate totals
      double salesTotal = 0.0;
      double profitTotal = 0.0;
      double paidTotal = 0.0;
      double creditTotal = 0.0;

      for (var sale in salesData) {
        salesTotal += sale.totalAmount;
        paidTotal += sale.amountPaid;
        creditTotal += (sale.totalAmount - sale.amountPaid);

        // Find corresponding stock to calculate profit
        final stock = stocksData.firstWhere(
          (stock) => stock.name.toLowerCase() == sale.productName.toLowerCase(),
          orElse: () => Stock()
            ..unitCostPrice = 0
            ..unitSellingPrice = sale.unitPrice,
        );
        final costPrice = stock.unitCostPrice;
        final profitPerUnit = sale.unitPrice - costPrice;
        profitTotal += profitPerUnit * sale.quantity;
      }

      setState(() {
        sales = salesData;
        stocks = stocksData;
        totalSales = salesTotal;
        totalProfit = profitTotal;
        totalPaid = paidTotal;
        totalCredit = creditTotal;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Sale> getFilteredSales() {
    switch (selectedPaymentFilter) {
      case 'Paid':
        return sales.where((sale) => sale.paymentStatus == 'paid').toList();
      case 'Credit':
        return sales.where((sale) => sale.paymentStatus == 'credit').toList();
      case 'Partial':
        return sales.where((sale) => sale.paymentStatus == 'partial').toList();
      default:
        return sales;
    }
  }

  Future<void> _refreshSales() async {
    await _loadData();
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
                      : _buildSalesList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSaleDialog,
        backgroundColor: GlassmorphismTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GlassmorphismTheme.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.point_of_sale,
                  color: GlassmorphismTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Sales Management',
                  style: TextStyle(
                    color: GlassmorphismTheme.textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: _showPaymentFilter,
                icon: const Icon(
                  Icons.filter_list,
                  color: GlassmorphismTheme.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSalesSummary(),
          const SizedBox(height: 12),
          _buildPaymentFilterChip(),
        ],
      ),
    );
  }

  Widget _buildSalesSummary() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Sales',
                '\$${NumberFormat('#,##0.00').format(totalSales)}',
                Icons.trending_up,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Total Profit',
                '\$${NumberFormat('#,##0.00').format(totalProfit)}',
                Icons.attach_money,
                totalProfit >= 0 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Total Orders',
                sales.length.toString(),
                Icons.shopping_cart,
                GlassmorphismTheme.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Amount Paid',
                '\$${NumberFormat('#,##0.00').format(totalPaid)}',
                Icons.check_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Credit Amount',
                '\$${NumberFormat('#,##0.00').format(totalCredit)}',
                Icons.credit_card,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentFilterChip() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ['All', 'Paid', 'Credit', 'Partial'].map((filter) {
          final isSelected = selectedPaymentFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedPaymentFilter = filter;
                });
              },
              backgroundColor: GlassmorphismTheme.surfaceColor.withOpacity(0.5),
              selectedColor: GlassmorphismTheme.primaryColor.withOpacity(0.3),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : GlassmorphismTheme.textColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showPaymentFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Filter by Payment Status',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['All', 'Paid', 'Credit', 'Partial'].map((filter) {
            return ListTile(
              title: Text(
                filter,
                style: const TextStyle(color: GlassmorphismTheme.textColor),
              ),
              trailing: selectedPaymentFilter == filter
                  ? const Icon(
                      Icons.check,
                      color: GlassmorphismTheme.primaryColor,
                    )
                  : null,
              onTap: () {
                setState(() {
                  selectedPaymentFilter = filter;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: GlassmorphismTheme.textSecondaryColor,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSalesList() {
    if (sales.isEmpty) {
      return Center(
        child: GlassmorphismTheme.glassmorphismContainer(
          padding: const EdgeInsets.all(32),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.point_of_sale_outlined,
                color: GlassmorphismTheme.textSecondaryColor,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'No sales recorded yet',
                style: TextStyle(
                  color: GlassmorphismTheme.textSecondaryColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add your first sale to get started',
                style: TextStyle(
                  color: GlassmorphismTheme.textSecondaryColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshSales,
      color: GlassmorphismTheme.primaryColor,
      child: ListView.builder(
        itemCount: getFilteredSales().length,
        itemBuilder: (context, index) {
          final sale = getFilteredSales()[index];
          return _buildSaleCard(sale);
        },
      ),
    );
  }

  Widget _buildSaleCard(Sale sale) {
    // Find corresponding stock for profit calculation
    final stock = stocks.firstWhere(
      (stock) => stock.name.toLowerCase() == sale.productName.toLowerCase(),
      orElse: () => Stock()
        ..unitCostPrice = 0
        ..unitSellingPrice = sale.unitPrice,
    );

    final costPrice = stock.unitCostPrice;
    final profitPerUnit = sale.unitPrice - costPrice;
    final totalProfit = profitPerUnit * sale.quantity;
    final profitMargin = sale.unitPrice > 0
        ? (profitPerUnit / sale.unitPrice) * 100
        : 0;
    final remainingAmount = sale.totalAmount - sale.amountPaid;
    final isOverdue =
        sale.dueDate != null &&
        sale.dueDate!.isBefore(DateTime.now()) &&
        remainingAmount > 0;

    return GlassmorphismTheme.glassmorphismContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: GlassmorphismTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: stock.imagePath != null && stock.imagePath!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(stock.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.point_of_sale,
                            color: GlassmorphismTheme.primaryColor,
                            size: 30,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.point_of_sale,
                        color: GlassmorphismTheme.primaryColor,
                        size: 30,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            sale.productName,
                            style: const TextStyle(
                              color: GlassmorphismTheme.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildPaymentStatusChip(
                          sale,
                          remainingAmount,
                          isOverdue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Customer: ${sale.customerName.isNotEmpty ? sale.customerName : 'Walk-in Customer'}',
                      style: const TextStyle(
                        color: GlassmorphismTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(sale.saleDate),
                      style: const TextStyle(
                        color: GlassmorphismTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${NumberFormat('#,##0.00').format(sale.totalAmount)}',
                    style: const TextStyle(
                      color: GlassmorphismTheme.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Profit: \$${NumberFormat('#,##0.00').format(totalProfit)}',
                    style: TextStyle(
                      color: totalProfit >= 0 ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (remainingAmount > 0)
                    Text(
                      'Remaining: \$${NumberFormat('#,##0.00').format(remainingAmount)}',
                      style: TextStyle(
                        color: isOverdue ? Colors.red : Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildSaleInfo('Quantity', '${sale.quantity}')),
              Expanded(
                child: _buildSaleInfo(
                  'Unit Price',
                  '\$${NumberFormat('#,##0.00').format(sale.unitPrice)}',
                ),
              ),
              Expanded(
                child: _buildSaleInfo(
                  'Profit Margin',
                  '${profitMargin.toStringAsFixed(1)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSaleInfo(
                  'Payment Status',
                  _getPaymentStatusText(sale.paymentStatus),
                ),
              ),
              Expanded(
                child: _buildSaleInfo(
                  'Amount Paid',
                  '\$${NumberFormat('#,##0.00').format(sale.amountPaid)}',
                ),
              ),
              if (sale.dueDate != null)
                Expanded(
                  child: _buildSaleInfo(
                    'Due Date',
                    DateFormat('MMM dd').format(sale.dueDate!),
                  ),
                ),
            ],
          ),
          if (sale.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Notes: ${sale.notes}',
              style: const TextStyle(
                color: GlassmorphismTheme.textSecondaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSaleInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: GlassmorphismTheme.textSecondaryColor,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: GlassmorphismTheme.textColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showAddSaleDialog() {
    final formKey = GlobalKey<FormState>();
    final productNameController = TextEditingController();
    final quantityController = TextEditingController();
    final unitPriceController = TextEditingController();
    final customerNameController = TextEditingController();
    final customerPhoneController = TextEditingController();
    final notesController = TextEditingController();
    final amountPaidController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    DateTime? selectedDueDate;
    Stock? selectedStock;
    bool isLoading = false;
    String selectedPaymentStatus = 'paid';
    String selectedPaymentMethod = 'cash';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: GlassmorphismTheme.surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Record Sale',
                      style: TextStyle(
                        color: GlassmorphismTheme.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: GlassmorphismTheme.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        // Product Selection
                        DropdownButtonFormField<Stock>(
                          decoration: const InputDecoration(
                            labelText: 'Select Product from Stock',
                            prefixIcon: Icon(Icons.inventory),
                            border: OutlineInputBorder(),
                            hintText: 'Choose a product to sell...',
                          ),
                          value: selectedStock,
                          items:
                              stocks
                                  .where((stock) => stock.quantity > 0)
                                  .isEmpty
                              ? [
                                  const DropdownMenuItem<Stock>(
                                    enabled: false,
                                    child: Text(
                                      'No products available in stock',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ]
                              : stocks.where((stock) => stock.quantity > 0).map((
                                  stock,
                                ) {
                                  return DropdownMenuItem(
                                    value: stock,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: GlassmorphismTheme
                                                .primaryColor
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child:
                                              stock.imagePath != null &&
                                                  stock.imagePath!.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.file(
                                                    File(stock.imagePath!),
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => Icon(
                                                          Icons.inventory,
                                                          color:
                                                              GlassmorphismTheme
                                                                  .primaryColor,
                                                          size: 20,
                                                        ),
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.inventory,
                                                  color: GlassmorphismTheme
                                                      .primaryColor,
                                                  size: 20,
                                                ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                stock.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                'Available: ${stock.quantity} | Price: \$${NumberFormat('#,##0.00').format(stock.unitSellingPrice)}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              if (stock.quantity <=
                                                  stock.reorderLevel)
                                                const Text(
                                                  '⚠️ Low Stock',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.orange,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          onChanged: (Stock? stock) {
                            setModalState(() {
                              selectedStock = stock;
                              if (stock != null) {
                                productNameController.text = stock.name;
                                unitPriceController.text = stock
                                    .unitSellingPrice
                                    .toString();
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a product';
                            }
                            return null;
                          },
                        ),
                        if (stocks.where((stock) => stock.quantity > 0).isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '💡 Add products to stock first to record sales',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: productNameController,
                          decoration: const InputDecoration(
                            labelText: 'Product Name',
                            prefixIcon: Icon(Icons.shopping_bag),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter product name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Quantity',
                                  prefixIcon: Icon(Icons.shopping_cart),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setModalState(() {});
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter quantity';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  final qty = double.parse(value);
                                  if (qty <= 0) {
                                    return 'Quantity must be greater than 0';
                                  }
                                  if (selectedStock != null &&
                                      qty > selectedStock!.quantity) {
                                    return 'Insufficient stock (${selectedStock!.quantity} available)';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: unitPriceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Unit Price',
                                  prefixText: '\$',
                                  prefixIcon: Icon(Icons.attach_money),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setModalState(() {});
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter unit price';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: customerNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Customer Name (Optional)',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: customerPhoneController,
                                decoration: const InputDecoration(
                                  labelText: 'Phone (Optional)',
                                  prefixIcon: Icon(Icons.phone),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Payment Status Selection
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Payment Status',
                            prefixIcon: Icon(Icons.payment),
                            border: OutlineInputBorder(),
                          ),
                          value: selectedPaymentStatus,
                          items: [
                            DropdownMenuItem(
                              value: 'paid',
                              child: Text('Paid'),
                            ),
                            DropdownMenuItem(
                              value: 'partial',
                              child: Text('Partial Payment'),
                            ),
                            DropdownMenuItem(
                              value: 'credit',
                              child: Text('Credit'),
                            ),
                          ],
                          onChanged: (value) {
                            setModalState(() {
                              selectedPaymentStatus = value!;
                              if (value == 'paid') {
                                amountPaidController.text =
                                    unitPriceController.text.isNotEmpty &&
                                        quantityController.text.isNotEmpty
                                    ? _calculateTotalAmount(
                                        quantityController.text,
                                        unitPriceController.text,
                                      )
                                    : '';
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Payment Method Selection
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Payment Method',
                            prefixIcon: Icon(Icons.credit_card),
                            border: OutlineInputBorder(),
                          ),
                          value: selectedPaymentMethod,
                          items: [
                            DropdownMenuItem(
                              value: 'cash',
                              child: Text('Cash'),
                            ),
                            DropdownMenuItem(
                              value: 'card',
                              child: Text('Card'),
                            ),
                            DropdownMenuItem(
                              value: 'bank_transfer',
                              child: Text('Bank Transfer'),
                            ),
                            DropdownMenuItem(
                              value: 'credit',
                              child: Text('Credit'),
                            ),
                          ],
                          onChanged: (value) {
                            setModalState(() {
                              selectedPaymentMethod = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Amount Paid Field
                        if (selectedPaymentStatus != 'paid')
                          TextFormField(
                            controller: amountPaidController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Amount Paid',
                              prefixText: '\$',
                              prefixIcon: Icon(Icons.attach_money),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setModalState(() {});
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter amount paid';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              final paid = double.parse(value);
                              final total =
                                  unitPriceController.text.isNotEmpty &&
                                      quantityController.text.isNotEmpty
                                  ? double.parse(
                                      _calculateTotalAmount(
                                        quantityController.text,
                                        unitPriceController.text,
                                      ).replaceAll(',', ''),
                                    )
                                  : 0;
                              if (paid > total) {
                                return 'Amount paid cannot exceed total amount';
                              }
                              return null;
                            },
                          ),
                        if (selectedPaymentStatus != 'paid')
                          const SizedBox(height: 16),

                        // Due Date for Credit Sales
                        if (selectedPaymentStatus == 'credit' ||
                            selectedPaymentStatus == 'partial')
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Due Date',
                              style: TextStyle(
                                color: GlassmorphismTheme.textColor,
                              ),
                            ),
                            subtitle: Text(
                              selectedDueDate != null
                                  ? DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(selectedDueDate!)
                                  : 'Not set',
                              style: const TextStyle(
                                color: GlassmorphismTheme.textSecondaryColor,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.calendar_today,
                              color: GlassmorphismTheme.primaryColor,
                            ),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate:
                                    selectedDueDate ??
                                    DateTime.now().add(
                                      const Duration(days: 30),
                                    ),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) {
                                setModalState(() {
                                  selectedDueDate = date;
                                });
                              }
                            },
                          ),
                        if (selectedPaymentStatus == 'credit' ||
                            selectedPaymentStatus == 'partial')
                          const SizedBox(height: 16),

                        TextFormField(
                          controller: notesController,
                          decoration: const InputDecoration(
                            labelText: 'Notes (Optional)',
                            prefixIcon: Icon(Icons.note),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),

                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Sale Date',
                            style: TextStyle(
                              color: GlassmorphismTheme.textColor,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('MMM dd, yyyy').format(selectedDate),
                            style: const TextStyle(
                              color: GlassmorphismTheme.textSecondaryColor,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.calendar_today,
                            color: GlassmorphismTheme.primaryColor,
                          ),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setModalState(() {
                                selectedDate = date;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // Summary Card
                        if (quantityController.text.isNotEmpty &&
                            unitPriceController.text.isNotEmpty)
                          GlassmorphismTheme.glassmorphismContainer(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Sale Summary',
                                  style: TextStyle(
                                    color: GlassmorphismTheme.textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Amount:',
                                      style: const TextStyle(
                                        color: GlassmorphismTheme
                                            .textSecondaryColor,
                                      ),
                                    ),
                                    Text(
                                      '\$${_calculateTotalAmount(quantityController.text, unitPriceController.text)}',
                                      style: const TextStyle(
                                        color: GlassmorphismTheme.textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (selectedStock != null) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Profit Per Unit:',
                                        style: const TextStyle(
                                          color: GlassmorphismTheme
                                              .textSecondaryColor,
                                        ),
                                      ),
                                      Text(
                                        '\$${_calculateProfitPerUnit(selectedStock!.unitCostPrice.toString(), unitPriceController.text)}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Payment Status:',
                                        style: const TextStyle(
                                          color: GlassmorphismTheme
                                              .textSecondaryColor,
                                        ),
                                      ),
                                      Text(
                                        _getPaymentStatusText(
                                          selectedPaymentStatus,
                                        ),
                                        style: TextStyle(
                                          color: _getPaymentStatusColor(
                                            selectedPaymentStatus,
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (selectedPaymentStatus != 'paid') ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Amount Paid:',
                                          style: const TextStyle(
                                            color: GlassmorphismTheme
                                                .textSecondaryColor,
                                          ),
                                        ),
                                        Text(
                                          '\$${amountPaidController.text.isEmpty ? '0.00' : amountPaidController.text}',
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Remaining:',
                                          style: const TextStyle(
                                            color: GlassmorphismTheme
                                                .textSecondaryColor,
                                          ),
                                        ),
                                        Text(
                                          '\$${_calculateRemainingAmount(quantityController.text, unitPriceController.text, amountPaidController.text)}',
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Profit:',
                                        style: const TextStyle(
                                          color: GlassmorphismTheme
                                              .textSecondaryColor,
                                        ),
                                      ),
                                      Text(
                                        '\$${_calculateTotalProfit(selectedStock!.unitCostPrice.toString(), unitPriceController.text, quantityController.text)}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Remaining Stock:',
                                        style: const TextStyle(
                                          color: GlassmorphismTheme
                                              .textSecondaryColor,
                                        ),
                                      ),
                                      Text(
                                        '${selectedStock!.quantity - (double.tryParse(quantityController.text) ?? 0)}',
                                        style: TextStyle(
                                          color:
                                              (selectedStock!.quantity -
                                                      (double.tryParse(
                                                            quantityController
                                                                .text,
                                                          ) ??
                                                          0)) <=
                                                  selectedStock!.reorderLevel
                                              ? Colors.orange
                                              : Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Stock Status:',
                                        style: const TextStyle(
                                          color: GlassmorphismTheme
                                              .textSecondaryColor,
                                        ),
                                      ),
                                      Text(
                                        selectedStock!.quantity <=
                                                selectedStock!.reorderLevel
                                            ? 'Low Stock'
                                            : 'In Stock',
                                        style: TextStyle(
                                          color:
                                              selectedStock!.quantity <=
                                                  selectedStock!.reorderLevel
                                              ? Colors.orange
                                              : Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              setModalState(() => isLoading = true);
                              try {
                                final quantity = double.parse(
                                  quantityController.text,
                                );
                                final unitPrice = double.parse(
                                  unitPriceController.text,
                                );
                                final totalAmount = quantity * unitPrice;

                                final sale = Sale()
                                  ..productName = productNameController.text
                                  ..quantity = quantity
                                  ..unitPrice = unitPrice
                                  ..totalAmount = totalAmount
                                  ..amountPaid = selectedPaymentStatus == 'paid'
                                      ? totalAmount
                                      : double.parse(
                                          amountPaidController.text.isEmpty
                                              ? '0'
                                              : amountPaidController.text,
                                        )
                                  ..customerName = customerNameController.text
                                  ..customerPhone = customerPhoneController.text
                                  ..notes = notesController.text
                                  ..paymentStatus = selectedPaymentStatus
                                  ..paymentMethod = selectedPaymentMethod
                                  ..dueDate = selectedDueDate
                                  ..lastPaymentDate =
                                      selectedPaymentStatus == 'paid'
                                      ? DateTime.now()
                                      : null
                                  ..saleDate = selectedDate
                                  ..createdAt = DateTime.now();

                                await DatabaseService.addSale(sale);

                                // Update stock quantity
                                if (selectedStock != null) {
                                  selectedStock!.quantity -= quantity;
                                  selectedStock!.updatedAt = DateTime.now();
                                  await DatabaseService.updateStock(
                                    selectedStock!,
                                  );
                                }

                                Navigator.pop(context);
                                _loadData(); // Refresh both sales and stocks
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error recording sale: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                setModalState(() => isLoading = false);
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlassmorphismTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Record Sale',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _calculateTotalAmount(String quantity, String unitPrice) {
    try {
      final qty = double.parse(quantity);
      final price = double.parse(unitPrice);
      return NumberFormat('#,##0.00').format(qty * price);
    } catch (e) {
      return '0.00';
    }
  }

  String _calculateProfitPerUnit(String costPrice, String sellingPrice) {
    try {
      final cost = double.parse(costPrice);
      final selling = double.parse(sellingPrice);
      final profit = selling - cost;
      return NumberFormat('#,##0.00').format(profit);
    } catch (e) {
      return '0.00';
    }
  }

  String _calculateTotalProfit(
    String costPrice,
    String sellingPrice,
    String quantity,
  ) {
    try {
      final cost = double.parse(costPrice);
      final selling = double.parse(sellingPrice);
      final qty = double.parse(quantity);
      final profitPerUnit = selling - cost;
      final totalProfit = profitPerUnit * qty;
      return NumberFormat('#,##0.00').format(totalProfit);
    } catch (e) {
      return '0.00';
    }
  }

  String _getPaymentStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Paid';
      case 'partial':
        return 'Partial';
      case 'credit':
        return 'Credit';
      default:
        return 'Unknown';
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'partial':
        return Colors.orange;
      case 'credit':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPaymentStatusChip(
    Sale sale,
    double remainingAmount,
    bool isOverdue,
  ) {
    Color chipColor = _getPaymentStatusColor(sale.paymentStatus);
    if (isOverdue) chipColor = Colors.red;

    String chipText = _getPaymentStatusText(sale.paymentStatus);
    if (isOverdue) chipText = 'Overdue';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        chipText,
        style: TextStyle(
          color: chipColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _calculateRemainingAmount(
    String quantity,
    String unitPrice,
    String amountPaid,
  ) {
    try {
      final total = double.parse(
        _calculateTotalAmount(quantity, unitPrice).replaceAll(',', ''),
      );
      final paid = double.parse(amountPaid.isEmpty ? '0' : amountPaid);
      final remaining = total - paid;
      return NumberFormat('#,##0.00').format(remaining > 0 ? remaining : 0);
    } catch (e) {
      return '0.00';
    }
  }
}
