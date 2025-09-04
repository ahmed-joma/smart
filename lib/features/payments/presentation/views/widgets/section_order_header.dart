import 'package:flutter/material.dart';

class SectionOrderHeader extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const SectionOrderHeader({super.key, required this.orderData});

  @override
  State<SectionOrderHeader> createState() => _SectionOrderHeaderState();
}

class _SectionOrderHeaderState extends State<SectionOrderHeader>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF7F2F3A).withOpacity(0.1),
                Colors.white,
                const Color(0xFF7F2F3A).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7F2F3A).withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Animated Image Container
              Hero(
                tag: 'order_image_${widget.orderData['title']}',
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF7F2F3A),
                        const Color(0xFF9B4B5A),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7F2F3A).withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: widget.orderData['type'] == 'hotel'
                      ? const Icon(Icons.hotel, color: Colors.white, size: 45)
                      : const Icon(Icons.event, color: Colors.white, size: 45),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with animated text
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1000),
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
                            widget.orderData['title'] ?? 'City Walk event',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // Date with icon
                    _buildInfoRow(
                      Icons.calendar_today,
                      widget.orderData['date'] ?? '14 December, 2025',
                      Colors.grey[600]!,
                    ),
                    const SizedBox(height: 8),
                    // Location with icon
                    _buildInfoRow(
                      Icons.location_on,
                      widget.orderData['location'] ??
                          'Jeddah King Abdulaziz Road',
                      Colors.grey[600]!,
                    ),
                  ],
                ),
              ),
              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF7F2F3A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF7F2F3A).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7F2F3A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Pending',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7F2F3A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
