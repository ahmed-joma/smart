import 'package:flutter/material.dart';

class SectionScrollListener extends StatefulWidget {
  final Widget child;

  const SectionScrollListener({super.key, required this.child});

  @override
  State<SectionScrollListener> createState() => _SectionScrollListenerState();
}

class _SectionScrollListenerState extends State<SectionScrollListener>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification) {
          _bounceController.forward().then((_) {
            _bounceController.reverse();
          });
        }
        return false;
      },
      child: widget.child,
    );
  }
}
