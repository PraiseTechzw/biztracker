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

class _CapitalScreenState extends State<CapitalScreen> {
  List<Capital> capitals = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  bool isAdding = false;

  @override
  void initState() {
    super.initState();
    _loadCapitals();
  }

  Future<void> _loadCapitals() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      final data = await DatabaseService.getAllCapitals();
      setState(() {
        capitals = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Failed to load capital data: $e';
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadCapitals();
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
                      : _buildCapitalList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCapitalDialog,
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GlassmorphismTheme.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: GlassmorphismTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Capital Management',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
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
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
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
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.calendar_today,
                              size: 13,
                              color: GlassmorphismTheme.textSecondaryColor,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              DateFormat('MMM dd, yyyy').format(capital.date),
                              style: const TextStyle(
                                color: GlassmorphismTheme.textSecondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '\$${NumberFormat('#,##0.00').format(capital.amount)}',
                    style: const TextStyle(
                      color: GlassmorphismTheme.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                                  _loadCapitals(); // Refresh the list
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
}
