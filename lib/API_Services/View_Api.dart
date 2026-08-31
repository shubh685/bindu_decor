// Api_Service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../Pro_Details.dart';
import '../Proj_Page.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.48/bindu_decor";

  static Future<List<ProjectItem>> fetchProjects() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/projects.php'));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        List<dynamic> data = [];

        if (decodedData is List) {
          data = decodedData;
        } else if (decodedData is Map<String, dynamic>) {
          data = decodedData['data'] ?? decodedData['projects'] ?? [];
        }

        return data.map((json) {
          return ProjectItem(
            title: json['title'] ?? '',
            subTitle: json['subTitle'] ?? json['subtitle'] ?? '',
            location: json['location'] ?? '',
            pricing: json['pricing'] ?? '',
            bhk: json['bhk'] ?? '',
            scope: json['scope'] ?? '',
            propertyType: json['propertyType'] ?? json['property_type'] ?? '',
            size: json['size'] ?? '',
            description: json['description'] ?? '',
            imageUrls: List<String>.from(json['imageUrls'] ?? json['image_urls'] ?? []),
          );
        }).toList();
      } else {
        throw Exception('Failed to load projects (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Error fetching projects: $e');
      return [];
    }
  }

  static Future<List<DecorProductItem>> fetchProductsByCategory(String category) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/products.php?action=fetch&category=${Uri.encodeComponent(category)}');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        List<dynamic> data = [];

        if (decodedData is List) {
          data = decodedData;
        } else if (decodedData is Map<String, dynamic>) {
          data = decodedData['data'] ?? decodedData['products'] ?? [];
        }

        return data.map((json) => DecorProductItem.fromJson(json)).toList();
      } else {
        debugPrint('Failed to load products for category $category: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching products by category ($category): $e');
      return [];
    }
  }

  static Future<List<String>> fetchDynamicCategories() async {
    try {
      final Uri uri = Uri.parse('$baseUrl/products.php?action=categories');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (decodedData is Map<String, dynamic> && decodedData['categories'] != null) {
          return List<String>.from(decodedData['categories']);
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching dynamic categories: $e');
      return [];
    }
  }
}