part of 'who_am_i_cubit.dart';

@immutable
abstract class WhoAmIState {}

class WhoAmIInitial extends WhoAmIState {}

class WhoAmIValueChanged extends WhoAmIState {}

class WhoAmILoading extends WhoAmIState {}

class WhoAmIError extends WhoAmIState {
  static Failure? failure;

  WhoAmIError(Failure failure){
    WhoAmIError.failure = failure;
  }
}

class WhoAmISuccess extends WhoAmIState {}