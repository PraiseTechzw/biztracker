import 'package:flutter/material.dart';
import '../utils/glassmorphism_theme.dart';
import '../models/business_profile.dart';
import '../services/sqlite_database_service.dart';
import 'business_profile_screen.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  BusinessProfile? _currentProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  Future<void> _loadCurrentProfile() async {
    try {
      final profile = await SQLiteDatabaseService().getFirstBusinessProfile();
      setState(() {
        _currentProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [GlassmorphismTheme.backgroundColor, Color(0xFF1E1B4B)],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: GlassmorphismTheme.primaryColor,
                ),
              )
            : _currentProfile == null
            ? _buildNoProfileView()
            : _buildProfileView(),
      ),
    );
  }

  Widget _buildNoProfileView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: GlassmorphismTheme.primaryGradient,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(Icons.business, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Business Profile Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: GlassmorphismTheme.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'You need to create a business profile first before you can update it.',
              style: TextStyle(
                fontSize: 16,
                color: GlassmorphismTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BusinessProfileScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GlassmorphismTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Create Business Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    final profile = _currentProfile!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Profile Summary
          GlassmorphismTheme.glassmorphismContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: GlassmorphismTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.business,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.displayName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: GlassmorphismTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.businessType.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: GlassmorphismTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: profile.isActive
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: profile.isActive ? Colors.green : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        profile.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: profile.isActive ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),

                if (profile.businessDescription != null &&
                    profile.businessDescription!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      profile.businessDescription!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: GlassmorphismTheme.textSecondaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Profile Information Cards
          _buildInfoCard(
            title: 'Contact Information',
            icon: Icons.contact_phone,
            items: [
              if (profile.phoneNumber != null &&
                  profile.phoneNumber!.isNotEmpty)
                _buildInfoItem('Phone', profile.phoneNumber!),
              if (profile.email != null && profile.email!.isNotEmpty)
                _buildInfoItem('Email', profile.email!),
              if (profile.website != null && profile.website!.isNotEmpty)
                _buildInfoItem('Website', profile.website!),
            ],
          ),

          const SizedBox(height: 16),

          if (profile.fullAddress.isNotEmpty)
            _buildInfoCard(
              title: 'Address',
              icon: Icons.location_on,
              items: [_buildInfoItem('Address', profile.fullAddress)],
            ),

          if (profile.fullAddress.isNotEmpty) const SizedBox(height: 16),

          _buildInfoCard(
            title: 'Business Details',
            icon: Icons.receipt_long,
            items: [
              if (profile.industry != null && profile.industry!.isNotEmpty)
                _buildInfoItem('Industry', profile.industry!),
              if (profile.currency != null && profile.currency!.isNotEmpty)
                _buildInfoItem('Currency', profile.currency!),
              if (profile.taxId != null && profile.taxId!.isNotEmpty)
                _buildInfoItem('Tax ID', profile.taxId!),
              if (profile.registrationNumber != null &&
                  profile.registrationNumber!.isNotEmpty)
                _buildInfoItem('Registration', profile.registrationNumber!),
            ],
          ),

          const SizedBox(height: 16),

          if (profile.ownerName != null && profile.ownerName!.isNotEmpty)
            _buildInfoCard(
              title: 'Owner Information',
              icon: Icons.person,
              items: [
                _buildInfoItem('Name', profile.ownerName!),
                if (profile.ownerPhone != null &&
                    profile.ownerPhone!.isNotEmpty)
                  _buildInfoItem('Phone', profile.ownerPhone!),
                if (profile.ownerEmail != null &&
                    profile.ownerEmail!.isNotEmpty)
                  _buildInfoItem('Email', profile.ownerEmail!),
              ],
            ),

          if (profile.ownerName != null && profile.ownerName!.isNotEmpty)
            const SizedBox(height: 16),

          // Update Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) =>
                            BusinessProfileScreen(existingProfile: profile),
                      ),
                    )
                    .then((_) {
                      // Refresh the profile after update
                      _loadCurrentProfile();
                    });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlassmorphismTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: GlassmorphismTheme.primaryColor, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: GlassmorphismTheme.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
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
}
