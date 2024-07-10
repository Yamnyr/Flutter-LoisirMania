import 'package:flutter/material.dart';
import 'app.API/API_loisirs.dart';

class ShowLoisirPage extends StatefulWidget {
  final Map<String, dynamic> loisir;

  ShowLoisirPage({required this.loisir});

  @override
  _ShowLoisirPageState createState() => _ShowLoisirPageState();
}

class _ShowLoisirPageState extends State<ShowLoisirPage> {
  late Future<Map<String, dynamic>> loisirDetails;
  final _formKey = GlobalKey<FormState>();
  int? _selectedNote;

  @override
  void initState() {
    super.initState();
    loisirDetails = APILoisirs.getLoisirById(widget.loisir['idloisir']);
  }

Future<void> _submitNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await APILoisirs.addNote(
          widget.loisir['idloisir'],
          _selectedNote!.toDouble(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note ajoutée avec succès!')),
        );
        setState(() {
          loisirDetails = APILoisirs.getLoisirById(widget.loisir['idloisir']);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout de la note: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du loisir'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: loisirDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Aucune donnée disponible.'));
          } else {
            var loisir = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loisir['nom'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text('Type: ${loisir['type']}'),
                  SizedBox(height: 8),
                  Text('Date de sortie: ${loisir['date_sortie']}'),
                  SizedBox(height: 16),
                  Text(
                    'Description:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(loisir['description']),
                  SizedBox(height: 16),
                  if (loisir['images'] != null && loisir['images'].isNotEmpty)
                    Image.network(
                      loisir['images'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Note moyenne: ${loisir['moyenne_notes'] ?? 'Pas encore noté'}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<int>(
                          decoration: InputDecoration(labelText: 'Votre note'),
                          items: List.generate(5, (index) => index + 1).map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedNote = value;
                            });
                          },
                          validator: (value) => value == null ? 'Champ requis' : null,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitNote,
                          child: Text('Ajouter la note'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
