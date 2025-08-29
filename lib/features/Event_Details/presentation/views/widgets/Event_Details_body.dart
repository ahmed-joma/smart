import 'package:flutter/material.dart';

import 'section_event_header.dart';
import 'section_attendees_container.dart';
import 'section_event_details.dart';
import 'section_buy_ticket_button.dart';

class EventDetailsBody extends StatefulWidget {
  final Map<String, dynamic>? eventData;

  const EventDetailsBody({super.key, this.eventData});

  @override
  State<EventDetailsBody> createState() => _EventDetailsBodyState();
}

class _EventDetailsBodyState extends State<EventDetailsBody>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
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
    // Default data if no eventData provided
    final event =
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
              const SectionEventHeader(),

              // Main Content
              SectionEventDetails(event: event),
            ],
          ),

          // Floating Attendees Container
          // Floating Attendees Container (Positioned)
          SectionAttendeesContainer(attendees: event['attendees']),

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
          // Fixed Buy Ticket Button at Bottom (Positioned)
          SectionBuyTicketButton(price: event['price']),
        ],
      ),
    );
  }
}
