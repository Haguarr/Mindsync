import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CameraAssistantScreen extends StatefulWidget {
  const CameraAssistantScreen({Key? key}) : super(key: key);
  static const id = "CameraAssistantScreen";

  @override
  State<CameraAssistantScreen> createState() => _CameraAssistantScreenState();
}

class _CameraAssistantScreenState extends State<CameraAssistantScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _cameraFloatController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _cameraFloatAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _cameraFloatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _cameraFloatAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _cameraFloatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _cameraFloatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EFF6),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5A2E6E), Color(0xFFD3A8E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Title shimmer
              Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.amberAccent,
                child: const Text(
                  "Camera Assistant",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black26,
                        offset: Offset(1.5, 1.5),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Animated pulse camera frame
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (_, __) => Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/camera.jpg'), // Replace with your asset
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.15),
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Subtitle
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Let me see how you're feeling...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    color: Colors.white70,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Floating camera button
              AnimatedBuilder(
                animation: _cameraFloatAnimation,
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, -_cameraFloatAnimation.value),
                  child: GestureDetector(
                    onTap: () {
                      // Add camera logic here
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFA272A9), Color(0xFF734F7C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
