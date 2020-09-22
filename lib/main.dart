import 'package:flutter/material.dart';
import 'file:///D:/New%20folder%20(2)/flutter%20apps/shop_app/lib/pages/home.dart';
import 'package:shop_app/pages/Login_Page_EID.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop app',
      theme: ThemeData(
          primaryColor: Colors.orange.shade900
      ),
      home: LoginPage(),
    );
  }
}

