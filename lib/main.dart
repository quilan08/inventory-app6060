import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/LoginPage/loginwidget.dart';
import 'package:flutter_application_1/providers/auth.dart';
import 'package:flutter_application_1/providers/database.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Arturos barkery'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

   @override
  void initState() {
   connectionStatusSingleton.connectionChange.listen((event) {print(event);});
   //Firebase.initializeApp().whenComplete(() => print("Completed"));
    super.initState();
  }
  @override
  void dispose() {
    dbService.dispose();
    connectionStatusSingleton.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.transparent,
      theme: ThemeData(
       
      ),
      routes: {
        
      },
      home: const LoginScreen()
    );
  }
  }

