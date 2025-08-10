import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:confetti/confetti.dart';
import '../utils/glassmorphism_theme.dart';
import '../utils/toast_utils.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../services/engagement_service.dart';
import '../services/ad_service.dart';
import '../models/business_data.dart';
import 'barcode_scanner_screen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen>
    with TickerProviderStateMixin {
  List<Sale> sales = [];
  List<Stock> stocks = [];
  bool isLoading = true;
  double totalSales = 0.0;
  double totalProfit = 0.0;
  double totalPaid = 0.0;
  double totalCredit = 0.0;
  String selectedPaymentFilter = 'All';
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _loadData();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final salesData = await DatabaseService.getAllSales();
      final stocksData = await DatabaseService.getAllStocks();

      // Check if widget is still mounted before proceeding
      if (!mounted) return;

      // Calculate totals
      double salesTotal = 0.0;
      double profitTotal = 0.0;
      double paidTotal = 0.0;
      double creditTotal = 0.0;

      for (var sale in salesData) {
        salesTotal += sale.totalAmount;
        paidTotal += sale.amountPaid;
        final remainingAmount = sale.totalAmount - sale.amountPaid;
        if (remainingAmount > 0) {
          creditTotal += remainingAmount;
        }

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

      // Ensure no NaN values
      if (salesTotal.isNaN) salesTotal = 0.0;
      if (profitTotal.isNaN) profitTotal = 0.0;
      if (paidTotal.isNaN) paidTotal = 0.0;
      if (creditTotal.isNaN) creditTotal = 0.0;

      if (mounted) {
        setState(() {
          sales = salesData;
          stocks = stocksData;
          totalSales = salesTotal;
          totalProfit = profitTotal;
          totalPaid = paidTotal;
          totalCredit = creditTotal;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
    return ConfettiUtils.buildConfettiWidget(
      controller: _confettiController,
      child: Scaffold(
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
                '\$${NumberFormat('#,##0.00').format(totalSales.isNaN ? 0.0 : totalSales)}',
                Icons.trending_up,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Total Profit',
                '\$${NumberFormat('#,##0.00').format(totalProfit.isNaN ? 0.0 : totalProfit)}',
                Icons.attach_money,
                (totalProfit.isNaN ? 0.0 : totalProfit) >= 0
                    ? Colors.green
                    : Colors.red,
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
                '\$${NumberFormat('#,##0.00').format(totalPaid.isNaN ? 0.0 : totalPaid)}',
                Icons.check_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Credit Amount',
                '\$${NumberFormat('#,##0.00').format(totalCredit.isNaN ? 0.0 : totalCredit)}',
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
    final profitMargin = sale.unitPrice > 0 && !sale.unitPrice.isNaN
        ? (profitPerUnit / sale.unitPrice) * 100
        : 0;
    final remainingAmount = sale.totalAmount - sale.amountPaid;
    final isOverdue =
        sale.dueDate != null &&
        sale.dueDate!.isBefore(DateTime.now()) &&
        remainingAmount > 0;

    return GestureDetector(
      onTap: () => _showSaleDetailsBottomSheet(sale),
      child: GlassmorphismTheme.glassmorphismContainer(
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
                      '\$${NumberFormat('#,##0.00').format(sale.totalAmount.isNaN ? 0.0 : sale.totalAmount)}',
                      style: const TextStyle(
                        color: GlassmorphismTheme.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Profit: \$${NumberFormat('#,##0.00').format(totalProfit.isNaN ? 0.0 : totalProfit)}',
                      style: TextStyle(
                        color: (totalProfit.isNaN ? 0.0 : totalProfit) >= 0
                            ? Colors.green
                            : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (remainingAmount > 0)
                      Text(
                        'Remaining: \$${NumberFormat('#,##0.00').format(remainingAmount.isNaN ? 0.0 : remainingAmount)}',
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
                    '\$${NumberFormat('#,##0.00').format(sale.unitPrice.isNaN ? 0.0 : sale.unitPrice)}',
                  ),
                ),
                Expanded(
                  child: _buildSaleInfo(
                    'Profit Margin',
                    '${profitMargin.isNaN ? 0.0 : profitMargin.toStringAsFixed(1)}%',
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
                    '\$${NumberFormat('#,##0.00').format(sale.amountPaid.isNaN ? 0.0 : sale.amountPaid)}',
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
            const SizedBox(height: 12),
            if (remainingAmount > 0)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showPaymentDialog(sale),
                  icon: const Icon(Icons.payment, size: 16),
                  label: const Text('Record Payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlassmorphismTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
          ],
        ),
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

  void _showSaleDetailsBottomSheet(Sale sale) {
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
    final profitMargin = sale.unitPrice > 0 && !sale.unitPrice.isNaN
        ? (profitPerUnit / sale.unitPrice) * 100
        : 0;
    final remainingAmount = sale.totalAmount - sale.amountPaid;
    final isOverdue =
        sale.dueDate != null &&
        sale.dueDate!.isBefore(DateTime.now()) &&
        remainingAmount > 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: GlassmorphismTheme.surfaceColor.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: GlassmorphismTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        stock.imagePath != null && stock.imagePath!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(stock.imagePath!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
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
                        Text(
                          sale.productName,
                          style: const TextStyle(
                            color: GlassmorphismTheme.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Customer: ${sale.customerName.isNotEmpty ? sale.customerName : 'Walk-in Customer'}',
                          style: const TextStyle(
                            color: GlassmorphismTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Customer: ${sale.customerPhone.isNotEmpty ? sale.customerPhone : 'Walk-in Customer'}',
                          style: const TextStyle(
                            color: GlassmorphismTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
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
                        '\$${NumberFormat('#,##0.00').format(sale.totalAmount.isNaN ? 0.0 : sale.totalAmount)}',
                        style: const TextStyle(
                          color: GlassmorphismTheme.textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildPaymentStatusChip(sale, remainingAmount, isOverdue),
                    ],
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sale Details Section
                    _buildDetailSection('Sale Details', [
                      _buildDetailRow('Product Name', sale.productName),
                      _buildDetailRow('Quantity', '${sale.quantity}'),
                      _buildDetailRow(
                        'Unit Price',
                        '\$${NumberFormat('#,##0.00').format(sale.unitPrice.isNaN ? 0.0 : sale.unitPrice)}',
                      ),
                      _buildDetailRow(
                        'Total Amount',
                        '\$${NumberFormat('#,##0.00').format(sale.totalAmount.isNaN ? 0.0 : sale.totalAmount)}',
                      ),
                      _buildDetailRow(
                        'Payment Status',
                        _getPaymentStatusText(sale.paymentStatus),
                      ),
                      _buildDetailRow('Payment Method', sale.paymentMethod),
                      _buildDetailRow(
                        'Amount Paid',
                        '\$${NumberFormat('#,##0.00').format(sale.amountPaid.isNaN ? 0.0 : sale.amountPaid)}',
                      ),
                      if (remainingAmount > 0)
                        _buildDetailRow(
                          'Remaining Amount',
                          '\$${NumberFormat('#,##0.00').format(remainingAmount.isNaN ? 0.0 : remainingAmount)}',
                        ),
                      if (sale.dueDate != null)
                        _buildDetailRow(
                          'Due Date',
                          DateFormat('MMM dd, yyyy').format(sale.dueDate!),
                        ),
                      if (sale.lastPaymentDate != null)
                        _buildDetailRow(
                          'Last Payment',
                          DateFormat(
                            'MMM dd, yyyy',
                          ).format(sale.lastPaymentDate!),
                        ),
                    ]),
                    const SizedBox(height: 16),
                    // Profit Analysis Section
                    _buildDetailSection('Profit Analysis', [
                      _buildDetailRow(
                        'Cost Price',
                        '\$${NumberFormat('#,##0.00').format(costPrice)}',
                      ),
                      _buildDetailRow(
                        'Selling Price',
                        '\$${NumberFormat('#,##0.00').format(sale.unitPrice.isNaN ? 0.0 : sale.unitPrice)}',
                      ),
                      _buildDetailRow(
                        'Profit Per Unit',
                        '\$${NumberFormat('#,##0.00').format(profitPerUnit.isNaN ? 0.0 : profitPerUnit)}',
                      ),
                      _buildDetailRow(
                        'Total Profit',
                        '\$${NumberFormat('#,##0.00').format(totalProfit.isNaN ? 0.0 : totalProfit)}',
                        color: (totalProfit.isNaN ? 0.0 : totalProfit) >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                      _buildDetailRow(
                        'Profit Margin',
                        '${profitMargin.isNaN ? 0.0 : profitMargin.toStringAsFixed(1)}%',
                        color: (profitMargin.isNaN ? 0.0 : profitMargin) >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ]),
                    if (sale.notes.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildDetailSection('Notes', [
                        _buildDetailRow('', sale.notes, isNotes: true),
                      ]),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: GlassmorphismTheme.surfaceColor.withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  if (remainingAmount > 0)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showPaymentDialog(sale);
                        },
                        icon: const Icon(Icons.payment, size: 18),
                        label: const Text('Record Payment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GlassmorphismTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  if (remainingAmount > 0) const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showEditSaleDialog(sale);
                          },
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showDeleteConfirmation(sale);
                          },
                          icon: const Icon(Icons.delete, size: 18),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: GlassmorphismTheme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? color,
    bool isNotes = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isNotes) ...[
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: const TextStyle(
                  color: GlassmorphismTheme.textSecondaryColor,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color ?? GlassmorphismTheme.textColor,
                fontSize: isNotes ? 13 : 14,
                fontWeight: isNotes ? FontWeight.normal : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSaleDialog() {
    // Don't show dialog if data is still loading
    if (isLoading) {
      ToastUtils.showWarningToast('Please wait while data is loading...');
      return;
    }

    // Ensure stocks list is properly initialized
    if (stocks.isEmpty) {
      ToastUtils.showErrorToast(
        'No products in stock. Please add products first.',
      );
      return;
    }

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
    bool isSubmitting = false;
    String selectedPaymentStatus = 'paid';
    String selectedPaymentMethod = 'cash';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: GlassmorphismTheme.surfaceColor.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
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
                          dropdownColor: GlassmorphismTheme.surfaceColor,
                          style: const TextStyle(
                            color: GlassmorphismTheme.textColor,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Select Product from Stock',
                            labelStyle: const TextStyle(
                              color: GlassmorphismTheme.textColor,
                            ),
                            prefixIcon: const Icon(
                              Icons.inventory,
                              color: GlassmorphismTheme.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: GlassmorphismTheme.primaryColor,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            hintText: 'Choose a product to sell...',
                            hintStyle: TextStyle(
                              color: GlassmorphismTheme.textSecondaryColor,
                            ),
                          ),
                          value: selectedStock,
                          items:
                              (stocks.isEmpty ||
                                  stocks
                                      .where((stock) => stock.quantity > 0)
                                      .isEmpty)
                              ? [
                                  const DropdownMenuItem<Stock>(
                                    enabled: false,
                                    child: Text(
                                      'No products available in stock',
                                      style: TextStyle(
                                        color: GlassmorphismTheme
                                            .textSecondaryColor,
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
                                    child: Text(
                                      '${stock.name} - \$${NumberFormat('#,##0.00').format(stock.unitSellingPrice)} (${stock.quantity} available)',
                                      style: const TextStyle(
                                        color: GlassmorphismTheme.textColor,
                                      ),
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

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: productNameController,
                                style: const TextStyle(
                                  color: GlassmorphismTheme.textColor,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Product Name',
                                  labelStyle: const TextStyle(
                                    color: GlassmorphismTheme.textColor,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.shopping_bag,
                                    color: GlassmorphismTheme.primaryColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: GlassmorphismTheme.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter product name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () async {
                                final result = await Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BarcodeScannerScreen(
                                          title: 'Scan Product Barcode',
                                        ),
                                  ),
                                );
                                if (result != null) {
                                  // Use database service to find stock by barcode
                                  final stockWithBarcode =
                                      await DatabaseService.getStockByBarcode(
                                        result,
                                      );

                                  if (stockWithBarcode != null) {
                                    setModalState(() {
                                      productNameController.text =
                                          stockWithBarcode.name;
                                      selectedStock = stockWithBarcode;
                                      unitPriceController.text =
                                          stockWithBarcode.unitSellingPrice
                                              .toString();
                                    });
                                    ToastUtils.showSuccessToast(
                                      'Product found: ${stockWithBarcode.name}',
                                    );
                                  } else {
                                    ToastUtils.showWarningToast(
                                      'No product found with this barcode',
                                    );
                                  }
                                }
                              },
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    GlassmorphismTheme.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.qr_code_scanner),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  color: GlassmorphismTheme.textColor,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Quantity',
                                  labelStyle: const TextStyle(
                                    color: GlassmorphismTheme.textColor,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.shopping_cart,
                                    color: GlassmorphismTheme.primaryColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: GlassmorphismTheme.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
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
                                style: const TextStyle(
                                  color: GlassmorphismTheme.textColor,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Unit Price',
                                  labelStyle: const TextStyle(
                                    color: GlassmorphismTheme.textColor,
                                  ),
                                  prefixText: '\$',
                                  prefixStyle: const TextStyle(
                                    color: GlassmorphismTheme.textColor,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.attach_money,
                                    color: GlassmorphismTheme.primaryColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: GlassmorphismTheme.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
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
                                style: const TextStyle(
                                  color: GlassmorphismTheme.textColor,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Customer Name (Optional)',
                                  labelStyle: const TextStyle(
                                    color: GlassmorphismTheme.textColor,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: GlassmorphismTheme.primaryColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: GlassmorphismTheme.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: customerPhoneController,
                                style: const TextStyle(
                                  color: GlassmorphismTheme.textColor,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Phone (Optional)',
                                  labelStyle: const TextStyle(
                                    color: GlassmorphismTheme.textColor,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.phone,
                                    color: GlassmorphismTheme.primaryColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: GlassmorphismTheme.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Payment Status Selection
                        DropdownButtonFormField<String>(
                          dropdownColor: GlassmorphismTheme.surfaceColor,
                          style: const TextStyle(
                            color: GlassmorphismTheme.textColor,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Payment Status',
                            labelStyle: const TextStyle(
                              color: GlassmorphismTheme.textColor,
                            ),
                            prefixIcon: const Icon(
                              Icons.payment,
                              color: GlassmorphismTheme.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: GlassmorphismTheme.primaryColor,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                          ),
                          value: selectedPaymentStatus,
                          items: [
                            DropdownMenuItem(
                              value: 'paid',
                              child: const Text(
                                'Paid',
                                style: TextStyle(
                                  color: GlassmorphismTheme.textColor,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'partial',
                              child: const Text(
                                'Partial Payment',
                                style: TextStyle(
                                  color: GlassmorphismTheme.textColor,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'credit',
                              child: const Text(
                                'Credit',
                                style: TextStyle(
                                  color: GlassmorphismTheme.textColor,
                                ),
                              ),
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
                          dropdownColor: GlassmorphismTheme.surfaceColor,
                          style: const TextStyle(
                            color: GlassmorphismTheme.textColor,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Payment Method',
                            labelStyle: const TextStyle(
                              color: GlassmorphismTheme.textColor,
                            ),
                            prefixIcon: const Icon(
                              Icons.credit_card,
                              color: GlassmorphismTheme.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: GlassmorphismTheme.primaryColor,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                          ),
                          value: selectedPaymentMethod,
                          items: [
                            DropdownMenuItem(
                              value: 'cash',
                              child: const Text(
                                'Cash',
                                style: TextStyle(
                                  color: GlassmorphismTheme.textColor,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'card',
                              child: const Text(
                                'Card',
                                style: TextStyle(
                                  color: GlassmorphismTheme.textColor,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'bank_transfer',
                              child: const Text(
                                'Bank Transfer',
                                style: TextStyle(
                                  color: GlassmorphismTheme.textColor,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'credit',
                              child: const Text(
                                'Credit',
                                style: TextStyle(
                                  color: GlassmorphismTheme.textColor,
                                ),
                              ),
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
                            style: const TextStyle(
                              color: GlassmorphismTheme.textColor,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Amount Paid',
                              labelStyle: const TextStyle(
                                color: GlassmorphismTheme.textColor,
                              ),
                              prefixText: '\$',
                              prefixStyle: const TextStyle(
                                color: GlassmorphismTheme.textColor,
                              ),
                              prefixIcon: const Icon(
                                Icons.attach_money,
                                color: GlassmorphismTheme.primaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: GlassmorphismTheme.primaryColor,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
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
                          style: const TextStyle(
                            color: GlassmorphismTheme.textColor,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Notes (Optional)',
                            labelStyle: const TextStyle(
                              color: GlassmorphismTheme.textColor,
                            ),
                            prefixIcon: const Icon(
                              Icons.note,
                              color: GlassmorphismTheme.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: GlassmorphismTheme.primaryColor,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
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
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              setModalState(() => isSubmitting = true);
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
                                ToastUtils.showSuccessToast(
                                  'Sale recorded successfully!',
                                );
                                // Show confetti for successful sale
                                ConfettiUtils.showSuccessConfetti(
                                  _confettiController,
                                );
                                // Show notification for the sale
                                await NotificationService()
                                    .showSaleNotification(sale);

                                // Record activity for engagement tracking
                                EngagementService().recordActivity();
                                EngagementService().checkForNewAchievements();

                                // Show interstitial ad for sale action
                                AdService.instance.showAdForAction(
                                  'sale_recorded',
                                );

                                _loadData(); // Refresh both sales and stocks
                              } catch (e) {
                                ToastUtils.showErrorToast(
                                  'Error recording sale: $e',
                                );
                              } finally {
                                setModalState(() => isSubmitting = false);
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
                    child: isSubmitting
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
      final result = qty * price;
      if (result.isNaN || result.isInfinite) {
        return '0.00';
      }
      return NumberFormat('#,##0.00').format(result);
    } catch (e) {
      return '0.00';
    }
  }

  String _calculateProfitPerUnit(String costPrice, String sellingPrice) {
    try {
      final cost = double.parse(costPrice);
      final selling = double.parse(sellingPrice);
      final profit = selling - cost;
      if (profit.isNaN || profit.isInfinite) {
        return '0.00';
      }
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
      if (totalProfit.isNaN || totalProfit.isInfinite) {
        return '0.00';
      }
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
      if (remaining.isNaN || remaining.isInfinite) {
        return '0.00';
      }
      return NumberFormat('#,##0.00').format(remaining > 0 ? remaining : 0);
    } catch (e) {
      return '0.00';
    }
  }

  void _showPaymentDialog(Sale sale) {
    final paymentController = TextEditingController();
    final remainingAmount = sale.totalAmount - sale.amountPaid;
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: GlassmorphismTheme.surfaceColor,
          title: const Text(
            'Record Payment',
            style: TextStyle(color: GlassmorphismTheme.textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sale: ${sale.productName}',
                style: const TextStyle(
                  color: GlassmorphismTheme.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Customer: ${sale.customerName.isNotEmpty ? sale.customerName : 'Walk-in Customer'}',
                style: const TextStyle(
                  color: GlassmorphismTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total Amount:',
                      style: const TextStyle(
                        color: GlassmorphismTheme.textColor,
                      ),
                    ),
                  ),
                  Text(
                    '\$${NumberFormat('#,##0.00').format(sale.totalAmount)}',
                    style: const TextStyle(
                      color: GlassmorphismTheme.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Amount Paid:',
                      style: const TextStyle(
                        color: GlassmorphismTheme.textColor,
                      ),
                    ),
                  ),
                  Text(
                    '\$${NumberFormat('#,##0.00').format(sale.amountPaid)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Remaining:',
                      style: const TextStyle(
                        color: GlassmorphismTheme.textColor,
                      ),
                    ),
                  ),
                  Text(
                    '\$${NumberFormat('#,##0.00').format(remainingAmount)}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: paymentController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: GlassmorphismTheme.textColor),
                decoration: InputDecoration(
                  labelText: 'Payment Amount',
                  labelStyle: const TextStyle(
                    color: GlassmorphismTheme.textColor,
                  ),
                  prefixText: '\$',
                  prefixStyle: const TextStyle(
                    color: GlassmorphismTheme.textColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: GlassmorphismTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter payment amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  final payment = double.parse(value);
                  if (payment <= 0) {
                    return 'Payment amount must be greater than 0';
                  }
                  if (payment > remainingAmount) {
                    return 'Payment cannot exceed remaining amount';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      if (paymentController.text.isNotEmpty) {
                        setDialogState(() => isSubmitting = true);
                        try {
                          final paymentAmount = double.parse(
                            paymentController.text,
                          );
                          final newAmountPaid = sale.amountPaid + paymentAmount;

                          // Update the sale with new payment
                          sale.amountPaid = newAmountPaid;
                          sale.lastPaymentDate = DateTime.now();

                          // Update payment status based on remaining amount
                          final newRemaining = sale.totalAmount - newAmountPaid;
                          if (newRemaining <= 0) {
                            sale.paymentStatus = 'paid';
                          } else if (newAmountPaid > 0) {
                            sale.paymentStatus = 'partial';
                          }

                          await DatabaseService.updateSale(sale);

                          Navigator.pop(context);
                          ToastUtils.showSuccessToast(
                            'Payment recorded successfully!',
                          );
                          _loadData(); // Refresh data
                        } catch (e) {
                          ToastUtils.showErrorToast(
                            'Error recording payment: $e',
                          );
                        } finally {
                          setDialogState(() => isSubmitting = false);
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlassmorphismTheme.primaryColor,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Record Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditSaleDialog(Sale sale) {
    final productNameController = TextEditingController(text: sale.productName);
    final customerNameController = TextEditingController(
      text: sale.customerName,
    );
    final quantityController = TextEditingController(
      text: sale.quantity.toString(),
    );
    final unitPriceController = TextEditingController(
      text: sale.unitPrice.toString(),
    );
    final amountPaidController = TextEditingController(
      text: sale.amountPaid.toString(),
    );
    final notesController = TextEditingController(text: sale.notes);
    final paymentStatusController = TextEditingController(
      text: sale.paymentStatus,
    );
    DateTime selectedDate = sale.saleDate;
    DateTime? selectedDueDate = sale.dueDate;
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: GlassmorphismTheme.surfaceColor,
              title: const Text(
                'Edit Sale',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: productNameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
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
                    TextFormField(
                      controller: customerNameController,
                      decoration: const InputDecoration(
                        labelText: 'Customer Name',
                        border: OutlineInputBorder(),
                      ),
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
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter quantity';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
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
                              border: OutlineInputBorder(),
                            ),
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
                      controller: amountPaidController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount Paid',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount paid';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: paymentStatusController.text,
                      decoration: const InputDecoration(
                        labelText: 'Payment Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'paid', child: Text('Paid')),
                        DropdownMenuItem(
                          value: 'partial',
                          child: Text('Partial'),
                        ),
                        DropdownMenuItem(
                          value: 'pending',
                          child: Text('Pending'),
                        ),
                      ],
                      onChanged: (value) {
                        paymentStatusController.text = value ?? 'pending';
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text(
                        'Sale Date',
                        style: TextStyle(color: GlassmorphismTheme.textColor),
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
                          setDialogState(() {
                            selectedDate = date;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Due Date (Optional)',
                        style: TextStyle(color: GlassmorphismTheme.textColor),
                      ),
                      subtitle: Text(
                        selectedDueDate != null
                            ? DateFormat(
                                'MMM dd, yyyy',
                              ).format(selectedDueDate!)
                            : 'No due date',
                        style: const TextStyle(
                          color: GlassmorphismTheme.textSecondaryColor,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selectedDueDate != null)
                            IconButton(
                              onPressed: () {
                                setDialogState(() {
                                  selectedDueDate = null;
                                });
                              },
                              icon: const Icon(Icons.clear, size: 16),
                            ),
                          const Icon(
                            Icons.calendar_today,
                            color: GlassmorphismTheme.primaryColor,
                          ),
                        ],
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDueDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date != null) {
                          setDialogState(() {
                            selectedDueDate = date;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Notes (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (productNameController.text.isNotEmpty &&
                              quantityController.text.isNotEmpty &&
                              unitPriceController.text.isNotEmpty &&
                              amountPaidController.text.isNotEmpty) {
                            setDialogState(() => isSubmitting = true);
                            try {
                              final quantity = double.parse(
                                quantityController.text,
                              );
                              final unitPrice = double.parse(
                                unitPriceController.text,
                              );
                              final amountPaid = double.parse(
                                amountPaidController.text,
                              );
                              final totalAmount = quantity * unitPrice;

                              if (amountPaid > totalAmount) {
                                ToastUtils.showErrorToast(
                                  'Amount paid cannot exceed total amount',
                                );
                                return;
                              }

                              // Update sale data
                              sale.productName = productNameController.text;
                              sale.customerName = customerNameController.text;
                              sale.quantity = quantity;
                              sale.unitPrice = unitPrice;
                              sale.totalAmount = totalAmount;
                              sale.amountPaid = amountPaid;
                              sale.paymentStatus = paymentStatusController.text;
                              sale.saleDate = selectedDate;
                              sale.dueDate = selectedDueDate;
                              sale.notes = notesController.text;

                              await DatabaseService.updateSale(sale);

                              Navigator.pop(context);
                              ToastUtils.showSuccessToast(
                                'Sale updated successfully!',
                              );
                              _loadData(); // Refresh data
                            } catch (e) {
                              ToastUtils.showErrorToast(
                                'Error updating sale: $e',
                              );
                            } finally {
                              setDialogState(() => isSubmitting = false);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlassmorphismTheme.primaryColor,
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Update Sale'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(Sale sale) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: GlassmorphismTheme.surfaceColor,
          title: const Text(
            'Delete Sale',
            style: TextStyle(color: GlassmorphismTheme.textColor),
          ),
          content: Text(
            'Are you sure you want to delete the sale of "${sale.productName}" to "${sale.customerName}"? This action cannot be undone.',
            style: const TextStyle(
              color: GlassmorphismTheme.textSecondaryColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await DatabaseService.deleteSale(sale.id);
                  Navigator.pop(context);
                  ToastUtils.showSuccessToast('Sale deleted successfully!');
                  _loadData(); // Refresh data
                } catch (e) {
                  ToastUtils.showErrorToast('Error deleting sale: $e');
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
