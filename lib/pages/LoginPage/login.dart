import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/LoginPage/Loginform.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
         decoration: const BoxDecoration(
         gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1,0.5,0.7,0.9],
          colors: [
            Color.fromARGB(255, 214, 217, 235),
            Color.fromARGB(255, 81, 96, 193),
            Color.fromARGB(255, 128, 142, 223),
            Color.fromARGB(255, 81, 96, 193),
          ]
         )
         ),
         child: const LoginForm(),
      ),
     
    );
  }
}