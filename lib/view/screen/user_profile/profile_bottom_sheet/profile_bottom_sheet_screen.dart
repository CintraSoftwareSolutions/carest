import 'package:castyourcare/view/custom/common_image_view_widget.dart';
import 'package:castyourcare/view/splash_service/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../data/services/session_service.dart';
import '../../../../generated/assets.dart';
import '../../../custom/my_text_widget.dart';



class ProfileBottomSheetScreen {
  static void logoutBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kSplashColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            CommonImageView(imagePath: Assets.imagesLogout,height: 150,),
            const SizedBox(height: 40),
            MyText(
              text: "Logout?",
              size: 24,
              weight: FontWeight.w600,
            ),
            SizedBox(height: 5,),
            MyText(
              text: "Are you sure want to logout from this app?",
              size: 16,
              weight: FontWeight.w500,
              color: kTextColor,
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () async {
                Get.back();
                // No accounts: "logout" starts a fresh anonymous session /
                // device identity, then returns to the splash flow.
                await SessionService.to.resetIdentity();
                Get.offAll(() => const SplashScreen());
              },
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
                    text: "Yes, Logout",
                    size: 16,
                    weight: FontWeight.w600,
                    color: kQuaternaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}