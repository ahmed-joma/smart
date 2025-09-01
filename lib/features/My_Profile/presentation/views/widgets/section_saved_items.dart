import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import '../../manager/saved_items_cubit.dart';
import '../../../data/models/saved_item_model.dart';

class SectionSavedItems extends StatefulWidget {
  const SectionSavedItems({super.key});

  @override
  State<SectionSavedItems> createState() => _SectionSavedItemsState();
}

class _SectionSavedItemsState extends State<SectionSavedItems>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });

    // Load saved items when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedItemsCubit>().loadSavedEvents();
      context.read<SavedItemsCubit>().loadSavedHotels();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavedItemsCubit, SavedItemsState>(
      listener: (context, state) {
        if (state is SaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is RemoveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is SavedItemsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Text(
              'Saved Items',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),

            const SizedBox(height: 20),

            // Tab Bar
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  letterSpacing: 0.5,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  letterSpacing: 0.5,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event,
                          size: 18,
                          color: _selectedTabIndex == 0
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        const Text('Events'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hotel,
                          size: 18,
                          color: _selectedTabIndex == 1
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        const Text('Hotels'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tab Bar View
            SizedBox(
              height: _selectedTabIndex == 0 ? 400 : 350,
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
      ),
    );
  }

  Widget _buildEventsList() {
    return BlocBuilder<SavedItemsCubit, SavedItemsState>(
      builder: (context, state) {
        if (state is SavedItemsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SavedEventsLoaded) {
          if (state.events.isEmpty) {
            return _buildEmptyState(
              'No saved events',
              'assets/images/events.svg',
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.events.length,
            itemBuilder: (context, index) {
              final event = state.events[index];
              return _buildEventCard(event);
            },
          );
        } else if (state is SavedItemsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return _buildEmptyState('No saved events', 'assets/images/events.svg');
      },
    );
  }

  Widget _buildHotelsList() {
    return BlocBuilder<SavedItemsCubit, SavedItemsState>(
      builder: (context, state) {
        if (state is SavedItemsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SavedHotelsLoaded) {
          if (state.hotels.isEmpty) {
            return _buildEmptyState(
              'No saved hotels',
              'assets/images/hotel.svg',
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.hotels.length,
            itemBuilder: (context, index) {
              final hotel = state.hotels[index];
              return _buildHotelCard(hotel);
            },
          );
        } else if (state is SavedItemsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return _buildEmptyState('No saved hotels', 'assets/images/hotel.svg');
      },
    );
  }

  Widget _buildEventCard(SavedEventModel event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to event details
            context.push('/eventDetailsView', extra: event.toJson());
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
                    child: SvgPicture.asset(
                      event.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.event,
                            color: AppColors.primary,
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Event Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
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
                              event.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontFamily: 'Inter',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              event.category,
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          Text(
                            event.price,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Remove Button
                IconButton(
                  onPressed: () {
                    _removeSavedEvent(event.id);
                  },
                  icon: Icon(
                    Icons.bookmark_remove,
                    color: Colors.red.shade400,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHotelCard(SavedHotelModel hotel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to hotel details
            context.push('/hotelDetailsView', extra: hotel.toJson());
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
                    child: SvgPicture.asset(
                      hotel.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.hotel,
                            color: AppColors.primary,
                            size: 30,
                          ),
                        );
                      },
                    ),
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
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
                              hotel.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontFamily: 'Inter',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            hotel.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            hotel.price,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        children: hotel.amenities.map<Widget>((amenity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              amenity,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade700,
                                fontFamily: 'Inter',
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // Remove Button
                IconButton(
                  onPressed: () {
                    _removeSavedHotel(hotel.id);
                  },
                  icon: Icon(
                    Icons.bookmark_remove,
                    color: Colors.red.shade400,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, String imagePath) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imagePath,
            width: 80,
            height: 80,
            colorFilter: ColorFilter.mode(
              Colors.grey.shade400,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Click the save button on any event or hotel to save it here',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _removeSavedEvent(String eventId) {
    context.read<SavedItemsCubit>().removeSavedEvent(eventId);
  }

  void _removeSavedHotel(String hotelId) {
    context.read<SavedItemsCubit>().removeSavedHotel(hotelId);
  }
}
