import 'package:flutter/material.dart';
import 'package:flutter_application_1/Forgot.dart';
import 'package:flutter_application_1/WelcomeScreen.dart';
import 'SplashScreen.dart';
import 'LoginScreen.dart';
import 'Signup.dart';
import 'CreateAvatarScreen.dart';
import 'AvatarSelection.dart';
import 'EchoMind.dart';
import 'ProfileScreen.dart';
import 'ChatScreen.dart';
import 'VoiceAssistantScreen.dart';
import 'TasksScreen.dart';
import 'SessionScreen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id :(context) => SplashScreen(),
          WelcomeScreen.id : (context) => WelcomeScreen(),
          LoginScreen.id : (context) => LoginScreen(),
          Signup.id :(context) => Signup(),
          Forgot.id :(context) => Forgot(),
          AvatarSelection.id :(context) => AvatarSelection(),
          EchoMind.id :(context) => EchoMind(),
          CreateAvatarScreen.id : (context) => CreateAvatarScreen(),
          ProfileScreen.id: (context) => ProfileScreen(),
          ChatScreen.id: (context) => const ChatScreen(),
          VoiceAssistantScreen.id: (context) => const VoiceAssistantScreen(),
          TasksScreen.id: (context) => const TasksScreen(),
          SessionScreen.id: (context) => const SessionScreen(),
        }
    );
  }
}