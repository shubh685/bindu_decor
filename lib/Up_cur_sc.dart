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
  NavItem(label: "Log In", route: AppRoutes.login, icon: Icons.login),
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

// =============================================================================
// 1. UPHOLSTERY SECTION
// =============================================================================

class Upholstery extends StatefulWidget {
  const Upholstery({super.key});

  @override
  State<Upholstery> createState() => _UpholsteryState();
}

class _UpholsteryState extends State<Upholstery> {

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
              child: UpholsteryAnimatedSection(),
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

class UpholsteryAnimatedSection extends StatelessWidget {
  const UpholsteryAnimatedSection({super.key});

  final List<DecorProductItem> _upholsteryItems = const [
    DecorProductItem(
      title: "Modular Curved Lounge Sofa",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkRhQssdHo3-JIMolcjjqkDzYGPBwkZGtfeVvxP1f4ng&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9xpJbTRV0CF8opUBVj4T4-wr6RczL1eFiq1y2T00qyg&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQra5VULvZHxVb2zzQQbY4_fgh_dn4h7NdII0_rZt6Ekw&s=10",
      ],
      description: "Modern curved modular sofa set in olive green and beige textured fabrics with warm ambient wall lights.",
    ),
    DecorProductItem(
      title: "Floral Printed Sofa",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsrdBEmz6tUd8qMklwgczwA3nenU3kBnpIbw2P4c9JLw&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxt-qePejPp7S892nn5fYThdDM8ymS_w1tUwryI8ws3w&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyJxd9-gsvOJ8MHgyg8kUGAq0aynrKmeJ-Lt_lq4Vzmg&s=10",
      ],
      description: "Vibrant artistic floral fabric sofa with rich wooden trim finish and custom patterned throw pillows.",
    ),
    DecorProductItem(
      title: "Dual-Tone Leatherette Sofa",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM5tNTTTWRARJmmYn4V6WJ9rG9Bi6xePOxs-ARGKYLCQ&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHFd8HQjzUx6SQTkzeQ0a4q6NtheUv9uOIorYPp1unsw&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQso9kXxUKdz4bVDJK4HO5rNwOeCgE_B9-RY17j8dFlLA&s",
      ],
      description: "Contemporary tan orange and cream leatherette padded sofa with sleek metal leg support.",
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
            "Luxury Upholstery Fabrics & Sofas",
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
            itemCount: _upholsteryItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
              mainAxisExtent: 520,
            ),
            itemBuilder: (context, index) {
              return ProductGridCard(item: _upholsteryItems[index]);
            },
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 2. CURTAINS SECTION
// =============================================================================

class Curtains extends StatefulWidget {
  const Curtains({super.key});

  @override
  State<Curtains> createState() => _CurtainsState();
}

class _CurtainsState extends State<Curtains> {

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
              child: CurtainsAnimatedSection(),
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

class CurtainsAnimatedSection extends StatelessWidget {
  const CurtainsAnimatedSection({super.key});

  final List<DecorProductItem> _curtainItems = const [
    DecorProductItem(
      title: "Boho Palm Print & Navy Drapes",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSTPR_ATqgSAd4j0jqrSkBV7QPLDBe0nVO0twMhFfMtA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSb562mQjYbWcicnMLAEuZdWwTgE0DEQh32_SrnKNxDDg&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDCH0SaeY8vnwbfl9GGu1_FDTMNNpbnck8ikEKeE9H0w&s",
      ],
      description: "Stylish cream palm print eyelet curtains paired with solid royal blue drapes and fringe tassel trim.",
    ),
    DecorProductItem(
      title: "Yellow Wildflower Floral Drapes",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpDTGGEt4ZMcIHTjRk7O-2ItFwf0nEXFF4V6J1atV_Lw&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMmAkaaFiFkf_xHWwDarlvv8Oi0VpRW3tGqSNEvxC9lA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvXcXPFlAZcYSulfyU2WFLZqowL_YDLvPIAfc3nuhwcg&s=10",
      ],
      description: "Bright mustard yellow eyelet curtains combined with delicate floral stem patterned drapes.",
    ),
    DecorProductItem(
      title: "Royal Blue & Gold Layered Drapes",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRf5xEKHnMqzCP59cosJBE_UavvQHrJOA2nz1KDlqx33g&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbtEWamz6HLoRmkHsFaiXFsS2zyfvg-PJaEp-Zelp1wQ&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSm47Qt0RfK1KJ9QJul4Ig7bvruSMjgMoR78Dw2FhwmRw&s",
      ],
      description: "Luxury dual-color royal blue and mustard curtains with tied-back blackout layers over soft sheer fabric.",
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
          Text("Designer Curtains & Window Drapes", style: GoogleFonts.cormorantGaramond(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _curtainItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
              mainAxisExtent: 520,
            ),
            itemBuilder: (context, index) {
              return ProductGridCard(item: _curtainItems[index]);
            },
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 3. STRETCH CEILING SECTION
// =============================================================================

class StretchCeiling extends StatefulWidget {
  const StretchCeiling({super.key});

  @override
  State<StretchCeiling> createState() => _StretchCeilingState();
}

class _StretchCeilingState extends State<StretchCeiling> {

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
              child: StretchCeilingAnimatedSection(),
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

class StretchCeilingAnimatedSection extends StatelessWidget {
  const StretchCeilingAnimatedSection({super.key});

  final List<DecorProductItem> _stretchCeilingItems = const [
    DecorProductItem(
      title: "Glossy Mirror Stretch Ceiling",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDLDPB52KffAPZmuAPuVztlL2jconnP8GXBWCD42hakA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTe_G75vtiXEGL4jyAGPr0ON4xLF6p94YXCqnqBT21kLg&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRG_hf8wsx84KsohNAzAjTS52vWElP6fC5O0ef0mSy2w&s=10",
      ],
      description: "High-gloss dark reflective stretch ceiling with integrated perimeter strip lighting for a spacious interior look.",
    ),
    DecorProductItem(
      title: "Multi-Tiered Wooden Stretch Ceiling",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeUctTmuvuv1HtPNyobLOWywyWBRucDCPYqjrJXw2OLA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5zk4uU55L1uOvbnS4IKNoaV12ek1LhhUWrSB7mxxLHg&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAkvNGzoawpID_qsnVBj6rk6xoEYmAUN7DqWiLiEL9Bg&s",
      ],
      description: "Architectural multi-level ceiling design featuring warm LED backlighting and central circular accents.",
    ),
    DecorProductItem(
      title: "Sky Print Backlit Stretch Ceiling",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVD6rqC8QjlcD7n4L8Hewldk2ayd2ZaOpgaiL1GL1ajA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNwNawkBbFVrH6CKOtc1FKIHroTxdDkaYEchvemfHk3Q&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsk4lqdAT0ovA9K5abcLe7GbfGUbO1g-hmR6l6WS-RFQ&s=10",
      ],
      description: "Illuminated sky and snow forest print stretch ceiling panel bringing a natural outdoor feel indoors.",
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
          Text("Decorative Stretch Ceilings", style: GoogleFonts.cormorantGaramond(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stretchCeilingItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
              mainAxisExtent: 520,
            ),
            itemBuilder: (context, index) {
              return ProductGridCard(item: _stretchCeilingItems[index]);
            },
          ),
        ],
      ),
    );
  }
}