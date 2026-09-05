import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:visibility_detector/visibility_detector.dart';

import 'Home_Page.dart';
import 'Nav_Widgets/Navigation.dart';

const String kBaseServerUrl = "https://yellow-woodpecker-430323.hostingersite.com/bindu_web/";

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final List<NavItem> _navItems = const [
    NavItem(label: "Home", route: AppRoutes.home, icon: Icons.home),
    NavItem(label: "About", route: AppRoutes.about, icon: CupertinoIcons.info_circle),
    NavItem(label: "Projects", route: AppRoutes.projects, icon: CupertinoIcons.building_2_fill),
    NavItem(label: "Clients", route: AppRoutes.clients, icon: CupertinoIcons.group_solid),
    NavItem(label: "Shop", route: AppRoutes.shop, icon: CupertinoIcons.cart),
    NavItem(label: "Blogs", route: AppRoutes.blogs, icon: Icons.library_add_check_sharp),
    NavItem(
      label: "Reviews",
      icon: Icons.reviews_outlined,
      route: "https://www.google.com/maps/place/Bindu+Decorators/@19.2351656,72.8487463,17z/data=!3m1!5s0x3be7b0d85f0d5563:0xbcc67135cad97d47!4m12!1m2!2m1!1sB-2+Mandpeshwar+Ind+premises+Opp+MCF+Gymkhana+Road+Borivali+west+mumbai-400092!3m8!1s0x3be7b11fee8a918b:0xedf1f8374494f993!8m2!3d19.2351656!4d72.8532524!9m1!1b1!15sCk5CLTIgTWFuZHBlc2h3YXIgSW5kIHByZW1pc2VzIE9wcCBNQ0YgR3lta2hhbmEgUm9hZCBCb3JpdmFsaSB3ZXN0IG11bWJhaS00MDAwOTJaUCJOYiAyIG1hbmRwZXNod2FyIGluZCBwcmVtaXNlcyBvcHAgbWNmIGd5bWtoYW5hIHJvYWQgYm9yaXZhbGkgd2VzdCBtdW1iYWkgNDAwMDkykgEPd2FsbHBhcGVyX3N0b3Jl4AEA!16s%2Fg%2F1v_slq8m?entry=ttu&g_ep=EgoyMDI2MDgwNS4xIKXMDSoASAFQAw%3D%3D",
    ),
  ];

  final List<NestedMenuItem> _shopItems = const [
    NestedMenuItem(
      title: 'Products & Services',
      subItems: [
        NavItem(label: 'Wallpapers', route: AppRoutes.wallpapers, icon: CupertinoIcons.photo),
        NavItem(label: 'Floorings', route: AppRoutes.floorings, icon: CupertinoIcons.square_grid_2x2),
        NavItem(label: 'Carpets', route: AppRoutes.carpets, icon: CupertinoIcons.layers),
        NavItem(label: 'Blinds', route: AppRoutes.blinds, icon: CupertinoIcons.bars),
        NavItem(label: 'Glass Films', route: AppRoutes.glassfilms, icon: CupertinoIcons.film),
        NavItem(label: 'Artificial Turfs', route: AppRoutes.artificialturfs, icon: CupertinoIcons.tree),
        NavItem(label: 'Gym Floorings', route: AppRoutes.gymfloorings, icon: CupertinoIcons.sportscourt),
        NavItem(label: 'Awnings', route: AppRoutes.awnings, icon: CupertinoIcons.house),
        NavItem(label: 'Mosquito Nets', route: AppRoutes.mosquitoNets, icon: CupertinoIcons.shield),
        NavItem(label: 'Upholstery', route: AppRoutes.upholstery, icon: CupertinoIcons.bed_double),
        NavItem(label: 'Curtains', route: AppRoutes.curtains, icon: CupertinoIcons.rectangle_grid_1x2),
        NavItem(label: 'Stretch Ceiling', route: AppRoutes.stretchCeiling, icon: CupertinoIcons.arrow_up_square),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F382C).withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: BinduNavigationBar(
            navItems: _navItems,
            shopItems: _shopItems,
            onMenuItemTap: () => context.navigateTo,
          ),
        ),
      ),
      drawer: isDesktop
          ? null
          : BinduMobileDrawer(
        navItems: _navItems,
        shopItems: _shopItems,
        onItemTap: () => context.navigateTo,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: _ClientLogoList(context: context),
              ),
            ),
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BinduFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClientItems {
  final int id;
  final String name;
  final String imgUrl;
  const ClientItems({required this.id, required this.name, required this.imgUrl});
}

class _ClientLogoList extends StatefulWidget {
  final BuildContext context;
  const _ClientLogoList({required this.context});

  @override
  State<_ClientLogoList> createState() => _ClientLogoListState();
}

class _ClientLogoListState extends State<_ClientLogoList> {
  late Future<List<ClientItems>> _clientsFuture;

  @override
  void initState() {
    super.initState();
    _clientsFuture = fetchClients();
  }

  // Helper function to resolve image URL using image.php
  String resolveImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';

    // If it's already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Clean the path
    String cleanPath = imagePath;

    // Remove leading slashes
    while (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }

    // Remove bindu_decor/ prefix if present
    if (cleanPath.toLowerCase().startsWith('bindu_decor/')) {
      cleanPath = cleanPath.substring('bindu_decor/'.length);
    }

    // Remove duplicate uploads
    if (cleanPath.toLowerCase().startsWith('uploads/uploads/')) {
      cleanPath = cleanPath.substring('uploads/'.length);
    }

