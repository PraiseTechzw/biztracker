import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/database_service.dart';
import '../models/business_data.dart';
import '../utils/search_filter_utils.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List<Stock> stocks = [];
  List<Stock> filteredStocks = [];
  bool isLoading = true;
  String searchQuery = '';
  String sortBy = 'date_desc';

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
        filteredStocks = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshStocks() async {
    await _loadStocks();
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
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Stock Management',
                  style: TextStyle(
                    color: GlassmorphismTheme.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: _showSortDialog,
                icon: const Icon(
                  Icons.sort,
                  color: GlassmorphismTheme.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: _onSearchChanged,
        decoration: const InputDecoration(
          hintText: 'Search stocks...',
          prefixIcon: Icon(
            Icons.search,
            color: GlassmorphismTheme.textSecondaryColor,
          ),
          border: InputBorder.none,
          hintStyle: TextStyle(color: GlassmorphismTheme.textSecondaryColor),
        ),
        style: const TextStyle(color: GlassmorphismTheme.textColor),
      ),
    );
  }

  Widget _buildStockList() {
    if (filteredStocks.isEmpty) {
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
                'Add your first stock item to get started',
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
      onRefresh: _refreshStocks,
      color: GlassmorphismTheme.primaryColor,
      child: ListView.builder(
        itemCount: filteredStocks.length,
        itemBuilder: (context, index) {
          final stock = filteredStocks[index];
          return GlassmorphismTheme.glassmorphismContainer(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: GlassmorphismTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory,
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
                        stock.name,
                        style: const TextStyle(
                          color: GlassmorphismTheme.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stock.description,
                        style: const TextStyle(
                          color: GlassmorphismTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Qty: ${stock.quantity} | Price: \$${NumberFormat('#,##0.00').format(stock.unitPrice)}',
                        style: const TextStyle(
                          color: GlassmorphismTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${NumberFormat('#,##0.00').format(stock.totalValue)}',
                  style: const TextStyle(
                    color: GlassmorphismTheme.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
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

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    var filtered = SearchFilterUtils.searchStocks(stocks, searchQuery);
    filtered = SearchFilterUtils.sortStocks(filtered, sortBy);
    setState(() {
      filteredStocks = filtered;
    });
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Sort By',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortOption('Name (A-Z)', 'name'),
            _buildSortOption('Name (Z-A)', 'name_desc'),
            _buildSortOption('Price (Low-High)', 'price'),
            _buildSortOption('Price (High-Low)', 'price_desc'),
            _buildSortOption('Quantity (Low-High)', 'quantity'),
            _buildSortOption('Quantity (High-Low)', 'quantity_desc'),
            _buildSortOption('Value (Low-High)', 'value'),
            _buildSortOption('Value (High-Low)', 'value_desc'),
            _buildSortOption('Date (Newest)', 'date_desc'),
            _buildSortOption('Date (Oldest)', 'date'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: GlassmorphismTheme.textColor),
      ),
      trailing: sortBy == value
          ? const Icon(Icons.check, color: GlassmorphismTheme.primaryColor)
          : null,
      onTap: () {
        setState(() {
          sortBy = value;
        });
        _applyFilters();
        Navigator.pop(context);
      },
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
