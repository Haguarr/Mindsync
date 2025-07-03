// Ensure you add the Poppins font to your pubspec.yaml:
// flutter:
//   fonts:
//     - family: Poppins
//       fonts:
//         - asset: fonts/Poppins-Bold.ttf
//           weight: 800

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Signup.dart';
import 'package:flutter_application_1/LoginScreen.dart';
import 'package:flutter_application_1/WelcomeScreen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        Signup.id: (context) => const Signup(),
        LoginScreen.id: (context) => const LoginScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  static const id = 'SplashScreen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _robotFadeAnimation;
  late Animation<double> _robotScaleAnimation;
  late Animation<Offset> _robotSlideAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with 3 seconds for sequence
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    // Logo animations (0–0.33, first 1 second)
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.33, curve: Curves.easeInOut),
      ),
    );
    _logoScaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.33, curve: Curves.easeOutBack),
      ),
    );
    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.33, curve: Curves.easeOutCubic),
      ),
    );

    // Text animations (0.33–0.66, next 1 second)
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.33, 0.66, curve: Curves.easeInOut),
      ),
    );
    _textScaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.33, 0.66, curve: Curves.easeOutBack),
      ),
    );
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.33, 0.66, curve: Curves.easeOutCubic),
      ),
    );

    // Robot animations (0.66–0.83, next 0.5 seconds)
    _robotFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 0.83, curve: Curves.easeInOut),
      ),
    );
    _robotScaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 0.83, curve: Curves.easeOutBack),
      ),
    );
    _robotSlideAnimation = Tween<Offset>(
      begin: const Offset(1.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 0.83, curve: Curves.easeOutCubic),
      ),
    );

    // Shimmer animation for background and text (0.66–1.0, last 1 second)
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 1.0, curve: Curves.linear),
      ),
    );

    // Navigate to WelcomeScreen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        WelcomeScreen.id,
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _shimmerAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF5C3D6D).withOpacity(0.8),
                  Color(0xFF9B5BA6).withOpacity(0.8),
                  Color(0xFF5C3D6D).withOpacity(0.8),
                ],
                stops: [
                  _shimmerAnimation.value < 0 ? 0.0 : _shimmerAnimation.value,
                  (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                  (_shimmerAnimation.value + 0.6).clamp(0.0, 1.0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _logoSlideAnimation,
                    child: FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: ScaleTransition(
                        scale: _logoScaleAnimation,
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SlideTransition(
                        position: _textSlideAnimation,
                        child: FadeTransition(
                          opacity: _textFadeAnimation,
                          child: ScaleTransition(
                            scale: _textScaleAnimation,
                            child: ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.7),
                                    Colors.white,
                                  ],
                                  stops: [
                                    _shimmerAnimation.value < 0 ? 0.0 : _shimmerAnimation.value,
                                    (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                                    (_shimmerAnimation.value + 0.6).clamp(0.0, 1.0),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.srcIn,
                              child: Text(
                                'Mindsync',
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.5,
                                      fontFamily: 'Poppins',
                                      fontSize: 48, // Bigger text
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SlideTransition(
                        position: _robotSlideAnimation,
                        child: FadeTransition(
                          opacity: _robotFadeAnimation,
                          child: ScaleTransition(
                            scale: _robotScaleAnimation,
                            child: Image.asset(
                              'assets/images/robot.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}