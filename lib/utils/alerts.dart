import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:workout_tracker/style/global_colors.dart';

class Alerts {
  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message, style: Theme.of(context).textTheme.bodyMedium,), 
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.all(10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showFlushBar(BuildContext context, String message, bool isError) {
    Flushbar().dismiss();
    Flushbar(
      message: message,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      borderRadius: BorderRadius.circular(5),
      messageText: Row(
        children: [
          Icon(isError? Icons.error_outline : Icons.check_circle_outline, color: isError? Colors.red : GlobalColors.primaryColor),
          const SizedBox(width: 10),
          FittedBox(child: Text(message, style: Theme.of(context).textTheme.bodySmall?.copyWith(color:  isError ? Colors.red : Colors.black),)),
        ],
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: isError ? const Color(0xfffef2f2) : GlobalColors.primaryColorLight,
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  static void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black, fontSize: 25),),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: GlobalColors.primaryBlue)),
          ),
        ],
      ),
    );
  }

  static showRetryDialog(BuildContext context, Function onRetry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Connection Error", style:Theme.of(context).textTheme.bodyMedium),
        content: Text("Could not fetch data", style:Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry();
            }, 
            child: Text("Retry", style:Theme.of(context).textTheme.bodyMedium)
            )
        ],
      ),
    );
  }

  static areYouSureDialog(BuildContext context, Function onYes, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // backgroundColor: ,
        title: Text("Are you sure?", style:Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        content: Text(message, style:Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("No", style:Theme.of(context).textTheme.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onYes();
            },
            child: Text("Yes", style:Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );  
  }

  static showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // LoadingSpinner(),
                SizedBox(width: 20),
                Text("Loading..."), // Optional text
              ],
            ),
          ),
        );
      },
    );
  }
}