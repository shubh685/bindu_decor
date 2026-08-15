import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bindu_decor/Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ==========================================
// LUXURY BRANDING COLOR PALETTE
// ==========================================
class LuxuryTheme {
  static const Color primaryDark = Color(0xFF1E4D40);  // Rich Royal Emerald
  static const Color primaryAccent = Color(0xFFC5A059); // Muted Brass Gold
  static const Color bgCream = Color(0xFFFBF9F5);       // Elegant Soft Cream
  static const Color textDark = Color(0xFF222222);      // Deep Charcoal
  static const Color textMuted = Color(0xFF666666);     // Neutral Subtext
}

// ==========================================
// NAVIGATION DATA MODELS
// ==========================================

class NavItem {
  final String label;
  final String route;
  final IconData? icon;

  const NavItem({
    required this.label,
    required this.route,
    this.icon,
  });
}

class NestedMenuItem {
  final String title;
  final List<NavItem> subItems;

  const NestedMenuItem({
    required this.title,
    required this.subItems,
  });
}

// ==========================================
// MAIN NAVIGATION BAR
// ==========================================

class BinduNavigationBar extends StatelessWidget {
  final List<NavItem> navItems;
  final List<NestedMenuItem> shopItems;
  final VoidCallback? onMenuItemTap;

  const BinduNavigationBar({
    super.key,
    required this.navItems,
    required this.shopItems,
    this.onMenuItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      decoration: BoxDecoration(
        color: LuxuryTheme.bgCream.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE8E3D9), width: 1.0),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLogo(context),
            const SizedBox(width: 20),
            if (isDesktop)
              _buildDesktopNav(context)
            else
              _buildMobileMenuButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopNav(BuildContext context) {
    List<Widget> navWidgets = [];

    for (var item in navItems) {
      if (item.label.toLowerCase() == 'shop') {
        // Desktop Shop Item with Popup Menu
        navWidgets.add(
          PopupMenuButton<String>(
            offset: const Offset(0, 52),
            elevation: 12,
            shadowColor: Colors.black.withOpacity(0.15),
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            tooltip: item.label,
            onSelected: (value) => _handleNavigation(context, value),
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<String>> menuEntries = [];

              for (var shopGroup in shopItems) {
                if (shopGroup.subItems.isNotEmpty) {
                  // Category Header
                  menuEntries.add(
                    PopupMenuItem<String>(
                      enabled: false,
                      child: Text(
                        shopGroup.title.toUpperCase(),
                        style: GoogleFonts.cormorantGaramond(
                          fontWeight: FontWeight.w700, fontSize: 12.5, letterSpacing: 2.0, color: LuxuryTheme.primaryAccent,)),
                    ),
                  );

                  // Sub-items with Icons
                  for (var subItem in shopGroup.subItems) {
                    menuEntries.add(
                      PopupMenuItem<String>(
                        value: subItem.route,
                        height: 44,
                        child: Row(
                          children: [
                            if (subItem.icon != null) ...[
                              Icon(subItem.icon, size: 18, color: LuxuryTheme.primaryDark),
                              const SizedBox(width: 12),
                            ],
                            Text(subItem.label, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: LuxuryTheme.textDark,)),
                          ]
                        ),
                      ),
                    );
                  }
                  menuEntries.add(const PopupMenuDivider());
                }
              }
              return menuEntries;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.icon != null) ...[
                    Icon(item.icon, size: 16, color: LuxuryTheme.primaryDark),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    item.label.toUpperCase(),
                    style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: LuxuryTheme.primaryDark)),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: LuxuryTheme.primaryDark),
                ],
              ),
            ),
          ),
        );
      } else {
        navWidgets.add(
          _NavItem(
            label: item.label,
            icon: item.icon,
            onTap: () => _handleNavigation(context, item.route),
          ),
        );
      }
      navWidgets.add(const SizedBox(width: 10));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: navWidgets,
    );
  }

  Widget _buildMobileMenuButton(BuildContext context) {
    return Builder(
      builder: (innerContext) => IconButton(
        icon: const Icon(Icons.menu_rounded, color: LuxuryTheme.primaryDark, size: 28),
        onPressed: () {
          Scaffold.of(innerContext).openDrawer();
        },
      ),
    );
  }

  // Replace this method in BinduNavigationBar class
  Future<void> _handleNavigation(BuildContext context, String route) async {
    await NavigationHandler.handleNavigation(context, route, onTap: onMenuItemTap);
  }
}

// Navigation.dart - Add this at the end of the file, before the BinduFooter class

// ==========================================
// REUSABLE NAVIGATION HANDLER
// ==========================================

