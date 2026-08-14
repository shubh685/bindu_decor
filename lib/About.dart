import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:bindu_decor/Nav_Widgets/Navigation.dart';
import 'Home_Page.dart';

// Enable drag scrolling with desktop mice and trackpads for web/desktop
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class TimelineEvent {
  final String year;
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  const TimelineEvent({
    required this.year,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
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
                    const TimelineView(),
                    const SizedBox(height: 32),
                    const MissionVisionAnimatedSection(),
                    const SizedBox(height: 32),
                    const MeetTeamAnimatedSection(),
                    const SizedBox(height: 32),
                    _lastLeast(context)
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
// TIMELINE SECTION
// ==========================================

class TimelineView extends StatefulWidget {
  const TimelineView({super.key});

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  late final ScrollController _scrollController;
  Timer? _autoScrollTimer;
  bool _isUserInteracting = false;

  final List<TimelineEvent> events = const [
    TimelineEvent(
      year: '1984',
      title: 'Phase 01',
      description:
      'Started our business with the distributorship of Bhor Ind Ltd. (Manufacturers of P.V.C flooring and wallpapers).',
      icon: Icons.event,
      gradient: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
    ),
    TimelineEvent(
      year: '1988',
      title: 'Phase 02',
      description: 'We were the distributor of Sintex water tanks.',
      icon: Icons.event,
      gradient: [Color(0xFFF7971E), Color(0xFFFFD200)],
    ),
    TimelineEvent(
      year: '1989',
      title: 'Phase 03',
      description:
      'We were also the distributors of Armstrong World Industries (U.K) for their flooring tiles.',
      icon: Icons.event,
      gradient: [Color(0xFFFF512F), Color(0xFFF09819)],
    ),
    TimelineEvent(
      year: '2000',
      title: 'Phase 04',
      description:
      'We became the channel partners of Grass Impex (Llumar films-USA based manufacturers of decorative and sun control films).',
      icon: Icons.event,
      gradient: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    ),
    TimelineEvent(
      year: '2018',
      title: 'Phase 05',
      description: 'We became the channel partners of Ddecor.',
      icon: Icons.event,
      gradient: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    ),
    TimelineEvent(
      year: '2021',
      title: 'Phase 06',
      description:
      'We introduced exclusive furnishings catering to drapes and upholstery.',
      icon: Icons.event,
      gradient: [Color(0xFF276B5A), Color(0xFF3B9A82)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!_isUserInteracting && _scrollController.hasClients) {
        final double maxScroll = _scrollController.position.maxScrollExtent;
        final double currentScroll = _scrollController.offset;

        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(currentScroll + 1.0);
        }
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 700;
    final double itemWidth = isMobile ? 260 : 320;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Timeline", style: GoogleFonts.arvo(fontSize: isMobile ? 28 : 36, fontWeight: FontWeight.bold, color: Colors.purple, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        Container(
          height: 3,
          width: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFC89D52),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: isMobile ? 320 : 310,
          child: Listener(
            onPointerDown: (_) => setState(() => _isUserInteracting = true),
            onPointerUp: (_) => setState(() => _isUserInteracting = false),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final isFirst = index == 0;
                final isLast = index == events.length - 1;

                return SizedBox(
                  width: itemWidth,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: isMobile ? 80 : 90,
                        left: isFirst ? itemWidth / 2 : 0,
                        right: isLast ? itemWidth / 2 : 0,
                        child: Container(
                          height: 3,
                          color: const Color(0xFF276B5A).withOpacity(0.3),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Container(
                            width: isMobile ? 90 : 110,
                            height: isMobile ? 60 : 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                colors: event.gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: event.gradient.first.withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Icon(event.icon, color: Colors.white, size: isMobile ? 28 : 35),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC89D52).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(event.year, style: GoogleFonts.arvo(fontSize: 14, fontWeight: FontWeight.bold))),
                          const SizedBox(height: 6),
                          Text(event.title, style: GoogleFonts.arvo(fontSize: isMobile ? 18 : 22, fontWeight: FontWeight.bold, color: Colors.purple)),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(event.description, textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: GoogleFonts.arvo(fontSize: isMobile ? 12 : 14, color:Colors.purple.shade800, height: 1.4)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// MISSION & VISION (SCROLL ANIMATED)
// ==========================================

class MissionVisionAnimatedSection extends StatefulWidget {
  const MissionVisionAnimatedSection({super.key});

  @override
  State<MissionVisionAnimatedSection> createState() =>
      _MissionVisionAnimatedSectionState();
}

class _MissionVisionAnimatedSectionState extends State<MissionVisionAnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    // Our Mission: Slides in from Left (-1.0 to 0.0)
    _leftSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    // Our Vision: Slides in from Right (1.0 to 0.0)
    _rightSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 900;

    final Widget missionCard = SlideTransition(
      position: _leftSlideAnimation,
      child: _buildMiViCard(
        title: "Our Mission",
        description:
        "Interior Design introduces people to modernism, relaxation and beauty. Our team at Bindu Decor ensures a perfect blend of function and appearance. We have picked up a notoriety of being consistent with its promise and are pleased to state that the majority of our customers will bear declaration to our greatness in administration crosswise over India.",
      ),
    );

    final Widget visionCard = SlideTransition(
      position: _rightSlideAnimation,
      child: _buildMiViCard(
        title: "Our Vision",
        description:
        "Our vision is to be at your service, at your doorstep, at your Convenience.",
      ),
    );

    return VisibilityDetector(
      key: const Key('mission_vision_visibility_key'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_hasAnimated) {
          _hasAnimated = true;
          _controller.forward();
        }
      },
      child: isDesktop
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: missionCard),
              Expanded(child: visionCard),
            ],
          ),
        ),
      )
          : SizedBox(
        height: 310,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            SizedBox(width: screenWidth * 0.82, child: missionCard),
            const SizedBox(width: 16),
            SizedBox(width: screenWidth * 0.82, child: visionCard),
          ],
        ),
      ),
    );
  }

  Widget _buildMiViCard({required String title, required String description}) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF276B5A), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.arvo(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.purple)),
          const SizedBox(height: 10),
          Text(description, style: GoogleFonts.cabin(fontSize: 13.5, fontWeight: FontWeight.w400, height: 1.5)),
        ],
      ),
    );
  }
}

