import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final Widget child;

  const SplashScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Simulate a delay for the splash screen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => child),
      );
    });

    return const Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_shopping_cart_outlined,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Atts Super Market',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
