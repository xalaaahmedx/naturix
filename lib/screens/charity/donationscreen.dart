import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naturix/screens/chat/chatpage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:naturix/services/chat_service/chat_service.dart'; // Import FirebaseAuth for user authentication

class DonationScreen extends StatefulWidget {
  final String user;

  const DonationScreen({Key? key, required this.user}) : super(key: key);

  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  TextEditingController _itemController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  List<Map<String, dynamic>> _donatedItems = [];
  ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Donation'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _itemController,
              decoration: InputDecoration(
                labelText: 'Item',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Weight',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                String item = _itemController.text;
                String weight = _weightController.text;
                if (item.isNotEmpty && weight.isNotEmpty) {
                  _donatedItems.add({
                    'item': item,
                    'weight': weight,
                  });
                  _itemController.clear();
                  _weightController.clear();
                  setState(() {});
                } else {
                  // Handle empty fields if needed
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 1, 158, 140),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child:
                  Text('Add Donation', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20.h),
            _donatedItems.isNotEmpty
                ? Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _donatedItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Item: ${_donatedItems[index]['item']}'),
                          subtitle:
                              Text('Weight: ${_donatedItems[index]['weight']}'),
                        );
                      },
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () async {
                // Fetch logged-in user's email
                User? currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  String currentUserEmail = currentUser.email!;
                  String receiverEmail =
                      widget.user; // Use recipient email from widget

                  // Send message
                  String message = 'I have donated the following items:';
                  for (var item in _donatedItems) {
                    message += '\n${item['item']} - ${item['weight']}';
                  }

                  await _chatService.sendMessage(receiverEmail, message);

                  // Navigate to chat page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        userEmail: currentUserEmail,
                        recieverUserId: receiverEmail,
                      ),
                    ),
                  );
                } else {
                  // Handle case where user is not logged in
                  print('User is not logged in');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 1, 158, 140),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Chat', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
