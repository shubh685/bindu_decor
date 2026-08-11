import 'package:bindu_decor/Nav_Widgets/Navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Home_Page.dart';

// =============================================================================
// 1. BLINDS SECTION
// =============================================================================

class Blinds extends StatefulWidget {
  const Blinds({super.key});

  @override
  State<Blinds> createState() => _BlindsState();
}

class _BlindsState extends State<Blinds> {
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
              child: BlindsAnimatedSection(),
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

class BlindItem {
  final String title;
  final String desc;
  final String imgurl;

  const BlindItem({
    required this.title,
    required this.desc,
    required this.imgurl,
  });
}

class BlindsAnimatedSection extends StatefulWidget {
  const BlindsAnimatedSection({super.key});

  @override
  State<BlindsAnimatedSection> createState() => _BlindsAnimatedSectionState();
}

class _BlindsAnimatedSectionState extends State<BlindsAnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;

  final List<BlindItem> _blinds = const [
    BlindItem(
      title: "Modern Wooden Roller Blinds",
      imgurl: "assets/bl_gl_ar/bli1.png",
      desc:
      "Sleek wooden textured roller blinds offering precise light control and natural elegance.",
    ),
    BlindItem(
      title: "Motorized Zebra Shades",
      imgurl: "assets/bl_gl_ar/bli2.png",
      desc:
      "Dual-layer motorized zebra blinds for effortless switching between privacy and natural light.",
    ),
    BlindItem(
      title: "Roman Fabric Window Blinds",
      imgurl: "assets/bl_gl_ar/bli3.png",
      desc:
      "Elegant soft fabric Roman blinds that fold neatly to complement sophisticated modern interiors.",
    ),
    BlindItem(
      title: "Vertical Venetian Blinds",
      imgurl: "assets/bl_gl_ar/bli4.png",
      desc:
      "Durable vertical blinds designed for large office windows, balconies, and modern sliding glass doors.",
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
            "Premium Window Blinds",
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
            "Elevate your window spaces with our versatile and stylish collection of custom window blinds.",
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
            itemCount: _blinds.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 380,
            ),
            itemBuilder: (context, index) {
              final item = _blinds[index];
              final bool slideFromLeft = index % 2 == 0;

              return SlideTransition(
                position:
                slideFromLeft ? _leftSlideAnimation : _rightSlideAnimation,
                child: _BlindsCard(item: item),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BlindsCard extends StatefulWidget {
  final BlindItem item;

  const _BlindsCard({required this.item});

  @override
  State<_BlindsCard> createState() => _BlindsCardState();
}

class _BlindsCardState extends State<_BlindsCard> {
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
                          Icon(CupertinoIcons.bars,
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
                    Text(
                      widget.item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cabin(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF276B5A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.item.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cabin(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF555555),
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.touch_app_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Get in Touch",
                          style: GoogleFonts.cabin(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
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
// 2. GLASS FILMS SECTION
// =============================================================================

class GlassFilms extends StatefulWidget {
  const GlassFilms({super.key});

  @override
  State<GlassFilms> createState() => _GlassFilmsState();
}

class _GlassFilmsState extends State<GlassFilms> {
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
              child: GlassFilmsAnimatedSection(),
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

class GlassFilmItem {
  final String title;
  final String desc;
  final String imgurl;

  const GlassFilmItem({
    required this.title,
    required this.desc,
    required this.imgurl,
  });
}

class GlassFilmsAnimatedSection extends StatefulWidget {
  const GlassFilmsAnimatedSection({super.key});

  @override
  State<GlassFilmsAnimatedSection> createState() =>
      _GlassFilmsAnimatedSectionState();
}

class _GlassFilmsAnimatedSectionState extends State<GlassFilmsAnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;

  final List<GlassFilmItem> _glassFilms = const [
    GlassFilmItem(
      title: "Frosted Privacy Glass Film",
      imgurl: "assets/bl_gl_ar/gla1.png",
      desc:
      "High-quality translucent frosted film ensuring complete privacy while allowing diffused natural sun light.",
    ),
    GlassFilmItem(
      title: "Geometric Patterned Film",
      imgurl: "assets/bl_gl_ar/gla2.png",
      desc:
      "Decorative geometric line art glass film that brings modern aesthetic appeal to glass doors & windows.",
    ),
    GlassFilmItem(
      title: "Solar Heat Control Sun Film",
      imgurl: "assets/bl_gl_ar/gla3.png",
      desc:
      "Advanced UV blocking reflective sun control film reducing heat build-up and saving energy.",
    ),
    GlassFilmItem(
      title: "Stained Glass Decorative Film",
      imgurl: "assets/bl_gl_ar/gla4.png",
      desc:
      "Vibrant stained glass effect film designed for artistic partition walls and entrance glass displays.",
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
            "Decorative & Safety Glass Films",
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
            "Enhance privacy, sun control, and interior aesthetics with our versatile range of glass film solutions.",
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
            itemCount: _glassFilms.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 380,
            ),
            itemBuilder: (context, index) {
              final item = _glassFilms[index];
              final bool slideFromLeft = index % 2 == 0;

              return SlideTransition(
                position:
                slideFromLeft ? _leftSlideAnimation : _rightSlideAnimation,
                child: _GlassFilmCard(item: item),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GlassFilmCard extends StatefulWidget {
  final GlassFilmItem item;

  const _GlassFilmCard({required this.item});

  @override
  State<_GlassFilmCard> createState() => _GlassFilmCardState();
}

class _GlassFilmCardState extends State<_GlassFilmCard> {
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
                          Icon(CupertinoIcons.film,
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
                    Text(
                      widget.item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cabin(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF276B5A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.item.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cabin(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF555555),
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.touch_app_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Get in Touch",
                          style: GoogleFonts.cabin(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
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
// 3. ARTIFICIAL TURFS SECTION
// =============================================================================

class ArtificialTurfs extends StatefulWidget {
  const ArtificialTurfs({super.key});

  @override
  State<ArtificialTurfs> createState() => _ArtificialTurfsState();
}

class _ArtificialTurfsState extends State<ArtificialTurfs> {
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
              child: ArtificialTurfsAnimatedSection(),
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

class ArtificialTurfItem {
  final String title;
  final String desc;
  final String imgurl;

  const ArtificialTurfItem({
    required this.title,
    required this.desc,
    required this.imgurl,
  });
}

class ArtificialTurfsAnimatedSection extends StatefulWidget {
  const ArtificialTurfsAnimatedSection({super.key});

  @override
  State<ArtificialTurfsAnimatedSection> createState() =>
      _ArtificialTurfsAnimatedSectionState();
}

class _ArtificialTurfsAnimatedSectionState
    extends State<ArtificialTurfsAnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;

  final List<ArtificialTurfItem> _turfs = const [
    ArtificialTurfItem(
      title: "Lush Green Balcony Grass",
      imgurl: "assets/bl_gl_ar/art-1.png",
      desc:
      "Ultra-soft 35mm natural look artificial grass ideal for apartment balconies and terrace gardens.",
    ),
    ArtificialTurfItem(
      title: "High-Density Landscape Turf",
      imgurl: "assets/bl_gl_ar/art-2.png",
      desc:
      "Durable, UV-resistant landscape grass providing all-year green lawn coverage without watering.",
    ),
    ArtificialTurfItem(
      title: "Sports & Play Area Turf",
      imgurl: "assets/bl_gl_ar/art-3.png",
      desc:
      "Heavy-duty artificial turf specifically engineered for sports grounds, rooftop courts, and play zones.",
    ),
    ArtificialTurfItem(
      title: "Vertical Green Wall Plant Panel",
      imgurl: "assets/bl_gl_ar/art-4.png",
      desc:
      "Decorative synthetic green foliage panel perfect for feature walls, cafes, and patio backdrops.",
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
            "Premium Artificial Turfs",
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
            "Bring everlasting natural greenery to your lawns, balconies, and indoor walls with zero maintenance.",
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
            itemCount: _turfs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 380,
            ),
            itemBuilder: (context, index) {
              final item = _turfs[index];
              final bool slideFromLeft = index % 2 == 0;

              return SlideTransition(
                position:
                slideFromLeft ? _leftSlideAnimation : _rightSlideAnimation,
                child: _ArtificialTurfCard(item: item),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ArtificialTurfCard extends StatefulWidget {
  final ArtificialTurfItem item;

  const _ArtificialTurfCard({required this.item});

  @override
  State<_ArtificialTurfCard> createState() => _ArtificialTurfCardState();
}

class _ArtificialTurfCardState extends State<_ArtificialTurfCard> {
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
                          Icon(CupertinoIcons.tree,
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
                    Text(
                      widget.item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cabin(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF276B5A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.item.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cabin(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF555555),
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.touch_app_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Get in Touch",
                          style: GoogleFonts.cabin(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
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