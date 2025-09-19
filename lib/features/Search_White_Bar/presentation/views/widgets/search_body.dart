import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'section_header.dart';
import 'section_search_bar.dart';
import 'section_city_list.dart';
import 'section_filter_results.dart';
import '../../../../../core/utils/cubits/filter_cubit.dart';
import '../../../../../core/utils/cubits/filter_state.dart';

class SearchBody extends StatefulWidget {
  final Map<String, dynamic>? searchData;

  const SearchBody({super.key, this.searchData});

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header Section
          const SectionHeader(),

          // Search Bar Section
          SectionSearchBar(
            searchController: _searchController,
            searchFocusNode: _searchFocusNode,
          ),

          // Content Section - Show filter results if available, otherwise city list
          Expanded(
            child: BlocBuilder<FilterCubit, FilterState>(
              builder: (context, state) {
                if (state is FilterResultsSuccess) {
                  // Show filter results
                  return SectionFilterResults(
                    results: state.results,
                    appliedFilters: state.appliedFilters,
                  );
                } else if (state is FilterResultsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FilterResultsError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Results Found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Default - show city list
                  return const SectionCityList();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
