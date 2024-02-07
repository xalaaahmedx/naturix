import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:naturix/features/auth/domain/model/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:naturix/model/user.dart';

class Firebase_FireStor {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser({
    required String email,
    required String username,
    required String bio,
    required String profile,
  }) async {
    await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set({
      'username': username,
      'email': email,
      'bio': bio,
      'profile': profile,
      'followers': [],
      'following': [],
    });
    return true;
  }

  Future<UserModels> getUser() async {
    try {
      final user = await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      if (user.exists) {
        final snapUser = user.data();
        print('snapUser: $snapUser');

        if (snapUser != null) {
          return UserModels(
            whoAmI: snapUser['whoAmI'] ?? '', // Use the null-aware operator
            email: snapUser['email'] ?? '',
            username: snapUser['username'] ?? '',
            profile: snapUser['profile'] ?? '',
            followers: List<String>.from(snapUser['followers'] ?? []),
            following: List<String>.from(snapUser['following'] ?? []),
            // Add other parameters if needed
          );
        } else {
          throw Exception('User data is incomplete or null.');
        }
      } else {
        throw Exception('User document does not exist.');
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message.toString());
    }
  }

  Future<bool> CreatePost({
    required String postImage,
    required String caption,
    required String location,
  }) async {
    var uid = Uuid().v4();
    UserModels user = await getUser();

    await _firebaseFirestore.collection('posts').doc(uid).set({
      'username': user.username,
      'email': user.email,
      'profileImage': user.profile,
      'postImage': postImage,
      'caption': caption,
      'location': location,
      'time': FieldValue.serverTimestamp(),
      'likes': [],
      'comments': [],
    });

    return true;
  }
}