// ==========================================
// MEET TEAM (SCROLL ANIMATED)
// ==========================================

class TeamMember {
  final String name;
  final String role;
  final String imageUrl;
  final String desc;

  const TeamMember({
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.desc,
  });
}

class MeetTeamAnimatedSection extends StatefulWidget {
  const MeetTeamAnimatedSection({super.key});

  @override
  State<MeetTeamAnimatedSection> createState() =>
      _MeetTeamAnimatedSectionState();
}

class _MeetTeamAnimatedSectionState extends State<MeetTeamAnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;
  bool _hasAnimated = false;

  final List<TeamMember> teamMembers = const [
    TeamMember(
      name: "Rajesh Chitalia",
      role: "Founder & Partner",
      imageUrl: "assets/images/rajesh_chit.png",
      desc:
      "An enthusiast, visionary, and a strong believer of the ‘Givers gain’ policy, Rajesh Chitalia is the founder and Partner of Bindu Decorators. With over 38 years of experience in the décor industry, he has the required know-hows to convert the architects concept to reality.",
    ),
    TeamMember(
      name: "Dinesh Chitalia",
      role: "Partner",
      imageUrl: "assets/images/dinesh_chit.png",
      desc:
      "Equipped with the technical know hows and a keen eye for details , Dinesh Chitalia – Partner of Bindu Decorators ensures a perfect balance of functional aspects and design.",
    ),
    TeamMember(
      name: "Venisha Chitalia",
      role: "Partner",
      imageUrl: "assets/images/venisha_chit.png",
      desc:
      "After working for a while in the corporate industry, Venisha Chitalia – an MBA-TECH (Marketing – IT) – NMIMS, has entered the family business with a vision of bringing in fresh insights and perspective thereby ensuring customer satisfaction.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    // Left direction animation for Rajesh Chitalia & Dinesh Chitalia
    _leftSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    // Right direction animation for Venisha Chitalia
    _rightSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 900;

    final List<Widget> cards = [
      // Rajesh Chitalia Card - Left Direction
      SlideTransition(
        position: _leftSlideAnimation,
        child: _teamCard(
          tit: teamMembers[0].name,
          role: teamMembers[0].role,
          desc: teamMembers[0].desc,
          imageUrl: teamMembers[0].imageUrl,
        ),
      ),
      // Dinesh Chitalia Card - Left Direction
      SlideTransition(
        position: _leftSlideAnimation,
        child: _teamCard(
          tit: teamMembers[1].name,
          role: teamMembers[1].role,
          desc: teamMembers[1].desc,
          imageUrl: teamMembers[1].imageUrl,
        ),
      ),
      // Venisha Chitalia Card - Right Direction
      SlideTransition(
        position: _rightSlideAnimation,
        child: _teamCard(
          tit: teamMembers[2].name,
          role: teamMembers[2].role,
          desc: teamMembers[2].desc,
          imageUrl: teamMembers[2].imageUrl,
        ),
      ),
    ];

    return VisibilityDetector(
      key: const Key('meet_team_visibility_key'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_hasAnimated) {
          _hasAnimated = true;
          _controller.forward();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Meet Our Team", style: GoogleFonts.imFellEnglishSc(fontSize: isDesktop ? 32 : 26, fontWeight: FontWeight.bold, color: Colors.purple)),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFC89D52),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: cards.map((card) => Expanded(child: card)).toList(),
                ),
              ),
            )
          else
            SizedBox(
              height: 420, // Slightly increased height to account for bottom stacked reflection
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cards.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: screenWidth * 0.70,
                    child: cards[index],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _teamCard({
    required String tit,
    required String role,
    required String imageUrl,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 3rd Bottom Reflection Layer (Lowest)
          Positioned(
            bottom: 0,
            left: 24,
            right: 24,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFE2ECFA).withOpacity(0.4),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
            ),
          ),
          // 2nd Bottom Reflection Layer (Middle Stack)
          Positioned(
            bottom: 8,
            left: 12,
            right: 12,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF4FC).withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
            ),
          ),
          // Main Foreground Card
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF276B5A).withOpacity(0.12),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF276B5A).withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tit,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.imFellEnglishSc(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(role, textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis, style: GoogleFonts.imFellEnglishSc(fontSize: 14.5, fontWeight: FontWeight.w500, color: const Color(0xFF4A4A4A), height: 1.4)),
                  const SizedBox(height: 10),
                  Text(
                    "\"$desc\"",
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.imFellEnglishSc(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF4A4A4A),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Universal image provider helper
Widget _buildDynamicImage(String imagePath) {
  if (imagePath.isEmpty) {
    return _imageFallback();
  }

  final bool isNetwork =
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  if (isNetwork) {
    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _imageFallback(),
    );
  }

  return Image.asset(
    imagePath,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => _imageFallback(),
  );
}

Widget _imageFallback() {
  return Container(
    color: const Color(0xFFEBF5F2),
    child: const Icon(Icons.person, size: 48, color: Color(0xFF276B5A)),
  );
}

// ==========================================
// LAST BUT NOT LEAST SECTION
// ==========================================

Widget _lastLeast(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final bool isDesktop = screenWidth >= 900;

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 8, left: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 2, color: Colors.black),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Last but", style: GoogleFonts.arvo(fontSize: isDesktop ? 32 : 26, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text("Not The Least", style: GoogleFonts.imFellEnglishSc(fontSize: isDesktop ? 32 : 26, fontWeight: FontWeight.bold, color: Colors.purple))
            ],
          ),
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFC89D52),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Our team of Supervisors, Technicians and back office ensures the smooth functioning and execution of work thereby ensuring that our projects are completed on time with perfection as per the client’s satisfaction.",
            textAlign: TextAlign.center, style: GoogleFonts.arvo(fontSize: 14.8, fontWeight: FontWeight.w400, color: const Color(0xFF4A4A4A), height: 1.4))
        ],
      ),
    ),
  );
}