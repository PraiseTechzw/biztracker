import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/glassmorphism_theme.dart';
import '../services/ad_service.dart';
import 'dashboard_screen.dart';
import 'capital_screen.dart';
import 'stock_screen.dart';
import 'sales_screen.dart';
import 'reports_screen.dart';
import 'achievements_screen.dart';
import 'profile_screen.dart';
import 'ad_debug_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CapitalScreen(),
    const StockScreen(),
    const SalesScreen(),
    const ReportsScreen(),
    const AchievementsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _screens[_currentIndex]),
          // Banner ad at the bottom
          AdService.instance.createBannerAd(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdDebugScreen()),
        );
      },
      backgroundColor: GlassmorphismTheme.primaryColor,
      foregroundColor: Colors.white,
      tooltip: 'Ad Debug',
      child: const Icon(Icons.bug_report),
    );
  }

  // build the bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            GlassmorphismTheme.surfaceColor.withOpacity(0.9),
            GlassmorphismTheme.backgroundColor.withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: GlassmorphismTheme.primaryColor,
            unselectedItemColor: GlassmorphismTheme.textSecondaryColor,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance),
                label: 'Capital',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory),
                label: 'Stock',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.point_of_sale),
                label: 'Sales',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics),
                label: 'Reports',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.workspace_premium),
                label: 'Achievements',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
