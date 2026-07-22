
import 'package:flutter/material.dart';
import '../../config/constants/app_colors.dart';
import '../../config/constants/app_fonts.dart';
import 'my_text_widget.dart';

// ignore: must_be_immutable
class MyBullet extends StatelessWidget {
  MyBullet({super.key, required this.point, this.size});
  String point;
  double? size;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: '•',
            //paddingLeft: 25,
            color: kTertiaryColor,
            paddingRight: 10,
          ),
          Expanded(
            child: MyText(
              text: point,
              color: kTertiaryColor,
              size: size ?? 12,
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
