import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:bindu_decor/Nav_Widgets/Navigation.dart';
import 'Home_Page.dart';

// Base API Server URL definition for path formatting
const String kBaseServerUrl = "https://yellow-woodpecker-430323.hostingersite.com/bindu_web/";

// Helper to handle absolute HTTP URLs and local server uploads directory paths
String _resolveImageUrl(String path) {
  final cleanPath = path.trim();
  if (cleanPath.isEmpty) return '';
  if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
    return cleanPath;
  }

  // Format local directory uploads paths safely
  String formatted = cleanPath.replaceAll('\\', '/');
  if (formatted.startsWith('/')) {
    formatted = formatted.substring(1);
  }
  return "$kBaseServerUrl$formatted";
}

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
    List<String> rawPhotos = [];
    if (json['photos'] != null) {
      if (json['photos'] is List) {
        rawPhotos = List<String>.from(json['photos']);
      } else if (json['photos'] is String) {
        // Fallback for single photo URL or JSON-encoded strings
        try {
          final decoded = jsonDecode(json['photos']);
          if (decoded is List) {
            rawPhotos = List<String>.from(decoded);
          } else {
            rawPhotos = [json['photos'].toString()];
          }
        } catch (_) {
          rawPhotos = [json['photos'].toString()];
        }
      }
    } else if (json['image_url'] != null) {
      rawPhotos = [json['image_url'].toString()];
    }

    return BlogModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      authorName: json['author_name'] ?? '',
      status: json['status'] ?? 'Published',
      photos: rawPhotos,
    );
  }
}

class BlogView extends StatefulWidget {
  const BlogView({super.key});

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  final String _apiEndpoint = "${kBaseServerUrl}blogs.php";
  late Future<List<BlogModel>> _blogsFuture;

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
    _blogsFuture = _fetchBlogsFromApi();
  }

  Future<List<BlogModel>> _fetchBlogsFromApi() async {
    final response = await http.get(Uri.parse(_apiEndpoint));
    if (response.statusCode == 200) {
      final resData = jsonDecode(response.body);
      if (resData['status'] == 'success' && resData['data'] != null) {
        final List list = resData['data'];
        return list.map((item) => BlogModel.fromJson(item)).toList();
      }
    }
    throw Exception('Failed to load blogs');
  }

  Widget _buildCustomLoadingIndicator() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(LuxuryTheme.primaryAccent),
              ),
            ),
            ClipOval(
              child: Image.asset(
                "assets/images/bindu.png",
                width: 45,
                height: 45,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  CupertinoIcons.photo,
                  size: 28,
                  color: LuxuryTheme.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPlainTextSnippet(String content) {
    if (content.trim().startsWith('[')) {
      try {
        final doc = quill.Document.fromJson(jsonDecode(content));
        return doc.toPlainText().trim();
      } catch (_) {}
    }
    return content;
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
            FutureBuilder<List<BlogModel>>(
              future: _blogsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: _buildCustomLoadingIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        "Failed to load blogs. Please try again later.",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.red.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        "No blogs available right now.",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }

                final blogs = snapshot.data!;

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return _buildBlogCard(blogs[index]);
                      },
                      childCount: blogs.length,
                    ),
                  ),
                );
              },
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
    final String rawPath = blog.photos.isNotEmpty ? blog.photos.first : '';
    final String resolvedUrl = _resolveImageUrl(rawPath);
    final String previewSnippet = _getPlainTextSnippet(blog.description);

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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlogDetailPage(blog: blog),
              ),
            );
          },
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
                    child: resolvedUrl.isNotEmpty
                        ? Image.network(
                      resolvedUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset("assets/images/bindu.png", fit: BoxFit.cover),
                    )
                        : Image.asset(
                      "assets/images/bindu.png",
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
                        previewSnippet,
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
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded, size: 24, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// AUTO-SCROLLING BLOG DETAIL PAGE WITH CAROUSEL
// ==========================================
class BlogDetailPage extends StatefulWidget {
  final BlogModel blog;

  const BlogDetailPage({
    super.key,
    required this.blog,
  });

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideInAnimation;

  int _currentCarouselIndex = 0;
  Timer? _carouselTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideInAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animController.forward();
    _startAutoCarouselTimer();
  }

  void _startAutoCarouselTimer() {
    if (widget.blog.photos.length > 1) {
      _carouselTimer?.cancel();
      _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_pageController.hasClients) {
          int nextPage = (_currentCarouselIndex + 1) % widget.blog.photos.length;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Widget _buildBlogImage(String rawPath) {
    final resolvedUrl = _resolveImageUrl(rawPath);

    if (resolvedUrl.isEmpty) {
      return Container(
        color: const Color(0xFFF2F2F2),
        child: const Center(
          child: Icon(CupertinoIcons.photo, color: Colors.grey, size: 48),
        ),
      );
    }

    if (resolvedUrl.startsWith("http://") || resolvedUrl.startsWith("https://")) {
      return Image.network(
        resolvedUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: const Color(0xFFF8F9FA),
            child: const Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF276B5A)),
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFFF2F2F2),
          child: const Center(
            child: Icon(CupertinoIcons.photo, color: Colors.grey, size: 48),
          ),
        ),
      );
    }

    return Image.asset(
      rawPath,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) => Container(
        color: const Color(0xFFF2F2F2),
        child: const Center(
          child: Icon(CupertinoIcons.photo, color: Colors.grey, size: 48),
        ),
      ),
    );
  }

  Widget _buildImageSection(bool isDesktop) {
    final List<String> photos = widget.blog.photos;

    if (photos.isEmpty) {
      return const SizedBox.shrink();
    }

    if (photos.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: isDesktop ? 450 : 320,
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
          child: _buildBlogImage(photos.first),
        ),
      );
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: isDesktop ? 450 : 320,
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: photos.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentCarouselIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildBlogImage(photos[index]);
                  },
                ),
              ),
            ),
            Positioned(
              left: 12,
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.85),
                radius: 20,
                child: IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.black87, size: 22),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    int prevPage = (_currentCarouselIndex - 1 + photos.length) % photos.length;
                    _pageController.animateToPage(
                      prevPage,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                    _startAutoCarouselTimer();
                  },
                ),
              ),
            ),
            Positioned(
              right: 12,
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.85),
                radius: 20,
                child: IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.black87, size: 22),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    int nextPage = (_currentCarouselIndex + 1) % photos.length;
                    _pageController.animateToPage(
                      nextPage,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                    _startAutoCarouselTimer();
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(photos.length, (index) {
                  final bool isSelected = index == _currentCarouselIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isSelected ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final isSelected = index == _currentCarouselIndex;
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  _startAutoCarouselTimer();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1A73E8)
                          : Colors.transparent,
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildBlogImage(photos[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 760),
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 24.0 : 18.0,
                  vertical: 20.0,
                ),
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: SlideTransition(
                    position: _slideInAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F0FE),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            widget.blog.subject.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A73E8),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.blog.title,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: isDesktop ? 36 : 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF202124),
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFF276B5A),
                              child: Text(
                                widget.blog.authorName.isNotEmpty
                                    ? widget.blog.authorName[0].toUpperCase()
                                    : "B",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  "${widget.blog.status} by ",
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12, color: Colors.grey.shade600),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.blog.authorName,
                                  style: GoogleFonts.aleo(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildImageSection(isDesktop),
                        const SizedBox(height: 28),
                        QuillDeltaParser(content: widget.blog.description),
                        const SizedBox(height: 40),
                        const Divider(color: Color(0xFFE5E7EB), thickness: 1),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.chat_bubble_2_fill,
                                  color: Color(0xFF276B5A), size: 32),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Have questions about this article?",
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF202124)),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Get in touch with our design specialists.",
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF276B5A),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () => showContactFormDialog(context),
                                child: Text("Contact Us",
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const BinduFooter(),
          ],
        ),
      ),
    );
  }
}

