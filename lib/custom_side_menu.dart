import 'package:flutter/material.dart';
import 'package:flutter_application_1/Signup.dart';
import 'EchoMind.dart';
import 'ActiveFeedbackScreen.dart';
import 'ActiveTherapyScreen.dart';
import 'SessionScreen.dart';
import 'TasksScreen.dart';
import 'LoginScreen.dart'; // For logout

class CustomSideMenu extends StatelessWidget {
  const CustomSideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5A2E6E), Color(0xFFD3A8E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _buildMenuItem(context, Icons.self_improvement, 'Echo Mind', EchoMind.id),
            _buildMenuItem(context, Icons.groups, 'Gather (Therapy)', ActiveTherapyScreen.id),
            _buildMenuItem(context, Icons.feedback, 'Feedback', ActiveFeedbackScreen.id),
            _buildMenuItem(context, Icons.emoji_events, 'Achievement', SessionScreen.id),
            _buildMenuItem(context, Icons.card_giftcard, 'Rewards', TasksScreen.id),
            _buildMenuItem(context, Icons.logout, 'Log Out', Signup.id),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String routeId) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        Navigator.pushReplacementNamed(context, routeId); // Navigate
      },
    );
  }
}
