import 'package:flutter/material.dart';
import 'package:flutter_app/common_widgets/addloisir_card_widget.dart';
import 'package:flutter_app/show_loisir_page.dart';
import 'edit_loisir_page.dart';
import 'add_loisir_page.dart';
import 'app.API/API_loisirs.dart';
import 'common_widgets/searchbar_widget.dart';
import 'common_widgets/sort_dropdownwidget.dart';
import 'common_widgets/loisir_card_widget.dart';

class ListLoisirPage extends StatefulWidget {
  @override
  _ListLoisirPageState createState() => _ListLoisirPageState();
}

class _ListLoisirPageState extends State<ListLoisirPage> {
  late Future<List> loisirs;
  String sortOption = 'Alphabetique';
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0; // Index for bottom navigation bar

  @override
  void initState() {
    super.initState();
    loisirs = APILoisirs.getAllLoisirs();
  }

  void _sortLoisirs(List loisirsList) {
    if (sortOption == 'Alphabetique') {
      loisirsList.sort((a, b) => a['nom'].compareTo(b['nom']));
    } else if (sortOption == 'Date') {
      loisirsList.sort((a, b) => DateTime.parse(b['date_sortie']).compareTo(DateTime.parse(a['date_sortie'])));
    }
  }

  void _searchLoisirs(String query) {
    if (query.isEmpty) {
      setState(() {
        loisirs = APILoisirs.getAllLoisirs();
      });
    } else {
      setState(() {
        loisirs = APILoisirs.getAllLoisirs().then((list) {
          return list.where((loisir) =>
              (loisir['nom_type'] != null &&
                      loisir['nom_type']
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase())) ||
                  (loisir['nom'] != null &&
                      loisir['nom']
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase() )
                  )
            ).toList();
        });
      });
    }
  }

  void _refreshList() {
    setState(() {
      loisirs = APILoisirs.getAllLoisirs();
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
    _selectedIndex = index; // Mettez à jour l'index sélectionné
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Loisirs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SearchBarr(
                  searchController: searchController,
                  onChanged: (value) {
                    _searchLoisirs(value);
                  },
                  onClear: () {
                    searchController.clear();
                    _searchLoisirs('');
                  },
                ),
                SortButton(
                  value: sortOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      sortOption = newValue!;
                      loisirs = APILoisirs.getAllLoisirs().then((list) {
                        _sortLoisirs(list);
                        return list;
                      });
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List>(
              future: loisirs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun loisir disponible.'));
                } else {
                  List sortedLoisirs = snapshot.data!;
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
        selectedItemColor: Color.fromARGB(255, 47, 112, 175),
        onTap: _onItemTapped,
      ),
    );
  }
}
