
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants/app_colors.dart';
import '../../config/constants/app_fonts.dart';
import 'common_image_view_widget.dart';
import 'custom_animated_row.dart';
import 'my_text_widget.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.height = 40,
    this.width,
    this.backgroundColor,
    this.fontColor,
    this.fontSize = 12,
    this.outlineColor = Colors.transparent,
    this.radius = 10,
    this.svgIcon,
    this.weight,
    this.haveSvg = false,
    this.choiceIcon,
    this.isleft = false,
    this.mhoriz = 0,
    this.hasicon = false,
    this.hasshadow = false,
    this.mBottom = 0,
    this.hasgrad = false,
    this.isactive = true,
    this.mTop = 0,
    this.fontWeight = FontWeight.w600,
  });

  final String buttonText;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final FontWeight? weight;

  final double radius;
  final double fontSize;
  final Color outlineColor;
  final bool hasicon, isleft, hasshadow, hasgrad, isactive;
  final Color? backgroundColor, fontColor;
  final String? svgIcon, choiceIcon;
  final bool haveSvg;
  final double mTop, mBottom, mhoriz;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(duration: Duration(milliseconds: 1000)),
        MoveEffect(curve: Curves.fastLinearToSlowEaseIn),
      ],
      child: Bounce(
        duration: Duration(milliseconds: isactive ? 100 : 0),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
            top: mTop,
            bottom: mBottom,
            left: mhoriz,
            right: mhoriz,
          ),
          height: height,
          width: width,
          decoration: BoxDecoration(
                    color:backgroundColor ?? kText2Color,
                    border: Border.all(color: outlineColor),
                    borderRadius: BorderRadius.circular(radius),
                  ),

          child: Material(
            color: Colors.transparent,
            child: AnimatedRow(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                hasicon
                    ? Padding(
                      padding:
                          isleft
                              ? const EdgeInsets.only(left: 20.0)
                              : const EdgeInsets.only(left: 5,),
                      child: CommonImageView(svgPath: choiceIcon, ),
                    )
                    : const SizedBox.shrink(),
                MyText(
                  paddingLeft: hasicon ? 10 : 0,
                  paddingRight: hasicon ? 10 : 0,
                  text: buttonText,
                  fontFamily: AppFonts.dmSans,
                  size: fontSize,
                  letterSpacing: 0.7,
                  color: fontColor ?? kQuaternaryColor,
                  weight: weight ?? FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class MyButton2 extends StatelessWidget {
  const MyButton2({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.height = 56,
    this.width,
    this.backgroundColor,
    this.fontColor,
    this.fontSize = 16,
    this.outlineColor = Colors.transparent,
    this.radius = 20,
    this.svgIcon,
    this.weight,
    this.haveSvg = false,
    this.choiceIcon,
    this.isleft = false,
    this.mhoriz = 0,
    this.hasicon = false,
    this.hasshadow = false,
    this.mBottom = 0,
    this.hasgrad = false,
    this.isactive = true,
    this.mTop = 0,
    this.fontWeight = FontWeight.w600,
  });

  final String buttonText;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final FontWeight? weight;

  final double radius;
  final double fontSize;
  final Color outlineColor;
  final bool hasicon, isleft, hasshadow, hasgrad, isactive;
  final Color? backgroundColor, fontColor;
  final String? svgIcon, choiceIcon;
  final bool haveSvg;
  final double mTop, mBottom, mhoriz;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(duration: Duration(milliseconds: 1000)),
        MoveEffect(curve: Curves.fastLinearToSlowEaseIn),
      ],
      child: Bounce(
        duration: Duration(milliseconds: isactive ? 100 : 0),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
            top: mTop,
            bottom: mBottom,
            left: mhoriz,
            right: mhoriz,
          ),
          height: height,
          width: width,
          decoration: BoxDecoration(
                    color:backgroundColor ?? kText3Color,
                    border: Border.all(color: outlineColor),
                    borderRadius: BorderRadius.circular(radius),
                  ),

          child: Material(
            color: Colors.transparent,
            child: AnimatedRow(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                hasicon
                    ? Padding(
                      padding:
                          isleft
                              ? const EdgeInsets.only(left: 20.0)
                              : const EdgeInsets.only(left: 5,),
                      child: CommonImageView(svgPath: choiceIcon, ),
                    )
                    : const SizedBox.shrink(),
                MyText(
                  paddingLeft: hasicon ? 10 : 0,
                  paddingRight: hasicon ? 10 : 0,
                  text: buttonText,
                  fontFamily: AppFonts.dmSans,
                  size: fontSize,
                  letterSpacing: 0.7,
                  color: fontColor ?? kQuaternaryColor,
                  weight: weight ?? FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyBorderButton extends StatelessWidget {
  MyBorderButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.height = 48,
    this.textSize,
    this.weight,
    this.child,
    this.radius,
    this.borderColor,
    this.mBottom,
    this.mTop,
    this.bgColor,
    this.textColor,
  });

  final String buttonText;
  final VoidCallback onTap;
  double? height, textSize;
  FontWeight? weight;
  Widget? child;
  double? radius;
  Color? borderColor,bgColor,textColor;
  double? mTop, mBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mTop ?? 0, bottom: mBottom ?? 0),
      height: height,
      decoration: BoxDecoration(
        color: bgColor ?? Color(0x190DACE8),
        borderRadius: BorderRadius.circular(radius ?? 50),
        border: Border.all(width: 1.0, color: borderColor ?? kBlueColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          child: InkWell(
            onTap: onTap,
            splashColor: kQuaternaryColor.withOpacity(0.1),
            highlightColor: kQuaternaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(radius ?? 8),
            child:
                child ??
                Center(
                  child: MyText(
                    text: buttonText,
                    size: textSize ?? 16,
                    weight: weight ?? FontWeight.w600,
                    fontFamily: AppFonts.dmSans,
                    color: textColor ?? kBlueColor,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
