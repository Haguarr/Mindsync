import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

bool pass = true;

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);
  static const id = "Signup";

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  String? _errorMessage;
  DateTime? _lastTap;

  // Debounce tap events to prevent rapid interactions
  void _handleTap(FocusNode focusNode) {
    final now = DateTime.now();
    if (_lastTap == null || now.difference(_lastTap!).inMilliseconds > 300) {
      FocusScope.of(context).requestFocus(focusNode);
      _lastTap = now;
    }
  }

  // Function to handle API login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Replace with your actual server IP or URL (localhost won't work on mobile)
        final response = await http.post(
          Uri.parse('http://your-server-ip:3000/login'), // Update this URL
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _emailController.text.trim(),
            'password': _passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          // Successful login
          Navigator.pushNamed(context, 'SplashScreen');
        } else {
          // Decode error message from response
          final error = jsonDecode(response.body)['message'] ?? 'Unknown error';
          setState(() {
            _errorMessage = 'Login failed: $error';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header with updated color
              Container(
                height: 250,
                color: const Color(0xFF734F7C), // Replaced Colors.deepPurple
                child: const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Email TextField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onTap: () => _handleTap(_emailFocus),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 15),

              // Password TextField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: pass,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          pass = !pass;
                        });
                      },
                      icon: const Icon(Icons.remove_red_eye),
                    ),
                  ),
                  onTap: () => _handleTap(_passwordFocus),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 15),

              // Error Message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 15),

              // Forgot Password Button
              Padding(
                padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'Forgot');
                  },
                  child: const Text(
                    "Forgot my password",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Login Button with updated color
              Container(
                width: 250,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF734F7C), // Replaced Colors.deepPurple
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Link to MindSync's Workspace with updated colors (moved here)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_circle,
                    size: 20,
                    color: Color(0xFF734F7C), // Replaced Colors.deepPurple
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () async {
                      final url = Uri.parse("https://www.gather.town/");
                      if (!await launchUrl(
                        url,
                        mode: LaunchMode.platformDefault,
                      )) {
                        setState(() {
                          _errorMessage = 'Could not launch $url';
                        });
                      }
                    },
                    child: const Text(
                      "To MindSync's Workspace",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA272A9), // Replaced Colors.deepPurpleAccent
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Signup link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an Account?",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'LoginScreen');
                    },
                    child: const Text(
                      "Sign me up",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
}

// BlobClipper
class BlobClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.6, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}