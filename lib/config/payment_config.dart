class PaymentConfig {
  // Payment Gateway Configuration
  // Replace these with your actual payment gateway details

  // For testing, you can use a service like:
  // - Paynow (popular in Zimbabwe)
  // - Ecocash API
  // - Your own backend payment processor

  static const String paymentGatewayUrl =
      'https://your-payment-gateway.com/api/payment';
  static const String merchantId = 'your_merchant_id';
  static const String merchantName = 'BizTracker Premium';
  static const String apiKey = 'your_api_key';

  // Supported payment methods for Zimbabwe
  static const List<Map<String, dynamic>> supportedPaymentMethods = [
    {
      'id': 'ecocash',
      'name': 'EcoCash',
      'description': 'Mobile money payment via EcoCash',
      'icon': '📱',
      'instructions': 'Send payment to +263 77 123 4567',
      'processingTime': 'Instant',
    },
    {
      'id': 'onemoney',
      'name': 'OneMoney',
      'description': 'Mobile money payment via OneMoney',
      'icon': '💳',
      'instructions': 'Send payment to +263 71 123 4567',
      'processingTime': 'Instant',
    },
    {
      'id': 'bank_transfer',
      'name': 'Bank Transfer',
      'description': 'Direct bank transfer',
      'icon': '🏦',
      'instructions': 'Transfer to Account: 1234567890, Bank: CBZ Bank',
      'processingTime': '1-2 business days',
    },
    {
      'id': 'cash_deposit',
      'name': 'Cash Deposit',
      'description': 'Cash deposit to bank account',
      'icon': '💰',
      'instructions': 'Deposit cash at any CBZ Bank branch',
      'processingTime': 'Same day',
    },
  ];

  // Product IDs for in-app purchases
  static const Map<String, String> productIds = {
    'monthly': 'biztracker_monthly_premium',
    'annual': 'biztracker_annual_premium',
    'lifetime': 'biztracker_lifetime_premium',
  };

  // Pricing information
  static const Map<String, double> pricing = {
    'monthly': 4.99,
    'annual': 39.99,
    'lifetime': 99.99,
  };

  // Currency settings
  static const String defaultCurrency = 'USD';
  static const String localCurrency = 'ZWL'; // Zimbabwe Dollar

  // Exchange rate (you should get this from a live API)
  static const double usdToZwlRate = 10000.0; // Approximate rate

  // Payment processing settings
  static const int paymentTimeoutSeconds = 300; // 5 minutes
  static const bool requireConfirmation = true;
  static const bool sendEmailReceipt = true;

  // Support contact information
  static const String supportEmail = 'support@biztracker.com';
  static const String supportPhone = '+263 77 123 4567';
  static const String supportWhatsApp = '+263 77 123 4567';

  // Business hours (Zimbabwe time)
  static const String businessHours =
      'Monday - Friday: 8:00 AM - 5:00 PM (CAT)';

  // Payment instructions
  static const String paymentInstructions = '''
1. Choose your preferred payment method
2. Complete the payment using the provided details
3. Enter your payment reference number
4. Wait for confirmation (usually instant for mobile money)
5. Your premium features will be activated automatically

For any issues, contact our support team.
  ''';

  // Refund policy
  static const String refundPolicy = '''
- Monthly and Annual plans: 7-day money-back guarantee
- Lifetime plan: 30-day money-back guarantee
- Refunds processed within 3-5 business days
- Contact support for refund requests
  ''';
}
