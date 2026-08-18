import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Home_Page.dart';
import 'Nav_Widgets/Navigation.dart';

// ==========================================
// GLOBAL NAVIGATION DATA
// ==========================================
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
    "https://www.google.com/maps/place/Bindu+Decorators/@19.2351656,72.8487463,17z/data=!3m1!5s0x3be7b0d85f0d5563:0xbcc67135cad97d47!4m12!1m2!2m1!1sB-2+Mandpeshwar+Ind+premises+Opp+MCF+Gymkhana+Road+Borivali+west+mumbai-400092!3m8!1s0x3be7b11fee8a918b:0xedf1f8374494f993!8m2!3d19.2351656!4d72.8532524!9m1!1b1!15sCk5CLTIgTWFuZHBlc2h3YXIgSW5kIHByZW1pc2VzIE9wcCBNQ0YgR3lta2hhbmEgSW5kIHByZW1pc2VzIE9wcCBNQ0YgR3lta2hhbmEgUm9hZCBCb3JpdmFsaSB3ZXN0IG11bWJhaS00MDAwOTZaUCJOYiAyIG1hbmRwZXNod2FyIGluZCBwcmVtaXNlcyBvcHAgbWNmIGd5bWtoYW5hIHJvYWQgYm9yaXZhbGkgd2VzdCBtdW1iYWkgNDAwMDkykgEPd2FsbHBhcGVyX3N0b3Jl4AEA!16s%2Fg%2F1v_slq8m?entry=ttu&g_ep=EgoyMDI2MDgwNS4xIKXMDSoASAFQAw%3D%3D",
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

// ==========================================
// SELF-CONTAINED PROJECT MODEL
// ==========================================
class ProjectItem {
  final String title;
  final String subTitle;
  final String location;
  final List<String> tags;
  final String pricing;
  final String bhk;
  final String scope;
  final String propertyType;
  final String size;
  final String description;
  final List<String> imageUrls;

  const ProjectItem({
    required this.title,
    required this.subTitle,
    required this.location,
    required this.tags,
    required this.pricing,
    required this.bhk,
    required this.scope,
    required this.propertyType,
    required this.size,
    required this.description,
    required this.imageUrls,
  });
}

// ==========================================
// MAIN PROJECTS PAGE
// ==========================================
class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final ProjectItem _project = const ProjectItem(
    title: "Modern Apartment Design in Mumbai With Stylish Living Room",
    subTitle: "Villa Velloze",
    location: "Villa Velloze, Mumbai",
    tags: ["Modern", "Convenience Max"],
    pricing: "10 - 15 Lakhs",
    bhk: "3-BHK",
    scope: "Living Room,Dining",
    propertyType: "Apartment",
    size: "2000 to 3500 sq ft",
    description:
    "This tastefully designed villa in Mumbai flaunts a chic and calming living room that’s high on both style and function. Pastel sage walls and nature-inspired murals bring a tranquil vibe, while velvet teal seating and a rich brown sectional add plushness to the space. The floating TV unit, set against a woodgrain panel, lends a contemporary contrast. Soft cove lighting enhances the ambience, while sheer drapes let in ample daylight. Ideal for a 2000 to 3500 sq ft. home, this design shows how a luxurious look can be achieved effortlessly within a 10–15 Lakh budget—modern villa living at its finest.",
    imageUrls: [
      "https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1200&q=80",
      "https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1200&q=80",
      "https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80",
    ],
  );

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: BinduNavigationBar(
          navItems: _globalNavItems,
          shopItems: _globalShopItems,
          onMenuItemTap: () => context.navigateTo,
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 36.0,
                  horizontal: isDesktop ? 60.0 : 20.0,
                ),
                child: Column(
                  children: [
                    Text(
                      "OUR SHOWCASE",
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFC5A059),
                        letterSpacing: 3.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Featured Interior Project",
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: isDesktop ? 36 : 26,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF14372E),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 2,
                      width: 60,
                      color: const Color(0xFFC5A059),
                    ),
                  ],
                ),
              ),
            ),

            // Displays Project Card
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 220.0 : 20.0,
                vertical: 10.0,
              ),
              sliver: SliverToBoxAdapter(
                child: _ProjectCard(item: _project),
              ),
            ),

            const SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 40),
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
// CARD WIDGET
// ==========================================
class _ProjectCard extends StatelessWidget {
  final ProjectItem item;

