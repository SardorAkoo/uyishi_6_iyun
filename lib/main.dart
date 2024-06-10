import 'package:flutter/material.dart';
import 'package:uyishi_6_iyun/views/Contatacs_screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactListScreen(),
    );
  }
}
