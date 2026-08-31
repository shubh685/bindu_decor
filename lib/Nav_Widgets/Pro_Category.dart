// product_category.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../API_Services/View_Api.dart';
import '../Pro_Details.dart';


class ProductCategoryPage extends StatefulWidget {
  final String category;

  const ProductCategoryPage({super.key, required this.category});

  @override
  State<ProductCategoryPage> createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  bool _isLoading = true;
  List<DecorProductItem> _items = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final fetched = await ApiService.fetchProductsByCategory(widget.category);
    setState(() {
      _items = fetched;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth < 600 ? 1 : (screenWidth < 900 ? 2 : 3);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category, style: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth > 900 ? 40.0 : 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.category, style: GoogleFonts.cormorantGaramond(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF276B5A))),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: _items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 24,
                    mainAxisExtent: 520,
                  ),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return _CategoryProductCard(item: item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryProductCard extends StatelessWidget {
  final DecorProductItem item;
  const _CategoryProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final String image = item.imageUrls.isNotEmpty ? item.imageUrls.first : '';
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (_) => ProductDetailPage(item: item),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Container(
                color: const Color(0xFFF5F5F5),
                width: double.infinity,
                child: image.isNotEmpty
                    ? Image.network(image, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported))
                    : const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.cormorantGaramond(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(child: SizedBox()),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF276B5A), borderRadius: BorderRadius.circular(4)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.touch_app_outlined, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text("Inquire", style: GoogleFonts.cabin(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}