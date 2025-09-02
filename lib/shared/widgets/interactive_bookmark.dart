import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InteractiveBookmark extends StatefulWidget {
  final bool isSaved;
  final VoidCallback onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const InteractiveBookmark({
    Key? key,
    required this.isSaved,
    required this.onPressed,
    this.size = 20,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  State<InteractiveBookmark> createState() => _InteractiveBookmarkState();
}

class _InteractiveBookmarkState extends State<InteractiveBookmark> {
  @override
  void didUpdateWidget(InteractiveBookmark oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSaved != oldWidget.isSaved) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onPressed();
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: widget.isSaved
                  ? const Color(0xFFEB5757).withOpacity(0.4)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 2,
              spreadRadius: 0,
              offset: const Offset(0, -1),
            ),
          ],
          border: Border.all(
            color: widget.isSaved
                ? const Color(0xFFEB5757).withOpacity(0.8)
                : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          widget.isSaved ? Icons.bookmark : Icons.bookmark_border,
          color: const Color(0xFFEB5757),
          size: widget.size * 0.6,
        ),
      ),
    );
  }
}
