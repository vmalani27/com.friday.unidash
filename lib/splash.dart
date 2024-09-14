import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  Color _backgroundColor = Colors.white;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    _checkUserStatus(); // Check user authentication status
  }

  void _checkUserStatus() async {
    await Future.delayed(
        const Duration(seconds: 1)); // Simulate splash screen duration

    User? user = FirebaseAuth.instance.currentUser;

    if (mounted) {
      setState(() {
        _backgroundColor = const Color.fromARGB(255, 213, 209, 236);
      });
    }

    await Future.delayed(const Duration(seconds: 2));

    if (user != null) {
      // User is signed in, check if the user document exists in Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        // User document exists, proceed to home screen
        Navigator.pushReplacementNamed(context, '/homescreen');
      } else {
        // User document does not exist, show a popup and sign out
        _showAccountDeletedDialog();
      }
    } else {
      // No user is signed in, navigate to welcome screen
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  void _showAccountDeletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Account Deleted'),
          content: const Text(
              'Your account has been deleted from our system. The app will now exit.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacementNamed(
                    context, '/welcome'); // Navigate to the welcome screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 4),
        color: _backgroundColor,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/logowobg.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Uni-Dash',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
