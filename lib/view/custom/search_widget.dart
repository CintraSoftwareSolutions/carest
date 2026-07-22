
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/constants/app_colors.dart';
import '../../config/constants/app_fonts.dart';
import '../../generated/assets.dart';
import 'common_image_view_widget.dart';
class SearchWidget extends StatelessWidget {
  SearchWidget({super.key, required this.searchController});
  TextEditingController searchController;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          color: kPrimaryColor,
          fontSize: 12),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 18),
          hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: kTertiaryColor,
              fontSize: 14,
            fontFamily: AppFonts.dmSans
          ),
          fillColor: kTertiaryColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: kTertiaryColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: kTertiaryColor,
              )),
          hintText: 'Search...'.tr,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Icon(Icons.search,color: kTertiaryColor,),
          )),
    );
  }
}
