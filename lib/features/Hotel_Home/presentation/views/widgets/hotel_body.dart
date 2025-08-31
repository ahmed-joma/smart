import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../shared/shared.dart';
import 'section_header.dart';
import 'section_near_location.dart';
import 'section_popular_hotel.dart';
import 'section_bottom_navigation.dart';
import 'home_drawer.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const HomeDrawer(), // إضافة Navigation Drawer
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              const SectionHeader(),
              const SizedBox(height: 30),

              // Near Location Section
              const SectionNearLocation(),

              // Popular Hotel Section
              const SectionPopularHotel(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const SectionBottomNavigation(),
    );
  }
}
