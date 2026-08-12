import 'package:bindu_decor/Nav_Widgets/Navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Home_Page.dart';

// =============================================================================
// 1. GYM FLOORING SECTION
// =============================================================================

class GymFloorings extends StatefulWidget {
  const GymFloorings({super.key});

  @override
  State<GymFloorings> createState() => _GymFlooringsState();
}

class _GymFlooringsState extends State<GymFloorings> {
  // Navigation Configuration
  final List<NavItem> _navItems = const [
    NavItem(label: "Home", route: AppRoutes.home, icon: Icons.home),
    NavItem(label: "About", route: AppRoutes.about, icon: CupertinoIcons.info_circle),
    NavItem(label: "Clients", route: AppRoutes.clients, icon: CupertinoIcons.person_alt_circle),
    NavItem(label: "Shop", route: AppRoutes.shop, icon: CupertinoIcons.cart),
    NavItem(
      label: "Reviews",
      icon: Icons.reviews_outlined,
      route:
      "https://www.google.com/maps/place/Bindu+Decorators/@19.2351656,72.8487463,17z/data=!3m1!5s0x3be7b0d85f0d5563:0xbcc67135cad97d47!4m12!1m2!2m1!1sB-2+Mandpeshwar+Ind+premises+Opp+MCF+Gymkhana+Road+Borivali+west+mumbai-400092!3m8!1s0x3be7b11fee8a918b:0xedf1f8374494f993!8m2!3d19.2351656!4d72.8532524!9m1!1b1!15sCk5CLTIgTWFuZHBlc2h3YXIgSW5kIHByZW1pc2VzIE9wcCBNQ0YgR3lta2hhbmEgUm9hZCBCb3JpdmFsaSB3ZXN0IG11bWJhaS00MDAwOTJaUCJOYiAyIG1hbmRwZXNod2FyIGluZCBwcmVtaXNlcyBvcHAgbWNmIGd5bWtoYW5hIHJvYWQgYm9yaXZhbGkgd2VzdCBtdW1iYWkgNDAwMDkykgEPd2FsbHBhcGVyX3N0b3Jl4AEA!16s%2Fg%2F1v_slq8m?entry=ttu&g_ep=EgoyMDI2MDgwNS4xIKXMDSoASAFQAw%3D%3D",
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

  void _handleNavigation(String route) {
    if (route.startsWith('http')) {
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
      backgroundColor: const Color(0xFFF9FBFB),
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
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: GymFlooringAnimatedSection(),
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

class GymFlooringItem {
  final String title;
  final String desc;
  final String imgurl;

  const GymFlooringItem({
    required this.title,
    required this.desc,
    required this.imgurl,
  });
}

class GymFlooringAnimatedSection extends StatefulWidget {
  const GymFlooringAnimatedSection({super.key});

  @override
  State<GymFlooringAnimatedSection> createState() => _GymFlooringAnimatedSectionState();
}

class _GymFlooringAnimatedSectionState extends State<GymFlooringAnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;

  final List<GymFlooringItem> _gymItems = const [
    GymFlooringItem(
      title: "Rubberized Dumbbell Mat",
      imgurl: "assets/gy_aw_mo/gym1.png",
      desc:
      "Shock-absorbing rubberized floor section designed for heavy weight training and equipment protection.",
    ),
    GymFlooringItem(
      title: "Commercial Athletic Flooring",
      imgurl: "assets/gy_aw_mo/gym2.png",
      desc:
      "High-end seamless rubber flooring with custom floor markings for cardio and functional fitness zones.",
    ),
    GymFlooringItem(
      title: "Interlocking Rubber Tiles",
      imgurl: "assets/gy_aw_mo/gym3.png",
      desc:
      "Durable puzzle-edge rubber tiles providing superior grip, impact absorption, and noise reduction.",
    ),
    GymFlooringItem(
      title: "Seamless Speckled Rubber Roll",
      imgurl: "assets/gy_aw_mo/gym4.png",
      desc:
      "Premium heavy-duty rubber roll flooring offering a modern aesthetic and long-lasting durability.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _leftSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.8, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _rightSlideAnimation = Tween<Offset>(
      begin: const Offset(0.8, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

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

    int crossAxisCount = 4;
    if (screenWidth < 600) {
      crossAxisCount = 1;
    } else if (screenWidth < 900) {
      crossAxisCount = 2;
    } else if (screenWidth < 1200) {
      crossAxisCount = 3;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 900 ? 32.0 : 16.0,
        vertical: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "High-Performance Gym Flooring",
            textAlign: TextAlign.center,
            style: GoogleFonts.cabin(
              fontSize: screenWidth > 600 ? 28 : 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF276B5A),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFC89D52),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Protect your surfaces and reduce impact with heavy-duty, noise-reducing sports rubber floorings.",
            textAlign: TextAlign.center,
            style: GoogleFonts.cabin(
              fontSize: 13.5,
              color: const Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _gymItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 380,
            ),
            itemBuilder: (context, index) {
              final item = _gymItems[index];
              final bool slideFromLeft = index % 2 == 0;

              return SlideTransition(
                position:
                slideFromLeft ? _leftSlideAnimation : _rightSlideAnimation,
                child: _GymFlooringCard(item: item),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GymFlooringCard extends StatefulWidget {
  final GymFlooringItem item;

  const _GymFlooringCard({required this.item});

  @override
  State<_GymFlooringCard> createState() => _GymFlooringCardState();
}

class _GymFlooringCardState extends State<_GymFlooringCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: _isHovered
            ? (Matrix4.identity()..translate(0, -4, 0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF276B5A)
                : const Color(0xFF276B5A).withOpacity(0.2),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFF276B5A).withOpacity(0.15)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _isHovered ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  widget.item.imgurl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFEBF5F2),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.sportscourt,
                              size: 36, color: Color(0xFF276B5A)),
                          SizedBox(height: 6),
                          Text("Image Not Found",
                              style: TextStyle(
                                  color: Color(0xFF276B5A), fontSize: 11)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.cabin(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
                    const SizedBox(height: 4),
                    Text(widget.item.desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.cabin(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xFF555555), height: 1.3)),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showContactFormDialog(context);
                        },
                        icon: const Icon(Icons.touch_app_outlined, size: 16, color: Colors.white),
                        label: Text("Get in Touch", style: GoogleFonts.cabin(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF276B5A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 2. AWNINGS SECTION
// =============================================================================

class Awnings extends StatefulWidget {
  const Awnings({super.key});

  @override
  State<Awnings> createState() => _AwningsState();
}

class _AwningsState extends State<Awnings> {
  final List<NavItem> _navItems = const [
    NavItem(label: "Home", route: AppRoutes.home, icon: Icons.home),
    NavItem(label: "About", route: AppRoutes.about, icon: CupertinoIcons.info_circle),
    NavItem(label: "Clients", route: AppRoutes.clients, icon: CupertinoIcons.person_alt_circle),
    NavItem(label: "Shop", route: AppRoutes.shop, icon: CupertinoIcons.cart),
    NavItem(
      label: "Reviews",
      icon: Icons.reviews_outlined,
      route:
      "https://www.google.com/maps/place/Bindu+Decorators/@19.2351656,72.8487463,17z/data=!3m1!5s0x3be7b0d85f0d5563:0xbcc67135cad97d47!4m12!1m2!2m1!1sB-2+Mandpeshwar+Ind+premises+Opp+MCF+Gymkhana+Road+Borivali+west+mumbai-400092!3m8!1s0x3be7b11fee8a918b:0xedf1f8374494f993!8m2!3d19.2351656!4d72.8532524!9m1!1b1!15sCk5CLTIgTWFuZHBlc2h3YXIgSW5kIHByZW1pc2VzIE9wcCBNQ0YgR3lta2hhbmEgUm9hZCBCb3JpdmFsaSB3ZXN0IG11bWJhaS00MDAwOTJaUCJOYiAyIG1hbmRwZXNod2FyIGluZCBwcmVtaXNlcyBvcHAgbWNmIGd5bWtoYW5hIHJvYWQgYm9yaXZhbGkgd2VzdCBtdW1iYWkgNDAwMDkykgEPd2FsbHBhcGVyX3N0b3Jl4AEA!16s%2Fg%2F1v_slq8m?entry=ttu&g_ep=EgoyMDI2MDgwNS4xIKXMDSoASAFQAw%3D%3D",
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

  void _handleNavigation(String route) {
    if (route.startsWith('http')) {
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
      backgroundColor: const Color(0xFFF9FBFB),
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
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: AwningsAnimatedSection(),
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

class AwningItem {
  final String title;
  final String desc;
  final String imgurl;

  const AwningItem({
    required this.title,
    required this.desc,
    required this.imgurl,
  });
}

class AwningsAnimatedSection extends StatefulWidget {
  const AwningsAnimatedSection({super.key});

  @override
  State<AwningsAnimatedSection> createState() => _AwningsAnimatedSectionState();
}

class _AwningsAnimatedSectionState extends State<AwningsAnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;

  final List<AwningItem> _awnings = const [
    AwningItem(
      title: "Rooftop Louver Pergola",
      imgurl: "assets/gy_aw_mo/awn1.png",
      desc:
      "Modern motorized louvered roof structure providing customizable shade for luxury rooftop terraces.",
    ),
    AwningItem(
      title: "Balcony Patio Awning",
      imgurl: "assets/gy_aw_mo/awn2.png",
      desc:
      "Sleek architectural canopy structure designed for outdoor lounge spaces and high-rise balconies.",
    ),
    AwningItem(
      title: "Retractable Balcony Shade",
      imgurl: "assets/gy_aw_mo/awn3.png",
      desc:
      "Heavy-duty motorized black folding arm awning offering instant sun & rain protection.",
    ),
    AwningItem(
      title: "Commercial Terrace Pergola",
      imgurl: "assets/gy_aw_mo/awn4.png",
      desc:
      "Weatherproof outdoor dining canopy designed for rooftop restaurants, cafes, and hospitality spaces.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _leftSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.8, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _rightSlideAnimation = Tween<Offset>(
      begin: const Offset(0.8, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

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

    int crossAxisCount = 4;
    if (screenWidth < 600) {
      crossAxisCount = 1;
    } else if (screenWidth < 900) {
      crossAxisCount = 2;
    } else if (screenWidth < 1200) {
      crossAxisCount = 3;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 900 ? 32.0 : 16.0,
        vertical: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Architectural Outdoor Awnings",
            textAlign: TextAlign.center,
            style: GoogleFonts.cabin(
              fontSize: screenWidth > 600 ? 28 : 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF276B5A),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFC89D52),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Transform your outdoor spaces, balconies, and rooftops with weather-resistant awnings and pergolas.",
            textAlign: TextAlign.center,
            style: GoogleFonts.cabin(
              fontSize: 13.5,
              color: const Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _awnings.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 380,
            ),
            itemBuilder: (context, index) {
              final item = _awnings[index];
              final bool slideFromLeft = index % 2 == 0;

              return SlideTransition(
                position:
                slideFromLeft ? _leftSlideAnimation : _rightSlideAnimation,
                child: _AwningCard(item: item),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AwningCard extends StatefulWidget {
  final AwningItem item;

  const _AwningCard({required this.item});

  @override
  State<_AwningCard> createState() => _AwningCardState();
}

class _AwningCardState extends State<_AwningCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: _isHovered
            ? (Matrix4.identity()..translate(0, -4, 0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF276B5A)
                : const Color(0xFF276B5A).withOpacity(0.2),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFF276B5A).withOpacity(0.15)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _isHovered ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  widget.item.imgurl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFEBF5F2),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.house,
                              size: 36, color: Color(0xFF276B5A)),
                          SizedBox(height: 6),
                          Text("Image Not Found",
                              style: TextStyle(
                                  color: Color(0xFF276B5A), fontSize: 11)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.cabin(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
                    const SizedBox(height: 4),
                    Text(widget.item.desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.cabin(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xFF555555), height: 1.3)),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showContactFormDialog(context);
                        },
                        icon: const Icon(
                            Icons.touch_app_outlined, size: 16, color: Colors.white),
                        label: Text("Get in Touch", style: GoogleFonts.cabin(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF276B5A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 3. MOSQUITO NET SECTION
// =============================================================================

class MosquitoNets extends StatefulWidget {
  const MosquitoNets({super.key});

  @override
  State<MosquitoNets> createState() => _MosquitoNetsState();
}

class _MosquitoNetsState extends State<MosquitoNets> {
  final List<NavItem> _navItems = const [
    NavItem(label: "Home", route: AppRoutes.home, icon: Icons.home),
    NavItem(label: "About", route: AppRoutes.about, icon: CupertinoIcons.info_circle),
    NavItem(label: "Clients", route: AppRoutes.clients, icon: CupertinoIcons.person_alt_circle),
    NavItem(label: "Shop", route: AppRoutes.shop, icon: CupertinoIcons.cart),
    NavItem(
      label: "Reviews",
      icon: Icons.reviews_outlined,
      route:
      "https://www.google.com/maps/place/Bindu+Decorators/@19.2351656,72.8487463,17z/data=!3m1!5s0x3be7b0d85f0d5563:0xbcc67135cad97d47!4m12!1m2!2m1!1sB-2+Mandpeshwar+Ind+premises+Opp+MCF+Gymkhana+Road+Borivali+west+mumbai-400092!3m8!1s0x3be7b11fee8a918b:0xedf1f8374494f993!8m2!3d19.2351656!4d72.8532524!9m1!1b1!15sCk5CLTIgTWFuZHBlc2h3YXIgSW5kIHByZW1pc2VzIE9wcCBNQ0YgR3lta2hhbmEgUm9hZCBCb3JpdmFsaSB3ZXN0IG11bWJhaS00MDAwOTJaUCJOYiAyIG1hbmRwZXNod2FyIGluZCBwcmVtaXNlcyBvcHAgbWNmIGd5bWtoYW5hIHJvYWQgYm9yaXZhbGkgd2VzdCBtdW1iYWkgNDAwMDkykgEPd2FsbHBhcGVyX3N0b3Jl4AEA!16s%2Fg%2F1v_slq8m?entry=ttu&g_ep=EgoyMDI2MDgwNS4xIKXMDSoASAFQAw%3D%3D",
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

  void _handleNavigation(String route) {
    if (route.startsWith('http')) {
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
      backgroundColor: const Color(0xFFF9FBFB),
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
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: MosquitoNetAnimatedSection(),
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

class MosquitoNetItem {
  final String title;
  final String desc;
  final String imgurl;

  const MosquitoNetItem({
    required this.title,
    required this.desc,
    required this.imgurl,
  });
}

class MosquitoNetAnimatedSection extends StatefulWidget {
  const MosquitoNetAnimatedSection({super.key});

  @override
  State<MosquitoNetAnimatedSection> createState() =>
      _MosquitoNetAnimatedSectionState();
}

class _MosquitoNetAnimatedSectionState
    extends State<MosquitoNetAnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;

  final List<MosquitoNetItem> _mosquitoItems = const [
    MosquitoNetItem(
      title: "Outdoor Lawn Dome Net",
      imgurl: "assets/gy_aw_mo/mo1.png",
      desc:
      "Portable outdoor pop-up mesh dome designed to create insect-free lounge seating in garden areas.",
    ),
    MosquitoNetItem(
      title: "Gazebo Mesh Screen Enclosure",
      imgurl: "assets/gy_aw_mo/mo2.png",
      desc:
      "Full perimeter transparent mosquito mesh netting for outdoor gazebos, patios, and pergolas.",
    ),
    MosquitoNetItem(
      title: "Pleated Window Mesh Screen",
      imgurl: "assets/gy_aw_mo/mo3.png",
      desc:
      "Retractable accordion-style mosquito net for smooth sliding windows and balcony doors.",
    ),
    MosquitoNetItem(
      title: "Magnetic Door Screen Net",
      imgurl: "assets/gy_aw_mo/mo4.png",
      desc:
      "Self-closing magnetic mesh door screen offering effortless hands-free entry and bug protection.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _leftSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.8, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _rightSlideAnimation = Tween<Offset>(
      begin: const Offset(0.8, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

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

    int crossAxisCount = 4;
    if (screenWidth < 600) {
      crossAxisCount = 1;
    } else if (screenWidth < 900) {
      crossAxisCount = 2;
    } else if (screenWidth < 1200) {
      crossAxisCount = 3;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 900 ? 32.0 : 16.0,
        vertical: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Mosquito & Insect Protection Nets",
            textAlign: TextAlign.center,
            style: GoogleFonts.cabin(
              fontSize: screenWidth > 600 ? 28 : 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF276B5A),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFC89D52),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Enjoy fresh air without insect pests with our premium indoor & outdoor mesh enclosures.",
            textAlign: TextAlign.center,
            style: GoogleFonts.cabin(
              fontSize: 13.5,
              color: const Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _mosquitoItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 380,
            ),
            itemBuilder: (context, index) {
              final item = _mosquitoItems[index];
              final bool slideFromLeft = index % 2 == 0;

              return SlideTransition(
                position:
                slideFromLeft ? _leftSlideAnimation : _rightSlideAnimation,
                child: _MosquitoNetCard(item: item),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MosquitoNetCard extends StatefulWidget {
  final MosquitoNetItem item;

  const _MosquitoNetCard({required this.item});

  @override
  State<_MosquitoNetCard> createState() => _MosquitoNetCardState();
}

class _MosquitoNetCardState extends State<_MosquitoNetCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: _isHovered
            ? (Matrix4.identity()..translate(0, -4, 0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF276B5A)
                : const Color(0xFF276B5A).withOpacity(0.2),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFF276B5A).withOpacity(0.15)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _isHovered ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  widget.item.imgurl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFEBF5F2),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.shield,
                              size: 36, color: Color(0xFF276B5A)),
                          SizedBox(height: 6),
                          Text("Image Not Found",
                              style: TextStyle(
                                  color: Color(0xFF276B5A), fontSize: 11)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.cabin(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
                    const SizedBox(height: 4),
                    Text(widget.item.desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.cabin(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xFF555555), height: 1.3)),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showContactFormDialog(context);
                        },
                        icon: const Icon(Icons.touch_app_outlined, size: 16, color: Colors.white),
                        label: Text("Get in Touch", style: GoogleFonts.cabin(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF276B5A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}