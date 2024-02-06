import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:naturix/core/views/widgets/custom_radio.dart';
import 'package:naturix/features/auth/views/blocs/who_am_i/who_am_i_cubit.dart';

import '../../../../core/config/app_images.dart';
import '../../../../core/config/app_theme.dart';
import '../../../../core/views/widgets/custom_progress_indicator.dart';
import '../../../../core/views/widgets/main_button.dart';
import '../../../../core/views/widgets/space.dart';
import '../../../../generated/locale_keys.g.dart';

class WhoAmIScreen extends StatelessWidget {
  const WhoAmIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: ListView(
              children: [
                Space(
                  height: 6.h,
                ),
                Center(
                  child: Image.asset(
                    AppImages.whoAmI,
                    width: 86.w,
                    height: 30.h,
                  ),
                ),
                Space(
                  height: 3.h,
                ),
                Center(
                  child: Text(
                    LocaleKeys.who_am_i,
                    style: AppTheme.mainTextStyle(
                      color: AppTheme.neutral900,
                      fontSize: 25.sp,
                    ),
                  ).tr(),
                ),
                Space(
                  height: 5.h,
                ),
                BlocConsumer<WhoAmICubit, WhoAmIState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomRadio(
                            title: LocaleKeys.person.tr(),
                            value: 0,
                            selectedValue: context.read<WhoAmICubit>().whoAmIIndex ,
                            onChanged: context.read<WhoAmICubit>().onPersonSelected
                        ),
                        Space(
                          height: 1.h,
                        ),
                        CustomRadio(
                            title: LocaleKeys.organization.tr(),
                            value: 1,
                            selectedValue: context.read<WhoAmICubit>().whoAmIIndex ,
                            onChanged: context.read<WhoAmICubit>().onOrganizationSelected
                        ),
                        Space(
                          height: 1.h,
                        ),

                        CustomRadio(
                            title: LocaleKeys.restaurant.tr(),
                            value:2,
                            selectedValue: context.read<WhoAmICubit>().whoAmIIndex ,
                            onChanged: context.read<WhoAmICubit>().onRestaurantSelected
                        )
                      ],
                    );
                  },
                ),

                Space(
                  height: 8.h,
                ),

                BlocConsumer<WhoAmICubit, WhoAmIState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return MainButton(
                      color: AppTheme.primary900,
                      width: 86.w,
                      height: 7.h,
                      label:  (state is WhoAmILoading)? CustomProgressIndicator(
                        color: AppTheme.neutral100,
                      ):  Text(
                        LocaleKeys.done,
                        style: AppTheme.mainTextStyle(
                            color: AppTheme.neutral100, fontSize: 14.sp),
                      ).tr(),
                      onTap: () => context.read<WhoAmICubit>().onDoneClick(context),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
