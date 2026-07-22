import 'package:castyourcare/config/constants/app_sizes.dart';
import 'package:castyourcare/view/custom/common_image_view_widget.dart';
import 'package:castyourcare/view/custom/my_text_widget.dart';
import 'package:castyourcare/view/custom/my_textfeild.dart';
import 'package:castyourcare/view/screen/stores/store_product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/app_colors.dart';
import '../../../controller/store_controller.dart';
import '../../../data/models/models.dart';
import '../../../generated/assets.dart';

class StoresScreen extends StatelessWidget {
  StoresScreen({super.key});

  final StoreController controller = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSplashColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Cast Your Cares Shop",
                            size: 24,
                            weight: FontWeight.w600,
                          ),
                          const SizedBox(height: 5),
                          MyText(
                            text: "Not just items. It’s a declaration.",
                            size: 14,
                            weight: FontWeight.w500,
                            color: kTextColor,
                          ),
                        ],
                      ),
                    ),
                    CommonImageView(imagePath: Assets.imagesWifi, height: 45),
                  ],
                ),
                const SizedBox(height: 20),
                MyTextField3(
                  hint: "Search for products ...",
                  onChanged: (v) => controller.search.value = v,
                  prefix: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CommonImageView(svgPath: Assets.svgSearch),
                  ),
                ),
                Obx(() {
                  if (controller.loadingProducts.value) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final items = controller.filteredProducts;
                  if (items.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Center(
                        child: MyText(
                          text: "No products found.",
                          size: 14,
                          color: kTextColor,
                        ),
                      ),
                    );
                  }
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(items.length, (index) {
                      final product = items[index];
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 26,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() =>
                                StoreProductDetailScreen(product: product));
                          },
                          child: _productCard(product),
                        ),
                      );
                    }),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _productCard(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 178,
          width: double.infinity,
          padding: AppSizes.DEFAULT,
          decoration: ShapeDecoration(
            color: kQuaternaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Stack(
            children: [
              if (product.imageUrl.isNotEmpty)
                Center(
                  child: CommonImageView(
                    url: product.imageUrl,
                    height: 150,
                  ),
                ),
              const Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.favorite_border),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        MyText(text: product.title, size: 14, weight: FontWeight.w600),
        const SizedBox(height: 5),
        MyText(
          text: product.shortDesc,
          size: 12,
          weight: FontWeight.w500,
          color: kTextColor,
          maxLines: 2,
        ),
        const SizedBox(height: 5),
        MyText(text: product.priceLabel, size: 16, weight: FontWeight.w600),
      ],
    );
  }
}
