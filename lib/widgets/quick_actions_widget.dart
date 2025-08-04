import 'package:flutter/material.dart';
import '../utils/glassmorphism_theme.dart';

class QuickAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class QuickActionsWidget extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionsWidget({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              color: GlassmorphismTheme.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _buildActionCard(action);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              action.color.withOpacity(0.2),
              action.color.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: action.color.withOpacity(0.3), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(action.icon, color: action.color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                action.title,
                style: const TextStyle(
                  color: GlassmorphismTheme.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                action.subtitle,
                style: const TextStyle(
                  color: GlassmorphismTheme.textSecondaryColor,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Predefined quick actions for common business tasks
class BusinessQuickActions {
  static List<QuickAction> getDefaultActions({
    required VoidCallback onAddCapital,
    required VoidCallback onAddStock,
    required VoidCallback onRecordSale,
    required VoidCallback onAddExpense,
    required VoidCallback onGenerateReport,
    required VoidCallback onViewAnalytics,
  }) {
    return [
      QuickAction(
        title: 'Add Capital',
        subtitle: 'Record new investment',
        icon: Icons.add_circle,
        color: GlassmorphismTheme.primaryColor,
        onTap: onAddCapital,
      ),
      QuickAction(
        title: 'Add Stock',
        subtitle: 'Add inventory item',
        icon: Icons.inventory_2,
        color: GlassmorphismTheme.secondaryColor,
        onTap: onAddStock,
      ),
      QuickAction(
        title: 'Record Sale',
        subtitle: 'Log a sale transaction',
        icon: Icons.point_of_sale,
        color: GlassmorphismTheme.accentColor,
        onTap: onRecordSale,
      ),
      QuickAction(
        title: 'Add Expense',
        subtitle: 'Track business cost',
        icon: Icons.receipt_long,
        color: Colors.orange,
        onTap: onAddExpense,
      ),
      QuickAction(
        title: 'Generate Report',
        subtitle: 'Create profit analysis',
        icon: Icons.analytics,
        color: Colors.green,
        onTap: onGenerateReport,
      ),
      QuickAction(
        title: 'View Analytics',
        subtitle: 'Business insights',
        icon: Icons.trending_up,
        color: Colors.purple,
        onTap: onViewAnalytics,
      ),
    ];
  }
}
