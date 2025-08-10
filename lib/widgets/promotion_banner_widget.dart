import 'package:flutter/material.dart';
import '../utils/glassmorphism_theme.dart';
import '../services/payment_service.dart';

class PromotionBannerWidget extends StatefulWidget {
  final VoidCallback? onTap;
  final bool showCloseButton;

  const PromotionBannerWidget({
    super.key,
    this.onTap,
    this.showCloseButton = true,
  });

  @override
  State<PromotionBannerWidget> createState() => _PromotionBannerWidgetState();
}

class _PromotionBannerWidgetState extends State<PromotionBannerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  Map<String, dynamic>? _promotionData;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _loadPromotionData();
    _animationController.forward();
  }

  Future<void> _loadPromotionData() async {
    try {
      final data = PaymentService.instance.getPromotionBanner();
      setState(() {
        _promotionData = data;
      });
    } catch (e) {
      debugPrint('PromotionBanner: Failed to load promotion data - $e');
    }
  }

  void _closeBanner() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible || _promotionData == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GlassmorphismTheme.glassmorphismContainer(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    // Main content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(
                                  _promotionData!['backgroundColor'],
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _promotionData!['discount'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(
                                    _promotionData!['backgroundColor'],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _promotionData!['title'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(
                                        _promotionData!['textColor'],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _promotionData!['subtitle'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(
                                        _promotionData!['textColor'],
                                      ).withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Price comparison
                        Row(
                          children: [
                            Text(
                              '\$${_promotionData!['originalPrice'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                                color: Color(
                                  _promotionData!['textColor'],
                                ).withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '\$${_promotionData!['discountedPrice'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(
                                  _promotionData!['backgroundColor'],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(
                                  _promotionData!['backgroundColor'],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(_promotionData!['textColor']),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        Text(
                          _promotionData!['validUntil'],
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Color(
                              _promotionData!['textColor'],
                            ).withOpacity(0.7),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Action button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                widget.onTap ??
                                () {
                                  // Default action - navigate to premium screen
                                  Navigator.pushNamed(context, '/premium');
                                },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(
                                _promotionData!['backgroundColor'],
                              ),
                              foregroundColor: Color(
                                _promotionData!['textColor'],
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.flash_on, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Get Offer Now!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Close button
                    if (widget.showCloseButton)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: _closeBanner,
                          icon: Icon(
                            Icons.close,
                            color: Color(
                              _promotionData!['textColor'],
                            ).withOpacity(0.7),
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
