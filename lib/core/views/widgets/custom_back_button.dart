import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:naturix/generated/locale_keys.g.dart';
import '../../config/app_images.dart';
import '../../config/app_theme.dart';

class CustomBackButton extends StatelessWidget {
  void Function()? onPressed;

  CustomBackButton({super.key,this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Positioned(
          left: 0,
          child: InkWell(
              borderRadius: BorderRadius.circular(100.w),
              onTap: () {
                if(onPressed != null){
                  onPressed!();
                }
                Navigator.pop(context);
              },
              child: SvgPicture.asset(AppImages.arrow,
                width: 6.w
                ,height: 6.w,
              )
          ),
        ),

        Text(
          LocaleKeys.add_product,
          style: AppTheme.mainTextStyle(
            color: AppTheme.neutral900,
            fontSize: 20.sp,
          ),
          textAlign: TextAlign.center,

        ).tr(),

        SizedBox(
          width: 6.w,
          height: 6.w,
        )
      ],
    );
  }
}
