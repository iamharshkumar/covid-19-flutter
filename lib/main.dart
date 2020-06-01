import 'package:covid19/data.dart';
import 'package:covid19/homepage.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Circular',
          primaryColor: primaryBlack,
        brightness: Brightness.light
      ),
      home: HomePage(),
    ));
  }
}
