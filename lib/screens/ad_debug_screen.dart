import 'package:flutter/material.dart';
import '../services/ad_service.dart';
import '../config/ad_config.dart';

class AdDebugScreen extends StatefulWidget {
  const AdDebugScreen({super.key});

  @override
  State<AdDebugScreen> createState() => _AdDebugScreenState();
}

class _AdDebugScreenState extends State<AdDebugScreen> {
  Map<String, dynamic> _adStats = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshStats();
  }

  void _refreshStats() {
    setState(() {
      _adStats = AdService.instance.getAdStats();
    });
  }

  Future<void> _reloadAds() async {
    setState(() {
      _isLoading = true;
    });

    try {
      AdService.instance.reloadAds();
      await Future.delayed(const Duration(seconds: 2));
      _refreshStats();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testInterstitialAd() async {
    final success = await AdService.instance.showInterstitialAd();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Interstitial ad shown successfully'
                : 'Failed to show interstitial ad',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _testRewardedAd() async {
    final success = await AdService.instance.showRewardedAd(
      onRewarded: () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reward earned!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      onFailed: () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to show rewarded ad'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );

    if (mounted && !success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No rewarded ad available'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Debug Screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshStats),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Configuration Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ad Configuration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow('Test Mode', AdConfig.isTestMode.toString()),
                    _buildInfoRow('AdMob App ID', AdConfig.admobAppId),
                    _buildInfoRow(
                      'Banner Ad Unit ID',
                      AdConfig.getBannerAdUnitId(),
                    ),
                    _buildInfoRow(
                      'Interstitial Ad Unit ID',
                      AdConfig.getInterstitialAdUnitId(),
                    ),
                    _buildInfoRow(
                      'Rewarded Ad Unit ID',
                      AdConfig.getRewardedAdUnitId(),
                    ),
                    _buildInfoRow(
                      'Test Device IDs',
                      AdConfig.getTestDeviceIds().join(', '),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Status Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ad Service Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Initialized',
                      _adStats['isInitialized']?.toString() ?? 'Unknown',
                    ),
                    _buildInfoRow(
                      'Ads Enabled',
                      _adStats['adsEnabled']?.toString() ?? 'Unknown',
                    ),
                    _buildInfoRow(
                      'Banner Ads',
                      _adStats['showBannerAds']?.toString() ?? 'Unknown',
                    ),
                    _buildInfoRow(
                      'Interstitial Ads',
                      _adStats['showInterstitialAds']?.toString() ?? 'Unknown',
                    ),
                    _buildInfoRow(
                      'Rewarded Ads',
                      _adStats['showRewardedAds']?.toString() ?? 'Unknown',
                    ),
                    _buildInfoRow(
                      'Interstitial Counter',
                      '${_adStats['interstitialCounter'] ?? 0}/${_adStats['interstitialFrequency'] ?? 0}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Test Controls Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _reloadAds,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
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
                                : const Text('Reload Ads'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _testInterstitialAd,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Test Interstitial'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _testRewardedAd,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Test Rewarded Ad'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Banner Ad Preview
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Banner Ad Preview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AdService.instance.createBannerAd(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Logs Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Logs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 200,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const SingleChildScrollView(
                        child: Text(
                          'Ad logs will appear here when running in debug mode.\n\n'
                          'Check the console/terminal for detailed ad loading logs.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'None' : value,
              style: TextStyle(
                color: value.isEmpty ? Colors.grey : Colors.black87,
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
