
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/homescreen/productscreen.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();

}



class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() => print("Completed"));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: ProductScreenPage(),
    );
  }
}