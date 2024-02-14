import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naturix/firebase_options.dart';
import 'package:naturix/screens/home_page.dart';
import 'package:naturix/screens/login_page.dart';
import 'package:naturix/services/auth/auth_sarvice.dart';
import 'package:naturix/widgets/btm_nav_bar.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:naturix/screens/first_onboardingscreen.dart';

final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 2, 165, 146),
  background: const Color.fromARGB(255, 250, 250, 250),
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.anekMalayalamTextTheme().copyWith(
    titleSmall: GoogleFonts.anekMalayalam(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.anekMalayalam(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.anekMalayalam(
      fontWeight: FontWeight.bold,
    ),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 runApp(
    ChangeNotifierProvider(
        create: (context) => AuthService(), child: const MyApp()),
  );
 
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      title: 'Naturix',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            return user != null ? const BtmNavBar() : const LoginPage();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
