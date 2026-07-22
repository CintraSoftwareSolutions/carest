import 'package:castyourcare/config/constants/app_sizes.dart';
import 'package:castyourcare/view/custom/common_image_view_widget.dart';
import 'package:castyourcare/view/custom/my_button.dart';
import 'package:castyourcare/view/custom/my_text_widget.dart';
import 'package:castyourcare/view/screen/auth/welcome2_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../config/constants/app_colors.dart';
import '../../../generated/assets.dart';



class WelcomeScreen extends StatelessWidget {
   WelcomeScreen({super.key});


  final List<String> onBoardingImages = [
    Assets.imagesGroup1,
    Assets.imagesGroup2,
    Assets.imagesGroup3,

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: Column(
            children: [
              const SizedBox(height: 20),
              CommonImageView(imagePath: Assets.imagesCarest,height: 90,),
               Spacer(),
              CommonImageView(imagePath: Assets.imagesGroup1,),
              Spacer(),
              SizedBox(height: 20,),
              MyText(text: "Welcome to Carest",
                textAlign: TextAlign.center,
                size: 28,
                weight: FontWeight.w600,

              ),
              SizedBox(height: 10,),
              MyText(text: "When life feels heavy, tell God what’s on your heart\nand cast your cares on Him.\n"
                  "Your cares and prayers are never stored in this app.",
                textAlign: TextAlign.center,
                size: 14,
                weight: FontWeight.w500,
                lineHeight: 1.71,
                color: kTextColor,

              ),
              Spacer(),
              MyButton2(onTap: (){
                Get.to(()=> Welcome2Screen());
              }, buttonText: "Begin"),
              SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }
}
