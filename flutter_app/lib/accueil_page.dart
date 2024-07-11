import 'package:flutter/material.dart';
import 'package:flutter_app/common_widgets/addloisir_card_widget.dart';
import 'package:flutter_app/show_loisir_page.dart';
import 'edit_loisir_page.dart';
import 'add_loisir_page.dart';
import 'app.API/API_loisirs.dart';
import 'common_widgets/searchbar_widget.dart';
import 'common_widgets/sort_dropdownwidget.dart';
import 'common_widgets/loisir_card_widget.dart';

class AccueilPage extends StatefulWidget {
  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  late Future<Map<String, dynamic>> topLoisirs;
  String sortOption = 'Alphabetique';
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0; // Index for bottom navigation bar

  @override
  void initState() {
    super.initState();
    topLoisirs = APILoisirs.getTop5ByType(); // Use getTop5ByType instead of getAllLoisirs
  }

  void _sortLoisirs(List loisirsList) {
    if (sortOption == 'Alphabetique') {
      loisirsList.sort((a, b) => a['nom'].compareTo(b['nom']));
    } else if (sortOption == 'Date') {
      loisirsList.sort((a, b) => a['date_sortie'].compareTo(b['date_sortie']));
    }
  }

  void _refreshList() {
    setState(() {
      topLoisirs = APILoisirs.getTop5ByType(); // Refresh the top loisirs list
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        // Accueil (current page)
        break;
      case 1:
        // Liste des loisirs
        Navigator.pushReplacementNamed(context, '/list_loisir');
        break;
      case 2:
        // Ajout de loisir
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
        title: Text('Accueil'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddLoisirPage()),
              ).then((value) {
                _refreshList();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Sort widgets can be added if necessary
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
                  List<dynamic> sortedLoisirs = snapshot.data!.values.toList();
                  _sortLoisirs(sortedLoisirs);

                  return ListView.builder(
                    itemCount: sortedLoisirs.length,
                    itemBuilder: (context, index) {
                      var loisir = sortedLoisirs[index];
                      return LoisirCard(
                        loisir: loisir,
                        onEditLoisir: _refreshList,
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
