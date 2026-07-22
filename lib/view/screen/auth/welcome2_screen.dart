import 'package:castyourcare/config/constants/app_sizes.dart';
import 'package:castyourcare/view/custom/common_image_view_widget.dart';
import 'package:castyourcare/view/custom/my_button.dart';
import 'package:castyourcare/view/custom/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/app_colors.dart';
import '../../../data/services/content_repository.dart';
import '../../../generated/assets.dart';
import 'auth_bottom_sheet/auth_bottom_sheet_screen.dart';

class Welcome2Screen extends StatelessWidget {
  Welcome2Screen({super.key});

  final Welcome2Controller controller = Get.put(Welcome2Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesWcbg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              children: [
                const SizedBox(height: 20),
                CommonImageView(
                  imagePath: Assets.imagesCarest,
                  height: 90,
                ),
                const SizedBox(height: 30),

                Obx(
                      () => AnimatedOpacity(
                    duration: const Duration(milliseconds: 900),
                    opacity: controller.textOpacity.value,
                    child: Column(
                      children: [
                        MyText(
                          text: controller.currentVerse.value,
                          textAlign: TextAlign.center,
                          size: 16,
                          weight: FontWeight.w600,
                          color: kBlackLightColor,
                          lineHeight: 1.5,
                        ),
                        const SizedBox(height: 10),
                        MyText(
                          text: controller.currentReference.value,
                          textAlign: TextAlign.center,
                          size: 16,
                          weight: FontWeight.w700,
                          color: const Color(0xFF9CAF88),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                buildInfoCard(
                  onTap: () {},
                  title: "Release what weighs on your heart.",
                  iconPath: Assets.svgHeart,
                ),
                const SizedBox(height: 10),
                buildInfoCard(
                  onTap: () {},
                  title: "You don’t have to carry it alone.",
                  iconPath: Assets.svgProfile,
                ),
                const SizedBox(height: 10),
                buildInfoCard(
                  onTap: () {},
                  title: "Give your worries to God",
                  iconPath: Assets.svgT,
                ),
                const SizedBox(height: 80),

                MyButton2(
                  onTap: () {
                    AuthBottomSheetScreen.selectCastCareSheet();
                  },
                  buttonText: "Start",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required VoidCallback onTap,
    required String title,
    required String iconPath,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: ShapeDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonImageView(svgPath: iconPath),
            const SizedBox(height: 10),
            MyText(
              text: title,
              size: 16,
              weight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

class Welcome2Controller extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxDouble textOpacity = 0.0.obs;

  final RxString currentVerse = ''.obs;
  final RxString currentReference = ''.obs;

  bool _disposed = false;

  List<Map<String, String>> verses = [
    {
      "verse":
      "Humble yourselves, therefore, under the mighty hand of God, so that he may exalt you at the proper time, casting all your cares on him, because he cares about you.",
      "reference": "1 Peter 5:7",
    },
    {
      "verse":
      "Cast your cares on the Lord and he will sustain you; he will never let the righteous be shaken.",
      "reference": "Psalms 55:22",
    },
    {
      "verse":
      "Jesus invites those burdened by life to come to Him for rest, promising that His yoke is easy and His burden is light.",
      "reference": "Matthew 11:28–30",
    },
    {
      "verse":
      "Carry each other’s burdens, and in this way you will fulfill the law of Christ.",
      "reference": "Galatians 6:2",
    },
    {
      "verse":
      "Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.",
      "reference": "Philippians 4:6–7",
    },
    {
      "verse":
      "Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight.",
      "reference": "Proverbs 3:5–6",
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _loadScriptures();
    _startVerseLoop();
  }

  Future<void> _loadScriptures() async {
    try {
      final scriptures = await ContentRepository.to.getScriptures();
      if (scriptures.isNotEmpty) {
        verses = scriptures
            .map((s) => {'verse': s.text, 'reference': s.reference})
            .toList();
        currentIndex.value = 0;
      }
    } catch (_) {
      // keep hardcoded fallback
    }
  }

  Future<void> _startVerseLoop() async {
    while (!_disposed) {
      final item = verses[currentIndex.value];

      currentVerse.value = item["verse"] ?? '';
      currentReference.value = item["reference"] ?? '';

      textOpacity.value = 0.0;
      await Future.delayed(const Duration(milliseconds: 200));
      if (_disposed) return;

      // fade in
      textOpacity.value = 1.0;

      // stay visible longer
      await Future.delayed(const Duration(seconds: 8));
      if (_disposed) return;

      // fade out
      textOpacity.value = 0.0;
      await Future.delayed(const Duration(milliseconds: 600));
      if (_disposed) return;

      currentIndex.value = (currentIndex.value + 1) % verses.length;
    }
  }

  @override
  void onClose() {
    _disposed = true;
    super.onClose();
  }
}