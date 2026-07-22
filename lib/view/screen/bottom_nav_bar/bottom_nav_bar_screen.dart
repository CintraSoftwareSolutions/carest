import 'package:castyourcare/config/constants/app_sizes.dart';
import 'package:castyourcare/view/screen/home/home_screen.dart';
import 'package:castyourcare/view/screen/stores/stores_screen.dart';
import 'package:castyourcare/view/screen/user_profile/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../config/constants/app_colors.dart';
import '../../../config/constants/app_fonts.dart';
import '../../../generated/assets.dart';
import '../../custom/common_image_view_widget.dart';
import '../../custom/my_text_widget.dart';

class BottomNavBarScreen extends StatelessWidget {
  final RxInt currentIndex = 0.obs;

  BottomNavBarScreen({super.key});

  final List<Map<String, dynamic>> items = [
    {
      'selected': Assets.imagesHome,
      'unselected': Assets.imagesHomeUs,
      'label': 'Home',
    },
    {
      'selected': Assets.imagesStore,
      'unselected': Assets.imagesStoreUs,
      'label': 'Store',
    },
    {
      'selected': Assets.imagesSetting,
      'unselected': Assets.imagesSettingUs,
      'label': 'Settings',
    },
  ];

  final List<Widget> screens = [
    HomeScreen(),
    StoresScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: screens[currentIndex.value],
        bottomNavigationBar: Container(
          height: 110,
          padding: AppSizes.HORIZONTAL,
          decoration: const BoxDecoration(
            color: kQuaternaryColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex.value,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: kPrimaryColor,
            onTap: (index) {
              currentIndex.value = index;
            },
            items: List.generate(items.length, (index) {
              final bool isSelected = currentIndex.value == index;
              final double iconSize = 27;

              return BottomNavigationBarItem(
                label: '',
                activeIcon: Column(
                  spacing: 3,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      isSelected
                          ? items[index]['selected']
                          : items[index]['unselected'],
                      width: iconSize,
                    ),

                    MyText(
                      text: items[index]['label'],
                      size: 14,
                      weight: FontWeight.w600,
                      color: kBlackColor,
                    ),
                  ],
                ),
                icon: Column(
                  spacing: 3,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(items[index]['unselected'], width: iconSize),
                    MyText(
                      text: items[index]['label'],
                      size: 14,
                      weight: FontWeight.w600,
                      color: kTextColor,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
