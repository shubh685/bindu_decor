import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Pro_Details.dart';
import '../Proj_Page.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.48/bindu_decor/";

  // Fetch projects from projects.php (tags field removed)
  static Future<List<ProjectItem>> fetchProjects() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/projects.php'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? responseData['projects'] ?? [];

        return data.map((json) {
          return ProjectItem(
            title: json['title'] ?? '',
            subTitle: json['sub_title'] ?? json['subTitle'] ?? '',
            location: json['location'] ?? '',
            pricing: json['pricing'] ?? '',
            bhk: json['bhk'] ?? '',
            scope: json['scope'] ?? '',
            propertyType: json['property_type'] ?? json['propertyType'] ?? '',
            size: json['size'] ?? '',
            description: json['description'] ?? '',
            imageUrls: List<String>.from(json['image_urls'] ?? json['imageUrls'] ?? []),
          );
        }).toList();
      } else {
        throw Exception('Failed to load projects (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching projects: $e');
    }
  }

  // Fetch product items by category from products.php
  static Future<List<DecorProductItem>> fetchProductsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products.php?category=${Uri.encodeComponent(category)}'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) {
          List<ImageDetail>? parsedDetails;
          if (json['imageDetails'] != null) {
            parsedDetails = (json['imageDetails'] as List<dynamic>).map((img) {
              return ImageDetail(
                imageUrl: img['imageUrl'] ?? img['image_url'] ?? '',
                title: img['title'],
                description: img['description'],
              );
            }).toList();
          }

          return DecorProductItem(
            title: json['title'] ?? '',
            category: json['category'] ?? category,
            imageDetails: parsedDetails,
            imageUrls: List<String>.from(json['imageUrls'] ?? json['image_urls'] ?? []),
            description: json['description'] ?? '',
            material: json['material'] ?? "Premium Grade Material",
            printType: json['printType'] ?? json['print_type'] ?? "High Definition Digital Print / Finish",
          );
        }).toList();
      } else {
        throw Exception('Failed to load $category products');
      }
    } catch (e) {
      throw Exception('Error fetching products for $category: $e');
    }
  }
}