import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SectionCustomCategory extends StatelessWidget {
  const SectionCustomCategory({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current route to determine active button
    final currentRoute = GoRouterState.of(context).uri.path;
    final isEventsActive = currentRoute == '/homeView';
    final isHotelsActive = currentRoute == '/hotelHomeView';

    final categories = [
      {
        'name': 'Hotel',
        'icon': Icons.hotel,
        'isActive': isHotelsActive,
        'activeGradient': const LinearGradient(
          // قريب من لون الهيدر لكن ليس مطابقًا له
          colors: [Color(0xFF8A3944), Color(0xFF6B2B33)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'inactiveGradient': const LinearGradient(
          // أفتح قليلًا ليوضح الفرق عند عدم النشاط
          colors: [Color(0xFFA0525B), Color(0xFF7C3A42)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'name': 'Events',
        'icon': Icons.event,
        'isActive': isEventsActive,
        'activeGradient': const LinearGradient(
          colors: [Color(0xFF8A3944), Color(0xFF6B2B33)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'inactiveGradient': const LinearGradient(
          colors: [Color(0xFFA0525B), Color(0xFF7C3A42)],
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
            final isActive = category['isActive'] as bool;

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < categories.length - 1 ? 12 : 0,
                ),
                child: _buildModernCategoryChip(
                  category['name'] as String,
                  category['icon'] as IconData,
                  isActive
                      ? category['activeGradient'] as LinearGradient
                      : category['inactiveGradient'] as LinearGradient,
                  isActive,
                  () {
                    final categoryName = category['name'] as String;
                    print('🔘 Hotel Home Button tapped: $categoryName');
                    if (categoryName == 'Events') {
                      print('🚀 Navigating to /homeView');
                      context.push('/homeView');
                    } else if (categoryName == 'Hotel') {
                      print('🚀 Navigating to /hotelHomeView');
                      context.push('/hotelHomeView');
                    }
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildModernCategoryChip(
    String title,
    IconData icon,
    LinearGradient gradient,
    bool isActive,
    VoidCallback onTap,
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
        border: isActive ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
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
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
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
