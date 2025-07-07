import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CaloriesBurntPage extends StatefulWidget {
  const CaloriesBurntPage({super.key, required this.caloriesBurnt});
  final int? caloriesBurnt;

  @override
  State<CaloriesBurntPage> createState() => _CaloriesBurntPageState();
}

class _CaloriesBurntPageState extends State<CaloriesBurntPage> {

  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(Duration(seconds: 3), () {
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => NavigationPage()));
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Congrats, you just burnt ${widget.caloriesBurnt} calories!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          LottieBuilder.asset('assets/lottie/check-animation.json', repeat: false)
        ],
      ),
    );
  }
}