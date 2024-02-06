import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  String message;
  int failureCode;

  List<dynamic> properties;

  Failure(this.message,
      {this.properties = const <dynamic>[], required this.failureCode});

  @override
  List<Object?> get props => properties;
}

class InternalFailure extends Failure {
  InternalFailure(String message,
      {required int failureCode})
      : super(message,failureCode : failureCode);
}

class RemoteDataFailure extends Failure {
  RemoteDataFailure(String message,
      {required int failureCode})
      : super(message,failureCode : failureCode);
}

class LocalDataFailure extends Failure {
  LocalDataFailure(String message,
      {required int failureCode})
      : super(message,failureCode : failureCode);
}

class ServiceFailure extends Failure {
  ServiceFailure(String message,
      {required int failureCode})
      : super(message,failureCode : failureCode);
}
