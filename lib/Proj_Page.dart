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
  NavItem(label: "Blogs", route: AppRoutes.blogs, icon: Icons.library_add_check_sharp),
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
  // Converted single _project to a List of ProjectItem models
  final List<ProjectItem> _projects = const [
    ProjectItem(
      title: "Modern Apartment Design in Mumbai With Stylish Living Room",
      subTitle: "Villa Velloze",
      location: "Villa Velloze, Mumbai",
      tags: ["Modern", "Convenience Max"],
      pricing: "10 - 15 Lakhs",
      bhk: "3-BHK",
      scope: "Living Room, Dining",
      propertyType: "Apartment",
      size: "2000 to 3500 sq ft",
      description:
      "This tastefully designed villa in Mumbai flaunts a chic and calming living room that’s high on both style and function. Pastel sage walls and nature-inspired murals bring a tranquil vibe, while velvet teal seating and a rich brown sectional add plushness to the space. The floating TV unit, set against a woodgrain panel, lends a contemporary contrast. Soft cove lighting enhances the ambience, while sheer drapes let in ample daylight. Ideal for a 2000 to 3500 sq ft. home, this design shows how a luxurious look can be achieved effortlessly within a 10–15 Lakh budget—modern villa living at its finest.",
      imageUrls: [
        "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/mumbai-1735452793-AQffS/jonita-gandhi-1750754827-5mUGp/lr-1750754841-VvYj3.jpg",
        "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/mumbai-1735452793-AQffS/jonita-gandhi-1750754827-5mUGp/tvv-1750754838-YRfmA.jpg",
        "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/mumbai-1735452793-AQffS/jonita-gandhi-1750754827-5mUGp/lr-1-1750754840-immyI.jpg",
        "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/mumbai-1735452793-AQffS/jonita-gandhi-1750754827-5mUGp/tv-1750754839-pPi2Y.jpg",
        "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/mumbai-1735452793-AQffS/jonita-gandhi-1750754827-5mUGp/dr-1-1763980215-sVaxh.jpg"
      ],
    ),
    ProjectItem(
        title: "Contemporary 3BHK Interior Design in Noida with Full Home Detailing",
        subTitle: "Ivy Country",
        location: 'Sector-75, Noida',
        tags: ["Contemporary", "Convenience Max"],
        pricing: "20-25 lakkhs",
        bhk: "3-BHK",
        scope: "Full Home, Kitchen, Living Room, 3 Bedrooms",
        propertyType:"Apartment",
        size: "2000 to 3500 sq ft",
        description: "Here’s a Noida 3BHK designed for style-conscious families who want comfort, sophistication, and practical design. The full-home interiors showcase calming neutrals, bold blue accent units, and organic-inspired feature walls. Living and dining zones are bright and spacious, lit by elegant fixtures and natural sunlight streaming through large windows. Bedrooms make the most of modular wardrobes, combining ample storage with clean geometry and integrated study nooks. Every touch, from clever display shelves to seamless built-ins, promotes both beauty and usability for homes sized 2000–3500 sq ft and finished within a 20–25 lakh bracket.",
        imageUrls:[
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/2711582-1755860801-qfgLL/mbr-1-1755861347-Pf0mv.jpg",
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/2711582-1755860801-qfgLL/mbr-2-1755861347-JGxR0.jpg",
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/2711582-1755860801-qfgLL/mbr-3-1755861345-a1LjP.jpg",
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/2711582-1755860801-qfgLL/mbr-4-1755861344-75OL8.jpg",
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/2711582-1755860801-qfgLL/mbr-5-1755861343-vMWgn.jpg"
        ]),
    ProjectItem(
        title: "Modern 3BHK Interior Design in Gurugram With L-Shaped Layout",
        subTitle: "Bestech Park View Spa Next",
        location: 'Sector-67, Gurugram',
        tags: ["Modern", "Convenience Max", "L-Shaped"],
        pricing: "25-30 lakkhs",
        bhk: "3-BHK",
        scope: "Kitchen, Living Room, Dining Room, 2 Bedrooms",
        propertyType:"Apartment",
        size: "1000 to 2500 sq ft",
        description: "What’s refreshing about this 3BHK modern style interior design in Gurugram is the way each room has its own personality. The kitchen grabs attention with its bold red-and-white cabinetry, paired with sleek counters for easy cooking. In contrast, the master bedroom exudes calmness with muted beige walls, soft lighting, and cozy layered bedding. The kids’ room, meanwhile, is colourful and playful with bright yellows, patterned walls, and cheerful storage. Even the foyer and dining area storage units feel polished with glossy neutrals. Designed at a budget of 25–30 Lakhs, this home beautifully balances convenience with vibrant modern charm.",
        imageUrls:[
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/hometour-1754897714-JYTjF/2233908-1754897784-l1rAi/mbr-1-1754897800-kBfpQ.jpg",
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/hometour-1754897714-JYTjF/2233908-1754897784-l1rAi/mbr-2-1754897800-dDQEg.jpg",
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/hometour-1754897714-JYTjF/2233908-1754897784-l1rAi/mbr-3-1754897799-jlNWH.jpg",
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/hometour-1754897714-JYTjF/2233908-1754897784-l1rAi/kbr-1-1754897798-iDSo5.jpg",
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/hometour-1754897714-JYTjF/2233908-1754897784-l1rAi/ki-1-1754897805-we9I5.jpg"
        ]),
    ProjectItem(
        title: "Contemporary 3BHK Interior Design in Greater Noida with Swing Wardrobes",
        subTitle: "Nirala Estate",
        location: 'Tech Zone IV, Patwari, Greater Noida, UP',
        tags: ["Contemporary", "Convenience Max", "Parallel"],
        pricing: "20-25 lakkhs",
        bhk: "3-BHK",
        scope: "Kitchen, Living Room, Dining Room, 3 Bedrooms",
        propertyType:"Apartment",
        size: "1000 to 2500 sq ft",
        description: "A bright and breezy contemporary home, this 3BHK apartment in Greater Noida is tailored for comfort and visual warmth. The kitchen layout maximises movement with its parallel format and white-toned cabinetry, making it a delight to cook in. The dining room is framed with mirrored wall panels and golden trims, enhancing the light flow. Bedrooms feature different design stories—green accent walls and floral themes in the guest space, pastel playfulness in the kids’ room, and rich woodwork in the master bedroom. Paired with clever swing wardrobe storage and a neutral colour palette, this 20–25 lakh home nails practicality and charm.",
        imageUrls:[
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/nirala-estate-1736923285-pfuE8/lr-ne-1736923415-OheGP.jpg",
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/nirala-estate-1736923285-pfuE8/tv-ne-1736923405-HJaX1.jpg",
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/nirala-estate-1736923285-pfuE8/dr-ne1-1736923406-wOLgx.jpg",
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/nirala-estate-1736923285-pfuE8/ki-ne-1736923404-BTl1B.jpg",
          "https://images.livspace-cdn.com/w:2048/plain/https://d3gq2merok8n5r.cloudfront.net/abhinav/2properties-1733457217-X1TuH/photoshoots-1735452784-CzJzx/delhi-1735818163-51LCH/nirala-estate-1736923285-pfuE8/br-ne2-1736923411-vUxaU.jpg"
        ]),
  ];

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
                    Text("OUR SHOWCASE", style: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFFC5A059), letterSpacing: 3.0,)),
                    const SizedBox(height: 6),
                    Text("Featured Interior Projects", style: GoogleFonts.cormorantGaramond(fontSize: isDesktop ? 36 : 26, fontWeight: FontWeight.w700, color: const Color(0xFF14372E))),
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

            // Displays Dynamic Grid of Project Cards
            // Displays Dynamic Grid of Project Cards (3 columns on Desktop)
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 60.0 : 20.0,
                vertical: 10.0,
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 3 : 1, // Set crossAxisCount to 3 for Desktop
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  mainAxisExtent: 480,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return _ProjectCard(item: _projects[index]);
                  },
                  childCount: _projects.length,
                ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A), height: 1.3)),
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
            SliverToBoxAdapter(
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
                      Text(widget.project.title, style: GoogleFonts.plusJakartaSans(fontSize: isDesktop ? 34 : 24, fontWeight: FontWeight.w800, color: const Color(0xFF1E1E1E), height: 1.2)),
                      const SizedBox(height: 8),

                      Text(widget.project.subTitle, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF222222))),
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
                                const Icon(Icons.location_on_outlined,
                                    color: Colors.black, size: 24),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.project.location,
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF222222)),
                                  ),
                                ),
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
                            child: Text(
                              "GET STARTED",
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5),
                            ),
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