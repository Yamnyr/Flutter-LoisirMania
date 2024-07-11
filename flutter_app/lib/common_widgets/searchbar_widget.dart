import 'package:flutter/material.dart';

class SearchBarr extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onChanged;
  final Function() onClear;

  SearchBarr({
    required this.searchController,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Rechercher par nom ou type',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey[400]),
              onPressed: onClear,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          onChanged: onChanged,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}