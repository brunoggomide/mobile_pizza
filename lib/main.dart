import 'package:flutter/material.dart';
import 'package:mobile_pizzaria/screens/base_screen.dart';
import 'package:mobile_pizzaria/screens/customer_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const Customer(),
    );
  }
}
