import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Nav_Widgets/Navigation.dart'; // Ensure Navigation.dart contains NavHeader and BinduFooter widgets

class ImageDetail {
  final String imageUrl;
  final String? title;
  final String? description;

  const ImageDetail({
    required this.imageUrl,
    this.title,
    this.description,
  });
}

class DecorProductItem {
  final String title;
  final String category;
  final List<ImageDetail>? imageDetails;
  final List<String> imageUrls;
  final String description;
  final String? material;
  final String? printType;

  const DecorProductItem({
    required this.title,
    this.category = "HOME DECOR",
    this.imageDetails,
    required this.imageUrls,
    required this.description,
    this.material = "Premium Grade Material",
    this.printType = "High Definition Digital Print / Finish",
  });

  factory DecorProductItem.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['imageUrls'] != null && json['imageUrls'] is List) {
      images = List<String>.from(json['imageUrls']);
    } else if (json['image_urls'] != null && json['image_urls'] is List) {
      images = List<String>.from(json['image_urls']);
    } else if (json['image_url'] != null) {
      images = [json['image_url'].toString()];
    }

    return DecorProductItem(
      title: json['title'] ?? '',
      category: json['category'] ?? 'HOME DECOR',
      imageUrls: images,
      description: json['description'] ?? '',
      material: json['material'] ?? 'Premium Grade Material',
      printType: json['printType'] ?? json['print_type'] ?? 'High Definition Digital Print / Finish',
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final DecorProductItem item;
  final int initialImageIndex;

  const ProductDetailPage({
    super.key,
    required this.item,
    this.initialImageIndex = 0,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late int _selectedImageIndex;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedImageIndex = widget.initialImageIndex;
  }

  Widget _buildProductImage(String path) {
    if (path.isEmpty) {
      return Container(
        color: const Color(0xFFF2F2F2),
        child: const Center(
          child: Icon(CupertinoIcons.photo, color: Colors.grey, size: 48),
        ),
      );
    }
    return Image.network(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => Container(
        color: const Color(0xFFF2F2F2),
        child: const Center(
          child: Icon(CupertinoIcons.photo, color: Colors.grey, size: 48),
        ),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: const Color(0xFFF2F2F2),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF276B5A)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF276B5A)),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.cabin(fontSize: 14, color: Colors.black87),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value ?? "N/A"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'WALLPAPERS':
        return Colors.purple.shade500;
      case 'FLOORINGS':
        return Colors.brown.shade500;
      case 'CARPETS':
        return Colors.teal.shade500;
      case 'BLINDS':
        return Colors.deepOrange.shade500;
      case 'GLASS FILMS':
        return Colors.blue.shade500;
      case 'ARTIFICIAL TURFS':
        return Colors.indigo.shade500;
      case 'GYM FLOORINGS':
        return Colors.red.shade500;
      case 'AWNINGS':
        return Colors.amber.shade700;
      case 'MOSQUITO NETS':
        return Colors.green.shade500;
      case 'UPHOLSTERY':
        return Colors.grey.shade700;
      case 'CURTAINS':
        return Colors.cyan.shade500;
      case 'STRETCH CEILINGS':
        return Colors.lime.shade700;
      default:
        return const Color(0xFF276B5A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    // 1. Resolve current selected ImageDetail
    final ImageDetail? currentImageDetail = (widget.item.imageDetails != null &&
        _selectedImageIndex < widget.item.imageDetails!.length)
        ? widget.item.imageDetails![_selectedImageIndex]
        : null;

    // 2. Resolve image list (prefer imageDetails over imageUrls)
    final List<String> availableImageUrls = widget.item.imageDetails != null &&
        widget.item.imageDetails!.isNotEmpty
        ? widget.item.imageDetails!.map((e) => e.imageUrl).toList()
        : widget.item.imageUrls;

    // 3. Fallback logic for title, image URL, and description
    final String currentImageUrl = currentImageDetail?.imageUrl ??
        (availableImageUrls.isNotEmpty ? availableImageUrls[_selectedImageIndex] : '');

    final String currentTitle = currentImageDetail?.title ?? widget.item.title;

    final String currentDescription = currentImageDetail?.description ?? widget.item.description;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          currentTitle,
          style: GoogleFonts.cormorantGaramond(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Page Body Content Container
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? screenWidth * 0.1 : 16.0,
                vertical: 24.0,
              ),
              child: Flex(
                direction: isDesktop ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- LEFT / TOP: MAIN IMAGE & THUMBNAILS ---
                  Flexible(
                    flex: isDesktop ? 1 : 0,
                    child: Column(
                      children: [
                        Container(
                          height: isDesktop ? 420 : 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xFFF5F5F5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: _buildProductImage(currentImageUrl),
                          ),
                        ),
                        if (availableImageUrls.length > 1) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: availableImageUrls.length,
                              itemBuilder: (context, index) {
                                final isSelected = index == _selectedImageIndex;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImageIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF276B5A)
                                            : Colors.transparent,
                                        width: 2.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: _buildProductImage(availableImageUrls[index]),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  if (isDesktop) const SizedBox(width: 36) else const SizedBox(height: 24),

                  // --- RIGHT / BOTTOM: PRODUCT DETAILS & SPECS ---
                  Flexible(
                    flex: isDesktop ? 1 : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: getCategoryColor(widget.item.category).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.item.category.toUpperCase(),
                            style: GoogleFonts.cabin(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: getCategoryColor(widget.item.category),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Title
                        Text(
                          currentTitle,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Divider(color: Color(0xFFE5E7EB), thickness: 1),
                        const SizedBox(height: 14),

                        // Description Section
                        Text(
                          "Description",
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF276B5A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentDescription,
                          maxLines: _isExpanded ? null : 4,
                          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                          style: GoogleFonts.cabin(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                        if (currentDescription.length > 100)
                          GestureDetector(
                            onTap: () => setState(() => _isExpanded = !_isExpanded),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Text(
                                _isExpanded ? "Show Less" : "Show More",
                                style: GoogleFonts.cabin(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF276B5A),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 14),
                        const Divider(color: Color(0xFFE5E7EB), thickness: 1),
                        const SizedBox(height: 16),

                        // Specifications
                        Text(
                          "Product Specifications",
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          CupertinoIcons.photo,
                          "Variant / View",
                          "Image ${_selectedImageIndex + 1} of ${availableImageUrls.length}",
                        ),
                        _buildDetailRow(
                          CupertinoIcons.layers,
                          "Material",
                          widget.item.material,
                        ),
                        _buildDetailRow(
                          CupertinoIcons.printer,
                          "Print / Finish Type",
                          widget.item.printType,
                        ),

                        const SizedBox(height: 28),

                        // Inquiry Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF276B5A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => showContactFormDialog(context),
                            icon: const Icon(CupertinoIcons.mail_solid, size: 20),
                            label: Text(
                              "Inquire For Details",
                              style: GoogleFonts.cabin(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Navigation/Footer widget embedded at the bottom
            const BinduFooter(),
          ],
        ),
      ),
    );
  }
}