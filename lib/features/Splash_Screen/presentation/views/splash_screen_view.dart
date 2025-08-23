import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/shared.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _bounceController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Scale animation - starts small and grows with elastic effect
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    // Fade animation - starts transparent and becomes visible
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Bounce animation - subtle bouncing effect
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start scale animation
    await _scaleController.forward();

    // Start fade animation
    await _fadeController.forward();

    // Start bounce animation
    await _bounceController.forward();

    // Wait a bit then navigate
    await Future.delayed(const Duration(milliseconds: 800));

    // Navigate to Sign In screen
    if (mounted) {
      context.go('/signInView');
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF5F5), Colors.white, Color(0xFFF8F5FF)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _scaleController,
              _fadeController,
              _bounceController,
            ]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.translate(
                  offset: Offset(
                    0,
                    _bounceAnimation.value * 10 * (1 - _bounceAnimation.value),
                  ),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: SizedBox(
                      width: 230.91,
                      height: 126,
                      child: SvgPicture.asset(
                        'assets/images/splash.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
