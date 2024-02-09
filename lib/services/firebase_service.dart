import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
CollectionReference users = _firestore.collection('users');

Future<String?> getUserData(String userId) async {
  try {
    DocumentSnapshot userDoc = await users.doc(userId).get();
    if (userDoc.exists) {
      return userDoc['username'];
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
