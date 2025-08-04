import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/database_service.dart';
import '../models/business_data.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List<Stock> stocks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStocks();
  }

  Future<void> _loadStocks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await DatabaseService.getAllStocks();
      setState(() {
        stocks = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
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
                      : _buildStockList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStockDialog,
        backgroundColor: GlassmorphismTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: GlassmorphismTheme.textColor,
            ),
          ),
          const Expanded(
            child: Text(
              'Stock Management',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockList() {
    if (stocks.isEmpty) {
      return Center(
        child: GlassmorphismTheme.glassmorphismContainer(
          padding: const EdgeInsets.all(32),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_outlined,
                color: GlassmorphismTheme.textSecondaryColor,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'No stock items yet',
                style: TextStyle(
                  color: GlassmorphismTheme.textSecondaryColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add your inventory items to track stock',
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

    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
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
                      color: GlassmorphismTheme.secondaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.inventory,
                      color: GlassmorphismTheme.secondaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stock.name,
                          style: const TextStyle(
                            color: GlassmorphismTheme.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (stock.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            stock.description,
                            style: const TextStyle(
                              color: GlassmorphismTheme.textSecondaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: GlassmorphismTheme.textColor,
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditStockDialog(stock);
                      } else if (value == 'delete') {
                        _showDeleteConfirmation(stock);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStockInfo('Quantity', '${stock.quantity}'),
                  _buildStockInfo(
                    'Unit Price',
                    '\$${NumberFormat('#,##0.00').format(stock.unitPrice)}',
                  ),
                  _buildStockInfo(
                    'Total Value',
                    '\$${NumberFormat('#,##0.00').format(stock.totalValue)}',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStockInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: GlassmorphismTheme.textSecondaryColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: GlassmorphismTheme.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showAddStockDialog() {
    _showStockDialog(null);
  }

  void _showEditStockDialog(Stock stock) {
    _showStockDialog(stock);
  }

  void _showStockDialog(Stock? stock) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: stock?.name ?? '');
    final descriptionController = TextEditingController(
      text: stock?.description ?? '',
    );
    final quantityController = TextEditingController(
      text: stock?.quantity.toString() ?? '',
    );
    final unitPriceController = TextEditingController(
      text: stock?.unitPrice.toString() ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: GlassmorphismTheme.surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    stock == null ? 'Add Stock Item' : 'Edit Stock Item',
                    style: const TextStyle(
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
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter item name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description (Optional)',
                        ),
                        maxLines: 3,
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
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final quantity = double.parse(
                                quantityController.text,
                              );
                              final unitPrice = double.parse(
                                unitPriceController.text,
                              );
                              final totalValue = quantity * unitPrice;

                              if (stock == null) {
                                // Add new stock
                                final newStock = Stock()
                                  ..name = nameController.text
                                  ..description = descriptionController.text
                                  ..quantity = quantity
                                  ..unitPrice = unitPrice
                                  ..totalValue = totalValue
                                  ..createdAt = DateTime.now()
                                  ..updatedAt = DateTime.now();

                                await DatabaseService.addStock(newStock);
                              } else {
                                // Update existing stock
                                stock.name = nameController.text;
                                stock.description = descriptionController.text;
                                stock.quantity = quantity;
                                stock.unitPrice = unitPrice;
                                stock.totalValue = totalValue;
                                stock.updatedAt = DateTime.now();

                                await DatabaseService.updateStock(stock);
                              }

                              Navigator.pop(context);
                              _loadStocks();
                            }
                          },
                          child: Text(
                            stock == null
                                ? 'Add Stock Item'
                                : 'Update Stock Item',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Stock stock) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Delete Stock Item',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: Text(
          'Are you sure you want to delete "${stock.name}"?',
          style: const TextStyle(color: GlassmorphismTheme.textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseService.deleteStock(stock.id);
              Navigator.pop(context);
              _loadStocks();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
