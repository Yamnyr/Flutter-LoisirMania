import 'package:flutter/material.dart';
import 'package:flutter_app/show_loisir_page.dart';
import 'edit_loisir_page.dart';
import 'add_loisir_page.dart';
import 'app.API/API_loisirs.dart';

class ListLoisirPage extends StatefulWidget {
  @override
  _ListLoisirPageState createState() => _ListLoisirPageState();
}

class _ListLoisirPageState extends State<ListLoisirPage> {
  late Future<List> loisirs;

  @override
  void initState() {
    super.initState();
    loisirs = APILoisirs.getAllLoisirs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Loisirs'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddLoisirPage()),
              ).then((value) {
                setState(() {
                  loisirs = APILoisirs.getAllLoisirs();
                });
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List>(
        future: loisirs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun loisir disponible.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length + 1,
              itemBuilder: (context, index) {
                if (index == snapshot.data!.length) {
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
                          setState(() {
                            loisirs = APILoisirs.getAllLoisirs();
                          });
                        });
                      },
                    ),
                  );
                } else {
                  var loisir = snapshot.data![index];
                  return Card(
                    elevation: 3.0,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ListTile(
                      title: Text(
                        loisir['nom'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(loisir['description']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility),
                            color: Color.fromARGB(255, 8, 163, 111),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowLoisirPage(loisir: loisir),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Color.fromARGB(255, 8, 163, 111),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditLoisirPage(loisir: loisir),
                                ),
                              ).then((value) {
                                setState(() {
                                  loisirs = APILoisirs.getAllLoisirs();
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}