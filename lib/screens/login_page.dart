import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naturix/screens/register.dart';
import 'package:naturix/services/auth/auth_sarvice.dart';
import 'package:naturix/widgets/widgetss/buttons.dart';
import 'package:naturix/widgets/widgetss/text_field.dart';
import 'package:naturix/widgets/btm_nav_bar.dart'; // Import your BtmNavBar

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onTap});
  final void Function()? onTap;
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _selectedRole = 'User'; // Initialize _selectedRole with a default value

  void _signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailandPassword(
          _emailController.text, _passwordController.text);
      
      // Navigate to BtmNavBar with the selected role
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BtmNavBar(role: _selectedRole),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Charity-bro.png', 
                    height: 200,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Welcome back!',
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
                      hintText: 'Enter Password'),
                  const SizedBox(
                    height: 25,
                  ),
                  MyButtons(onTap: _signIn, text: 'sign in'),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('not a member? '),
                      const SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const Register()),
                          );
                        },
                        child: const Text('Register'),
                      )
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
