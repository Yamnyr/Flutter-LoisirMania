import 'dart:convert';
import 'package:http/http.dart' as http;

class APILoisirs {
  static const String baseUrl = 'http://localhost:8000/api'; // Ajustez l'URL selon votre configuration

  // Récupérer le top 5 par loisir
  static Future<Map<String, dynamic>> getTop5ByType() async {
    final response = await http.get(Uri.parse('$baseUrl/index'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération du top 5 par loisir');
    }
  }

  // Récupérer tous les loisirs avec leurs moyennes
  static Future<List<dynamic>> getAllLoisirs() async {
    final response = await http.get(Uri.parse('$baseUrl/loisirs'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération des loisirs');
    }
  }

  // Récupérer un loisir par son id
  static Future<Map<String, dynamic>> getLoisirById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/loisir/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body)[0];
    } else {
      throw Exception('Erreur lors de la récupération du loisir');
    }
  }

  // Ajouter un loisir
  static Future<void> addLoisir(Map<String, dynamic> loisir) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loisir'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(loisir),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de l\'ajout du loisir');
    }
  }

  // Ajouter une note à un loisir
  static Future<void> addNote(int loisirId, double note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loisir/$loisirId/note'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'note': note}),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de l\'ajout de la note');
    }
  }

  // Récupérer tous les types
  static Future<List<dynamic>> getAllTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/types'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération des types');
    }
  }

  // Récupérer les notes d'un loisir par son id
  static Future<List<dynamic>> getNotesByLoisirId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/loisir/$id/notes'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération des notes du loisir');
    }
  }
  // Mettre à jour un loisir par son id
  static Future<void> updateLoisir(int id, Map<String, dynamic> loisir) async {
    final response = await http.put(
      Uri.parse('$baseUrl/loisir/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(loisir),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour du loisir');
    }
  }
}