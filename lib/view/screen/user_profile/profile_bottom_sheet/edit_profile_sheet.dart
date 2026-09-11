import 'dart:convert';
import 'dart:typed_data';

import 'package:castyourcare/view/custom/my_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../data/services/user_repository.dart';
import '../../../custom/my_text_widget.dart';

/// Bottom sheet to add/edit profile details (photo, name, email, phone),
/// saved to Firestore under users/{uid}.profile. Opened by tapping the
/// profile card.
class EditProfileSheet {
  static void open() {
    Get.bottomSheet(
      const _EditProfileSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet();

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  String _photo = ''; // base64-encoded, downsized JPEG
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  Future<void> _prefill() async {
    final p = await UserRepository.to.getProfile();
    if (!mounted) return;
    _name.text = (p['name'] ?? '') as String;
    _email.text = (p['email'] ?? '') as String;
    _phone.text = (p['phone'] ?? '') as String;
    _photo = (p['photo'] ?? '') as String;
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        // Downsize + compress at pick time so the stored image stays tiny
        // (well under Firestore's 1MB document limit).
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 55,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() => _photo = base64Encode(bytes));
    } catch (e) {
      Get.snackbar(
        "Couldn't add photo",
        "Please try a different image.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    setState(() => _saving = true);
    final ok = await UserRepository.to.saveProfile({
      'name': _name.text.trim(),
      'email': _email.text.trim(),
      'phone': _phone.text.trim(),
      'photo': _photo,
    });
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      Get.back();
      Get.snackbar(
        "Profile saved",
        "Your details have been updated.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Couldn't save",
        "Please check your connection and try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: kSplashColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, size: 15),
                  const SizedBox(width: 3),
                  MyText(text: "Back", size: 14, weight: FontWeight.w600),
                ],
              ),
            ),
            const SizedBox(height: 10),
            MyText(text: "Edit Profile", size: 20, weight: FontWeight.w600),
            const SizedBox(height: 5),
            MyText(
              text: "Add your details. These are saved securely to your profile.",
              size: 14,
              weight: FontWeight.w600,
              color: kTextColor,
            ),
            const SizedBox(height: 20),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              Center(child: _avatar()),
              const SizedBox(height: 20),
              MyTextField(controller: _name, label: "Full Name"),
              MyTextField(
                controller: _email,
                label: "Email address",
                keyboardType: TextInputType.emailAddress,
              ),
              MyTextField(
                controller: _phone,
                label: "Phone Number",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _saving ? null : _save,
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF1F3A5F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : MyText(
                            text: "Save",
                            size: 16,
                            weight: FontWeight.w600,
                            color: kQuaternaryColor,
                          ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    Uint8List? bytes;
    if (_photo.isNotEmpty) {
      try {
        bytes = base64Decode(_photo);
      } catch (_) {}
    }
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: kQuaternaryColor,
            backgroundImage: bytes != null ? MemoryImage(bytes) : null,
            child: bytes == null
                ? const Icon(Icons.person, size: 46, color: kTextColor)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(
                color: Color(0xFF1F3A5F),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt,
                  size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
