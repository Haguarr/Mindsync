import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'custom_side_menu.dart';

class ActiveFeedbackScreen extends StatefulWidget {
  const ActiveFeedbackScreen({Key? key}) : super(key: key);
  static const id = "ActiveFeedbackScreen";

  @override
  State<ActiveFeedbackScreen> createState() => _ActiveFeedbackScreenState();
}

class _ActiveFeedbackScreenState extends State<ActiveFeedbackScreen> {
  bool _isMicOn = false;
  bool _isCameraOn = false;
  bool _isCallActive = true;
  bool _micPermissionGranted = false;
  bool _cameraPermissionGranted = false;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _requestPermissions();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(_cameras![0], ResolutionPreset.medium);
        await _cameraController!.initialize();
      }
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  Future<void> _requestPermissions() async {
    var micStatus = await Permission.microphone.request();
    var cameraStatus = await Permission.camera.request();
    setState(() {
      _micPermissionGranted = micStatus.isGranted;
      _cameraPermissionGranted = cameraStatus.isGranted;
    });
    if (!_micPermissionGranted || !_cameraPermissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please grant microphone and camera permissions to proceed.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomSideMenu(),
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
                        _scaffoldKey.currentState?.openDrawer();
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

                // Action Buttons with Permission Feedback
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
                        isActive: _isCameraOn && _cameraPermissionGranted,
                        onPressed: _cameraPermissionGranted && _cameraController != null && _cameraController!.value.isInitialized
                            ? () {
                                setState(() {
                                  _isCameraOn = !_isCameraOn;
                                });
                              }
                            : null,
                        tooltip: _cameraPermissionGranted
                            ? 'Toggle Camera'
                            : 'Camera permission denied',
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
                        isActive: _isMicOn && _micPermissionGranted,
                        onPressed: _micPermissionGranted
                            ? () {
                                setState(() {
                                  _isMicOn = !_isMicOn;
                                });
                              }
                            : null,
                        tooltip: _micPermissionGranted
                            ? 'Toggle Microphone'
                            : 'Microphone permission denied',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Camera Preview (if camera is on and initialized)
          if (_isCameraOn && _cameraController != null && _cameraController!.value.isInitialized)
            Positioned.fill(
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 200,
                  child: CameraPreview(_cameraController!),
                ),
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
    required VoidCallback? onPressed,
    bool isRed = false,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: isActive && onPressed != null
                ? const LinearGradient(
                    colors: [Color(0xFFD3A8E0), Color(0xFF5A2E6E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isActive && onPressed != null
                ? null
                : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 28,
            color: isRed
                ? Colors.red
                : isActive && onPressed != null
                    ? Colors.white
                    : Colors.black,
          ),
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