class NavigationHandler {
  /// Handles navigation for both internal routes and external URLs
  static Future<void> handleNavigation(
      BuildContext context,
      String route, {
        VoidCallback? onTap,
      }) async {
    if (onTap != null) {
      onTap();
    }

    if (route.startsWith('http://') || route.startsWith('https://')) {
      final Uri url = Uri.parse(route);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
      }
    } else {
      // Check if we're already on the same route to avoid unnecessary navigation
      final String? currentRoute = ModalRoute.of(context)?.settings.name;
      if (currentRoute != route) {
        Navigator.pushNamed(context, route);
      }
    }
  }

  /// Creates a navigation callback that can be used with onMenuItemTap
  static VoidCallback createNavigationCallback(
      BuildContext context,
      String route,
      ) {
    return () => handleNavigation(context, route);
  }
}
// ==========================================
// NAVIGATION WIDGETS
// ==========================================

class _NavItem extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _NavItem({required this.label, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: LuxuryTheme.primaryDark),
              const SizedBox(width: 6),
            ],
            Text(label.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: LuxuryTheme.primaryDark)),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// MOBILE DRAWER
// ==========================================

class BinduMobileDrawer extends StatelessWidget {
  final List<NavItem> navItems;
  final List<NestedMenuItem> shopItems;
  final VoidCallback? onItemTap;

  const BinduMobileDrawer({
    super.key,
    required this.navItems,
    required this.shopItems,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: LuxuryTheme.bgCream,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          children: [
            _buildLogo(context),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFE8E3D9)),
            const SizedBox(height: 8),
            ..._buildDrawerItems(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    List<Widget> items = [];

    for (var navItem in navItems) {
      if (navItem.label.toLowerCase() == 'shop') {
        items.add(
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: navItem.icon != null
                  ? Icon(navItem.icon, color: LuxuryTheme.primaryDark)
                  : null,
              title: Text(
                navItem.label.toUpperCase(),
                style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: LuxuryTheme.primaryDark),
              ),
              children: shopItems.map((category) {
                return ExpansionTile(
                  tilePadding: const EdgeInsets.only(left: 20),
                  title: Text(
                    category.title.toUpperCase(),
                    style: GoogleFonts.cormorantGaramond(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: LuxuryTheme.primaryAccent),
                  ),
                  children: category.subItems.map((subItem) {
                    return ListTile(
                      contentPadding: const EdgeInsets.only(left: 36),
                      leading: subItem.icon != null
                          ? Icon(subItem.icon, size: 18, color: LuxuryTheme.primaryDark)
                          : null,
                      title: Text(
                        subItem.label,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500, color: LuxuryTheme.textDark),
                      ),
                      onTap: () => _handleNavigation(context, subItem.route),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        );
        items.add(const SizedBox(height: 4));
      } else {
        items.add(
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            leading: navItem.icon != null
                ? Icon(navItem.icon, color: LuxuryTheme.primaryDark)
                : null,
            title: Text(
              navItem.label.toUpperCase(),
              style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: LuxuryTheme.primaryDark),
            ),
            onTap: () => _handleNavigation(context, navItem.route),
          ),
        );
        items.add(const SizedBox(height: 4));
      }
    }

    return items;
  }

  // Replace this method in BinduMobileDrawer class
  Future<void> _handleNavigation(BuildContext context, String route) async {
    await NavigationHandler.handleNavigation(context, route, onTap: onItemTap);
  }
}

// ==========================================
// LOGO WIDGET
// ==========================================

Widget _buildLogo(BuildContext context) {
  return SizedBox(
    height: 65,
    child: InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
      },
      child: Image.asset("assets/images/bindu.png", fit: BoxFit.contain),
    ),
  );
}

// ==========================================
// FOOTER WIDGET
// ==========================================

class BinduFooter extends StatefulWidget {
  const BinduFooter({super.key});

  @override
  State<BinduFooter> createState() => _BinduFooterState();
}

class _BinduFooterState extends State<BinduFooter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> _logoAnim;
  late Animation<Offset> _addressAnim;
  late Animation<Offset> _phoneAnim;
  late Animation<Offset> _emailAnim;
  late Animation<Offset> _workingHoursAnim;

  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoAnim = Tween<Offset>(
      begin: const Offset(0.0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    ));

