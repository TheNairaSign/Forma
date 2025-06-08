// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:workout_tracker/auth/auth_wrapper.dart';
import 'package:workout_tracker/style/global_colors.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthWrapper())));
  }

  final threeBounceSpinner = SpinKitChasingDots(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.primaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInRight(
                  duration: Duration(milliseconds: 1000),
                  child: Text('F', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                FadeInRight(
                  duration: Duration(milliseconds: 1500),
                  child: Text('O', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                FadeInRight(
                  duration: Duration(milliseconds: 2000),
                  child: Text('R', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                FadeInRight(
                  duration: Duration(milliseconds: 2500),
                  child: Text('M', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                FadeInRight(
                  duration: Duration(milliseconds: 3000),
                  child: Text('A', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            FadeIn(
              delay: Duration(milliseconds: 3500),
              child: SizedBox(
                width: 120,
                child: LinearProgressIndicator(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}