    // Remove uploads/ prefix if present (we'll add it back)
    if (cleanPath.toLowerCase().startsWith('uploads/')) {
      cleanPath = cleanPath.substring('uploads/'.length);
    }

    // If empty after cleaning, return empty
    if (cleanPath.isEmpty) return '';

    // Build URL using image.php
    String baseUrl = kBaseServerUrl.endsWith('/')
        ? kBaseServerUrl.substring(0, kBaseServerUrl.length - 1)
        : kBaseServerUrl;

    return '$baseUrl/image.php?path=${Uri.encodeComponent(cleanPath)}';
  }

  Future<List<ClientItems>> fetchClients() async {
    final url = Uri.parse('${kBaseServerUrl}clients.php');

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Connection timeout - Please check your internet connection');
        },
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📡 Response Body Preview: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');

      // Check if response is valid JSON
      if (response.body.isEmpty) {
        print('❌ Empty response from server');
        return [];
      }

      // Try to parse JSON
      dynamic jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body);
      } catch (e) {
        print('❌ Invalid JSON response: $e');
        print('📄 Raw response: ${response.body}');
        return [];
      }

      if (jsonResponse is! Map<String, dynamic>) {
        print('❌ Response is not a Map: ${jsonResponse.runtimeType}');
        return [];
      }

      print('📦 Parsed Response: $jsonResponse');

      // Check if status is success
      String status = jsonResponse['status']?.toString() ?? '';
      print('📊 Status: $status');

      if (status != 'success') {
        print('❌ Status is not success: $status');
        print('📄 Message: ${jsonResponse['message'] ?? 'No message'}');
        return [];
      }

      // Get data from response
      dynamic data = jsonResponse['data'];

      if (data == null) {
        print('❌ No data in response');
        return [];
      }

      if (data is! List) {
        print('❌ Data is not a List: ${data.runtimeType}');
        return [];
      }

      print('✅ Found ${data.length} clients');

      if (data.isEmpty) {
        print('ℹ️ No clients available');
        return [];
      }

      // Map data to ClientItems
      List<ClientItems> clients = [];

      for (var item in data) {
        if (item is! Map<String, dynamic>) {
          print('⚠️ Skipping non-map item: ${item.runtimeType}');
          continue;
        }

        // Extract image URL - try all possible keys
        String rawImgUrl = '';

        // Check img_path first (stored path)
        if (item['img_path'] != null && item['img_path'].toString().isNotEmpty) {
          rawImgUrl = item['img_path'].toString().trim();
        }
        // Then check img_url
        else if (item['img_url'] != null && item['img_url'].toString().isNotEmpty) {
          rawImgUrl = item['img_url'].toString().trim();
        }
        // Finally check image_url
        else if (item['image_url'] != null && item['image_url'].toString().isNotEmpty) {
          rawImgUrl = item['image_url'].toString().trim();
        }

        print('🖼️ Raw Image URL for client ${item['id']}: $rawImgUrl');

        // If we have a valid image URL, resolve it
        String resolvedUrl = '';
        if (rawImgUrl.isNotEmpty) {
          resolvedUrl = resolveImageUrl(rawImgUrl);
          print('✅ Resolved URL: $resolvedUrl');
        } else {
          print('⚠️ No image URL found for client ${item['id']}');
        }

        // Get client name (if exists)
        String name = item['name']?.toString() ?? 'Client ${item['id'] ?? ''}';

        clients.add(ClientItems(
          id: int.tryParse(item['id']?.toString() ?? '0') ?? 0,
          name: name,
          imgUrl: resolvedUrl,
        ));
      }

      print('✅ Successfully parsed ${clients.length} clients');
      return clients;

    } catch (e) {
      print('❌ Error fetching clients: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;
    final double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<ClientItems>>(
      future: _clientsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F382C)),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load clients',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error?.toString() ?? 'Please check your connection',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _clientsFuture = fetchClients();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F382C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Retry',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final clients = snapshot.data ?? [];

        if (clients.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 60,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No clients available',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for updates',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Display clients in a responsive grid - FIXED: Proper scrolling
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Our Valued Clients',
                  style: GoogleFonts.cinzel(
                    fontSize: isDesktop ? 32 : 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F382C),
                  ),
                ),
              ),
              // Use Wrap for automatic flow without height constraints
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.start,
                children: clients.map((client) {
                  // Calculate card width based on screen size
                  double cardWidth;
                  if (isDesktop) {
                    cardWidth = (screenWidth - 24 * 2 - 16 * 5) / 6; // 6 columns
                  } else if (screenWidth > 600) {
                    cardWidth = (screenWidth - 24 * 2 - 16 * 3) / 4; // 4 columns
                  } else {
                    cardWidth = (screenWidth - 24 * 2 - 16 * 1) / 2; // 2 columns
                  }

                  // Ensure minimum width
                  if (cardWidth < 100) cardWidth = 100;

                  return SizedBox(
                    width: cardWidth,
                    child: _buildClientCard(client),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClientCard(ClientItems client) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Client Logo Image
          SizedBox(
            height: 70,
            child: _buildClientImage(client.imgUrl),
          ),
          const SizedBox(height: 8),
          // Client Name
          if (client.name.isNotEmpty && client.name != 'Client 0')
            Text(
              client.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Widget _buildClientImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F382C)),
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print('❌ Image load error: $error');
        print('❌ Failed URL: $imageUrl');
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business,
              size: 32,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 4),
            Text(
              'Logo',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}