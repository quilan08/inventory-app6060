import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/auth.dart';
import 'package:shimmer/shimmer.dart';
 
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    if (mounted) {
      authService.auth.authStateChanges().listen((user) {
        
        if (user != null) {
          if (user.emailVerified) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            user.reload().then((_) async {
              if (authService.auth.currentUser != null) {
                User? currentUser =
                    authService.auth.currentUser; // Access currentUser directly
                if (currentUser!.emailVerified) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  Navigator.pushReplacementNamed(context, '/verify');
                }
              }
            });
          }
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SizedBox(
            width: 200.0,
            height: 100.0,
            child: Shimmer.fromColors(
              baseColor: Colors.red,
              highlightColor: Colors.yellow,
              child: const Text(
                'INVENTORY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}