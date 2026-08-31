import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../Pro_Details.dart';
import '../Proj_Page.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.48/bindu_decor";

  // Fetch projects from projects.php
  // Fetch projects from projects.php
  static Future<List<ProjectItem>> fetchProjects() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/projects.php'));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        List<dynamic> data = [];

        if (decodedData is List) {
          // If the PHP script returns a raw array: [...]
          data = decodedData;
        } else if (decodedData is Map<String, dynamic>) {
          // If the PHP script returns an object wrapper: {"status": true, "data": [...]}
          // Adjust 'data' or 'projects' according to your PHP array key.
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
}