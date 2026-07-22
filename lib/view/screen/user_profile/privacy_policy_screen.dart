import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/app_colors.dart';
import '../../../config/constants/app_sizes.dart';
import '../../../data/models/models.dart';
import '../../../data/services/content_repository.dart';
import '../../../generated/assets.dart';
import '../../custom/common_image_view_widget.dart';
import '../../custom/my_text_widget.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalDocView(
      titleFallback: "Privacy Policy",
      which: "privacy",
    );
  }
}

/// Shared legal-document viewer used by Privacy Policy and Terms & Conditions.
class LegalDocView extends StatelessWidget {
  final String which;
  final String titleFallback;

  const LegalDocView({
    super.key,
    required this.which,
    required this.titleFallback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSplashColor,
      body: SafeArea(
        child: FutureBuilder<LegalDoc>(
          future: ContentRepository.to.getLegal(which),
          builder: (context, snapshot) {
            final doc = snapshot.data;
            return SingleChildScrollView(
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
                          text: doc?.title ?? titleFallback,
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    if (doc == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else ...[
                      MyText(
                        text: doc.lastUpdated,
                        size: 14,
                        weight: FontWeight.w600,
                        color: kTextColor,
                      ),
                      const SizedBox(height: 10),
                      ...doc.sections.expand((s) => [
                            MyText(text: s.heading, size: 18),
                            const SizedBox(height: 5),
                            MyText(
                              text: s.body,
                              size: 14,
                              weight: FontWeight.w500,
                              color: kTextColor,
                              lineHeight: 1.5,
                            ),
                            const SizedBox(height: 15),
                          ]),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
