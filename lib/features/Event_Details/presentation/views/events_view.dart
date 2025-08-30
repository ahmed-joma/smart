import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/shared.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  String _selectedTab = 'UPCOMING'; // Default selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Segmented Control
            _buildSegmentedControl(),

            // Main Content
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back Arrow
          GestureDetector(
            onTap: () => context.go('/homeView'),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.primary,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Title
          const Expanded(
            child: Text(
              'Events',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),

          // Menu Icon
          const Icon(Icons.more_vert, color: AppColors.primary, size: 24),
        ],
      ),
    );
  }

  void _onTabChanged(String tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  Widget _buildSegmentedControl() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // UPCOMING Tab
          Expanded(
            child: GestureDetector(
              onTap: () => _onTabChanged('UPCOMING'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 'UPCOMING'
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _selectedTab == 'UPCOMING'
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'UPCOMING',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _selectedTab == 'UPCOMING'
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: _selectedTab == 'UPCOMING'
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // PAST EVENTS Tab
          Expanded(
            child: GestureDetector(
              onTap: () => _onTabChanged('PAST EVENTS'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 'PAST EVENTS'
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _selectedTab == 'PAST EVENTS'
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'PAST EVENTS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _selectedTab == 'PAST EVENTS'
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: _selectedTab == 'PAST EVENTS'
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox(height: 150),

          // Calendar Illustration
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Calendar Icon
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Calendar Header (Red)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Calendar Grid
                      Positioned(
                        top: 25,
                        left: 8,
                        right: 8,
                        child: Column(
                          children: [
                            // Grid rows
                            for (int i = 0; i < 4; i++)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (int j = 0; j < 7; j++)
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade800,
                                        borderRadius: BorderRadius.circular(1),
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

                // Clock Icon (overlapping)
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Primary Message
          const Text(
            'No Upcoming Event',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w400,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Secondary Message
          Text(
            'Lorem ipsum dolor sit amet,\nconsectetur',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 200),

          // Explore Events Button
          Container(
            width: double.infinity,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'EXPLORE EVENTS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
