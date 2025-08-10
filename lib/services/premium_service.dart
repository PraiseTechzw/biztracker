import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_pay/google_pay.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:convert';

enum PremiumPlan { free, monthly, annual, lifetime }

class PremiumService {
  static PremiumService? _instance;
  static PremiumService get instance =>
      _instance ??= PremiumService._internal();
  PremiumService._internal();

  // SharedPreferences keys
  static const String _premiumPlanKey = 'premium_plan';
  static const String _premiumExpiryKey = 'premium_expiry';
  static const String _adFreeUntilKey = 'ad_free_until';
  static const String _rewardedAdsWatchedKey = 'rewarded_ads_watched';
  static const String _lastPromotionShownKey = 'last_promotion_shown';

  // Premium plans pricing and product IDs
  static const Map<PremiumPlan, Map<String, dynamic>> _plans = {
    PremiumPlan.monthly: {
      'price': 4.99,
      'productId': 'biztracker_monthly',
      'title': 'Monthly Premium',
      'description': 'Unlock all features for 1 month',
      'savings': null,
    },
    PremiumPlan.annual: {
      'price': 39.99,
      'productId': 'biztracker_annual',
      'title': 'Annual Premium',
      'description': 'Unlock all features for 1 year',
      'savings': 'Save 33%',
    },
    PremiumPlan.lifetime: {
      'price': 99.99,
      'productId': 'biztracker_lifetime',
      'title': 'Lifetime Premium',
      'description': 'Unlock all features forever',
      'savings': 'Best Value',
    },
  };

  // Rewarded ads system
  static const int _adsForOneHour = 1;
  static const int _adsForOneDay = 5;
  static const int _adsForOneWeek = 30;

  // Google Pay configuration
  static const _googlePayConfig = GooglePayConfig(
    environment: GooglePayEnvironment.test, // Change to .production for live
    merchantName: 'BizTracker',
    merchantId: '12345678901234567890', // Replace with your merchant ID
    paymentMethodTokenizationType: PaymentMethodTokenizationType.paymentGateway,
    paymentMethodCardParameters: PaymentMethodCardParameters(
      billingAddressRequired: true,
      billingAddressParameters: BillingAddressParameters(
        format: BillingAddressFormat.full,
        phoneNumberRequired: true,
      ),
    ),
  );

  // In-app purchase instance
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  /// Initialize the premium service
  Future<void> initialize() async {
    _isAvailable = await _inAppPurchase.isAvailable();
    if (_isAvailable) {
      await _loadProducts();
      await _loadPurchases();
    }
  }

  /// Load available products from store
  Future<void> _loadProducts() async {
    final Set<String> productIds = _plans.values
        .map((plan) => plan['productId'] as String)
        .toSet();

    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }

