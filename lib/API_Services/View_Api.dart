import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Pro_Details.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.48/bindu_decor/";

  // Fetch products by category
  static Future<List<DecorProductItem>> fetchProductsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}products.php?category=${Uri.encodeComponent(category)}"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) => DecorProductItem.fromJson(item)).toList();
        }
        return [];
      }
      return [];
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Fetch all products
  static Future<List<DecorProductItem>> fetchAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}products.php"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) => DecorProductItem.fromJson(item)).toList();
        }
        return [];
      }
      return [];
    } catch (e) {
      print('Error fetching all products: $e');
      return [];
    }
  }

  // Fetch projects
  static Future<List<dynamic>> fetchProjects() async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}projects.php"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          return jsonResponse['data'];
        }
        return [];
      }
      return [];
    } catch (e) {
      print('Error fetching projects: $e');
      return [];
    }
  }
}