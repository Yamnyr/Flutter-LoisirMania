import 'package:flutter/material.dart';
import 'package:flutter_app/show_loisir_page.dart';
import '../edit_loisir_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class LoisirCard extends StatelessWidget {
  final Map<String, dynamic> loisir;
  final Function() onEditLoisir;

  LoisirCard({required this.loisir, required this.onEditLoisir});

  @override
  Widget build(BuildContext context) {
    double rating = loisir['moyenne_notes'] != null 
        ? double.parse(loisir['moyenne_notes'].toString()) 
        : 0.0;

    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: loisir['images'] != null
                ? Image.network(
                    loisir['images'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),
          ),
          // Content section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loisir['nom'],
                            style: TextStyle(color: Color.fromARGB(255, 47, 112, 175), fontSize: 20, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Type: ${loisir['nom_type']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    RatingBarIndicator(
                      rating: rating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Color.fromARGB(255, 47, 112, 175),
                        
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  loisir['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.visibility),
                      label: Text('Voir'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowLoisirPage(loisir: loisir),
                          ),
                        ).then((value) => onEditLoisir());
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 128, 100, 145),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: Icon(Icons.edit),
                      label: Text('Modifier'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditLoisirPage(loisir: loisir),
                          ),
                        ).then((value) => onEditLoisir());
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 128, 100, 145),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}