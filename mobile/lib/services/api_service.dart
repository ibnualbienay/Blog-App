import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:3000/api';

  Future<List<dynamic>> getPosts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Gagal mengambil artikel');
    }
  }

  Future<Map<String, dynamic>> getPostById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/$id'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Gagal mengambil detail artikel');
    }
  }

  Future<List<dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Gagal mengambil kategori');
    }
  }

  Future<void> createPost({
    required String title,
    required String content,
    required int categoryId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'category_id': categoryId,
      }),
    );

    if (response.statusCode != 201) {
      final data = jsonDecode(response.body);

      throw Exception(
        data['message'] ?? 'Gagal membuat artikel',
      );
    }
  }

  Future<void> updatePost({
    required int id,
    required String title,
    required String content,
    required int categoryId,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'category_id': categoryId,
      }),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);

      throw Exception(
        data['message'] ?? 'Gagal mengubah artikel',
      );
    }
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);

      throw Exception(
        data['message'] ?? 'Gagal menghapus artikel',
      );
    }
  }
}