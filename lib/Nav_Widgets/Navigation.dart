import 'dart:convert';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bindu_decor/Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
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
        // Desktop Shop Item with Icon & Popup Menu
        navWidgets.add(
          PopupMenuButton<String>(
            offset: const Offset(0, 40),
            elevation: 4,
            color: Colors.white,
            tooltip: item.label,
            onSelected: (value) => _handleNavigation(context, value),
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<String>> menuEntries = [];

              for (var shopGroup in shopItems) {
                if (shopGroup.subItems.isNotEmpty) {
                  // Category Header (e.g., PRODUCTS & SERVICES)
                  menuEntries.add(
                    PopupMenuItem<String>(
                      enabled: false,
                      child: Text(
                        shopGroup.title.toUpperCase(),
                        style: GoogleFonts.arvo(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.brown.shade800, letterSpacing: 1.0))),
                  );

                  // Sub-items with Icons
                  for (var subItem in shopGroup.subItems) {
                    menuEntries.add(
                      PopupMenuItem<String>(
                        value: subItem.route,
                        height: 40,
                        child: Row(
                          children: [
                            if (subItem.icon != null) ...[
                              Icon(subItem.icon, size: 18, color: Colors.brown.shade800),
                              const SizedBox(width: 10),
                            ],
                            Text(subItem.label, style: GoogleFonts.arvo(fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xFF4A4A4A))),
                          ],
                        ),
                      ),
                    );
                  }
                  menuEntries.add(const PopupMenuDivider());
                }
              }
              return menuEntries;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.icon != null) ...[
                    Icon(item.icon, size: 20, color: const Color(0xFF276B5A)),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    item.label,
                    style: GoogleFonts.arvo(fontSize: 18, fontWeight: FontWeight.w500, color: const Color(0xFF276B5A))),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 20, color: Color(0xFF276B5A)),
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
      navWidgets.add(const SizedBox(width: 20));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: navWidgets,
    );
  }

  Widget _buildMobileMenuButton(BuildContext context) {
    return Builder(
      builder: (innerContext) => IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: () {
          Scaffold.of(innerContext).openDrawer();
        },
      ),
    );
  }

  Future<void> _handleNavigation(BuildContext context, String route) async {
    if (onMenuItemTap != null) {
      onMenuItemTap!();
    }

    if (route.startsWith('http://') || route.startsWith('https://')) {
      final Uri url = Uri.parse(route);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
      }
    } else {
      Navigator.pushNamed(context, route);
    }
  }
}

// ==========================================
// NAVIGATION WIDGETS
// ==========================================

class _NavItem extends StatelessWidget {
  final String label;final IconData? icon;final VoidCallback onTap;

