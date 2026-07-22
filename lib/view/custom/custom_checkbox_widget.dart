import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../config/constants/app_colors.dart';
import '../../config/constants/app_fonts.dart';
import 'custom_animated_row.dart';
import 'my_text_widget.dart';

class TermsCheckbox extends StatefulWidget {
  final String? text;

  final Color? textcolor;
  final Function(bool) onChanged;

  const TermsCheckbox({
    super.key,
    this.text,
    required this.onChanged,
    this.textcolor,
  });

  @override
  _TermsCheckboxState createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  bool _isChecked = false;


  @override
  Widget build(BuildContext context) {
    return AnimatedRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
            });
            widget.onChanged(_isChecked);
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _isChecked ? kBlueColor : kQuaternaryColor,
              border: Border.all(color: _isChecked ? kBlueColor :kQuaternaryColor, width: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _isChecked
                ? Icon(Icons.check, color: kQuaternaryColor, size: 15)
                : null,
          ),
        ),
        SizedBox(width: 8),
        Flexible(
          child: MyText(
            text: widget.text ?? '',
            size: 16,
            color: kBlackColor,
            fontFamily: AppFonts.dmSans,
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class CustomCheckBox extends StatelessWidget {
  final RxBool isChecked = false.obs; // 👈 reactive bool
  final ValueChanged<bool> onChanged;

  CustomCheckBox({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          isChecked.value = !isChecked.value; // toggle
          onChanged(isChecked.value); // callback
        },
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isChecked.value ? kPrimaryColor : kBackGroundColor,
            border: Border.all(color: isChecked.value ? kPrimaryColor :kTextColor, width: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: isChecked.value
              ? Icon(Icons.check, color: kQuaternaryColor, size: 15)
              : null,
        ),
      ),
    );
  }
}



class TermsCheckbox2 extends StatefulWidget {
  final Function(bool) onChanged;

  const TermsCheckbox2({
    super.key, // 👈 optional rich text
    required this.onChanged,
  });

  @override
  _TermsCheckbox2State createState() => _TermsCheckbox2State();
}

class _TermsCheckbox2State extends State<TermsCheckbox2> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
            });
            widget.onChanged(_isChecked);
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _isChecked ? kBlueColor : kQuaternaryColor,
              border: Border.all(
                color: _isChecked ? kBlueColor : kQuaternaryColor,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _isChecked
                ? Icon(Icons.check, color: kQuaternaryColor, size: 15)
                : null,
          ),
        ),
        SizedBox(width: 8),

        // 👇 Rich text ya simple text — jo diya ho woh show karo
        Flexible(
          child: SizedBox(
            width: 278,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'I agree to the  ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: AppFonts.dmSans,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      letterSpacing: -0.07,
                    ),
                  ),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      color: kBlueColor,
                      fontSize: 16,
                      fontFamily: AppFonts.dmSans,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: kBlueColor,
                      height: 1,
                      letterSpacing: -0.07,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}