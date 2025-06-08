// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:workout_tracker/style/global_colors.dart';
// import 'package:workout_tracker/utils/custom_route.dart';
// import 'package:workout_tracker/views/pages/auth/login_page.dart.dart';
// import 'package:workout_tracker/views/pages/auth/sign_up_page.dart.dart';
// import 'package:workout_tracker/views/pages/navigation/navigation_page.dart';
// import 'package:workout_tracker/views/widgets/animated_page_entry.dart';
// import 'package:workout_tracker/views/widgets/blue_button.dart';

// class AuthPageView extends StatefulWidget {
//   const AuthPageView({super.key});

//   @override
//   State<AuthPageView> createState() => _AuthPageViewState();
// }

// class _AuthPageViewState extends State<AuthPageView> {
//   int _currentPage = 0;
  
//   @override
//   Widget build(BuildContext context) {
//     final pageController = PageController(initialPage: _currentPage);
//     return Scaffold(
//       body: AnimatedPageEntry(
//         verticalOffset: 50,
//         children: [
//           Center(child: Text('FORMA', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: GlobalColors.purple))),
//           Text('Login to your Account', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
//           Lottie.asset('assets/lottie/workout-duo-animation.json'),
          
//           SizedBox(
//             height: 200,
//             child: PageView(
//               controller: pageController,
//               physics: const BouncingScrollPhysics(),
//               onPageChanged: (value) {
//                 setState(() {
//                   _currentPage = value;
//                 });
//               },
//               children: [
//                 LoginPage(),
//                 SignUpPage()
//               ],
//             ),
            
//           ),
//           // BlueButton(onPressed: () {
//           //   p
//           // }, text: text)
//           BlueButton(onPressed: () => Navigator.of(context).pushReplacement(SlidePageRoute(page: NavigationPage())), text: 'Login'),

//           Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Already have an account?", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
//                   const SizedBox(width: 5),
//                   GestureDetector(
//                     onTap: () => Navigator.of(context).push(
//                       SlidePageRoute(page: LoginPage())
//                     ),
//                     child: Text("Login", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: GlobalColors.primaryBlue))),
//                 ],
//               )
//         ],
//       ),
//     );
//   }
// }