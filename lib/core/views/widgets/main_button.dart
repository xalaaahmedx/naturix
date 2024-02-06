import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../config/app_theme.dart';

class MainButton extends StatelessWidget {
  double? width;
  double? height;
  Widget? label;
  GestureTapCallback? onTap;
  Color? color;

  MainButton({Key? key,this.height,this.width,this.label,this.onTap,this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.h),
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.w),
          color: (color!= null)? color : AppTheme.neutral900,
        ),
        child: label,
      ),
    );
  }
}
