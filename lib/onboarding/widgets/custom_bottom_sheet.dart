import 'package:flutter/material.dart';
import 'package:workout_tracker/onboarding/screens/avatar_page.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/widgets/fluid_press_button.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({super.key, required this.currentPage, required this.pages, required this.onPressed});
  final int currentPage, pages;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final pageText = currentPage == pages - 1 ? 'Finish' : 'Continue';
    return Container(
      height: 110,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        // color: Color(0xff7064e3),
        color: GlobalColors.primaryColor,
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        // borderRadius: BorderRadius.vertical(top: Radius.circular(30))
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PickAvatarPage())), 
            child: Text(
              'Do it later', 
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)
            )
          ),
          const Spacer(),
          SizedBox(
            height: 50,
            // child: ElevatedButton.icon(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.white,
            //     // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(15)
            //     )
            //   ),
            //   onPressed: onPressed,
            //   iconAlignment: IconAlignment.end,
            //   icon: Icon(Icons.keyboard_double_arrow_right, color: Colors.black, size: 15,),
            //   label: Text(
            //     pageText,
            //     style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)
            //   )
            // ),
            child: FluidPressButton(
              onPressed: onPressed, 
              text: pageText, 
              trailIcon: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Icon(Icons.keyboard_double_arrow_right, color: Colors.black, size: 15),
              )
            ),
          )
        ],
      ),
    );
  }
}