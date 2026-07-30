import 'package:castyourcare/view/screen/stores/store_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/constants/app_colors.dart';
import '../../../config/constants/app_sizes.dart';
import '../../../controller/store_controller.dart';
import '../../../data/models/models.dart';
import '../../../generated/assets.dart';
import '../../custom/common_image_view_widget.dart';
import '../../custom/my_text_widget.dart';


class StoreProductDetailScreen extends StatelessWidget {
  final Product product;

  const StoreProductDetailScreen({super.key, required this.product});

  Future<void> _openStore() async {
    if (product.storeUrl.isEmpty) return;
    final uri = Uri.tryParse(product.storeUrl);
    if (uri == null) return;
    // Launch directly — canLaunchUrl() returns false on Android 11+ without
    // <queries> declared, which would silently block a valid https URL.
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar(
        "Couldn't open store",
        "Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSplashColor,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: GestureDetector(
            onTap: () async {
              await StoreController.to.addToCart(product);
              Get.to(() => StoreCartScreen());
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
                  text: "Add to Cart",
                  size: 16,
                  weight: FontWeight.w600,
                  color: kQuaternaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 15,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                        child: CommonImageView(imagePath: Assets.imagesBackArrow,height: 45,)),
                    MyText(
                      text: "Product Details",
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                    Spacer(),
                    CommonImageView(imagePath: Assets.imagesLike,height: 45,),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  height: 325,
                  padding: AppSizes.DEFAULT,
                  decoration: ShapeDecoration(
                    color: kQuaternaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (product.imageUrl.isNotEmpty)
                        Center(
                          child: CommonImageView(
                            url: product.imageUrl,
                            height: 260,
                          ),
                        ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 13),
                          decoration: ShapeDecoration(
                            color: const Color(0x219CAF88),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            children: [
                              CommonImageView(svgPath: Assets.svgShopify),
                              const SizedBox(width: 10),
                              Expanded(
                                child: MyText(
                                  text: product.storeName,
                                  size: 14,
                                  weight: FontWeight.w600,
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _openStore(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 11),
                                  decoration: ShapeDecoration(
                                    color: kQuaternaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: MyText(
                                    text: "View Store",
                                    size: 12,
                                    weight: FontWeight.w600,
                                    color: kGreenColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                MyText(text: product.title, size: 24, weight: FontWeight.w600),
                const SizedBox(height: 10),
                MyText(
                  text: product.priceLabel,
                  size: 18,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 10),
                MyText(
                  text: product.description,
                  size: 14,
                  weight: FontWeight.w600,
                  color: kTextColor,
                  lineHeight: 1.5,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
