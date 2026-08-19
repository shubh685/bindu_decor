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

class BinduNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final List<NavItem> navItems;
  final List<NestedMenuItem> shopItems;
  final VoidCallback? onMenuItemTap;

  const BinduNavigationBar({
    super.key,
    required this.navItems,
    required this.shopItems,
    this.onMenuItemTap,
  });

  // Gives Scaffold/AppBar a safe default height to avoid vertical bounding conflicts
  @override
  Size get preferredSize => const Size.fromHeight(85.0);

  String _getCurrentViewLabel(String? currentRoute) {
    if (currentRoute == null || currentRoute.isEmpty) return 'Home';

    // Check defined static nav items first
    for (var item in navItems) {
      if (item.route == currentRoute) return item.label;
    }

    // Check shop category items
    for (var group in shopItems) {
      for (var sub in group.subItems) {
        if (sub.route == currentRoute) return '${group.title} › ${sub.label}';
      }
    }

    // If route is a custom string (e.g. "Projects > Villa Velloze"), return it directly
    if (currentRoute.contains('>')) {
      return currentRoute;
    }

    return currentRoute.replaceAll('/', '');
  }
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    final String currentViewLabel = _getCurrentViewLabel(currentRoute);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24.0 : 16.0,
        vertical: 4.0,
      ),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildLogo(context, isDesktop),
                      const SizedBox(width: 12),
                      if (isDesktop)
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _buildDesktopNav(context, currentRoute),
                          ),
                        )
                      else
                        _buildMobileMenuButton(context),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Current View Badge
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(
                      color: LuxuryTheme.primaryDark.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.remove_red_eye_outlined, size: 11, color: LuxuryTheme.primaryAccent),
                        const SizedBox(width: 4),
                        Text('CURRENT VIEW: ', style: GoogleFonts.cinzel(fontSize: 11.8, fontWeight: FontWeight.bold, color: LuxuryTheme.textMuted, letterSpacing: 1.0,)),
                        Flexible(
                          child: Text(currentViewLabel.toUpperCase(), overflow: TextOverflow.ellipsis, style: GoogleFonts.cinzel(fontSize: 11.8, fontWeight: FontWeight.w700, color: LuxuryTheme.primaryDark, letterSpacing: 1.1)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Responsive Logo Helper
  Widget _buildLogo(BuildContext context, bool isDesktop) {
    return SizedBox(
      height: isDesktop ? 42 : 34,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        child: Image.asset("assets/images/bindu.png", fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildDesktopNav(BuildContext context, String? currentRoute) {
    List<Widget> navWidgets = [];

    for (var item in navItems) {
      if (item.label.toLowerCase() == 'shop') {
        bool isShopActive = shopItems.any(
              (group) => group.subItems.any((sub) => sub.route == currentRoute),
        );

        navWidgets.add(
          PopupMenuButton<String>(
            offset: const Offset(0, 40),
            elevation: 12,
            shadowColor: Colors.black.withOpacity(0.15),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tooltip: item.label,
            onSelected: (value) => _handleNavigation(context, value),
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<String>> menuEntries = [];
              for (var shopGroup in shopItems) {
                if (shopGroup.subItems.isNotEmpty) {
                  menuEntries.add(
                    PopupMenuItem<String>(
                      enabled: false,
                      child: Text(
                        shopGroup.title.toUpperCase(),
                        style: GoogleFonts.cormorantGaramond(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          letterSpacing: 2.0,
                          color: LuxuryTheme.primaryAccent,
                        ),
                      ),
                    ),
                  );

                  for (var subItem in shopGroup.subItems) {
                    final bool isSubSelected = subItem.route == currentRoute;
                    menuEntries.add(
                      PopupMenuItem<String>(
                        value: subItem.route,
                        height: 38,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSubSelected
                                ? LuxuryTheme.primaryDark.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              if (subItem.icon != null) ...[
                                Icon(
                                  subItem.icon,
                                  size: 16,
                                  color: isSubSelected
                                      ? LuxuryTheme.primaryAccent
                                      : LuxuryTheme.primaryDark,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                subItem.label,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: isSubSelected
                                      ? FontWeight.w800
                                      : FontWeight.w700,
                                  color: isSubSelected
                                      ? LuxuryTheme.primaryDark
                                      : LuxuryTheme.textDark,
                                ),
                              ),
                            ],
                          ),
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
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              decoration: BoxDecoration(
                color: isShopActive
                    ? LuxuryTheme.primaryDark
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isShopActive
                      ? LuxuryTheme.primaryAccent
                      : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.icon != null) ...[
                    Icon(
                      item.icon,
                      size: 14,
                      color: isShopActive
                          ? LuxuryTheme.primaryAccent
                          : LuxuryTheme.primaryDark,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    item.label.toUpperCase(),
                    style: GoogleFonts.cinzel(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: isShopActive
                          ? Colors.white
                          : LuxuryTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: isShopActive
                        ? LuxuryTheme.primaryAccent
                        : LuxuryTheme.primaryDark,
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        final bool isSelected = item.route == currentRoute;
        navWidgets.add(
          _NavItem(
            label: item.label,
            icon: item.icon,
            isSelected: isSelected,
            onTap: () => _handleNavigation(context, item.route),
          ),
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: navWidgets.map((widget) {
          return Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: widget,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileMenuButton(BuildContext context) {
    return Builder(
      builder: (innerContext) => IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(
          Icons.menu_rounded,
          color: LuxuryTheme.primaryDark,
          size: 26,
        ),
        onPressed: () {
          Scaffold.of(innerContext).openDrawer();
        },
      ),
    );
  }

  Future<void> _handleNavigation(BuildContext context, String route) async {
    await NavigationHandler.handleNavigation(
      context,
      route,
      onTap: onMenuItemTap,
    );
  }
}

// ==========================================
// REUSABLE NAVIGATION HANDLER
// ==========================================

class NavigationHandler {
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
      final String? currentRoute = ModalRoute.of(context)?.settings.name;
      if (currentRoute != route) {
        Navigator.pushNamed(context, route);
      }
    }
  }

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
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    this.icon,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? LuxuryTheme.primaryDark : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? LuxuryTheme.primaryAccent
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? LuxuryTheme.primaryAccent
                    : LuxuryTheme.primaryDark,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label.toUpperCase(),
              style: GoogleFonts.cinzel(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: isSelected ? Colors.white : LuxuryTheme.primaryDark,
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
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

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
            ..._buildDrawerItems(context, currentRoute),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDrawerItems(
      BuildContext context,
      String? currentRoute,
      ) {
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
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: LuxuryTheme.primaryDark,
                ),
              ),
              children: shopItems.map((category) {
                return ExpansionTile(
                  tilePadding: const EdgeInsets.only(left: 20),
                  title: Text(
                    category.title.toUpperCase(),
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: LuxuryTheme.primaryAccent,
                    ),
                  ),
                  children: category.subItems.map((subItem) {
                    final bool isSubSelected = subItem.route == currentRoute;
                    return Container(
                      color: isSubSelected
                          ? LuxuryTheme.primaryDark.withOpacity(0.08)
                          : Colors.transparent,
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 36),
                        leading: subItem.icon != null
                            ? Icon(
                          subItem.icon,
                          size: 18,
                          color: isSubSelected
                              ? LuxuryTheme.primaryAccent
                              : LuxuryTheme.primaryDark,
                        )
                            : null,
                        title: Text(
                          subItem.label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: isSubSelected
                                ? FontWeight.w800
                                : FontWeight.w500,
                            color: isSubSelected
                                ? LuxuryTheme.primaryDark
                                : LuxuryTheme.textDark,
                          ),
                        ),
                        onTap: () => _handleNavigation(
                          context,
                          subItem.route,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        );
        items.add(const SizedBox(height: 4));
      } else {
        final bool isSelected = navItem.route == currentRoute;
        items.add(
          Container(
            decoration: BoxDecoration(
              color: isSelected ? LuxuryTheme.primaryDark : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: navItem.icon != null
                  ? Icon(
                navItem.icon,
                color: isSelected
                    ? LuxuryTheme.primaryAccent
                    : LuxuryTheme.primaryDark,
              )
                  : null,
              title: Text(
                navItem.label.toUpperCase(),
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: isSelected ? Colors.white : LuxuryTheme.primaryDark,
                ),
              ),
              onTap: () => _handleNavigation(context, navItem.route),
            ),
          ),
        );
        items.add(const SizedBox(height: 4));
      }
    }

    return items;
  }

  Future<void> _handleNavigation(BuildContext context, String route) async {
    await NavigationHandler.handleNavigation(
      context,
      route,
      onTap: onItemTap,
    );
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
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
          vertical: 24.0,
          horizontal: isDesktop ? 40.0 : 20.0,
        ),
        child: Column(
          children: [
            isDesktop
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildLogoSection()),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: _buildContactSection(addressText, emailText, phoneText),
                ),
                const SizedBox(width: 16),
                Expanded(flex: 3, child: _buildRightSection()),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogoSection(),
                const SizedBox(height: 20),
                _buildContactSection(addressText, emailText, phoneText),
                const SizedBox(height: 20),
                _buildRightSection(),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.15), height: 1),
            const SizedBox(height: 16),
            // ==========================================
            // CENTERED COPYRIGHT SECTION
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "© 2026 Bindu Decorators. All rights reserved. ",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "| Developed by Grow Socialee",
                  style: GoogleFonts.plusJakartaSans(
                    color: LuxuryTheme.primaryAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
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
            height: 55,
            width: 100,
            child: Image.asset(
              "assets/images/bindu.png",
              errorBuilder: (context, error, stackTrace) => Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: LuxuryTheme.primaryAccent, width: 2),
                ),
                child: const Center(
                  child: Text("BINDU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text("BINDU DÉCOR", style: GoogleFonts.cormorantGaramond(color: Colors.white, fontSize: 18, letterSpacing: 2.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text("Curating Luxury Living Spaces", style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 11)),
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
          style: GoogleFonts.cormorantGaramond(color: LuxuryTheme.primaryAccent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        const SizedBox(height: 10),
        SlideTransition(
          position: _addressAnim,
          child: InkWell(
            onTap: () => _launchMapUrl(address),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 1.0),
                  child: Icon(Icons.location_on_outlined, color: LuxuryTheme.primaryAccent, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(address, style: GoogleFonts.plusJakartaSans(color: Colors.white.withOpacity(0.9), fontSize: 12, height: 1.4, decorationColor: Colors.white38)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SlideTransition(
          position: _phoneAnim,
          child: InkWell(
            onTap: () => _launchPhoneUrl(phone),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 1.0),
                  child: Icon(Icons.phone_outlined, color: LuxuryTheme.primaryAccent, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(phone, style: GoogleFonts.plusJakartaSans(color: Colors.white.withOpacity(0.9), fontSize: 12, decorationColor: Colors.white38)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SlideTransition(
          position: _emailAnim,
          child: InkWell(
            onTap: () => _launchEmailUrl(email),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 1.0),
                  child: Icon(Icons.email_outlined, color: LuxuryTheme.primaryAccent, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(email, style: GoogleFonts.plusJakartaSans(color: Colors.white.withOpacity(0.9), fontSize: 12, decorationColor: Colors.white38)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchSocialUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
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
            style: GoogleFonts.cinzel(color: LuxuryTheme.primaryAccent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 10),
          Text(
            "10:30 AM to 7:00 PM IST | Mon - Sat",
            style: GoogleFonts.plusJakartaSans(color: Colors.white.withOpacity(0.85), fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 14),
          Text("FOLLOW US", style: GoogleFonts.cinzel(color: LuxuryTheme.primaryAccent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSocialIconButton(
                icon: FontAwesomeIcons.facebookF,
                url: 'https://www.facebook.com/people/Bindu-decorators/100054549485306/',
              ),
              const SizedBox(width: 8),
              _buildSocialIconButton(
                icon: FontAwesomeIcons.instagram,
                url: 'https://www.instagram.com/bindudecor/?hl=hi',
              ),
              const SizedBox(width: 8),
              _buildSocialIconButton(
                icon: FontAwesomeIcons.linkedinIn,
                url: 'https://in.linkedin.com/company/bindu-decorators',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIconButton({required IconData icon, required String url}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchSocialUrl(url),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: LuxuryTheme.primaryAccent, width: 1.2),
            color: Colors.white.withOpacity(0.05),
          ),
          child: Center(
            child: FaIcon(icon, size: 14, color: Colors.white),
          ),
        ),
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
    const String rawPhoneNumber = '919930098219';

    final String name = nameController.text.trim();
    final String location = locationController.text.trim();

    String message = 'Hello Bindu Decor Team,\nI would like to ask for the price details regarding *$selectedDesignType*.';
    if (name.isNotEmpty) message += '\nName: $name';
    if (location.isNotEmpty) message += '\nLocation: $location';

    final String encodedMessage = Uri.encodeComponent(message);

    final Uri httpsUri = Uri.parse('https://wa.me/$rawPhoneNumber?text=$encodedMessage');
    final Uri nativeUri = Uri.parse('whatsapp://send?phone=$rawPhoneNumber&text=$encodedMessage');

    try {
      if (await canLaunchUrl(nativeUri)) {
        await launchUrl(nativeUri);
      } else if (await canLaunchUrl(httpsUri)) {
        await launchUrl(
          httpsUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open WhatsApp. Please check if WhatsApp is installed.'),
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
                        Text('DESIGN CONSULTATION', style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w700, color: LuxuryTheme.primaryAccent, letterSpacing: 2.0)),
                        const SizedBox(height: 4),
                        Text('Get In Touch With Us', style: GoogleFonts.cormorantGaramond(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(height: 8),
                        Text(
                          'Tell us your location & preferred style. Our design experts will recommend tailored solutions for you.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white.withOpacity(0.85), height: 1.4),
                        ),
                      ],
                    ),
                  ),
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
                                          style: GoogleFonts.cormorantGaramond(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.white),
                                        ),
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
  Future<void> navigateTo(String route, {VoidCallback? onTap}) {
    return NavigationHandler.handleNavigation(this, route, onTap: onTap);
  }

  bool isCurrentRoute(String route) {
    return ModalRoute.of(this)?.settings.name == route;
  }
}