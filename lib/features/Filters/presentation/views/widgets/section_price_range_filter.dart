import 'package:flutter/material.dart';

class SectionPriceRangeFilter extends StatelessWidget {
  final RangeValues priceRange;
  final Function(RangeValues) onPriceRangeChanged;

  const SectionPriceRangeFilter({
    super.key,
    required this.priceRange,
    required this.onPriceRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header with Price Range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select price range',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7F2F3A),
                ),
              ),
              Text(
                'SR${priceRange.start.round()}-SR${priceRange.end.round()}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Price Histogram (Mock)
          Container(
            height: 40,
            child: Row(
              children: List.generate(10, (index) {
                final height = (index + 1) * 2.0;
                final isInRange =
                    index >= (priceRange.start / 12).round() &&
                    index <= (priceRange.end / 12).round();

                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: isInRange
                          ? Colors.blue.shade400
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    height: height,
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // Price Slider
          RangeSlider(
            values: priceRange,
            min: 0,
            max: 200,
            divisions: 20,
            activeColor: Colors.blue.shade600,
            inactiveColor: Colors.grey.shade300,
            onChanged: onPriceRangeChanged,
            labels: RangeLabels(
              'SR${priceRange.start.round()}',
              'SR${priceRange.end.round()}',
            ),
          ),

          // Price Range Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SR0',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              Text(
                'SR200',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
