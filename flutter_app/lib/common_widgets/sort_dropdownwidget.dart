import 'package:flutter/material.dart';

class SortDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  SortDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      icon: Icon(Icons.sort),
      items: <String>['Alphabetique', 'Date']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
