import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/phone_auth_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'هپی چت',
      theme: ThemeData(
        fontFamily: 'Vazir',
        primarySwatch: Colors.blue,
      ),
      home: const PhoneAuthPage(),
    );
  }
}
