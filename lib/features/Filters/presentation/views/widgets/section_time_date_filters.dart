import 'package:flutter/material.dart';

class SectionTimeDateFilters extends StatelessWidget {
  final String selectedTimeFilter;
  final Function(String) onTimeFilterChanged;

  const SectionTimeDateFilters({
    super.key,
    required this.selectedTimeFilter,
    required this.onTimeFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Time & Date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7F2F3A),
            ),
          ),

          const SizedBox(height: 16),

          // Time Filter Buttons with Horizontal Scroll
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildTimeButton('Today', selectedTimeFilter == 'Today'),
                const SizedBox(width: 12),
                _buildTimeButton('Tomorrow', selectedTimeFilter == 'Tomorrow'),
                const SizedBox(width: 12),
                _buildTimeButton(
                  'This week',
                  selectedTimeFilter == 'This week',
                ),
                const SizedBox(width: 12),
                _buildTimeButton(
                  'This month',
                  selectedTimeFilter == 'This month',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Calendar Button
          Container(
            width:
                MediaQuery.of(context).size.width * 0.70, // 85% من عرض الشاشة
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: const Color(0xFF7F2F3A),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Choose from calendar',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: Colors.blue.shade600,
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => onTimeFilterChanged(text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7F2F3A) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF7F2F3A) : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
