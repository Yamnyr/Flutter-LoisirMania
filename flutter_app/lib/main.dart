import 'package:flutter/material.dart';
import 'package:flutter_app/accueil_page.dart';
import 'package:flutter_app/list_loisir_page.dart'; // Assurez-vous que ce chemin est correct

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loisir',
      theme: ThemeData(
        primaryColor: Colors.pink,
          scaffoldBackgroundColor: Color.fromARGB(255, 185, 132, 140),
      ),
      home: ListLoisirPage(),
      routes: {
        '/accueil': (context) =>  AccueilPage(),
        '/list_loisir': (context) => ListLoisirPage(),
      },
    );
  }
}
  