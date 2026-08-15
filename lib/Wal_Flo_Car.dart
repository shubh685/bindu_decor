import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Home_Page.dart';
import 'Nav_Widgets/Navigation.dart';
import 'Pro_Details.dart';

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

  void _openDetailDialog() {
    showDialog(
      context: context,
      builder: (context) => ProductDetailPage(
        item: widget.item,
        initialImageIndex: _selectedImageIndex,
      ),
    );
  }

  Widget _buildProductImage(String path) {
    if (path.isEmpty) {
      return _buildPlaceholder();
    }

    return Image.network(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: const Color(0xFFF2F2F2),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF276B5A)),
            ),
          ),
        );
      },
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

    return InkWell(
      onTap: _openDetailDialog,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Image Display Area with InkWell / Tap Gesture
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFF5F5F5),
                    child: _buildProductImage(currentImage),
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

          // Title
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

          // Thumbnails & Quick Inquire Button
          Row(
            children: [
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

              InkWell(
                onTap: _openDetailDialog,
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
      ),
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
          onMenuItemTap: () => context.navigateTo,
        ),
      ),
      drawer: isDesktop
          ? null
          : BinduMobileDrawer(
        navItems: _globalNavItems,
        shopItems: _globalShopItems,
        onItemTap: () => context.navigateTo,
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
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZsUShEzxBw8UMG1bXP4OA76w62MddirmLsxpQSEJ-7A&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZ2x1v1wN0yDrpf-diMv0zswg_wRcWWxK2zqwQP-60Ew&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9NlR5jBTk4tJv49uFzm9isBBATYtsciHzVCW67hStCQ&s=10",
      ],
      description: "Monochrome forest trees mural depicting peaceful wilderness.",
    ),
    DecorProductItem(
      title: "Little Curiosity",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwK7pJ34s4p-K9BxnpIzh4NGKk5MBNzJOVanon8FkS9w&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGri-MxB0WuO36eV9VizgUJV2HOFHUCew1HaktAsB9HQ&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQevlSTzfIrkf6XMPRqB-8yK50GV4MkxbDPQhAjLPZZKw&s=10",
      ],
      description: "Sage green botanical pattern featuring subtle animal silhouettes.",
    ),
    DecorProductItem(
      title: "Secrets Of The Stars",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQgY8za7EGgk_vFJo9j0N9DeB-GPbU3FJBFaXh0MB44Q&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRylL2JMFEAJ8_mTdLUcXWcG9api2dJIprGaF0F4B10Dg&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAFMQ-EhhhtEZNEercVE3y7gEOROge81aLSjhf5yQitQ&s=10",
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
          Text("Wallpapers Collection", style: GoogleFonts.cabin(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
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
          onMenuItemTap: () => context.navigateTo,
        ),
      ),
      drawer: isDesktop
          ? null
          : BinduMobileDrawer(
        navItems: _globalNavItems,
        shopItems: _globalShopItems,
        onItemTap: () => context.navigateTo,
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
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7EN-yCRT7ltma9w_m17wK3nXBqZAkOtv7iINgSi40rQ&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTihL0RCXs3WhhNEGjIqJIE0ZIdWKf2e6Sey7zJX4GYBw&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyIy6VYGVGXLF_gukV-dIAZ3She3Ty-mqPGH1jw8chTQ&s=10",
      ],
      description: "Premium oak finish hardwood flooring planks.",
    ),
    DecorProductItem(
      title: "Dark Vintage Hardwood",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBdbAUfRC2j0DfJsq0oN0NQimXZwHJW4QCCJpz4NBf7g&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQaM9GO9jZJSLdWoDHbkG1Bd6nofQZZfJHy9RbuOs87EQ&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeNPHYvLU9WYWRoDEKO1ACulwuk63UKZGAbid78yByRw&s=10",
      ],
      description: "Rich dark walnut wood planks for cozy, elegant interior flooring.",
    ),
    DecorProductItem(
      title: "Italian Carrara Marble Tile",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPRnh8pDemscGO5PY7m2v50tR4Qat9_U_phc1IaLgHhg&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKqJebUVEo3MY1BcGeaEjEWf2HFFQq_P3C265T2NQsZw&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNEro14_--ktIWuwyp80puiGGbzAGYfqMKCsNyx7_Www&s=10",
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
          Text("Premium Floorings", style: GoogleFonts.cabin(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
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
          onMenuItemTap: () => context.navigateTo,
        ),
      ),
      drawer: isDesktop
          ? null
          : BinduMobileDrawer(
        navItems: _globalNavItems,
        shopItems: _globalShopItems,
        onItemTap: () => context.navigateTo,
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
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPa2GEOtq7-vDQGS-jV9Z8OODV8QRiTTEWQBFgTqS_qA&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_viVUCAkCR3qYrA8EOcXC8Uy9IKH-SqQ7t7BZ_OtnSQ&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzYjZFew7XRn6ceO1GJjtcSXmcMQp_WFPp7kN9QvakgQ&s=10",
      ],
      description: "Soft hand-tufted plush wool carpet for living areas.",
    ),
    DecorProductItem(
      title: "Modern Vintage Persian Rug",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTuRERD2mMB77rJbolW6_1rEiEOy66BrinmP1x_qCXGA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmpiH2bQ5C2R6uBGTejBHcToqbvKbHxuiIeN_VijXY0w&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrJ5a9CQckdA1DTUcY0qgxlzzXXvz_fhFaTEeE9dHTqg&s=10",
      ],
      description: "Traditional motif with modern distressed finish.",
    ),
    DecorProductItem(
      title: "Abstract Gold & Teal Rug",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgSZ8zcz5vT0vXzDsIZD7uWhL1bF_wDUP6YZ5fVEXdCA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQo0nYlMpW9BvxFFNbWWW-PImQuEGeyYwYiPJgyCp5dYQ&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIBNifFvWKH-ogGlLibh7VdWaM6ifHr1qhtNnGtdcQzg&s",
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
          Text("Luxury Carpets & Rugs", style: GoogleFonts.cabin(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
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