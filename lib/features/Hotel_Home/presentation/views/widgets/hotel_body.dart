import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/shared.dart';
import 'section_header.dart';
import 'section_near_location.dart';
import 'section_popular_hotel.dart';
import 'section_bottom_navigation.dart';
import 'home_drawer.dart';
import '../../manager/hotel_home_cubit.dart';

class HotelBody extends StatefulWidget {
  const HotelBody({super.key});

  @override
  State<HotelBody> createState() => _HotelBodyState();
}

class _HotelBodyState extends State<HotelBody> {
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

    // Load hotel data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🏨 HotelBody: Initializing and calling getHotelData()');
      context.read<HotelHomeCubit>().getHotelData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const HomeDrawer(), // إضافة Navigation Drawer
      body: SafeArea(
        child: BlocBuilder<HotelHomeCubit, HotelHomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<HotelHomeCubit>().refreshHotelData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header Section
                    const SectionHeader(),
                    const SizedBox(height: 30),

                    // Loading State
                    if (state is HotelHomeLoading)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),

                    // Error State
                    if (state is HotelHomeError)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
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
                                  : 'Failed to load hotels',
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
                                    state.message.contains(
                                      'Authentication',
                                    )) ...[
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
                                  onPressed: () => context
                                      .read<HotelHomeCubit>()
                                      .getHotelData(),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    // Success State
                    if (state is HotelHomeSuccess) ...[
                      // Near Location Section
                      SectionNearLocation(
                        hotels: state.hotelData.hotels.nearLocationHotels,
                      ),

                      // Popular Hotel Section
                      SectionPopularHotel(
                        hotels: state.hotelData.hotels.popularHotels,
                      ),
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
