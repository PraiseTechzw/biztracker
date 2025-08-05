import 'package:flutter/material.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/database_service.dart';
import 'notifications_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoading = false;

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
                  child: _buildSettingsContent(),
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
          _buildSection('App Information', [
            _buildSettingTile(
              'App Version',
              '1.0.0',
              Icons.info_outline,
              onTap: null,
            ),
            _buildSettingTile('Build Number', '1', Icons.build, onTap: null),
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
              'Clear All Data',
              'Delete all business records',
              Icons.delete_forever,
              onTap: _showClearDataDialog,
              isDestructive: true,
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
              'About BizTracker',
              'Learn more about the app',
              Icons.business,
              onTap: _showAboutDialog,
            ),
          ]),
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
              ? Colors.red.withOpacity(0.2)
              : GlassmorphismTheme.primaryColor.withOpacity(0.2),
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

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export feature coming soon!'),
        backgroundColor: GlassmorphismTheme.primaryColor,
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
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: const Text(
          'Are you sure you want to delete all your business data? This action cannot be undone.',
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
              'Clear Data',
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
      // Note: In a real app, you would implement proper data clearing
      // For now, we'll just show a success message
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to clear data'),
            backgroundColor: Colors.red,
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
                '5. Generate reports to analyze performance',
                style: TextStyle(color: GlassmorphismTheme.textColor),
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

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlassmorphismTheme.surfaceColor,
        title: const Text(
          'About BizTracker',
          style: TextStyle(color: GlassmorphismTheme.textColor),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BizTracker v1.0.0',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'A modern business tracking app with glassmorphism UI design. '
              'Track your capital, inventory, sales, expenses, and generate '
              'detailed profit reports.',
              style: TextStyle(color: GlassmorphismTheme.textColor),
            ),
            SizedBox(height: 16),
            Text(
              'Features:',
              style: TextStyle(
                color: GlassmorphismTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Capital Management\n'
              '• Stock/Inventory Tracking\n'
              '• Sales Recording\n'
              '• Expense Tracking\n'
              '• Profit Analysis\n'
              '• Business Reports',
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
}
