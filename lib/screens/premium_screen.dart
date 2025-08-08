import 'package:flutter/material.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/premium_service.dart';
import '../services/ad_service.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  Map<String, dynamic>? _premiumStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPremiumStatus();
  }

  Future<void> _loadPremiumStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final status = await PremiumService.instance.getPremiumStatus();
      setState(() {
        _premiumStatus = status;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [GlassmorphismTheme.backgroundColor, Color(0xFF1E293B)],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadPremiumStatus,
                  color: GlassmorphismTheme.primaryColor,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAppBar(),
                        const SizedBox(height: 24),
                        _buildCurrentStatus(),
                        const SizedBox(height: 24),
                        _buildRewardedAdsSection(),
                        const SizedBox(height: 24),
                        _buildPremiumPlans(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: GlassmorphismTheme.textColor,
          ),
        ),
        const Text(
          'Premium & Ad-Free',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: GlassmorphismTheme.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStatus() {
    if (_premiumStatus == null) return const SizedBox.shrink();

    final isPremium = _premiumStatus!['isPremium'] as bool;
    final hasAdFree = _premiumStatus!['hasAdFreePeriod'] as bool;
    final plan = _premiumStatus!['plan'] as String;
    final planExpiry = _premiumStatus!['planExpiry'] as String?;
    final adFreeExpiry = _premiumStatus!['adFreeExpiry'] as String?;

    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPremium ? Icons.workspace_premium : Icons.info_outline,
                color: isPremium
                    ? Colors.amber
                    : GlassmorphismTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                isPremium ? 'Premium Active' : 'Current Status',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: GlassmorphismTheme.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatusRow('Plan', plan.replaceAll('PremiumPlan.', '')),
          if (isPremium && planExpiry != null)
            _buildStatusRow('Expires', _formatDate(planExpiry)),
          if (hasAdFree && adFreeExpiry != null)
            _buildStatusRow('Ad-Free Until', _formatDate(adFreeExpiry)),
          _buildStatusRow(
            'Ads Status',
            isPremium || hasAdFree ? 'Disabled' : 'Enabled',
            valueColor: isPremium || hasAdFree ? Colors.green : Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildRewardedAdsSection() {
    if (_premiumStatus == null) return const SizedBox.shrink();

    final watchedAds = _premiumStatus!['watchedAds'] as int;
    final nextReward = _premiumStatus!['nextReward'] as Map<String, dynamic>;
    final message = nextReward['message'] as String;

    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.card_giftcard,
                color: GlassmorphismTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Watch Ads for Ad-Free Time',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: GlassmorphismTheme.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: GlassmorphismTheme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildStatusRow('Ads Watched Today', '$watchedAds'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _watchRewardedAd(),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Watch Ad for Ad-Free Time'),
              style: ElevatedButton.styleFrom(
                backgroundColor: GlassmorphismTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumPlans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Premium Plans',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: GlassmorphismTheme.textColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildPlanCard(PremiumPlan.monthly),
        const SizedBox(height: 12),
        _buildPlanCard(PremiumPlan.annual),
        const SizedBox(height: 12),
        _buildPlanCard(PremiumPlan.lifetime),
      ],
    );
  }

  Widget _buildPlanCard(PremiumPlan plan) {
    final price = PremiumService.getPlanPrice(plan);
    final savings = PremiumService.getPlanSavings(plan);
    final features = PremiumService.getPlanFeatures(plan);
    final isCurrentPlan = _premiumStatus?['plan'] == plan.toString();

    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getPlanName(plan),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: GlassmorphismTheme.textColor,
                    ),
                  ),
                  if (savings > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Save ${savings.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: GlassmorphismTheme.primaryColor,
                    ),
                  ),
                  if (plan == PremiumPlan.annual)
                    Text(
                      'per year',
                      style: TextStyle(
                        fontSize: 12,
                        color: GlassmorphismTheme.textSecondaryColor,
                      ),
                    )
                  else if (plan == PremiumPlan.monthly)
                    Text(
                      'per month',
                      style: TextStyle(
                        fontSize: 12,
                        color: GlassmorphismTheme.textSecondaryColor,
                      ),
                    )
                  else if (plan == PremiumPlan.lifetime)
                    Text(
                      'one-time',
                      style: TextStyle(
                        fontSize: 12,
                        color: GlassmorphismTheme.textSecondaryColor,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(
                        fontSize: 14,
                        color: GlassmorphismTheme.textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isCurrentPlan ? null : () => _purchasePlan(plan),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrentPlan
                    ? Colors.grey
                    : GlassmorphismTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                isCurrentPlan ? 'Current Plan' : 'Choose Plan',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: GlassmorphismTheme.textSecondaryColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? GlassmorphismTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getPlanName(PremiumPlan plan) {
    switch (plan) {
      case PremiumPlan.monthly:
        return 'Monthly Plan';
      case PremiumPlan.annual:
        return 'Annual Plan';
      case PremiumPlan.lifetime:
        return 'Lifetime Plan';
      case PremiumPlan.free:
        return 'Free Plan';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Future<void> _watchRewardedAd() async {
    try {
      final success = await AdService.instance.showRewardedAd(
        onRewarded: () async {
          await PremiumService.instance.watchRewardedAd();
          await _loadPremiumStatus();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ad-free time granted!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        onFailed: () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to load ad. Please try again.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
      );

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No ad available. Please try again later.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _purchasePlan(PremiumPlan plan) async {
    try {
      final success = await PremiumService.instance.purchasePlan(plan);

      if (success) {
        await _loadPremiumStatus();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_getPlanName(plan)} purchased successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Purchase failed. Please try again.'),
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
    }
  }
}