  const _ProjectCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final String primaryImage =
    item.imageUrls.isNotEmpty ? item.imageUrls.first : '';

    return Container(
      height: 480,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Passes the custom breadcrumb route name to the navigator
                  settings: RouteSettings(name: 'Projects > ${item.subTitle}'),
                  builder: (context) => ProjectDetailPage(project: item),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 6,
                  child: Image.network(
                    primaryImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFF2ECE1),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.photo,
                          color: Color(0xFF14372E),
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                            height: 1.3,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFE55B5B),
                              width: 1.2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Get Similar Interiors",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFE55B5B),
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
        ),
      ),
    );
  }
}

// ==========================================
// PROJECT DETAIL VIEW
// ==========================================
class ProjectDetailPage extends StatefulWidget {
  final ProjectItem project;

  const ProjectDetailPage({super.key, required this.project});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  late PageController _pageController;
  int _currentImageIndex = 0;
  bool _isAboutExpanded = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 900;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: BinduNavigationBar(
          navItems: _globalNavItems,
          shopItems: _globalShopItems,
          onMenuItemTap: () => context.navigateTo,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40.0 : 20.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.arrow_back, color: Colors.black),
                          const SizedBox(width: 8),
                          Text(
                            "Back to Projects",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 1. CAROUSEL OF ALL PROJECT IMAGES
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: isDesktop ? 480 : 280,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: widget.project.imageUrls.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Image.network(
                              widget.project.imageUrls[index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: const Color(0xFFF2ECE1),
                                    child: const Center(
                                      child: Icon(
                                        CupertinoIcons.photo,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Left Chevron Button
                    if (widget.project.imageUrls.length > 1)
                      Positioned(
                        left: 12,
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.85),
                          child: IconButton(
                            icon: const Icon(Icons.chevron_left,
                                color: Colors.black),
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ),

                    // Right Chevron Button
                    if (widget.project.imageUrls.length > 1)
                      Positioned(
                        right: 12,
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.85),
                          child: IconButton(
                            icon: const Icon(Icons.chevron_right,
                                color: Colors.black),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ),

                    // Indicators
                    if (widget.project.imageUrls.length > 1)
                      Positioned(
                        bottom: 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.project.imageUrls.length,
                                (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentImageIndex == index ? 12 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentImageIndex == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 28),

                // 2. PROJECT TITLE & DETAILS
                Text(
                  widget.project.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isDesktop ? 34 : 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E1E1E),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  widget.project.subTitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 12),

                // TAGS
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: widget.project.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3EE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF388E3C),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // LOCATION & GET STARTED BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: Colors.black, size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(widget.project.location, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF222222)))),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => showContactFormDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEE5A5A),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: Text("GET STARTED", style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFE0E0E0), thickness: 1),
                const SizedBox(height: 20),

                // SPECIFICATIONS ROW
                Wrap(
                  spacing: 32,
                  runSpacing: 20,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    _SpecItem(label: "Pricing", value: widget.project.pricing),
                    _SpecItem(label: "BHK", value: widget.project.bhk),
                    _SpecItem(label: "Scope", value: widget.project.scope),
                    _SpecItem(
                        label: "Property Type",
                        value: widget.project.propertyType),
                    _SpecItem(label: "Size", value: widget.project.size),
                  ],
                ),
                const SizedBox(height: 36),

                // 3. ABOUT THE HOME SECTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "About the Home",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1E1E),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isAboutExpanded = !_isAboutExpanded;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0F0F0),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isAboutExpanded
                              ? CupertinoIcons.chevron_up
                              : CupertinoIcons.chevron_down,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (_isAboutExpanded)
                  Text(
                    widget.project.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF333333),
                      height: 1.6,
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SPECIFICATION WIDGET HELPER
class _SpecItem extends StatelessWidget {
  final String label;
  final String value;

  const _SpecItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF757575),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E1E1E),
          ),
        ),
      ],
    );
  }
}