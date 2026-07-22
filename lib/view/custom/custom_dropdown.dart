// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:fedepr_3d_yume/constants/app_colors.dart';
// import 'package:fedepr_3d_yume/constants/app_fonts.dart';
// import 'package:fedepr_3d_yume/generated/assets.dart';
// import 'package:fedepr_3d_yume/view/widget/common_image_view_widget.dart';
// import 'package:fedepr_3d_yume/view/widget/custom_animated_row.dart';
// import 'package:fedepr_3d_yume/view/widget/my_text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get_utils/get_utils.dart';

// class CustomDropDown extends StatelessWidget {
//   const CustomDropDown({
//     super.key,
//     required this.hint,
//     required this.items,
//     required this.selectedValue,
//     required this.onChanged,
//     this.bgColor,
//     this.marginBottom,
//     this.width,
//     this.labelText,
//   });

//   final List<dynamic>? items;
//   final String selectedValue;
//   final ValueChanged<dynamic>? onChanged;
//   final String hint;
//   final String? labelText;
//   final Color? bgColor;
//   final double? marginBottom, width;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: marginBottom ?? 16,
//       ),
//       child: Animate(
//         effects: [
//           MoveEffect(
//             duration: Duration(milliseconds: 500),
//             begin: const Offset(20, 0),
//           )
//         ],
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             if (labelText != null)
//               Animate(
//                 effects: [
//                   MoveEffect(
//                     duration: Duration(milliseconds: 500),
//                     begin: const Offset(20, 0),
//                   )
//                 ],
//                 child: MyText(
//                   paddingBottom: 10,
//                   text: labelText!.tr,
//                   size: 16,
//                   fontFamily: AppFonts.Quicksand,
//                   textAlign: TextAlign.start,
//                   weight: FontWeight.w600,
//                 ),
//               ),
//             Animate(
//               effects: [
//                 MoveEffect(
//                   duration: Duration(milliseconds: 500),
//                   begin: const Offset(20, 0),
//                 )
//               ],
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton2(
//                   items: items!
//                       .map(
//                         (item) => DropdownMenuItem<dynamic>(
//                           value: item,
//                           child: MyText(
//                               text: item.tr,
//                               size: 14,
//                               color: kBlack,
//                               weight: FontWeight.w600,
//                               fontFamily: AppFonts.Quicksand),
//                         ),
//                       )
//                       .toList(),
//                   value: selectedValue == hint ? null : selectedValue,
//                   hint: MyText(
//                     text: hint.tr,
//                     size: 12,
//                     color: KSubText,
//                     textAlign: TextAlign.start,
//                     weight: FontWeight.w600,
//                   ),
//                   onChanged: onChanged,
//                   iconStyleData: const IconStyleData(
//                     icon: SizedBox(),
//                   ),
//                   isDense: true,
//                   isExpanded: true,
//                   customButton: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 6),
//                     height: 48,
//                     decoration: BoxDecoration(
//                       color: kWhite,
//                       border: Border.all(
//                         color: kWhite,
//                       ),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: AnimatedRow(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         MyText(
//                             text: selectedValue == hint.tr ? hint.tr : selectedValue,
//                             size: 14,
//                             color: kBlack,
//                             weight: FontWeight.w600,
//                             fontFamily: AppFonts.Quicksand),
//                         CommonImageView(
//                           imagePath: Assets.imagesArrowDown,
//                           height: 16,
//                         )
//                       ],
//                     ),
//                   ),
//                   menuItemStyleData: const MenuItemStyleData(
//                     height: 35,
//                   ),
//                   dropdownStyleData: DropdownStyleData(
//                     elevation: 6,
//                     maxHeight: 300,
//                     offset: const Offset(0, -5),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: kWhite),
//                         borderRadius: BorderRadius.circular(10),
//                         color: kWhite),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


/*import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../config/constants/app_colors.dart';
import '../../config/constants/app_fonts.dart';
import '../../generated/assets.dart';
import 'common_image_view_widget.dart';
import 'custom_animated_row.dart';
import 'my_text_widget.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.bgColor,
    this.marginBottom,
    this.width,
    this.labelText,
  });

  final List<String>? items;
  final String selectedValue;
  final ValueChanged<String>? onChanged;
  final String hint;
  final String? labelText;
  final Color? bgColor;
  final double? marginBottom, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: marginBottom ?? 16,
      ),
      child: Animate(
        effects: [
          MoveEffect(
            duration: Duration(milliseconds: 500),
            begin: const Offset(20, 0),
          )
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (labelText != null)
              Animate(
                effects: [
                  MoveEffect(
                    duration: Duration(milliseconds: 500),
                    begin: const Offset(20, 0),
                  )
                ],
                child: MyText(
                  paddingBottom: 6,
                  text: labelText!,
                  size: 14,
                  fontFamily: AppFonts.satoshi,
                  textAlign: TextAlign.start,
                  weight: FontWeight.w600,
                  color: kTextColor,
                ),
              ),
            Animate(
              effects: [
                MoveEffect(
                  duration: Duration(milliseconds: 500),
                  begin: const Offset(20, 0),
                )
              ],
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  items: items!
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: MyText(
                              text: item.tr, 
                              size: 14,
                              color: kBlackColor,
                              weight: FontWeight.w600,
                              fontFamily: AppFonts.satoshi),
                        ),
                      )
                      .toList(),
                  value: selectedValue == hint ? null : selectedValue,
                  hint: MyText(
                    text: hint.tr,  
                    size: 12,
                    color: kPrimaryColor,
                    textAlign: TextAlign.start,
                    weight: FontWeight.w600,
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      onChanged!(value);  
                    }
                  },
                  iconStyleData: const IconStyleData(
                    icon: SizedBox(),
                  ),
                  isDense: true,
                  isExpanded: true,
                  customButton: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    height: 48,
                    decoration: BoxDecoration(
                      color: kQuaternaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedRow(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                            text: selectedValue == hint.tr ? hint.tr : selectedValue.tr,  // ✅ Ensure `.tr`
                            size: 14,
                            color: kBlackColor,
                            weight: FontWeight.w600,
                            fontFamily: AppFonts.satoshi),
                        CommonImageView(
                          svgPath: Assets.svgArrowDown,
                        )
                      ],
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 35,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    elevation: 6,
                    maxHeight: 300,
                    offset: const Offset(0, -5),
                    decoration: BoxDecoration(
                        border: Border.all(color: kQuaternaryColor),
                        borderRadius: BorderRadius.circular(10),
                        color: kQuaternaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
