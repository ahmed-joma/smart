import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'section_header.dart';
import 'section_search_bar.dart';
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

  void _showClearingMessage(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated check icon
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.cleaning_services,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Filters Cleared Successfully',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Returning to main page...',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );

    // Auto dismiss after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  Widget _buildWelcomeState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated welcome icon
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 1200),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.1),
                          Colors.purple.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.explore,
                      size: 60,
                      color: Colors.blue.shade400,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              'Discover Amazing Events & Hotels',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Use the filter button to find events and hotels\nthat match your preferences',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Animated arrow pointing to filter button
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 2000),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.blue.shade300,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tap the filter button above',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
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
                print(
                  '🔍 SearchBody: Current FilterState: ${state.runtimeType}',
                );
                if (state is FilterResultsSuccess) {
                  print(
                    '✅ SearchBody: Showing FilterResultsSuccess with ${state.results.events.length} events and ${state.results.hotels.length} hotels',
                  );
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
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              // Show clearing message with animation
                              _showClearingMessage(context);

                              // Clear filters after a short delay
                              Future.delayed(
                                const Duration(milliseconds: 1500),
                                () {
                                  context.read<FilterCubit>().clearFilters();
                                },
                              );
                            },
                            child: const Text('Clear Filters'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Default - show beautiful empty state
                  return _buildWelcomeState();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
