import 'package:flutter/material.dart';
import 'custom_side_menu.dart';

class ActiveFeedbackScreen extends StatefulWidget {
  const ActiveFeedbackScreen({Key? key}) : super(key: key);
  static const id = "ActiveFeedbackScreen";

  @override
  State<ActiveFeedbackScreen> createState() => _ActiveFeedbackScreenState();
}

class _ActiveFeedbackScreenState extends State<ActiveFeedbackScreen> {
  bool _isMicOn = true;
  bool _isCameraOn = false;
  bool _isCallActive = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // 👈 Needed for opening drawer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // 👈 Connect it
      drawer: const CustomSideMenu(), // 👈 Custom Drawer
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Decorative Gradient Blob
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

          // Bottom Blob
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
                // Menu Button
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer(); // 👈 Open drawer
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Active Feedback",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B2CBF),
                  ),
                ),

                const SizedBox(height: 40),

                // Avatars
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAvatarWithName('assets/images/activ1.png', 'George'),
                          _buildAvatarWithName('assets/images/activ2.png', 'Jane'),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAvatarWithName('assets/images/activ4.png', 'Anna'),
                          _buildAvatarWithName('assets/images/activv4.png', 'John'),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Action Buttons
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

  Widget _buildAvatarWithName(String imagePath, String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
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
