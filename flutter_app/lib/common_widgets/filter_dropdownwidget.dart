import 'package:flutter/material.dart';
class FilterDropdown extends StatelessWidget {
  final String selectedType;
  final void Function(String?)? onChanged; // Adapter la signature de la fonction onChanged

  const FilterDropdown({
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedType,
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
            onChanged: onChanged, // Utilisation directe de la fonction onChanged fournie
            items: <String>[
              'Tous',
              'Film',
              'Serie',
              'Livre',
              'BD',
              'Comics',
              'Mangas'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
