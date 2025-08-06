import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/database_service.dart';
import '../models/business_data.dart';

class CapitalScreen extends StatefulWidget {
  const CapitalScreen({super.key});

  @override
  State<CapitalScreen> createState() => _CapitalScreenState();
}

class _CapitalScreenState extends State<CapitalScreen>
    with SingleTickerProviderStateMixin {
  List<Capital> capitals = [];
  List<Expense> expenses = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  bool isAdding = false;
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      final capitalData = await DatabaseService.getAllCapitals();
      final expenseData = await DatabaseService.getAllExpenses();
      setState(() {
        capitals = capitalData;
        expenses = expenseData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Failed to load data: $e';
      });
    }
  }

  Future<void> _refreshData() async {
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
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Capital Tab
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: GlassmorphismTheme.primaryColor,
                              ),
                            )
                          : _buildCapitalList(),
                    ),
                    // Expenses Tab
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: GlassmorphismTheme.primaryColor,
                              ),
                            )
                          : _buildExpensesList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectedTabIndex == 0
            ? _showAddCapitalDialog
            : _showAddExpenseDialog,
        backgroundColor: GlassmorphismTheme.primaryColor,
        child: Icon(
          _selectedTabIndex == 0 ? Icons.add : Icons.receipt_long,
          color: Colors.white,
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
                child: Icon(
                  _selectedTabIndex == 0
                      ? Icons.account_balance_wallet
                      : Icons.receipt_long,
                  color: GlassmorphismTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _selectedTabIndex == 0
                      ? 'Capital Management'
                      : 'Expense Management',
                  style: const TextStyle(
                    color: GlassmorphismTheme.textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: GlassmorphismTheme.surfaceColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: GlassmorphismTheme.primaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: GlassmorphismTheme.textSecondaryColor,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Capital'),
                Tab(text: 'Expenses'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapitalList() {
    if (hasError) {
      return _buildErrorState();
    }

    if (capitals.isEmpty) {
      return Center(
        child: GlassmorphismTheme.glassmorphismContainer(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: GlassmorphismTheme.primaryColor.withOpacity(0.5),
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'No capital entries yet',
                style: TextStyle(
                  color: GlassmorphismTheme.textSecondaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add your initial or additional capital to get started.',
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
      onRefresh: _refreshData,
      color: GlassmorphismTheme.primaryColor,
      child: ListView.builder(
        itemCount: capitals.length,
        itemBuilder: (context, index) {
          final capital = capitals[index];
          return GestureDetector(
            onTap: () => _showCapitalDetailsBottomSheet(capital),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              child: GlassmorphismTheme.glassmorphismContainer(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: capital.type == 'initial'
                            ? GlassmorphismTheme.primaryColor.withOpacity(0.18)
                            : Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        capital.type == 'initial'
                            ? Icons.account_balance_wallet
                            : Icons.add_circle,
                        color: capital.type == 'initial'
                            ? GlassmorphismTheme.primaryColor
                            : Colors.green,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capital.description,
                            style: const TextStyle(
                              color: GlassmorphismTheme.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: capital.type == 'initial'
                                        ? GlassmorphismTheme.primaryColor
                                              .withOpacity(0.13)
                                        : Colors.green.withOpacity(0.13),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    capital.type == 'initial'
                                        ? 'Initial Capital'
                                        : 'Additional Capital',
                                    style: TextStyle(
                                      color: capital.type == 'initial'
                                          ? GlassmorphismTheme.primaryColor
                                          : Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.calendar_today,
                                size: 13,
                                color: GlassmorphismTheme.textSecondaryColor,
                              ),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(capital.date),
                                  style: const TextStyle(
                                    color:
                                        GlassmorphismTheme.textSecondaryColor,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${NumberFormat('#,##0.00').format(capital.amount)}',
                          style: const TextStyle(
                            color: GlassmorphismTheme.textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _showEditCapitalDialog(capital),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 20,
                              ),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              onPressed: () => _showDeleteConfirmation(capital),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: GlassmorphismTheme.glassmorphismContainer(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.withOpacity(0.7),
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load data',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: const TextStyle(
                color: GlassmorphismTheme.textSecondaryColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshData,
              style: ElevatedButton.styleFrom(
                backgroundColor: GlassmorphismTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCapitalDetailsBottomSheet(Capital capital) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: capital.type == 'initial'
                          ? GlassmorphismTheme.primaryColor.withOpacity(0.18)
                          : Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      capital.type == 'initial'
                          ? Icons.account_balance_wallet
                          : Icons.add_circle,
                      color: capital.type == 'initial'
                          ? GlassmorphismTheme.primaryColor
                          : Colors.green,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capital.description,
                          style: const TextStyle(
                            color: GlassmorphismTheme.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          capital.type == 'initial'
                              ? 'Initial Capital'
                              : 'Additional Capital',
                          style: TextStyle(
                            color: capital.type == 'initial'
                                ? GlassmorphismTheme.primaryColor
                                : Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          DateFormat('MMM dd, yyyy').format(capital.date),
                          style: const TextStyle(
                            color: GlassmorphismTheme.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${NumberFormat('#,##0.00').format(capital.amount)}',
                    style: const TextStyle(
                      color: GlassmorphismTheme.textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
                    // Capital Details Section
                    _buildDetailSection('Capital Details', [
                      _buildDetailRow('Description', capital.description),
                      _buildDetailRow(
                        'Type',
                        capital.type == 'initial'
                            ? 'Initial Capital'
                            : 'Additional Capital',
                      ),
                      _buildDetailRow(
                        'Amount',
                        '\$${NumberFormat('#,##0.00').format(capital.amount)}',
                      ),
                      _buildDetailRow(
                        'Date',
                        DateFormat('MMM dd, yyyy').format(capital.date),
                      ),
                      _buildDetailRow(
                        'Created',
                        DateFormat('MMM dd, yyyy').format(capital.createdAt),
                      ),
                    ]),
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
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditCapitalDialog(capital);
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
                        _showDeleteConfirmation(capital);
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: GlassmorphismTheme.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCapitalDialog() {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedType = 'initial';
    DateTime selectedDate = DateTime.now();
    bool localIsLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: GlassmorphismTheme.surfaceColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Capital',
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
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Amount',
                                    prefixText: '\$',
                                    prefixIcon: Icon(Icons.attach_money),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an amount';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              ToggleButtons(
                                isSelected: [
                                  selectedType == 'initial',
                                  selectedType == 'additional',
                                ],
                                onPressed: (index) {
                                  setModalState(() {
                                    selectedType = index == 0
                                        ? 'initial'
                                        : 'additional';
                                  });
                                },
                                borderRadius: BorderRadius.circular(10),
                                selectedColor: Colors.white,
                                fillColor: GlassmorphismTheme.primaryColor,
                                color: GlassmorphismTheme.primaryColor,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text('Initial'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text('Additional'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              prefixIcon: Icon(Icons.description),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Date',
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
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary:
                                            GlassmorphismTheme.primaryColor,
                                        surface:
                                            GlassmorphismTheme.surfaceColor,
                                        onSurface: GlassmorphismTheme.textColor,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (date != null) {
                                setModalState(() {
                                  selectedDate = date;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 18),
                          // Summary
                          GlassmorphismTheme.glassmorphismContainer(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Icon(
                                  selectedType == 'initial'
                                      ? Icons.account_balance_wallet
                                      : Icons.add_circle,
                                  color: selectedType == 'initial'
                                      ? GlassmorphismTheme.primaryColor
                                      : Colors.green,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        descriptionController.text.isNotEmpty
                                            ? descriptionController.text
                                            : 'Description',
                                        style: const TextStyle(
                                          color: GlassmorphismTheme.textColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        selectedType == 'initial'
                                            ? 'Initial Capital'
                                            : 'Additional Capital',
                                        style: TextStyle(
                                          color: selectedType == 'initial'
                                              ? GlassmorphismTheme.primaryColor
                                              : Colors.green,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        DateFormat(
                                          'MMM dd, yyyy',
                                        ).format(selectedDate),
                                        style: const TextStyle(
                                          color: GlassmorphismTheme
                                              .textSecondaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  amountController.text.isNotEmpty
                                      ? '\$${amountController.text}'
                                      : '\$0.00',
                                  style: const TextStyle(
                                    color: GlassmorphismTheme.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: localIsLoading
                          ? null
                          : () async {
                              if (formKey.currentState!.validate()) {
                                setModalState(() => localIsLoading = true);
                                try {
                                  final capital = Capital()
                                    ..amount = double.parse(
                                      amountController.text,
                                    )
                                    ..description = descriptionController.text
                                    ..type = selectedType
                                    ..date = selectedDate
                                    ..createdAt = DateTime.now();
                                  await DatabaseService.addCapital(capital);
                                  Navigator.pop(context);
                                  _loadData(); // Refresh the list
                                } catch (e) {
                                  // Show error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to add capital: $e',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } finally {
                                  setModalState(() => localIsLoading = false);
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
                      child: localIsLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Add Capital',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpensesList() {
    if (hasError) {
      return _buildErrorState();
    }

    if (expenses.isEmpty) {
      return Center(
        child: GlassmorphismTheme.glassmorphismContainer(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: GlassmorphismTheme.primaryColor.withOpacity(0.5),
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'No expenses recorded yet',
                style: TextStyle(
                  color: GlassmorphismTheme.textSecondaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add your first expense to get started.',
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
      onRefresh: _refreshData,
      color: GlassmorphismTheme.primaryColor,
      child: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return _buildExpenseCard(expense);
        },
      ),
    );
  }

  Widget _buildExpenseCard(Expense expense) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      child: GlassmorphismTheme.glassmorphismContainer(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.receipt_long,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.description,
                    style: const TextStyle(
                      color: GlassmorphismTheme.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            expense.category,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.calendar_today,
                        size: 13,
                        color: GlassmorphismTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          DateFormat(
                            'MMM dd, yyyy',
                          ).format(expense.expenseDate),
                          style: const TextStyle(
                            color: GlassmorphismTheme.textSecondaryColor,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                '\$${NumberFormat('#,##0.00').format(expense.amount)}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddExpenseDialog() {
    final formKey = GlobalKey<FormState>();
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    final paymentMethodController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    bool localIsLoading = false;

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
                      'Record Expense',
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
                        TextFormField(
                          controller: categoryController,
                          decoration: const InputDecoration(
                            labelText: 'Expense Category',
                            prefixIcon: Icon(Icons.category),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter expense category';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            prefixIcon: Icon(Icons.description),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            prefixText: '\$',
                            prefixIcon: Icon(Icons.attach_money),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: paymentMethodController,
                          decoration: const InputDecoration(
                            labelText: 'Payment Method',
                            prefixIcon: Icon(Icons.payment),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter payment method';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Expense Date',
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: localIsLoading
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              setModalState(() => localIsLoading = true);
                              try {
                                final expense = Expense()
                                  ..category = categoryController.text
                                  ..description = descriptionController.text
                                  ..amount = double.parse(amountController.text)
                                  ..paymentMethod = paymentMethodController.text
                                  ..expenseDate = selectedDate
                                  ..createdAt = DateTime.now();
                                await DatabaseService.addExpense(expense);
                                Navigator.pop(context);
                                _loadData();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to add expense: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                setModalState(() => localIsLoading = false);
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
                    child: localIsLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Record Expense',
                            style: TextStyle(
                              fontSize: 17,
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

  void _showEditCapitalDialog(Capital capital) {
    final descriptionController = TextEditingController(
      text: capital.description,
    );
    final amountController = TextEditingController(
      text: capital.amount.toString(),
    );
    final typeController = TextEditingController(text: capital.type);
    DateTime selectedDate = capital.date;
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: GlassmorphismTheme.surfaceColor,
              title: const Text(
                'Edit Capital',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: typeController.text,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'initial',
                          child: Text('Initial Capital'),
                        ),
                        DropdownMenuItem(
                          value: 'additional',
                          child: Text('Additional Capital'),
                        ),
                      ],
                      onChanged: (value) {
                        typeController.text = value ?? 'initial';
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text(
                        'Date',
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
                          if (descriptionController.text.isNotEmpty &&
                              amountController.text.isNotEmpty) {
                            setDialogState(() => isSubmitting = true);
                            try {
                              final amount = double.parse(
                                amountController.text,
                              );

                              // Update capital data
                              capital.description = descriptionController.text;
                              capital.amount = amount;
                              capital.type = typeController.text;
                              capital.date = selectedDate;

                              await DatabaseService.updateCapital(capital);

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Capital updated successfully!',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              _loadData(); // Refresh data
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error updating capital: $e'),
                                  backgroundColor: Colors.red,
                                ),
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
                      : const Text('Update Capital'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(Capital capital) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: GlassmorphismTheme.surfaceColor,
          title: const Text(
            'Delete Capital',
            style: TextStyle(color: GlassmorphismTheme.textColor),
          ),
          content: Text(
            'Are you sure you want to delete the capital entry "${capital.description}"? This action cannot be undone.',
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
                  await DatabaseService.deleteCapital(capital.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Capital deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _loadData(); // Refresh data
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting capital: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
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
