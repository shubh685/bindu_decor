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

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: LuxuryTheme.bgCream,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: BinduNavigationBar(
          navItems: _navItems,
          shopItems: _shopItems,
          onMenuItemTap: () => context.navigateTo,
        ),
      ),
      drawer: isDesktop
          ? null
          : BinduMobileDrawer(
        navItems: _navItems,
        shopItems: _shopItems,
        onItemTap: () => context.navigateTo,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const MainImageCarousel(),
                  _subTitle(context),
                  const ExploreByCategorySection(),
                  const OurDetails(),
                  const MoreInfo(),
                ],
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
// MAIN IMAGE CAROUSEL WIDGET
// ==========================================

class CarouselImageData {
  final String imagePath;
  final Color textColor;

  const CarouselImageData({
    required this.imagePath,
    required this.textColor,
  });
}

class MainImageCarousel extends StatefulWidget {
  const MainImageCarousel({super.key});

  @override
  State<MainImageCarousel> createState() => _MainImageCarouselState();
}

class _MainImageCarouselState extends State<MainImageCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  final List<CarouselImageData> _slides = const [
    CarouselImageData(
      imagePath: "assets/images/main_img.png",
      textColor: Colors.white,
    ),
    CarouselImageData(
      imagePath: "assets/images/main_img2.png",
      textColor: Color(0xFFF4EAD4), // Elegant Warm Ivory
    ),
    CarouselImageData(
      imagePath: "assets/images/main_img3.png",
      textColor: Color(0xFFE6C687), // Muted Gold Accent
    ),
    CarouselImageData(
      imagePath: "assets/images/main_img4.png",
      textColor: Color(0xFFFFF8E7), // Soft Champagne
    ),
    CarouselImageData(
      imagePath: "assets/images/main_img5.png",
      textColor: Color(0xFFD4AF37), // Signature Gold
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentIndex + 1;
        if (nextPage >= _slides.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    double imageHeight;
    double buttonBottomPadding;
    double buttonFontSize;
    double buttonHorizontalPadding;

    if (screenWidth >= 1200) {
      imageHeight = 540;
      buttonBottomPadding = 60;
      buttonFontSize = 14;
      buttonHorizontalPadding = 32;
    } else if (screenWidth >= 600) {
      imageHeight = 420;
      buttonBottomPadding = 45;
      buttonFontSize = 13;
      buttonHorizontalPadding = 24;
    } else {
      imageHeight = 320;
      buttonBottomPadding = 30;
      buttonFontSize = 12;
      buttonHorizontalPadding = 20;
    }

    return SizedBox(
      width: double.infinity,
      height: imageHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background PageView Image Carousel
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                _slides[index].imagePath,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: LuxuryTheme.primaryDark,
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.white54, size: 50),
                  ),
                ),
              );
            },
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.15),
                  LuxuryTheme.primaryDark.withOpacity(0.4),
                  LuxuryTheme.primaryDark.withOpacity(0.85),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
          // Content Overlay
          Positioned(
            left: 24,
            right: 24,
            bottom: buttonBottomPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    "Transforming Living Spaces Into Masterpieces",
                    key: ValueKey<int>(_currentIndex),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: screenWidth >= 900
                          ? 46
                          : (screenWidth >= 600 ? 34 : 24),
                      fontWeight: FontWeight.w700,
                      color: _slides[_currentIndex].textColor,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Wallpapers()),
                    ),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonHorizontalPadding,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD4AF37), Color(0xFFC5A059)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFC5A059).withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "EXPLORE COLLECTION",
                            style: GoogleFonts.cinzel(
                              fontWeight: FontWeight.w700,
                              fontSize: buttonFontSize,
                              color: LuxuryTheme.primaryDark,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: LuxuryTheme.primaryDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (index) {
                    final bool isActive = _currentIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      height: 6,
                      width: isActive ? 24 : 6,
                      decoration: BoxDecoration(
                        color: isActive ? LuxuryTheme.primaryAccent : Colors.white38,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// SUBTITLE WIDGET
// ==========================================

Widget _subTitle(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;

  final double fontSize = screenWidth >= 900 ? 24 : (screenWidth >= 600 ? 19 : 16);
  final double horizontalPadding = screenWidth >= 900 ? 140 : (screenWidth >= 600 ? 40 : 20);

  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [LuxuryTheme.primaryDark, Color(0xFF14372E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: 36,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "\"The spaces have been waiting in silence. One thoughtful detail, and suddenly the whole room remembers how to feel like home.\"",
          textAlign: TextAlign.center,
          style: GoogleFonts.cormorantGaramond(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
            color: const Color(0xFFFBF9F5),
            height: 1.5,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 1,
                width: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, LuxuryTheme.primaryAccent.withOpacity(0.8)],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.star_outline_rounded, color: LuxuryTheme.primaryAccent, size: 20),
              ),
              Container(
                height: 1,
                width: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [LuxuryTheme.primaryAccent.withOpacity(0.8), Colors.transparent],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ==========================================
// EXPLORE BY CATEGORY SECTION
// ==========================================

class CategoryItem {
  final String title;
  final String imageUrl;
  final String route;
  final Color badgeColor;

  const CategoryItem({
    required this.title,
    required this.imageUrl,
    this.route = AppRoutes.shop,
    required this.badgeColor,
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
    CategoryItem(title: "Wallpapers", imageUrl: "assets/images/wallpapers.png", route: AppRoutes.wallpapers, badgeColor: Color(0xFFC0392B)),
    CategoryItem(title: "Floorings", imageUrl: "assets/images/floorings.png", route: AppRoutes.floorings, badgeColor: Color(0xFFC0392B)),
    CategoryItem(title: "Carpets", imageUrl: "assets/images/carpets.png", route: AppRoutes.carpets, badgeColor: Color(0xFFC0392B)),
    CategoryItem(title: "Blinds", imageUrl: "assets/images/blinds.png", route: AppRoutes.blinds, badgeColor: Color(0xFFC0392B)),
    CategoryItem(title: "Glass Films", imageUrl: "assets/images/glass-films.png", route: AppRoutes.glassfilms, badgeColor: Color(0xFFC0392B)),
    CategoryItem(title: "Artificial Turfs", imageUrl: "assets/images/arti-turfs.png", route: AppRoutes.artificialturfs, badgeColor: Color(0xFFC0392B)),
    CategoryItem(title: "Gym Floorings", imageUrl: "assets/images/gym_floor.png", route: AppRoutes.gymfloorings, badgeColor: Color(0xFFC0392B)),
    CategoryItem(title: "Awnings", imageUrl: "assets/images/awnings.png", route: AppRoutes.awnings, badgeColor: Color(0xFFC0392B)),
    CategoryItem(title: "Mosquito Nets", imageUrl: "assets/images/mos_net.png", route: AppRoutes.mosquitoNets, badgeColor: Color(0xFFC0392B)),
    CategoryItem(title: "Upholstery", imageUrl: "assets/images/upholstery.png", route: AppRoutes.upholstery, badgeColor: Color(0xFFC0392B)),
    CategoryItem(title: "Curtains", imageUrl: "assets/images/curtains.png", route: AppRoutes.curtains, badgeColor: Color(0xFFC0392B)),
    CategoryItem(title: "Stretch Ceiling", imageUrl: "assets/images/str_ceil.png", route: AppRoutes.stretchCeiling, badgeColor: Color(0xFFC0392B)),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
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
          duration: const Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
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
        vertical: 48.0,
        horizontal: screenWidth >= 900 ? 40.0 : 18.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("EXPLORE COLLECTIONS", style: GoogleFonts.cormorantGaramond(fontSize: 13, fontWeight: FontWeight.w700, color: LuxuryTheme.primaryAccent, letterSpacing: 3.0)),
          const SizedBox(height: 6),
          Text("Bespoke Interior Elements", style: GoogleFonts.cormorantGaramond(fontSize: screenWidth >= 900 ? 38 : (screenWidth >= 600 ? 30 : 24), fontWeight: FontWeight.w700, color: LuxuryTheme.primaryDark)),
          const SizedBox(height: 12),
          Container(
            height: 2,
            width: 50,
            decoration: BoxDecoration(
              color: LuxuryTheme.primaryAccent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 36),
          SizedBox(
            height: screenWidth >= 900 ? 350 : (screenWidth >= 600 ? 330 : 310),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: _CategoryCard(item: category),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(totalPages, (pageIndex) {
              final bool isActive = _currentPage == pageIndex;

              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    pageIndex,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 6,
                  width: isActive ? 32 : 12,
                  decoration: BoxDecoration(
                    color: isActive ? LuxuryTheme.primaryAccent : LuxuryTheme.primaryDark.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
                        child: Icon(Icons.image_not_supported, color: LuxuryTheme.primaryDark, size: 40)),
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
                        LuxuryTheme.primaryDark.withOpacity(0.2),
                        LuxuryTheme.primaryDark.withOpacity(0.9),
                      ],
                      stops: const [0.3, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: item.badgeColor,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.badgeColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text("DESIGN", style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.5)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(item.title, style: GoogleFonts.cormorantGaramond(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5))),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// OUR DETAILS SECTION
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
      duration: const Duration(seconds: 2),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: LuxuryTheme.primaryAccent,
                ),
              );
            },
          ),
          const SizedBox(height: 2),
          Text(
            widget.item.subtitle.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cinzel(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 1.2,
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
    FeatureItem(targetValue: 40, suffix: "+", subtitle: "Years in industry"),
    FeatureItem(targetValue: 27000, suffix: "+", subtitle: "Completed Sites"),
    FeatureItem(targetValue: 800, suffix: "+", subtitle: "Satisfied Architects"),
    FeatureItem(targetValue: 20, suffix: "", subtitle: "Dedicated Experts"),
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
        decoration: const BoxDecoration(
          color: LuxuryTheme.primaryDark,
          border: Border(
            top: BorderSide(color: LuxuryTheme.primaryAccent, width: 1.5),
            bottom: BorderSide(color: LuxuryTheme.primaryAccent, width: 1.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(
              height: 75,
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
                              Container(
                                height: 40,
                                width: 1,
                                color: LuxuryTheme.primaryAccent.withOpacity(0.3),
                              ),
                          ],
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
            if (totalPages > 1) ...[
              const SizedBox(height: 16),
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
                      height: 6,
                      width: isActive ? 24 : 6,
                      decoration: BoxDecoration(
                        color: isActive ? LuxuryTheme.primaryAccent : Colors.white24,
                        borderRadius: BorderRadius.circular(3),
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
// MORE INFO SECTION
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
      duration: const Duration(milliseconds: 800),
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
          vertical: 56.0,
          horizontal: isDesktop ? 48.0 : 20.0,
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
      height: 500,
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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
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
          ),
          Positioned(
            left: 0,
            top: 35,
            bottom: 35,
            width: 560,
            child: SlideTransition(
              position: _leftCardSlide,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFE8E3D9)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ABOUT BINDU DÉCOR", style: GoogleFonts.cormorantGaramond(fontSize: 21, fontWeight: FontWeight.bold, color: LuxuryTheme.primaryAccent, letterSpacing: 2.5)),const SizedBox(height: 8),
                    Text(
                      "Interior Design introduces people to modernism, relaxation and beauty. Our team at Bindu Decor ensures a perfect blend of function and appearance. We have picked up a notoriety of being consistent with its promise and are pleased to state that the majority of our customers will bear declaration to our greatness in administration crosswise over India.",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        height: 1.7,
                        color: LuxuryTheme.textMuted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.about);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LuxuryTheme.primaryDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                        shadowColor: LuxuryTheme.primaryDark.withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("READ MORE", style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.5,)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 14),
                        ],
                      ),
                    ),
                  ],
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
            borderRadius: BorderRadius.circular(16),
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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: const Color(0xFFE8E3D9)),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ABOUT BINDU DÉCOR", style: GoogleFonts.cinzel(fontSize: 21, fontWeight: FontWeight.w700,
                  color: LuxuryTheme.primaryAccent, letterSpacing: 2.0,)),
                const SizedBox(height: 6),
                Text(
                    "Interior Design introduces people to modernism, relaxation and beauty. Our team at Bindu Decor ensures a perfect blend of function and appearance. We have picked up a notoriety of being consistent with its promise and are pleased to state that the majority of our customers will bear declaration to our greatness in administration crosswise over India.",
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13, height: 1.6, color: LuxuryTheme.textMuted)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.about);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LuxuryTheme.primaryDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text("READ MORE", style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.5)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}