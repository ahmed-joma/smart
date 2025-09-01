import 'package:flutter/material.dart';

import 'section_hotel_header.dart';
import 'section_guests_container.dart';
import 'section_hotel_details.dart';
import 'section_hotel_preview.dart';
import 'section_book_hotel_button.dart';

class HotelDetailsBody extends StatefulWidget {
  final Map<String, dynamic>? hotelData;

  const HotelDetailsBody({super.key, this.hotelData});

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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Default data if no hotelData provided
    final hotel =
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

    return Scaffold(
      body: Stack(
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
              SectionHotelHeader(),

              // Main Content
              SectionHotelDetails(hotel: hotel),

              // Preview Section
              const SectionHotelPreview(),
            ],
          ),

          // Floating Guests Container
          SectionGuestsContainer(guests: hotel['guests']),

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
          SectionBookHotelButton(price: hotel['price']),
        ],
      ),
    );
  }
}
