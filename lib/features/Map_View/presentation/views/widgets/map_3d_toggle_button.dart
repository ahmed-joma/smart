import 'package:flutter/material.dart';

class Map3DToggleButton extends StatelessWidget {
  final bool is3DEnabled;
  final VoidCallback onToggle;

  const Map3DToggleButton({
    super.key,
    required this.is3DEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: is3DEnabled ? const Color(0xFF7F2F3A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          Icons.view_in_ar,
          color: is3DEnabled ? Colors.white : const Color(0xFF7F2F3A),
        ),
        tooltip: is3DEnabled ? 'Disable 3D' : 'Enable 3D',
        onPressed: onToggle,
      ),
    );
  }
}
