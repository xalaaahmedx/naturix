import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      // Use a case-insensitive search for usernames
      QuerySnapshot userDocs = await users
          .where('username', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('username',
              isLessThanOrEqualTo: query.toLowerCase() + '\uf8ff')
          .get();

      if (userDocs.docs.isNotEmpty) {
        // Convert the user documents to a list of maps
        List<Map<String, dynamic>> results = userDocs.docs
            .map((doc) =>
                {'userId': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
        return results;
      } else {
        return [];
      }
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

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
  
}
