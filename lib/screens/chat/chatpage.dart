import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naturix/model/message.dart';
import 'package:naturix/services/chat_service/chat_service.dart';
import 'package:naturix/widgets/chat/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  final String recieverUserId;
  final String userEmail;

  const ChatPage({
    Key? key,
    required this.userEmail,
    required this.recieverUserId,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  String username = ''; // Add a variable to store the username
  String receiverUserProfileImageUrl = '';
  @override
  void initState() {
    super.initState();
    fetchReceiverUserData(); // Fetch the username when the widget initializes
  }

  void fetchReceiverUserData() async {
    try {
      final receiverUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.recieverUserId)
          .get();

      if (receiverUserDoc.exists) {
        setState(() {
          username = receiverUserDoc.get('username');
          receiverUserProfileImageUrl = receiverUserDoc.get('profileImageUrl');
        });
      }
    } catch (e) {
      print('Error fetching receiver user data: $e');
    }
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.recieverUserId,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 158, 140),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: receiverUserProfileImageUrl.isNotEmpty
                  ? NetworkImage(receiverUserProfileImageUrl)
                  : AssetImage('assets/default_profile_image.png')
                      as ImageProvider<Object>,
            ),
            SizedBox(width: 8),
            Text(
              username,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'anekMalayalam',
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(
        widget.recieverUserId,
        _firebaseAuth.currentUser!.email!,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Text('Something went wrong: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        print('Received data: ${snapshot.data?.docs.length} messages');

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = data['senderId'] == _firebaseAuth.currentUser!.email
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 2), // Adjust vertical margin here
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8), // Keep horizontal padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['senderEmail'] ?? '',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'anekMalayalam',
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            ChatBubble(message: data['message']!),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 1, 158, 140),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
