import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

bool pass = true;

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);
  static const id = "Signup";

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  String? _errorMessage;
  DateTime? _lastTap;
  bool _isWorkspaceHovered = false;
  bool _isLoginButtonHovered = false;
  late AnimationController _controller;
  late Animation<double> _buttonScaleAnimation;
  late Animation<Color?> _buttonColorAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for login button
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Scale animation for login button
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Color animation for login button hover
    _buttonColorAnimation = ColorTween(
      begin: const Color(0xFF734F7C),
      end: const Color(0xFF9B5BA6),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _handleTap(FocusNode focusNode) {
    final now = DateTime.now();
    if (_lastTap == null || now.difference(_lastTap!).inMilliseconds > 300) {
      FocusScope.of(context).requestFocus(focusNode);
      _lastTap = now;
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        Navigator.pushNamed(context, 'ProfileScreen');
      } on FirebaseAuthException catch (e) {
        setState(() {
          switch (e.code) {
            case 'user-not-found':
              _errorMessage = 'No user found with this email.';
              break;
            case 'wrong-password':
              _errorMessage = 'Incorrect password.';
              break;
            case 'invalid-email':
              _errorMessage = 'Invalid email address.';
              break;
            default:
              _errorMessage = 'Login failed: ${e.message}';
          }
        });
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
              ClipPath(
                clipper: BlobClipper(),
                child: Container(
                  height: 250,
                  color: const Color(0xFF734F7C),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        MouseRegion(
                          onEnter: (_) => setState(() => _isWorkspaceHovered = true),
                          onExit: (_) => setState(() => _isWorkspaceHovered = false),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle,
                                size: 20,
                                color: _isWorkspaceHovered ? Colors.white : const Color(0xFFA272A9),
                              ),
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: () async {
                                  final url = Uri.parse("https://www.gather.town/");
                                  if (!await launchUrl(url)) {
                                    setState(() {
                                      _errorMessage = 'Could not launch $url';
                                    });
                                  }
                                },
                                child: Text(
                                  "To MindSync's Workspace",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: _isWorkspaceHovered ? Colors.white : const Color(0xFFA272A9),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
                    if (value.length < 2) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 15),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'Forgot');
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              MouseRegion(
                onEnter: (_) {
                  setState(() => _isLoginButtonHovered = true);
                  _controller.forward();
                },
                onExit: (_) {
                  setState(() => _isLoginButtonHovered = false);
                  _controller.reverse();
                },
                child: GestureDetector(
                  onTap: _login,
                  child: ScaleTransition(
                    scale: _buttonScaleAnimation,
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _buttonColorAnimation.value ?? const Color(0xFF734F7C),
                            _isLoginButtonHovered ? const Color(0xFFA272A9) : const Color(0xFF734F7C),
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
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
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
                    child: Text(
                      "Sign me up",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _isLoginButtonHovered ? const Color(0xFFA272A9) : const Color(0xFF734F7C),
                        fontFamily: 'Poppins',
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
    _controller.dispose();
    super.dispose();
  }
}

class BlobClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.85); // Increased height for bigger upward curve
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 1.1, size.width * 0.5, size.height * 0.95); // Adjusted for larger upward curve
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.7, size.width, size.height * 0.95); // Adjusted for larger upward curve
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}