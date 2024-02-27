import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String recieverId;
  final String senerEmail;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.recieverId,
    required this.senerEmail,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverId': recieverId,
      'senerEmail': senerEmail,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
