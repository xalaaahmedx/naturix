import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../config/app_images.dart';
import '../../config/app_theme.dart';

class CustomAppbar extends StatelessWidget {
  String title;

  CustomAppbar({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        InkWell(
            borderRadius: BorderRadius.circular(100.w),
            child: SvgPicture.asset(AppImages.arrow),
            onTap: (){
                Navigator.pop(context);
            },
        ),

        Text(
          title,
          style: AppTheme.mainTextStyle(
              color: AppTheme.neutral900, fontSize: 18.sp),
        ),

        SizedBox(
          width: 5.w,
        )

        
      ],
    );
  }
}
