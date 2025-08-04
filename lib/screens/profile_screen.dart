import 'package:flutter/material.dart';
import '../utils/glassmorphism_theme.dart';
import '../utils/formatters.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _businessNameController = TextEditingController(
    text: 'My Business',
  );
  final TextEditingController _ownerNameController = TextEditingController(
    text: 'John Doe',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'john@mybusiness.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '+1 (555) 123-4567',
  );
  final TextEditingController _addressController = TextEditingController(
    text: '123 Business St, City, State 12345',
  );

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    // In a real app, this would load from a service or database
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

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildBusinessInfo(),
          const SizedBox(height: 24),
          _buildContactInfo(),
          const SizedBox(height: 24),
          _buildPreferences(),
          const SizedBox(height: 24),
          _buildAccountActions(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
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
            _businessNameController.text,
            style: const TextStyle(
              color: GlassmorphismTheme.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Business Owner',
            style: const TextStyle(
              color: GlassmorphismTheme.textSecondaryColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessInfo() {
    return _buildSection('Business Information', [
      _buildTextField(
        controller: _businessNameController,
        label: 'Business Name',
        icon: Icons.business,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _ownerNameController,
        label: 'Owner Name',
        icon: Icons.person,
      ),
    ]);
  }

  Widget _buildContactInfo() {
    return _buildSection('Contact Information', [
      _buildTextField(
        controller: _emailController,
        label: 'Email',
        icon: Icons.email,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _phoneController,
        label: 'Phone',
        icon: Icons.phone,
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _addressController,
        label: 'Address',
        icon: Icons.location_on,
        maxLines: 3,
      ),
    ]);
  }

  Widget _buildPreferences() {
    return _buildSection('Preferences', [
      _buildSwitchTile(
        'Dark Mode',
        'Use dark theme',
        Icons.dark_mode,
        true,
        (value) {},
      ),
      _buildSwitchTile(
        'Notifications',
        'Receive business alerts',
        Icons.notifications,
        true,
        (value) {},
      ),
      _buildSwitchTile(
        'Auto Backup',
        'Automatically backup data',
        Icons.backup,
        false,
        (value) {},
      ),
    ]);
  }

  Widget _buildAccountActions() {
    return _buildSection('Account', [
      _buildActionTile(
        'Export Data',
        'Download your business data',
        Icons.download,
        () {},
      ),
      _buildActionTile(
        'Import Data',
        'Restore from backup',
        Icons.upload,
        () {},
      ),
      _buildActionTile(
        'Change Password',
        'Update your account password',
        Icons.lock,
        () {},
      ),
      _buildActionTile(
        'Delete Account',
        'Permanently delete your account',
        Icons.delete_forever,
        _showDeleteAccountDialog,
        isDestructive: true,
      ),
    ]);
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
