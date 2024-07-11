import 'package:flutter/material.dart';

class SearchBarr extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onChanged;
  final Function() onClear;

  SearchBarr({required this.searchController, required this.onChanged, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher par nom ou type',
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: onClear,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
