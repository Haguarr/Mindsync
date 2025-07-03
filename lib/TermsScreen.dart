import 'package:flutter/material.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);
  static const id = "TermsScreen";

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
        backgroundColor: const Color(0xFF734F7C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: const Text(
            '''
Welcome to MindSync. By using our application, you agree to the following terms:

1. **Data Storage**: Your data may be stored securely to improve your experience.
2. **Privacy**: We do not share your data with third parties.
3. **Usage**: You must not misuse or abuse the platform.
4. **Updates**: These terms may change. You will be notified of updates.

Please review all terms before proceeding.
            ''',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
