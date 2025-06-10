import 'package:flutter/material.dart';
import 'SplashScreen.dart';
import 'LoginScreen.dart';
import 'Signup.dart';

class Forgot extends StatefulWidget {
  const Forgot({Key? key}) : super(key: key);
  static const id = "Forgot";

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isBackButtonHovered = false; // Track hover state for Back button

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 242, 240, 245), // Dark purple background
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                color: const Color(0xFF734F7C), // Solid purple
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          size: 20,
                          color: Color(0xFFA272A9), // Accent purple
                        ),
                        SizedBox(width: 8),
                        Text(
                          "By MindSync",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 169, 139, 173), // Accent purple
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Please enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Signup.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF734F7C), // Main purple
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            "Reset Password",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: 250,
                        child: MouseRegion(
                          onEnter: (_) => setState(() => _isBackButtonHovered = true),
                          onExit: (_) => setState(() => _isBackButtonHovered = false),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFA272A9), // Accent purple
                              foregroundColor: _isBackButtonHovered
                                  ? Colors.white
                                  : Color(0xFF734F7C), // White on hover, main purple otherwise
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              "Back",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}