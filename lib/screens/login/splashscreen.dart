import 'dart:async';
import 'package:flutter/material.dart';
import 'package:workoutapp/screens/login/authpage.dart';
import 'package:workoutapp/screens/bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  double opacity = 0.0; // Initial opacity

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        opacity = 1.0;
      });
    });

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const AuthPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(seconds: 2), // Animation duration
              child: Image.asset(
                "assets/bodybuilder.jpg",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'Build Your Body with Us',
                      style: TextStyle(fontSize: 40, color: Colors.amber),
                    ),
                  ),
                  const SizedBox(
                    height: 400,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const NavPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 20),
                      ),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
