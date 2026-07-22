import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/app_colors.dart';
import '../../../config/constants/app_sizes.dart';
import '../../../controller/store_controller.dart';
import '../../../data/services/user_repository.dart';
import '../../../generated/assets.dart';
import '../../custom/common_image_view_widget.dart';
import '../../custom/my_text_widget.dart';
import '../donation/donation_bottom_sheet/donation_bottom_sheet.dart';

class CheckOutScreen extends StatelessWidget {
  CheckOutScreen({super.key});

  final StoreController controller = Get.find<StoreController>();

  Future<void> _pay() async {
    final items = List.of(controller.cart);
    final itemsTotal = controller.itemsTotal;
    final total = controller.total;
    final deliveryInfo = await UserRepository.to.getDeliveryInfo();

    DonationBottomSheet.selectPaymentSheet(
      amount: total,
      onComplete: (_) async {
        await UserRepository.to.placeOrder(
          items: items,
          itemsTotal: itemsTotal,
          deliveryFee: StoreController.deliveryFee,
          deliveryInfo: deliveryInfo,
        );
        await controller.clearCartAfterOrder();
      },
    );
  }

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
                      _row(
                        "Items Total",
                        "\$${controller.itemsTotal.toStringAsFixed(2)}",
                      ),
                      const SizedBox(height: 15),
                      _row(
                        "Delivery Fees",
                        "\$${(controller.cart.isEmpty ? 0.0 : StoreController.deliveryFee).toStringAsFixed(2)}",
                      ),
                      const SizedBox(height: 5),
                      const Divider(thickness: 0.5),
                      const SizedBox(height: 5),
                      _row(
                        "Total Amount",
                        "\$${controller.total.toStringAsFixed(2)}",
                        bold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: _pay,
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
                        text: "Continue to Payment",
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
      body: SingleChildScrollView(
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
                    MyText(text: "Checkout", size: 16, weight: FontWeight.w600),
                  ],
                ),
                const SizedBox(height: 20),
                MyText(
                  text: "ADDRESS INFORMATION",
                  size: 12,
                  weight: FontWeight.w500,
                  color: kTextColor,
                ),
                const SizedBox(height: 10),
                FutureBuilder<Map<String, dynamic>>(
                  future: UserRepository.to.getDeliveryInfo(),
                  builder: (context, snapshot) {
                    final info = snapshot.data ?? {};
                    final country =
                        (info['country'] ?? 'Your location') as String;
                    final address =
                        (info['address'] ?? 'Add your delivery address')
                            as String;
                    return _addressCard(country, address);
                  },
                ),
                const SizedBox(height: 20),
                MyText(
                  text: "PRODUCT INFORMATION",
                  size: 12,
                  weight: FontWeight.w500,
                  color: kTextColor,
                ),
                const SizedBox(height: 10),
                Obx(
                  () => ListView.builder(
                    itemCount: controller.cart.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = controller.cart[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: ShapeDecoration(
                                    color: kQuaternaryColor,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                        text: item.name,
                                        size: 14,
                                        weight: FontWeight.w600,
                                      ),
                                      const SizedBox(height: 4),
                                      MyText(
                                        text:
                                            "Quantity : ${item.quantity.toString().padLeft(2, '0')}",
                                        size: 12,
                                        weight: FontWeight.w600,
                                        color: kTextColor,
                                      ),
                                      const SizedBox(height: 12),
                                      MyText(
                                        text:
                                            "\$${item.lineTotal.toStringAsFixed(2)}",
                                        size: 16,
                                        weight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Divider(thickness: 0.5),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(
          text: label,
          size: 16,
          weight: FontWeight.w600,
          color: bold ? null : kTextColor,
        ),
        MyText(text: value, size: 16, weight: FontWeight.w600),
      ],
    );
  }

  Widget _addressCard(String country, String address) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: ShapeDecoration(
        color: kQuaternaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Row(
        children: [
          CommonImageView(imagePath: Assets.imagesLocation, height: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(text: country, size: 14, weight: FontWeight.w600),
                const SizedBox(height: 2),
                MyText(
                  text: address,
                  size: 14,
                  weight: FontWeight.w500,
                  color: kTextColor,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: MyText(
              text: "Edit",
              size: 14,
              weight: FontWeight.w600,
              decoration: TextDecoration.underline,
              color: const Color(0xFF9CAF88),
              decorationColor: const Color(0xFF9CAF88),
            ),
          ),
        ],
      ),
    );
  }
}
