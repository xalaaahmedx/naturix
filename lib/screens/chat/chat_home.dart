import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naturix/screens/chat/chatpage.dart';
import 'package:naturix/services/chat_service/chat_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Chat',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'anekMalayalam',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return FutureBuilder<List<String>>(
      future: ChatService().getConversations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching conversations'));
        }

        final conversationIds = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: conversationIds.length,
          itemBuilder: (context, index) {
            return _buildConversationCard(conversationIds[index]);
          },
        );
      },
    );
  }

  Widget _buildConversationCard(String conversationId) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .doc(conversationId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ListTile(title: Text('Error loading conversation'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(title: Text('Loading...'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final participants = data['participants'] as List;
          final lastMessage = data['lastMessage'] as String;
          final username = data['username'] != null
              ? data['username'] as String
              : participants[1];

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(participants[
                    1]) // Assuming participants[1] is the user's email
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.hasError ||
                  !userSnapshot.hasData ||
                  userSnapshot.data == null) {
                return ListTile(title: Text('Error loading user data'));
              }

              final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>;
              final profileImageUrl = userData['profileImageUrl'] as String?;

              return ListTile(
                title: Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  lastMessage,
                  style: TextStyle(color: Colors.grey),
                ),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl) as ImageProvider<Object>?
                      : AssetImage('assets/default_image.png')
                          as ImageProvider<Object>?,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        recieverUserId: participants[0],
                        userEmail: participants[1],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
