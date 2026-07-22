import 'package:castyourcare/view/screen/stores/delivery_infromation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/app_colors.dart';
import '../../../config/constants/app_sizes.dart';
import '../../../controller/store_controller.dart';
import '../../../generated/assets.dart';
import '../../custom/common_image_view_widget.dart';
import '../../custom/my_text_widget.dart';

class StoreCartScreen extends StatelessWidget {
  StoreCartScreen({super.key});

  final StoreController controller = Get.find<StoreController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSplashColor,
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
          ),
          child: Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Obx(
                  () => Column(
                    children: [
                      _totalRow("Items Total",
                          "\$${controller.itemsTotal.toStringAsFixed(2)}"),
                      const SizedBox(height: 15),
                      _totalRow("Delivery Fees",
                          "\$${(controller.cart.isEmpty ? 0.0 : StoreController.deliveryFee).toStringAsFixed(2)}"),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    if (controller.cart.isEmpty) {
                      Get.snackbar("Cart is empty",
                          "Add a product before continuing.",
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }
                    Get.to(() => DeliveryInfromationScreen());
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
                        text: "Continue",
                        size: 16,
                        weight: FontWeight.w600,
                        color: kQuaternaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
                  MyText(text: "Shopping Cart", size: 16, weight: FontWeight.w600),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (controller.cart.isEmpty) {
                    return Center(
                      child: MyText(
                        text: "Your cart is empty.",
                        size: 14,
                        color: kTextColor,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.cart.length,
                    itemBuilder: (context, index) {
                      final item = controller.cart[index];
                      return Dismissible(
                        key: Key(item.productId),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => controller.remove(item),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: ShapeDecoration(
                            color: kQuaternaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 103,
                                height: 103,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFF4F4F4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: item.imageUrl.isNotEmpty
                                    ? CommonImageView(
                                        url: item.imageUrl,
                                        radius: 15,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: item.name,
                                      size: 14,
                                      weight: FontWeight.w600,
                                    ),
                                    const SizedBox(height: 8),
                                    MyText(
                                      text: "\$${item.price.toStringAsFixed(2)}",
                                      size: 16,
                                      weight: FontWeight.w600,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () => controller.decrement(item),
                                          child: CommonImageView(
                                            imagePath: Assets.imagesMin,
                                            height: 32,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        MyText(
                                          text: item.quantity.toString(),
                                          size: 16,
                                          weight: FontWeight.w600,
                                        ),
                                        const SizedBox(width: 20),
                                        InkWell(
                                          onTap: () => controller.increment(item),
                                          child: CommonImageView(
                                            imagePath: Assets.imagesMax,
                                            height: 32,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _totalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(text: label, size: 16, weight: FontWeight.w600, color: kTextColor),
        MyText(text: value, size: 16, weight: FontWeight.w600),
      ],
    );
  }
}
