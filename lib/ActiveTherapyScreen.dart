import 'package:flutter/material.dart';
import 'custom_side_menu.dart';
import 'dart:math';

class ActiveTherapyScreen extends StatefulWidget {
  const ActiveTherapyScreen({Key? key}) : super(key: key);
  static const id = "ActiveTherapyScreen";

  @override
  State<ActiveTherapyScreen> createState() => _ActiveTherapyScreenState();
}

class _ActiveTherapyScreenState extends State<ActiveTherapyScreen> {
  bool _isMicOn = true;
  bool _isCameraOn = false;
  bool _isCallActive = true;

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
              height: 180,
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
              height: 120,
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
                // Menu Icon (opens drawer)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Title
                const Text(
                  "Active Therapy",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B2CBF),
                  ),
                ),

                const SizedBox(height: 40),

                // Avatars Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAvatar('assets/images/activ1.png'),
                          _buildAvatar('assets/images/activ2.png'),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAvatar('assets/images/activ3.png'),
                          _buildAvatar('assets/images/activ4.png'),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom Action Buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
                        isActive: _isCameraOn,
                        onPressed: () {
                          setState(() {
                            _isCameraOn = !_isCameraOn;
                          });
                        },
                      ),
                      _buildActionButton(
                        icon: _isCallActive ? Icons.call : Icons.call_end,
                        isActive: _isCallActive,
                        isRed: !_isCallActive,
                        onPressed: () {
                          setState(() {
                            _isCallActive = !_isCallActive;
                          });
                        },
                      ),
                      _buildActionButton(
                        icon: _isMicOn ? Icons.mic : Icons.mic_off,
                        isActive: _isMicOn,
                        onPressed: () {
                          setState(() {
                            _isMicOn = !_isMicOn;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String imagePath) {
    return CircleAvatar(
      radius: 40,
      backgroundImage: AssetImage(imagePath),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
    bool isRed = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFFD3A8E0), Color(0xFF5A2E6E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 28,
          color: isRed
              ? Colors.red
              : isActive
                  ? Colors.white
                  : Colors.black,
        ),
      ),
    );
  }
}

// Custom Clipper
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
