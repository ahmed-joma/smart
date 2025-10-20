import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/shared.dart';
import 'section_custom_category.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary, // #7F2F3A - خلفية حمراء داكنة
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        children: [
          // Top header: enforce exact centering for the location block
          SizedBox(
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Left menu button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),

                // Centered location
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Current Location',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const Text(
                      'JEDDAH, SA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Search and Filters Section
          Builder(builder: (context) => _buildSearchSection(context)),

          const SizedBox(height: 1),

          // Categories Section (inside red header)
          const SectionCustomCategory(),
        ],
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
      ), // إزالة padding لأننا داخل header
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              height: 50,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.go('/searchView');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Search...',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Filters Button
          GestureDetector(
            onTap: () {
              // Navigate to Events & Hotels page (same as search)
              context.go('/searchView');
            },
            child: Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                color: AppColors.filters,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tune, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
