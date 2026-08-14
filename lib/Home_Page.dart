import 'dart:async';
import 'package:bindu_decor/Nav_Widgets/Navigation.dart';
import 'package:bindu_decor/Wal_Flo_Car.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ==========================================
// NAVIGATION ROUTES
// ==========================================

class AppRoutes {
  static const String home = '/';
  static const String about = '/About';
  static const String clients = '/clients';
  static const String shop = '/shop';
  static const String reviews = '/reviews';
  static const String wallpapers = '/shop/wallpapers';
  static const String floorings = '/shop/floorings';
  static const String carpets = '/shop/carpets';
  static const String blinds = '/shop/blinds';
  static const String glassfilms = '/shop/glassfilms';
  static const String artificialturfs = '/shop/artificialturfs';
  static const String gymfloorings = '/shop/gymfloorings';
  static const String awnings = '/shop/awnings';
  static const String mosquitoNets = '/shop/mosquitoNets';
  static const String upholstery = '/shop/upholstery';
  static const String curtains = '/shop/curtains';
  static const String stretchCeiling = '/shop/stertchCeiling';
}

// ==========================================
// HOME PAGE
// ==========================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<NavItem> _navItems = const [
    NavItem(label: "Home", route: AppRoutes.home, icon: Icons.home),
    NavItem(label: "About", route: AppRoutes.about, icon: CupertinoIcons.info_circle),
    NavItem(label: "Clients", route: AppRoutes.clients, icon: CupertinoIcons.person_alt_circle),
    NavItem(label: "Shop", route: AppRoutes.shop, icon: CupertinoIcons.cart),
    NavItem(
      label: "Reviews",
      icon: Icons.reviews_outlined,
      route: "https://www.google.com/maps/place/Bindu+Decorators/@19.2351656,72.8487463,17z/data=!3m1!5s0x3be7b0d85f0d5563:0xbcc67135cad97d47!4m12!1m2!2m1!1sB-2+Mandpeshwar+Ind+premises+Opp+MCF+Gymkhana+Road+Borivali+west+mumbai-400092!3m8!1s0x3be7b11fee8a918b:0xedf1f8374494f993!8m2!3d19.2351656!4d72.8532524!9m1!1b1!15sCk5CLTIgTWFuZHBlc2h3YXIgSW5kIHByZW1pc2VzIE9wcCBNQ0YgR3lta2hhbmEgUm9hZCBCb3JpdmFsaSB3ZXN0IG11bWJhaS00MDAwOTJaUCJOYiAyIG1hbmRwZXNod2FyIGluZCBwcmVtaXNlcyBvcHAgbWNmIGd5bWtoYW5hIHJvYWQgYm9yaXZhbGkgd2VzdCBtdW1iYWkgNDAwMDkykgEPd2FsbHBhcGVyX3N0b3Jl4AEA!16s%2Fg%2F1v_slq8m?entry=ttu&g_ep=EgoyMDI2MDgwNS4xIKXMDSoASAFQAw%3D%3D",
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    _mainImage(context),
                    _subTitle(context),
                    const ExploreByCategorySection(),
                    const OurDetails(),
                    const MoreInfo(),
                  ],
                ),
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

// ==========================================
// MAIN IMAGE & SUBTITLE WIDGETS
// ==========================================

