import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:naturix/screens/login_page.dart';
import 'package:naturix/services/auth/auth_sarvice.dart';
import 'package:naturix/widgets/widgetss/buttons.dart';
import 'package:naturix/widgets/widgetss/text_field.dart';

class Register extends StatefulWidget {
  const Register({Key? key, this.onTap}) : super(key: key);
  final void Function()? onTap;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final emailTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    emailTextController.dispose();
  }

  void _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Extract username from email
      String username = userCredential.user!.email!.split('@')[0];

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.email)
          .set({
        'username': username,
        'bio': 'Empty bio...',
      }, SetOptions(merge: true));

      // Signup successful, navigate back to login page
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Icon(
                    Icons.message,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Lets create an account for you',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MyTextField(
                    controller: _emailController,
                    obscureText: false,
                    hintText: 'Enter Email',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    controller: _passwordController,
                    obscureText: true,
                    hintText: 'Enter Password',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MyTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MyButtons(
                    text: 'SignUp',
                    onTap: _signUp,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already a member? '),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
