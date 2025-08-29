import 'package:flutter/material.dart';

class SectionActionButtons extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onApply;

  const SectionActionButtons({
    super.key,
    required this.onReset,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Reset Button
          Expanded(
            child: GestureDetector(
              onTap: onReset,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'RESET',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F2F3A),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Apply Button
          Expanded(
            child: GestureDetector(
              onTap: onApply,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF7F2F3A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'APPLY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
