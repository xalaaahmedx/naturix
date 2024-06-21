import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationHelper {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> notificationInit()async{
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    print(token);
  }

}