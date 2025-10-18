import 'package:flutter/material.dart';

class SectionCustomCategory extends StatelessWidget {
  const SectionCustomCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Hotel',
        'icon': Icons.hotel,
        'color': const Color(0xFF4A90E2), // أزرق حديث
        'gradient': const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'name': 'Events',
        'icon': Icons.event,
        'color': const Color(0xFFE74C3C), // أحمر حديث
        'gradient': const LinearGradient(
          colors: [Color(0xFFE74C3C), Color(0xFFC0392B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
    ];

    return Transform.translate(
      offset: const Offset(0, 42),
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          children: categories.map((category) {
            final index = categories.indexOf(category);
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < categories.length - 1 ? 12 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    // No navigation - buttons are just for display
                  },
                  child: _buildModernCategoryChip(
                    category['name'] as String,
                    category['icon'] as IconData,
                    category['gradient'] as LinearGradient,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String title, IconData icon, Color color) {
    return Container(
      constraints: const BoxConstraints(minWidth: 80, maxWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCategoryChip(
    String title,
    IconData icon,
    LinearGradient gradient,
  ) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
