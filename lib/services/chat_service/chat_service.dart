import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naturix/model/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> sendMessage(String recieverEmail, String message) async {
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserEmail,
      recieverId: recieverEmail,
      senerEmail: currentUserEmail,
      message: message,
      timestamp: timestamp,
    );

    List<String> emails = [currentUserEmail, recieverEmail];
    emails.sort();
    String chatRoomId = emails.join('_');

    // Add the message to the messages collection
    await _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

    // Update or create a conversation document in the conversations collection
    await _firestore.collection('conversations').doc(chatRoomId).set({
      'participants': emails,
      'lastMessage': message,
      'timestamp': timestamp,
      'username': await _getUsername(recieverEmail), // Add the username
    }, SetOptions(merge: true));
  }

  Future<List<String>> getConversations() async {
    final currentUserEmail = _firebaseAuth.currentUser!.email!;
    final querySnapshot = await _firestore
        .collection('conversations')
        .where('participants', arrayContains: currentUserEmail)
        .get();

    return querySnapshot.docs.map((doc) => doc.id).toList();
  }

  Future<String> _getUsername(String userEmail) async {
    // Assuming you have a 'users' collection with user data
    var userSnapshot =
        await _firestore.collection('users').doc(userEmail).get();

    if (userSnapshot.exists) {
      // Replace 'username' with the actual field name in your user data
      return userSnapshot['username'] ?? userEmail;
    } else {
      return userEmail;
    }
  }

  Stream<QuerySnapshot> getMessages(String userEmail, String otherUserEmail) {
    List<String> emails = [userEmail, otherUserEmail];
    emails.sort();
    String chatRoomId = emails.join('_');

    return _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
