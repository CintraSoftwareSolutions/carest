import 'package:castyourcare/config/constants/app_sizes.dart';
import 'package:castyourcare/view/custom/common_image_view_widget.dart';
import 'package:castyourcare/view/custom/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../data/services/content_repository.dart';
import '../../../generated/assets.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSplashColor,
      body: SafeArea(
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
                  MyText(text: "Help & Support", size: 16, weight: FontWeight.w600),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: FutureBuilder<List<Faq>>(
                  future: ContentRepository.to.getFaqs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final faqs = snapshot.data ?? [];
                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: faqs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 7),
                      itemBuilder: (context, index) => FaqCard(faq: faqs[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FaqCard extends StatefulWidget {
  final Faq faq;
  const FaqCard({super.key, required this.faq});

  @override
  State<FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: ShapeDecoration(
        color: kQuaternaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: MyText(text: widget.faq.question, size: 14)),
              InkWell(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Icon(isExpanded ? Icons.remove : Icons.add),
              ),
            ],
          ),
          if (isExpanded) ...[
            const SizedBox(height: 5),
            const Divider(thickness: 0.5),
            const SizedBox(height: 5),
            MyText(
              text: widget.faq.answer,
              size: 14,
              weight: FontWeight.w600,
              color: kTextColor,
            ),
          ],
        ],
      ),
    );
  }
}
