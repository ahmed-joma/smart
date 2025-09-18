import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'section_hotel_header.dart';
import 'section_hotel_rating.dart';
import 'section_hotel_details.dart';
import 'section_hotel_details_button.dart';
import '../../manager/hotel_details_cubit.dart';

class HotelDetailsBody extends StatefulWidget {
  final Map<String, dynamic>? hotelData;
  final int? hotelId;

  const HotelDetailsBody({super.key, this.hotelData, this.hotelId});

  @override
  State<HotelDetailsBody> createState() => _HotelDetailsBodyState();
}

class _HotelDetailsBodyState extends State<HotelDetailsBody>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Load hotel details if hotelId is provided
    if (widget.hotelId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HotelDetailsCubit>().getHotelDetails(widget.hotelId!);
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
      body: BlocBuilder<HotelDetailsCubit, HotelDetailsState>(
        builder: (context, state) {
          // Loading State
          if (state is HotelDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error State
          if (state is HotelDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      state.message.contains('login') ||
                              state.message.contains('Authentication')
                          ? Icons.login_outlined
                          : Icons.error_outline,
                      size: 64,
                      color:
                          state.message.contains('login') ||
                              state.message.contains('Authentication')
                          ? Colors.orange.shade400
                          : Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message.contains('login') ||
                              state.message.contains('Authentication')
                          ? 'Authentication Required'
                          : 'Failed to load hotel details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color:
                            state.message.contains('login') ||
                                state.message.contains('Authentication')
                            ? Colors.orange.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF747688),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.message.contains('login') ||
                            state.message.contains('Authentication')) ...[
                          ElevatedButton.icon(
                            onPressed: () {
                              context.go('/login');
                            },
                            icon: const Icon(Icons.login),
                            label: const Text('Login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        OutlinedButton.icon(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Go Back'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (widget.hotelId != null) {
                              context.read<HotelDetailsCubit>().getHotelDetails(
                                widget.hotelId!,
                              );
                            }
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          // Success State or Fallback
          Map<String, dynamic> hotel;
          String? imageUrl;
          bool? isFavorite;

          if (state is HotelDetailsSuccess) {
            print('🏨 HotelDetailsSuccess state detected');
            print('📊 Hotel model: ${state.hotel}');

            // Convert API data to UI format
            hotel = state.hotel.toHotelData();
            imageUrl = state.hotel.coverUrl;
            isFavorite = state.hotel.isFavorite;

            print('🎯 Using API data for hotel: ${state.hotel.name}');
            print('🖼️ Hotel image URL: $imageUrl');
            print('💖 Hotel is favorite: $isFavorite');
          } else {
            print('🎯 Using fallback data (no API data available)');
            // Default data if no API data
            hotel =
                widget.hotelData ??
                {
                  'title': 'Four Points by Sheraton',
                  'date': '14 December, 2025',
                  'day': 'Tuesday',
                  'time': 'Check-in: 3:00PM',
                  'location': 'Jeddah Corniche',
                  'country': 'KSA',
                  'organizer': 'Marriott International',
                  'organizerCountry': 'USA',
                  'about':
                      'Luxury hotel with stunning sea views, world-class amenities, and exceptional service in the heart of Jeddah.',
                  'guests': '+50 Guests',
                  'price': 'SR165.3',
                  'image': 'assets/images/hotel.svg',
                };
            imageUrl = hotel['image'] as String?;
            isFavorite = false; // Default for fallback data
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
                  SectionHotelHeader(
                    imageUrl: imageUrl,
                    isFavorite: isFavorite,
                    onFavoriteToggle: widget.hotelId != null
                        ? () => context
                              .read<HotelDetailsCubit>()
                              .toggleFavorite(widget.hotelId!)
                        : null,
                  ),

                  // Main Content
                  SectionHotelDetails(hotel: hotel),
                ],
              ),

              // Floating Rating Container
              SectionHotelRating(
                rating: hotel['rating'] ?? 0,
                hotelName: hotel['title']?.toString() ?? 'Hotel',
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

              // Fixed Book Hotel Button at Bottom
              SectionHotelDetailsButton(hotelData: hotel),
            ],
          );
        },
      ),
    );
  }
}
