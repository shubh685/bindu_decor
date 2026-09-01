import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Pro_Details.dart';

class ApiService {
  static const String baseUrl = "https://yellow-woodpecker-430323.hostingersite.com/bindu_web/";

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

  // Normalize category name to match PHP backend expectations
  static String _normalizeCategory(String category) {
    final String cat = category.trim();

    // Map Flutter display names to exact database category names
    final Map<String, String> categoryMap = {
      // Wallpapers - matches your database "Wallpapers"
      'Wallpapers': 'Wallpapers',
      'WALLPAPERS': 'Wallpapers',
      'Wallpaper': 'Wallpapers',
      'WALLPAPER': 'Wallpapers',
      'Wall': 'Wallpapers',
      'WALL': 'Wallpapers',
      'Wall Decor': 'Wallpapers',
      'WALL DECOR': 'Wallpapers',

      // Cushion Covers - matches your database "Cushion Covers"
      'Cushion Covers': 'Cushion Covers',
      'CUSHION COVERS': 'Cushion Covers',
      'Cushion': 'Cushion Covers',
      'CUSHION': 'Cushion Covers',
      'Cushions': 'Cushion Covers',
      'CUSHIONS': 'Cushion Covers',

      // Floorings
      'Floorings': 'Floorings',
      'FLOORINGS': 'Floorings',
      'Flooring': 'Floorings',
      'FLOORING': 'Floorings',
      'Floor': 'Floorings',
      'FLOOR': 'Floorings',

      // Carpets
      'Carpets': 'Carpets',
      'CARPETS': 'Carpets',
      'Carpet': 'Carpets',
      'CARPET': 'Carpets',

      // Blinds
      'Blinds': 'Blinds',
      'BLINDS': 'Blinds',
      'Blind': 'Blinds',
      'BLIND': 'Blinds',
      'Window': 'Blinds',
      'WINDOW': 'Blinds',
      'Window Decor': 'Blinds',
      'WINDOW DECOR': 'Blinds',

      // Glass Films
      'Glass Films': 'Glass Films',
      'GLASS FILMS': 'Glass Films',
      'Glass Film': 'Glass Films',
      'GLASS FILM': 'Glass Films',
      'Glass': 'Glass Films',
      'GLASS': 'Glass Films',

      // Artificial Turfs
      'Artificial Turfs': 'Artificial Turfs',
      'ARTIFICIAL TURFS': 'Artificial Turfs',
      'Artificial Turf': 'Artificial Turfs',
      'ARTIFICIAL TURF': 'Artificial Turfs',
      'Turf': 'Artificial Turfs',
      'TURF': 'Artificial Turfs',

      // Gym Floorings
      'Gym Floorings': 'Gym Floorings',
      'GYM FLOORINGS': 'Gym Floorings',
      'Gym Flooring': 'Gym Floorings',
      'GYM FLOORING': 'Gym Floorings',
      'Gym': 'Gym Floorings',
      'GYM': 'Gym Floorings',

      // Awnings
      'Awnings': 'Awnings',
      'AWNINGS': 'Awnings',
      'Awning': 'Awnings',
      'AWNING': 'Awnings',

      // Mosquito Nets
      'Mosquito Nets': 'Mosquito Nets',
      'MOSQUITO NETS': 'Mosquito Nets',
      'Mosquito Net': 'Mosquito Nets',
      'MOSQUITO NET': 'Mosquito Nets',
      'Mosquito': 'Mosquito Nets',
      'MOSQUITO': 'Mosquito Nets',

      // Upholstery
      'Upholstery': 'Upholstery',
      'UPHOLSTERY': 'Upholstery',

      // Curtains
      'Curtains': 'Curtains',
      'CURTAINS': 'Curtains',
      'Curtain': 'Curtains',
      'CURTAIN': 'Curtains',

      // Stretch Ceiling
      'Stretch Ceiling': 'Stretch Ceiling',
      'STRETCH CEILING': 'Stretch Ceiling',
      'Ceiling': 'Stretch Ceiling',
      'CEILING': 'Stretch Ceiling',

      // Home Decor (fallback)
      'Home Decor': 'Home Decor',
      'HOME DECOR': 'Home Decor',
      'Home': 'Home Decor',
      'HOME': 'Home Decor',
      'Decor': 'Home Decor',
      'DECOR': 'Home Decor',
      'Decorative': 'Home Decor',
      'DECORATIVE': 'Home Decor',
    };

    // Try exact match first
    if (categoryMap.containsKey(cat)) {
      return categoryMap[cat]!;
    }

    // Try case-insensitive match
    final String lowerCat = cat.toLowerCase();
    for (final key in categoryMap.keys) {
      if (key.toLowerCase() == lowerCat) {
        return categoryMap[key]!;
      }
    }

    // Return original if not found
    print('⚠️ No mapping found for category: "$category", using as-is');
    return category;
  }

  // Fetch products by category
  static Future<List<DecorProductItem>> fetchProductsByCategory(String category) async {
    try {
      final String normalizedCategory = _normalizeCategory(category);
      print('🔍 Fetching products for category: "$category" (normalized: "$normalizedCategory")');

      final response = await http.get(
        Uri.parse("${baseUrl}products.php?category=${Uri.encodeComponent(normalizedCategory)}"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        print('📊 API Response status: ${jsonResponse['status']}');
        print('📊 API Response data count: ${jsonResponse['data']?.length ?? 0}');

        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          final List<DecorProductItem> items = data.map((item) => DecorProductItem.fromJson(item)).toList();
          print('✅ Successfully parsed ${items.length} items for category: "$category"');
          return items;
        }
        print('⚠️ No data found for category: "$category"');
        return [];
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching products for category "$category": $e');
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

  // Fetch categories list
  static Future<List<String>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}products.php?action=categories"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['categories'] != null) {
          final List<dynamic> categories = jsonResponse['categories'];
          return categories.map((item) => item['category'] as String).toList();
        }
        return [];
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}