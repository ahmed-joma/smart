import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../shared/shared.dart';
import 'section_header.dart';
import 'section_upcoming_events.dart';
import 'section_hotel_reservations.dart';
import 'section_nearby.dart';
import 'section_bottom_navigation.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              const SectionHeader(),

              // Upcoming Events Section
              const SectionUpcomingEvents(),

              // Hotel Reservations Section
              const SectionHotelReservations(),

              // Nearby You Section
              const SectionNearby(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const SectionBottomNavigation(),
    );
  }
}
