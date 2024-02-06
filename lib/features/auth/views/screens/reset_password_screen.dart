import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:naturix/features/auth/views/blocs/reset_password/reset_password_cubit.dart';
import 'package:naturix/generated/locale_keys.g.dart';

import '../../../../core/config/app_images.dart';
import '../../../../core/config/app_theme.dart';
import '../../../../core/views/widgets/custom_appbar.dart';
import '../../../../core/views/widgets/custom_progress_indicator.dart';
import '../../../../core/views/widgets/custom_text_field.dart';
import '../../../../core/views/widgets/main_button.dart';
import '../../../../core/views/widgets/space.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: ListView(
          children: [

            Space(
              height: 3.h,
            ),
            CustomAppbar(title: "",),
            Space(
              height: 4.h,
            ),

            Text(
              LocaleKeys.reset_password,
              style: AppTheme.mainTextStyle(
                  color: AppTheme.neutral900, fontSize: 18.sp),
            ).tr(),
            Space(
              height: 2.h,
            ),
            Text(
              LocaleKeys.reset_password_sub_text,
              style: AppTheme.mainTextStyle(
                  color: AppTheme.neutral600, fontSize: 13.sp),
            ).tr(),

            Space(
              height: 2.5.h,
            ),

            CustomTextField(
              controller: context
                  .read<ResetPasswordCubit>()
                  .emailController,
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: SvgPicture.asset(
                  AppImages.email,
                  width: 3.w,
                  height: 3.h,
                ),

              ),
              label: LocaleKeys.email.tr(),
              hint: LocaleKeys.email_hint.tr(),
            ),

            Space(
              height: 50.h,
            ),

            BlocConsumer<ResetPasswordCubit,ResetPasswordState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return MainButton(
                  color: AppTheme.primary900,
                  width: 86.w,
                  height: 7.h,
                  label: (state is ResetPasswordLoading) ? CustomProgressIndicator(
                    color: AppTheme.neutral100,
                  ) : Text(
                    LocaleKeys.next,
                    style: AppTheme.mainTextStyle(
                        color: AppTheme.neutral100, fontSize: 14.sp),
                  ).tr(),
                  onTap: () => context.read<ResetPasswordCubit>().onNextClick(context),
                );
              },
            )

          ],
        ),
      ),
    ));
  }
}
