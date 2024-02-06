import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:naturix/core/views/widgets/custom_checkbox.dart';
import 'package:naturix/core/views/widgets/custom_progress_indicator.dart';
import 'package:naturix/core/views/widgets/custom_text_field.dart';
import 'package:naturix/features/auth/views/blocs/login/login_cubit.dart';

import '../../../../core/config/app_images.dart';
import '../../../../core/config/app_theme.dart';
import '../../../../core/views/widgets/custom_appbar.dart';
import '../../../../core/views/widgets/main_button.dart';
import '../../../../core/views/widgets/space.dart';
import '../../../../generated/locale_keys.g.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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


            Center(
              child: Image.asset(
                AppImages.login,
                width: 86.w,
                height: 20.h,
              ),
            ),

            Space(
              height: 3.h,
            ),

            Text(
              LocaleKeys.login,
              style: AppTheme.mainTextStyle(
                color: AppTheme.neutral900,
                fontSize: 25.sp,
              ),
            ).tr(),
            Space(
              height: 2.h,
            ),
            Text(
              LocaleKeys.login_description,
              style: AppTheme.mainTextStyle(
                  color: AppTheme.neutral700, fontSize: 12.sp),
            ).tr(),

            Space(
              height: 3.h,
            ),

            CustomTextField(
              controller: context.read<LoginCubit>().emailController,
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
              height: 2.h,
            ),
            CustomTextField(
              controller: context.read<LoginCubit>().passwordController,
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: SvgPicture.asset(
                  AppImages.password,
                  width: 3.w,
                  height: 3.h,
                ),

              ),
              label: LocaleKeys.password.tr(),
              hint: LocaleKeys.password_hint.tr(),
            ),
            Space(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                CustomCheckBox(
                    value: context.read<LoginCubit>().rememberMe,
                    onChanged: (value){
                      context.read<LoginCubit>().rememberMe = value!;
                    },
                  label: LocaleKeys.remember_me.tr(),
                ),

                InkWell(
                  onTap: () => context.read<LoginCubit>().onForgotPasswordClick(context) ,
                  child: Text(
                    LocaleKeys.forgot_password.tr(),
                    style: AppTheme.mainTextStyle(
                        color: AppTheme.neutral700, fontSize: 12.sp),
                  ).tr(),
                ),
              ],
            ),

            Space(
              height: 12.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text(
                  LocaleKeys.dont_have_account.tr(),
                  style: AppTheme.mainTextStyle(
                      color: AppTheme.neutral400, fontSize: 12.sp),
                ).tr(),
                Space(
                  width: 2.w,
                ),
                InkWell(
                  onTap: () => context.read<LoginCubit>().onRegisterClick(context),
                  child: Text(
                    LocaleKeys.register.tr(),
                    style: AppTheme.mainTextStyle(
                        color: AppTheme.neutral900, fontSize: 12.sp),
                  ).tr(),
                ),
              ],
            ),

            Space(
              height: 3.h,
            ),

            BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {},
              builder: (context, state) {
                return MainButton(
                  color: AppTheme.primary900,
                          width: 86.w,
                          height: 7.h,
                          label: (state is LoginLoading)? CustomProgressIndicator(
                            color: AppTheme.neutral100,
                          ) : Text(
                            LocaleKeys.login,
                            style: AppTheme.mainTextStyle(
                                color: AppTheme.neutral100, fontSize: 14.sp),
                          ).tr(),
                          onTap: ()=> context.read<LoginCubit>().onLoginClick(context),
                        );
              },
            ),


          ],
        ),
      ),

    ));
  }
}
