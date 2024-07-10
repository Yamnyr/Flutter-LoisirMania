import 'package:flutter/material.dart';
import 'app.API/API_loisirs.dart';

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
        Navigator.of(context).pop(true); // Retourne true pour indiquer une mise à jour réussie
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
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _type,
                      decoration: InputDecoration(labelText: 'Type'),
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
                    TextFormField(
                      initialValue: _nom,
                      decoration: InputDecoration(labelText: 'Nom'),
                      validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                      onSaved: (value) => _nom = value!,
                    ),
                    TextFormField(
                      initialValue: _images,
                      decoration: InputDecoration(labelText: 'Images (URL)'),
                      validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                      onSaved: (value) => _images = value!,
                    ),
                    TextFormField(
                      initialValue: _description,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                      onSaved: (value) => _description = value!,
                    ),
                    InputDatePickerFormField(
                      firstDate: DateTime(1900),
                      lastDate: DateTime(9999),
                      initialDate: _dateSortie,
                      fieldLabelText: 'Date de sortie',
                      onDateSaved: (value) => _dateSortie = value,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Mettre à jour le loisir'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}