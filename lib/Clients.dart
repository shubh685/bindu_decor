import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'Home_Page.dart';
import 'Nav_Widgets/Navigation.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final List<NavItem> _navItems = const [
    NavItem(label: "Home", route: AppRoutes.home, icon: Icons.home_rounded),
    NavItem(label: "About", route: AppRoutes.about, icon: CupertinoIcons.info_circle),
    NavItem(label: "Clients", route: AppRoutes.clients, icon: CupertinoIcons.person_alt_circle_fill),
    NavItem(label: "Shop", route: AppRoutes.shop, icon: CupertinoIcons.cart_fill),
    NavItem(label: "Reviews", icon: Icons.rate_review_rounded, route:"https://www.google.com/maps/place/Bindu+Decorators/@19.2351656,72.8487463,17z/data=!3m1!5s0x3be7b0d85f0d5563:0xbcc67135cad97d47!4m12!1m2!2m1!1sB-2+Mandpeshwar+Ind+premises+Opp+MCF+Gymkhana+Road+Borivali+west+mumbai-400092!3m8!1s0x3be7b11fee8a918b:0xedf1f8374494f993!8m2!3d19.2351656!4d72.8532524!9m1!1b1!15sCk5CLTIgTWFuZHBlc2h3YXIgSW5kIHByZW1pc2VzIE9wcCBNQ0YgR3lta2hhbmEgUm9hZCBCb3JpdmFsaSB3ZXN0IG11bWJhaS00MDAwOTJaUCJOYiAyIG1hbmRwZXNod2FyIGluZCBwcmVtaXNlcyBvcHAgbWNmIGd5bWtoYW5hIHJvYWQgYm9yaXZhbGkgd2VzdCBtdW1iYWkgNDAwMDkykgEPd2FsbHBhcGVyX3N0b3Jl4AEA!16s%2Fg%2F1v_slq8m?entry=ttu&g_ep=EgoyMDI2MDgwNS4xIKXMDSoASAFQAw%3D%3D"),
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
      backgroundColor: const Color(0xFFFAFAF8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F382C).withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: BinduNavigationBar(
            navItems: _navItems,
            shopItems: _shopItems,
            onMenuItemTap: () => context.navigateTo,
          ),
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
          slivers: [
            SliverToBoxAdapter(
              child: _ClientLogoList(context: context),
            ),
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BinduFooter(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ClientItems {
  final String imgUrl;
  const ClientItems({required this.imgUrl});
}

class _ClientLogoList extends StatefulWidget {
  final BuildContext context;
  const _ClientLogoList({required this.context});

  @override
  State<_ClientLogoList> createState() => _ClientLogoListState();
}

class _ClientLogoListState extends State<_ClientLogoList>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<Offset> _topToBottomTextAnim;
  bool _headerAnimated = false;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _topToBottomTextAnim = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 4;
    } else if (screenWidth >= 768) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    final List<ClientItems> teamMembers = const [
      ClientItems(imgUrl: "assets/client_logos/img1.png"),
      ClientItems(imgUrl: "assets/client_logos/img2.png"),
      ClientItems(imgUrl: "assets/client_logos/img3.png"),
      ClientItems(imgUrl: "assets/client_logos/img4.png"),
      ClientItems(imgUrl: "assets/client_logos/img5.png"),
      ClientItems(imgUrl: "assets/client_logos/img6.png"),
      ClientItems(imgUrl: "assets/client_logos/img7.png"),
      ClientItems(imgUrl: "assets/client_logos/img8.png"),
      ClientItems(imgUrl: "assets/client_logos/img9.png"),
      ClientItems(imgUrl: "assets/client_logos/img10.png"),
      ClientItems(imgUrl: "assets/client_logos/img11.png"),
      ClientItems(imgUrl: "assets/client_logos/img12.png"),
      ClientItems(imgUrl: "assets/client_logos/img13.png"),
      ClientItems(imgUrl: "assets/client_logos/img14.png"),
      ClientItems(imgUrl: "assets/client_logos/img15.png"),
      ClientItems(imgUrl: "assets/client_logos/img16.png"),
      ClientItems(imgUrl: "assets/client_logos/img17.png"),
      ClientItems(imgUrl: "assets/client_logos/img18.png"),
      ClientItems(imgUrl: "assets/client_logos/img19.png"),
      ClientItems(imgUrl: "assets/client_logos/img20.png"),
      ClientItems(imgUrl: "assets/client_logos/img21.png"),
      ClientItems(imgUrl: "assets/client_logos/img22.png"),
      ClientItems(imgUrl: "assets/client_logos/img23.png"),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VisibilityDetector(
            key: const Key('header_visibility_key'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.1 && !_headerAnimated) {
                _headerAnimated = true;
                _headerController.forward();
              }
            },
            child: Column(
              children: [
                SlideTransition(
                  position: _topToBottomTextAnim,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F382C).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFF0F382C).withOpacity(0.15)),
                    ),
                    child: Text("TRUSTED BY INDUSTRY LEADERS", style: GoogleFonts.cormorantGaramond(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.5, color: const Color(0xFF0F382C))),
                 ),
                ),
                const SizedBox(height: 14),

                SlideTransition(
                  position: _topToBottomTextAnim,
                  child: Text("Our Esteemed Clients", textAlign: TextAlign.center,
                      style: GoogleFonts.cormorantGaramond(fontSize: screenWidth >= 900 ? 42 : 30, fontWeight: FontWeight.bold, color: const Color(0xFF0F382C), letterSpacing: 0.5)),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 2,
                      width: 24,
                      color: const Color(0xFFD4AF37).withOpacity(0.4),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 4,
                      width: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFF8C6D23)]),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: 24,
                      color: const Color(0xFFD4AF37).withOpacity(0.4),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                SlideTransition(
                  position: _topToBottomTextAnim,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "Proudly serving corporate offices, luxury residences, and commercial venues across India.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 16,
                        color: const Color(0xFF4A5568))),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 44),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth >= 1200
                  ? 80.0
                  : (screenWidth >= 768 ? 36.0 : 16.0),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: teamMembers.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: screenWidth >= 768 ? 24 : 14,
                mainAxisSpacing: screenWidth >= 768 ? 24 : 14,
                childAspectRatio: 2.1,
              ),
              itemBuilder: (context, index) {
                return _AnimatedClientCard(
                  key: ValueKey("client_card_$index"),
                  imgUrl: teamMembers[index].imgUrl,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedClientCard extends StatefulWidget {
  final String imgUrl;
  final int index;
  const _AnimatedClientCard({super.key, required this.imgUrl, required this.index});

  @override
  State<_AnimatedClientCard> createState() => _AnimatedClientCardState();
}

class _AnimatedClientCardState extends State<_AnimatedClientCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _cardController;
  late Animation<Offset> _leftToRightImageAnim;
  bool isHovered = false;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _leftToRightImageAnim = Tween<Offset>(
      begin: const Offset(-0.8, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('client_card_visibility_${widget.index}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_hasAnimated) {
          _hasAnimated = true;
          _cardController.forward();
        }
      },
      child: SlideTransition(
        position: _leftToRightImageAnim,
        child: MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            transform: isHovered
                ? (Matrix4.identity()..translate(0, -6, 0))
                : Matrix4.identity(),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isHovered ? const Color(0xFFD4AF37) : const Color(0xFF0F382C).withOpacity(0.12),
                width: isHovered ? 2.0 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isHovered
                      ? const Color(0xFF0F382C).withOpacity(0.12)
                      : const Color(0xFF0F382C).withOpacity(0.04),
                  blurRadius: isHovered ? 20 : 10,
                  offset: isHovered ? const Offset(0, 10) : const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: _buildDynamicImage(widget.imgUrl),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildDynamicImage(String imagePath) {
  if (imagePath.isEmpty) {
    return _imageFallback();
  }

  final bool isNetwork =
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  if (isNetwork) {
    return Image.network(
      imagePath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _imageFallback(),
    );
  }

  return Image.asset(
    imagePath,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) => _imageFallback(),
  );
}

Widget _imageFallback() {
  return Container(
    color: const Color(0xFFFAFAF8),
    child: const Center(
      child: Icon(Icons.business_rounded, size: 36, color: Color(0xFF0F382C)),
    ),
  );
}