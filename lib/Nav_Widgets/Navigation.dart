import 'package:bindu_decor/Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                        style: GoogleFonts.cabin(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: const Color(0xFF276B5A),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
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
                              Icon(subItem.icon, size: 18, color: const Color(0xFF276B5A)),
                              const SizedBox(width: 10),
                            ],
                            Text(
                              subItem.label,
                              style: GoogleFonts.cabin(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4A4A4A),
                              ),
                            ),
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
                    style: GoogleFonts.cabin(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF276B5A),
                    ),
                  ),
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
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    this.icon,
    required this.onTap,
  });

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
              Icon(icon, size: 20, color: const Color(0xFF276B5A)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.cabin(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF276B5A),
              ),
            ),
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
                ? Icon(navItem.icon, color: const Color(0xFF276B5A))
                : null,
            title: Text(
              navItem.label,
              style: GoogleFonts.cabin(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF276B5A),
              ),
            ),
            children: shopItems.map((category) {
              return ExpansionTile(
                tilePadding: const EdgeInsets.only(left: 24),
                title: Text(
                  category.title,
                  style: GoogleFonts.cabin(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF276B5A),
                  ),
                ),
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
              style: GoogleFonts.cabin(
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
                  child: Text(
                    "BINDU",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "BINDU DECOR",
            style: GoogleFonts.cabin(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
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