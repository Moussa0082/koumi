
// import 'package:flutter/material.dart';

// class AnimatedBackground extends StatefulWidget {
//   const AnimatedBackground({super.key});

//   @override
//   State<AnimatedBackground> createState() => _AnimatedBackgroundState();
// }

// class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin{
 

//     late AnimationController _controller;
//   // late Animation<Color> _colorAnimation;



// // @override
// // void initState() {
// //   super.initState();
// //   _controller = AnimationController(
// //     vsync: this,
// //     duration: Duration(seconds: 2),
// //   )..repeat(reverse: true);
// //   ColorTween _colorAnimation = ColorTween(
// //   begin: Color?.fromARGB(255, 0, 0, 0), // Optional alpha channel
// //   end: Color?.fromARGB(255, 255, 165, 0), // Optional alpha channel
// // ).animate(_controller);
// // }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }


//     @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Color(0xFFFFFF), Color(0xFFFFF312)],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// //  class AnimatedBackground extends StatefulWidget {
// //   @override
// //   _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
// // }

// // class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
// //   AnimationController _controller;
// //   Animation<Color> _colorAnimation;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: Duration(seconds: 2),
// //     )..repeat(reverse: true);
// //     _colorAnimation = ColorTween(
// //       begin: Colors.black,
// //       end: Colors.orange,
// //     ).animate(_controller);
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedBuilder(
// //       animation: _controller,
// //       builder: (context, child) {
// //         return Container(
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.topCenter,
// //               end: Alignment.bottomCenter,
// //               colors: [_colorAnimation.value.withOpacity(0.5), _colorAnimation.value.withOpacity(0.8)],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }