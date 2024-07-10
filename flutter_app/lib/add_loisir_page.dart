import 'package:flutter/material.dart';
import 'app.API/API_loisirs.dart';

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
        Navigator.of(context).pop(); // Retourne à la page précédente
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
        title: Text('Ajouter un loisir'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _type,
                      decoration: InputDecoration(labelText: 'Type'),
                      items: _types.map((type) {
                        return DropdownMenuItem<String>(
                          value: type['value'],
                          child: Text(type['label']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _type = value!;
                        });
                      },
                      validator: (value) => value == null ? 'Champ requis' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nom'),
                      validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                      onSaved: (value) => _nom = value!,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Images (URL)'),
                      validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                      onSaved: (value) => _images = value!,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                      onSaved: (value) => _description = value!,
                    ),
                    InputDatePickerFormField(
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      initialDate: _dateSortie,
                      fieldLabelText: 'Date de sortie',
                      onDateSaved: (value) => _dateSortie = value,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Ajouter le loisir'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
