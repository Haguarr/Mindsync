// Ensure you add the Poppins font to your pubspec.yaml:

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Forgot extends StatefulWidget {
  const Forgot({Key? key}) : super(key: key);
  static const id = "Forgot";

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isBackButtonHovered = false;
  bool _isResetButtonHovered = false;
  bool _isLoading = false;
  bool _showSuccessMessage = false;
  late AnimationController _resetController;
  late AnimationController _backController;
  late Animation<double> _resetScaleAnimation;
  late Animation<Color?> _resetColorAnimation;
  late Animation<double> _backScaleAnimation;
  late Animation<Color?> _backColorAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for reset button
    _resetController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize animation controller for back button
    _backController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Scale animation for reset button
    _resetScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOutBack),
    );

    // Color animation for reset button hover
    _resetColorAnimation = ColorTween(
      begin: const Color(0xFF734F7C),
      end: const Color(0xFF9B5BA6),
    ).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeInOut),
    );

    // Scale animation for back button
    _backScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _backController, curve: Curves.easeOutBack),
    );

    // Color animation for back button hover
    _backColorAnimation = ColorTween(
      begin: const Color(0xFFA272A9),
      end: const Color(0xFF734F7C),
    ).animate(
      CurvedAnimation(parent: _backController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _resetController.dispose();
    _backController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F3F7),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipPath(
                  clipper: BlobClipper(),
                  child: Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF734F7C), Color(0xFF5B3A64)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Reset Your Password",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.account_circle_outlined,
                              size: 20,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "By MindSync",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Color(0xFF734F7C),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: _showSuccessMessage ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Link sent to email',
                                    style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        MouseRegion(
                          onEnter: (_) {
                            setState(() => _isResetButtonHovered = true);
                            _resetController.forward();
                          },
                          onExit: (_) {
                            setState(() => _isResetButtonHovered = false);
                            _resetController.reverse();
                          },
                          child: GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                        _showSuccessMessage = false;
                                      });
                                      try {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                          email: _emailController.text.trim(),
                                        );
                                        setState(() {
                                          _showSuccessMessage = true;
                                          _isLoading = false;
                                        });
                                        await Future.delayed(
                                            const Duration(seconds: 3));
                                        setState(() {
                                          _showSuccessMessage = false;
                                        });
                                      } catch (e) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Error: ${e.toString()}'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                            child: ScaleTransition(
                              scale: _resetScaleAnimation,
                              child: Container(
                                width: 250,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _resetColorAnimation.value ??
                                          const Color(0xFF734F7C),
                                      _isResetButtonHovered
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
                                child: Stack(
                                  children: [
                                    // Shimmer effect
                                    if (_isResetButtonHovered)
                                      AnimatedOpacity(
                                        opacity: _isResetButtonHovered ? 0.3 : 0.0,
                                        duration: const Duration(milliseconds: 300),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.1),
                                                Colors.white.withOpacity(0.4),
                                                Colors.white.withOpacity(0.1),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                        ),
                                      ),
                                    Center(
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              "Reset Password",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                fontFamily: 'Poppins',
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        MouseRegion(
                          onEnter: (_) {
                            setState(() => _isBackButtonHovered = true);
                            _backController.forward();
                          },
                          onExit: (_) {
                            setState(() => _isBackButtonHovered = false);
                            _backController.reverse();
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: ScaleTransition(
                              scale: _backScaleAnimation,
                              child: Container(
                                width: 250,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _backColorAnimation.value ??
                                          const Color(0xFFA272A9),
                                      _isBackButtonHovered
                                          ? const Color(0xFF734F7C)
                                          : const Color(0xFFA272A9),
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
                                child: Stack(
                                  children: [
                                    // Shimmer effect
                                    if (_isBackButtonHovered)
                                      AnimatedOpacity(
                                        opacity: _isBackButtonHovered ? 0.3 : 0.0,
                                        duration: const Duration(milliseconds: 300),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.1),
                                                Colors.white.withOpacity(0.4),
                                                Colors.white.withOpacity(0.1),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                        ),
                                      ),
                                    Center(
                                      child: Text(
                                        "Back",
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BlobClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.85);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 1.1, size.width * 0.5, size.height * 0.95);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.7, size.width, size.height * 0.95);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}