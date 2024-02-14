import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPost({required String caption, required List<String> imageUrls}) async {
    try {
      String currentUserEmail = _auth.currentUser?.email ?? '';
      Timestamp timestamp = Timestamp.now();

      await _firestore.collection('posts').add({
        'user': currentUserEmail,
        'caption': caption,
        'imageUrls': imageUrls,
        'timestamp': timestamp,
      });
    } catch (e) {
      print('Error creating post: $e');
    }
  }
}
