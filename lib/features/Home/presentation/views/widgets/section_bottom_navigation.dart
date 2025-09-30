import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/shared.dart';

class SectionBottomNavigation extends StatefulWidget {
  const SectionBottomNavigation({super.key});

  @override
  State<SectionBottomNavigation> createState() =>
      _SectionBottomNavigationState();
}

class _SectionBottomNavigationState extends State<SectionBottomNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            // Navigate to Orders page
            context.go('/eventsView');
          } else if (index == 2) {
            // Navigate to Home page
            context.go('/homeView');
          } else if (index == 3) {
            // Navigate to Map page
            context.go('/mapView');
          } else if (index == 4) {
            // Navigate to Profile page
            context.go('/myProfileView');
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        iconSize: 22,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF7F2F3A),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.home, color: Colors.white, size: 30),
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
