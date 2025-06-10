import 'package:flutter/material.dart';
import 'EchoMind.dart';

class AvatarSelection extends StatefulWidget {
  const AvatarSelection({Key? key}) : super(key: key);
  static const id = "AvatarSelection";

  @override
  State<AvatarSelection> createState() => _AvatarSelectionState();
}

class _AvatarSelectionState extends State<AvatarSelection> {
  String? _selectedAvatar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            ClipPath(
              clipper: BlobClipper(),
              child: Container(
                height: 200,
                color: const Color(0xFF734F7C),
                child: const Center(
                  child: Text(
                    "Select your Avatar",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Avatar Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 6, // Further reduced spacing
                crossAxisSpacing: 6, // Further reduced spacing
                childAspectRatio: 1.0, // Reset to 1 for square cells
                children: [
                  buildAvatar('man1', 'images/man1.png'),
                  buildAvatar('man2', 'images/man2.png'),
                  buildAvatar('man3', 'images/man3.png'),
                  buildAvatar('man4', 'images/man4.png'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: _selectedAvatar == null
                    ? null
                    : () {
                        Navigator.pushNamed(context, EchoMind.id);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF734F7C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bottom Blob
            ClipPath(
              clipper: BlobClipper(),
              child: Container(
                height: 100,
                color: const Color(0xFF734F7C).withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAvatar(String id, String assetPath) {
    bool isSelected = _selectedAvatar == id;
    return SizedBox(
      width: 20, // Explicitly set width
      height: 20, // Explicitly set height
      child: GestureDetector(
        onTap: () => setState(() => _selectedAvatar = id),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 15, // Reduced to 15 (30px diameter)
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(assetPath),
          ),
        ),
      ),
    );
  }
}

// BlobClipper unchanged
class BlobClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.6, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}