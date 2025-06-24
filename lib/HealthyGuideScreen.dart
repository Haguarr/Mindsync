import 'package:flutter/material.dart';
import 'custom_side_menu.dart'; // Assuming this is defined elsewhere
import 'dart:math' as math;

class HealthyGuideScreen extends StatefulWidget {
  const HealthyGuideScreen({Key? key}) : super(key: key);
  static const id = "HealthyGuideScreen";

  @override
  State<HealthyGuideScreen> createState() => _HealthyGuideScreenState();
}

class _HealthyGuideScreenState extends State<HealthyGuideScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomSideMenu(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Gradient Blob
          ClipPath(
            clipper: TopBlobClipper(),
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5A2E6E), Color(0xFFD3A8E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Bottom Gradient Blob
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD3A8E0), Color(0xFF5A2E6E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Menu and Back Icons
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        onPressed: () {
                          Navigator.pop(context); // Navigate back
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Title
                const Text(
                  "Healthy Guide",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B2CBF),
                  ),
                ),

                const SizedBox(height: 40),

                // Central Image Placeholder
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Image.asset(
                    'assets/images/health.png', // Replace with your image path
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20),

                // Text Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Text(
                    "What if I told you that your inner struggles are more important than those in the outside world? If you not a medium member click here to read full story",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Clickable Link (simulated)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle click action (e.g., navigate to a story page)
                      print("Clicked to read full story");
                    },
                    child: const Text(
                      "click here to read full story",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for top decorative blob
class TopBlobClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.5, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

