import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/shared.dart';
import '../../../../../shared/widgets/interactive_bookmark.dart';
import '../../../data/models/home_models.dart';

class SectionExpiredEvents extends StatefulWidget {
  final List<HomeEvent> events;

  const SectionExpiredEvents({super.key, required this.events});

  @override
  State<SectionExpiredEvents> createState() => _SectionExpiredEventsState();
}

class _SectionExpiredEventsState extends State<SectionExpiredEvents> {
  // Track saved state for each event
  final Map<int, bool> _savedEvents = {};

  @override
  Widget build(BuildContext context) {
    if (widget.events.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Past Events',
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

        // Events List
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.events.length,
            itemBuilder: (context, index) {
              final event = widget.events[index];
              return _buildEventCard(event, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(HomeEvent event, int index) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push(
              '/eventDetailsView',
              extra: {'eventId': event.id, 'eventData': event.toJson()},
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
                      child: Stack(
                        children: [
                          // Image with grayscale filter for expired events
                          ColorFiltered(
                            colorFilter: const ColorFilter.matrix([
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                            ]),
                            child: event.imageUrl.isNotEmpty
                                ? (event.imageUrl.endsWith('.svg')
                                      ? SvgPicture.network(
                                          event.imageUrl,
                                          fit: BoxFit.cover,
                                          placeholderBuilder: (context) =>
                                              const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                        )
                                      : Image.network(
                                          event.imageUrl,
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  color: const Color(
                                                    0xFFF0F0F0,
                                                  ),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                      color: Color(0xFF9E9E9E),
                                                      size: 40,
                                                    ),
                                                  ),
                                                );
                                              },
                                        ))
                                : const Center(
                                    child: Icon(
                                      Icons.event,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          // Overlay for expired effect
                          Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bookmark
                  Positioned(
                    top: 12,
                    right: 12,
                    child: InteractiveBookmark(
                      isSaved: _savedEvents[event.id] ?? event.isFavorite,
                      size: 28,
                      onPressed: () {
                        setState(() {
                          _savedEvents[event.id] =
                              !(_savedEvents[event.id] ?? event.isFavorite);
                        });
                      },
                    ),
                  ),
                  // Date Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.95),
                            Colors.white.withOpacity(0.85),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.8),
                            blurRadius: 5,
                            offset: const Offset(-2, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _extractDay(event.formattedStartAt),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF0635A),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            _extractMonth(event.formattedStartAt),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFF0635A),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Content Section
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Date
                      Text(
                        event.formattedStartAt,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF747688),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Event Title (using venue as title)
                      Text(
                        event.venue,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1E25).withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Attendees (moved up)
                      if (event.attendeesImages.isNotEmpty)
                        Row(
                          children: [
                            // Attendees Images
                            SizedBox(
                              height: 24,
                              width: event.attendeesImages.length > 3
                                  ? 56 // 3 * 16 + 24
                                  : event.attendeesImages.length * 16 + 8,
                              child: Stack(
                                children: List.generate(
                                  event.attendeesImages.length > 3
                                      ? 3
                                      : event.attendeesImages.length,
                                  (attendeeIndex) => Positioned(
                                    left: attendeeIndex * 16.0,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: ColorFiltered(
                                          colorFilter:
                                              const ColorFilter.matrix([
                                                0.2126,
                                                0.7152,
                                                0.0722,
                                                0,
                                                0,
                                                0.2126,
                                                0.7152,
                                                0.0722,
                                                0,
                                                0,
                                                0.2126,
                                                0.7152,
                                                0.0722,
                                                0,
                                                0,
                                                0,
                                                0,
                                                0,
                                                1,
                                                0,
                                              ]),
                                          child: Image.network(
                                            event
                                                .attendeesImages[attendeeIndex],
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                                      color: Colors.grey,
                                                      child: const Icon(
                                                        Icons.person,
                                                        size: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),

                            // More attendees count
                            if (event.attendeesImages.length > 3)
                              Text(
                                '+${event.attendeesImages.length - 3}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF3F38DD),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      const SizedBox(height: 4),

                      // Location (moved down)
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Color(0xFF747688),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.cityName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF747688),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods to extract day and month from formatted date
  String _extractDay(String formattedDate) {
    // Format: "26th Sep - Fri - 12:00 AM"
    try {
      final parts = formattedDate.split(' ');
      if (parts.isNotEmpty) {
        // Extract number from "26th"
        return parts[0].replaceAll(RegExp(r'[^\d]'), '');
      }
    } catch (e) {
      // Fallback
    }
    return '10';
  }

  String _extractMonth(String formattedDate) {
    // Format: "26th Sep - Fri - 12:00 AM"
    try {
      final parts = formattedDate.split(' ');
      if (parts.length > 1) {
        return parts[1].toUpperCase();
      }
    } catch (e) {
      // Fallback
    }
    return 'JUN';
  }
}
