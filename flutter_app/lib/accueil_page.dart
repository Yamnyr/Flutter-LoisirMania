import 'package:flutter/material.dart';
import 'package:flutter_app/show_loisir_page.dart';
import 'edit_loisir_page.dart';
import 'add_loisir_page.dart';
import 'app.API/API_loisirs.dart';

class AccueilPage extends StatefulWidget {
  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  late Future<Map<String, dynamic>> topLoisirs;

  @override
  void initState() {
    super.initState();
    topLoisirs = APILoisirs.getTop5ByType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top 5 des Loisirs'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddLoisirPage()),
              ).then((value) {
                setState(() {
                  topLoisirs = APILoisirs.getTop5ByType();
                });
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: topLoisirs,
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
                            topLoisirs = APILoisirs.getTop5ByType();
                          });
                        });
                      },
                    ),
                  );
                } else {
                  String type = snapshot.data!.keys.elementAt(index);
                  List loisirs = snapshot.data![type];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Top 5 $type',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...loisirs.map((loisir) => Card(
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
                                      topLoisirs = APILoisirs.getTop5ByType();
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      )).toList(),
                    ],
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