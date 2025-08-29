
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../shared/shared.dart';
import 'section_event_header.dart';


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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50, // قللنا من 100 إلى 60 لرفع المحتوى لأعلى
                  ), // مساحة فوق للـ floating container
                  child: Column(
                    children: [
                      // Event Details Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event Title
                            Text(
                              event['title'],
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Date and Time
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0x337F2F3A),
                                    borderRadius: BorderRadius.circular(15.31),
                                  ),
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event['date'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Text(
                                        '${event['day']}, ${event['time']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Location
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0x337F2F3A),
                                    borderRadius: BorderRadius.circular(15.31),
                                  ),
                                  child: Icon(
                                    Icons.location_on,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event['location'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Text(
                                        event['country'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Organizer
                            Row(
                              children: [
                                // Organizer Logo
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.palette,
                                    color: Colors.orange,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event['organizer'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        event['organizerCountry'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Follow Button
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      230,
                                      231,
                                      239,
                                    ),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(
                                      color: Color(0xFF7F2F3A),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // About Event
                            const Text(
                              'About Event',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              event['about'],
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primary.withOpacity(0.8),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Attendees Container
          Positioned(
            top: 320, // يتحكم بمكان الفلوتينج
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26, // ظل أقوى
                    blurRadius: 15, // ظل أكبر
                    spreadRadius: 2, // انتشار أكثر
                    offset: Offset(0, 4), // ظل أعمق
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Profile Images
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade300,
                        child: SvgPicture.asset(
                          'assets/images/person1.svg',
                          width: 32,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, color: Colors.grey);
                          },
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(
                          -10,
                          0,
                        ), // تداخل أكثر مع الصورة الأولى
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey.shade300,
                          child: SvgPicture.asset(
                            'assets/images/person2.svg',
                            width: 32,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(
                          -20,
                          0,
                        ), // تداخل أكثر مع الصورة الثانية
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey.shade300,
                          child: SvgPicture.asset(
                            'assets/images/person3.svg',
                            width: 32,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Text(
                    event['attendees'],
                    style: const TextStyle(
                      color: Color(0xFF3F38DD),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  // Invite Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Invite',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          Positioned(
            bottom: 20,
            left: 50, // بدل 20 لجعل الزر أضيق
            right: 50, // بدل 20 لجعل الزر أضيق
            child: ElevatedButton(
              onPressed: () {
                // Handle buy ticket action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' BUY TICKET ${event['price']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D56F0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
