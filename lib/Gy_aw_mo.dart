import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'API_Services/View_Api.dart';
import 'Home_Page.dart';
import 'Nav_Widgets/Navigation.dart';
import 'Pro_Details.dart';
import 'Wal_Flo_Car.dart';

final List<NavItem> _globalNavItems = const [
  NavItem(label: "Home", route: AppRoutes.home, icon: Icons.home),
  NavItem(label: "About", route: AppRoutes.about, icon: CupertinoIcons.info_circle),
  NavItem(label: "Projects", route: AppRoutes.projects, icon: CupertinoIcons.building_2_fill),
  NavItem(label: "Clients", route: AppRoutes.clients, icon: CupertinoIcons.person_alt_circle),
  NavItem(label: "Shop", route: AppRoutes.shop, icon: CupertinoIcons.cart),
  NavItem(label: "Blogs", route: AppRoutes.blogs, icon: Icons.library_add_check_sharp),
  NavItem(
    label: "Reviews",
    icon: Icons.reviews_outlined,
    route: "https://www.google.com/maps/place/Bindu+Decorators/@19.2351656,72.8487463,17z",
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

// ProductGridCard class remains the same...

// 1. GYM FLOORINGS SECTION
class GymFloorings extends StatefulWidget {
  const GymFloorings({super.key});

  @override
  State<GymFloorings> createState() => _GymFlooringsState();
}

class _GymFlooringsState extends State<GymFloorings> {
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
            const SliverToBoxAdapter(child: GymFlooringsAnimatedSection()),
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [BinduFooter()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GymFlooringsAnimatedSection extends StatefulWidget {
  const GymFlooringsAnimatedSection({super.key});

  @override
  State<GymFlooringsAnimatedSection> createState() => _GymFlooringsAnimatedSectionState();
}

class _GymFlooringsAnimatedSectionState extends State<GymFlooringsAnimatedSection> {
  bool _isLoading = true;
  List<DecorProductItem> _gymItems = [];

  final List<DecorProductItem> _staticGymItems = const [
    DecorProductItem(
      title: "Rubberized Dumbbell Mat",
      category: "Gym Floorings",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVcTkp0U8ES6Hei7zEh3S0jwWGyMwd5Thsf4wadnAi3g&s=104",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRS10N8ZTA7_3qNf6mZCWB-9TGKXxBRCubB7adA9GNU2A&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHqpeSi5HboaNeSC7gvyOf_Bz9H9anSI9lYrEid_o_qA&s=10",
      ],
      description: "Shock-absorbing rubberized floor section designed for heavy weight training and equipment protection.",
    ),
    DecorProductItem(
      title: "Commercial Athletic Flooring",
      category: "Gym Floorings",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRaCbSVrTPbAR2DJSxsa4-Xn1lrekqR-NOXzuLxIvH9zw&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTThvKenYZJGOYpP3uffH32jGWQ8UdeImhwB4UYd_O0fw&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLz9umVq0WDQSGmpPFiKDayDA_NB_T1d0Tf20detA95g&s=10",
      ],
      description: "High-end seamless rubber flooring with custom floor markings for cardio and functional fitness zones.",
    ),
    DecorProductItem(
      title: "Interlocking Rubber Tiles",
      category: "Gym Floorings",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrxH6rjFPbdrnrhsB1k7lrI-wv3NHVUP_eGPOYg8qsHw&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKQSbku_xphzghkuLu3Tyeo3_lsbT_K3-MzUNLglpSLA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMwhBAnGMDk4Erft7wg4C6CcJcsMFkkRVFtj94HfkE2g&s=10",
      ],
      description: "Durable puzzle-edge rubber tiles providing superior grip, impact absorption, and noise reduction.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _gymItems = List<DecorProductItem>.from(_staticGymItems);
    _fetchCategoryProducts();
  }

  Future<void> _fetchCategoryProducts() async {
    try {
      final fetched = await ApiService.fetchProductsByCategory("Gym Floorings");

      if (fetched.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final Set<String> seenTitles = <String>{};
      List<DecorProductItem> merged = [];

      for (final p in fetched) {
        final key = p.title.toLowerCase();
        if (!seenTitles.contains(key)) {
          merged.add(p);
          seenTitles.add(key);
        }
      }

      for (final s in _staticGymItems) {
        final key = s.title.toLowerCase();
        if (!seenTitles.contains(key)) {
          merged.add(s);
          seenTitles.add(key);
        }
      }

      setState(() {
        _gymItems = merged;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _gymItems = List<DecorProductItem>.from(_staticGymItems);
      });
    }
  }

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
          Text("High-Performance Gym Flooring", style: GoogleFonts.cormorantGaramond(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
          const SizedBox(height: 16),
          _isLoading
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(width: 28, height: 28, child: CircularProgressIndicator()),
          )
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _gymItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
              mainAxisExtent: 520,
            ),
            itemBuilder: (context, index) {
              return ProductGridCard(item: _gymItems[index]);
            },
          ),
        ],
      ),
    );
  }
}

