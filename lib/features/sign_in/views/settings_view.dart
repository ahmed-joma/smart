import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/shared.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/utils/api_service.dart';
import '../../Profile/presentation/manager/profile_cubit.dart';
import '../../../../shared/widgets/profile_avatar.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    // Load profile data when settings page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            print('🔙 Settings: Back button pressed');
            if (context.canPop()) {
              context.pop();
              print('✅ Settings: Successfully popped');
            } else {
              print('❌ Settings: Cannot pop, navigating to home');
              context.go('/homeView');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildProfileSection(),

            const SizedBox(height: 24),

            // Account Settings
            _buildSettingsSection('Account', Icons.person_outline, [
              _buildSettingsItem(
                'Edit Profile',
                'Update your personal information',
                Icons.edit,
                () => context.go('/editProfileView'),
              ),
            ]),

            const SizedBox(height: 24),

            // App Settings
            _buildSettingsSection('App Settings', Icons.settings_outlined, [
              _buildSwitchItem(
                'Push Notifications',
                'Receive notifications about events and hotels',
                Icons.notifications_outlined,
                _notificationsEnabled,
                (value) => setState(() => _notificationsEnabled = value),
              ),
              _buildSwitchItem(
                'Location Services',
                'Allow app to access your location',
                Icons.location_on_outlined,
                _locationEnabled,
                (value) => setState(() => _locationEnabled = value),
              ),
              _buildSwitchItem(
                'Biometric Login',
                'Use fingerprint or face ID to login',
                Icons.fingerprint_outlined,
                _biometricEnabled,
                (value) => setState(() => _biometricEnabled = value),
              ),
            ]),

            const SizedBox(height: 24),

            // Support & Info
            _buildSettingsSection('Support & Info', Icons.help_outline, [
              _buildSettingsItem(
                'Help Center',
                'Get help and support',
                Icons.help_outline,
                () => _showComingSoon('Help Center'),
              ),
              _buildSettingsItem(
                'Contact Us',
                'Send us feedback or report issues',
                Icons.email_outlined,
                () => _showComingSoon('Contact Us'),
              ),
              _buildSettingsItem(
                'About App',
                'App version and information',
                Icons.info_outline,
                () => _showAboutDialog(),
              ),
              _buildSettingsItem(
                'Terms of Service',
                'Read our terms and conditions',
                Icons.description_outlined,
                () => _showComingSoon('Terms of Service'),
              ),
              _buildSettingsItem(
                'Privacy Policy',
                'Read our privacy policy',
                Icons.policy_outlined,
                () => _showComingSoon('Privacy Policy'),
              ),
            ]),

            const SizedBox(height: 24),

            // Danger Zone
            _buildSettingsSection('Account Actions', Icons.warning_outlined, [
              _buildDangerItem(
                'Sign Out',
                'Sign out of your account',
                Icons.logout_outlined,
                () => _showSignOutDialog(),
              ),
              _buildDangerItem(
                'Delete Account',
                'Permanently delete your account',
                Icons.delete_outline,
                () => _showDeleteAccountDialog(),
              ),
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        String imageUrl = '';
        String userName = 'User';
        String userEmail = 'user@example.com';

        if (state is ProfileSuccess) {
          // Use data from ProfileCubit if available
          imageUrl = state.data.user.imageUrl;
          userName = state.data.user.fullName;
          // Get email from ApiService since UserProfile doesn't have email
          final apiService = sl<ApiService>();
          userEmail = apiService.userData?['email'] ?? 'user@example.com';
        } else {
          // Fallback to ApiService data
          final apiService = sl<ApiService>();
          imageUrl = apiService.userData?['image_url'] ?? '';
          userName = apiService.userData?['full_name'] ?? 'User';
          userEmail = apiService.userData?['email'] ?? 'user@example.com';
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Profile Avatar
              ProfileAvatar(
                imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
                name: userName,
                size: 60,
                showEditIcon: false,
              ),

              const SizedBox(width: 16),

              // Profile Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Premium Member',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Edit Button
              GestureDetector(
                onTap: () => context.go('/editProfileView'),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.edit, color: AppColors.primary, size: 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsSection(
    String title,
    IconData icon,
    List<Widget> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildDangerItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.red, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature'),
        content: const Text(
          'This feature is coming soon! Stay tuned for updates.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About App'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smart Events & Hotels'),
            SizedBox(height: 8),
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Build: 2024.09.28'),
            SizedBox(height: 8),
            Text(
              'Discover amazing events and book hotels with ease. Your ultimate travel companion.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out? You will need to log in again to access your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon('Sign Out');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone and all your data will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon('Delete Account');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
