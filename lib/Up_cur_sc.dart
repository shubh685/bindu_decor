import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Home_Page.dart';
import 'Nav_Widgets/Navigation.dart';

// =============================================================================
// SHARED MODELS & REUSABLE COMPONENTS
// =============================================================================

class ProductItem {
  final String title;
  final String desc;
  final String imgurl;

  const ProductItem({
    required this.title,
    required this.desc,
    required this.imgurl,
  });
}

class ProductAnimatedSection extends StatefulWidget {
  final String sectionTitle;
  final String sectionSubtitle;
  final List<ProductItem> items;

  const ProductAnimatedSection({
    super.key,
    required this.sectionTitle,
    required this.sectionSubtitle,
    required this.items,
  });

  @override
  State<ProductAnimatedSection> createState() =>
      _ProductAnimatedSectionState();
}

class _ProductAnimatedSectionState extends State<ProductAnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;

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
          Text(widget.sectionTitle, textAlign: TextAlign.center, style: GoogleFonts.cabin(fontSize: screenWidth > 600 ? 28 : 22, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
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
            widget.sectionSubtitle,
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
            itemCount: widget.items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 380,
            ),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final bool slideFromLeft = index % 2 == 0;

              return SlideTransition(
                position:
                slideFromLeft ? _leftSlideAnimation : _rightSlideAnimation,
                child: ProductCard(item: item),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final ProductItem item;

  const ProductCard({super.key, required this.item});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
                          Icon(CupertinoIcons.photo, size: 36, color: Color(0xFF276B5A)),
                          SizedBox(height: 6),
                          Text("Image Not Found", style: TextStyle(color: Color(0xFF276B5A), fontSize: 11)),
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

// Nav Data for Integration
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

void _handleNavigation(BuildContext context, String route) {
  if (route.startsWith('http')) return;
  if (ModalRoute.of(context)?.settings.name != route) {
    Navigator.pushNamed(context, route);
  }
}

// =============================================================================
// 1. UPHOLSTERY CLASS
// =============================================================================

class Upholstery extends StatefulWidget {
  const Upholstery({super.key});

  @override
  State<Upholstery> createState() => _UpholsteryState();
}

class _UpholsteryState extends State<Upholstery> {
  final List<ProductItem> _upholsteryItems = const [
    ProductItem(
      title: "Modular Curved Lounge Sofa",
      imgurl: "assets/up_cur_sc/uph1.png",
      desc:
      "Modern curved modular sofa set in olive green and beige textured fabrics with warm ambient wall lights.",
    ),
    ProductItem(
      title: "Floral Printed Sofa",
      imgurl: "assets/up_cur_sc/uph2.png",
      desc:
      "Vibrant artistic floral fabric sofa with rich wooden trim finish and custom patterned throw pillows.",
    ),
    ProductItem(
      title: "Dual-Tone Leatherette Sofa",
      imgurl: "assets/up_cur_sc/uph3.png",
      desc:
      "Contemporary tan orange and cream leatherette padded sofa with sleek metal leg support.",
    ),
    ProductItem(
      title: "L-Shaped Sectional Sofa",
      imgurl: "assets/up_cur_sc/uph4.png",
      desc:
      "Spacious white fabric and terracotta leatherette sectional sofa designed for ultimate living room comfort.",
    ),
  ];

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
          onMenuItemTap: () => (route) => _handleNavigation(context, route),
        ),
      ),
      drawer: isDesktop
          ? null
          : BinduMobileDrawer(
        navItems: _navItems,
        shopItems: _shopItems,
        onItemTap: () => (route) => _handleNavigation(context, route),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: ProductAnimatedSection(
                sectionTitle: "Luxury Upholstery Fabrics & Sofas",
                sectionSubtitle:
                "Transform your furniture with high-grade leatherette, velvet, and custom textured upholstery fabrics.",
                items: _upholsteryItems,
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

// =============================================================================
// 2. CURTAINS CLASS
// =============================================================================

class Curtains extends StatefulWidget {
  const Curtains({super.key});

  @override
  State<Curtains> createState() => _CurtainsState();
}

class _CurtainsState extends State<Curtains> {
  final List<ProductItem> _curtainItems = const [
    ProductItem(
      title: "Boho Palm Print & Navy Drapes",
      imgurl: "assets/up_cur_sc/cur1.png",
      desc:
      "Stylish cream palm print eyelet curtains paired with solid royal blue drapes and fringe tassel trim.",
    ),
    ProductItem(
      title: "Yellow Wildflower Floral Drapes",
      imgurl: "assets/up_cur_sc/cur2.png",
      desc:
      "Bright mustard yellow eyelet curtains combined with delicate floral stem patterned drapes.",
    ),
    ProductItem(
      title: "Royal Blue & Gold Layered Drapes",
      imgurl: "assets/up_cur_sc/cur3.png",
      desc:
      "Luxury dual-color royal blue and mustard curtains with tied-back blackout layers over soft sheer fabric.",
    ),
    ProductItem(
      title: "Floral Branch & Chocolate Drapes",
      imgurl: "assets/up_cur_sc/cur4.png",
      desc:
      "Elegant brown blossom floral print curtains paired with rich solid chocolate brown grommet drapes.",
    ),
  ];

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
          onMenuItemTap: () => (route) => _handleNavigation(context, route),
        ),
      ),
      drawer: isDesktop
          ? null
          : BinduMobileDrawer(
        navItems: _navItems,
        shopItems: _shopItems,
        onItemTap: () => (route) => _handleNavigation(context, route),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: ProductAnimatedSection(
                sectionTitle: "Designer Curtains & Window Drapes",
                sectionSubtitle:
                "Elevate your interior ambience with custom printed, sheer, and blackout curtain solutions.",
                items: _curtainItems,
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

// =============================================================================
// 3. STRETCH CEILING CLASS
// =============================================================================

class StretchCeiling extends StatefulWidget {
  const StretchCeiling({super.key});

  @override
  State<StretchCeiling> createState() => _StretchCeilingState();
}

class _StretchCeilingState extends State<StretchCeiling> {
  final List<ProductItem> _stretchCeilingItems = const [
    ProductItem(
      title: "Glossy Mirror Stretch Ceiling",
      imgurl: "assets/up_cur_sc/sc1.png",
      desc:
      "High-gloss dark reflective stretch ceiling with integrated perimeter strip lighting for a spacious interior look.",
    ),
    ProductItem(
      title: "Multi-Tiered Wooden Stretch Ceiling",
      imgurl: "assets/up_cur_sc/sc2.png",
      desc:
      "Architectural multi-level ceiling design featuring warm LED backlighting and central circular accents.",
    ),
    ProductItem(
      title: "Sky Print Backlit Stretch Ceiling",
      imgurl: "assets/up_cur_sc/sc3.png",
      desc:
      "Illuminated sky and snow forest print stretch ceiling panel bringing a natural outdoor feel indoors.",
    ),
    ProductItem(
      title: "3D Butterfly Artwork Stretch Ceiling",
      imgurl: "assets/up_cur_sc/sc4.png",
      desc:
      "Vibrant 3D printed butterfly artwork stretch ceiling illuminated with soft perimeter cove lights.",
    ),
  ];

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
          onMenuItemTap: () => (route) => _handleNavigation(context, route),
        ),
      ),
      drawer: isDesktop
          ? null
          : BinduMobileDrawer(
        navItems: _navItems,
        shopItems: _shopItems,
        onItemTap: () => (route) => _handleNavigation(context, route),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: ProductAnimatedSection(
                sectionTitle: "Decorative Stretch Ceilings",
                sectionSubtitle:
                "Modern translucent, printed, glossy, and backlit ceiling solutions for luxury residential and commercial spaces.",
                items: _stretchCeilingItems,
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