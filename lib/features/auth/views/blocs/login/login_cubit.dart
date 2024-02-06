import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:naturix/core/di/app_module.dart';
import 'package:naturix/core/errors/failure.dart';
import 'package:naturix/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:naturix/features/auth/views/screens/register_screen.dart';
import 'package:naturix/features/auth/views/screens/reset_password_screen.dart';

import '../../../../../core/views/widgets/custom_flush_bar.dart';
import '../../screens/who_am_i_screen.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = true;

  onForgotPasswordClick(BuildContext context){
    navigateToResetPasswordScreen(context);
  }

  onLoginClick(BuildContext context){
    login(context);
  }

  onRegisterClick(BuildContext context){
    navigateToRegisterScreen(context);
  }

  login(BuildContext context){
    emit(LoginLoading());
    getIt<SignInUseCase>().call(emailController.text, passwordController.text).then(
      (value) => value.fold(
        (error) {
          emit(LoginError(error));
          showFlushBar(
            context,
            title: "Error ${error.failureCode}",
            message : error.message
          );
          emit(LoginInitial());
        },
        (user) {
          emit(LoginSuccess());
          navigateToProductsScreen(context);
          emit(LoginInitial());
        }
      )
    );
  }

  navigateToRegisterScreen(BuildContext context){
    Navigator.push(context,MaterialPageRoute(builder: (_)=> const RegisterScreen()));
  }

  navigateToProductsScreen(BuildContext context){
    Navigator.push(context,MaterialPageRoute(builder: (_)=> const WhoAmIScreen()));
  }

  navigateToResetPasswordScreen(BuildContext context){
    Navigator.push(context,MaterialPageRoute(builder: (_)=> const ResetPasswordScreen()));
  }



}
