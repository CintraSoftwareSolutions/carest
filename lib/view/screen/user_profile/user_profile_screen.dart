import 'dart:convert';
import 'dart:typed_data';

import 'package:castyourcare/config/constants/app_sizes.dart';
import 'package:castyourcare/view/custom/common_image_view_widget.dart';
import 'package:castyourcare/view/custom/my_text_widget.dart';
import 'package:castyourcare/view/screen/user_profile/help_support_screen.dart';
import 'package:castyourcare/view/screen/user_profile/privacy_policy_screen.dart';
import 'package:castyourcare/view/screen/user_profile/profile_bottom_sheet/account_recovery_sheet.dart';
import 'package:castyourcare/view/screen/user_profile/profile_bottom_sheet/edit_profile_sheet.dart';
import 'package:castyourcare/view/screen/user_profile/profile_bottom_sheet/profile_bottom_sheet_screen.dart';
import 'package:castyourcare/view/screen/user_profile/term_and_condition_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/app_colors.dart';
import '../../../data/services/audio_service.dart';
import '../../../data/services/user_repository.dart';
import '../../../generated/assets.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _music = true;
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final user = await UserRepository.to.getUser();
    final settings = Map<String, dynamic>.from(user['settings'] ?? {});
    if (!mounted) return;
    setState(() {
      _music = (settings['musicEnabled'] ?? true) as bool;
      _notifications = (settings['notificationsEnabled'] ?? true) as bool;
    });
  }

  Future<void> _toggleMusic(bool val) async {
    setState(() => _music = val);
    await UserRepository.to.setSetting('musicEnabled', val);
    try {
      await AudioService.to.setEnabled(val);
    } catch (_) {}
  }

  Future<void> _toggleNotifications(bool val) async {
    setState(() => _notifications = val);
    await UserRepository.to.setSetting('notificationsEnabled', val);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSplashColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(text: "User Profile", size: 24, weight: FontWeight.w600),
                const SizedBox(height: 10),
                _profileCard(),
                const SizedBox(height: 15),
                MyText(
                  text: "ACCOUNT",
                  size: 12,
                  weight: FontWeight.w600,
                  color: kTextColor,
                ),
                const SizedBox(height: 10),
                buildSupportCard(
                  onTap: () => AccountRecoverySheet.open(),
                  title: "Sync Across Devices",
                  imagePath: Assets.imagesPpff,
                  arrowPath: Assets.svgArrowForward,
                ),
                const SizedBox(height: 15),
                MyText(
                  text: "GENERAL SETTINGS",
                  size: 12,
                  weight: FontWeight.w600,
                  color: kTextColor,
                ),
                const SizedBox(height: 10),
                _toggleCard(
                  icon: Assets.imagesMusic,
                  title: "Enable Music",
                  value: _music,
                  onChanged: _toggleMusic,
                ),
                const SizedBox(height: 10),
                _toggleCard(
                  icon: Assets.imagesNotification,
                  title: "Enable Notifications",
                  value: _notifications,
                  onChanged: _toggleNotifications,
                ),
                const SizedBox(height: 15),
                MyText(
                  text: "ABOUT",
                  size: 12,
                  weight: FontWeight.w600,
                  color: kTextColor,
                ),
                const SizedBox(height: 10),
                buildSupportCard(
                  onTap: () => Get.to(() => HelpSupportScreen()),
                  title: "Help & Support",
                  imagePath: Assets.imagesHs,
                  arrowPath: Assets.svgArrowForward,
                ),
                buildSupportCard(
                  onTap: () => Get.to(() => PrivacyPolicyScreen()),
                  title: "Privacy Policy",
                  imagePath: Assets.imagesPp,
                  arrowPath: Assets.svgArrowForward,
                ),
                buildSupportCard(
                  onTap: () => Get.to(() => TermAndConditionScreen()),
                  title: "Terms & Conditions",
                  imagePath: Assets.imagesTc,
                  arrowPath: Assets.svgArrowForward,
                ),
                buildSupportCard(
                  onTap: () => ProfileBottomSheetScreen.logoutBottomSheet(),
                  title: "Logout",
                  imagePath: Assets.imagesLg,
                  arrowPath: Assets.svgArrowForward,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileCard() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: UserRepository.to.userStream(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? {};
        final username = (data['username'] ?? '@user') as String;
        final year = (data['memberSince'] ?? DateTime.now().year);
        final profile = Map<String, dynamic>.from(data['profile'] ?? {});
        final name = (profile['name'] ?? '') as String;
        final email = (profile['email'] ?? '') as String;
        final photo = (profile['photo'] ?? '') as String;

        // Show the entered name as the title (fall back to username), and the
        // email (or "member since") as the subtitle.
        final title = name.isNotEmpty ? name : username;
        final subtitle = email.isNotEmpty ? email : "Member since $year";

        return GestureDetector(
          onTap: () => EditProfileSheet.open(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: ShapeDecoration(
              color: kQuaternaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              children: [
                _cardAvatar(photo),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: title,
                        size: 16,
                        weight: FontWeight.w600,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      MyText(
                        text: subtitle,
                        size: 12,
                        weight: FontWeight.w500,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.edit, size: 18, color: kTextColor),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Profile-card avatar: the saved photo when set, otherwise the placeholder.
  Widget _cardAvatar(String photo) {
    Uint8List? bytes;
    if (photo.isNotEmpty) {
      try {
        bytes = base64Decode(photo);
      } catch (_) {}
    }
    if (bytes != null) {
      return ClipOval(
        child: Image.memory(
          bytes,
          width: 45,
          height: 45,
          fit: BoxFit.cover,
        ),
      );
    }
    return CommonImageView(imagePath: Assets.imagesPpff, height: 45);
  }

  Widget _toggleCard({
    required String icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: ShapeDecoration(
        color: kQuaternaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Row(
        children: [
          CommonImageView(imagePath: icon, height: 40),
          const SizedBox(width: 10),
          Expanded(
            child: MyText(text: title, size: 16, weight: FontWeight.w600),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF9AAA7A),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD9D9D9),
          ),
        ],
      ),
    );
  }

  Widget buildSupportCard({
    required VoidCallback onTap,
    required String title,
    required String imagePath,
    required String arrowPath,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: ShapeDecoration(
          color: kQuaternaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Row(
          children: [
            CommonImageView(imagePath: imagePath, height: 40),
            const SizedBox(width: 10),
            Expanded(
              child: MyText(text: title, size: 16, weight: FontWeight.w600),
            ),
            CommonImageView(svgPath: arrowPath),
          ],
        ),
      ),
    );
  }
}
