import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/payment_config.dart';

enum PaymentMethod { inAppPurchase, directPayment }

class PaymentService {
  static PaymentService? _instance;
  static PaymentService get instance =>
      _instance ??= PaymentService._internal();
  PaymentService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _purchasePending = false;

  /// Initialize payment service
  Future<void> initialize() async {
    try {
      // Check if in-app purchases are available
      _isAvailable = await _inAppPurchase.isAvailable();

      if (_isAvailable) {
        // Load products
        await _loadProducts();

        // Listen to purchase updates
        _subscription = _inAppPurchase.purchaseStream.listen(
          _onPurchaseUpdate,
          onDone: () => _subscription?.cancel(),
          onError: (error) =>
              debugPrint('PaymentService: Purchase stream error - $error'),
        );
      }

      debugPrint('PaymentService: Initialized successfully');
    } catch (e) {
      debugPrint('PaymentService: Initialization failed - $e');
    }
  }

  /// Load available products
  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response = await _inAppPurchase
          .queryProductDetails(PaymentConfig.productIds.values.toSet());

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint(
          'PaymentService: Products not found - ${response.notFoundIDs}',
        );
      }

      _products = response.productDetails;
      debugPrint('PaymentService: Loaded ${_products.length} products');
    } catch (e) {
      debugPrint('PaymentService: Failed to load products - $e');
    }
  }

  /// Get available products
  List<ProductDetails> get products => _products;

  /// Check if payments are available
  bool get isAvailable => _isAvailable;

  /// Check if purchase is pending
  bool get isPurchasePending => _purchasePending;

  /// Get product by plan type
  ProductDetails? getProductByPlan(String planType) {
    final productId = PaymentConfig.productIds[planType];
    if (productId == null) return null;

    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Purchase premium plan using in-app purchase
  Future<bool> purchasePlanInApp(String planType) async {
    try {
      final product = getProductByPlan(planType);
      if (product == null) {
        debugPrint('PaymentService: Product not found for plan $planType');
        return false;
      }

      _purchasePending = true;

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: null,
      );

      bool success = false;

      if (planType == 'lifetime') {
        success = await _inAppPurchase.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
      } else {
        success = await _inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam,
        );
      }

      if (success) {
        debugPrint('PaymentService: Purchase initiated for $planType');
        return true;
      } else {
        debugPrint('PaymentService: Failed to initiate purchase for $planType');
        _purchasePending = false;
        return false;
      }
    } catch (e) {
      debugPrint('PaymentService: Purchase error - $e');
      _purchasePending = false;
      return false;
    }
  }

  /// Purchase premium plan using direct payment (for Zimbabwe/local payment methods)
  Future<bool> purchasePlanDirect(
    String planType,
    double amount,
    Map<String, dynamic> paymentDetails,
  ) async {
    try {
      _purchasePending = true;

      // Create payment request
      final paymentRequest = {
        'merchant_id': PaymentConfig.merchantId,
        'amount': amount,
        'currency': PaymentConfig.defaultCurrency,
        'plan_type': planType,
        'payment_method': paymentDetails['method'],
        'customer_details': {
          'name': paymentDetails['customerName'] ?? '',
          'email': paymentDetails['customerEmail'] ?? '',
          'phone': paymentDetails['customerPhone'] ?? '',
        },
        'payment_data': paymentDetails['paymentData'] ?? {},
        'timestamp': DateTime.now().toIso8601String(),
        'local_amount': amount * PaymentConfig.usdToZwlRate,
        'local_currency': PaymentConfig.localCurrency,
      };

      // Send payment request to your backend/payment gateway
      final response = await http
          .post(
            Uri.parse(PaymentConfig.paymentGatewayUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${PaymentConfig.apiKey}',
            },
            body: jsonEncode(paymentRequest),
          )
          .timeout(Duration(seconds: PaymentConfig.paymentTimeoutSeconds));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          debugPrint('PaymentService: Direct payment successful for $planType');
          _purchasePending = false;
          return true;
        } else {
          debugPrint(
            'PaymentService: Payment failed - ${responseData['message']}',
          );
          _purchasePending = false;
          return false;
        }
      } else {
        debugPrint(
          'PaymentService: Payment request failed - ${response.statusCode}',
        );
        _purchasePending = false;
        return false;
      }
    } catch (e) {
      debugPrint('PaymentService: Direct payment error - $e');
      _purchasePending = false;
      return false;
    }
  }

  /// Handle purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _purchasePending = true;
      } else {
        _purchasePending = false;

        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint(
            'PaymentService: Purchase error - ${purchaseDetails.error}',
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _handleSuccessfulPurchase(purchaseDetails);
        }

        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  /// Handle successful purchase
  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) {
    debugPrint(
      'PaymentService: Purchase successful - ${purchaseDetails.productID}',
    );

    // Here you would update the user's premium status
    // and sync with your backend
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      return true;
    } catch (e) {
      debugPrint('PaymentService: Failed to restore purchases - $e');
      return false;
    }
  }

  /// Get promotion banner data
  Map<String, dynamic> getPromotionBanner() {
    // You can customize this based on user behavior, time, or other factors
    final now = DateTime.now();
    final isWeekend =
        now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    final isHoliday = _isHoliday(now);

    if (isHoliday) {
      return {
        'title': 'Holiday Special! 🎊',
        'subtitle': 'Get 25% off Annual Plan',
        'discount': '25%',
        'plan': 'annual',
        'originalPrice': PaymentConfig.pricing['annual']!,
        'discountedPrice': PaymentConfig.pricing['annual']! * 0.75,
        'validUntil': 'Limited holiday offer',
        'backgroundColor': 0xFFE91E63,
        'textColor': 0xFFFFFFFF,
      };
    } else if (isWeekend) {
      return {
        'title': 'Weekend Special! 🎉',
        'subtitle': 'Get 20% off Annual Plan',
        'discount': '20%',
        'plan': 'annual',
        'originalPrice': PaymentConfig.pricing['annual']!,
        'discountedPrice': PaymentConfig.pricing['annual']! * 0.80,
        'validUntil': 'This weekend only',
        'backgroundColor': 0xFF4CAF50,
        'textColor': 0xFFFFFFFF,
      };
    } else {
      return {
        'title': 'Limited Time Offer! ⚡',
        'subtitle': 'Save 15% on Monthly Plan',
        'discount': '15%',
        'plan': 'monthly',
        'originalPrice': PaymentConfig.pricing['monthly']!,
        'discountedPrice': PaymentConfig.pricing['monthly']! * 0.85,
        'validUntil': 'Limited time only',
        'backgroundColor': 0xFFFF9800,
        'textColor': 0xFFFFFFFF,
      };
    }
  }

  /// Check if date is a holiday (you can expand this list)
  bool _isHoliday(DateTime date) {
    // Add Zimbabwe holidays here
    final holidays = [
      DateTime(date.year, 1, 1), // New Year's Day
      DateTime(date.year, 4, 18), // Independence Day
      DateTime(date.year, 5, 1), // Workers' Day
      DateTime(date.year, 8, 11), // Heroes' Day
      DateTime(date.year, 8, 12), // Defence Forces Day
      DateTime(date.year, 12, 25), // Christmas Day
      DateTime(date.year, 12, 26), // Boxing Day
    ];

    return holidays.any(
      (holiday) => holiday.day == date.day && holiday.month == date.month,
    );
  }

  /// Get available payment methods for Zimbabwe
  List<Map<String, dynamic>> getAvailablePaymentMethods() {
    return [
      {
        'id': 'in_app_purchase',
        'name': 'In-App Purchase',
        'description': 'Purchase through app store',
        'icon': '🛒',
        'available': _isAvailable,
        'instructions': 'Secure payment through Google Play Store',
        'processingTime': 'Instant',
      },
      ...PaymentConfig.supportedPaymentMethods.map(
        (method) => ({...method, 'available': true}),
      ),
    ];
  }

  /// Get payment instructions for a specific method
  String getPaymentInstructions(String methodId) {
    final method = PaymentConfig.supportedPaymentMethods.firstWhere(
      (method) => method['id'] == methodId,
      orElse: () => {
        'instructions': 'Contact support for payment instructions',
      },
    );
    return method['instructions'];
  }

  /// Get local currency amount
  double getLocalAmount(double usdAmount) {
    return usdAmount * PaymentConfig.usdToZwlRate;
  }

  /// Get support contact information
  Map<String, String> getSupportInfo() {
    return {
      'email': PaymentConfig.supportEmail,
      'phone': PaymentConfig.supportPhone,
      'whatsapp': PaymentConfig.supportWhatsApp,
      'businessHours': PaymentConfig.businessHours,
    };
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
  }
}
