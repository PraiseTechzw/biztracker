import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/database_service.dart';
import '../models/business_data.dart';
import '../utils/search_filter_utils.dart';
import 'barcode_scanner_screen.dart';

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
  String selectedCategory = 'All';
  List<String> categories = [
    'All',
    'Electronics',
    'Clothing',
    'Food',
    'Books',
    'Tools',
    'Other',
  ];

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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GlassmorphismTheme.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.inventory,
                  color: GlassmorphismTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Stock Management',
                  style: TextStyle(
                    color: GlassmorphismTheme.textColor,
                    fontSize: 22,
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
              IconButton(
                onPressed: _showCategoryFilter,
                icon: const Icon(
                  Icons.filter_list,
                  color: GlassmorphismTheme.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 12),
          _buildStockSummary(),
        ],
      ),
    );
  }

  Widget _buildStockSummary() {
    final totalItems = filteredStocks.length;
    final totalValue = filteredStocks.fold<double>(
      0.0,
      (sum, stock) => sum + stock.totalValue,
    );
    final lowStockItems = filteredStocks
        .where((stock) => stock.quantity <= stock.reorderLevel)
        .length;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Items',
            totalItems.toString(),
            Icons.inventory,
            GlassmorphismTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Total Value',
            '\$${NumberFormat('#,##0.00').format(totalValue)}',
            Icons.attach_money,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Low Stock',
            lowStockItems.toString(),
            Icons.warning,
            lowStockItems > 0 ? Colors.orange : Colors.grey,
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
          return _buildStockCard(stock);
        },
      ),
    );
  }

  Widget _buildStockCard(Stock stock) {
    final isLowStock = stock.quantity <= stock.reorderLevel;
    final profitMargin =
        ((stock.unitSellingPrice - stock.unitCostPrice) / stock.unitCostPrice) *
        100;

    return GlassmorphismTheme.glassmorphismContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // Stock Image or Icon
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
                            Icons.inventory,
                            color: GlassmorphismTheme.primaryColor,
                            size: 30,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.inventory,
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
                            stock.name,
                            style: const TextStyle(
                              color: GlassmorphismTheme.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isLowStock)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Low Stock',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stock.category,
                      style: TextStyle(
                        color: GlassmorphismTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStockInfo('Quantity', '${stock.quantity}')),
              Expanded(
                child: _buildStockInfo(
                  'Cost Price',
                  '\$${NumberFormat('#,##0.00').format(stock.unitCostPrice)}',
                ),
              ),
              Expanded(
                child: _buildStockInfo(
                  'Selling Price',
                  '\$${NumberFormat('#,##0.00').format(stock.unitSellingPrice)}',
                ),
              ),
              Expanded(
                child: _buildStockInfo(
                  'Profit/Unit',
                  '\$${NumberFormat('#,##0.00').format(stock.unitSellingPrice - stock.unitCostPrice)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStockInfo(
                  'Profit Margin',
                  '${profitMargin.toStringAsFixed(1)}%',
                ),
              ),
              Expanded(
                child: _buildStockInfo(
                  'Total Profit',
                  '\$${NumberFormat('#,##0.00').format((stock.unitSellingPrice - stock.unitCostPrice) * stock.quantity)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Value: \$${NumberFormat('#,##0.00').format(stock.totalValue)}',
                style: const TextStyle(
                  color: GlassmorphismTheme.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (stock.supplierName != null && stock.supplierName!.isNotEmpty)
                Text(
                  'Supplier: ${stock.supplierName}',
                  style: const TextStyle(
                    color: GlassmorphismTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
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
    final categoryController = TextEditingController(
      text: stock?.category ?? 'Electronics',
    );
    final barcodeController = TextEditingController(text: stock?.barcode ?? '');
    final supplierNameController = TextEditingController(
      text: stock?.supplierName ?? '',
    );
    final supplierContactController = TextEditingController(
      text: stock?.supplierContact ?? '',
    );
    final quantityController = TextEditingController(
      text: stock?.quantity.toString() ?? '',
    );
    final costPriceController = TextEditingController(
      text: stock?.unitCostPrice.toString() ?? '',
    );
    final sellingPriceController = TextEditingController(
      text: stock?.unitSellingPrice.toString() ?? '',
    );
    final reorderLevelController = TextEditingController(
      text: stock?.reorderLevel.toString() ?? '5',
    );

    String? selectedImagePath = stock?.imagePath;
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
                    child: ListView(
                      children: [
                        // Image Section
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                // Show option to choose camera or gallery
                                final ImageSource? source =
                                    await showDialog<ImageSource>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor:
                                              GlassmorphismTheme.surfaceColor,
                                          title: const Text(
                                            'Select Image Source',
                                            style: TextStyle(
                                              color:
                                                  GlassmorphismTheme.textColor,
                                            ),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.camera_alt,
                                                  color: GlassmorphismTheme
                                                      .primaryColor,
                                                ),
                                                title: const Text(
                                                  'Camera',
                                                  style: TextStyle(
                                                    color: GlassmorphismTheme
                                                        .textColor,
                                                  ),
                                                ),
                                                onTap: () => Navigator.pop(
                                                  context,
                                                  ImageSource.camera,
                                                ),
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.photo_library,
                                                  color: GlassmorphismTheme
                                                      .primaryColor,
                                                ),
                                                title: const Text(
                                                  'Gallery',
                                                  style: TextStyle(
                                                    color: GlassmorphismTheme
                                                        .textColor,
                                                  ),
                                                ),
                                                onTap: () => Navigator.pop(
                                                  context,
                                                  ImageSource.gallery,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                if (source != null) {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(
                                    source: source,
                                    maxWidth: 800,
                                    maxHeight: 800,
                                    imageQuality: 80,
                                  );
                                  if (image != null) {
                                    setModalState(() {
                                      selectedImagePath = image.path;
                                    });
                                  }
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error picking image: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: GlassmorphismTheme.primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: GlassmorphismTheme.primaryColor
                                      .withOpacity(0.3),
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: selectedImagePath != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(selectedImagePath!),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.add_a_photo,
                                                  color: GlassmorphismTheme
                                                      .primaryColor,
                                                  size: 40,
                                                ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.add_a_photo,
                                      color: GlassmorphismTheme.primaryColor,
                                      size: 40,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Basic Information
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Item Name',
                            prefixIcon: Icon(Icons.inventory),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter item name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Barcode Field
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: barcodeController,
                                decoration: const InputDecoration(
                                  labelText: 'Barcode/QR Code (Optional)',
                                  prefixIcon: Icon(Icons.qr_code),
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  final result = await Navigator.push<String>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BarcodeScannerScreen(
                                            title: 'Scan Barcode',
                                          ),
                                    ),
                                  );
                                  if (result != null) {
                                    setModalState(() {
                                      barcodeController.text = result;
                                    });
                                  }
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
                                          title: 'Scan Barcode',
                                        ),
                                  ),
                                );
                                if (result != null) {
                                  setModalState(() {
                                    barcodeController.text = result;
                                  });
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

                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description (Optional)',
                            prefixIcon: Icon(Icons.description),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: categoryController.text,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            prefixIcon: Icon(Icons.category),
                            border: OutlineInputBorder(),
                          ),
                          items: categories.where((cat) => cat != 'All').map((
                            category,
                          ) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setModalState(() {
                                categoryController.text = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Supplier Information
                        TextFormField(
                          controller: supplierNameController,
                          decoration: const InputDecoration(
                            labelText: 'Supplier Name (Optional)',
                            prefixIcon: Icon(Icons.business),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: supplierContactController,
                          decoration: const InputDecoration(
                            labelText: 'Supplier Contact (Optional)',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Pricing and Quantity
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
                                controller: reorderLevelController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Reorder Level',
                                  prefixIcon: Icon(Icons.warning),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter reorder level';
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
                                controller: costPriceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Cost Price',
                                  prefixText: '\$',
                                  prefixIcon: Icon(Icons.price_change),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter cost price';
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
                                controller: sellingPriceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Selling Price',
                                  prefixText: '\$',
                                  prefixIcon: Icon(Icons.sell),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter selling price';
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
                        const SizedBox(height: 24),

                        // Summary Card
                        if (costPriceController.text.isNotEmpty &&
                            quantityController.text.isNotEmpty)
                          GlassmorphismTheme.glassmorphismContainer(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Financial Summary',
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
                                      'Total Cost Value:',
                                      style: const TextStyle(
                                        color: GlassmorphismTheme
                                            .textSecondaryColor,
                                      ),
                                    ),
                                    Text(
                                      '\$${_calculateTotalValue(costPriceController.text, quantityController.text)}',
                                      style: const TextStyle(
                                        color: GlassmorphismTheme.textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (sellingPriceController.text.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Selling Value:',
                                        style: const TextStyle(
                                          color: GlassmorphismTheme
                                              .textSecondaryColor,
                                        ),
                                      ),
                                      Text(
                                        '\$${_calculateTotalSellingValue(sellingPriceController.text, quantityController.text)}',
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
                                        'Profit Per Unit:',
                                        style: const TextStyle(
                                          color: GlassmorphismTheme
                                              .textSecondaryColor,
                                        ),
                                      ),
                                      Text(
                                        '\$${_calculateProfitPerUnit(costPriceController.text, sellingPriceController.text)}',
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
                                        '\$${_calculateTotalProfit(costPriceController.text, sellingPriceController.text, quantityController.text)}',
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
                                        'Profit Margin:',
                                        style: const TextStyle(
                                          color: GlassmorphismTheme
                                              .textSecondaryColor,
                                        ),
                                      ),
                                      Text(
                                        '${_calculateProfitMargin(costPriceController.text, sellingPriceController.text)}%',
                                        style: const TextStyle(
                                          color: Colors.green,
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
                                final costPrice = double.parse(
                                  costPriceController.text,
                                );
                                final sellingPrice = double.parse(
                                  sellingPriceController.text,
                                );
                                final reorderLevel = double.parse(
                                  reorderLevelController.text,
                                );
                                final totalValue = quantity * costPrice;

                                if (stock == null) {
                                  // Add new stock
                                  final newStock = Stock()
                                    ..name = nameController.text
                                    ..description = descriptionController.text
                                    ..category = categoryController.text
                                    ..barcode = barcodeController.text.isEmpty
                                        ? null
                                        : barcodeController.text
                                    ..supplierName =
                                        supplierNameController.text.isEmpty
                                        ? null
                                        : supplierNameController.text
                                    ..supplierContact =
                                        supplierContactController.text.isEmpty
                                        ? null
                                        : supplierContactController.text
                                    ..imagePath = selectedImagePath
                                    ..quantity = quantity
                                    ..unitCostPrice = costPrice
                                    ..unitSellingPrice = sellingPrice
                                    ..totalValue = totalValue
                                    ..reorderLevel = reorderLevel
                                    ..createdAt = DateTime.now()
                                    ..updatedAt = DateTime.now();

                                  await DatabaseService.addStock(newStock);
                                } else {
                                  // Update existing stock
                                  stock.name = nameController.text;
                                  stock.description =
                                      descriptionController.text;
                                  stock.category = categoryController.text;
                                  stock.barcode = barcodeController.text.isEmpty
                                      ? null
                                      : barcodeController.text;
                                  stock.supplierName =
                                      supplierNameController.text.isEmpty
                                      ? null
                                      : supplierNameController.text;
                                  stock.supplierContact =
                                      supplierContactController.text.isEmpty
                                      ? null
                                      : supplierContactController.text;
                                  stock.imagePath = selectedImagePath;
                                  stock.quantity = quantity;
                                  stock.unitCostPrice = costPrice;
                                  stock.unitSellingPrice = sellingPrice;
                                  stock.totalValue = totalValue;
                                  stock.reorderLevel = reorderLevel;
                                  stock.updatedAt = DateTime.now();

                                  await DatabaseService.updateStock(stock);
                                }

                                Navigator.pop(context);
                                _loadStocks();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
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
                        : Text(
                            stock == null
                                ? 'Add Stock Item'
                                : 'Update Stock Item',
                            style: const TextStyle(
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

  String _calculateTotalValue(String costPrice, String quantity) {
    try {
      final cost = double.parse(costPrice);
      final qty = double.parse(quantity);
      return NumberFormat('#,##0.00').format(cost * qty);
    } catch (e) {
      return '0.00';
    }
  }

  String _calculateTotalSellingValue(String sellingPrice, String quantity) {
    try {
      final selling = double.parse(sellingPrice);
      final qty = double.parse(quantity);
      return NumberFormat('#,##0.00').format(selling * qty);
    } catch (e) {
      return '0.00';
    }
  }

  String _calculateProfitMargin(String costPrice, String sellingPrice) {
    try {
      final cost = double.parse(costPrice);
      final selling = double.parse(sellingPrice);
      if (cost > 0) {
        final margin = ((selling - cost) / cost) * 100;
        return margin.toStringAsFixed(1);
      }
      return '0.0';
    } catch (e) {
      return '0.0';
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

  void _showCategoryFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Filter by Category',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: categories.map((category) {
            return ListTile(
              title: Text(
                category,
                style: const TextStyle(color: GlassmorphismTheme.textColor),
              ),
              trailing: selectedCategory == category
                  ? const Icon(
                      Icons.check,
                      color: GlassmorphismTheme.primaryColor,
                    )
                  : null,
              onTap: () {
                setState(() {
                  selectedCategory = category;
                });
                _applyFilters();
                Navigator.pop(context);
              },
            );
          }).toList(),
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
    var filtered = stocks;

    // Apply category filter
    if (selectedCategory != 'All') {
      filtered = filtered
          .where((stock) => stock.category == selectedCategory)
          .toList();
    }

    // Apply search filter
    filtered = SearchFilterUtils.searchStocks(filtered, searchQuery);

    // Apply sort
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
            _buildSortOption('Cost Price (Low-High)', 'cost_price'),
            _buildSortOption('Cost Price (High-Low)', 'cost_price_desc'),
            _buildSortOption('Selling Price (Low-High)', 'selling_price'),
            _buildSortOption('Selling Price (High-Low)', 'selling_price_desc'),
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