  const _NavItem({required this.label, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 22, color: Colors.brown.shade800),
              const SizedBox(width: 6),
            ],
            Text(label, style: GoogleFonts.arvo(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.brown.shade800)),
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
      backgroundColor: Colors.white,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          children: [
            _buildLogo(context),
            const Divider(),
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
          ExpansionTile(
            leading: navItem.icon != null
                ? Icon(navItem.icon, color: Colors.brown.shade800)
                : null,
            title: Text(navItem.label, style: GoogleFonts.cabin(fontSize: 18, fontWeight: FontWeight.w500, color: const Color(0xFF276B5A),)),
            children: shopItems.map((category) {
              return ExpansionTile(
                tilePadding: const EdgeInsets.only(left: 24),
                title: Text(category.title, style: GoogleFonts.cabin(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
                children: category.subItems.map((subItem) {
                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 40),
                    leading: subItem.icon != null
                        ? Icon(subItem.icon, size: 18, color: const Color(0xFF276B5A))
                        : null,
                    title: Text(
                      subItem.label,
                      style: GoogleFonts.cabin(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4A4A4A),
                      ),
                    ),
                    onTap: () => _handleNavigation(context, subItem.route),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        );
        items.add(const SizedBox(height: 8));
      } else {
        items.add(
          ListTile(
            leading: navItem.icon != null
                ? Icon(navItem.icon, color: const Color(0xFF276B5A))
                : null,
            title: Text(
              navItem.label,
              style: GoogleFonts.arvo(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF276B5A),
              ),
            ),
            onTap: () => _handleNavigation(context, navItem.route),
          ),
        );
        items.add(const SizedBox(height: 8));
      }
    }

    return items;
  }

  Future<void> _handleNavigation(BuildContext context, String route) async {
    if (onItemTap != null) {
      onItemTap!();
    }
    Navigator.pop(context); // Close Drawer

    if (route.startsWith('http://') || route.startsWith('https://')) {
      final Uri url = Uri.parse(route);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
      }
    } else {
      Navigator.pushNamed(context, route);
    }
  }
}

// ==========================================
// LOGO WIDGET
// ==========================================

Widget _buildLogo(BuildContext context) {
  return SizedBox(
    height: 72,
    child: InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
      },
      child: Image.asset("assets/images/bindu.png"),
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

  // Track if the animation has already been triggered
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    // Duration normalized to 1 second for a smooth staggered reveal
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // 1. Logo & Title (Top -> Bottom)
    _logoAnim = Tween<Offset>(
      begin: const Offset(0.0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    ));

    // 2. Address (Left -> Right)
    _addressAnim = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    ));

    // 3. Phone (Left -> Right)
    _phoneAnim = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    ));

    // 4. Email (Left -> Right)
    _emailAnim = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
    ));

    // 5. Working Hours (Right -> Left)
    _workingHoursAnim = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    ));

    // Note: _controller.forward() removed from here so it waits for scroll visibility
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
        // Trigger animation when at least 10% of the footer is scrolled into view
        if (info.visibleFraction > 0.1 && !_hasAnimated) {
          _hasAnimated = true;
          _controller.forward();
        }
      },
      child: Container(
        width: double.infinity,
        color: const Color(0xFF276B5A),
        padding: EdgeInsets.symmetric(
          vertical: 40.0,
          horizontal: isDesktop ? 60.0 : 24.0,
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
            const SizedBox(height: 30),
            _buildContactSection(addressText, emailText, phoneText),
            const SizedBox(height: 30),
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
            height: 90,
            width: 135,
            child: Image.asset(
              "assets/images/bindu.png",
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white70, width: 2),
                ),
                child: const Center(
                  child: Text("BINDU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text("BINDU DECOR", style: GoogleFonts.cabin(color: Colors.white, fontSize: 16, letterSpacing: 2, fontWeight: FontWeight.w600)),
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
          style: GoogleFonts.cabin(
            color: const Color(0xFFD4B16A),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        SlideTransition(
          position: _addressAnim,
          child: InkWell(
            onTap: () => _launchMapUrl(address),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address,
                    style: GoogleFonts.cabin(
                      color: Colors.white,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SlideTransition(
          position: _phoneAnim,
          child: InkWell(
            onTap: () => _launchPhoneUrl(phone),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: Icon(Icons.phone_outlined, color: Colors.white70, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    phone,
                    style: GoogleFonts.cabin(
                      color: Colors.white,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SlideTransition(
          position: _emailAnim,
          child: InkWell(
            onTap: () => _launchEmailUrl(email),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: Icon(Icons.email_outlined, color: Colors.white70, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    email,
                    style: GoogleFonts.cabin(
                      color: Colors.white,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white54,
                    ),
                  ),
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
            style: GoogleFonts.cabin(
              color: const Color(0xFFD4B16A),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "10:30 AM to 7:00 PM IST | Mon - Sat",
            style: GoogleFonts.cabin(color: Colors.white70, fontSize: 15),
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

  const Color primaryColor = Color(0xFF276B5A);
  const Color goldAccent = Color(0xFFC89D52);

  InputDecoration buildInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: primaryColor),
      labelStyle: GoogleFonts.cabin(color: Colors.black87, fontSize: 13),
      hintStyle: GoogleFonts.cabin(color: Colors.black38, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  // Submit form via HTTP API Call
  Future<void> sendInquiryApi(StateSetter setDialogState) async {
    if (!formKey.currentState!.validate()) return;

    setDialogState(() {
      isLoading = true;
    });

    final String generatedReqId =
        'BD-${DateTime.now().millisecondsSinceEpoch}';

    final Uri apiUrl = Uri.parse(
      'http://192.168.1.10/bindu_decor/send_inquiry.php',
    );

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

      debugPrint('================ INQUIRY API ================');
      debugPrint('URL: $apiUrl');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');
      debugPrint('================================================');

      if (!context.mounted) return;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        setDialogState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Server Error ${response.statusCode}: ${response.body}',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );

        return;
      }

      Map<String, dynamic> responseData;

      try {
        responseData = jsonDecode(response.body);
      } catch (jsonError) {
        debugPrint('JSON ERROR: $jsonError');
        debugPrint('RAW RESPONSE: ${response.body}');

        setDialogState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Server returned an invalid response. Check PHP error.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );

        return;
      }

      if (responseData['success'] == true) {
        if (!context.mounted) return;

        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ??
                  'Inquiry submitted successfully!',
            ),
            backgroundColor: primaryColor,
          ),
        );
      } else {
        setDialogState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ??
                  'Unable to submit inquiry.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } on TimeoutException catch (e) {
      debugPrint('TIMEOUT ERROR: $e');

      if (!context.mounted) return;

      setDialogState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Request timed out. Check whether the PHP server is running.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } on SocketException catch (e) {
      debugPrint('SOCKET ERROR: $e');

      if (!context.mounted) return;

      setDialogState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cannot connect to PHP server. Check IP address and Apache.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('GENERAL ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');

      if (!context.mounted) return;

      setDialogState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Connection Error: $e',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // Open WhatsApp directly with Price Request Message
  Future<void> openWhatsApp() async {
    const String phoneNumber = '919586518360';
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
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    decoration: const BoxDecoration(color: primaryColor),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 24),
                            const Icon(
                              Icons.mark_email_read_outlined,
                              size: 38,
                              color: Colors.white,
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
                        Text(
                          'Inquiry Form',
                          style: GoogleFonts.cabin(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tell us your location & preferred style. Our design experts will recommend tailored solutions for you.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cabin(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.85),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form
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
                            style: GoogleFonts.cabin(fontSize: 14, color: Colors.black87),
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
                            style: GoogleFonts.cabin(fontSize: 14, color: Colors.black87),
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
                            style: GoogleFonts.cabin(fontSize: 14, color: Colors.black87),
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
                            style: GoogleFonts.cabin(fontSize: 14, color: Colors.black87),
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
                            style: GoogleFonts.cabin(fontSize: 14, color: Colors.black87),
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

                          // Actions Row (Send Inquiry & WhatsApp Buttons)
                          Row(
                            children: [
                              // Send Inquiry Button
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : () => sendInquiryApi(setDialogState),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: goldAccent,
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                          'Send Inquiry',
                                          style: GoogleFonts.cabin(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(Icons.send_rounded, size: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),

                              // WhatsApp Button
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: openWhatsApp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.chat_bubble_outline, size: 18),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Ask Price',
                                          style: GoogleFonts.cabin(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
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