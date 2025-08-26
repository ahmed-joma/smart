import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/widgets/custom_text_field.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name Field
          Text(
            'Full Name',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            height: 60,
            width: double.infinity,
            hintText: 'Enter your full name',
            controller: nameController,
            borderColor: const Color(0xFFE4DFDF),
          ),

          const SizedBox(height: 24),

          // About Me Field
          Text(
            'About Me',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4DFDF), width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: aboutMeController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Tell us about yourself...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
