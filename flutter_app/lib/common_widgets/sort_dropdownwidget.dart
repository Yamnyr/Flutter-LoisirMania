import 'package:flutter/material.dart';

class SortButton extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  SortButton({required this.value, required this.onChanged});

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
      child: PopupMenuButton<String>(
        icon: Icon(Icons.sort, color: Colors.grey[600]),
        onSelected: onChanged,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'Alphabetique',
            child: Text('Alphabétique', style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Numans',
                    )),
          ),
          PopupMenuItem<String>(
            value: 'Date',
            child: Text('Date', style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Numans',
                    )),
          ),
        ],
      ),
    );
  }
}