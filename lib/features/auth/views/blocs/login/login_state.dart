part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {

  static Failure? failure;

  LoginError(Failure failure){
    LoginError.failure = failure;
  }

}

class LoginLoading extends LoginState {}




