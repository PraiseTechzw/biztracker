import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

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

  // Premium plans pricing
  static const double _monthlyPrice = 4.99;
  static const double _annualPrice = 39.99;
  static const double _lifetimePrice = 99.99;

  // Rewarded ads system
  static const int _adsForOneHour = 1;
  static const int _adsForOneDay = 5;
  static const int _adsForOneWeek = 30;

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

    return !isPremiumUser && !hasAdFreePeriod;
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
        return _monthlyPrice;
      case PremiumPlan.annual:
        return _annualPrice;
      case PremiumPlan.lifetime:
        return _lifetimePrice;
      case PremiumPlan.free:
        return 0.0;
    }
  }

  /// Get plan savings percentage
  static double getPlanSavings(PremiumPlan plan) {
    switch (plan) {
      case PremiumPlan.annual:
        final monthlyCost = _monthlyPrice * 12;
        return ((monthlyCost - _annualPrice) / monthlyCost) * 100;
      case PremiumPlan.lifetime:
        final monthlyCost = _monthlyPrice * 12;
        return ((monthlyCost - _lifetimePrice) / monthlyCost) * 100;
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
