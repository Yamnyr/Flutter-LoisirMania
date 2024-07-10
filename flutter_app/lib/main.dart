import 'package:flutter/material.dart';
import 'package:flutter_app/app.pages/flutter_app_page.dart';

void main() => runApp(MyApp());

// Raccourci : Saisisser 'stless' puis appuyer sur Enter
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO',
      theme: ThemeData(
        primaryColor: Colors.pink,
      ),
      // TODO : Changer le nom de la page d'accueil
      home:  const FlutterAppPage(),
    );
  }
}
