import 'package:flutter/material.dart';
import 'app.API/API_loisirs.dart';
import 'package:intl/intl.dart';

class EditLoisirPage extends StatefulWidget {
  final Map<String, dynamic> loisir;

  EditLoisirPage({required this.loisir});

  @override
  _EditLoisirPageState createState() => _EditLoisirPageState();
}

class _EditLoisirPageState extends State<EditLoisirPage> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late String _nom;
  late String _images;
  late String _description;
  late DateTime _dateSortie;
  bool _isLoading = false;

  final Map<String, String> _typeOptions = {
    '1': 'Film',
    '2': 'Série',
    '3': 'Livre',
    '4': 'BD',
    '5': 'Comics',
    '6': 'Mangas',
  };

  @override
  void initState() {
    super.initState();
    _type = widget.loisir['type'].toString();
    _nom = widget.loisir['nom'];
    _images = widget.loisir['images'];
    _description = widget.loisir['description'];
    _dateSortie = DateTime.parse(widget.loisir['date_sortie']);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await APILoisirs.updateLoisir(widget.loisir['idloisir'], {
          'type': _type,
          'nom': _nom,
          'images': _images,
          'description': _description,
          'date_sortie': _dateSortie.toIso8601String(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loisir mis à jour avec succès!')),
        );
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour du loisir: $e')),
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
        title: Text('Modifier le loisir'),
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
                          'Modifier le loisir',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _type,
                          decoration: InputDecoration(
                            labelText: 'Type',
                            border: OutlineInputBorder(),
                          ),
                          items: _typeOptions.entries.map((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value),
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
                          initialValue: _nom,
                          decoration: InputDecoration(
                            labelText: 'Nom',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                          onSaved: (value) => _nom = value!,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          initialValue: _images,
                          decoration: InputDecoration(
                            labelText: 'Images (URL)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                          onSaved: (value) => _images = value!,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          initialValue: _description,
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
                          child: Text('Mettre à jour le loisir'),
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