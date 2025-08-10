import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum PaymentMethod { inAppPurchase, directPayment }

class PaymentService {
  static PaymentService? _instance;
  static PaymentService get instance =>
      _instance ??= PaymentService._internal();
  PaymentService._internal();

  static const String _monthlyProductId = 'biztracker_monthly_premium';
  static const String _annualProductId = 'biztracker_annual_premium';
  static const String _lifetimeProductId = 'biztracker_lifetime_premium';

  // Payment gateway configuration (you can use any local payment gateway)
  static const String _paymentGatewayUrl =
      'https://your-payment-gateway.com/api/payment';
  static const String _merchantId = 'your_merchant_id';
  static const String _merchantName = 'BizTracker Premium';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _purchasePending = false;

  // Product IDs mapping
  static const Map<String, String> _productIds = {
    'monthly': _monthlyProductId,
    'annual': _annualProductId,
    'lifetime': _lifetimeProductId,
  };

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
          .queryProductDetails(_productIds.values.toSet());

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
    final productId = _productIds[planType];
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

      if (product.id == _lifetimeProductId) {
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
        'merchant_id': _merchantId,
        'amount': amount,
        'currency': 'USD',
        'plan_type': planType,
        'payment_method': paymentDetails['method'],
        'customer_details': {
          'name': paymentDetails['customerName'] ?? '',
          'email': paymentDetails['customerEmail'] ?? '',
          'phone': paymentDetails['customerPhone'] ?? '',
        },
        'payment_data': paymentDetails['paymentData'] ?? {},
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Send payment request to your backend/payment gateway
      final response = await http.post(
        Uri.parse(_paymentGatewayUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${paymentDetails['apiKey'] ?? ''}',
        },
        body: jsonEncode(paymentRequest),
      );

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

    if (isWeekend) {
      return {
        'title': 'Weekend Special! 🎉',
        'subtitle': 'Get 20% off Annual Plan',
        'discount': '20%',
        'plan': 'annual',
        'originalPrice': 39.99,
        'discountedPrice': 31.99,
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
        'originalPrice': 4.99,
        'discountedPrice': 4.24,
        'validUntil': 'Limited time only',
        'backgroundColor': 0xFFFF9800,
        'textColor': 0xFFFFFFFF,
      };
    }
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
      },
      {
        'id': 'ecocash',
        'name': 'EcoCash',
        'description': 'Mobile money payment',
        'icon': '📱',
        'available': true,
      },
      {
        'id': 'onemoney',
        'name': 'OneMoney',
        'description': 'Mobile money payment',
        'icon': '💳',
        'available': true,
      },
      {
        'id': 'bank_transfer',
        'name': 'Bank Transfer',
        'description': 'Direct bank transfer',
        'icon': '🏦',
        'available': true,
      },
      {
        'id': 'cash_deposit',
        'name': 'Cash Deposit',
        'description': 'Cash deposit to bank account',
        'icon': '💰',
        'available': true,
      },
    ];
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
  }
}
