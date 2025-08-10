import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'premium_service.dart';
import '../config/ad_config.dart';

class AdService {
  static AdService? _instance;
  static AdService get instance => _instance ??= AdService._internal();
  AdService._internal();

  bool _isInitialized = false;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  int _interstitialLoadAttempts = 0;
  int _rewardedLoadAttempts = 0;

  // Ad preferences
  bool _adsEnabled = true;
  bool _showBannerAds = true;
  bool _showInterstitialAds = true;
  bool _showRewardedAds = true;

  // Ad frequency control
  int _interstitialAdCounter = 0;

  /// Initialize the ad service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configure test devices for development
      final testDeviceIds = AdConfig.getTestDeviceIds();
      if (testDeviceIds.isNotEmpty) {
        MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(testDeviceIds: testDeviceIds),
        );
      }

      await MobileAds.instance.initialize();
      _isInitialized = true;

      // Load initial ads with delay to ensure proper initialization
      Future.delayed(AdConfig.adLoadDelay, () {
        _loadInterstitialAd();
        _loadRewardedAd();
      });

      if (AdConfig.enableAdLogging) {
        debugPrint(
          'AdService: Initialized successfully (Test Mode: ${AdConfig.isTestMode})',
        );
        debugPrint(
          'AdService: Using ad unit IDs - Banner: ${AdConfig.getBannerAdUnitId()}',
        );
      }
    } catch (e) {
      debugPrint('AdService: Failed to initialize - $e');
      _isInitialized = false;
    }
  }

  /// Get banner ad unit ID
  String get bannerAdUnitId => AdConfig.getBannerAdUnitId();

  /// Get interstitial ad unit ID
  String get interstitialAdUnitId => AdConfig.getInterstitialAdUnitId();

  /// Get rewarded ad unit ID
  String get rewardedAdUnitId => AdConfig.getRewardedAdUnitId();

  /// Check if ads are enabled
  bool get adsEnabled => _adsEnabled;

  /// Check if banner ads should be shown
  Future<bool> get showBannerAds async {
    final shouldShow = await PremiumService.instance.shouldShowAds();
    final result = _adsEnabled && _showBannerAds && shouldShow;
    if (AdConfig.enableAdLogging) {
      debugPrint(
        'AdService: showBannerAds = $result (adsEnabled: $_adsEnabled, showBannerAds: $_showBannerAds, shouldShow: $shouldShow)',
      );
    }
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
    if (AdConfig.enableAdLogging) {
      debugPrint('AdService: Ads ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  /// Toggle banner ads
  void toggleBannerAds(bool enabled) {
    _showBannerAds = enabled;
    if (AdConfig.enableAdLogging) {
      debugPrint('AdService: Banner ads ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  /// Toggle interstitial ads
  void toggleInterstitialAds(bool enabled) {
    _showInterstitialAds = enabled;
    if (AdConfig.enableAdLogging) {
      debugPrint(
        'AdService: Interstitial ads ${enabled ? 'enabled' : 'disabled'}',
      );
    }
  }

  /// Toggle rewarded ads
  void toggleRewardedAds(bool enabled) {
    _showRewardedAds = enabled;
    if (AdConfig.enableAdLogging) {
      debugPrint('AdService: Rewarded ads ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  /// Load interstitial ad with improved error handling
  void _loadInterstitialAd() async {
    if (!_isInitialized) return;
    final shouldShow = await showInterstitialAds;
    if (!shouldShow) return;

    try {
      InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _interstitialLoadAttempts = 0;
            if (AdConfig.enableAdLogging) {
              debugPrint('AdService: Interstitial ad loaded successfully');
            }

            // Set up ad lifecycle callbacks
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                _interstitialAd = null;
                _loadInterstitialAd(); // Load next ad
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                if (AdConfig.enableAdLogging) {
                  debugPrint(
                    'AdService: Interstitial ad failed to show: $error',
                  );
                }
                ad.dispose();
                _interstitialAd = null;
                _loadInterstitialAd(); // Try to load again
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            _interstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (AdConfig.enableAdLogging) {
              debugPrint('AdService: Interstitial ad failed to load: $error');
            }

            if (_interstitialLoadAttempts < AdConfig.maxFailedLoadAttempts) {
              // Exponential backoff for retry
              final delay = Duration(seconds: _interstitialLoadAttempts * 2);
              Future.delayed(delay, _loadInterstitialAd);
            }
          },
        ),
      );
    } catch (e) {
      if (AdConfig.enableAdLogging) {
        debugPrint('AdService: Exception loading interstitial ad: $e');
      }
    }
  }

  /// Load rewarded ad with improved error handling
  void _loadRewardedAd() async {
    if (!_isInitialized) return;
    final shouldShow = await showRewardedAds;
    if (!shouldShow) return;

    try {
      RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _rewardedLoadAttempts = 0;
            if (AdConfig.enableAdLogging) {
              debugPrint('AdService: Rewarded ad loaded successfully');
            }

            // Set up ad lifecycle callbacks
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                _rewardedAd = null;
                _loadRewardedAd(); // Load next ad
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                if (AdConfig.enableAdLogging) {
                  debugPrint('AdService: Rewarded ad failed to show: $error');
                }
                ad.dispose();
                _rewardedAd = null;
                _loadRewardedAd(); // Try to load again
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            _rewardedLoadAttempts += 1;
            _rewardedAd = null;
            if (AdConfig.enableAdLogging) {
              debugPrint('AdService: Rewarded ad failed to load: $error');
            }

            if (_rewardedLoadAttempts < AdConfig.maxFailedLoadAttempts) {
              // Exponential backoff for retry
              final delay = Duration(seconds: _rewardedLoadAttempts * 2);
              Future.delayed(delay, _loadRewardedAd);
            }
          },
        ),
      );
    } catch (e) {
      if (AdConfig.enableAdLogging) {
        debugPrint('AdService: Exception loading rewarded ad: $e');
      }
    }
  }

  /// Show interstitial ad (with frequency control)
  Future<bool> showInterstitialAd() async {
    if (!_isInitialized || _interstitialAd == null) {
      if (AdConfig.enableAdLogging) {
        debugPrint('AdService: No interstitial ad available to show');
      }
      return false;
    }

    final shouldShow = await showInterstitialAds;
    if (!shouldShow) {
      if (AdConfig.enableAdLogging) {
        debugPrint('AdService: Interstitial ads disabled');
      }
      return false;
    }

    _interstitialAdCounter++;

    // Only show ad every N actions
    if (_interstitialAdCounter < AdConfig.interstitialAdFrequency) {
      if (AdConfig.enableAdLogging) {
        debugPrint(
          'AdService: Interstitial ad counter: $_interstitialAdCounter/${AdConfig.interstitialAdFrequency}',
        );
      }
      return false;
    }

    _interstitialAdCounter = 0;

    try {
      await _interstitialAd!.show();
      if (AdConfig.enableAdLogging) {
        debugPrint('AdService: Interstitial ad shown successfully');
      }
      return true;
    } catch (e) {
      if (AdConfig.enableAdLogging) {
        debugPrint('AdService: Failed to show interstitial ad - $e');
      }
      _interstitialAd = null;
      _loadInterstitialAd(); // Try to load again
      return false;
    }
  }

  /// Show rewarded ad
  Future<bool> showRewardedAd({
    required Function() onRewarded,
    required Function() onFailed,
  }) async {
    if (!_isInitialized || _rewardedAd == null) {
      if (AdConfig.enableAdLogging) {
        debugPrint('AdService: No rewarded ad available to show');
      }
      onFailed();
      return false;
    }

    final shouldShow = await showRewardedAds;
    if (!shouldShow) {
      if (AdConfig.enableAdLogging) {
        debugPrint('AdService: Rewarded ads disabled');
      }
      onFailed();
      return false;
    }

    try {
      await _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          onRewarded();
          if (AdConfig.enableAdLogging) {
            debugPrint(
              'AdService: User earned reward: ${reward.amount} ${reward.type}',
            );
          }
        },
      );

      if (AdConfig.enableAdLogging) {
        debugPrint('AdService: Rewarded ad shown successfully');
      }
      return true;
    } catch (e) {
      if (AdConfig.enableAdLogging) {
        debugPrint('AdService: Failed to show rewarded ad - $e');
      }
      onFailed();
      return false;
    }
  }

  /// Create banner ad widget with improved error handling
  Widget createBannerAd() {
    if (AdConfig.enableAdLogging) {
      debugPrint(
        'AdService: createBannerAd called, initialized: $_isInitialized',
      );
    }

    if (!_isInitialized) {
      if (AdConfig.enableAdLogging) {
        debugPrint('AdService: Not initialized, returning empty widget');
      }
      return const SizedBox.shrink();
    }

    return FutureBuilder<bool>(
      future: showBannerAds,
      builder: (context, snapshot) {
        if (AdConfig.enableAdLogging) {
          debugPrint(
            'AdService: FutureBuilder snapshot: ${snapshot.connectionState}, data: ${snapshot.data}',
          );
        }

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
                    if (AdConfig.enableAdLogging) {
                      debugPrint('AdService: Banner ad loaded successfully');
                    }
                  },
                  onAdFailedToLoad: (ad, error) {
                    if (AdConfig.enableAdLogging) {
                      debugPrint('AdService: Banner ad failed to load: $error');
                    }
                    ad.dispose();

                    // Don't retry banner ads immediately to avoid spam
                    // They will be recreated when the widget rebuilds
                  },
                  onAdOpened: (ad) {
                    if (AdConfig.enableAdLogging) {
                      debugPrint('AdService: Banner ad opened');
                    }
                  },
                  onAdClosed: (ad) {
                    if (AdConfig.enableAdLogging) {
                      debugPrint('AdService: Banner ad closed');
                    }
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
        if (AdConfig.enableAdLogging) {
          debugPrint('AdService: User earned access to $feature');
        }
      },
      onFailed: () {
        if (AdConfig.enableAdLogging) {
          debugPrint('AdService: Failed to earn access to $feature');
        }
      },
    );
  }

  /// Dispose ads
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    if (AdConfig.enableAdLogging) {
      debugPrint('AdService: Disposed');
    }
  }

  /// Get ad statistics
  Map<String, dynamic> getAdStats() {
    return {
      'adsEnabled': _adsEnabled,
      'showBannerAds': _showBannerAds,
      'showInterstitialAds': _showInterstitialAds,
      'showRewardedAds': _showRewardedAds,
      'interstitialCounter': _interstitialAdCounter,
      'interstitialFrequency': AdConfig.interstitialAdFrequency,
      'isTestMode': AdConfig.isTestMode,
      'isInitialized': _isInitialized,
      'adUnitIds': {
        'banner': bannerAdUnitId,
        'interstitial': interstitialAdUnitId,
        'rewarded': rewardedAdUnitId,
      },
    };
  }

  /// Force reload ads
  void reloadAds() {
    if (_isInitialized) {
      _loadInterstitialAd();
      _loadRewardedAd();
      if (AdConfig.enableAdLogging) {
        debugPrint('AdService: Forced reload of ads');
      }
    }
  }
}
