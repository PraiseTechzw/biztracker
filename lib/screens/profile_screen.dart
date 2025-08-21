import 'package:flutter/material.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/ad_service.dart';
import 'profile_update_screen.dart';
import 'premium_screen.dart';
import '../models/business_profile.dart';
import '../services/sqlite_database_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  BusinessProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });
    final profile = await SQLiteDatabaseService().getFirstBusinessProfile();
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  Future<void> _refreshProfile() async {
    await _loadProfileData();
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
              : _profile == null
              ? _buildNoProfileView()
              : RefreshIndicator(
                  onRefresh: _refreshProfile,
                  color: GlassmorphismTheme.primaryColor,
                  child: Column(
                    children: [
                      _buildAppBar(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildProfileContent(),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildNoProfileView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business,
              size: 60,
              color: GlassmorphismTheme.primaryColor,
            ),
            const SizedBox(height: 24),
            const Text(
              'No Business Profile Found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: GlassmorphismTheme.textColor,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'You have not set up your business profile yet. Please create one to get started.',
              style: TextStyle(
                fontSize: 16,
                color: GlassmorphismTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => const ProfileUpdateScreen(),
                      ),
                    )
                    .then((_) => _loadProfileData());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlassmorphismTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Create Business Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    final p = _profile!;
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildInfoCard('Business Information', [
            _buildInfoRow('Business Name', p.businessName),
            _buildInfoRow('Type', p.businessType),
            if (p.businessDescription != null &&
                p.businessDescription!.isNotEmpty)
              _buildInfoRow('Description', p.businessDescription!),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Contact', [
            if (p.phoneNumber != null && p.phoneNumber!.isNotEmpty)
              _buildInfoRow('Phone', p.phoneNumber!),
            if (p.email != null && p.email!.isNotEmpty)
              _buildInfoRow('Email', p.email!),
            if (p.website != null && p.website!.isNotEmpty)
              _buildInfoRow('Website', p.website!),
          ]),
          const SizedBox(height: 16),
          if (p.fullAddress.isNotEmpty)
            _buildInfoCard('Address', [
              _buildInfoRow('Address', p.fullAddress),
            ]),
          if (p.fullAddress.isNotEmpty) const SizedBox(height: 16),
          _buildInfoCard('Business Details', [
            if (p.industry != null && p.industry!.isNotEmpty)
              _buildInfoRow('Industry', p.industry!),
            if (p.currency != null && p.currency!.isNotEmpty)
              _buildInfoRow('Currency', p.currency!),
            if (p.taxId != null && p.taxId!.isNotEmpty)
              _buildInfoRow('Tax ID', p.taxId!),
            if (p.registrationNumber != null &&
                p.registrationNumber!.isNotEmpty)
              _buildInfoRow('Registration', p.registrationNumber!),
          ]),
          const SizedBox(height: 16),
          if (p.ownerName != null && p.ownerName!.isNotEmpty)
            _buildInfoCard('Owner', [
              _buildInfoRow('Name', p.ownerName!),
              if (p.ownerPhone != null && p.ownerPhone!.isNotEmpty)
                _buildInfoRow('Phone', p.ownerPhone!),
              if (p.ownerEmail != null && p.ownerEmail!.isNotEmpty)
                _buildInfoRow('Email', p.ownerEmail!),
            ]),
          if (p.ownerName != null && p.ownerName!.isNotEmpty)
            const SizedBox(height: 16),
          _buildInfoCard('Status', [
            _buildInfoRow('Active', p.isActive ? 'Yes' : 'No'),
            _buildInfoRow(
              'Created',
              p.createdAt.toLocal().toString().split(' ').first,
            ),
            _buildInfoRow(
              'Updated',
              p.updatedAt.toLocal().toString().split(' ').first,
            ),
          ]),
          const SizedBox(height: 16),
          _buildAdSettingsCard(),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => ProfileUpdateScreen(),
                    ),
                  )
                  .then((_) => _loadProfileData());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GlassmorphismTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    final p = _profile!;
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  GlassmorphismTheme.primaryColor,
                  GlassmorphismTheme.secondaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.business, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          Text(
            p.displayName,
            style: const TextStyle(
              color: GlassmorphismTheme.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            p.businessType.toUpperCase(),
            style: const TextStyle(
              color: GlassmorphismTheme.textSecondaryColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: GlassmorphismTheme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: GlassmorphismTheme.textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: GlassmorphismTheme.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Profile',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: _saveProfile,
            icon: const Icon(Icons.save, color: GlassmorphismTheme.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: GlassmorphismTheme.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GlassmorphismTheme.glassmorphismContainer(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: GlassmorphismTheme.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: GlassmorphismTheme.primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: GlassmorphismTheme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: GlassmorphismTheme.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: GlassmorphismTheme.textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: GlassmorphismTheme.textSecondaryColor,
          fontSize: 14,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: GlassmorphismTheme.primaryColor,
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isDestructive ? Colors.red : GlassmorphismTheme.primaryColor)
              .withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : GlassmorphismTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : GlassmorphismTheme.textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: GlassmorphismTheme.textSecondaryColor,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: GlassmorphismTheme.textSecondaryColor,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _saveProfile() {
    // In a real app, this would save to a service or database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildAdSettingsCard() {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.ads_click,
                color: GlassmorphismTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Ad Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: GlassmorphismTheme.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Enable Ads',
            'Show ads to support app development',
            Icons.ads_click,
            AdService.instance.adsEnabled,
            (value) {
              AdService.instance.toggleAds(value);
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PremiumScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.workspace_premium),
              label: const Text('Premium & Ad-Free Options'),
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Delete Account',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, this would delete the account
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion feature coming soon'),
                  backgroundColor: GlassmorphismTheme.primaryColor,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
