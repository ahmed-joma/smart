import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/models/filter_models.dart';
import '../../../../../core/utils/cubits/favorite_cubit.dart';
import '../../../../../core/utils/cubits/favorite_state.dart';
import '../../../../../core/utils/cubits/filter_cubit.dart';
import '../../../../../shared/shared.dart';
import '../../../../../shared/widgets/interactive_bookmark.dart';

class SectionFilterResults extends StatefulWidget {
  final FilterResult results;
  final FilterRequest appliedFilters;

  const SectionFilterResults({
    super.key,
    required this.results,
    required this.appliedFilters,
  });

  @override
  State<SectionFilterResults> createState() => _SectionFilterResultsState();
}

class _SectionFilterResultsState extends State<SectionFilterResults>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // Local state for favorites
  final Map<int, bool> _savedEvents = {};
  final Map<int, bool> _savedHotels = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });

    // Initialize saved state from results
    for (var event in widget.results.events) {
      _savedEvents[event.id] = event.isFavorite;
    }
    for (var hotel in widget.results.hotels) {
      _savedHotels[hotel.id] = hotel.isFavorite;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final totalResults =
        widget.results.events.length + widget.results.hotels.length;

    return BlocListener<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteSuccess) {
          setState(() {
            if (state.favoriteType == 'event') {
              _savedEvents[state.favoriteId] = state.isFavorite;
            } else if (state.favoriteType == 'hotel') {
              _savedHotels[state.favoriteId] = state.isFavorite;
            }
          });
        }
      },
      child: Column(
        children: [
          // Results Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Results Summary
                Row(
                  children: [
                    Icon(Icons.search, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Found $totalResults results',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // Show clearing message with animation
                        _showClearingMessage(context);

                        // Clear filters after a short delay
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          context.read<FilterCubit>().clearFilters();
                        });
                      },
                      child: Text(
                        'Clear Filters',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Tab Bar
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey.shade600,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event,
                              size: 16,
                              color: _selectedTabIndex == 0
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text('Events (${widget.results.events.length})'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hotel,
                              size: 16,
                              color: _selectedTabIndex == 1
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text('Hotels (${widget.results.hotels.length})'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Events Tab
                _buildEventsList(),
                // Hotels Tab
                _buildHotelsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    if (widget.results.events.isEmpty) {
      return _buildEmptyState('No Events Found', Icons.event);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: widget.results.events.length,
      itemBuilder: (context, index) {
        final event = widget.results.events[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildHotelsList() {
    if (widget.results.hotels.isEmpty) {
      return _buildEmptyState('No Hotels Found', Icons.hotel);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: widget.results.hotels.length,
      itemBuilder: (context, index) {
        final hotel = widget.results.hotels[index];
        return _buildHotelCard(hotel);
      },
    );
  }

  Widget _buildEventCard(FilterEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            final eventData = {
              'id': event.id,
              'title': event.title ?? 'Event',
              'city': event.cityName,
              'venue': event.venue,
              'start_at': event.formattedStartAt,
              'price': event.price ?? '0',
              'image_url': event.imageUrl,
              'event_status': event.eventStatus ?? 'Upcoming',
            };
            context.push('/eventDetailsView', extra: eventData);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Event Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: event.imageUrl.isNotEmpty
                        ? Image.network(
                            event.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.event,
                                color: AppColors.primary,
                                size: 30,
                              );
                            },
                          )
                        : Icon(Icons.event, color: AppColors.primary, size: 30),
                  ),
                ),

                const SizedBox(width: 16),

                // Event Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title ?? 'Event Title',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${event.cityName}, ${event.venue}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.formattedStartAt,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const Spacer(),
                          if (event.price != null)
                            Text(
                              'SR ${event.price}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Favorite Button
                InteractiveBookmark(
                  isSaved: _savedEvents[event.id] ?? event.isFavorite,
                  size: 32,
                  onPressed: () {
                    setState(() {
                      _savedEvents[event.id] =
                          !(_savedEvents[event.id] ?? event.isFavorite);
                    });
                    context.read<FavoriteCubit>().toggleEventFavorite(event.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHotelCard(FilterHotel hotel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            final hotelData = {
              'id': hotel.id,
              'title': hotel.name,
              'city': hotel.city,
              'venue': hotel.venue,
              'price_per_night': hotel.pricePerNight,
              'rate': hotel.rate,
              'cover_url': hotel.coverUrl,
            };
            context.push('/hotelDetailsView', extra: hotelData);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Hotel Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: hotel.coverUrl.isNotEmpty
                        ? Image.network(
                            hotel.coverUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.hotel,
                                color: AppColors.primary,
                                size: 30,
                              );
                            },
                          )
                        : Icon(Icons.hotel, color: AppColors.primary, size: 30),
                  ),
                ),

                const SizedBox(width: 16),

                // Hotel Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotel.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${hotel.city}, ${hotel.venue}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // Rating
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < hotel.rate
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 14,
                                color: Colors.amber,
                              );
                            }),
                          ),
                          const Spacer(),
                          Text(
                            'SR ${hotel.pricePerNight}/night',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Favorite Button
                InteractiveBookmark(
                  isSaved: _savedHotels[hotel.id] ?? hotel.isFavorite,
                  size: 32,
                  onPressed: () {
                    setState(() {
                      _savedHotels[hotel.id] =
                          !(_savedHotels[hotel.id] ?? hotel.isFavorite);
                    });
                    context.read<FavoriteCubit>().toggleHotelFavorite(hotel.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
