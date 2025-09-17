import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/shared.dart';
import 'section_header.dart';
import 'section_upcoming_events.dart';
import 'section_ongoing_events.dart';
import 'section_expired_events.dart';
import 'section_hotel_reservations.dart';
import 'section_nearby.dart';
import 'section_bottom_navigation.dart';
import 'home_drawer.dart';
import '../../manager/Home/home_cubit.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    // Load home data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const HomeDrawer(), // إضافة Navigation Drawer
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().refreshHomeData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header Section
                    const SectionHeader(),

                    // Loading State
                    if (state is HomeLoading)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),

                    // Error State
                    if (state is HomeError)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              state.message.contains('login') || state.message.contains('Authentication')
                                  ? Icons.login_outlined
                                  : Icons.error_outline,
                              size: 64,
                              color: state.message.contains('login') || state.message.contains('Authentication')
                                  ? Colors.orange.shade400
                                  : Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message.contains('login') || state.message.contains('Authentication')
                                  ? 'Authentication Required'
                                  : 'Failed to load events',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: state.message.contains('login') || state.message.contains('Authentication')
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
                                if (state.message.contains('login') || state.message.contains('Authentication')) ...[
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // Navigate to login page
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
                                OutlinedButton(
                                  onPressed: () =>
                                      context.read<HomeCubit>().getHomeData(),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    // Success State
                    if (state is HomeSuccess) ...[
                      // Upcoming Events Section
                      SectionUpcomingEvents(
                        events: state.homeData.events.upcoming,
                      ),

                      // Ongoing Events Section
                      SectionOngoingEvents(
                        events: state.homeData.events.ongoing,
                      ),

                      // Expired Events Section
                      SectionExpiredEvents(
                        events: state.homeData.events.expired,
                      ),
                    ],

                    // Static Sections (keep as they are for now)
                    if (state is! HomeLoading) ...[
                      // Hotel Reservations Section
                      const SectionHotelReservations(),

                      // Nearby You Section
                      const SectionNearby(),
                    ],

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const SectionBottomNavigation(),
    );
  }
}
