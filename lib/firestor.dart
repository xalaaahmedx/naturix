import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:uuid/uuid.dart';
import 'package:naturix/model/user.dart';

class FirebaseFireStor {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser({
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
      final userDoc = await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        print('userData: $userData');

        if (userData != null) {
          return UserModels.fromMap(userData);
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

  Future<bool> createPost({
    required String postImage,
    required String caption,
    required String location,
    required String username,
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
