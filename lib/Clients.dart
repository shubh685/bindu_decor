import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    NavItem(label: "Clients", route: AppRoutes.clients, icon: CupertinoIcons.person_alt_circle),
    NavItem(label: "Shop", route: AppRoutes.shop, icon: CupertinoIcons.cart),
    NavItem(label: "Reviews", icon: Icons.reviews_outlined, route:"https://www.google.com/maps/place/Bindu+Decorators/@19.2351656,72.8487463,17z/data=!3m1!5s0x3be7b0d85f0d5563:0xbcc67135cad97d47!4m12!1m2!2m1!1sB-2+Mandpeshwar+Ind+premises+Opp+MCF+Gymkhana+Road+Borivali+west+mumbai-400092!3m8!1s0x3be7b11fee8a918b:0xedf1f8374494f993!8m2!3d19.2351656!4d72.8532524!9m1!1b1!15sCk5CLTIgTWFuZHBlc2h3YXIgSW5kIHByZW1pc2VzIE9wcCBNQ0YgR3lta2hhbmEgUm9hZCBCb3JpdmFsaSB3ZXN0IG11bWJhaS00MDAwOTJaUCJOYiAyIG1hbmRwZXNod2FyIGluZCBwcmVtaXNlcyBvcHAgbWNmIGd5bWtoYW5hIHJvYWQgYm9yaXZhbGkgd2VzdCBtdW1iYWkgNDAwMDkykgEPd2FsbHBhcGVyX3N0b3Jl4AEA!16s%2Fg%2F1v_slq8m?entry=ttu&g_ep=EgoyMDI2MDgwNS4xIKXMDSoASAFQAw%3D%3D"),
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

  void _handleNavigation(String route) {
    if (route.startsWith('http')) {
      // Handle external URLs like Google Reviews
      // Example: launchUrl(Uri.parse(route));
      return;
    }

    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: BinduNavigationBar(
          navItems: _navItems,
          shopItems: _shopItems,
          onMenuItemTap: () => _handleNavigation,
        ),
      ),
      drawer: isDesktop
          ? null
          : BinduMobileDrawer(
        navItems: _navItems,
        shopItems: _shopItems,
        onItemTap: () => _handleNavigation,
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
  final String imgUrl;
  const ClientItems({required this.imgUrl});
}

class _ClientLogoList extends StatefulWidget {
  final BuildContext context;
  const _ClientLogoList({required this.context});

  @override
  State<_ClientLogoList> createState() => _ClientLogoListState();
}

class _ClientLogoListState extends State<_ClientLogoList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _topToBottomTextAnim;
  late Animation<Offset> _leftToRightImageAnim;

  @override
  void initState() {
    super.initState();

    // Minimum 80 seconds animation running duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    );

    // First 3 texts slide from Top to Down
    _topToBottomTextAnim = Tween<Offset>(
      begin: const Offset(0.0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Images slide from Left to Right
    _leftToRightImageAnim = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 4;
    } else if (screenWidth >= 768) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    final List<ClientItems> teamMembers = const [
      ClientItems(imgUrl: "assets/client_logos/img1.png"),
      ClientItems(imgUrl: "assets/client_logos/img2.png"),
      ClientItems(imgUrl: "assets/client_logos/img3.png"),
      ClientItems(imgUrl: "assets/client_logos/img4.png"),
      ClientItems(imgUrl: "assets/client_logos/img5.png"),
      ClientItems(imgUrl: "assets/client_logos/img6.png"),
      ClientItems(imgUrl: "assets/client_logos/img7.png"),
      ClientItems(imgUrl: "assets/client_logos/img8.png"),
      ClientItems(imgUrl: "assets/client_logos/img9.png"),
      ClientItems(imgUrl: "assets/client_logos/img10.png"),
      ClientItems(imgUrl: "assets/client_logos/img11.png"),
      ClientItems(imgUrl: "assets/client_logos/img12.png"),
      ClientItems(imgUrl: "assets/client_logos/img13.png"),
      ClientItems(imgUrl: "assets/client_logos/img14.png"),
      ClientItems(imgUrl: "assets/client_logos/img15.png"),
      ClientItems(imgUrl: "assets/client_logos/img16.png"),
      ClientItems(imgUrl: "assets/client_logos/img17.png"),
      ClientItems(imgUrl: "assets/client_logos/img18.png"),
      ClientItems(imgUrl: "assets/client_logos/img19.png"),
      ClientItems(imgUrl: "assets/client_logos/img20.png"),
      ClientItems(imgUrl: "assets/client_logos/img21.png"),
      ClientItems(imgUrl: "assets/client_logos/img22.png"),
      ClientItems(imgUrl: "assets/client_logos/img23.png"),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. First Text (Top to Bottom Slide)
          SlideTransition(
            position: _topToBottomTextAnim,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF276B5A).withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text("TRUSTED BY INDUSTRY LEADER", style: GoogleFonts.cabin(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0, color: const Color(0xFF276B5A))),
            ),
          ),
          const SizedBox(height: 12),

          // 2. Second Text (Top to Bottom Slide)
          SlideTransition(
            position: _topToBottomTextAnim,
            child: Text("Our Esteemed Clients", textAlign: TextAlign.center, style: GoogleFonts.cabin(fontSize: screenWidth >= 900 ? 36 : 28, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A), letterSpacing: 0.5)),
          ),
          const SizedBox(height: 10),

          // Decorative Gold Line
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2,
                width: 24,
                color: const Color(0xFFC89D52).withOpacity(0.4),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFC89D52),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                height: 2,
                width: 24,
                color: const Color(0xFFC89D52).withOpacity(0.4),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3. Third Text (Top to Bottom Slide)
          SlideTransition(
            position: _topToBottomTextAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Proudly serving corporate offices, luxury residences, and commercial venues across India.",
                textAlign: TextAlign.center,
                style: GoogleFonts.cabin(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Client Cards Grid (All images slide from Left side)
          SlideTransition(
            position: _leftToRightImageAnim,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth >= 1200
                    ? 80.0
                    : (screenWidth >= 768 ? 36.0 : 16.0),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: teamMembers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: screenWidth >= 768 ? 24 : 12,
                  mainAxisSpacing: screenWidth >= 768 ? 24 : 12,
                  childAspectRatio: 2.1,
                ),
                itemBuilder: (context, index) {
                  return _AnimatedClientCard(imgUrl: teamMembers[index].imgUrl);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedClientCard extends StatefulWidget {
  final String imgUrl;
  const _AnimatedClientCard({required this.imgUrl});

  @override
  State<_AnimatedClientCard> createState() => _AnimatedClientCardState();
}

class _AnimatedClientCardState extends State<_AnimatedClientCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(seconds: 18),
        curve: Curves.easeOut,
        transform: isHovered
            ? (Matrix4.identity()..translate(0, -6, 0))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF276B5A), width: 2),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? const Color(0xFF276B5A).withOpacity(0.12)
                  : Colors.black.withOpacity(0.04),
              blurRadius: isHovered ? 16 : 8,
              offset: isHovered ? const Offset(0, 8) : const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: _buildDynamicImage(widget.imgUrl),
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
      errorBuilder: (context, error, stackTrace) => _imageFallback(),
    );
  }

  return Image.asset(
    imagePath,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) => _imageFallback(),
  );
}

Widget _imageFallback() {
  return Container(
    color: const Color(0xFFF5F5F5),
    child: const Center(
      child: Icon(Icons.business, size: 36, color: Color(0xFF276B5A)),
    ),
  );
}