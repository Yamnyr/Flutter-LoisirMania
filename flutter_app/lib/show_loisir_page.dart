import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
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
            // Formattez la date ici
            var dateFormatter = DateFormat('dd MMMM yyyy');
            var formattedDate = dateFormatter.format(DateTime.parse(loisir['date_sortie']));
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      child: loisir['images'] != null && loisir['images'].isNotEmpty
                          ? Image.network(
                              loisir['images'],
                              height: 600,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 300,
                              color: Colors.grey[300],
                              child: Icon(Icons.image_not_supported, size: 100),
                            ),
                    ),
                    // Informations
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                loisir['nom'],
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: loisir['moyenne_notes'] != null 
                                        ? double.parse(loisir['moyenne_notes'].toString()) 
                                        : 0.0,
                                    itemBuilder: (context, index) => Icon(Icons.star, color: Color.fromARGB(255, 47, 112, 175)),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Type: ${loisir['type']}'),
                              Text('$formattedDate'),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(loisir['description']),
                          SizedBox(height: 24),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ajouter une note:',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Color.fromARGB(255, 47, 112, 175),
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      _selectedNote = rating.toInt();
                                    });
                                  },
                                ),
                                SizedBox(height: 8),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _submitNote,
                                  child: Text('Ajouter la note'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 128, 100, 145),
                                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
