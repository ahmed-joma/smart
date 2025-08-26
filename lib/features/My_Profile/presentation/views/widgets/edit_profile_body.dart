import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'section_edit_header.dart';
import 'section_edit_profile_picture.dart';
import 'section_edit_form.dart';
import 'section_save_button.dart';

// كلاس لتخزين بيانات الملف الشخصي
class ProfileData extends ChangeNotifier {
  String _name = 'AHLAM';
  String _aboutMe =
      'Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase.';
  String _profileImage = 'assets/images/profile.svg';

  String get name => _name;
  String get aboutMe => _aboutMe;
  String get profileImage => _profileImage;

  void updateProfile({String? name, String? aboutMe, String? profileImage}) {
    if (name != null) _name = name;
    if (aboutMe != null) _aboutMe = aboutMe;
    if (profileImage != null) _profileImage = profileImage;
    notifyListeners();
  }
}

// متغير عام لتقاسم البيانات
final ProfileData profileData = ProfileData();

class EditProfileBody extends StatefulWidget {
  const EditProfileBody({super.key});

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  final _nameController = TextEditingController();
  final _aboutMeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // تحميل البيانات الحالية
    _nameController.text = profileData.name;
    _aboutMeController.text = profileData.aboutMe;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    // تحديث البيانات في ProfileData
    profileData.updateProfile(
      name: _nameController.text,
      aboutMe: _aboutMeController.text,
    );

    // العودة لصفحة Profile
    context.go('/myProfileView');
  }

  void _onProfileImageChanged(String newImagePath) {
    profileData.updateProfile(profileImage: newImagePath);
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
              const SectionEditHeader(),

              // Profile Picture Section
              SectionEditProfilePicture(
                currentImagePath: profileData.profileImage,
                onImageChanged: _onProfileImageChanged,
              ),

              // Edit Form Section
              SectionEditForm(
                nameController: _nameController,
                aboutMeController: _aboutMeController,
              ),

              // Save Button Section
              SectionSaveButton(onSavePressed: _onSavePressed),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
