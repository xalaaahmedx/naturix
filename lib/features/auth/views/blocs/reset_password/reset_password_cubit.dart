import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:naturix/core/di/app_module.dart';
import 'package:naturix/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:naturix/features/auth/views/screens/register_message_screen.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/views/widgets/custom_flush_bar.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  TextEditingController emailController = TextEditingController();

  onNextClick(BuildContext context) {
    resetPassword(context);
  }

  resetPassword(BuildContext context){
    emit(ResetPasswordLoading());
    getIt<ResetPasswordUseCase>().call(emailController.text.trim()).then(
            (value) => value.fold(
                    (error) {
                      emit(ResetPasswordError(error));
                      showFlushBar(
                          context,
                          title: "Error ${error.failureCode}",
                          message : error.message
                      );
                      emit(ResetPasswordInitial());

                    },
                    (success) {
                      emit(ResetPasswordSuccess());
                      navigateToMessageScreen(context);
                      emit(ResetPasswordInitial());
                    }
            )
    );
  }

  navigateToMessageScreen(BuildContext context){
    Navigator.push(context,MaterialPageRoute(builder: (_)=> const RegisterMessageScreen()));
  }




}
