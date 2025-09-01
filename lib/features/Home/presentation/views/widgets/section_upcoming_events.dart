import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/shared.dart';
import '../../../../../shared/widgets/interactive_bookmark.dart';

class SectionUpcomingEvents extends StatefulWidget {
  const SectionUpcomingEvents({super.key});

  @override
  State<SectionUpcomingEvents> createState() => _SectionUpcomingEventsState();
}

class _SectionUpcomingEventsState extends State<SectionUpcomingEvents> {
  // Track saved state for each event
  final Map<int, bool> _savedEvents = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primary,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF747688),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF747688),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Events List
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 6,
            itemBuilder: (context, index) {
              if (index.isEven) {
                return _buildEventCard(
                  context,
                  index,
                  index % 2 == 0 ? 'City Walk event' : 'Art Promenade',
                  index % 2 == 0
                      ? 'assets/images/citywaikeevents.svg'
                      : 'assets/images/Art Promenade.svg',
                  '10 JUNE',
                  'Jeddah King Abdulaziz Road',
                  '+20 Going',
                );
              } else {
                return Container(
                  width: 16,
                  constraints: const BoxConstraints(minWidth: 16, maxWidth: 16),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    int index,
    String title,
    String imagePath,
    String date,
    String location,
    String attendees,
  ) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 260,
        maxWidth: 280,
        minHeight: 280,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to Event Details with event data
          final eventData = {
            'id': 'event_${DateTime.now().millisecondsSinceEpoch}',
            'title': title,
            'date': date,
            'day': 'Tuesday', // You can make this dynamic
            'time': '4:00PM - 9:00PM', // You can make this dynamic
            'location': location,
            'country': 'KSA',
            'organizer': 'Entertainment Authority',
            'organizerCountry': 'SA',
            'about':
                'The best event in Jeddah, unique and wonderful, with many restaurants, events and games.',
            'attendees': attendees,
            'price': 'SR120',
            'image': imagePath,
          };
          context.push('/eventDetailsView', extra: eventData);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: imagePath.endsWith('.svg')
                      ? SvgPicture.asset(
                          imagePath,
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          imagePath,
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                ),

                // Date Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '10',
                          style: const TextStyle(
                            color: Color(0xFFF0635A),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'JUNE',
                          style: const TextStyle(
                            color: Color(0xFFF0635A),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Interactive Bookmark Icon
                Positioned(
                  top: 12,
                  right: 12,
                  child: InteractiveBookmark(
                    isSaved: _savedEvents[index] ?? false,
                    onPressed: () {
                      final newSavedState = !(_savedEvents[index] ?? false);
                      setState(() {
                        _savedEvents[index] = newSavedState;
                      });
                      // TODO: Call API to save/unsave event
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            newSavedState
                                ? 'Event saved to favorites!'
                                : 'Event removed from favorites!',
                          ),
                          backgroundColor: AppColors.primary,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    size: 44,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    iconColor: AppColors.primary,
                  ),
                ),
              ],
            ),

            // Event Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Attendees
                  Row(
                    children: [
                      // Profile Images
                      Row(
                        children: [
                          Transform.translate(
                            offset: const Offset(0, 0),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey.shade300,
                              child: SvgPicture.asset(
                                'assets/images/person1.svg',
                                width: 20,
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(-6, 0),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey.shade300,
                              child: SvgPicture.asset(
                                'assets/images/person2.svg',
                                width: 20,
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(-12, 0),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey.shade300,
                              child: SvgPicture.asset(
                                'assets/images/person3.svg',
                                width: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        attendees,
                        style: const TextStyle(
                          color: Color(0xFF3F38DD),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
