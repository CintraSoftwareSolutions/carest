import 'package:castyourcare/config/constants/app_sizes.dart';
import 'package:castyourcare/view/custom/common_image_view_widget.dart';
import 'package:castyourcare/view/custom/my_button.dart';
import 'package:castyourcare/view/custom/my_text_widget.dart';
import 'package:castyourcare/view/screen/auth/welcome2_screen.dart';
import 'package:castyourcare/view/screen/donation/donation_screen.dart';
import 'package:castyourcare/view/screen/notification/notification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/app_colors.dart';
import '../../../data/services/user_repository.dart';
import '../../../generated/assets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F0),
      body: SafeArea(
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesCarest,
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => NotificationScreen());
                    },
                    child: CommonImageView(
                      imagePath: Assets.imagesBell,
                      height: 50,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: UserRepository.to.userStream(),
                builder: (context, snapshot) {
                  final count =
                      (snapshot.data?.data()?['burdensReleased'] ?? 0) as int;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: "🌿 $count burdens released",
                        size: 20,
                        weight: FontWeight.w600,
                      ),
                      const SizedBox(height: 5),
                      MyText(
                        text: count == 0
                            ? "Your journey of letting go starts here."
                            : "You’ve been letting go consistently!",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kTextColor,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              Stack(
                children: [
                  CommonImageView(imagePath: Assets.imagesFl),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonImageView(svgPath: Assets.svgFlower),
                          const Spacer(),
                          MyText(
                            text: "Find peace in letting go",
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                          const SizedBox(height: 5),
                          MyText(
                            text:
                                "Release your worries through a simple moment of reflection and faith.",
                            size: 12,
                            weight: FontWeight.w500,
                          ),
                          const Spacer(),
                          MyButton(
                            onTap: () {
                              // Option 1: replay the cast-release flow
                              // (scripture → what's in your heart → release).
                              Get.to(() => Welcome2Screen());
                            },
                            buttonText: "Begin Casting Your Care",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Stack(
                children: [
                  CommonImageView(imagePath: Assets.imagesHd),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonImageView(svgPath: Assets.svgHand),
                          const Spacer(),
                          MyText(
                            text: "Support this space",
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                          const SizedBox(height: 5),
                          MyText(
                            text:
                                "This app is free for everyone. Your support helps us keep it that way.",
                            size: 12,
                            weight: FontWeight.w500,
                          ),
                          const Spacer(),
                          MyButton(
                            backgroundColor: kGreenColor,
                            onTap: () {
                              Get.to(() => DonationScreen());
                            },
                            buttonText: "Donate Now",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
