import 'package:flutter/material.dart';
import 'package:flutter_app/common_widgets/filter_dropdownwidget.dart';
import 'package:flutter_app/common_widgets/loisir_card_widget.dart';
import 'package:flutter_app/add_loisir_page.dart';
import 'app.API/API_loisirs.dart';
import 'common_widgets/filter_dropdownwidget.dart'; // Importez votre nouveau widget

class AccueilPage extends StatefulWidget {
  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  late Future<Map<String, dynamic>> topLoisirs;
  int _selectedIndex = 0;
  String _selectedType = 'Tous';

  @override
  void initState() {
    super.initState();
    topLoisirs = APILoisirs.getTop5ByType();
  }

  void _refreshList() {
    setState(() {
      topLoisirs = APILoisirs.getTop5ByType();
    });
  }


  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/accueil');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/list_loisir');
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddLoisirPage()),
        ).then((value) {
          _refreshList();
        });
        break;
      default:
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 50, // Adjust the height according to your needs
            ),
            SizedBox(width: 10),
            Text('Le top 5'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: 
          FilterDropdown(
            selectedType: _selectedType,
            onChanged: (String? newValue) {
              setState(() {
                _selectedType = newValue ?? 'Tous'; // Assurez-vous de gérer le cas où newValue est null
              });
            },
          ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: topLoisirs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun loisir disponible.'));
                } else {
                  Map<String, dynamic> topLoisirsByType = snapshot.data!;
                  List<String> typesToShow = _selectedType == 'Tous'
                      ? topLoisirsByType.keys.toList()
                      : [_selectedType];

                  return typesToShow.isEmpty
                      ? Center(child: Text('Aucun loisir disponible pour le type sélectionné.'))
                      : ListView.builder(
                          itemCount: typesToShow.length,
                          itemBuilder: (context, index) {
                            String type = typesToShow[index];
                            List<dynamic>? loisirs = topLoisirsByType[type] as List<dynamic>?;

                            if (loisirs == null || loisirs.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('Aucun loisir disponible pour le type $type.'),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: loisirs.length,
                                  itemBuilder: (context, index) {
                                    var loisir = loisirs[index];
                                    return LoisirCard(
                                      loisir: loisir,
                                      onEditLoisir: _refreshList,
                                    );
                                  },
                                ),
                                SizedBox(height: 16),
                              ],
                            );
                          },
                        );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Liste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Ajouter',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 47, 112, 175),
        onTap: _onItemTapped,
      ),
    );
  }
}
