import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:naturix/core/config/app_theme.dart';

showFlushBar(
    BuildContext context,
    {
      String title = "",
      String message = ""
    }
){
  Flushbar(
    title: title,
    message: message,
    backgroundColor: AppTheme.neutral800,
    flushbarPosition: FlushbarPosition.TOP, // Set position to TOP
    duration: const Duration(seconds: 3),
  ).show(context);
}