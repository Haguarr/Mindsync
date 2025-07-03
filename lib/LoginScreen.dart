// Ensure you add the Poppins font to your pubspec.yaml:
// flutter:
//   fonts:
//     - family: Poppins
//       fonts:
//         - asset: fonts/Poppins-Bold.ttf
//           weight: 800
//         - asset: fonts/Poppins-SemiBold.ttf
//           weight: 600
//         - asset: fonts/Poppins-Regular.ttf
//           weight: 400

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool pass = true;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const id = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isBackButtonHovered = false;
  bool _isSignUpButtonHovered = false;
  bool _isContinueButtonHovered = false;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _errorMessage;
  String? _successMessage;

  late AnimationController _strengthController;
  late AnimationController _signUpController;
  late AnimationController _backController;
  late AnimationController _alertController;
  late AnimationController _continueController;
  late Animation<double> _strengthAnimation;
  late Animation<double> _signUpScaleAnimation;
  late Animation<Color?> _signUpColorAnimation;
  late Animation<double> _backScaleAnimation;
  late Animation<Color?> _backColorAnimation;
  late Animation<double> _continueScaleAnimation;
  late Animation<Color?> _continueColorAnimation;
  late Animation<Offset> _alertSlideAnimation;
  String _passwordStrength = 'Weak';
  Color _strengthColor = Colors.red;
  bool _showIndicator = false;

  @override
  void initState() {
    super.initState();
    _strengthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _signUpController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _backController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _alertController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _continueController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _strengthAnimation = CurvedAnimation(parent: _strengthController, curve: Curves.easeOut);
    _signUpScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _signUpController, curve: Curves.easeOutBack),
    );
    _signUpColorAnimation = ColorTween(
      begin: const Color(0xFF734F7C),
      end: const Color(0xFF9B5BA6),
    ).animate(
      CurvedAnimation(parent: _signUpController, curve: Curves.easeInOut),
    );
    _backScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _backController, curve: Curves.easeOutBack),
    );
    _backColorAnimation = ColorTween(
      begin: const Color(0xFFA272A9),
      end: const Color(0xFF734F7C),
    ).animate(
      CurvedAnimation(parent: _backController, curve: Curves.easeInOut),
    );
    _continueScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _continueController, curve: Curves.easeOutBack),
    );
    _continueColorAnimation = ColorTween(
      begin: const Color(0xFF734F7C),
      end: const Color(0xFF9B5BA6),
    ).animate(
      CurvedAnimation(parent: _continueController, curve: Curves.easeInOut),
    );
    _alertSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _alertController, curve: Curves.easeOutCubic),
    );

    // Clear error messages when user types
    _nameController.addListener(() {
      if (_nameError != null && _nameController.text.isNotEmpty) {
        setState(() {
          _nameError = null;
        });
      }
    });
    _emailController.addListener(() {
      if (_emailError != null && _emailController.text.isNotEmpty) {
        final email = _emailController.text.trim();
        if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
          setState(() {
            _emailError = null;
          });
        }
      }
    });
    _passwordController.addListener(() {
      if (_passwordError != null && _passwordController.text.isNotEmpty) {
        setState(() {
          _passwordError = null;
        });
      }
    });
    _confirmPasswordController.addListener(() {
      if (_confirmPasswordError != null && _confirmPasswordController.text.isNotEmpty) {
        setState(() {
          _confirmPasswordError = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _strengthController.dispose();
    _signUpController.dispose();
    _backController.dispose();
    _alertController.dispose();
    _continueController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _showIndicator = false;
        _strengthController.reset();
      });
      return;
    }

    setState(() {
      _showIndicator = true;
      if (!_strengthController.isCompleted) {
        _strengthController.forward();
      }
    });

    if (password.length < 8) {
      setState(() {
        _passwordStrength = 'Password is weak';
        _strengthColor = Colors.red;
      });
      return;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasNumbers = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#\$&*~]'));

    if (hasUppercase && hasLowercase && hasNumbers && hasSpecial) {
      setState(() {
        _passwordStrength = 'Password is strong';
        _strengthColor = Colors.green;
      });
    } else if ((hasUppercase || hasLowercase) && hasNumbers) {
      setState(() {
        _passwordStrength = 'Password is medium';
        _strengthColor = Colors.blue;
      });
    } else {
      setState(() {
        _passwordStrength = 'Password is weak';
        _strengthColor = Colors.red;
      });
    }
  }

  Future<void> registerUser() async {
    final email = _emailController.text.trim();
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'Please fill out Username' : null;
      _emailError = _emailController.text.isEmpty
          ? 'Please fill out Email'
          : !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)
              ? 'Please enter a valid email address'
              : null;
      _passwordError = _passwordController.text.isEmpty ? 'Please fill out Password' : null;
      _confirmPasswordError = _confirmPasswordController.text.isEmpty ? 'Please fill out Confirm Password' : null;
    });

    if (_nameError != null || _emailError != null || _passwordError != null || _confirmPasswordError != null) {
      setState(() {
        _errorMessage = 'Please fill in all fields correctly';
      });
      _alertController.forward();
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        _errorMessage = null;
      });
      _alertController.reverse();
      return;
    }

    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      _alertController.forward();
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        _errorMessage = null;
      });
      _alertController.reverse();
      return;
    }

    if (_passwordStrength != 'Password is strong') {
      setState(() {
        _errorMessage = 'Password must be strong';
      });
      _alertController.forward();
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        _errorMessage = null;
      });
      _alertController.reverse();
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      setState(() {
        _successMessage = 'Account created successfully!';
      });
      _alertController.forward();
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        _successMessage = null;
      });
      _alertController.reverse();
      Navigator.pushNamed(context, 'CreateAvatarScreen');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email is already in use';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        default:
          message = 'Registration failed: ${e.message}';
      }
      setState(() {
        _errorMessage = message;
      });
      _alertController.forward();
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        _errorMessage = null;
      });
      _alertController.reverse();
    } catch (e) {
      setState(() {
        _errorMessage = 'Unexpected error: $e';
      });
      _alertController.forward();
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        _errorMessage = null;
      });
      _alertController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ClipPath(
                  clipper: BlobClipper(),
                  child: Container(
                    height: 250,
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
                          "Register",
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
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.account_circle_outlined,
                              size: 20,
                              color: Color(0xFFA272A9),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "By MindSync",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFA272A9),
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
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            errorText: _nameError,
                            errorStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.red,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) => null,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            errorText: _emailError,
                            errorStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.red,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) => null,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: pass,
                          onChanged: _updatePasswordStrength,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            errorText: _passwordError,
                            errorStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.red,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () => setState(() => pass = !pass),
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _strengthAnimation,
                          builder: (context, child) {
                            return Column(
                              children: [
                                if (_showIndicator)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          width: 70 * _strengthAnimation.value,
                                          height: 5,
                                          color: _strengthColor,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          _passwordStrength,
                                          style: TextStyle(
                                            color: _strengthColor,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'A strong password must be at least 8 characters long and include uppercase, lowercase, numbers, and special characters.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade600,
                                      fontFamily: 'Poppins',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: pass,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            errorText: _confirmPasswordError,
                            errorStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.red,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () => setState(() => pass = !pass),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        MouseRegion(
                          onEnter: (_) {
                            setState(() => _isSignUpButtonHovered = true);
                            _signUpController.forward();
                          },
                          onExit: (_) {
                            setState(() => _isSignUpButtonHovered = false);
                            _signUpController.reverse();
                          },
                          child: GestureDetector(
                            onTap: () {
                              registerUser();
                            },
                            child: ScaleTransition(
                              scale: _signUpScaleAnimation,
                              child: Container(
                                width: 250,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _signUpColorAnimation.value ??
                                          const Color(0xFF734F7C),
                                      _isSignUpButtonHovered
                                          ? const Color(0xFF9B5BA6)
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
                                    if (_isSignUpButtonHovered)
                                      AnimatedOpacity(
                                        opacity: _isSignUpButtonHovered ? 0.3 : 0.0,
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
                                        "Sign up",
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
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already Registered?",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'Signup');
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: _isSignUpButtonHovered
                                      ? const Color(0xFFA272A9)
                                      : const Color(0xFF734F7C),
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
              ],
            ),
          ),
          if (_errorMessage != null)
            Center(
              child: SlideTransition(
                position: _alertSlideAnimation,
                child: AnimatedOpacity(
                  opacity: _errorMessage != null ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.red.shade200,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.red.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
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
                              setState(() {
                                _errorMessage = null;
                              });
                              _alertController.reverse();
                            },
                            child: ScaleTransition(
                              scale: _backScaleAnimation,
                              child: Container(
                                width: 100,
                                height: 40,
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
                                  borderRadius: BorderRadius.circular(20),
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
                                    "Close",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
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
          if (_successMessage != null)
            Center(
              child: SlideTransition(
                position: _alertSlideAnimation,
                child: AnimatedOpacity(
                  opacity: _successMessage != null ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.green.shade200,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _successMessage!,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        MouseRegion(
                          onEnter: (_) {
                            setState(() => _isContinueButtonHovered = true);
                            _continueController.forward();
                          },
                          onExit: (_) {
                            setState(() => _isContinueButtonHovered = false);
                            _continueController.reverse();
                          },
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _successMessage = null;
                              });
                              _alertController.reverse();
                              Navigator.pushNamed(context, 'CreateAvatarScreen');
                            },
                            child: ScaleTransition(
                              scale: _continueScaleAnimation,
                              child: Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _continueColorAnimation.value ??
                                          const Color(0xFF734F7C),
                                      _isContinueButtonHovered
                                          ? const Color(0xFF9B5BA6)
                                          : const Color(0xFF734F7C),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
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
                                    if (_isContinueButtonHovered)
                                      AnimatedOpacity(
                                        opacity: _isContinueButtonHovered ? 0.3 : 0.0,
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
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    Center(
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
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
              ),
            ),
        ],
      ),
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