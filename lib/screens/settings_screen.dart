import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/sqlite_database_service.dart';
import '../models/business_profile.dart';
import 'notifications_screen.dart';
import 'welcome_screen.dart';
import 'business_profile_screen.dart'; // Added import for BusinessProfileScreen

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoading = false;
  BusinessProfile? businessProfile;
  Map<String, dynamic> appStats = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final profile = await SQLiteDatabaseService().getFirstBusinessProfile();
      final stats = await SQLiteDatabaseService().getBusinessMetrics();

      if (mounted) {
        setState(() {
          businessProfile = profile;
          appStats = stats;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String _getAppVersion() {
    return '1.0.0';
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
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: GlassmorphismTheme.primaryColor,
                          ),
                        )
                      : _buildSettingsContent(),
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
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: GlassmorphismTheme.textColor,
            ),
          ),
          const Expanded(
            child: Text(
              'Settings',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications,
              color: GlassmorphismTheme.primaryColor,
            ),
            tooltip: 'Notifications',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBusinessProfileSection(),
          const SizedBox(height: 24),
          _buildSection('App Information', [
            _buildSettingTile(
              'App Version',
              '1.0.0',
              Icons.info_outline,
              onTap: null,
            ),
            _buildSettingTile('Build Number', '1', Icons.build, onTap: null),
            _buildSettingTile(
              'Last Updated',
              DateFormat('MMM dd, yyyy').format(DateTime.now()),
              Icons.update,
              onTap: null,
            ),
            _buildSettingTile(
              'Database Status',
              'Connected',
              Icons.storage,
              onTap: null,
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('Business Statistics', [
            _buildStatTile(
              'Total Sales',
              '\$${NumberFormat('#,##0.00').format(appStats['totalSales'] ?? 0.0)}',
              Icons.trending_up,
              Colors.green,
            ),
            _buildStatTile(
              'Total Expenses',
              '\$${NumberFormat('#,##0.00').format(appStats['totalExpenses'] ?? 0.0)}',
              Icons.trending_down,
              Colors.red,
            ),
            _buildStatTile(
              'Net Profit',
              '\$${NumberFormat('#,##0.00').format(appStats['netProfit'] ?? 0.0)}',
              Icons.account_balance_wallet,
              (appStats['netProfit'] ?? 0.0) >= 0 ? Colors.green : Colors.red,
            ),
            _buildStatTile(
              'Total Customers',
              '${appStats['totalCustomers'] ?? 0}',
              Icons.people,
              Colors.blue,
            ),
            _buildStatTile(
              'Inventory Items',
              '${appStats['lowStockCount'] ?? 0} low stock',
              Icons.inventory,
              Colors.orange,
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('Data Management', [
            _buildSettingTile(
              'Export Data',
              'Backup your business data',
              Icons.download,
              onTap: _exportData,
            ),
            _buildSettingTile(
              'Import Data',
              'Restore from backup',
              Icons.upload,
              onTap: _importData,
            ),
            _buildSettingTile(
              'Backup Settings',
              'Configure backup preferences',
              Icons.backup,
              onTap: _showBackupSettings,
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('App Settings', [
            _buildSettingTile(
              'Theme Settings',
              'Customize app appearance',
              Icons.palette,
              onTap: _showThemeSettings,
            ),
            _buildSettingTile(
              'Notification Settings',
              'Manage app notifications',
              Icons.notifications_active,
              onTap: _showNotificationSettings,
            ),
            _buildSettingTile(
              'Privacy Settings',
              'Manage data privacy',
              Icons.privacy_tip,
              onTap: _showPrivacySettings,
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('Support', [
            _buildSettingTile(
              'Help & FAQ',
              'Get help with the app',
              Icons.help_outline,
              onTap: _showHelpDialog,
            ),
            _buildSettingTile(
              'Contact Support',
              'Get in touch with us',
              Icons.support_agent,
              onTap: _showContactSupport,
            ),
            _buildSettingTile(
              'Report Bug',
              'Report app issues',
              Icons.bug_report,
              onTap: _showBugReport,
            ),
            _buildSettingTile(
              'About BizTracker',
              'Learn more about the app',
              Icons.business,
              onTap: _showAboutDialog,
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('Legal', [
            _buildSettingTile(
              'Privacy Policy',
              'Read our privacy policy',
              Icons.privacy_tip_outlined,
              onTap: _showPrivacyPolicy,
            ),
            _buildSettingTile(
              'Terms of Service',
              'Read our terms of service',
              Icons.description,
              onTap: _showTermsOfService,
            ),
            _buildSettingTile(
              'Licenses',
              'Open source licenses',
              Icons.description_outlined,
              onTap: _showLicenses,
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('Account', [
            _buildSettingTile(
              'Logout',
              'Sign out and clear profile data',
              Icons.logout,
              onTap: _showLogoutDialog,
              isDestructive: true,
            ),
            _buildSettingTile(
              'Clear All Data',
              'Delete all business records and data',
              Icons.delete_forever,
              onTap: _showClearDataDialog,
              isDestructive: true,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildBusinessProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Business Profile',
          style: TextStyle(
            color: GlassmorphismTheme.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GlassmorphismTheme.glassmorphismContainer(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: GlassmorphismTheme.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.business,
                color: GlassmorphismTheme.primaryColor,
                size: 24,
              ),
            ),
            title: Text(
              businessProfile?.businessName ?? 'Business Name Not Set',
              style: const TextStyle(
                color: GlassmorphismTheme.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              businessProfile?.businessType ?? 'Business Type Not Set',
              style: const TextStyle(
                color: GlassmorphismTheme.textSecondaryColor,
                fontSize: 14,
              ),
            ),
            trailing: const Icon(
              Icons.edit,
              color: GlassmorphismTheme.primaryColor,
              size: 20,
            ),
            onTap: _editBusinessProfile,
          ),
        ),
      ],
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

  Widget _buildSettingTile(
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withValues(alpha: 0.2)
              : GlassmorphismTheme.primaryColor.withValues(alpha: 0.2),
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
      trailing: onTap != null
          ? const Icon(
              Icons.arrow_forward_ios,
              color: GlassmorphismTheme.textSecondaryColor,
              size: 16,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildStatTile(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
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
        value,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _editBusinessProfile() {
    // Navigate to business profile screen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const BusinessProfileScreen()),
    );
  }

  Future<void> _exportData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Show progress dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: GlassmorphismTheme.surfaceColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: GlassmorphismTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'Exporting your business data...',
                style: TextStyle(color: GlassmorphismTheme.textColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

      // Get all data from database
      final sales = await SQLiteDatabaseService().getAllSales();
      final expenses = await SQLiteDatabaseService().getAllExpenses();
      final stocks = await SQLiteDatabaseService().getAllStocks();
      final capitals = await SQLiteDatabaseService().getAllCapitals();
      final profits = await SQLiteDatabaseService().getAllProfits();
      final profile = await SQLiteDatabaseService().getFirstBusinessProfile();

      // Create export data structure
      final exportData = {
        'exportDate': DateTime.now().toIso8601String(),
        'appInfo': {
          'appName': 'BizTracker',
          'version': '1.0.1',
          'developer': 'Appixia Software',
          'developerContact': 'praisemasunga@appixia.co.zw',
          'website': 'www.appixia.co.zw',
        },
        'businessProfile': profile != null
            ? {
                'businessName': profile.businessName,
                'businessType': profile.businessType,
                'address': profile.address,
                'phoneNumber': profile.phoneNumber,
                'email': profile.email,
              }
            : null,
        'sales': sales
            .map(
              (s) => {
                'productName': s.productName,
                'quantity': s.quantity,
                'unitPrice': s.unitPrice,
                'totalAmount': s.totalAmount,
                'customerName': s.customerName,
                'paymentStatus': s.paymentStatus,
                'saleDate': s.saleDate.toIso8601String(),
              },
            )
            .toList(),
        'expenses': expenses
            .map(
              (e) => {
                'category': e.category,
                'description': e.description,
                'amount': e.amount,
                'expenseDate': e.expenseDate.toIso8601String(),
              },
            )
            .toList(),
        'stocks': stocks
            .map(
              (s) => {
                'name': s.name,
                'quantity': s.quantity,
                'unitCostPrice': s.unitCostPrice,
                'unitSellingPrice': s.unitSellingPrice,
              },
            )
            .toList(),
        'capitals': capitals
            .map(
              (c) => {
                'amount': c.amount,
                'description': c.description,
                'type': c.type,
                'date': c.date.toIso8601String(),
              },
            )
            .toList(),
        'profits': profits
            .map(
              (p) => {
                'revenue': p.revenue,
                'expenses': p.expenses,
                'netProfit': p.netProfit,
                'profitMargin': p.profitMargin,
                'periodStart': p.periodStart.toIso8601String(),
                'periodEnd': p.periodEnd.toIso8601String(),
              },
            )
            .toList(),
      };

      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'biztracker_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json';
      final file = File('${directory.path}/$fileName');

      // Convert to proper JSON string
      final jsonString = exportData.toString().replaceAll("'", '"');

      // Write data to file
      await file.writeAsString(jsonString);

      // Close progress dialog
      if (mounted) {
        Navigator.pop(context);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported successfully to: $fileName'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Open Folder',
              onPressed: () {
                // In a real app, you would open the file or folder
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File saved to Documents folder'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Close progress dialog if there's an error
      if (mounted) {
        Navigator.pop(context);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _importData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Import Data',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Import Feature',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This feature will be available in the next update. For now, you can:\n\n'
              '• Export your current data as backup\n'
              '• Manually restore data by copying the exported JSON file\n'
              '• Contact support for assistance\n\n'
              'Coming soon: One-click data import and restore functionality.',
              style: TextStyle(color: GlassmorphismTheme.textColor),
            ),
            SizedBox(height: 16),
            Text(
              'Contact: support@appixia.co.zw',
              style: TextStyle(
                color: GlassmorphismTheme.primaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBackupSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Backup Settings',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Automatic Backup:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Daily backup at 2:00 AM\n'
              '• Keep last 7 backups\n'
              '• Backup to local storage\n'
              '• Encrypt sensitive data\n'
              '• Auto-cleanup old backups',
              style: TextStyle(color: GlassmorphismTheme.textColor),
            ),
            SizedBox(height: 16),
            Text(
              'Manual Backup:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Export data anytime\n'
              '• Save to Documents folder\n'
              '• JSON format for compatibility\n'
              '• Include all business data',
              style: TextStyle(color: GlassmorphismTheme.textColor),
            ),
            SizedBox(height: 16),
            Text(
              'Contact: support@appixia.co.zw',
              style: TextStyle(
                color: GlassmorphismTheme.primaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showThemeSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Theme Settings',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Theme:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              title: Text(
                'Dark Theme',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              trailing: Icon(
                Icons.check,
                color: GlassmorphismTheme.primaryColor,
              ),
            ),
            ListTile(
              title: Text(
                'Glassmorphism UI',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              trailing: Icon(
                Icons.check,
                color: GlassmorphismTheme.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Coming Soon:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Light theme option\n'
              '• Custom color schemes\n'
              '• Font size adjustments\n'
              '• High contrast mode',
              style: TextStyle(color: GlassmorphismTheme.textColor),
            ),
            SizedBox(height: 16),
            Text(
              'Contact: support@appixia.co.zw',
              style: TextStyle(
                color: GlassmorphismTheme.primaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Notification Settings',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Alerts:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              title: Text(
                'Low Stock Alerts',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              trailing: Switch(value: true, onChanged: null),
            ),
            ListTile(
              title: Text(
                'Payment Reminders',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              trailing: Switch(value: true, onChanged: null),
            ),
            ListTile(
              title: Text(
                'Daily Reports',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              trailing: Switch(value: false, onChanged: null),
            ),
            SizedBox(height: 16),
            Text(
              'Coming Soon:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Custom notification times\n'
              '• Sound and vibration options\n'
              '• Priority level settings\n'
              '• Do not disturb mode',
              style: TextStyle(color: GlassmorphismTheme.textColor),
            ),
            SizedBox(height: 16),
            Text(
              'Contact: support@appixia.co.zw',
              style: TextStyle(
                color: GlassmorphismTheme.primaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Privacy Settings',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Collection:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• All data is stored locally\n'
              '• No data is sent to external servers\n'
              '• Analytics are disabled\n'
              '• Your privacy is protected',
              style: TextStyle(color: GlassmorphismTheme.textColor),
            ),
            SizedBox(height: 16),
            Text(
              'Data Security:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Local encryption for sensitive data\n'
              '• No cloud synchronization\n'
              '• No third-party access\n'
              '• Complete data ownership',
              style: TextStyle(color: GlassmorphismTheme.textColor),
            ),
            SizedBox(height: 16),
            Text(
              'Your Rights:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Export your data anytime\n'
              '• Delete all data permanently\n'
              '• No tracking or profiling\n'
              '• Full control over your information',
              style: TextStyle(color: GlassmorphismTheme.textColor),
            ),
            SizedBox(height: 16),
            Text(
              'Contact: support@appixia.co.zw',
              style: TextStyle(
                color: GlassmorphismTheme.primaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Clear All Data',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          '⚠️ WARNING: This will permanently delete ALL your business data including:\n\n'
          '• Sales records\n'
          '• Expense records\n'
          '• Stock inventory\n'
          '• Capital records\n'
          '• Business profile\n'
          '• All reports and analytics\n\n'
          'This action cannot be undone. Are you absolutely sure?',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _clearAllData();
            },
            child: const Text(
              'Clear All Data',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Show final confirmation dialog
      final shouldClear = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: GlassmorphismTheme.surfaceColor,
          title: const Text(
            'Final Warning',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            '⚠️ This is your FINAL warning!\n\n'
            'This action will permanently delete ALL your business data including:\n\n'
            '• Sales records\n'
            '• Expense records\n'
            '• Stock inventory\n'
            '• Capital records\n'
            '• Business profile\n'
            '• All reports and analytics\n\n'
            'This action cannot be undone. Are you absolutely sure?',
            style: TextStyle(color: GlassmorphismTheme.textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Yes, Delete Everything',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

      if (shouldClear != true) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Clear all business data
      await SQLiteDatabaseService().clearAllBusinessData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate to welcome screen after clearing data
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const WelcomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear data: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Help & FAQ',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How to use BizTracker:',
                style: TextStyle(
                  color: GlassmorphismTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '1. Start by adding your initial capital\n'
                '2. Add your inventory items\n'
                '3. Record sales transactions\n'
                '4. Track your expenses\n'
                '5. Generate reports to analyze performance\n\n'
                'Frequently Asked Questions:\n\n'
                'Q: How do I add a new product?\n'
                'A: Go to Stock Management and tap the + button\n\n'
                'Q: How do I record a sale?\n'
                'A: Go to Sales and tap the + button\n\n'
                'Q: How do I view reports?\n'
                'A: Go to Reports to see detailed analytics\n\n'
                'Q: How do I backup my data?\n'
                'A: Go to Settings > Data Management > Export Data\n\n'
                'Q: How do I change business profile?\n'
                'A: Go to Settings > Business Profile and tap to edit',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              SizedBox(height: 16),
              Text(
                'Need More Help?',
                style: TextStyle(
                  color: GlassmorphismTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Contact our support team:\n'
                'support@appixia.co.zw\n'
                'www.appixia.co.zw',
                style: TextStyle(
                  color: GlassmorphismTheme.primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Contact Support',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get in touch with our support team:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.email,
                color: GlassmorphismTheme.primaryColor,
              ),
              title: Text(
                'General Support',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              subtitle: Text(
                'support@appixia.co.zw',
                style: TextStyle(color: GlassmorphismTheme.textSecondaryColor),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: GlassmorphismTheme.primaryColor,
              ),
              title: Text(
                'Developer Contact',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              subtitle: Text(
                'praisemasunga@appixia.co.zw',
                style: TextStyle(color: GlassmorphismTheme.textSecondaryColor),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.language,
                color: GlassmorphismTheme.primaryColor,
              ),
              title: Text(
                'Website',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              subtitle: Text(
                'www.appixia.co.zw',
                style: TextStyle(color: GlassmorphismTheme.textSecondaryColor),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBugReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Report Bug',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help us improve BizTracker by reporting bugs:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '• Describe the issue in detail\n'
              '• Include steps to reproduce\n'
              '• Mention your device and OS\n'
              '• Attach screenshots if possible\n\n'
              'Email: support@appixia.co.zw',
              style: TextStyle(color: GlassmorphismTheme.textColor),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'About BizTracker',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BizTracker v${_getAppVersion()}',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A modern business tracking app with glassmorphism UI design. '
              'Track your capital, inventory, sales, expenses, and generate '
              'detailed profit reports.',
              style: TextStyle(color: GlassmorphismTheme.textColor),
            ),
            const SizedBox(height: 16),
            const Text(
              'Features:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Capital Management\n'
              '• Stock/Inventory Tracking\n'
              '• Sales Recording\n'
              '• Expense Tracking\n'
              '• Profit Analysis\n'
              '• Business Reports\n'
              '• Data Export/Import\n'
              '• Professional UI Design',
              style: TextStyle(color: GlassmorphismTheme.textColor),
            ),
            const SizedBox(height: 16),
            const Text(
              'Developed by:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Appixia Software\n'
              'Praise Masunga',
              style: TextStyle(
                color: GlassmorphismTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Contact: support@appixia.co.zw\n'
              'Website: www.appixia.co.zw',
              style: TextStyle(
                color: GlassmorphismTheme.textSecondaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last updated: ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
                style: TextStyle(
                  color: GlassmorphismTheme.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your Privacy Matters',
                style: TextStyle(
                  color: GlassmorphismTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'BizTracker is committed to protecting your privacy. '
                'All your business data is stored locally on your device '
                'and is never transmitted to external servers without your explicit consent.',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              const SizedBox(height: 16),
              const Text(
                'Data Collection:',
                style: TextStyle(
                  color: GlassmorphismTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• We collect only the data you enter\n'
                '• All data is stored locally\n'
                '• No analytics or tracking\n'
                '• No third-party data sharing',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              const SizedBox(height: 16),
              const Text(
                'Contact Information:',
                style: TextStyle(
                  color: GlassmorphismTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'For privacy concerns, contact:\n'
                'support@appixia.co.zw\n'
                'www.appixia.co.zw',
                style: TextStyle(
                  color: GlassmorphismTheme.primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Terms of Service',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last updated: ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
                style: TextStyle(
                  color: GlassmorphismTheme.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Acceptance of Terms',
                style: TextStyle(
                  color: GlassmorphismTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'By using BizTracker, you agree to these terms of service. '
                'The app is provided "as is" without warranties of any kind.',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              const SizedBox(height: 16),
              const Text(
                'Use of Service:',
                style: TextStyle(
                  color: GlassmorphismTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Use the app for legitimate business purposes\n'
                '• Maintain accurate and up-to-date information\n'
                '• Keep your data secure\n'
                '• Respect intellectual property rights',
                style: TextStyle(color: GlassmorphismTheme.textColor),
              ),
              const SizedBox(height: 16),
              const Text(
                'Developer Information:',
                style: TextStyle(
                  color: GlassmorphismTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'BizTracker is developed by:\n'
                'Appixia Software\n'
                'Praise Masunga\n'
                'support@appixia.co.zw',
                style: TextStyle(
                  color: GlassmorphismTheme.primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLicenses() {
    showLicensePage(
      context: context,
      applicationName: 'BizTracker',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: GlassmorphismTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.business, color: Colors.white, size: 24),
      ),
      applicationLegalese:
          'Developed by Appixia Software\nPraise Masunga\nsupport@appixia.co.zw',
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'Logout',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: const Text(
          'Are you sure you want to sign out? This will clear your business profile and return you to the welcome screen. Your business data (sales, expenses, etc.) will be preserved.',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Show confirmation dialog
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: GlassmorphismTheme.surfaceColor,
          title: const Text(
            'Confirm Logout',
            style: TextStyle(color: GlassmorphismTheme.textColor),
          ),
          content: const Text(
            'Are you sure you want to sign out? This will clear your business profile and return you to the welcome screen. Your business data (sales, expenses, etc.) will be preserved.',
            style: TextStyle(color: GlassmorphismTheme.textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (shouldLogout != true) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Clear only business profile
      await SQLiteDatabaseService().clearBusinessProfile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to welcome screen after logout
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const WelcomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to logout: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
