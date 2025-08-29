import 'package:flutter/material.dart';
import 'widgets/Filter_body.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: const FilterBody()),
    );
  }
}
