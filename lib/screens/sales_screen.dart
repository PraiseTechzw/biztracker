import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

      for (var sale in salesData) {
        salesTotal += sale.totalAmount;
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
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
            ],
          ),
          const SizedBox(height: 16),
          _buildSalesSummary(),
        ],
      ),
    );
  }

  Widget _buildSalesSummary() {
    return Row(
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
        itemCount: sales.length,
        itemBuilder: (context, index) {
          final sale = sales[index];
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

    return GlassmorphismTheme.glassmorphismContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: GlassmorphismTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.point_of_sale,
                  color: GlassmorphismTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sale.productName,
                      style: const TextStyle(
                        color: GlassmorphismTheme.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
    final notesController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    Stock? selectedStock;
    bool isLoading = false;

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
                            labelText: 'Select Product',
                            prefixIcon: Icon(Icons.inventory),
                            border: OutlineInputBorder(),
                          ),
                          value: selectedStock,
                          items: stocks.map((stock) {
                            return DropdownMenuItem(
                              value: stock,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    stock.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Stock: ${stock.quantity} | Price: \$${NumberFormat('#,##0.00').format(stock.unitSellingPrice)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
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

                        TextFormField(
                          controller: customerNameController,
                          decoration: const InputDecoration(
                            labelText: 'Customer Name (Optional)',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                        ),
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
                                        style: const TextStyle(
                                          color: Colors.blue,
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
                                  ..customerName = customerNameController.text
                                  ..notes = notesController.text
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
}
