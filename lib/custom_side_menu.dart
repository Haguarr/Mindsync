import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_application_1/AchievementsScreen.dart';
import 'package:flutter_application_1/RewardsScreen.dart';
import 'package:flutter_application_1/Signup.dart';
import 'package:flutter_application_1/ProfileScreen.dart';
import 'EchoMind.dart';
import 'ActiveFeedbackScreen.dart';
import 'ActiveTherapyScreen.dart';

class CustomSideMenu extends StatefulWidget {
  const CustomSideMenu({Key? key}) : super(key: key);

  @override
  _CustomSideMenuState createState() => _CustomSideMenuState();
}

class _CustomSideMenuState extends State<CustomSideMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int? _hoveredIndex;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          width: 270,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: Border(
              right: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            gradient: const LinearGradient(
              colors: [Color(0xFF4B0082), Color(0xFF8B5FBF), Color(0xFFD3A8E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildProfileHeader(),
                const Divider(
                  color: Colors.white30,
                  thickness: 0.6,
                  indent: 20,
                  endIndent: 20,
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    children: [
                      _buildMenuItem(Icons.person, 'Profile', ProfileScreen.id, 0),
                      _buildMenuItem(Icons.self_improvement, 'Echo Mind', EchoMind.id, 1),
                      _buildMenuItem(Icons.groups, 'Active Therapy', ActiveTherapyScreen.id, 2),
                      _buildMenuItem(Icons.feedback, 'Feedback', ActiveFeedbackScreen.id, 3),
                      _buildMenuItem(Icons.emoji_events, 'Achievement', AchievementsScreen.id, 4),
                      _buildMenuItem(Icons.card_giftcard, 'Rewards', RewardsScreen.id, 5),
                      _buildMenuItem(Icons.logout, 'Log Out', Signup.id, 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Colors.deepPurpleAccent],
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white,
              backgroundImage: const AssetImage('assets/images/profile.png'),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Haguar El Mallawany',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Member since 2025',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String routeId, int index) {
    final isHovered = _hoveredIndex == index;
    final isSelected = _selectedIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: isHovered ? Matrix4.translationValues(0, -2, 0) : Matrix4.identity(),
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: isHovered || isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: Colors.purpleAccent.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() => _selectedIndex = index);
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, routeId);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    icon,
                    color: isHovered || isSelected ? Colors.white : Colors.white60,
                    size: isHovered ? 25 : 23,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Shimmer.fromColors(
                    enabled: isSelected,
                    baseColor: Colors.white,
                    highlightColor: Colors.pinkAccent,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isHovered ? 16.5 : 15.5,
                        fontWeight: isHovered || isSelected ? FontWeight.w700 : FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
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
