import 'package:flutter/material.dart';

class SectionFilterHeader extends StatelessWidget {
  const SectionFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // ← هذا يجعل العناصر تبدأ من اليسار
        children: [
          // Title centered
          const Center(
            child: Text(
              'Filter',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
