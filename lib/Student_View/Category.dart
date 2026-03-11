import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Constants (shared with home_page.dart) ───────────────────────────────────
const kNavy     = Color(0xFF1A2D5A);
const kBgGrey   = Color(0xFFF4F6FA);
const kTextGrey = Color(0xFF9AA0AE);
const kBorder   = Color(0xFFDDE2EF);

// ─── Entry point (standalone test) ───────────────────────────────────────────
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CategoryPage(),
  ));
}

// ─── Data model ───────────────────────────────────────────────────────────────
class CategoryItem {
  final String label;
  final IconData icon;
  const CategoryItem({required this.label, required this.icon});
}

const List<CategoryItem> _categories = [
  CategoryItem(label: 'Medicine',   icon: Icons.medication_outlined),
  CategoryItem(label: 'Lab Test',   icon: Icons.biotech_outlined),
  CategoryItem(label: 'Healthcare', icon: Icons.local_hospital_outlined),
  CategoryItem(label: 'Best Offer', icon: Icons.local_offer_outlined),
  CategoryItem(label: 'Medicine',   icon: Icons.medication_outlined),
  CategoryItem(label: 'Medicine',   icon: Icons.medication_outlined),
  CategoryItem(label: 'Lab Test',   icon: Icons.biotech_outlined),
  CategoryItem(label: 'Healthcare', icon: Icons.local_hospital_outlined),
  CategoryItem(label: 'Best Offer', icon: Icons.local_offer_outlined),
];

// ─── Category Page ────────────────────────────────────────────────────────────
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 20,
            childAspectRatio: 0.82,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) =>
              _CategoryTile(item: _categories[index]),
        ),
      ),
    );
  }

  // ─── Navy AppBar with white back arrow & title ─────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kNavy,
      elevation: 0,
      // Makes the status bar icons white on the navy background
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: kNavy,
        statusBarIconBrightness: Brightness.light,  // Android
        statusBarBrightness: Brightness.dark,        // iOS
      ),
      leading: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
      ),
      title: const Text(
        'Category',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      centerTitle: false,
    );
  }
}

// ─── Single Category Tile ─────────────────────────────────────────────────────
class _CategoryTile extends StatelessWidget {
  final CategoryItem item;
  const _CategoryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon box
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kBorder, width: 1.4),
              boxShadow: [
                BoxShadow(
                  color: kNavy.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(item.icon, color: kNavy, size: 28),
          ),
          const SizedBox(height: 7),
          // Label
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: kNavy,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}