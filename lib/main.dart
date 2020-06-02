import 'package:covid19/bloc/theme.dart';
import 'package:covid19/data.dart';
import 'package:covid19/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.light()),
      child: new MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    var mode = Brightness.dark;
    theme.getTheme() == ThemeData.light()
        ? mode = Brightness.light
        : mode = Brightness.dark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Circular', primaryColor: primaryBlack, brightness: mode),
      home: HomePage(),
    );
  }
}
