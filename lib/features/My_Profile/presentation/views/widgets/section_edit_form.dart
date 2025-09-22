import 'package:flutter/material.dart';

class SectionEditForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController aboutMeController;

  const SectionEditForm({
    super.key,
    required this.nameController,
    required this.aboutMeController,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - opacity)),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Header
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B7AED).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.person_outline,
                            color: Color(0xFF6B7AED),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            color: Color(0xFF1D1E25),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Name Field with Modern Design
                    _buildModernTextField(
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      hintText: 'Enter your full name',
                      controller: nameController,
                      isMultiline: false,
                    ),

                    const SizedBox(height: 16),

                    // About Me Field with Modern Design
                    _buildModernTextField(
                      label: 'About Me',
                      icon: Icons.description_outlined,
                      hintText: 'Tell us about yourself...',
                      controller: aboutMeController,
                      isMultiline: true,
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernTextField({
    required String label,
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
    required bool isMultiline,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with Icon
        Row(
          children: [
            Icon(icon, color: const Color(0xFF6B7AED), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1D1E25),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Text Field
        Container(
          height: isMultiline ? 80 : 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: isMultiline ? 5 : 1,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF1D1E25),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}
