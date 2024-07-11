import 'package:flutter/material.dart';
import 'package:flutter_app/add_loisir_page.dart';
import 'package:flutter_app/app.API/API_loisirs.dart';


class AddLoisirCard extends StatelessWidget {
  final Function() onAddLoisir;

  AddLoisirCard({required this.onAddLoisir});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 8, 163, 111),
      elevation: 3.0,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        title: Text(
          'Ajouter un nouveau loisir',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        trailing: Icon(Icons.add, color: Colors.white),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLoisirPage()),
          ).then((value) {
            // Call the callback function provided by the parent widget
            onAddLoisir();
          });
        },
      ),
    );
  }
}