    _products = response.productDetails;
  }

  /// Load existing purchases
  Future<void> _loadPurchases() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    purchaseUpdated.listen((purchases) {
      _purchases = purchases;
      _handlePurchases(purchases);
    });
  }

  /// Handle purchase updates
  void _handlePurchases(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        // Handle pending purchase
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _verifyPurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        debugPrint('Purchase error: ${purchase.error}');
      }

      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
    }
  }

  /// Verify and process purchase
  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    // Verify purchase with your backend server
    final isValid = await _verifyPurchaseWithServer(purchase);

    if (isValid) {
      await _activatePremiumPlan(purchase.productID);
    }
  }

  /// Verify purchase with backend server
  Future<bool> _verifyPurchaseWithServer(PurchaseDetails purchase) async {
    try {
      // Send purchase data to your backend for verification
      // This is crucial for security
      final response = await _sendPurchaseToServer(purchase);
      return response['valid'] == true;
    } catch (e) {
      debugPrint('Purchase verification failed: $e');
      return false;
    }
  }

  /// Send purchase data to backend server
  Future<Map<String, dynamic>> _sendPurchaseToServer(
    PurchaseDetails purchase,
  ) async {
    // Implement your backend API call here
    // This should verify the purchase receipt with Google/Apple
    return {'valid': true}; // Placeholder
  }

  /// Activate premium plan after successful purchase
  Future<void> _activatePremiumPlan(String productId) async {
    PremiumPlan? plan;
    for (final entry in _plans.entries) {
      if (entry.value['productId'] == productId) {
        plan = entry.key;
        break;
      }
    }

    if (plan != null) {
      await _setPremiumPlan(plan);
    }
  }

  /// Set premium plan
  Future<void> _setPremiumPlan(PremiumPlan plan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_premiumPlanKey, plan.index);

    if (plan != PremiumPlan.lifetime) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      int expiryTime = 0;

      switch (plan) {
        case PremiumPlan.monthly:
          expiryTime = currentTime + (30 * 24 * 60 * 60 * 1000); // 30 days
          break;
        case PremiumPlan.annual:
          expiryTime = currentTime + (365 * 24 * 60 * 60 * 1000); // 1 year
          break;
        default:
          break;
      }

      await prefs.setInt(_premiumExpiryKey, expiryTime);
    }
  }

  /// Purchase premium plan using Google Pay
  Future<bool> purchaseWithGooglePay(PremiumPlan plan) async {
    try {
      final planData = _plans[plan];
      if (planData == null) return false;

      final paymentData = PaymentData(
        totalPrice: planData['price'].toString(),
        totalPriceStatus: TotalPriceStatus.finalPrice,
        currencyCode: 'USD',
        countryCode: 'US',
      );

      final result = await GooglePay.makePayment(
        paymentData: paymentData,
        config: _googlePayConfig,
      );

      if (result.status == PaymentStatus.success) {
        // Process the payment token with your backend
        final success = await _processGooglePayToken(
          result.paymentMethodToken,
          plan,
        );
        if (success) {
          await _setPremiumPlan(plan);
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('Google Pay purchase failed: $e');
      return false;
    }
  }

  /// Process Google Pay token with backend
  Future<bool> _processGooglePayToken(String token, PremiumPlan plan) async {
    try {
      // Send token to your backend for processing
      // This should charge the user's card and verify the payment
      final response = await _sendGooglePayTokenToServer(token, plan);
      return response['success'] == true;
    } catch (e) {
      debugPrint('Google Pay token processing failed: $e');
      return false;
    }
  }

  /// Send Google Pay token to backend
  Future<Map<String, dynamic>> _sendGooglePayTokenToServer(
    String token,
    PremiumPlan plan,
  ) async {
    // Implement your backend API call here
    // This should process the payment with your payment processor
    return {'success': true}; // Placeholder
  }

  /// Purchase premium plan using in-app purchase
  Future<bool> purchaseWithInAppPurchase(PremiumPlan plan) async {
    try {
      final planData = _plans[plan];
      if (planData == null) return false;

      final product = _products.firstWhere(
        (product) => product.id == planData['productId'],
        orElse: () => throw Exception('Product not found'),
      );

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      return await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
    } catch (e) {
      debugPrint('In-app purchase failed: $e');
      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      return await _inAppPurchase.restorePurchases();
    } catch (e) {
      debugPrint('Restore purchases failed: $e');
      return false;
    }
  }

  /// Get promotional banner data
  Future<Map<String, dynamic>?> getPromotionalBanner() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShown = prefs.getInt(_lastPromotionShownKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Show promotion every 24 hours
    if (now - lastShown < 24 * 60 * 60 * 1000) {
      return null;
    }

    // Check if user is eligible for promotion
    final isPremium = await this.isPremium();
    if (isPremium) return null;

    // Get current plan for targeted promotions
    final currentPlan = await getCurrentPlan();

    // Return promotional data
    return {
      'title': 'Upgrade to Premium',
      'subtitle': 'Unlock all features and remove ads',
      'plan': _getBestValuePlan(),
      'discount': 'Limited Time Offer',
      'cta': 'Upgrade Now',
    };
  }

  /// Get best value plan for promotions
  Map<String, dynamic> _getBestValuePlan() {
    return _plans[PremiumPlan.annual]!;
  }

  /// Mark promotion as shown
  Future<void> _markPromotionShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _lastPromotionShownKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Get all available plans with promotional data
  List<Map<String, dynamic>> getAvailablePlans() {
    return _plans.entries.map((entry) {
      final plan = entry.value;
      return {
        'plan': entry.key,
        'title': plan['title'],
        'description': plan['description'],
        'price': plan['price'],
        'productId': plan['productId'],
        'savings': plan['savings'],
        'isPopular': entry.key == PremiumPlan.annual,
        'isBestValue': entry.key == PremiumPlan.lifetime,
      };
    }).toList();
  }

  /// Check if user has active premium subscription
  Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    final plan = PremiumPlan.values[prefs.getInt(_premiumPlanKey) ?? 0];

    if (plan == PremiumPlan.free) return false;
    if (plan == PremiumPlan.lifetime) return true;

    // Check expiry for monthly/annual
    final expiry = prefs.getInt(_premiumExpiryKey);
    if (expiry == null) return false;

    return DateTime.now().millisecondsSinceEpoch < expiry;
  }

  /// Check if user has temporary ad-free period
  Future<bool> hasAdFreePeriod() async {
    final prefs = await SharedPreferences.getInstance();
    final adFreeUntil = prefs.getInt(_adFreeUntilKey);

    if (adFreeUntil == null) return false;

    return DateTime.now().millisecondsSinceEpoch < adFreeUntil;
  }

  /// Check if ads should be shown (considering both premium and ad-free periods)
  Future<bool> shouldShowAds() async {
    final isPremiumUser = await isPremium();
    final hasAdFreePeriod = await this.hasAdFreePeriod();
    final shouldShow = !isPremiumUser && !hasAdFreePeriod;

    debugPrint(
      'PremiumService: shouldShowAds = $shouldShow (isPremium: $isPremiumUser, hasAdFreePeriod: $hasAdFreePeriod)',
    );
    return shouldShow;
  }

  /// Get current premium plan
  Future<PremiumPlan> getCurrentPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final planIndex = prefs.getInt(_premiumPlanKey) ?? 0;
    return PremiumPlan.values[planIndex];
  }

  /// Get premium expiry date
  Future<DateTime?> getPremiumExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    final expiry = prefs.getInt(_premiumExpiryKey);

    if (expiry == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(expiry);
  }

  /// Get ad-free period expiry
  Future<DateTime?> getAdFreeExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    final adFreeUntil = prefs.getInt(_adFreeUntilKey);

    if (adFreeUntil == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(adFreeUntil);
  }

  /// Get number of rewarded ads watched today
  Future<int> getRewardedAdsWatched() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().day;
    final lastWatchDay = prefs.getInt('last_watch_day') ?? 0;

    if (today != lastWatchDay) {
      // Reset daily count
      await prefs.setInt(_rewardedAdsWatchedKey, 0);
      await prefs.setInt('last_watch_day', today);
      return 0;
    }

    return prefs.getInt(_rewardedAdsWatchedKey) ?? 0;
  }

  /// Watch a rewarded ad and grant ad-free time
  Future<bool> watchRewardedAd() async {
    final prefs = await SharedPreferences.getInstance();
    final currentWatched = await getRewardedAdsWatched();
    final newWatched = currentWatched + 1;

    // Update watched count
    await prefs.setInt(_rewardedAdsWatchedKey, newWatched);

    // Calculate ad-free time based on watched ads
    int adFreeMinutes = 0;

    if (newWatched >= _adsForOneWeek) {
      adFreeMinutes = 7 * 24 * 60; // 1 week
    } else if (newWatched >= _adsForOneDay) {
      adFreeMinutes = 24 * 60; // 1 day
    } else if (newWatched >= _adsForOneHour) {
      adFreeMinutes = 60; // 1 hour
    }

    if (adFreeMinutes > 0) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final adFreeUntil = currentTime + (adFreeMinutes * 60 * 1000);
      await prefs.setInt(_adFreeUntilKey, adFreeUntil);

      debugPrint(
        'PremiumService: Granted $adFreeMinutes minutes of ad-free time',
      );
      return true;
    }

    return false;
  }

  /// Purchase premium plan
  Future<bool> purchasePlan(PremiumPlan plan) async {
    try {
      // Here you would integrate with payment system (Stripe, Google Pay, etc.)
      // For now, we'll simulate successful purchase

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_premiumPlanKey, plan.index);

      // Set expiry date based on plan
      int expiryTime = 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      switch (plan) {
        case PremiumPlan.monthly:
          expiryTime = currentTime + (30 * 24 * 60 * 60 * 1000); // 30 days
          break;
        case PremiumPlan.annual:
          expiryTime = currentTime + (365 * 24 * 60 * 60 * 1000); // 365 days
          break;
        case PremiumPlan.lifetime:
          expiryTime =
              currentTime + (100 * 365 * 24 * 60 * 60 * 1000); // 100 years
          break;
        case PremiumPlan.free:
          break;
      }

      if (expiryTime > 0) {
        await prefs.setInt(_premiumExpiryKey, expiryTime);
      }

      debugPrint('PremiumService: Purchased $plan plan');
      return true;
    } catch (e) {
      debugPrint('PremiumService: Failed to purchase plan - $e');
      return false;
    }
  }

  /// Cancel premium subscription
  Future<void> cancelPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_premiumPlanKey, PremiumPlan.free.index);
    await prefs.remove(_premiumExpiryKey);

    debugPrint('PremiumService: Premium subscription cancelled');
  }

  /// Get plan pricing
  static double getPlanPrice(PremiumPlan plan) {
    switch (plan) {
      case PremiumPlan.monthly:
        return _plans[PremiumPlan.monthly]!['price'] as double;
      case PremiumPlan.annual:
        return _plans[PremiumPlan.annual]!['price'] as double;
      case PremiumPlan.lifetime:
        return _plans[PremiumPlan.lifetime]!['price'] as double;
      case PremiumPlan.free:
        return 0.0;
    }
  }

  /// Get plan savings percentage
  static double getPlanSavings(PremiumPlan plan) {
    switch (plan) {
      case PremiumPlan.annual:
        final monthlyCost = getPlanPrice(PremiumPlan.monthly) * 12;
        return ((monthlyCost - getPlanPrice(PremiumPlan.annual)) /
                monthlyCost) *
            100;
      case PremiumPlan.lifetime:
        final monthlyCost = getPlanPrice(PremiumPlan.monthly) * 12;
        return ((monthlyCost - getPlanPrice(PremiumPlan.lifetime)) /
                monthlyCost) *
            100;
      default:
        return 0.0;
    }
  }

  /// Get plan features
  static List<String> getPlanFeatures(PremiumPlan plan) {
    switch (plan) {
      case PremiumPlan.free:
        return [
          'Basic business management',
          'Limited ads with controls',
          'Watch ads for temporary ad-free',
          'Basic analytics',
        ];
      case PremiumPlan.monthly:
      case PremiumPlan.annual:
      case PremiumPlan.lifetime:
        return [
          'Complete ad-free experience',
          'Unlimited business features',
          'Advanced analytics',
          'Priority support',
          'Premium themes',
          'Data export',
          'Cloud backup',
        ];
    }
  }

  /// Get next reward info
  Future<Map<String, dynamic>> getNextRewardInfo() async {
    final watched = await getRewardedAdsWatched();

    if (watched >= _adsForOneWeek) {
      return {
        'type': 'week',
        'adsNeeded': 0,
        'adsWatched': watched,
        'message': 'You have 1 week of ad-free time!',
      };
    } else if (watched >= _adsForOneDay) {
      return {
        'type': 'day',
        'adsNeeded': _adsForOneWeek - watched,
        'adsWatched': watched,
        'message':
            'Watch ${_adsForOneWeek - watched} more ads for 1 week ad-free!',
      };
    } else if (watched >= _adsForOneHour) {
      return {
        'type': 'hour',
        'adsNeeded': _adsForOneDay - watched,
        'adsWatched': watched,
        'message':
            'Watch ${_adsForOneDay - watched} more ads for 1 day ad-free!',
      };
    } else {
      return {
        'type': 'none',
        'adsNeeded': _adsForOneHour - watched,
        'adsWatched': watched,
        'message':
            'Watch ${_adsForOneHour - watched} more ads for 1 hour ad-free!',
      };
    }
  }

  /// Get premium status summary
  Future<Map<String, dynamic>> getPremiumStatus() async {
    final isPremium = await this.isPremium();
    final hasAdFree = await hasAdFreePeriod();
    final plan = await getCurrentPlan();
    final expiry = await getPremiumExpiry();
    final adFreeExpiry = await getAdFreeExpiry();
    final watchedAds = await getRewardedAdsWatched();
    final nextReward = await getNextRewardInfo();

    return {
      'isPremium': isPremium,
      'hasAdFreePeriod': hasAdFree,
      'shouldShowAds': await shouldShowAds(),
      'plan': plan.toString(),
      'planExpiry': expiry?.toIso8601String(),
      'adFreeExpiry': adFreeExpiry?.toIso8601String(),
      'watchedAds': watchedAds,
      'nextReward': nextReward,
    };
  }
}
