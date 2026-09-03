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
  ];

  final List<NestedMenuItem> _shopItems = const [
    NestedMenuItem(
      title: 'Products & Services',
      subItems: [
        NavItem(label: 'Wallpapers', route: AppRoutes.wallpapers, icon: CupertinoIcons.photo),
        NavItem(label: 'Floorings', route: AppRoutes.floorings, icon: CupertinoIcons.square_grid_2x2),
        NavItem(label: 'Carpets', route: AppRoutes.carpets, icon: CupertinoIcons.layers),
        NavItem(label: 'Blinds', route: AppRoutes.blinds, icon: CupertinoIcons.bars),
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
        child: BinduNavigationBar(
          navItems: _navItems,
          shopItems: _shopItems,
          onMenuItemTap: () => context.navigateTo,
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
              child: _ClientLogoList(context: context),
            ),
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BinduFooter(),
                ],
              ),
            )
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

  Future<List<ClientItems>> fetchClients() async {
    final url = Uri.parse('${kBaseServerUrl}clients.php');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? [];

        if (data.isEmpty) return [];

        return data.map((item) {
          return ClientItems(
            id: int.tryParse(item['id']?.toString() ?? '0') ?? 0,
            name: item['name'] ?? '',
            imgUrl: item['img_url'] ?? item['image_url'] ?? '',
          );
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
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
        final clients = snapshot.data ?? [];
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: clients.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(clients[index].name),
          ),
        );
      },
    );
  }
}