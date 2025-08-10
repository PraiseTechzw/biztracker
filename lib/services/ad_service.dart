import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'premium_service.dart';

class AdService {
  static AdService? _instance;
  static AdService get instance => _instance ??= AdService._internal();
  AdService._internal();

  // Real AdMob Ad Unit IDs
  static const String _bannerAdUnitId =
      'ca-app-pub-4135089940496442/6305305810'; // Banner Ad
  static const String _interstitialAdUnitId =
      'ca-app-pub-4135089940496442/6720270606'; // Interstitial Ad Unit
  static const String _rewardedAdUnitId =
      'ca-app-pub-4135089940496442/1408202358'; // Rewarded Ad Unit

  bool _isInitialized = false;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  int _interstitialLoadAttempts = 0;
  int _rewardedLoadAttempts = 0;
  static const int _maxFailedLoadAttempts = 3;

  // Ad preferences
  bool _adsEnabled = true;
  bool _showBannerAds = true;
  bool _showInterstitialAds = true;
  bool _showRewardedAds = true;

  // Ad frequency control
  int _interstitialAdCounter = 0;
  static const int _interstitialAdFrequency = 5; // Show every 5 actions

  /// Initialize the ad service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;

      // Load initial ads
      _loadInterstitialAd();
      _loadRewardedAd();

