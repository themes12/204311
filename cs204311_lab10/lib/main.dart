import 'package:cs204311_lab10/my_custom_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child:  MaterialApp(
        home: Scaffold(
          body: Center(
            child: MyCustomForm(),
          ),
        ),
      ),
    );
  }
}
