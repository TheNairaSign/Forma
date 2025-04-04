import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CaloryContainer extends StatelessWidget {
  const CaloryContainer({super.key});
  // final double height ;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height,
      padding: EdgeInsets.all(10), 
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // Color(0xffc85469),
            // Color(0xfff2849e),

            // Colors.white,
            // Colors.grey,
            Color(0xff5469c8),
            Color(0xff849ef2),
          ],
        )
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xff3a55a0), 
              // color: Color(0xffa03a55),
              // color: Colors.grey,
              borderRadius: BorderRadius.circular(10), 
            ),
            child: Center(
              child: SvgPicture.asset('assets/man-lifting-weights.svg',),
            ),
          ),
          const SizedBox(height: 20),
          Text('2200', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
          Text('Calories', style: TextStyle(color: Colors.white, fontSize: 12),),
        ],
      ),
    );
  }
}