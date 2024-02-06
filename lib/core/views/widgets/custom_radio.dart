import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:naturix/core/views/widgets/space.dart';
import '../../config/app_theme.dart';

class CustomRadio extends StatelessWidget {
  String title;
  int value;
  int selectedValue;
  void Function(int?)? onChanged;

  CustomRadio({super.key,required this.title, required this.value,required this.selectedValue,required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
          activeColor: AppTheme.primary900,
          value: value,
          groupValue: selectedValue,
          onChanged: onChanged,
        ),

        Space(width: 2.w,),

        Text(
          title,
          style: AppTheme.mainTextStyle(
            color: AppTheme.neutral700,
            fontSize: 16.sp,
          ),
        )
      ],
    );
  }
}
