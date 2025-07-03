import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'EchoMind.dart';

class AvatarSelection extends StatefulWidget {
  const AvatarSelection({Key? key}) : super(key: key);
  static const id = "AvatarSelection";

  @override
  State<AvatarSelection> createState() => _AvatarSelectionState();
}

class _AvatarSelectionState extends State<AvatarSelection>
    with TickerProviderStateMixin {
  String? _selectedAvatar;
  int? _hoveredIndex;

  // Hover + float animations
  late AnimationController _controller;
  late Animation<double> _buttonScaleAnimation;
  late Animation<Color?> _buttonColorAnimation;
  bool _isContinueButtonHovered = false;

  final List<String> avatarPaths = [
    'assets/images/user1.jpg',
    'assets/images/user11.png',
    'assets/images/man1.png',
    'assets/images/man2.jpg',
    'assets/images/user7.jpg',
    'assets/images/user6.jpg',
    'assets/images/user12.jpg',
    'assets/images/user9.jpg',
    'assets/images/user1.jpg',
    'assets/images/user1.jpg',
    'assets/images/user1.jpg',
    'assets/images/user1.jpg',
    'assets/images/user1.jpg',
    'assets/images/user1.jpg',
    'assets/images/user1.jpg',
    'assets/images/user1.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _buttonColorAnimation = ColorTween(
      begin: const Color(0xFF734F7C),
      end: const Color(0xFFA272A9),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EFF6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            ClipPath(
              clipper: BlobClipper(),
              child: Container(
                height: 150,
                color: const Color(0xFF734F7C),
                child: Center(
                  child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.purple.shade100,
                    child: const Text(
                      "Create Your Avatar",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.black45,
                            offset: Offset(1.5, 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Avatar Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                itemCount: avatarPaths.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return buildAvatar('avatar$index', avatarPaths[index], index);
                },
              ),
            ),

            const SizedBox(height: 20),

            // Continue Button
            MouseRegion(
              onEnter: (_) {
                if (_selectedAvatar != null) {
                  setState(() => _isContinueButtonHovered = true);
                  _controller.forward();
                }
              },
              onExit: (_) {
                setState(() => _isContinueButtonHovered = false);
                _controller.reverse();
              },
              child: GestureDetector(
                onTap: _selectedAvatar == null
                    ? null
                    : () {
                        Navigator.pushNamed(context, EchoMind.id);
                      },
                child: ScaleTransition(
                  scale: _buttonScaleAnimation,
                  child: Container(
                    width: 240,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _buttonColorAnimation.value ??
                              const Color(0xFF734F7C),
                          _isContinueButtonHovered
                              ? const Color(0xFFA272A9)
                              : const Color(0xFF734F7C),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Footer Blob
            ClipPath(
              clipper: BottomBlobClipper(),
              child: Container(
                height: 80,
                color: const Color(0xFF734F7C).withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAvatar(String id, String assetPath, int index) {
    final bool isSelected = _selectedAvatar == id;
    final bool isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedAvatar = id;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? Colors.greenAccent
                  : isHovered
                      ? Colors.purpleAccent
                      : Colors.transparent,
              width: 2.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Shimmer.fromColors(
            enabled: isHovered,
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: CircleAvatar(
              backgroundImage: AssetImage(assetPath),
              backgroundColor: Colors.grey[200],
              radius: 30,
            ),
          ),
        ),
      ),
    );
  }
}

// Top wave
class BlobClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.6);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height * 0.85);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.7, size.width, size.height * 0.85);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Bottom wave
class BottomBlobClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.3,
        size.width * 0.5, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.1,
        size.width, size.height * 0.3);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