      debugPrint('AdService: Initialized successfully');
    } catch (e) {
      debugPrint('AdService: Failed to initialize - $e');
    }
  }

  /// Get banner ad unit ID based on platform
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return _bannerAdUnitId;
    } else if (Platform.isIOS) {
      return _bannerAdUnitId; // Use same ID for now, replace with iOS ID
    }
    return _bannerAdUnitId;
  }

  /// Get interstitial ad unit ID based on platform
  String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return _interstitialAdUnitId;
    } else if (Platform.isIOS) {
      return _interstitialAdUnitId; // Use same ID for now, replace with iOS ID
    }
    return _interstitialAdUnitId;
  }

  /// Get rewarded ad unit ID based on platform
  String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return _rewardedAdUnitId;
    } else if (Platform.isIOS) {
      return _rewardedAdUnitId; // Use same ID for now, replace with iOS ID
    }
    return _rewardedAdUnitId;
  }

  /// Check if ads are enabled
  bool get adsEnabled => _adsEnabled;

  /// Check if banner ads should be shown
  Future<bool> get showBannerAds async {
    final shouldShow = await PremiumService.instance.shouldShowAds();
    final result = _adsEnabled && _showBannerAds && shouldShow;
    debugPrint(
      'AdService: showBannerAds = $result (adsEnabled: $_adsEnabled, showBannerAds: $_showBannerAds, shouldShow: $shouldShow)',
    );
    return result;
  }

  /// Check if interstitial ads should be shown
  Future<bool> get showInterstitialAds async {
    final shouldShow = await PremiumService.instance.shouldShowAds();
    return _adsEnabled && _showInterstitialAds && shouldShow;
  }

  /// Check if rewarded ads should be shown
  Future<bool> get showRewardedAds async {
    final shouldShow = await PremiumService.instance.shouldShowAds();
    return _adsEnabled && _showRewardedAds && shouldShow;
  }

  /// Toggle ads on/off
  void toggleAds(bool enabled) {
    _adsEnabled = enabled;
    debugPrint('AdService: Ads ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Toggle banner ads
  void toggleBannerAds(bool enabled) {
    _showBannerAds = enabled;
    debugPrint('AdService: Banner ads ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Toggle interstitial ads
  void toggleInterstitialAds(bool enabled) {
    _showInterstitialAds = enabled;
    debugPrint(
      'AdService: Interstitial ads ${enabled ? 'enabled' : 'disabled'}',
    );
  }

  /// Toggle rewarded ads
  void toggleRewardedAds(bool enabled) {
    _showRewardedAds = enabled;
    debugPrint('AdService: Rewarded ads ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Load interstitial ad
  void _loadInterstitialAd() async {
    if (!_isInitialized) return;
    final shouldShow = await showInterstitialAds;
    if (!shouldShow) return;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
          debugPrint('AdService: Interstitial ad loaded successfully');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          debugPrint('AdService: Interstitial ad failed to load: $error');

          if (_interstitialLoadAttempts < _maxFailedLoadAttempts) {
            _loadInterstitialAd();
          }
        },
      ),
    );
  }

  /// Load rewarded ad
  void _loadRewardedAd() async {
    if (!_isInitialized) return;
    final shouldShow = await showRewardedAds;
    if (!shouldShow) return;

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _rewardedLoadAttempts = 0;
          debugPrint('AdService: Rewarded ad loaded successfully');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedLoadAttempts += 1;
          _rewardedAd = null;
          debugPrint('AdService: Rewarded ad failed to load: $error');

          if (_rewardedLoadAttempts < _maxFailedLoadAttempts) {
            _loadRewardedAd();
          }
        },
      ),
    );
  }

  /// Show interstitial ad (with frequency control)
  Future<bool> showInterstitialAd() async {
    if (!_isInitialized || _interstitialAd == null) {
      return false;
    }
    final shouldShow = await showInterstitialAds;
    if (!shouldShow) {
      return false;
    }

    _interstitialAdCounter++;

    // Only show ad every N actions
    if (_interstitialAdCounter < _interstitialAdFrequency) {
      return false;
    }

    _interstitialAdCounter = 0;

    try {
      await _interstitialAd!.show();
      _interstitialAd = null;
      _loadInterstitialAd(); // Load next ad
      debugPrint('AdService: Interstitial ad shown successfully');
      return true;
    } catch (e) {
      debugPrint('AdService: Failed to show interstitial ad - $e');
      return false;
    }
  }

  /// Show rewarded ad
  Future<bool> showRewardedAd({
    required Function() onRewarded,
    required Function() onFailed,
  }) async {
    if (!_isInitialized || _rewardedAd == null) {
      onFailed();
      return false;
    }
    final shouldShow = await showRewardedAds;
    if (!shouldShow) {
      onFailed();
      return false;
    }

    try {
      await _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          onRewarded();
          debugPrint(
            'AdService: User earned reward: ${reward.amount} ${reward.type}',
          );
        },
      );

      _rewardedAd = null;
      _loadRewardedAd(); // Load next ad
      debugPrint('AdService: Rewarded ad shown successfully');
      return true;
    } catch (e) {
      debugPrint('AdService: Failed to show rewarded ad - $e');
      onFailed();
      return false;
    }
  }

  /// Create banner ad widget
  Widget createBannerAd() {
    debugPrint(
      'AdService: createBannerAd called, initialized: $_isInitialized',
    );
    if (!_isInitialized) {
      debugPrint('AdService: Not initialized, returning empty widget');
      return const SizedBox.shrink();
    }

    return FutureBuilder<bool>(
      future: showBannerAds,
      builder: (context, snapshot) {
        debugPrint(
          'AdService: FutureBuilder snapshot: ${snapshot.connectionState}, data: ${snapshot.data}',
        );
        if (snapshot.hasData && snapshot.data == true) {
          return SizedBox(
            width: double.infinity,
            height: 50,
            child: AdWidget(
              ad: BannerAd(
                adUnitId: bannerAdUnitId,
                size: AdSize.banner,
                request: const AdRequest(),
                listener: BannerAdListener(
                  onAdLoaded: (ad) {
                    debugPrint('AdService: Banner ad loaded successfully');
                  },
                  onAdFailedToLoad: (ad, error) {
                    debugPrint('AdService: Banner ad failed to load: $error');
                    ad.dispose();
                  },
                ),
              )..load(),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Show interstitial ad for specific actions
  Future<void> showAdForAction(String action) async {
    switch (action) {
      case 'sale_recorded':
      case 'expense_added':
      case 'stock_added':
      case 'report_generated':
        await showInterstitialAd();
        break;
      default:
        // Don't show ad for other actions
        break;
    }
  }

  /// Show rewarded ad for premium features
  Future<bool> showRewardedAdForFeature(String feature) async {
    return await showRewardedAd(
      onRewarded: () {
        // Grant temporary access to premium feature
        debugPrint('AdService: User earned access to $feature');
      },
      onFailed: () {
        debugPrint('AdService: Failed to earn access to $feature');
      },
    );
  }

  /// Dispose ads
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    debugPrint('AdService: Disposed');
  }

  /// Get ad statistics
  Map<String, dynamic> getAdStats() {
    return {
      'adsEnabled': _adsEnabled,
      'showBannerAds': _showBannerAds,
      'showInterstitialAds': _showInterstitialAds,
      'showRewardedAds': _showRewardedAds,
      'interstitialCounter': _interstitialAdCounter,
      'interstitialFrequency': _interstitialAdFrequency,
    };
  }
}