    _addressAnim = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    ));

    _phoneAnim = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    ));

    _emailAnim = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
    ));

    _workingHoursAnim = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchMapUrl(String address) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
    );
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchPhoneUrl(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _launchEmailUrl(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 900;

    const String addressText =
        "B-2 Mandpeshwar Ind premises Opp MCF Gymkhana Road Borivali west mumbai-400092";
    const String emailText = "info@bindudecor.com";
    const String phoneText = "+91 9930098219 / 2228905344 / 28930959";

    return VisibilityDetector(
      key: const Key('bindu_footer_visibility'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_hasAnimated) {
          _hasAnimated = true;
          _controller.forward();
        }
      },
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: LuxuryTheme.primaryDark,
          border: Border(
            top: BorderSide(color: LuxuryTheme.primaryAccent, width: 2.0),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 56.0,
          horizontal: isDesktop ? 64.0 : 24.0,
        ),
        child: isDesktop
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildLogoSection()),
            const SizedBox(width: 20),
            Expanded(
              flex: 4,
              child: _buildContactSection(addressText, emailText, phoneText),
            ),
            const SizedBox(width: 20),
            Expanded(flex: 3, child: _buildRightSection()),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLogoSection(),
            const SizedBox(height: 36),
            _buildContactSection(addressText, emailText, phoneText),
            const SizedBox(height: 36),
            _buildRightSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return SlideTransition(
      position: _logoAnim,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 75,
            width: 140,
            child: Image.asset(
              "assets/images/bindu.png",
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: LuxuryTheme.primaryAccent, width: 2),
                ),
                child: const Center(
                  child: Text("BINDU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text("BINDU DÉCOR", style: GoogleFonts.cormorantGaramond(color: Colors.white, fontSize: 22, letterSpacing: 3, fontWeight: FontWeight.w700,),),
          const SizedBox(height: 4),
          Text("Curating Luxury Living Spaces", style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildContactSection(String address, String email, String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "CONTACT DETAILS",
          style: GoogleFonts.cormorantGaramond(color: LuxuryTheme.primaryAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        const SizedBox(height: 18),
        SlideTransition(
          position: _addressAnim,
          child: InkWell(
            onTap: () => _launchMapUrl(address),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: Icon(Icons.location_on_outlined, color: LuxuryTheme.primaryAccent, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(address, style: GoogleFonts.plusJakartaSans(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.5, decorationColor: Colors.white38,)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        SlideTransition(
          position: _phoneAnim,
          child: InkWell(
            onTap: () => _launchPhoneUrl(phone),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: Icon(Icons.phone_outlined, color: LuxuryTheme.primaryAccent, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(phone, style: GoogleFonts.plusJakartaSans(color: Colors.white.withOpacity(0.9), fontSize: 14,  decorationColor: Colors.white38)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        SlideTransition(
          position: _emailAnim,
          child: InkWell(
            onTap: () => _launchEmailUrl(email),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: Icon(Icons.email_outlined, color: LuxuryTheme.primaryAccent, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(email, style: GoogleFonts.plusJakartaSans(color: Colors.white.withOpacity(0.9), fontSize: 14, decorationColor: Colors.white38)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightSection() {
    return SlideTransition(
      position: _workingHoursAnim,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "WORKING HOURS",
            style: GoogleFonts.cinzel(
              color: LuxuryTheme.primaryAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            "10:30 AM to 7:00 PM IST | Mon - Sat",
            style: GoogleFonts.plusJakartaSans(color: Colors.white.withOpacity(0.85), fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}

void showContactFormDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => _contactForm(context),
  );
}

Widget _contactForm(BuildContext context) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  bool isLoading = false;

  String selectedDesignType = 'Wallpapers';
  final List<String> designTypes = [
    'Wallpapers',
    'Floorings',
    'Carpets',
    'Blinds',
    'Glass Films',
    'Artificial Turfs',
    'Gym Floorings',
    'Awnings',
    'Mosquito Nets',
    'Upholstery',
    'Curtains',
    'Stretch Ceiling',
    'Other / Custom Design',
  ];

  InputDecoration buildInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: LuxuryTheme.primaryDark, size: 20),
      labelStyle: GoogleFonts.plusJakartaSans(color: LuxuryTheme.textDark, fontSize: 13),
      hintStyle: GoogleFonts.plusJakartaSans(color: LuxuryTheme.textMuted, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      filled: true,
      fillColor: LuxuryTheme.bgCream,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LuxuryTheme.primaryDark, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Future<void> sendInquiryApi(StateSetter setDialogState) async {
    if (!formKey.currentState!.validate()) return;

    setDialogState(() {
      isLoading = true;
    });

    final String generatedReqId = 'BD-${DateTime.now().millisecondsSinceEpoch}';

    final Uri apiUrl = Uri.parse('http://192.168.1.10/bindu_decor/send_inquiry.php');

    try {
      final response = await http
          .post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'request_id': generatedReqId,
          'name': nameController.text.trim(),
          'mobile': mobileController.text.trim(),
          'email': emailController.text.trim(),
          'location': locationController.text.trim(),
          'design_type': selectedDesignType,
        }),
      )
          .timeout(const Duration(seconds: 30));

      if (!context.mounted) return;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        setDialogState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server Error ${response.statusCode}: ${response.body}'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['success'] == true) {
        if (!context.mounted) return;
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Inquiry submitted successfully!'),
            backgroundColor: LuxuryTheme.primaryDark,
          ),
        );
      } else {
        setDialogState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Unable to submit inquiry.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      setDialogState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection Error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> openWhatsApp() async {
    const String phoneNumber = '91 9586518360';
    final String name = nameController.text.trim();
    final String location = locationController.text.trim();

    String message = 'Hello Bindu Decor Team,\nI would like to ask for the price details regarding *$selectedDesignType*.';
    if (name.isNotEmpty) message += '\nName: $name';
    if (location.isNotEmpty) message += '\nLocation: $location';

    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
    );

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open WhatsApp.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  return Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    child: Container(
      constraints: const BoxConstraints(maxWidth: 480),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dialog Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [LuxuryTheme.primaryDark, Color(0xFF14372E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 24),
                            const Icon(
                              Icons.mark_email_read_outlined,
                              size: 38,
                              color: LuxuryTheme.primaryAccent,
                            ),
                            IconButton(
                              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close, color: Colors.white70),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('DESIGN CONSULTATION', style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w700, color: LuxuryTheme.primaryAccent, letterSpacing: 2.0,)),
                        const SizedBox(height: 4),
                        Text('Get In Touch With Us', style: GoogleFonts.cormorantGaramond(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(height: 8),
                        Text(
                          'Tell us your location & preferred style. Our design experts will recommend tailored solutions for you.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.85),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form Controls
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            enabled: !isLoading,
                            textCapitalization: TextCapitalization.words,
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: LuxuryTheme.textDark),
                            decoration: buildInputDecoration(
                              label: 'Full Name',
                              hint: 'Enter your full name',
                              icon: Icons.person_outline,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: mobileController,
                            enabled: !isLoading,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: LuxuryTheme.textDark),
                            decoration: buildInputDecoration(
                              label: 'Mobile Number',
                              hint: 'Enter 10-digit phone number',
                              icon: Icons.phone_outlined,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your mobile number';
                              }
                              if (value.trim().length < 10) {
                                return 'Enter a valid 10-digit phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: emailController,
                            enabled: !isLoading,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: LuxuryTheme.textDark),
                            decoration: buildInputDecoration(
                              label: 'Email ID',
                              hint: 'Enter your email address',
                              icon: Icons.email_outlined,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: locationController,
                            enabled: !isLoading,
                            textCapitalization: TextCapitalization.words,
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: LuxuryTheme.textDark),
                            decoration: buildInputDecoration(
                              label: 'Your Location / City',
                              hint: 'e.g., Borivali, Mumbai',
                              icon: Icons.location_on_outlined,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your location';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedDesignType,
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: LuxuryTheme.textDark),
                            decoration: buildInputDecoration(
                              label: 'Design Category',
                              hint: 'Select design category',
                              icon: Icons.design_services_outlined,
                            ),
                            items: designTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: isLoading
                                ? null
                                : (String? newValue) {
                              if (newValue != null) {
                                setDialogState(() {
                                  selectedDesignType = newValue;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 24),

                          // Actions Row
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : () => sendInquiryApi(setDialogState),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: LuxuryTheme.primaryDark,
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shadowColor: LuxuryTheme.primaryDark.withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                        : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'SEND INQUIRY',
                                          style: GoogleFonts.cormorantGaramond(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.white)),
                                        const SizedBox(width: 6),
                                        const Icon(Icons.send_rounded, size: 14),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),

                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: openWhatsApp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF25D366),
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shadowColor: const Color(0xFF25D366).withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FaIcon(FontAwesomeIcons.whatsapp, size: 14),
                                        const SizedBox(width: 6),
                                        Text('ASK PRICE', style: GoogleFonts.cinzel(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

extension NavigationExtension on BuildContext {
  /// Navigate to a route or open URL
  Future<void> navigateTo(String route, {VoidCallback? onTap}) {
    return NavigationHandler.handleNavigation(this, route, onTap: onTap);
  }

  /// Check if current route matches the given route
  bool isCurrentRoute(String route) {
    return ModalRoute
        .of(this)
        ?.settings
        .name == route;
  }
}