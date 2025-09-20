import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'section_filter_header.dart';
import 'section_category_filters.dart';
import 'section_time_date_filters.dart';
import 'section_location_filter.dart';
import 'section_price_range_filter.dart';
import 'section_action_buttons.dart';
import '../../../../../core/utils/cubits/filter_cubit.dart';
import '../../../../../core/utils/cubits/filter_state.dart';
import '../../../../../core/utils/models/filter_models.dart';

class FilterBody extends StatefulWidget {
  final ScrollController? scrollController;

  const FilterBody({super.key, this.scrollController});

  @override
  State<FilterBody> createState() => _FilterBodyState();
}

class _FilterBodyState extends State<FilterBody> {
  // Selected categories (now using tag IDs from API)
  final Set<int> _selectedTagIds = {};

  // Selected time filter
  String _selectedTimeFilter = 'This month';

  // Selected location (now using city ID from API)
  int? _selectedCityId;

  // Price range
  RangeValues _priceRange = const RangeValues(20, 120);

  // Search query
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load filter details when the filter opens
    // We'll call this in the build method instead
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        print('🎛️ FilterBody: Current state: ${state.runtimeType}');

        // Load filter details only if we're in initial state
        if (state is FilterInitial) {
          print('🎛️ FilterBody: Initial state - calling getFilterDetails...');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<FilterCubit>().getFilterDetails();
          });
        }

        // If we're in results state and this FilterBody is in a bottom sheet,
        // we need to get filter details for editing
        if (state is FilterResultsSuccess || state is FilterResultsError) {
          // Only call getFilterDetails when the bottom sheet opens for editing
          // We'll handle this differently - store the filter details in the success state
        }

        if (state is FilterDetailsLoading || state is FilterInitial) {
          print('🔄 FilterBody: Loading filter details...');
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FilterDetailsError) {
          print('❌ FilterBody: Error state: ${state.message}');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to load filter options',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Use API data if available, otherwise show loading or use fallback
        List<Tag> availableTags = [];
        List<City> availableCities = [];

        if (state is FilterDetailsSuccess) {
          print(
            '✅ FilterBody: Success! Cities: ${state.data.cities.length}, Tags: ${state.data.tags.length}',
          );
          availableTags = state.data.tags;
          availableCities = state.data.cities;
        } else if (state is FilterResultsSuccess &&
            state.filterDetails != null) {
          print(
            '✅ FilterBody: Using cached filter details from FilterResultsSuccess',
          );
          availableTags = state.filterDetails!.tags;
          availableCities = state.filterDetails!.cities;
        }

        // If no filter details available, show loading
        if (availableTags.isEmpty && availableCities.isEmpty) {
          print(
            '⏳ FilterBody: No filter details available, showing loading...',
          );
          return const Center(child: CircularProgressIndicator());
        }

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

                    // Category Filters (now using API tags)
                    SectionCategoryFilters(
                      selectedCategories: _selectedTagIds.map((id) {
                        final tag = availableTags.firstWhere(
                          (tag) => tag.id == id,
                          orElse: () => Tag(id: id, name: 'Tag $id'),
                        );
                        return tag.name;
                      }).toSet(),
                      availableTags: availableTags,
                      onCategoryChanged: (tagName, isSelected) {
                        final tag = availableTags.firstWhere(
                          (tag) => tag.name == tagName,
                          orElse: () => Tag(id: 0, name: tagName),
                        );
                        setState(() {
                          if (isSelected) {
                            _selectedTagIds.add(tag.id);
                          } else {
                            _selectedTagIds.remove(tag.id);
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

                    // Location Filter (now using API cities)
                    SectionLocationFilter(
                      selectedLocation: _selectedCityId != null
                          ? availableCities
                                .firstWhere(
                                  (city) => city.id == _selectedCityId,
                                  orElse: () => City(
                                    id: _selectedCityId!,
                                    name: 'City $_selectedCityId',
                                    imageUrl: '',
                                  ),
                                )
                                .name
                          : 'Select City',
                      availableCities: availableCities,
                      onLocationChanged: (cityName) {
                        final city = availableCities.firstWhere(
                          (city) => city.name == cityName,
                          orElse: () =>
                              City(id: 0, name: cityName, imageUrl: ''),
                        );
                        setState(() {
                          _selectedCityId = city.id != 0 ? city.id : null;
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
                  _selectedTagIds.clear();
                  _selectedTimeFilter = 'This month';
                  _selectedCityId = null;
                  _priceRange = const RangeValues(20, 120);
                  _searchQuery = '';
                });
              },
              onApply: () async {
                // Create filter request with selected options
                final filterRequest = FilterRequest(
                  q: _searchQuery.isNotEmpty ? _searchQuery : null,
                  tags: _selectedTagIds.isNotEmpty
                      ? _selectedTagIds.toList()
                      : null,
                  cityId: _selectedCityId,
                  priceMin: _priceRange.start != 20 ? _priceRange.start : null,
                  priceMax: _priceRange.end != 120 ? _priceRange.end : null,
                );

                // Apply filters and wait for completion
                print(
                  '🎯 FilterBody: Applying filters with request: ${filterRequest.toJson()}',
                );
                await context.read<FilterCubit>().applyFilters(filterRequest);
                print('✅ FilterBody: Apply filters completed');

                // Close filter bottom sheet only if the context is still mounted
                if (context.mounted) {
                  Navigator.of(context).pop();
                  // No need to navigate - the SearchView will automatically show results
                  // because we're using the same FilterCubit singleton
                }
              },
            ),
          ],
        );
      },
    );
  }
}
