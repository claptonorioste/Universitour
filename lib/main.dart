/*
  @author Orioste, Christian Clapton Edison G.
  BS - IT
  USTP Final Thesis Implementation 2020
 */

import 'package:flutter/material.dart';
import 'package:universitour/loginPage/login.dart';
import 'outdoor/map.dart';



void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
        primaryColor: Colors.white
      ),
      home: Login(),
    );
  }
}