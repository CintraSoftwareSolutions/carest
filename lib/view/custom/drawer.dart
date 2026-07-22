/*
import 'dart:ui';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
        color: KBlueText,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        AnimatedRow(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(28.0),
                                    child: CommonImageView(
                                        imagePath: Assets.imagesPf),
                                  ),
                                ),
                                MyText(
                                  text: "SmuelSmith".tr,
                                  size: 18,
                                  weight: FontWeight.w600,
                                  color: kWhite,
                                  fontFamily: AppFonts.Manrope,
                                ),
                                Gap(5),
                                MyText(
                                  text: "Smuel123gmailcom".tr,
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: kWhite,
                                  fontFamily: AppFonts.Manrope,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDrawerItem(
                          "Edit Profile",
                          Assets.imagesEditProfile,
                          () {
                           Get.to(() => EditProfileScreen());
                          },
                        ),
                        _buildDrawerItem(
                          "Change Password",
                         Assets.imagesChangePassword,
                          () {
                            Get.to(() => ChangePasswordScreen());
                            //SubscriptionBottomSheet(context);
                          },
                        ),
                        _buildDrawerItem(
                          "Notification settings",
                          Assets.imagesNotificationSetting,
                          () {
                            Get.to(() => NotificationSettingScreen());
                          },
                        ),
                        _buildDrawerItem(
                          "Privacy & Policy",
                           Assets.imagesPrivacyPolicy,
                          () {
                           Get.to(() => PrivacyPolicyScreen());
                          },
                        ),
                        _buildDrawerItem(
                          "Terms & Conditions",
                           Assets.imagesTermConditions,
                          () {
                           Get.to(() => TermAndConditionsScreen());
                          },
                        ),
                        _buildDrawerItem(
                          "Installments Status",
                           Assets.imagesInstallmentStatus,
                          () {
                           Get.to(() => InstallmentStatusScreen());
                          },
                        ),
                        _buildDrawerItem(
                          "Delete Account",
                           Assets.imagesDeleteAccount,
                          () {
                            DialogHelper.deleteDialog(context);
                          },
                        ),
                        _buildDrawerItem(
                          "Logout".tr,
                           Assets.imagesLogout,
                          () {
                            DialogHelper.LogOutDialog(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    String title,
    String icon,
    VoidCallback ontap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Bounce(
        onTap: ontap,
        duration: Duration(milliseconds: 200),
        child: Container(
          //height: 44,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25), color: kbackground),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
         // margin: const EdgeInsets.symmetric(horizontal: 10),
          child: AnimatedRow(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonImageView(
                imagePath: icon,
                height: 30,
              ),
              MyText(
                paddingLeft: 6,
                text: title,
                size: 11,
                weight: FontWeight.w600,
                color: kBlackLight,
                fontFamily: AppFonts.Manrope,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void SubscriptionBottomSheet(BuildContext context) {
  Get.bottomSheet(
    isScrollControlled: false,
    Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: kbackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: "UpgradeToMaker".tr,
            size: 14,
            paddingTop: 27,
            textAlign: TextAlign.start,
            weight: FontWeight.w800,
            color: kBlackText,
          ),
          MyText(
            text: "GainAccessToUnlimitedFilamentsSpoolsAnPrints".tr,
            size: 14,
            paddingTop: 8,
            paddingBottom: 16,
            textAlign: TextAlign.start,
            weight: FontWeight.w600,
            color: kBlackText,
          ),
          Container(
            padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
            decoration: BoxDecoration(
              color: kbackground,
              border: Border.all(color: kBorderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              spacing: 10,
              children: [
                AnimatedRow(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: "MakerMonthly".tr,
                      size: 16,
                      weight: FontWeight.w800,
                    ),
                    MyText(
                      text: "50".tr,
                      size: 14,
                      weight: FontWeight.w800,
                    ),
                  ],
                ),
                AnimatedRow(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: "CreateUnlimitedFilamentsnspoolsAndPrints".tr,
                      size: 12,
                      textOverflow: TextOverflow.fade,
                      weight: FontWeight.w600,
                    ),
                    MyButton(
                      height: 33,
                      width: 88,
                      fontWeight: FontWeight.w400,
                      hasgrad: true,
                      onTap: () {
                        Get.to(() => CardScreen());
                      },
                      buttonText: "Buy".tr,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
            decoration: BoxDecoration(
              color: kbackground,
              border: Border.all(color: kBorderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              spacing: 10,
              children: [
                AnimatedRow(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: "MakerYearly".tr,
                      size: 16,
                      weight: FontWeight.w800,
                    ),
                    MyText(
                      text: "1000".tr,
                      size: 14,
                      weight: FontWeight.w800,
                    ),
                  ],
                ),
                AnimatedRow(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: "CreateUnlimitedFilamentsnspoolsAndPrints".tr,
                      size: 12,
                      textOverflow: TextOverflow.fade,
                      weight: FontWeight.w600,
                    ),
                    MyButton(
                      height: 33,
                      width: 88,
                      fontWeight: FontWeight.w400,
                      hasgrad: true,
                      onTap: () {
                        Get.to(() => CardScreen());
                      },
                      buttonText: "Buy".tr,
                    ),
                  ],
                ),
              ],
            ),
          ),
          MyText(
            text: "SubscriptionAutomaticallyRenewed".tr,
            size: 10,
            paddingTop: 16,
            paddingBottom: 16,
            textAlign: TextAlign.start,
            weight: FontWeight.w400,
            color: kPurple,
          ),
        ],
      ),
    ),
  );
}
*/
