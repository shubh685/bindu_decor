import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:bindu_decor/Nav_Widgets/Navigation.dart';
import 'Home_Page.dart';

// Model definition for Blog Items
class BlogModel {
  final String id;
  final String title;
  final String subject;
  final String description;
  final String authorName;
  final String status;
  final List<String> photos;

  BlogModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.authorName,
    required this.status,
    required this.photos,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      authorName: json['author_name'] ?? '',
      status: json['status'] ?? 'Published',
      photos: json['photos'] != null ? List<String>.from(json['photos']) : [],
    );
  }
}

class BlogView extends StatefulWidget {
  const BlogView({super.key});

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  // Set to true when connecting live backend API
  final bool _useLiveApi = false;
  final String _apiEndpoint = "http://192.168.1.54/bindu_decor/blogs.php";

  bool _isLoading = false;
  List<BlogModel> _blogs = [];

  // Static Mock Data for UI presentation
  final List<BlogModel> _mockBlogs = [
    BlogModel(
      id: "1",
      title: "Transforming Modern Interior Living Spaces",
      subject: "Interior Design & Wallpapers",
      description:
      "Discover how premium textured wallpapers and modern curtains can completely redefine your living room atmosphere.",
      authorName: "Bindu Decor Team",
      status: "Published",
      photos: [
        "https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=800&q=80"
      ],
    ),
    BlogModel(
      id: "2",
      title: "Choosing the Right Gym Flooring & Turf",
      subject: "Flooring Solutions",
      description:
      "A comprehensive guide on selecting rubber gym floorings and shock-absorbing artificial turfs for maximum durability.",
      authorName: "Decor Specialist",
      status: "Published",
      photos: [
        "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=800&q=80"
      ],
    ),
    BlogModel(
      id: "3",
      title: "Elegance of Stretch Ceilings & Glass Films",
      subject: "Architectural Decor",
      description:
      "Explore innovative light translucent stretch ceilings combined with modern frosted glass films for modern offices.",
      authorName: "Architectural Lead",
      status: "Published",
      photos: [
        "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80"
      ],
    ),
  ];

  final List<NavItem> _navItems = const [
    NavItem(label: "Home", route: AppRoutes.home, icon: Icons.home),
    NavItem(label: "About", route: AppRoutes.about, icon: CupertinoIcons.info_circle),
    NavItem(label: "Projects", route: AppRoutes.projects, icon: CupertinoIcons.building_2_fill),
    NavItem(label: "Clients", route: AppRoutes.clients, icon: CupertinoIcons.group_solid),
    NavItem(label: "Shop", route: AppRoutes.shop, icon: CupertinoIcons.cart),
    NavItem(label: "Blogs", route: AppRoutes.blogs, icon: Icons.library_add_check_sharp),
    NavItem(
      label: "Reviews",
      icon: Icons.reviews_outlined,
      route: "https://www.google.com/maps/place/Bindu+Decorators/@19.2351656,72.8487463,17z/",
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
  void initState() {
    super.initState();
    if (_useLiveApi) {
      _fetchBlogsFromApi();
    } else {
      _blogs = _mockBlogs;
    }
  }

  Future<void> _fetchBlogsFromApi() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(_apiEndpoint));
      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['status'] == 'success' && resData['data'] != null) {
          final List list = resData['data'];
          setState(() {
            _blogs = list.map((item) => BlogModel.fromJson(item)).toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading blogs from API: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      "Our Creative Insights",
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: LuxuryTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Explore trends, design tips, and stories from Bindu Decorators",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            _isLoading
                ? const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: LuxuryTheme.primaryAccent),
              ),
            )
                : SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return _buildBlogCard(_blogs[index]);
                  },
                  childCount: _blogs.length,
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

  Widget _buildBlogCard(BlogModel blog) {
    final String imageUrl = blog.photos.isNotEmpty
        ? blog.photos.first
        : "assets/images/bindu.png";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: imageUrl.startsWith("http")
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset("assets/images/bindu.png", fit: BoxFit.cover),
                    )
                        : Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        blog.title,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: LuxuryTheme.primaryDark,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        blog.description,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            blog.subject,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: LuxuryTheme.primaryAccent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const SizedBox(
                            height: 12,
                            child: VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            blog.authorName,
                            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded, size: 24,color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}