Widget _mainImage(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;

  double imageHeight;
  double buttonTopPadding;
  double buttonFontSize;
  double buttonPadding;

  if (screenWidth >= 1200) {
    imageHeight = 450;
    buttonTopPadding = 295;
    buttonFontSize = 20;
    buttonPadding = 14;
  } else if (screenWidth >= 600) {
    imageHeight = 350;
    buttonTopPadding = 250;
    buttonFontSize = 18;
    buttonPadding = 12;
  } else {
    imageHeight = 250;
    buttonTopPadding = 120;
    buttonFontSize = 16;
    buttonPadding = 10;
  }

  return SizedBox(
    width: double.infinity,
    height: imageHeight,
    child: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/main_img.png"),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
        Positioned(
          top: buttonTopPadding,
          left: 0,
          right: 0,
          child: Center(
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Wallpapers())),
              child: Container(
                padding: EdgeInsets.all(buttonPadding),
                decoration: BoxDecoration(
                  color: Colors.brown.shade800,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text("Explore Collection", style: GoogleFonts.arvo(fontWeight: FontWeight.w500, fontSize: buttonFontSize, color: Colors.white)),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _subTitle(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;

  final double fontSize = screenWidth >= 900 ? 22 : (screenWidth >= 600 ? 18 : 15);
  final double horizontalPadding = screenWidth >= 900 ? 120 : (screenWidth >= 600 ? 40 : 20);
  final double verticalPadding = screenWidth >= 900 ? 20 : 15;

  return Container(
    width: double.infinity,
    color: Colors.brown.shade800,
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "the spaces have been waiting in silence. one thoughtful detail, and \n suddenly the whole room remembers how to feel like home.",
          textAlign: TextAlign.center,
          style: GoogleFonts.arvo(
            fontSize: fontSize, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic, color: Colors.white, height: 1.6)),
        const SizedBox(height: 8),
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.white70,
                thickness: 0.8,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.local_florist, color: Colors.white, size: 28),
            ),
            Expanded(
              child: Divider(
                color: Colors.white70,
                thickness: 0.8,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// ==========================================
// EXPLORE BY CATEGORY SECTION
//
// ================
// ==========================

class CategoryItem {
  final String title;
  final String imageUrl;
  final String route;

  const CategoryItem({
    required this.title,
    required this.imageUrl,
    this.route = AppRoutes.shop,
  });
}

class ExploreByCategorySection extends StatefulWidget {
  const ExploreByCategorySection({super.key});

  @override
  State<ExploreByCategorySection> createState() => _ExploreByCategorySectionState();
}

class _ExploreByCategorySectionState extends State<ExploreByCategorySection> {
  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  final List<CategoryItem> _categories = const [
    CategoryItem(title: "Wallpapers", imageUrl: "assets/images/wallpapers.png", route: AppRoutes.wallpapers),
    CategoryItem(title: "Floorings", imageUrl: "assets/images/floorings.png", route: AppRoutes.floorings),
    CategoryItem(title: "Carpets", imageUrl: "assets/images/carpets.png", route: AppRoutes.carpets),
    CategoryItem(title: "Blinds", imageUrl: "assets/images/blinds.png", route: AppRoutes.blinds),
    CategoryItem(title: "Glass Films", imageUrl: "assets/images/glass-films.png", route: AppRoutes.glassfilms),
    CategoryItem(title: "Artificial Turfs", imageUrl: "assets/images/arti-turfs.png", route: AppRoutes.artificialturfs),
    CategoryItem(title: "Gym Floorings", imageUrl: "assets/images/gym_floor.png", route: AppRoutes.gymfloorings),
    CategoryItem(title: "Awnings", imageUrl: "assets/images/awnings.png", route: AppRoutes.awnings),
    CategoryItem(title: "Mosquito Nets", imageUrl: "assets/images/mos_net.png", route: AppRoutes.mosquitoNets),
    CategoryItem(title: "Upholstery", imageUrl: "assets/images/upholstery.png", route: AppRoutes.upholstery),
    CategoryItem(title: "Curtains", imageUrl: "assets/images/curtains.png", route: AppRoutes.curtains),
    CategoryItem(title: "Stretch Ceiling", imageUrl: "assets/images/str_ceil.png", route: AppRoutes.stretchCeiling),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final double width = MediaQuery.of(context).size.width;
        final int itemsPerPage = _getItemsPerPage(width);
        final int totalPages = (_categories.length / itemsPerPage).ceil();

        int nextPage = _currentPage + 1;
        if (nextPage >= totalPages) {
          nextPage = 0;
        }

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  int _getItemsPerPage(double width) {
    if (width >= 1100) return 4;
    if (width >= 700) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int itemsPerPage = _getItemsPerPage(screenWidth);
    final int totalPages = (_categories.length / itemsPerPage).ceil();

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 36.0,
        horizontal: screenWidth >= 900 ? 32.0 : 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Explore by Category", style: GoogleFonts.arvo(fontSize: screenWidth >= 900 ? 32 : (screenWidth >= 600 ? 26 : 22), fontWeight: FontWeight.bold, color: Colors.brown.shade800, letterSpacing: 0.8)),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFC89D52),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: screenWidth >= 900 ? 320 : (screenWidth >= 600 ? 300 : 280),
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalPages,
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, pageIndex) {
                final int startIndex = pageIndex * itemsPerPage;
                final int endIndex = (startIndex + itemsPerPage < _categories.length)
                    ? startIndex + itemsPerPage
                    : _categories.length;
                final List<CategoryItem> pageItems = _categories.sublist(startIndex, endIndex);

                return Row(
                  children: pageItems.map((category) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _CategoryCard(item: category),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(_categories.length, (itemIndex) {
              final int activeGroupStart = _currentPage * itemsPerPage;
              final int activeGroupEnd = activeGroupStart + itemsPerPage;
              final bool isActive = itemIndex >= activeGroupStart && itemIndex < activeGroupEnd;

              return GestureDetector(
                onTap: () {
                  final int targetPage = itemIndex ~/ itemsPerPage;
                  _pageController.animateToPage(
                    targetPage,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 10,
                  width: isActive ? 24 : 10,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF3B9A82) : const Color(0xFF3B9A82).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryItem item;

  const _CategoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: const Color(0xFF3B9A82).withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, item.route);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFEBF5F2),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Color(0xFF3B9A82),
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 16,
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.cabin(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(
                      color: Colors.black45,
                      offset: Offset(0, 1),
                      blurRadius: 4,
                    )
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

// ==========================================
// OUR DETAILS SECTION (With Scroll Animation Trigger)
// ==========================================

class FeatureItem {
  final int targetValue;
  final String suffix;
  final String subtitle;

  const FeatureItem({
    required this.targetValue,
    required this.suffix,
    required this.subtitle,
  });
}

class AnimatedHighlightTile extends StatefulWidget {
  final FeatureItem item;
  final bool startAnimation;

  const AnimatedHighlightTile({
    super.key,
    required this.item,
    required this.startAnimation,
  });

  @override
  State<AnimatedHighlightTile> createState() => _AnimatedHighlightTileState();
}

class _AnimatedHighlightTileState extends State<AnimatedHighlightTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _numberAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Normalized to standard 2 seconds
      vsync: this,
    );

    _numberAnimation = IntTween(
      begin: 0,
      end: widget.item.targetValue,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.startAnimation) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedHighlightTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startAnimation && !_controller.isAnimating && !_controller.isCompleted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _numberAnimation,
            builder: (context, child) {
              return Text(
                "${_formatNumber(_numberAnimation.value)}${widget.item.suffix}",
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cabin(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            widget.item.subtitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cabin(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class OurDetails extends StatefulWidget {
  const OurDetails({super.key});

  @override
  State<OurDetails> createState() => _OurDetailsState();
}

class _OurDetailsState extends State<OurDetails> {
  late final PageController _page;
  Timer? timer;
  int _curPage = 0;
  bool _isVisible = false;

  final List<FeatureItem> highlights = const [
    FeatureItem(targetValue: 40, suffix: "+", subtitle: "Years in the industry"),
    FeatureItem(targetValue: 27000, suffix: "+", subtitle: "Sites"),
    FeatureItem(targetValue: 800, suffix: "+", subtitle: "Satisfied Architectures"),
    FeatureItem(targetValue: 20, suffix: "", subtitle: "Professional & Dedicated Team"),
  ];

  int _getItemsPerPage(double width) {
    if (width >= 1100) return 4;
    if (width >= 700) return 2;
    return 1;
  }

  void _startAutoPlay() {
    timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_page.hasClients) {
        final double width = MediaQuery.of(context).size.width;
        final int itemsPerPage = _getItemsPerPage(width);
        final int totalPages = (highlights.length / itemsPerPage).ceil();

        if (totalPages <= 1) return;

        int nextPage = _curPage + 1;
        if (nextPage >= totalPages) {
          nextPage = 0;
        }

        _page.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _page = PageController();
    _startAutoPlay();
  }

  @override
  void dispose() {
    timer?.cancel();
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int itemsPerPage = _getItemsPerPage(screenWidth);
    final int totalPages = (highlights.length / itemsPerPage).ceil();

    return VisibilityDetector(
      key: const Key('our_details_visibility'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Container(
        width: double.infinity,
        color: Colors.brown.shade800,
        padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(
              height: 65,
              child: PageView.builder(
                controller: _page,
                itemCount: totalPages,
                onPageChanged: (int index) {
                  setState(() {
                    _curPage = index;
                  });
                },
                itemBuilder: (context, pageIndex) {
                  final int startIndex = pageIndex * itemsPerPage;
                  final int endIndex = (startIndex + itemsPerPage < highlights.length)
                      ? startIndex + itemsPerPage
                      : highlights.length;
                  final List<FeatureItem> pageItems = highlights.sublist(startIndex, endIndex);

                  return Row(
                    children: List.generate(pageItems.length, (index) {
                      final item = pageItems[index];
                      final bool isLastInRow = index == pageItems.length - 1;

                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: AnimatedHighlightTile(
                                key: ValueKey(item.subtitle),
                                item: item,
                                startAnimation: _isVisible,
                              ),
                            ),
                            if (!isLastInRow && itemsPerPage > 1)
                              Container(height: 60, width: 1, color: Colors.white30),
                          ],
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
            if (totalPages > 1) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalPages, (index) {
                  final bool isActive = _curPage == index;
                  return GestureDetector(
                    onTap: () {
                      _page.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      height: 8,
                      width: isActive ? 24 : 8,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFE91E63) : Colors.white38,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ==========================================
// MORE INFO SECTION (Scroll Animation Triggered)
// ==========================================

class MoreInfo extends StatefulWidget {
  const MoreInfo({super.key});

  @override
  State<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _leftCardSlide;
  late Animation<Offset> _rightImageSlide;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Standard smooth duration
    );

    _leftCardSlide = Tween<Offset>(
      begin: const Offset(-0.8, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _rightImageSlide = Tween<Offset>(
      begin: const Offset(0.8, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 900;

    return VisibilityDetector(
      key: const Key('more_info_visibility'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.25 && !_hasAnimated) {
          _hasAnimated = true;
          _animController.forward();
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 48.0,
          horizontal: isDesktop ? 48.0 : 16.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SizedBox(
      height: 480,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 680,
            child: SlideTransition(
              position: _rightImageSlide,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.asset(
                  "assets/images/about-show.png",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFE2E8E6),
                    child: const Center(
                      child: Icon(Icons.image, size: 60, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 30,
            bottom: 30,
            width: 560,
            child: SlideTransition(
              position: _leftCardSlide,
              child: Material(
                elevation: 10,
                shadowColor: Colors.black.withOpacity(0.18),
                borderRadius: BorderRadius.circular(2),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 44.0, vertical: 36.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("About Us", style: GoogleFonts.arvo(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.brown.shade800, letterSpacing: -0.5)),
                      const SizedBox(height: 20),
                      Text(
                        "Interior Design introduces people to modernism, relaxation and beauty. Our team at Bindu Decor ensures a perfect blend of function and appearance. We have picked up a notoriety of being consistent with its promise and are pleased to state that the majority of our customers will bear declaration to our greatness in administration crosswise over India.",
                        style: GoogleFonts.arvo(
                          fontSize: 15,
                          height: 1.6,
                          color: const Color(0xFF4A4A4A),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.about);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown.shade800,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          elevation: 0,
                        ),
                        child: Text("Read More", style: GoogleFonts.arvo(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideTransition(
          position: _rightImageSlide,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                "assets/images/about-show.png",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFE2E8E6),
                  child: const Center(
                    child: Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SlideTransition(
          position: _leftCardSlide,
          child: Material(
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.12),
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About Us", style: GoogleFonts.arvo(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 16),
                  Text(
                    "Interior Design introduces people to modernism, relaxation and beauty. Our team at Bindu Decor ensures a perfect blend of function and appearance. We have picked up a notoriety of being consistent with its promise and are pleased to state that the majority of our customers will bear declaration to our greatness in administration crosswise over India.",
                    style: GoogleFonts.arvo(
                      fontSize: 14,
                      height: 1.5,
                      color: const Color(0xFF4A4A4A),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.about);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: Text(
                      "Read More",
                      style: GoogleFonts.cabin(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}