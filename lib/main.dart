/*
  @author Orioste, Christian Clapton Edison G.
  BS - IT
  USTP Final Thesis Implementation 2020
 */

import 'package:flutter/material.dart';
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
      theme: ThemeData(
        primaryColor: Colors.white
      ),
      home: MapUI(),
    );
  }
}