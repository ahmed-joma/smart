import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import '../../../../Home/presentation/manager/logout_cubit.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  void _onLogoutPressed(BuildContext context) {
    context.read<LogoutCubit>().logout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Profile Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: ClipOval(
                      child: SvgPicture.asset(
                        'assets/images/profile.svg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Profile Name
                  const Text(
                    'Ahlam',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: 'My Profile',
                    onTap: () {
                      // Navigate to My Profile
                      context.go('/myProfileView');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.calendar_today,
                    title: 'Calender',
                    onTap: () {
                      // Navigate to Calendar
                      context.go('/calendarView');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.chat_bubble_outline,
                    title: 'AI chatbot',
                    onTap: () {
                      // Navigate to AI Chatbot
                      context.go('/chatView');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      // Navigate to Settings
                      context.go('/settingsView');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline,
                    title: 'Helps & FAQs',
                    onTap: () {
                      // Navigate to Help & FAQs
                      context.go('/helpFaqsView');
                    },
                  ),
                  // Logout with proper API integration
                  BlocProvider(
                    create: (context) => LogoutCubit(),
                    child: BlocListener<LogoutCubit, LogoutState>(
                      listener: (context, state) {
                        if (state is LogoutSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logged out successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // Navigate to Sign In
                          context.go('/signInView');
                        } else if (state is LogoutError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: BlocBuilder<LogoutCubit, LogoutState>(
                        builder: (context, state) {
                          return _buildDrawerItem(
                            icon: Icons.logout,
                            title: 'Sign Out',
                            onTap: () => _onLogoutPressed(context),
                            isLoading: state is LogoutLoading,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Upgrade Pro Button
            Container(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 200,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF00F8FF,
                  ).withOpacity(0.2), // #00F8FF33 شفاف 20%
                  borderRadius: BorderRadius.circular(
                    15,
                  ), // إرجاع الزوايا الدائرية
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.workspace_premium,
                      color: Color(0xFF00F8FF), // #00F8FF للأيقونة
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Upgrade Pro',
                      style: TextStyle(
                        color: Color(0xFF00F8FF), // #00F8FF للنص
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return ListTile(
      leading: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              icon,
              color: const Color(0xFF767676), // لون رمادي للأيقونات
              size: 24,
            ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black, // لون أسود للنصوص
          fontSize: 16,
          fontWeight: FontWeight.w400, // تحديث الوزن إلى w400
          fontFamily: 'Inter',
        ),
      ),
      onTap: isLoading ? null : onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      // إضافة تأثيرات عند الضغط
      tileColor: Colors.transparent,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
      selectedColor: AppColors.primary,
      hoverColor: AppColors.primary.withOpacity(0.05),
      focusColor: AppColors.primary.withOpacity(0.1),
      // تأثيرات إضافية
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      // تأثير عند الضغط
      onLongPress: () {
        // يمكن إضافة تأثير إضافي هنا
      },
    );
  }
}
