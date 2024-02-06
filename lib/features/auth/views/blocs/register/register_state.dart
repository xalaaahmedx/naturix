part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {
  static Failure? failure;

  RegisterError(Failure failure){
    RegisterError.failure = failure;
  }
}

class RegisterLoading extends RegisterState {}
