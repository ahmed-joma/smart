import 'package:flutter/material.dart';
import 'section_filter_header.dart';
import 'section_category_filters.dart';
import 'section_time_date_filters.dart';
import 'section_location_filter.dart';
import 'section_price_range_filter.dart';
import 'section_action_buttons.dart';

class FilterBody extends StatefulWidget {
  final ScrollController? scrollController;

  const FilterBody({super.key, this.scrollController});

  @override
  State<FilterBody> createState() => _FilterBodyState();
}

class _FilterBodyState extends State<FilterBody> {
  // Selected categories
  final Set<String> _selectedCategories = {'Sports', 'Art'};

  // Selected time filter
  String _selectedTimeFilter = 'This month';

  // Selected location
  String _selectedLocation = 'Jeddah, SA';

  // Price range
  RangeValues _priceRange = const RangeValues(20, 120);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            child: Column(
              children: [
                // Header with drag handle
                const SectionFilterHeader(),

                // Category Filters
                SectionCategoryFilters(
                  selectedCategories: _selectedCategories,
                  onCategoryChanged: (category, isSelected) {
                    setState(() {
                      if (isSelected) {
                        _selectedCategories.add(category);
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                  },
                ),

                const SizedBox(height: 32),

                // Time & Date Filters
                SectionTimeDateFilters(
                  selectedTimeFilter: _selectedTimeFilter,
                  onTimeFilterChanged: (filter) {
                    setState(() {
                      _selectedTimeFilter = filter;
                    });
                  },
                ),

                const SizedBox(height: 32),

                // Location Filter
                SectionLocationFilter(
                  selectedLocation: _selectedLocation,
                  onLocationChanged: (location) {
                    setState(() {
                      _selectedLocation = location;
                    });
                  },
                ),

                const SizedBox(height: 32),

                // Price Range Filter
                SectionPriceRangeFilter(
                  priceRange: _priceRange,
                  onPriceRangeChanged: (range) {
                    setState(() {
                      _priceRange = range;
                    });
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),

        // Fixed Action Buttons at Bottom
        SectionActionButtons(
          onReset: () {
            setState(() {
              _selectedCategories.clear();
              _selectedTimeFilter = 'This month';
              _selectedLocation = 'Jeddah, SA';
              _priceRange = const RangeValues(20, 120);
            });
          },
          onApply: () {
            // Handle apply filters
            Navigator.of(context).pop({
              'categories': _selectedCategories.toList(),
              'timeFilter': _selectedTimeFilter,
              'location': _selectedLocation,
              'priceRange': _priceRange,
            });
          },
        ),
      ],
    );
  }
}
