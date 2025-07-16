import 'package:first_app/gradient_container.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter First App',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GradientContainer([Colors.blue.shade300, Colors.purple.shade300]),
      ),
    );
  }
}
