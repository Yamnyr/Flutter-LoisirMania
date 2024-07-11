import 'package:flutter/material.dart';
import 'app.API/API_loisirs.dart';
import 'package:intl/intl.dart';

class AddLoisirPage extends StatefulWidget {
  @override
  _AddLoisirPageState createState() => _AddLoisirPageState();
}

class _AddLoisirPageState extends State<AddLoisirPage> {
  final _formKey = GlobalKey<FormState>();
  String _type = '1';
  String _nom = '';
  String _images = '';
  String _description = '';
  DateTime _dateSortie = DateTime.now();
  final List<Map<String, String>> _types = [
    {'value': '1', 'label': 'Film'},
    {'value': '2', 'label': 'Série'},
    {'value': '3', 'label': 'Livre'},
    {'value': '4', 'label': 'BD'},
    {'value': '5', 'label': 'Comics'},
    {'value': '6', 'label': 'Manags'},
  ];
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await APILoisirs.addLoisir({
          'type': _type,
          'nom': _nom,
          'images': _images,
          'description': _description,
          'date_sortie': _dateSortie.toIso8601String(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loisir ajouté avec succès!')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout du loisir: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
            Text('Ajouter un Loisir',style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 47, 112, 175),
                      fontFamily: 'FiraSans',
                    )),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Nouveau loisir',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 47, 112, 175), fontFamily: 'FiraSans'),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _type,
                          decoration: InputDecoration(
                            labelText: 'Type',
                            border: OutlineInputBorder(),
                          ),
                          items: _types.map((type) {
                            return DropdownMenuItem<String>(
                              value: type['value'],
                              child: Text(type['label']!,style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Numans',
                            )),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _type = value!;
                            });
                          },
                          validator: (value) => value == null ? 'Champ requis' : null,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nom',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                          onSaved: (value) => _nom = value!,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Images (URL)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                          onSaved: (value) => _images = value!,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                          onSaved: (value) => _description = value!,
                        ),
                        SizedBox(height: 16),
                        InputDatePickerFormField(
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          initialDate: _dateSortie,
                          fieldLabelText: 'Date de sortie',
                          errorFormatText: 'Format de date invalide',
                          errorInvalidText: 'Date invalide',
                          fieldHintText: 'JJ/MM/AAAA',
                          onDateSaved: (value) => _dateSortie = value,
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Ajouter le loisir',style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Numans',
                          )),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 128, 100, 145),
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}