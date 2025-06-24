import 'package:flutter/material.dart';
import 'custom_side_menu.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({Key? key}) : super(key: key);
  static const id = "SessionScreen";

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> sessions = [
    {"title": "Healthy thoughts guide", "isSelected": false},
    {"title": "Guided Sessions", "isSelected": false},
    {"title": "Empathy Simulation", "isSelected": true},
    {"title": "Active Therapy", "isSelected": false},
    {"title": "Podcast", "isSelected": false},
  ];

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0.6, 0)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      if (_isMenuOpen) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CustomSideMenu(),
          SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: AbsorbPointer(
                absorbing: _isMenuOpen,
                child: Container(
                  color: Colors.white,
                  child: SafeArea(
                    child: Column(
                      children: [
                        // Menu Icon
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: const Icon(Icons.menu, color: Color(0xFF5A2E6E), size: 28),
                              onPressed: _toggleMenu,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // List of Sessions
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: sessions.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: _buildSessionButton(
                                  title: sessions[index]["title"],
                                  isSelected: sessions[index]["isSelected"],
                                  onTap: () {
                                    setState(() {
                                      for (var session in sessions) {
                                        session["isSelected"] = false;
                                      }
                                      sessions[index]["isSelected"] = true;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        // Skip Button
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFD3A8E0), Color(0xFF5A2E6E)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/next');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              ),
                              child: const Text(
                                "Skip",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E1A4D),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD3A8E0), Color(0xFF5A2E6E)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Colors.redAccent, width: 3)
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
