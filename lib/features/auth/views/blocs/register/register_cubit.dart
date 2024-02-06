import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:naturix/features/auth/domain/usecases/register_use_case.dart';
import 'package:naturix/features/auth/views/screens/auth_methods_screen.dart';
import 'package:naturix/features/auth/views/screens/login_screen.dart';
import 'package:naturix/features/auth/views/screens/register_message_screen.dart';

import '../../../../../core/di/app_module.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/views/widgets/custom_flush_bar.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  onRegisterClick(BuildContext context){
    register(context);
  }

  onLoginClick(BuildContext context){
    navigateToLoginScreen(context);
  }

  onDoneClick(BuildContext context){
    navigateToAuthMethodsScreen(context);
  }

  register(BuildContext context){
    emit(RegisterLoading());
    getIt<RegisterUseCase>().call(emailController.text,passwordController.text,usernameController.text,phoneNumberController.text)
    .then((value) => value.fold(
      (error) {
        emit(RegisterError(error));
        showFlushBar(
            context,
            title: "Error ${error.failureCode}",
            message : error.message
        );
        emit(RegisterInitial());
      },
      (success) {
        emit(RegisterSuccess());
        navigateToRegisterMessageScreen(context);
        emit(RegisterInitial());
      }
    ));
  }

  navigateToLoginScreen(BuildContext context) {
    Navigator.push(context,MaterialPageRoute(builder: (_)=> const LoginScreen()));
  }


  navigateToRegisterMessageScreen(BuildContext context) {
    Navigator.push(context,MaterialPageRoute(builder: (_)=> const RegisterMessageScreen()));
  }

  navigateToAuthMethodsScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (_)=> const AuthMethodsScreen()), (route) => false);
  }



}
