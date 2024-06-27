import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naturix/screens/charity/donationscreen.dart';
import 'package:naturix/screens/user_profile_screen.dart';
import 'package:naturix/services/firebase_service.dart'; // Import your FirebaseService

class OrganizationScreen extends StatefulWidget {
  final String user;

  const OrganizationScreen({Key? key, required this.user}) : super(key: key);

  @override
  _OrganizationScreenState createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
  FirebaseService _firebaseService = FirebaseService();
  final currentUser = FirebaseAuth.instance.currentUser!;
  List<Map<String, dynamic>> _organizationUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchOrganizationUsers();
  }

  Future<void> _fetchOrganizationUsers() async {
    try {
      List<Map<String, dynamic>> results =
          await _firebaseService.searchOrganizationUsers();

      setState(() {
        _organizationUsers = results;
      });
    } catch (e) {
      print('Error fetching organization users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Users'),
      ),
      body: ListView.builder(
        itemCount: _organizationUsers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      _organizationUsers[index]['profileImageUrl']),
                ),
                title: Text(_organizationUsers[index]['username']),
                subtitle: Text(_organizationUsers[index]['email']),
                onTap: () {
                  String userEmail = _organizationUsers[index]['email'];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        useremail: userEmail,
                        currentUserEmail: currentUser.email!,
                      ),
                    ),
                  );
                },
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DonationScreen(
                          user: _organizationUsers[index]['email'],
                          
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 1, 158, 140),
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  child: Text('Donate', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
