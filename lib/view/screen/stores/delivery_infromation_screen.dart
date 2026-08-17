import 'package:castyourcare/view/custom/my_textfeild.dart';
import 'package:castyourcare/view/screen/stores/check_out_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/app_colors.dart';
import '../../../config/constants/app_sizes.dart';
import '../../../data/services/user_repository.dart';
import '../../../generated/assets.dart';
import '../../custom/common_image_view_widget.dart';
import '../../custom/my_text_widget.dart';

class DeliveryInfromationScreen extends StatefulWidget {
  const DeliveryInfromationScreen({super.key});

  @override
  State<DeliveryInfromationScreen> createState() =>
      _DeliveryInfromationScreenState();
}

class _DeliveryInfromationScreenState extends State<DeliveryInfromationScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _country = TextEditingController();
  final _address = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  Future<void> _prefill() async {
    final info = await UserRepository.to.getDeliveryInfo();
    if (!mounted || info.isEmpty) return;
    _name.text = (info['name'] ?? '') as String;
    _email.text = (info['email'] ?? '') as String;
    _phone.text = (info['phone'] ?? '') as String;
    _country.text = (info['country'] ?? '') as String;
    _address.text = (info['address'] ?? '') as String;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _country.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_name.text.trim().isEmpty || _address.text.trim().isEmpty) {
      Get.snackbar("Missing details",
          "Please enter at least your name and address.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    await UserRepository.to.saveDeliveryInfo({
      'name': _name.text.trim(),
      'email': _email.text.trim(),
      'phone': _phone.text.trim(),
      'country': _country.text.trim(),
      'address': _address.text.trim(),
    });
    Get.to(() => CheckOutScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSplashColor,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: GestureDetector(
            onTap: _continue,
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
                child: MyText(
                  text: "Continue to Checkout",
                  size: 16,
                  weight: FontWeight.w600,
                  color: kQuaternaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
      // Tapping empty space dismisses the keyboard (the address field is
      // multiline with no "done" key, which was trapping users on iOS).
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: CommonImageView(
                        imagePath: Assets.imagesBackArrow,
                        height: 45,
                      ),
                    ),
                    const SizedBox(width: 15),
                    MyText(
                      text: "Delivery Information",
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MyText(
                  text: "PERSONAL INFORMATION",
                  size: 12,
                  weight: FontWeight.w600,
                  color: kTextColor,
                ),
                const SizedBox(height: 8),
                MyTextField(controller: _name, label: "Your Full Name"),
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
                const Divider(thickness: 0.5),
                const SizedBox(height: 10),
                MyText(
                  text: "DELIVERY INFORMATION",
                  size: 12,
                  weight: FontWeight.w600,
                  color: kTextColor,
                ),
                const SizedBox(height: 8),
                MyTextField(controller: _country, label: "Country"),
                MyTextField(
                  controller: _address,
                  label: "Address",
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}
