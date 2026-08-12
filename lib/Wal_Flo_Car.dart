import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Home_Page.dart';
import 'Nav_Widgets/Navigation.dart';

// ============================================================================
// GLOBAL NAVIGATION CONFIGURATIONS (Unified for all screens)
// ============================================================================

final List<NavItem> _globalNavItems = const [
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

final List<NestedMenuItem> _globalShopItems = const [
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

// ============================================================================
// DATA MODELS
// ============================================================================

class DecorProductItem {
  final String title;
  final String price;
  final List<String> imageUrls;
  final String description;

  const DecorProductItem({
    required this.title,
    required this.price,
    required this.imageUrls,
    required this.description,
  });
}

// ============================================================================
// COMMON PRODUCT CARD WIDGET
// ============================================================================

class ProductGridCard extends StatefulWidget {
  final DecorProductItem item;

  const ProductGridCard({super.key, required this.item});

  @override
  State<ProductGridCard> createState() => _ProductGridCardState();
}

class _ProductGridCardState extends State<ProductGridCard> {
  int _selectedImageIndex = 0;
  bool _isFavorite = false;

  Widget _buildProductImage(String path) {
    return Image.network(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF2F2F2),
      child: const Center(
        child: Icon(CupertinoIcons.photo, color: Colors.grey, size: 32),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentImage = widget.item.imageUrls.isNotEmpty
        ? widget.item.imageUrls[_selectedImageIndex]
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Image Area with Heart Icon & Tap Gesture
        Expanded(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => showContactFormDialog(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFF5F5F5),
                    child: _buildProductImage(currentImage),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      size: 18,
                      color: _isFavorite ? Colors.red : Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Product Title
        Text(
          widget.item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.cabin(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF222222),
          ),
        ),
        const SizedBox(height: 2),

        // Price per sq. ft.
        Text(
          widget.item.price,
          style: GoogleFonts.cabin(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 6),

        // Thumbnails & Get in Touch Bar
        Row(
          children: [
            // Thumbnail Selector Row
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(widget.item.imageUrls.length, (idx) {
                    final isSelected = idx == _selectedImageIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = idx;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.black87 : Colors.transparent,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1),
                          child: _buildProductImage(widget.item.imageUrls[idx]),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Get in Touch Action Button
            InkWell(
              onTap: () => showContactFormDialog(context),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF276B5A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.touch_app_outlined, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      "Inquire",
                      style: GoogleFonts.cabin(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// 1. WALLPAPERS SCREEN
// ============================================================================

class Wallpapers extends StatefulWidget {
  const Wallpapers({super.key});

  @override
  State<Wallpapers> createState() => _WallpapersState();
}

class _WallpapersState extends State<Wallpapers> {
  void _handleNavigation(String route) {
    if (route.startsWith('http')) return;
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: BinduNavigationBar(
          navItems: _globalNavItems,
          shopItems: _globalShopItems,
          onMenuItemTap: () => _handleNavigation,
        ),
      ),
      drawer: isDesktop
          ? null
          : BinduMobileDrawer(
        navItems: _globalNavItems,
        shopItems: _globalShopItems,
        onItemTap: () => _handleNavigation,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: WallpaperAnimatedSection(),
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

class WallpaperAnimatedSection extends StatelessWidget {
  const WallpaperAnimatedSection({super.key});

  final List<DecorProductItem> _wallpapers = const [
    DecorProductItem(
      title: "The Song of the Woods",
      price: "₹250 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/87/42/48/874248a3138f2208a3f8fa55bfefec23.jpg",
        "https://i.pinimg.com/236x/51/cd/a7/51cda7860eb8c693fd61ed10e7e66b0c.jpg",
        "https://i.pinimg.com/736x/12/3a/0b/123a0b4d45e2270928a6fdf6d132ab23.jpg",
      ],
      description: "Monochrome forest trees mural depicting peaceful wilderness.",
    ),
    DecorProductItem(
      title: "Little Curiosity",
      price: "₹250 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/66/3d/dc/663ddcdaf1c20974a4e68510f6eab6fb.jpgg",
        "https://i.pinimg.com/736x/07/2d/27/072d272f467bcc1b0b995bc34cc8f21a.jpg",
        "https://i.pinimg.com/736x/7d/8d/40/7d8d400a4e4ebe24c92581b52c848597.jpg",
      ],
      description: "Sage green botanical pattern featuring subtle animal silhouettes.",
    ),
    DecorProductItem(
      title: "Secrets Of The Stars",
      price: "₹250 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/21/0f/cf/210fcf17b9d628f8f2b3ec2a0c868128.jpg",
        "https://i.pinimg.com/736x/80/2c/40/802c40fe51cedf55895b8df4952ac624.jpg",
        "https://i.pinimg.com/736x/39/d1/20/39d120dcae780449bc9e1a8a29eef2e1.jpg",
      ],
      description: "Night sky over traditional royal architectural landscape.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600 ? 1 : (screenWidth < 900 ? 2 : 3);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 900 ? 40.0 : 16.0,
        vertical: 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Wallpapers Collection",
            style: GoogleFonts.cabin(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF276B5A),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _wallpapers.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
              mainAxisExtent: 520,
            ),
            itemBuilder: (context, index) {
              return ProductGridCard(item: _wallpapers[index]);
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 2. FLOORINGS SCREEN
// ============================================================================

class Floorings extends StatefulWidget {
  const Floorings({super.key});

  @override
  State<Floorings> createState() => _FlooringsState();
}

class _FlooringsState extends State<Floorings> {
  void _handleNavigation(String route) {
    if (route.startsWith('http')) return;
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: BinduNavigationBar(
          navItems: _globalNavItems,
          shopItems: _globalShopItems,
          onMenuItemTap: () => _handleNavigation,
        ),
      ),
      drawer: isDesktop
          ? null
          : BinduMobileDrawer(
        navItems: _globalNavItems,
        shopItems: _globalShopItems,
        onItemTap: () => _handleNavigation,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: FloorAnimatedSection(),
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

class FloorAnimatedSection extends StatelessWidget {
  const FloorAnimatedSection({super.key});

  final List<DecorProductItem> _floors = const [
    DecorProductItem(
      title: "Royal Gold Oak Plank",
      price: "₹320 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/8d/a4/09/8da40941df5e8c1ff94e0f5451e5cfb1.jpg",
        "https://i.pinimg.com/736x/5c/12/3b/5c123b092837fec178224b11f0084aef.jpg",
        "https://i.pinimg.com/736x/77/82/30/7782309e20a2334ef518d6bf918231e8.jpg",
      ],
      description: "Premium oak finish hardwood flooring planks.",
    ),
    DecorProductItem(
      title: "Dark Vintage Hardwood",
      price: "₹290 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/32/cb/fa/32cbfa91a27e77b4d3d2db7aa6d42125.jpg",
        "https://i.pinimg.com/736x/88/1b/23/881b238f902cd381baee2100a747cd11.jpg",
        "https://i.pinimg.com/736x/91/ee/40/91ee40a5f099120bc7645167e42d729a.jpg",
      ],
      description: "Rich dark walnut wood planks for cozy, elegant interior flooring.",
    ),
    DecorProductItem(
      title: "Italian Carrara Marble Tile",
      price: "₹450 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/c5/40/07/c54007b8b29dd6242c388efd4cb73860.jpg",
        "https://i.pinimg.com/736x/41/39/0f/41390f7a098bc100e428d09fbc622345.jpg",
        "https://i.pinimg.com/736x/11/49/aa/1149aacb234ff5002981329aef100a82.jpg",
      ],
      description: "Polished Italian white marble finish tile for luxury spaces.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600 ? 1 : (screenWidth < 900 ? 2 : 3);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 900 ? 40.0 : 16.0,
        vertical: 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Premium Floorings",
            style: GoogleFonts.cabin(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF276B5A),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _floors.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
              mainAxisExtent: 520,
            ),
            itemBuilder: (context, index) {
              return ProductGridCard(item: _floors[index]);
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 3. CARPETS SCREEN
// ============================================================================

class Carpets extends StatefulWidget {
  const Carpets({super.key});

  @override
  State<Carpets> createState() => _CarpetsState();
}

class _CarpetsState extends State<Carpets> {
  void _handleNavigation(String route) {
    if (route.startsWith('http')) return;
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: BinduNavigationBar(
          navItems: _globalNavItems,
          shopItems: _globalShopItems,
          onMenuItemTap: () => _handleNavigation,
        ),
      ),
      drawer: isDesktop
          ? null
          : BinduMobileDrawer(
        navItems: _globalNavItems,
        shopItems: _globalShopItems,
        onItemTap: () => _handleNavigation,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: CarpetAnimatedSection(),
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

class CarpetAnimatedSection extends StatelessWidget {
  const CarpetAnimatedSection({super.key});

  final List<DecorProductItem> _carpets = const [
    DecorProductItem(
      title: "Royal Hand-Tufted Plush",
      price: "₹180 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/55/78/3d/55783d6a229cb5fa9e7b235ee6fa25d3.jpg",
        "https://i.pinimg.com/736x/2a/e5/11/2ae51130e9d8cb4318d18471b3e94b81.jpg",
        "https://i.pinimg.com/736x/7b/91/f0/7b91f034eb89e672bbcd199b542e88a0.jpg",
      ],
      description: "Soft hand-tufted plush wool carpet for living areas.",
    ),
    DecorProductItem(
      title: "Modern Vintage Persian Rug",
      price: "₹210 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/1a/bc/40/1abc401b52a4e9bd1114bd4f31c4f1c9.jpg",
        "https://i.pinimg.com/736x/48/21/5c/48215cc3984180dd43fe8d3a24ab1e01.jpg",
        "https://i.pinimg.com/736x/31/b0/29/31b029288ee8798bf2c28ef5aef21d00.jpg",
      ],
      description: "Traditional motif with modern distressed finish.",
    ),
    DecorProductItem(
      title: "Abstract Gold & Teal Rug",
      price: "₹240 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/8d/23/ef/8d23eff0bc261687fbd52a0a28f8f9cd.jpg",
        "https://i.pinimg.com/736x/17/80/9e/17809e51c8e1903ebc109d94943f5a11.jpg",
        "https://i.pinimg.com/736x/60/a4/12/60a4128f1e4bc0b2c1f92a34298ab820.jpg",
      ],
      description: "Artistic contemporary statement rug for living spaces.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600 ? 1 : (screenWidth < 900 ? 2 : 3);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 900 ? 40.0 : 16.0,
        vertical: 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Luxury Carpets & Rugs",
            style: GoogleFonts.cabin(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF276B5A),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _carpets.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
              mainAxisExtent: 520,
            ),
            itemBuilder: (context, index) {
              return ProductGridCard(item: _carpets[index]);
            },
          ),
        ],
      ),
    );
  }
}