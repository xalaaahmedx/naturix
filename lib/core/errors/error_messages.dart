class ErrorMessages {

  static const String network = "Please check your internet connection and try again!";

  static const String server = "There is an error in the server please try again later";

  static const String returnedWithNull = "The response returned with null";

  static const String unknown = "There was unknown error in the server";

  static const String serverDown = "The server is down, please try again later!";

  static const String cachingFailure = "There was a failure during the caching!";

  static const String serviceProvider = "There was unknown error in network service provider";

  static const String emptyListOfProducts = "There request returned with an empty list";

  static const String emptyListOfProductsInSearch = "Didn't found what you have been looking for!";

  debugErrorCode(int errorCode) {
     List errorCodeList = errorCode.toString().split("");
     String error = "";

     String? screenCode = _screenCode[errorCodeList.sublist(0,3).join()];

     String? exceptionCode = _exceptionCode[errorCodeList[3]]?["exception"];

     String? customCode = _exceptionCode[errorCodeList[3]]?[errorCodeList.sublist(4).join()];

     return "Exception : $customCode $exceptionCode in $screenCode";

  }

  /// Code for each screen
  final Map<String,String> _screenCode = {
    "0" : "Intro Screen",
    "100" : "Auth Method Screen",
    "101" : "Login Screen",
    "102" : "Registration Screen",
    "103" : "Reset Password Method Screen",
    "104" : "Reset Password Screen",
    "105" : "Pin Screen",
    "106" : "New Password Screen",
    "107" : "Account Activation Screen",
  };


  /// Code for each exception
  Map<String,Map<String,String>> get _exceptionCode => {
    "1" : _internalCustomException,
    "2" : _remoteCustomException,
    "3" : _localCustomException,
    "4" : _serviceCustomException,
  };


  /// Custom error for each exception
  final Map<String,String> _internalCustomException = {
    "exception" : "Internal exception",
    "0" : "unknown internal error has happened",
  };

  final Map<String,String> _remoteCustomException = {
    "exception" : "Remote data source exception (Server)",
    "0" : "The request has failed due to bad status code",
    "1" : "The request has failed due to response code returned with null",
    "2" : "The request has failed due to bad request from the client",
  };

  final Map<String,String> _localCustomException = {
    "exception" : "Local data source exception (database)",
    "0" : "The storing has failed due to unregular exception",
  };

  final Map<String,String> _serviceCustomException = {
    "exception" : "Service exception",
    "0" : "The service calling has failed dut to a failure in the service provider",
    "1" : "the device is not connected to the network",
  };

  static const String networkErrorCode = "41";



}