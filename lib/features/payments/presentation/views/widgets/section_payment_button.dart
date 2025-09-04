import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SectionPaymentButton extends StatefulWidget {
  final String totalPrice;
  final VoidCallback onPressed;

  const SectionPaymentButton({
    super.key,
    required this.totalPrice,
    required this.onPressed,
  });

  @override
  State<SectionPaymentButton> createState() => _SectionPaymentButtonState();
}

class _SectionPaymentButtonState extends State<SectionPaymentButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 19),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Total price section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        const Color(0xFF7F2F3A),
                        const Color(0xFF9B4B5A),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      widget.totalPrice,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(width: 16), // بدل Spacer
          // Payment button (take remaining space)
          Expanded(
            child: AnimatedBuilder(
              animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF7F2F3A), Color(0xFF9B4B5A)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7F2F3A).withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTapDown: (_) {
                          setState(() => _isPressed = true);
                          _scaleController.forward();
                          HapticFeedback.lightImpact();
                        },
                        onTapUp: (_) {
                          setState(() => _isPressed = false);
                          _scaleController.reverse();
                          widget.onPressed();
                          HapticFeedback.mediumImpact();
                        },
                        onTapCancel: () {
                          setState(() => _isPressed = false);
                          _scaleController.reverse();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.payment,
                              color: Colors.white,
                              size: _isPressed ? 22 : 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Make Payment',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
