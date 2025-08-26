import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'section_header.dart';
import 'section_profile_info.dart';
import 'section_about_me.dart';
import 'section_interests.dart';

class MyProfileBody extends StatefulWidget {
  const MyProfileBody({super.key});

  @override
  State<MyProfileBody> createState() => _MyProfileBodyState();
}

class _MyProfileBodyState extends State<MyProfileBody> {
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

              // Profile Info Section
              const SectionProfileInfo(),

              // About Me Section
              const SectionAboutMe(),

              // Interests Section
              const SectionInterests(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
