import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/constants/app_colors.dart';
import '../../../config/constants/app_sizes.dart';
import '../../../data/models/models.dart';
import '../../../data/services/user_repository.dart';
import '../../../generated/assets.dart';
import '../../custom/common_image_view_widget.dart';
import '../../custom/my_text_widget.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const SizedBox(width: 10),
                  MyText(text: "Notification", size: 16, weight: FontWeight.w600),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<List<AppNotification>>(
                  stream: UserRepository.to.notificationsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final items = snapshot.data ?? [];
                    if (items.isEmpty) return _emptyState();
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) => _tile(items[index]),
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

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonImageView(imagePath: Assets.imagesNotification, height: 90),
          const SizedBox(height: 16),
          MyText(
            text: "No Notifications Yet!",
            size: 16,
            weight: FontWeight.w600,
          ),
          const SizedBox(height: 6),
          MyText(
            text: "No Notifications is shown yet.",
            size: 13,
            weight: FontWeight.w500,
            color: kTextColor,
          ),
        ],
      ),
    );
  }

  Widget _tile(AppNotification n) {
    final time = DateFormat('h:mm a').format(n.createdAt);
    final letter = n.title.isNotEmpty ? n.title[0].toUpperCase() : 'C';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: ValueKey(n.id),
        direction: DismissDirection.endToStart,
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 30),
        ),
        onDismissed: (_) => UserRepository.to.deleteNotification(n.id),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: kQuaternaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: ShapeDecoration(
                  color: const Color(0x1934A853),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Center(
                  child: MyText(
                    text: letter,
                    size: 14,
                    weight: FontWeight.w600,
                    color: kGreenColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: n.title,
                      size: 14,
                      weight: FontWeight.w600,
                      color: kBlackColor,
                    ),
                    const SizedBox(height: 5),
                    MyText(
                      text: n.body,
                      size: 12,
                      weight: FontWeight.w500,
                      color: kTextColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              MyText(
                text: time,
                size: 12,
                weight: FontWeight.w500,
                color: kTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