// 2. AWNINGS SECTION
class Awnings extends StatefulWidget {
  const Awnings({super.key});

  @override
  State<Awnings> createState() => _AwningsState();
}

class _AwningsState extends State<Awnings> {
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
            const SliverToBoxAdapter(child: AwningsAnimatedSection()),
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [BinduFooter()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AwningsAnimatedSection extends StatefulWidget {
  const AwningsAnimatedSection({super.key});

  @override
  State<AwningsAnimatedSection> createState() => _AwningsAnimatedSectionState();
}

class _AwningsAnimatedSectionState extends State<AwningsAnimatedSection> {
  bool _isLoading = true;
  List<DecorProductItem> _awnings = [];

  final List<DecorProductItem> _staticAwnings = const [
    DecorProductItem(
      title: "Rooftop Louver Pergola",
      category: "Awnings",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQdDt6ILehmhc-ZCIOi1hD78y3JZoE7Yj4zdMwhT-ND3Q&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlD_6REnRXeWBvonaZWyoHbyx0RmKrgp-DLcbNN-csLA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0TN4NE8OX94Lr1ogCq3sSLJWV8JIux8q_CWwV-QhBPg&s=10",
      ],
      description: "Modern motorized louvered roof structure providing customizable shade for luxury rooftop terraces.",
    ),
    DecorProductItem(
      title: "Balcony Patio Awning",
      category: "Awnings",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRV7mniXaDirbUcNs56VwuHdklwplbUDCwM8SrpqFvAQ&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRV7mniXaDirbUcNs56VwuHdklwplbUDCwM8SrpqFvAQ&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKAya6vmEyDOF6LRuqy__if6E6zeW4GZB7Bi7cxGgtKw&s=10",
      ],
      description: "Sleek architectural canopy structure designed for outdoor lounge spaces and high-rise balconies.",
    ),
    DecorProductItem(
      title: "Retractable Balcony Shade",
      category: "Awnings",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlaFMSD-L2QJEFsEwYiHy2ELigF61ZLH3mbdd_QC7dAA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTL8guIzHtBvbI1rbRDngXo7mcbDCkmnXxhrFGU4dWrjA&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTttSBuUKWF0pr2sC0-NUzqNt9ji8FYmEBQQ5O8MeT43w&s",
      ],
      description: "Heavy-duty motorized black folding arm awning offering instant sun & rain protection.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _awnings = List<DecorProductItem>.from(_staticAwnings);
    _fetchCategoryProducts();
  }

  Future<void> _fetchCategoryProducts() async {
    try {
      final fetched = await ApiService.fetchProductsByCategory("Awnings");

      if (fetched.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final Set<String> seenTitles = <String>{};
      List<DecorProductItem> merged = [];

      for (final p in fetched) {
        final key = p.title.toLowerCase();
        if (!seenTitles.contains(key)) {
          merged.add(p);
          seenTitles.add(key);
        }
      }

      for (final s in _staticAwnings) {
        final key = s.title.toLowerCase();
        if (!seenTitles.contains(key)) {
          merged.add(s);
          seenTitles.add(key);
        }
      }

      setState(() {
        _awnings = merged;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _awnings = List<DecorProductItem>.from(_staticAwnings);
      });
    }
  }

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
          Text("Architectural Outdoor Awnings", style: GoogleFonts.cormorantGaramond(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
          const SizedBox(height: 16),
          _isLoading
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(width: 28, height: 28, child: CircularProgressIndicator()),
          )
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _awnings.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
              mainAxisExtent: 520,
            ),
            itemBuilder: (context, index) {
              return ProductGridCard(item: _awnings[index]);
            },
          ),
        ],
      ),
    );
  }
}

