import 'dart:io';

import 'package:batoro/screens/home.dart';
import 'package:batoro/utils/constants/colors.dart';
import 'package:batoro/utils/constants/file_scanner.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingSreen extends StatelessWidget {
  const OnboardingSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: BColors.lightGrey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 30.0, right: 150),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome To ',
                      style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w700, fontSize: 35),
                    ),
                    TextSpan(
                      text: 'Batoro',
                      style: TextStyle(fontFamily: 'Mistrully', fontWeight: FontWeight.w700, fontSize: 45, letterSpacing: 2),
                    ),
                  ],
                ),
              ),
            ),
            Image.asset('assets/images/welcome_option_alpha-removebg-preview.png', scale: 0.7),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 90),
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BColors.allFiles,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen())
                    ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Get Started', style: TextStyle(fontFamily: 'Raleway', fontSize: 15, color: BColors.white, fontWeight: FontWeight.w600)),
                      SizedBox(width: 20),
                      Icon(Icons.arrow_forward, color: BColors.white),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Privacy Policy', style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w600, color: Colors.black, decoration: TextDecoration.underline)),
            ),
          ],
        ),
      ),
    );
  }
}
