import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import '../../manager/Home/home_cubit.dart';
// home_state is part of home_cubit.dart
import '../../../../../core/utils/cubits/favorite_cubit.dart';
import '../../../../../core/utils/cubits/favorite_state.dart';
import '../../../../../shared/widgets/interactive_bookmark.dart';

class OngoingEventsBody extends StatefulWidget {
  const OngoingEventsBody({super.key});

  @override
  State<OngoingEventsBody> createState() => _OngoingEventsBodyState();
}

class _OngoingEventsBodyState extends State<OngoingEventsBody> {
  Map<int, bool> _savedEvents = {};

  @override
  void initState() {
    super.initState();
    // Initialize saved events from HomeCubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeState = context.read<HomeCubit>().state;
      if (homeState is HomeSuccess) {
        for (var event in homeState.homeData.events.ongoing) {
          _savedEvents[event.id] = event.isFavorite;
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteSuccess) {
          // Update local state when favorite changes
          setState(() {
            _savedEvents[state.favoriteId] = state.isFavorite;
          });
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load events',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is HomeSuccess) {
            final events = state.homeData.events.ongoing;

            if (events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Ongoing Events',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back later for ongoing events',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final isSaved = _savedEvents[event.id] ?? false;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        print(
                          '🚀 Navigation: Tapped ongoing event with ID: ${event.id}',
                        );
                        final navigationData = {
                          'eventId': event.id,
                          'eventData': event.toJson(),
                        };
                        print('📦 Navigation data: $navigationData');
                        context.push(
                          '/eventDetailsView',
                          extra: navigationData,
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event Image
                          Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary.withOpacity(0.1),
                                  const Color(0xFF6B7AED).withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: event.imageUrl.isNotEmpty
                                ? Image.network(
                                    event.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildPlaceholderImage();
                                    },
                                  )
                                : _buildPlaceholderImage(),
                          ),
                          // Event Details
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Event Title
                                Text(
                                  event.venue,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1D1E25),
                                    fontFamily: 'Inter',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // Event Venue
                                Text(
                                  event.venue,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                    fontFamily: 'Inter',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                // Event Date and Favorite
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            event.formattedStartAt,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primary,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Favorite Button
                                    InteractiveBookmark(
                                      isSaved: isSaved,
                                      onPressed: () =>
                                          _toggleFavorite(event.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            const Color(0xFF6B7AED).withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.event,
          size: 48,
          color: AppColors.primary.withOpacity(0.5),
        ),
      ),
    );
  }

  void _toggleFavorite(int eventId) {
    setState(() {
      _savedEvents[eventId] = !(_savedEvents[eventId] ?? false);
    });

    // Call FavoriteCubit
    context.read<FavoriteCubit>().toggleEventFavorite(eventId);
  }
}