// 3. MOSQUITO NET SECTION
class MosquitoNets extends StatefulWidget {
  const MosquitoNets({super.key});

  @override
  State<MosquitoNets> createState() => _MosquitoNetsState();
}

class _MosquitoNetsState extends State<MosquitoNets> {
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
            const SliverToBoxAdapter(child: MosquitoNetAnimatedSection()),
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [BinduFooter()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MosquitoNetAnimatedSection extends StatefulWidget {
  const MosquitoNetAnimatedSection({super.key});

  @override
  State<MosquitoNetAnimatedSection> createState() => _MosquitoNetAnimatedSectionState();
}

class _MosquitoNetAnimatedSectionState extends State<MosquitoNetAnimatedSection> {
  bool _isLoading = true;
  List<DecorProductItem> _mosquitoItems = [];

  final List<DecorProductItem> _staticMosquitoItems = const [
    DecorProductItem(
      title: "Outdoor Lawn Dome Net",
      category: "Mosquito Nets",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5F888CmSGKGOPmplz4Or_pWEbllerd6HoJx-UyviISg&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT51KEf8gAfu26Q4O2rEtE2itBi3Owpa_Ul8OPW1w8j4g&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5I6N6BfKP09fhmde4S0mjICrUfVShcJTXOqwE-H6z0A&s=10",
      ],
      description: "Portable outdoor pop-up mesh dome designed to create insect-free lounge seating in garden areas.",
    ),
    DecorProductItem(
      title: "Gazebo Mesh Screen Enclosure",
      category: "Mosquito Nets",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnVTuJPjEmS3_ruYlgPxf-WIoDHfYpvIMBErVBYZkNrg&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4Yzd5jgKJ10TatrdZp9nKarb_U0YKtjxuv-UIgsAAFg&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJDazpdej3cWSvvHSlS5B3t7SJ3bRX81TlnDZIRVGqlg&s=10",
      ],
      description: "Full perimeter transparent mosquito mesh netting for outdoor gazebos, patios, and pergolas.",
    ),
    DecorProductItem(
      title: "Pleated Window Mesh Screen",
      category: "Mosquito Nets",
      imageUrls: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGhE0J-vBCgyoqhDadqgVw2bewchQflkE8l_j1CXUsJg&s=10",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuWsXBFfjvH9po3PP8y8b3HVtwbHJqioyTRIo1AyuzeA&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZoY9DePKcyxOZfWeb7Ovd4l9vm8Ix05dsGpRrJnAyUw&s=10",
      ],
      description: "Retractable accordion-style mosquito net for smooth sliding windows and balcony doors.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _mosquitoItems = List<DecorProductItem>.from(_staticMosquitoItems);
    _fetchCategoryProducts();
  }

  Future<void> _fetchCategoryProducts() async {
    try {
      final fetched = await ApiService.fetchProductsByCategory("Mosquito Nets");

      if (fetched.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final Set<String> seenTitles = <String>{};
      List<DecorProductItem> merged = [];

      for (final p in fetched) {
        final key = p.title.toLowerCase();
        if (!seenTitles.contains(key)) {
          merged.add(p);
          seenTitles.add(key);
        }
      }

      for (final s in _staticMosquitoItems) {
        final key = s.title.toLowerCase();
        if (!seenTitles.contains(key)) {
          merged.add(s);
          seenTitles.add(key);
        }
      }

      setState(() {
        _mosquitoItems = merged;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _mosquitoItems = List<DecorProductItem>.from(_staticMosquitoItems);
      });
    }
  }

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
          Text("Mosquito & Insect Protection Nets", style: GoogleFonts.cormorantGaramond(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
          const SizedBox(height: 16),
          _isLoading
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(width: 28, height: 28, child: CircularProgressIndicator()),
          )
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _mosquitoItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
              mainAxisExtent: 520,
            ),
            itemBuilder: (context, index) {
              return ProductGridCard(item: _mosquitoItems[index]);
            },
          ),
        ],
      ),
    );
  }
}