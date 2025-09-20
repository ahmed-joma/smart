import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'section_event_header.dart';
import 'section_attendees_container.dart';
import 'section_event_details.dart';
import 'section_buy_ticket_button.dart';
import '../../manager/event_details_cubit.dart';
import '../../../../../../shared/shared.dart';
import '../../../../../core/utils/cubits/favorite_cubit.dart';
import '../../../../../core/utils/cubits/favorite_state.dart';

class EventDetailsBody extends StatefulWidget {
  final Map<String, dynamic>? eventData;
  final int? eventId;

  const EventDetailsBody({super.key, this.eventData, this.eventId});

  @override
  State<EventDetailsBody> createState() => _EventDetailsBodyState();
}

class _EventDetailsBodyState extends State<EventDetailsBody>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _bounceController;

  // Track favorite state locally
  bool? _localFavoriteState;

  void _toggleFavorite(bool currentState) {
    if (widget.eventId != null) {
      print('🎯 Toggle favorite for event ID: ${widget.eventId}');
      context.read<FavoriteCubit>().toggleEventFavorite(widget.eventId!);
      setState(() {
        _localFavoriteState = !currentState;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Load event details if eventId is provided
    if (widget.eventId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<EventDetailsCubit>().getEventDetails(widget.eventId!);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<FavoriteCubit, FavoriteState>(
            listener: (context, state) {
              if (state is FavoriteSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else if (state is FavoriteError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<EventDetailsCubit, EventDetailsState>(
          builder: (context, state) {
            if (state is EventDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EventDetailsError) {
              print('❌ EventDetailsError state: ${state.message}');
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  title: const Text('Event Details'),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error Loading Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Go Back'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (widget.eventId != null) {
                                context
                                    .read<EventDetailsCubit>()
                                    .getEventDetails(widget.eventId!);
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            // Use API data if available, otherwise fallback to default
            Map<String, dynamic> event;
            bool? isFavorite;

            if (state is EventDetailsSuccess) {
              print('🔄 EventDetailsSuccess state detected');
              print('📊 Event model: ${state.event}');

              try {
                event = state.event.toEventData();
                isFavorite = state.event.isFavorite;
                print('✅ toEventData() successful');
                print('🎯 Using API data for event: ${event['title']}');
                print('💖 Event is favorite: $isFavorite');
              } catch (e) {
                print('❌ Error in toEventData(): $e');
                // Use fallback data if conversion fails
                event = {
                  'title': 'Event Title',
                  'date': '14 December, 2025',
                  'day': 'Tuesday',
                  'time': '4:00PM - 9:00PM',
                  'location': 'Event Location',
                  'country': 'KSA',
                  'organizer': 'Event Organizer',
                  'organizerCountry': 'SA',
                  'about': 'Event description',
                  'attendees': '+20 Going',
                  'price': 'SR120',
                  'image': '',
                };
                isFavorite = false;
              }
            } else {
              // Default/fallback data
              event =
                  widget.eventData ??
                  {
                    'title': 'City Walk Event',
                    'date': '14 December, 2025',
                    'day': 'Tuesday',
                    'time': '4:00PM - 9:00PM',
                    'location': 'Jeddah King Abdulaziz Road',
                    'country': 'KSA',
                    'organizer': 'Entertainment Authority',
                    'organizerCountry': 'SA',
                    'about':
                        'The best event in Jeddah, unique and wonderful, with many restaurants, events and games.',
                    'attendees': '+20 Going',
                    'price': 'SR120',
                    'image': 'assets/images/citywaikevents.svg',
                  };
              isFavorite = false; // Default for fallback data
              print('📋 Using fallback data for event: ${event['title']}');
            }

            return Stack(
              children: [
                // Scrollable Content with Beautiful Physics
                CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  scrollBehavior: ScrollConfiguration.of(context).copyWith(
                    physics: const BouncingScrollPhysics(),
                    scrollbars: false,
                  ),
                  slivers: [
                    // Custom App Bar with Background Image
                    SectionEventHeader(
                      imageUrl: event['image'] as String?,
                      isFavorite: _localFavoriteState ?? isFavorite,
                      onFavoriteToggle: widget.eventId != null
                          ? () => _toggleFavorite(
                              _localFavoriteState ?? isFavorite ?? false,
                            )
                          : null,
                    ),

                    // Main Content
                    SectionEventDetails(event: event),
                  ],
                ),

                // Floating Attendees Container
                SectionAttendeesContainer(
                  attendees: event['attendees']?.toString() ?? '+0 Going',
                  attendeesImages: _getAttendeesImages(state),
                ),

                // Scroll Listener for Beautiful Physics
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo is ScrollEndNotification) {
                      _bounceController.forward().then((_) {
                        _bounceController.reverse();
                      });
                    }
                    return false;
                  },
                  child: const SizedBox.shrink(),
                ),

                // Fixed Buy Ticket Button at Bottom
                SectionBuyTicketButton(
                  price: event['price']?.toString() ?? 'SR0',
                  eventData: event,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper method to extract attendees images from state
  List<String>? _getAttendeesImages(EventDetailsState state) {
    if (state is EventDetailsSuccess) {
      return state.event.attendeesImages;
    }
    return null;
  }
}
