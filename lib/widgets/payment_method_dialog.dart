import 'package:flutter/material.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/payment_service.dart';

class PaymentMethodDialog extends StatefulWidget {
  final String planType;
  final double amount;
  final VoidCallback? onSuccess;

  const PaymentMethodDialog({
    super.key,
    required this.planType,
    required this.amount,
    this.onSuccess,
  });

  @override
  State<PaymentMethodDialog> createState() => _PaymentMethodDialogState();
}

class _PaymentMethodDialogState extends State<PaymentMethodDialog> {
  String? _selectedPaymentMethod;
  bool _isLoading = false;
  List<Map<String, dynamic>> _paymentMethods = [];

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  void _loadPaymentMethods() {
    _paymentMethods = PaymentService.instance.getAvailablePaymentMethods();
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = false;

      if (_selectedPaymentMethod == 'in_app_purchase') {
        success = await PaymentService.instance.purchasePlanInApp(
          widget.planType,
        );
      } else {
        // For local payment methods, show additional form
        final paymentDetails = await _showPaymentDetailsForm();
        if (paymentDetails != null) {
          success = await PaymentService.instance.purchasePlanDirect(
            widget.planType,
            widget.amount,
            paymentDetails,
          );
        }
      }

      if (success) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Payment successful! ${widget.planType} plan activated.',
              ),
              backgroundColor: Colors.green,
            ),
          );
          widget.onSuccess?.call();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _showPaymentDetailsForm() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController referenceController = TextEditingController();

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '${_getPaymentMethodName(_selectedPaymentMethod!)} Details',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: referenceController,
                decoration: InputDecoration(
                  labelText: _getReferenceLabel(_selectedPaymentMethod!),
                  border: const OutlineInputBorder(),
                  helperText: _getReferenceHelperText(_selectedPaymentMethod!),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                Navigator.of(context).pop({
                  'method': _selectedPaymentMethod!,
                  'customerName': nameController.text,
                  'customerEmail': emailController.text,
                  'customerPhone': phoneController.text,
                  'paymentData': {'reference': referenceController.text},
                });
              }
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodName(String methodId) {
    final method = _paymentMethods.firstWhere(
      (method) => method['id'] == methodId,
      orElse: () => {'name': 'Unknown'},
    );
    return method['name'];
  }

  String _getReferenceLabel(String methodId) {
    switch (methodId) {
      case 'ecocash':
        return 'EcoCash Number';
      case 'onemoney':
        return 'OneMoney Number';
      case 'bank_transfer':
        return 'Bank Reference';
      case 'cash_deposit':
        return 'Deposit Reference';
      default:
        return 'Reference Number';
    }
  }

  String _getReferenceHelperText(String methodId) {
    switch (methodId) {
      case 'ecocash':
        return 'Enter the EcoCash number you used for payment';
      case 'onemoney':
        return 'Enter the OneMoney number you used for payment';
      case 'bank_transfer':
        return 'Enter the bank transfer reference number';
      case 'cash_deposit':
        return 'Enter the cash deposit reference number';
      default:
        return 'Enter the payment reference number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: GlassmorphismTheme.glassmorphismContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.payment,
                    color: GlassmorphismTheme.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Choose Payment Method',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: GlassmorphismTheme.textColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: GlassmorphismTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Text(
                'Select your preferred payment method for ${widget.planType} plan',
                style: TextStyle(
                  fontSize: 14,
                  color: GlassmorphismTheme.textSecondaryColor,
                ),
              ),

              const SizedBox(height: 24),

              // Payment methods list
              ..._paymentMethods.map((method) {
                final isAvailable = method['available'] as bool;
                final isSelected = _selectedPaymentMethod == method['id'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: isAvailable
                        ? () {
                            setState(() {
                              _selectedPaymentMethod = method['id'];
                            });
                          }
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? GlassmorphismTheme.primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? GlassmorphismTheme.primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isAvailable
                                  ? GlassmorphismTheme.primaryColor.withOpacity(
                                      0.2,
                                    )
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              method['icon'],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isAvailable
                                        ? GlassmorphismTheme.textColor
                                        : GlassmorphismTheme.textSecondaryColor,
                                  ),
                                ),
                                Text(
                                  method['description'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isAvailable
                                        ? GlassmorphismTheme.textSecondaryColor
                                        : GlassmorphismTheme.textSecondaryColor
                                              .withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: GlassmorphismTheme.primaryColor,
                              size: 24,
                            ),
                          if (!isAvailable)
                            Icon(Icons.block, color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              // Payment summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GlassmorphismTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: GlassmorphismTheme.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: GlassmorphismTheme.textColor,
                      ),
                    ),
                    Text(
                      '\$${widget.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: GlassmorphismTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading || _selectedPaymentMethod == null
                          ? null
                          : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GlassmorphismTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Pay Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
