import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String user;
  final String caption;
  final List<String> imageUrls;
  final Timestamp timestamp; // Make sure to import the 'cloud_firestore' package

  Post({
    required this.user,
    required this.caption,
    required this.imageUrls,
    required this.timestamp,
  });

  // A factory constructor to convert Firestore data to a Post object
  factory Post.fromFirestore(Map<String, dynamic> data) {
    return Post(
      user: data['user'],
      caption: data['caption'],
      imageUrls: List<String>.from(data['imageUrls']),
      timestamp: data['timestamp'],
    );
  }
}
