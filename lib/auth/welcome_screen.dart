import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Top-left "Welcome!"
          Positioned(
            left: screenWidth * 0.05, // 10% from the left
            top: screenHeight * 0.15, // 20% from the top
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Welcome!\n",
                    style: TextStyle(
                        color: const Color.fromARGB(213, 209, 236, 255),
                        fontSize: screenWidth *
                            0.1, // Font size is 10% of screen width
                        fontWeight: FontWeight.w500,
                        shadows: const [Shadow(blurRadius: 3)]),
                  ),
                ],
              ),
            ),
          ),
          // Bottom-right "Uni-Dash"
          Positioned(
            left: screenWidth * 0.17, // 15% from the left
            top: screenHeight * 0.57, // 60% from the top
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Uni-Dash\n",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth *
                            0.05, // Font size is 5% of screen width
                        fontWeight: FontWeight.w500,
                        shadows: const [Shadow(blurRadius: 3)]),
                  ),
                ],
              ),
            ),
          ),
          // Login Button
          Positioned(
            right: screenWidth * 0.15, // 15% from the right
            top: screenHeight * 0.45, // 45% from the top
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(99, 0, 0, 0), // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                elevation: 3,
              ),
              child: Text(
                "Login",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize:
                        screenWidth * 0.05, // Font size is 5% of screen width
                    fontWeight: FontWeight.bold,
                    shadows: const [Shadow(blurRadius: 3)]),
              ),
            ),
          ),
          // Sign Up Button
          Positioned(
            top: screenHeight * 0.55, // 55% from the top
            right: screenWidth * 0.15, // 15% from the right
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/register");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(99, 0, 0, 0), // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                elevation: 3,
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize:
                        screenWidth * 0.05, // Font size is 5% of screen width
                    fontWeight: FontWeight.bold,
                    shadows: const [Shadow(blurRadius: 3)]),
              ),
            ),
          ),
          // Center logo
          Positioned(
            top: screenHeight * 0.36, // 35% from the top
            left: screenWidth * 0.03, // Center horizontally
            child: Container(
              height: 175,
              width: 175,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/logowobg.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
