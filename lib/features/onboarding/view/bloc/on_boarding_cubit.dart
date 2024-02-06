import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:naturix/features/auth/views/screens/auth_methods_screen.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());

  int index = 0;
  PageController controller = PageController();

  onPageChanged(int index) {
    this.index = index;
    emit(OnBoardingIndexChanging());
    emit(OnBoardingInitial());
  }

  onNextClick(BuildContext context) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AuthMethodsScreen()),
        //(route) => false
      );
      //navigateToAuthMethodsScreen(context);
    } else {
      index += 1;
      controller.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  onSkipCLick(BuildContext context) {
    navigateToAuthMethodsScreen(context);
  }

  navigateToAuthMethodsScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AuthMethodsScreen()),
        //(route) => false
    );
  }
}
