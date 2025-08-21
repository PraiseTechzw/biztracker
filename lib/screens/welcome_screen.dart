import 'package:flutter/material.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/sqlite_database_service.dart';
import 'business_profile_screen.dart';
import 'main_navigation_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _floatController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;

  int _currentFeatureIndex = 0;
  bool _hasExistingProfile = false;
  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.analytics,
      'title': 'Smart Analytics',
      'description':
          'Track your business performance with detailed insights and reports',
      'color': GlassmorphismTheme.primaryColor,
    },
    {
      'icon': Icons.inventory,
      'title': 'Inventory Management',
      'description':
          'Keep track of your stock levels and manage your inventory efficiently',
      'color': GlassmorphismTheme.secondaryColor,
    },
    {
      'icon': Icons.trending_up,
      'title': 'Profit Tracking',
      'description':
          'Monitor your revenue, expenses, and profit margins in real-time',
      'color': GlassmorphismTheme.accentColor,
    },
    {
      'icon': Icons.assessment,
      'title': 'Comprehensive Reports',
      'description':
          'Generate detailed reports and insights for better decision making',
      'color': GlassmorphismTheme.primaryColor,
    },
    {
      'icon': Icons.notifications,
      'title': 'Smart Notifications',
      'description':
          'Stay updated with important business alerts and reminders',
      'color': GlassmorphismTheme.secondaryColor,
    },
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _startAnimations();
    _startFeatureRotation();
    _checkExistingProfile();
  }

  Future<void> _checkExistingProfile() async {
    try {
      final hasProfile = await SQLiteDatabaseService()
          .hasCompleteBusinessProfile();
      if (mounted) {
        setState(() {
          _hasExistingProfile = hasProfile;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  String _getAppVersion() {
    return '1.0.0';
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _pulseController.repeat(reverse: true);
    _floatController.repeat(reverse: true);
  }

  void _startFeatureRotation() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _currentFeatureIndex = (_currentFeatureIndex + 1) % _features.length;
        });
        _startFeatureRotation();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _floatController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              GlassmorphismTheme.backgroundColor,
              Color(0xFF1E1B4B),
              Color(0xFF0F172A),
              GlassmorphismTheme.backgroundColor,
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildBackgroundElements(),
              // Make main content scrollable to avoid overflow
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'v${_getAppVersion()}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: GlassmorphismTheme
                                            .textSecondaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Column(
                                  children: [
                                    AnimatedBuilder(
                                      animation: _pulseAnimation,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _pulseAnimation.value,
                                          child: Container(
                                            width: 140,
                                            height: 140,
                                            decoration: BoxDecoration(
                                              gradient: GlassmorphismTheme
                                                  .primaryGradient,
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: GlassmorphismTheme
                                                      .primaryColor
                                                      .withOpacity(0.4),
                                                  blurRadius: 30,
                                                  spreadRadius: 5,
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              child: Image.asset(
                                                'assets/images/logo.png',
                                                width: 90,
                                                height: 90,
                                                fit: BoxFit.contain,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const Icon(
                                                        Icons.business,
                                                        size: 70,
                                                        color: Colors.white,
                                                      );
                                                    },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'BizTracker',
                                      style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                        color: GlassmorphismTheme.textColor,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Your Business, Simplified',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: GlassmorphismTheme
                                            .textSecondaryColor,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: _buildFeatureHighlight(),
                              ),
                              const SizedBox(height: 32),
                              SlideTransition(
                                position: _slideAnimation,
                                child: Column(
                                  children: [
                                    if (_hasExistingProfile) ...[
                                      _buildActionButton(
                                        title: 'Restore Business Profile',
                                        subtitle:
                                            'Continue with your existing business',
                                        icon: Icons.restore,
                                        gradient: GlassmorphismTheme
                                            .secondaryGradient,
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                            PageRouteBuilder(
                                              pageBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                  ) =>
                                                      const MainNavigationScreen(),
                                              transitionsBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child,
                                                  ) {
                                                    return FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    );
                                                  },
                                              transitionDuration:
                                                  const Duration(
                                                    milliseconds: 500,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      _buildActionButton(
                                        title: 'Create New Profile',
                                        subtitle:
                                            'Start fresh with a new business',
                                        icon: Icons.add_business,
                                        gradient:
                                            GlassmorphismTheme.primaryGradient,
                                        onTap: () {
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                  ) =>
                                                      const BusinessProfileScreen(),
                                              transitionsBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child,
                                                  ) {
                                                    return SlideTransition(
                                                      position: Tween<Offset>(
                                                        begin: const Offset(
                                                          1.0,
                                                          0.0,
                                                        ),
                                                        end: Offset.zero,
                                                      ).animate(animation),
                                                      child: child,
                                                    );
                                                  },
                                              transitionDuration:
                                                  const Duration(
                                                    milliseconds: 300,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ] else ...[
                                      _buildActionButton(
                                        title: 'Create Business Profile',
                                        subtitle:
                                            'Set up your business information',
                                        icon: Icons.add_business,
                                        gradient:
                                            GlassmorphismTheme.primaryGradient,
                                        onTap: () {
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                  ) =>
                                                      const BusinessProfileScreen(),
                                              transitionsBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child,
                                                  ) {
                                                    return SlideTransition(
                                                      position: Tween<Offset>(
                                                        begin: const Offset(
                                                          1.0,
                                                          0.0,
                                                        ),
                                                        end: Offset.zero,
                                                      ).animate(animation),
                                                      child: child,
                                                    );
                                                  },
                                              transitionDuration:
                                                  const Duration(
                                                    milliseconds: 300,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Track sales, expenses, and profits with ease',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: GlassmorphismTheme
                                            .textSecondaryColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _buildFeatureDot(
                                          Icons.analytics,
                                          'Analytics',
                                        ),
                                        const SizedBox(width: 20),
                                        _buildFeatureDot(
                                          Icons.inventory,
                                          'Inventory',
                                        ),
                                        const SizedBox(width: 20),
                                        _buildFeatureDot(
                                          Icons.trending_up,
                                          'Reports',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '© ${DateTime.now().year} BizTracker. All rights reserved.',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: GlassmorphismTheme
                                            .textSecondaryColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              // Floating circles
              Positioned(
                top: 100 + (_floatAnimation.value * 20),
                left: 50,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: GlassmorphismTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              Positioned(
                top: 200 + (_floatAnimation.value * -15),
                right: 80,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: GlassmorphismTheme.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Positioned(
                bottom: 150 + (_floatAnimation.value * 25),
                left: 100,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: GlassmorphismTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeatureHighlight() {
    final feature = _features[_currentFeatureIndex];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: GlassmorphismTheme.glassmorphismContainer(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [feature['color'], feature['color'].withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(feature['icon'], color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: GlassmorphismTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature['description'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: GlassmorphismTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isLoading
                          ? GlassmorphismTheme.textSecondaryColor
                          : GlassmorphismTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: GlassmorphismTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            // Add trailing arrow icon to show button is pressable
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: GlassmorphismTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureDot(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: GlassmorphismTheme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: GlassmorphismTheme.primaryColor, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: GlassmorphismTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}
