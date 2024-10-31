import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat2/firebase_options.dart';
import 'package:flash_chat2/screen_names.dart';
import 'package:flash_chat2/screens/chat_screen.dart';
import 'package:flash_chat2/screens/login_screen.dart';
import 'package:flash_chat2/screens/registration_screen.dart';
import 'package:flash_chat2/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(FlashChat());
}
// singletickerprovidermixin
// AnimationController
// Animation
// curvedanimation
// addlistner
// ColorTween`
//mixin

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colors.black54),
        ),
      ),
      // home: WelcomeScreen(),
      initialRoute: ScreenNames.welcome_screen,
      routes: {
        // "/": (context) => WelcomeScreen(),
        ScreenNames.welcome_screen: (context) => WelcomeScreen(),
        ScreenNames.login_screen: (context) => LoginScreen(),
        ScreenNames.register_screen: (context) => RegistrationScreen(),
        ScreenNames.chat_screen: (context) => ChatScreen(),
      },
    );
  }
}
