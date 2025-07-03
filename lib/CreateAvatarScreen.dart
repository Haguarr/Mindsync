import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'EchoMind.dart';

class CreateAvatarScreen extends StatefulWidget {
  const CreateAvatarScreen({Key? key}) : super(key: key);
  static const id = "CreateAvatarScreen";

  @override
 State<CreateAvatarScreen> createState() => _CreateAvatarScreenState();
}

class _CreateAvatarScreenState extends State<CreateAvatarScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;
  String? _nameError;
  String? _dateError;
  String? _genderError;
  String? _errorMessage;
  String? _successMessage;
  bool _isNextButtonHovered = false;
  bool _isContinueButtonHovered = false;

  late AnimationController _nextController;
  late AnimationController _continueController;
  late AnimationController _alertController;
  late AnimationController _iconController;
  late Animation<double> _nextScaleAnimation;
  late Animation<Color?> _nextColorAnimation;
  late Animation<double> _continueScaleAnimation;
  late Animation<Color?> _continueColorAnimation;
  late Animation<Offset> _alertSlideAnimation;
  late Animation<double> _iconFloatAnimation;
  late Animation<double> _iconShimmerAnimation; // Added for shimmer effect

  @override
  void initState() {
    super.initState();
    _nextController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _continueController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _alertController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _nextScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _nextController, curve: Curves.easeOutBack),
    );
    _nextColorAnimation = ColorTween(
      begin: const Color(0xFF734F7C),
      end: const Color(0xFF9B5BA6),
    ).animate(
      CurvedAnimation(parent: _nextController, curve: Curves.easeInOut),
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
    _iconFloatAnimation = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );
    _iconShimmerAnimation = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    _nameController.addListener(() {
      if (_nameError != null && _nameController.text.isNotEmpty) {
        setState(() {
          _nameError = null;
        });
      }
    });
    _dateController.addListener(() {
      if (_dateError != null && _dateController.text.isNotEmpty) {
        setState(() {
          _dateError = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _hobbiesController.dispose();
    _nextController.dispose();
    _continueController.dispose();
    _alertController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  Future<void> _saveAvatarData() async {
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'Please fill out Name' : null;
      _dateError = _selectedDate == null ? 'Please select Date of Birth' : null;
      _genderError = _selectedGender == null ? 'Please select Gender' : null;
    });

    if (_nameError != null || _dateError != null || _genderError != null) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
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
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text.trim(),
          'dateOfBirth': _selectedDate!.toIso8601String(),
          'gender': _selectedGender,
          'hobbies': _hobbiesController.text.trim(),
          'createdAt': Timestamp.now(),
        });
        setState(() {
          _successMessage = 'Profile created successfully!';
        });
        _alertController.forward();
        await Future.delayed(const Duration(seconds: 3));
        setState(() {
          _successMessage = null;
        });
        _alertController.reverse();
        Navigator.pushNamed(context, EchoMind.id);
      } else {
        setState(() {
          _errorMessage = 'User not logged in';
        });
        _alertController.forward();
        await Future.delayed(const Duration(seconds: 3));
        setState(() {
          _errorMessage = null;
        });
        _alertController.reverse();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save profile: $e';
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Top Blob with Title
                  ClipPath(
                    clipper: BlobClipper(),
                    child: Container(
                      height: 220,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF734F7C), Color(0xFF5B3A64)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Create your Profile",
                          style: TextStyle(
                            fontSize: 32,
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your name',
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Color(0xFFA272A9),
                            width: 2,
                          ),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Poppins'),
                      validator: (value) => null,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Date of Birth TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: 'Select your date of birth',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        errorText: _dateError,
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Color(0xFFA272A9),
                            width: 2,
                          ),
                        ),
                        suffixIcon: const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF734F7C),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Poppins'),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 20)),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null && picked != _selectedDate) {
                          setState(() {
                            _selectedDate = picked;
                            _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                            _dateError = null;
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Gender Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio<String>(
                              value: 'Female',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                  _genderError = null;
                                });
                              },
                              activeColor: const Color(0xFFA272A9),
                            ),
                            const Text(
                              'Female',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            const SizedBox(width: 8),
                            AnimatedBuilder(
                              animation: _iconShimmerAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _iconFloatAnimation.value),
                                  child: Icon(
                                    Icons.female,
                                    color: Color(0xFF734F7C),
                                    shadows: [
                                      Shadow(
                                        color: Colors.white.withOpacity(_iconShimmerAnimation.value),
                                        blurRadius: 8,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 24),
                            Radio<String>(
                              value: 'Male',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                  _genderError = null;
                                });
                              },
                              activeColor: const Color(0xFFA272A9),
                            ),
                            const Text(
                              'Male',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            const SizedBox(width: 8),
                            AnimatedBuilder(
                              animation: _iconShimmerAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _iconFloatAnimation.value),
                                  child: Icon(
                                    Icons.male,
                                    color: Color(0xFF734F7C),
                                    shadows: [
                                      Shadow(
                                        color: Colors.white.withOpacity(_iconShimmerAnimation.value),
                                        blurRadius: 8,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        if (_genderError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _genderError!,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Hobbies TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: _hobbiesController,
                      decoration: InputDecoration(
                        labelText: 'Hobbies',
                        hintText: 'Enter your hobbies',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Color(0xFFA272A9),
                            width: 2,
                          ),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Poppins'),
                      validator: (value) => null,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Next Button
                  MouseRegion(
                    onEnter: (_) {
                      setState(() => _isNextButtonHovered = true);
                      _nextController.forward();
                    },
                    onExit: (_) {
                      setState(() => _isNextButtonHovered = false);
                      _nextController.reverse();
                    },
                    child: GestureDetector(
                      onTap: _saveAvatarData,
                      child: ScaleTransition(
                        scale: _nextScaleAnimation,
                        child: Container(
                          width: 250,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _nextColorAnimation.value ?? const Color(0xFF734F7C),
                                _isNextButtonHovered
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
                              if (_isNextButtonHovered)
                                AnimatedOpacity(
                                  opacity: _isNextButtonHovered ? 0.3 : 0.0,
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
                                  "Next",
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

                  const SizedBox(height: 20),

                  // Bottom Blob
                  ClipPath(
                    clipper: BottomBlobClipper(),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF734F7C), Color(0xFF5B3A64)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                                _errorMessage = null;
                              });
                              _alertController.reverse();
                            },
                            child: ScaleTransition(
                              scale: _continueScaleAnimation,
                              child: Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _continueColorAnimation.value ?? const Color(0xFF734F7C),
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
                              Navigator.pushNamed(context, EchoMind.id);
                            },
                            child: ScaleTransition(
                              scale: _continueScaleAnimation,
                              child: Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _continueColorAnimation.value ?? const Color(0xFF734F7C),
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
                                child: Center(
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

class BottomBlobClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.15);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * -0.1, size.width * 0.5, size.height * 0.05);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.3, size.width, size.height * 0.05);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}