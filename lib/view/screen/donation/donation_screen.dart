import 'package:castyourcare/config/constants/app_sizes.dart';
import 'package:castyourcare/view/custom/my_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/app_colors.dart';
import '../../../data/services/content_repository.dart';
import '../../../data/services/user_repository.dart';
import '../../../generated/assets.dart';
import '../../custom/common_image_view_widget.dart';
import '../../custom/my_text_widget.dart';
import 'donation_bottom_sheet/donation_bottom_sheet.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final TextEditingController _amountController = TextEditingController();
  List<int> _suggestions = [5, 10, 15, 20, 25];

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    try {
      final s = await ContentRepository.to.getDonationSuggestions();
      if (s.isNotEmpty && mounted) setState(() => _suggestions = s);
    } catch (_) {}
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount {
    final raw = _amountController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(raw) ?? 0;
  }

  void _donate() {
    final amount = _amount;
    if (amount <= 0) {
      Get.snackbar(
        "Enter an amount",
        "Please enter or pick a donation amount to continue.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    DonationBottomSheet.selectPaymentSheet(
      amount: amount,
      onComplete: (method) {
        return UserRepository.to.recordDonation(amount: amount, method: method);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSizes.HORIZONTAL,
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
                  MyText(
                    text: "Send Donations",
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              MyText(text: "Support Carest", size: 24, weight: FontWeight.w600),
              const SizedBox(height: 10),
              MyText(
                text:
                    "This app is free for everyone. Your support help us maintain and grow this space of Faith",
                size: 14,
                weight: FontWeight.w500,
                color: kTextColor,
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: _amountController,
                label: "Enter Amount",
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => setState(() {}),
              ),
              MyText(
                text: "SUGGESTIONS",
                size: 14,
                weight: FontWeight.w500,
                color: kTextColor,
              ),
              const SizedBox(height: 7),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _suggestions.map((price) {
                  final selected = _amount == price.toDouble();
                  return GestureDetector(
                    onTap: () {
                      setState(() => _amountController.text = price.toString());
                    },
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: ShapeDecoration(
                        color: selected
                            ? const Color(0x199CAF88)
                            : kQuaternaryColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: selected
                                ? const Color(0xFFA7B78F)
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: MyText(
                          text: "\$$price",
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _donate,
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
                      text: "Donate Now",
                      size: 16,
                      weight: FontWeight.w600,
                      color: kQuaternaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
