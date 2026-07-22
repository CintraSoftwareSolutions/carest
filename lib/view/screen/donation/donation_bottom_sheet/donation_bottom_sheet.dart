import 'package:castyourcare/view/custom/common_image_view_widget.dart';
import 'package:castyourcare/view/custom/my_textfeild.dart';
import 'package:castyourcare/view/screen/bottom_nav_bar/bottom_nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../generated/assets.dart';
import '../../../custom/my_text_widget.dart';

class DonationBottomSheet {
  static String _amountLabel(double amount) =>
      amount > 0 ? '\$${amount.toStringAsFixed(2)}' : '\$9.99';

  static void selectPaymentSheet({
    double amount = 0,
    AsyncValueSetter<String>? onComplete,
  }) {
    Get.bottomSheet(
      Container(
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
              onTap: () {
                Get.back();
              },
              child: Row(
                spacing: 3,
                children: [
                  Icon(Icons.arrow_back, size: 18),
                  MyText(text: "Back", size: 14, weight: FontWeight.w600),
                ],
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: MyText(
                text: "Select Payment",
                size: 20,
                weight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.center,
              child: MyText(
                text: "Please select the preferred payment method.",
                size: 14,
                weight: FontWeight.w600,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 20),
            DonationOneBottomSheet(),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Get.back();
                final method = PaymentMethodController.to.selectedMethodLabel;
                DonationBottomSheet.applePaySheet(
                  amount: amount,
                  onComplete: onComplete,
                  method: method,
                );
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
                    text: "Confirm",
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

  static void paymentSuccessBottomSheet({
    bool isOrder = false,
    bool returnHome = true,
  }) {
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
            CommonImageView(
              imagePath: Assets.imagesPaymentsuccess,
              height: 150,
            ),
            const SizedBox(height: 40),
            MyText(
              text: isOrder ? "Order Placed" : "Payment Sent",
              size: 24,
              weight: FontWeight.w600,
            ),
            SizedBox(height: 5),
            MyText(
              text: isOrder
                  ? "Your order is complete. Thank you!\nYour confirmation will be sent shortly."
                  : "Thank you for your donation. Your support\nhelps move our mission forward.",
              size: 16,
              weight: FontWeight.w500,
              color: kTextColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Get.back();
                if (returnHome) {
                  Get.offAll(() => BottomNavBarScreen());
                }
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
                    text: "Return Home",
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

  static void cardInformationSheet({
    double amount = 0,
    AsyncValueSetter<String>? onComplete,
    bool isOrder = false,
    String method = 'Debit/Credit Card',
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: kSplashColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 3,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back, size: 18),
                ),
                MyText(text: "Back", size: 14, weight: FontWeight.w600),
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: MyText(
                text: "Enter Card Information",
                size: 20,
                weight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.center,
              child: MyText(
                text:
                    "Please enter the card information\nmention on your debit or credit card.",
                size: 14,
                weight: FontWeight.w600,
                color: kTextColor,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            MyTextField3(
              label: "Card Number",
              hint: "**** - **** - **** - *",
              suffix: Padding(
                padding: const EdgeInsets.all(10),
                child: CommonImageView(svgPath: Assets.svgMaster),
              ),
            ),
            MyTextField3(label: "Card Holder Name", hint: "e.g. kevin backer"),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: MyTextField3(label: "Expiry Date", hint: "MM/YYYY"),
                ),
                Expanded(
                  child: MyTextField3(label: "CVV", hint: "e.g. 123"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                Get.back();
                // Demo payment success: record the transaction, then confirm.
                await onComplete?.call(method);
                DonationBottomSheet.paymentSuccessBottomSheet(isOrder: isOrder);
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
                    text: "Confirm",
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

  static void applePaySheet({
    double amount = 0,
    AsyncValueSetter<String>? onComplete,
    bool isOrder = false,
    String method = 'Debit/Credit Card',
  }) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          height: Get.height * 0.58,
          decoration: const BoxDecoration(
            color: Color(0xFFF3F3F3),
            borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header
                      Row(
                        children: [
                          CommonImageView(
                            imagePath: Assets.imagesApple,
                            height: 28,
                          ),
                          const SizedBox(width: 4),
                          MyText(
                            text: "Pay",
                            size: 22,
                            weight: FontWeight.w600,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// Apple Card
                      _infoCard(
                        leading: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFEED9A4),
                                Color(0xFFF7C3A4),
                                Color(0xFFC5B7FF),
                                Color(0xFFBCE3A8),
                              ],
                            ),
                          ),
                        ),
                        title: "Demo Card",
                        subtitle: "Carest test checkout",
                        trailingTop: "•••• 4242",
                      ),

                      const SizedBox(height: 12),

                      /// Contact
                      _infoCard(
                        leading: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                        title: "Contact",
                        subtitle: "support@carest.app",
                        trailingTop: "(123) 456-7890",
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              /// Amount section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                decoration: const BoxDecoration(
                  color: Color(0xFFF7F7F7),
                  border: Border(
                    top: BorderSide(color: Color(0xFFD7D7D7), width: 0.8),
                    bottom: BorderSide(color: Color(0xFFD7D7D7), width: 0.8),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: isOrder
                                ? "Place demo order"
                                : "Send demo donation",
                            size: 14,
                            weight: FontWeight.w500,
                            color: const Color(0xFF8A8A8A),
                          ),
                          const SizedBox(height: 6),
                          MyText(
                            text: _amountLabel(amount),
                            size: 26,
                            weight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 30,
                      color: Color(0xFF8A8A8A),
                    ),
                  ],
                ),
              ),

              /// Confirm section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 22, bottom: 12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        cardInformationSheet(
                          amount: amount,
                          onComplete: onComplete,
                          isOrder: isOrder,
                          method: method,
                        );
                      },
                      child: CommonImageView(svgPath: Assets.svgSideButton),
                    ),
                    const SizedBox(height: 10),
                    MyText(
                      text: "Confirm with Side Button",
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  static Widget _infoCard({
    required Widget leading,
    required String title,
    required String subtitle,
    required String trailingTop,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: title,
                  size: 14,
                  weight: FontWeight.w500,
                  color: const Color(0xFF8A8A8A),
                ),
                const SizedBox(height: 4),
                MyText(
                  text: subtitle,
                  size: 15,
                  weight: FontWeight.w600,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                MyText(
                  text: trailingTop,
                  size: 13,
                  weight: FontWeight.w500,
                  color: const Color(0xFF555555),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Color(0xFF9A9A9A), size: 28),
        ],
      ),
    );
  }
}

class PaymentMethodController extends GetxController {
  static PaymentMethodController get to => Get.find();

  RxInt selectedIndex = 0.obs;

  void selectMethod(int index) {
    selectedIndex.value = index;
  }

  String get selectedMethodLabel {
    switch (selectedIndex.value) {
      case 1:
        return 'Apple Pay';
      case 2:
        return 'Google Pay';
      case 3:
        return 'American Express';
      default:
        return 'Debit/Credit Card';
    }
  }
}

class DonationOneBottomSheet extends StatelessWidget {
  DonationOneBottomSheet({super.key});

  final PaymentMethodController controller = Get.put(PaymentMethodController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _paymentCard(
                index: 0,
                title: "Debit/Credit Card",
                icon: Assets.imagesCard, // apna card icon
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _paymentCard(
                index: 1,
                title: "Apple Pay",
                icon: Assets.imagesApple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _paymentCard(
                index: 2,
                title: "Google Pay",
                icon: Assets.imagesGooglr,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _paymentCard(
                index: 3,
                title: "American Express",
                icon: Assets.imagesAmericanExpress,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _paymentCard({
    required int index,
    required String title,
    required String icon,
  }) {
    return Obx(() {
      final bool isSelected = controller.selectedIndex.value == index;

      return GestureDetector(
        onTap: () => controller.selectMethod(index),
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Color(0x199CAF88) : kQuaternaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFA7B78F) : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonImageView(imagePath: icon, height: 17),
                  if (isSelected)
                    Container(
                      height: 22,
                      width: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFFA7B78F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              MyText(text: title, size: 14, weight: FontWeight.w600),
            ],
          ),
        ),
      );
    });
  }
}
