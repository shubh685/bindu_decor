import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:visibility_detector/visibility_detector.dart';

import 'Home_Page.dart';
import 'Nav_Widgets/Navigation.dart';

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
      route: "https://www.google.com/maps/place/Bindu+Decorators/@19.2351656,72.8487463,17z/data=!3m1!5s0x3be7b0d85f0d5563:0xbcc67135cad97d47!4m12!1m2!2m1!1sB-2+Mandpeshwar+Ind+premises+Opp+MCF+Gymkhana+Road+Borivali+west+mumbai-400092!3m8!1s0x3be7b11fee8a918b:0xedf1f8374494f993!8m2!3d19.2351656!4d72.8532524!9m1!1b1!15sCk5CLTIgTWFuZHBlc2h3YXIgSW5kIHByZW1pc2VzIE9wcCBNQ0YgR3lta2hhbmEgUm9hZCBCb3JpdmFsaSB3ZXN0IG11bWJhaS00MDAwOTJaUCJOYiAyIG1hbmRwZXNod2FyIGluZCBwcmVtaXNlcyBvcHAgbWNmIGd5bWtoYW5hIHJvYWQgYm9yaXZhbGkgd2VzdCBtdW1iYWkgNDAwMDkykgEPd2FsbHBhcGVyX3N0b3Store4AEA!16s%2Fg%2F1v_slq8m?entry=ttu&g_ep=EgoyMDI2MDgwNS4xIKXMDSoASAFQAw%3D%3D",
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

