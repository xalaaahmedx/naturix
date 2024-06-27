import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:naturix/firebase_options.dart';
import 'package:naturix/recommendation/views/blocs/recommendation_cubit.dart';
import 'package:naturix/recommendation/views/blocs/shopping_list/shopping_list_cubit.dart';
import 'package:naturix/screens/login_page.dart';
import 'package:naturix/services/auth/auth_sarvice.dart';

import 'package:naturix/widgets/btm_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'helper/firebase_notification_helper.dart';

final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 138, 255, 241),
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
  FirebaseNotificationHelper().notificationInit();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            Provider(create: (_) => RecommendationCubit()),
            Provider(create: (_) => ShoppingListCubit()),
          ],
          child: MaterialApp(
            theme: theme,
            title: 'Naturix',
            debugShowCheckedModeBanner: false,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final User? user = snapshot.data;
                  if (user != null) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.email)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data == null || !snapshot.data!.exists) {
                            return const Text('User document does not exist');
                          }

                          Map<String, dynamic>? data =
                              snapshot.data!.data() as Map<String, dynamic>?;
                          if (data == null) {
                            return const Text('No data found in user document');
                          }

                          String? userRole = data['role'];

                          if (userRole == null) {
                            return const LoginPage();
                          }

                          return BtmNavBar(role: userRole);
                        }

                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                  } else {
                    return const LoginPage();
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        );
      },
    );
  }
}
