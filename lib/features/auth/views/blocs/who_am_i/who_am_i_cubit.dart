import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:naturix/core/di/app_module.dart';
import 'package:naturix/features/auth/domain/usecases/select_who_am_i_use_case.dart';

import '../../../../../core/config/app_consts.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/views/widgets/custom_flush_bar.dart';

part 'who_am_i_state.dart';

class WhoAmICubit extends Cubit<WhoAmIState> {
  WhoAmICubit() : super(WhoAmIInitial());

  int whoAmIIndex = 0;

  onPersonSelected(value){
    emit(WhoAmIValueChanged());
    whoAmIIndex = value;
    emit(WhoAmIInitial());
  }

  onOrganizationSelected(value){
    emit(WhoAmIValueChanged());
    whoAmIIndex = value;
    emit(WhoAmIInitial());
  }

  onRestaurantSelected(value){
    emit(WhoAmIValueChanged());
    whoAmIIndex = value;
    emit(WhoAmIInitial());
  }

  String whoAmI(int value){
    switch(value){
      case 1 :
        return AppConsts.person;

      case 2 :
        return AppConsts.organization;

      case 3 :
        return AppConsts.restaurant;

      default:
        return AppConsts.person;

    }
  }

  onDoneClick(BuildContext context){
    selectWhoAmI(context);
  }

  selectWhoAmI(BuildContext context){
    emit(WhoAmILoading());
    getIt<SelectWhoAmIUseCase>().call(whoAmI(whoAmIIndex))
    .then((value) => value.fold(
      (error) {
        emit(WhoAmIError(error));
        showFlushBar(
            context,
            title: "Error ${error.failureCode}",
            message : error.message
        );
        emit(WhoAmIInitial());
      },
      (success) {
        emit(WhoAmISuccess());
        navigateToHomeScreen(context);
        emit(WhoAmIInitial());

      })
    );
  }

  navigateToHomeScreen(BuildContext context){
    //
  }

}