// Widget to handle Quill Delta JSON format or legacy plain-text descriptions dynamically
class QuillDeltaParser extends StatefulWidget {
  final String content;

  const QuillDeltaParser({super.key, required this.content});

  @override
  State<QuillDeltaParser> createState() => _QuillDeltaParserState();
}

class _QuillDeltaParserState extends State<QuillDeltaParser> {
  late quill.QuillController _controller;
  bool _isQuillJson = false;

  @override
  void initState() {
    super.initState();
    if (widget.content.trim().startsWith('[')) {
      try {
        final doc = quill.Document.fromJson(jsonDecode(widget.content));
        _controller = quill.QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
        _isQuillJson = true;
        return;
      } catch (_) {}
    }

    _controller = quill.QuillController.basic();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isQuillJson) {
      return Text(
        widget.content,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          height: 1.75,
          color: const Color(0xFF3C4043),
          letterSpacing: 0.2,
        ),
      );
    }

    return AbsorbPointer(
      child: quill.QuillEditor(
        controller: _controller,
        focusNode: FocusNode(),
        scrollController: ScrollController(),
        config: quill.QuillEditorConfig(
          autoFocus: false,
          expands: false,
          padding: EdgeInsets.zero,
          showCursor: false,
          customStyles: quill.DefaultStyles(
            paragraph: quill.DefaultTextBlockStyle(
              GoogleFonts.plusJakartaSans(
                fontSize: 16,
                height: 1.75,
                color: const Color(0xFF3C4043),
                letterSpacing: 0.2,
              ),
              const quill.HorizontalSpacing(0, 0),
              const quill.VerticalSpacing(0, 0),
              const quill.VerticalSpacing(0, 0),
              null,
            ),
          ),
        ),
      ),
    );
  }
}