import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            fontSize: 20.sp,
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

        final conversationIds = snapshot.data ?? [];

        if (conversationIds.isEmpty) {
          return _buildPlaceholderScreen();
        }

        return ListView.builder(
          padding: EdgeInsets.all(4.w),
          itemCount: conversationIds.length,
          itemBuilder: (context, index) {
            return _buildConversationCard(conversationIds[index]);
          },
        );
      },
    );
  }

  Widget _buildPlaceholderScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/Online Review-pana.png',
            width: 2500,
            height: 250,
          ),
          SizedBox(height: 40),
          Text(
            'No chats available, start a new chat!',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard(String conversationId) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 2.w),
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

            final otherParticipantEmail = participants
                .firstWhere((email) => email != _auth.currentUser!.email);

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(otherParticipantEmail)
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
                final username = userData['username'] as String;

                return ListTile(
                  title: Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  subtitle: Text(
                    lastMessage,
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  leading: CircleAvatar(
                    radius: 30.w,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl)
                            as ImageProvider<Object>?
                        : AssetImage('assets/default_image.png')
                            as ImageProvider<Object>?,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          recieverUserId: otherParticipantEmail,
                          userEmail: _auth.currentUser!.email!,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