class _ClientLogoListState extends State<_ClientLogoList>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<Offset> _topToBottomTextAnim;
  bool _headerAnimated = false;
  late Future<List<ClientItems>> _clientsFuture;

  // Ordered fallback list matching the exact layout of your photo
  final List<ClientItems> _defaultOrderedClients = const [
    ClientItems(id: 1, name: "ACME", imgUrl: "assets/images/clients/acme.png"),
    ClientItems(id: 2, name: "Sai Lee", imgUrl: "assets/images/clients/sailee.png"),
    ClientItems(id: 3, name: "Kala Niketan", imgUrl: "assets/images/clients/kala_niketan.png"),
    ClientItems(id: 4, name: "GeeCee Ventures", imgUrl: "assets/images/clients/geecee.png"),
    ClientItems(id: 5, name: "RITC Developers", imgUrl: "assets/images/clients/ritc.png"),
    ClientItems(id: 6, name: "Chheda Group", imgUrl: "assets/images/clients/chheda.png"),
    ClientItems(id: 7, name: "Larsen & Toubro", imgUrl: "assets/images/clients/lt.png"),
    ClientItems(id: 8, name: "Indian Navy INS Hamla", imgUrl: "assets/images/clients/indian_navy.png"),
  ];

  @override
  void initState() {
    super.initState();
    _clientsFuture = fetchClients();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _topToBottomTextAnim = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    ));
  }

  Future<List<ClientItems>> fetchClients() async {
    final url = Uri.parse('https://yellow-woodpecker-430323.hostingersite.com/bindu_web/clients.php');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? [];

        if (data.isEmpty) return _defaultOrderedClients;

        List<ClientItems> fetched = data.map((item) {
          return ClientItems(
            id: int.tryParse(item['id']?.toString() ?? '0') ?? 0,
            name: item['name'] ?? '',
            imgUrl: item['img_url'] ?? item['image_url'] ?? '',
          );
        }).toList();

        // Sort by DB ID ascending to guarantee the correct display sequence
        fetched.sort((a, b) => a.id.compareTo(b.id));
        return fetched;
      } else {
        return _defaultOrderedClients;
      }
    } catch (e) {
      debugPrint('Error fetching clients: $e');
      return _defaultOrderedClients;
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth >= 1100) {
      crossAxisCount = 4;
      childAspectRatio = 2.6;
    } else if (screenWidth >= 768) {
      crossAxisCount = 3;
      childAspectRatio = 2.3;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 2.0;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VisibilityDetector(
            key: const Key('header_visibility_key'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.1 && !_headerAnimated) {
                _headerAnimated = true;
                _headerController.forward();
              }
            },
            child: Column(
              children: [
                SlideTransition(
                  position: _topToBottomTextAnim,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F382C).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFF0F382C).withOpacity(0.15)),
                    ),
                    child: Text(
                      "TRUSTED BY INDUSTRY LEADERS",
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
                        color: const Color(0xFF0F382C),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SlideTransition(
                  position: _topToBottomTextAnim,
                  child: Text(
                    "Our Esteemed Clients",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: screenWidth >= 900 ? 42 : 30,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F382C),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 2, width: 24, color: const Color(0xFFD4AF37).withOpacity(0.4)),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 4,
                      width: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFF8C6D23)]),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Container(height: 2, width: 24, color: const Color(0xFFD4AF37).withOpacity(0.4)),
                  ],
                ),
                const SizedBox(height: 16),
                SlideTransition(
                  position: _topToBottomTextAnim,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "Proudly serving corporate offices, luxury residences, and commercial venues across India.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 16,
                        color: const Color(0xFF4A5568),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 44),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth >= 1200
                  ? 80.0
                  : (screenWidth >= 768 ? 36.0 : 16.0),
            ),
            child: FutureBuilder<List<ClientItems>>(
              future: _clientsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F382C)),
                    ),
                  );
                }

                final clientList = (snapshot.hasData && snapshot.data!.isNotEmpty)
                    ? snapshot.data!
                    : _defaultOrderedClients;

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: screenWidth >= 768 ? 24 : 14,
                  mainAxisSpacing: screenWidth >= 768 ? 24 : 14,
                  childAspectRatio: childAspectRatio,
                  children: List.generate(clientList.length, (index) {
                    return _AnimatedClientCard(
                      key: ValueKey("client_card_${clientList[index].id}_$index"),
                      imgUrl: clientList[index].imgUrl,
                      index: index,
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedClientCard extends StatefulWidget {
  final String imgUrl;
  final int index;
  const _AnimatedClientCard({super.key, required this.imgUrl, required this.index});

  @override
  State<_AnimatedClientCard> createState() => _AnimatedClientCardState();
}

class _AnimatedClientCardState extends State<_AnimatedClientCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _cardController;
  late Animation<Offset> _leftToRightImageAnim;
  bool isHovered = false;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _leftToRightImageAnim = Tween<Offset>(
      begin: const Offset(-0.8, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('client_card_visibility_${widget.index}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_hasAnimated) {
          _hasAnimated = true;
          // Stagger card entrance animation based on index
          Future.delayed(Duration(milliseconds: widget.index * 80), () {
            if (mounted) _cardController.forward();
          });
        }
      },
      child: SlideTransition(
        position: _leftToRightImageAnim,
        child: MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            transform: isHovered
                ? (Matrix4.identity()..translate(0, -6, 0))
                : Matrix4.identity(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isHovered ? const Color(0xFFD4AF37) : Colors.grey.shade300,
                width: isHovered ? 1.8 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: isHovered
                      ? const Color(0xFF0F382C).withOpacity(0.12)
                      : Colors.black.withOpacity(0.02),
                  blurRadius: isHovered ? 16 : 6,
                  offset: isHovered ? const Offset(0, 8) : const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 70,
                    maxWidth: 200,
                  ),
                  child: _buildDynamicImage(widget.imgUrl),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildDynamicImage(String imagePath) {
  if (imagePath.isEmpty) {
    return _imageFallback();
  }

  final bool isNetwork =
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  if (isNetwork) {
    return Image.network(
      imagePath,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      errorBuilder: (context, error, stackTrace) => _imageFallback(),
    );
  }

  return Image.asset(
    imagePath,
    fit: BoxFit.contain,
    alignment: Alignment.center,
    errorBuilder: (context, error, stackTrace) => _imageFallback(),
  );
}

Widget _imageFallback() {
  return Container(
    padding: const EdgeInsets.all(12),
    color: const Color(0xFFFAFAF8),
    child: const Center(
      child: Icon(Icons.business_rounded, size: 36, color: Color(0xFF0F382C)),
    ),
  );
}