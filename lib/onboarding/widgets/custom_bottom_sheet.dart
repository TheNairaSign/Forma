import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xff7064e3),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () {}, 
            child: Text(
              'Do it later', 
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)
            )
          ),
          const Spacer(),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                )
              ),
              onPressed: () {},
              iconAlignment: IconAlignment.end,
              icon: Icon(Icons.keyboard_double_arrow_right, color: Colors.black, size: 15,),
              label: Text(
                'Let\'s do it',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)
              )
            ),
          )
        ],
      ),
    );
  }
}