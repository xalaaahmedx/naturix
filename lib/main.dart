import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naturix/screens/home_page.dart';
import 'package:naturix/widgets/btm_nav_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naturix/features/onboarding/view/screens/on_boarding_screen.dart';
import 'package:naturix/screens/first_onboardingscreen.dart';
import 'package:naturix/core/bloc/core_cubit.dart';
import 'package:naturix/core/config/app_theme.dart';
import 'package:naturix/features/auth/views/blocs/login/login_cubit.dart';
import 'package:naturix/features/auth/views/blocs/register/register_cubit.dart';
import 'package:naturix/features/auth/views/blocs/reset_password/reset_password_cubit.dart';
import 'package:naturix/features/auth/views/blocs/who_am_i/who_am_i_cubit.dart';
import 'features/onboarding/view/bloc/on_boarding_cubit.dart';
import 'generated/codegen_loader.g.dart';

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
  await CoreCubit.setupApp();

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    fallbackLocale: const Locale('en'),
    assetLoader: const CodegenLoader(),
    path: "assets/translations/",
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CoreCubit()),
        BlocProvider(create: (_) => OnBoardingCubit()),
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => RegisterCubit()),
        BlocProvider(create: (_) => WhoAmICubit()),
        BlocProvider(create: (_) => ResetPasswordCubit()),
      ],
      child: Sizer(
        builder: (BuildContext context, Orientation orientation,
            DeviceType deviceType) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: 'Naturix',
            debugShowCheckedModeBanner: false,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasData) {
                    // User is signed in
                    return BtmNavBar(); // Replace with your home page widget
                  } else {
                    // User is not signed in
                    return const OnBoardingScreen();
                  }
                }
              },
            ),
            theme: AppTheme.theme(context),
          );
        },
      ),
    );
  }
}
