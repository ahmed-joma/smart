import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/widgets/custom_text_field.dart';

class SectionEmailField extends StatelessWidget {
  final TextEditingController emailController;

  const SectionEmailField({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email Input Field
        Center(
          child: CustomTextField(
            height: 60,
            width: 350,
            hintText: 'ahlam@email.com',
            prefixIcon: Icon(
              Icons.email_outlined,
              color: const Color(0xFF807A7A),
              size: 25,
            ),
            controller: emailController,
            borderColor: const Color(0xFFE4DFDF),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
