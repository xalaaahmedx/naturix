class RemoteDataException implements Exception {
  String message;

  RemoteDataException(this.message);
}

class ServiceException implements Exception {
  String message;

  ServiceException(this.message);
}

class LocalDataException implements Exception {
  String message;

  LocalDataException(this.message);
}

class InternalException implements Exception {
  String message;

  InternalException(this.message);
}