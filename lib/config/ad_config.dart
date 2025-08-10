import 'package:flutter/foundation.dart';

class AdConfig {
  // Test Ad Unit IDs (Google's official test ads)
  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  // Production Ad Unit IDs
  static const String productionBannerAdUnitId =
      'ca-app-pub-4135089940496442/6305305810';
  static const String productionInterstitialAdUnitId =
      'ca-app-pub-4135089940496442/6720270606';
  static const String productionRewardedAdUnitId =
      'ca-app-pub-4135089940496442/1408202358';

  // AdMob App ID
  static const String admobAppId = 'ca-app-pub-4135089940496442~6683745617';

  // Test Device IDs (add your device ID here)
  static const List<String> testDeviceIds = [
    'B39C9B7BEB288444AD6FADE2ACAD6A4A', // Your current test device
    // Add more test devices as needed
  ];

  // Ad loading configuration
  static const int maxFailedLoadAttempts = 3;
  static const int interstitialAdFrequency = 5;
  static const Duration adLoadDelay = Duration(seconds: 2);
  static const Duration retryDelay = Duration(seconds: 2);

  // Debug settings
  static bool get isTestMode => kDebugMode;
  static bool get enableAdLogging => kDebugMode;
  static bool get enableTestAds => kDebugMode;

  // Get appropriate ad unit ID based on mode
  static String getBannerAdUnitId() {
    return isTestMode ? testBannerAdUnitId : productionBannerAdUnitId;
  }

  static String getInterstitialAdUnitId() {
    return isTestMode
        ? testInterstitialAdUnitId
        : productionInterstitialAdUnitId;
  }

  static String getRewardedAdUnitId() {
    return isTestMode ? testRewardedAdUnitId : productionRewardedAdUnitId;
  }

  // Get test device configuration
  static List<String> getTestDeviceIds() {
    return isTestMode ? testDeviceIds : [];
  }

  // Ad loading strategy
  static const Map<String, dynamic> adLoadingStrategy = {
    'banner': {
      'retryOnFailure': false,
      'maxRetries': 1,
      'retryDelay': Duration(seconds: 5),
    },
    'interstitial': {
      'retryOnFailure': true,
      'maxRetries': 3,
      'retryDelay': Duration(seconds: 2),
      'exponentialBackoff': true,
    },
    'rewarded': {
      'retryOnFailure': true,
      'maxRetries': 3,
      'retryDelay': Duration(seconds: 2),
      'exponentialBackoff': true,
    },
  };
}
