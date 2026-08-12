import 'package:bindu_decor/Nav_Widgets/Navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Home_Page.dart';

// ============================================================================
// GLOBAL NAVIGATION CONFIGURATIONS
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
// DATA MODEL
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
        // Main Image Display Area
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

        // Price
        Text(
          widget.item.price,
          style: GoogleFonts.cabin(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 6),

        // Thumbnails & Inquire Action Button
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

// =============================================================================
// 1. BLINDS SECTION
// =============================================================================

class Blinds extends StatefulWidget {
  const Blinds({super.key});

  @override
  State<Blinds> createState() => _BlindsState();
}

class _BlindsState extends State<Blinds> {
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
      price: "₹120 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/2b/9d/28/2b9d28d0859c03bfd92ca8a635677b10.jpg",
        "https://i.pinimg.com/736x/9f/8e/33/9f8e330a84d2847c21f92e8111e1f40d.jpg",
        "https://i.pinimg.com/736x/44/21/00/442100808a991823bcd14b1b88e14620.jpg",
      ],
      description: "Wooden textured roller blinds offering precise light control and natural elegance.",
    ),
    DecorProductItem(
      title: "Motorized Zebra Shades",
      price: "₹160 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/88/44/2c/88442c554e20790f95b5420306198f12.jpg",
        "https://i.pinimg.com/736x/11/aa/22/11aa223344b55c66d7788e8822998d33.jpg",
        "https://i.pinimg.com/736x/33/cc/11/33cc1199a88b2200ef77443311884021.jpg",
      ],
      description: "Dual-layer motorized zebra blinds for effortless switching between privacy and light.",
    ),
    DecorProductItem(
      title: "Roman Fabric Window Blinds",
      price: "₹140 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/11/bf/2d/11bf2d4c06208be14022c4d62cd2f6bc.jpg",
        "https://i.pinimg.com/736x/55/01/22/550122e8477bb91122a1002938e12332.jpg",
        "https://i.pinimg.com/736x/77/88/99/77889922002341d3311f44a889932145.jpg",
      ],
      description: "Soft fabric Roman blinds folding neatly for modern interiors.",
    ),
    DecorProductItem(
      title: "Vertical Venetian Blinds",
      price: "₹110 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/3f/8a/19/3f8a19d36e2f16ef0aa9a785cfca512c.jpg",
        "https://i.pinimg.com/736x/8a/3b/19/8a3b1922c091bc883e42911b33201a44.jpg",
        "https://i.pinimg.com/736x/66/12/f4/6612f4882103e91d844c8227b998101a.jpg",
      ],
      description: "Durable vertical Venetian blinds designed for wide glass panels and office windows.",
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
            "Premium Window Blinds",
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
      price: "₹65 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/5b/44/e9/5b44e9dae9c3e2bb97f74c7dbb94b0d0.jpg",
        "https://i.pinimg.com/736x/31/20/fa/3120fa290881b22eefd092288111ee22.jpg",
        "https://i.pinimg.com/736x/88/21/bc/8821bc33400e99811802df910011ef93.jpg",
      ],
      description: "High-quality frosted film ensuring complete privacy while allowing soft daylight.",
    ),
    DecorProductItem(
      title: "Geometric Patterned Film",
      price: "₹85 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/7d/1a/06/7d1a067a9643d937a0914856fcdb7746.jpg",
        "https://i.pinimg.com/736x/11/44/88/114488992223bb33109a82209112a9ef.jpg",
        "https://i.pinimg.com/736x/99/aa/10/99aa102988172ee0102931bc7721e843.jpg",
      ],
      description: "Decorative geometric glass film bringing stylish aesthetics to office dividers.",
    ),
    DecorProductItem(
      title: "Solar Heat Control Sun Film",
      price: "₹95 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/32/38/2b/32382b6bdff36f78a9bb2c1b9759c5d1.jpg",
        "https://i.pinimg.com/736x/22/01/55/220155a88019fe8227e2219934bb012a.jpg",
        "https://i.pinimg.com/736x/67/00/31/670031a908819d44320b9218d99801ec.jpg",
      ],
      description: "UV blocking reflective solar control film that reduces indoor heat and glare.",
    ),
    DecorProductItem(
      title: "Stained Glass Decorative Film",
      price: "₹120 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/c2/f3/e6/c2f3e69f826359eb36be98b7eec97fbf.jpg",
        "https://i.pinimg.com/736x/44/55/66/445566778899112233445566778899aa.jpg",
        "https://i.pinimg.com/736x/88/99/00/889900112233445566778899001122bb.jpg",
      ],
      description: "Vibrant stained glass effect film designed for artistic feature partition displays.",
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
            "Decorative & Safety Glass Films",
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
      price: "₹55 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/88/29/73/882973809623eeb4a9ed517b6d19a27f.jpg",
        "https://i.pinimg.com/736x/12/89/34/128934567890abcd1234567890abcdef.jpg",
        "https://i.pinimg.com/736x/23/90/45/239045678901bcde2345678901bcdefa.jpg",
      ],
      description: "Ultra-soft 35mm natural look artificial grass ideal for balcony gardens.",
    ),
    DecorProductItem(
      title: "High-Density Landscape Turf",
      price: "₹75 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/da/be/1a/dabe1a5332f913d6a69ef4c1c9117cf4.jpg",
        "https://i.pinimg.com/736x/34/01/56/340156789012cdef3456789012cdefab.jpg",
        "https://i.pinimg.com/736x/45/12/67/451267890123defa4567890123defabc.jpg",
      ],
      description: "Durable UV-resistant grass providing vibrant green lawn coverage without watering.",
    ),
    DecorProductItem(
      title: "Sports & Play Area Turf",
      price: "₹90 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/34/7c/43/347c43df3531b4baefaa326eebffec1a.jpg",
        "https://i.pinimg.com/736x/56/23/78/562378901234efab5678901234efabcd.jpg",
        "https://i.pinimg.com/736x/67/34/89/673489012345fabc6789012345fabcde.jpg",
      ],
      description: "Heavy-duty artificial turf engineered for high-traffic playgrounds and sports courts.",
    ),
    DecorProductItem(
      title: "Vertical Green Wall Plant Panel",
      price: "₹130 / sq.ft.",
      imageUrls: [
        "https://i.pinimg.com/736x/32/da/df/32dadfa0f8c057edcbb2f45814e55e8c.jpg",
        "https://i.pinimg.com/736x/78/45/90/784590123456abcd7890123456abcdef.jpg",
        "https://i.pinimg.com/736x/89/56/01/895601234567bcde8901234567bcdefa.jpg",
      ],
      description: "Synthetic green foliage panel perfect for accent feature walls and patio backdrops.",
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
            "Premium Artificial Turfs",
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