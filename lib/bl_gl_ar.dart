import 'package:bindu_decor/Nav_Widgets/Navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Home_Page.dart';
import 'Pro_Details.dart';

// ============================================================================
// GLOBAL NAVIGATION CONFIGURATIONS
// ============================================================================

final List<NavItem> _globalNavItems = const [
  NavItem(label: "Home", route: AppRoutes.home, icon: Icons.home),
  NavItem(label: "About", route: AppRoutes.about, icon: CupertinoIcons.info_circle),
  NavItem(label: "Clients", route: AppRoutes.clients, icon: CupertinoIcons.person_alt_circle),
  NavItem(label: "Projects", route: AppRoutes.projects, icon: CupertinoIcons.building_2_fill),
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
// COMMON PRODUCT GRID CARD WIDGET
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
          Text(widget.item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.cormorantGaramond(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF222222))),
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
                      Text("Inquire", style: GoogleFonts.cabin(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
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

// =============================================================================
// 1. BLINDS SECTION
// =============================================================================

class Blinds extends StatefulWidget {
  const Blinds({super.key});

  @override
  State<Blinds> createState() => _BlindsState();
}

class _BlindsState extends State<Blinds> {

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

class BlindsAnimatedSection extends StatelessWidget {
  const BlindsAnimatedSection({super.key});

  final List<DecorProductItem> _blinds = const [
    DecorProductItem(
      title: "Modern Wooden Roller Blinds",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSL-v-AASWB8__k6UF3FSvo6yDbfMZYTVFkWPr3iyZ5_g&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4Pc6ToN_DEvhUyQBKYXaYzq24yQFWWEb_cfJv85dvXg&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShmMFK9REEOt5OHBeesimNvShdgzNxDELdPa3UlNx9Jg&s=10",
      ],
      description: "Wooden textured roller blinds offering precise light control and natural elegance.",
    ),
    DecorProductItem(
      title: "Motorized Zebra Shades",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4KAdQo4yQNWahr6N_0GzhhXazPw0ad8K47iJDfKWr2Q&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPaIX0R3v8brk-xVKMeRikwlNxv7bj3DfDddg-UreMfg&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTwI2TGooJGANSB_eQiReW3NSs-N7iAOs2hiVVUjX0fg&s=10",
      ],
      description: "Dual-layer motorized zebra blinds for effortless switching between privacy and light.",
    ),
    DecorProductItem(
      title: "Roman Fabric Window Blinds",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZh1_VnC8N3cCzt8Gd7XQoOR0QD5LlkWqgDAJkZHLmmA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnNeeqXE_rlKkFGSUXpvmXKDhlamiEmqepfQzv7uEAXQ&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSqswW3cgOCNLbzrYdOIQCaVVYIWVne40XouM_DMUcZg&s=10",
      ],
      description: "Soft fabric Roman blinds folding neatly for modern interiors.",
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
          Text("Premium Window Blinds", style: GoogleFonts.cormorantGaramond(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _blinds.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
              mainAxisExtent: 520,
            ),
            itemBuilder: (context, index) {
              return ProductGridCard(item: _blinds[index]);
            },
          ),
        ],
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

class GlassFilmsAnimatedSection extends StatelessWidget {
  const GlassFilmsAnimatedSection({super.key});

  final List<DecorProductItem> _glassFilms = const [
    DecorProductItem(
      title: "Frosted Privacy Glass Film",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSS5zFLRhjS9bxpN_W8yjHldqg9joye5Se1QW6cfdiSTg&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmzDETgaFUSPzqCx5tSFMiLQLMAgtOhjaR1UNASB1FOg&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPAVnhQIuchRPWi4e8Vsvw2QnVwBE8mg-67BoARJ6Hog&s",
      ],
      description: "High-quality frosted film ensuring complete privacy while allowing soft daylight.",
    ),
    DecorProductItem(
      title: "Geometric Patterned Film",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXRZC7xpWuTK1qrmwMhfh8Z26x_uGljRpjJRCPC84v9Q&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBcdEkYb5azFMFjjOJK91lklZdGKgfyhIMdfuqRhtiIA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIq7t9egM5zlMezxBvibP6it1Ykje5j88Y904AA8Qd_g&s=10",
      ],
      description: "Decorative geometric glass film bringing stylish aesthetics to office dividers.",
    ),
    DecorProductItem(
      title: "Solar Heat Control Sun Film",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPCYJF8zNWJY7NBiXcwci4MZCz16e23kEtKNOxWwmSbQ&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHcm81hOYwFfB758rp2YpjzPUycII2xDDO5p9LOGfCoA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZ4Zbdp91p8wTeC-r6JACk0TbbnIjmIjG0ZKBShKuwEg&s",
      ],
      description: "UV blocking reflective solar control film that reduces indoor heat and glare.",
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
          Text("Decorative & Safety Glass Films", style: GoogleFonts.cormorantGaramond(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _glassFilms.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
              mainAxisExtent: 520,
            ),
            itemBuilder: (context, index) {
              return ProductGridCard(item: _glassFilms[index]);
            },
          ),
        ],
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

class ArtificialTurfsAnimatedSection extends StatelessWidget {
  const ArtificialTurfsAnimatedSection({super.key});

  final List<DecorProductItem> _turfs = const [
    DecorProductItem(
      title: "Lush Green Balcony Grass",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_K67g_nBZEKDDJP0xJKRrcFtvjSnTI1t9UHSuTECN4A&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFqAXWYwJdjpxXF1H6s2r-zGd9kZ82akiroKW9Yc3RQA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRUk-ng3-DGQKQL9eHke4ze6CGk5wVGscO7a9sBCtjdQ&s=10",
      ],
      description: "Ultra-soft 35mm natural look artificial grass ideal for balcony gardens.",
    ),
    DecorProductItem(
      title: "High-Density Landscape Turf",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3T8qsfIxm7yDq5Poiz0CPXlZTbutHFmbV8zrfb_1L3A&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxnShjA6E52AnAS2wbE0cGt349Zf7jYAi0_GEDnVeJKw&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwj8Y1dQWDFC1mTeywt0EJX_uDFOhf6UfrKLb4QVeNKw&s=10",
      ],
      description: "Durable UV-resistant grass providing vibrant green lawn coverage without watering.",
    ),
    DecorProductItem(
      title: "Sports & Play Area Turf",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRNewt7mQGQo7Dz11IwUUuruBQubrowazxEPIsrJOQhA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmM0s5e1nH_jjcrGRRhc3_9NU_a7JtwM4Mnj3Yk_audA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQe2hOE1UwqU_xHWlQD6BAk-mvWjQnKDJ-AG7Emdtk5qg&s",
      ],
      description: "Heavy-duty artificial turf engineered for high-traffic playgrounds and sports courts.",
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
          Text("Premium Artificial Turfs", style: GoogleFonts.cormorantGaramond(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _turfs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
              mainAxisExtent: 520,
            ),
            itemBuilder: (context, index) {
              return ProductGridCard(item: _turfs[index]);
            },
          ),
        ],
      ),
    );
  }
}