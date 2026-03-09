import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Constants ────────────────────────────────────────────────────────────────
const kNavy     = Color(0xFF1A2D5A);
const kBgGrey   = Color(0xFFF0F3FA);
const kTextGrey = Color(0xFF9AA3B8);
const kBorder   = Color(0xFFDDE2EF);
const kGreen    = Color(0xFF27AE75);

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DoctorProfilePage(),
    ));

// ─── Doctor Profile Page ──────────────────────────────────────────────────────
class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});
  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  bool _overviewExpanded = false;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(child: _buildBody()),
              ],
            ),
          ),
          _buildRequestButton(),
        ],
      ),
    );
  }

  // ─── Sliver App Bar with hero image area ────────────────────────────────
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeroSection(),
      ),
      // Minimal transparent top bar with back + action icons
      title: null,
      bottom: PreferredSize(
        preferredSize: Size.zero,
        child: const SizedBox.shrink(),
      ),
    );
  }

  // ─── Hero Section (grey bg + image + stat cards) ─────────────────────────
  Widget _buildHeroSection() {
    return Stack(
      children: [
        // Grey background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: kBgGrey,
        ),

        // Top bar icons (back, heart, refresh)
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: const Icon(Icons.chevron_left,
                      color: kNavy, size: 28),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          setState(() => _isFavorite = !_isFavorite),
                      child: Icon(
                        _isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : kNavy,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.refresh_rounded,
                        color: kNavy, size: 24),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Doctor image placeholder (centered-left)
        Positioned(
          left: 40,
          bottom: 30,
          child: Column(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kBorder, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: kNavy.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back square (offset)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: kBgGrey,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: kBorder),
                        ),
                      ),
                    ),
                    // Front square
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: kBgGrey.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: kBorder),
                        ),
                        child: const Icon(Icons.image_outlined,
                            color: kTextGrey, size: 28),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'No Image Preview',
                style: TextStyle(
                  fontSize: 10,
                  color: kTextGrey.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),

        // Stat cards (right side, stacked)
        Positioned(
          right: 24,
          top: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildStatCard(
                icon: Icons.people_alt_outlined,
                value: '500',
                label: 'Publications',
              ),
              const SizedBox(height: 10),
              _buildStatCard(
                icon: Icons.calendar_today_outlined,
                value: '5 Year',
                label: 'Experience',
              ),
              const SizedBox(height: 10),
              _buildStatCard(
                icon: Icons.star_border_rounded,
                value: '120',
                label: 'Citations',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      {required IconData icon,
      required String value,
      required String label}) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
        boxShadow: [
          BoxShadow(
            color: kNavy.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: kNavy.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: kNavy, size: 17),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: kNavy,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              Text(label,
                  style:
                      const TextStyle(color: kTextGrey, fontSize: 9.5)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Body Content ─────────────────────────────────────────────────────────
  Widget _buildBody() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role + Online
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Role',
                  style: TextStyle(
                      color: kNavy,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: kGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('Online',
                      style: TextStyle(
                          color: kGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Field button
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: kNavy,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Field Name',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 16),
          const Divider(color: kBorder, height: 1),
          const SizedBox(height: 12),

          // Overview accordion
          GestureDetector(
            onTap: () =>
                setState(() => _overviewExpanded = !_overviewExpanded),
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  const Icon(Icons.description_outlined,
                      color: kNavy, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Overview...',
                        style: TextStyle(
                            color: kNavy,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),
                  Icon(
                    _overviewExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: kTextGrey,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          // Overview expanded content
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _overviewExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12, left: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailText('Professional Role:', bold: true),
                  _buildDetailText('Professor'),
                  const SizedBox(height: 6),
                  _buildDetailText('Primary Field:', bold: true),
                  _buildDetailText('Health & Life Sciences'),
                  const SizedBox(height: 6),
                  _buildDetailText('Sub-Discipline:', bold: true),
                  _buildDetailText('any....'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Overview details (always visible below accordion)
          _buildDetailText('Professional Role:', bold: true),
          _buildDetailText('Professor'),
          const SizedBox(height: 6),
          _buildDetailText('Primary Field:', bold: true),
          _buildDetailText('Health & Life Sciences'),
          const SizedBox(height: 6),
          _buildDetailText('Sub-Discipline:', bold: true),
          _buildDetailText('any....'),

          const SizedBox(height: 20),
          const Divider(color: kBorder, height: 1),
          const SizedBox(height: 16),

          // Location / Region / Language row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLocationStat(value: 'BH', label: 'Country'),
              _buildVertDivider(),
              _buildLocationStat(value: 'Manama', label: 'State/Region'),
              _buildVertDivider(),
              _buildLocationStat(value: 'Arabic', label: 'Language'),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDetailText(String text, {bool bold = false}) {
    return Text(
      text,
      style: TextStyle(
        color: bold ? kNavy : kTextGrey,
        fontSize: 13,
        fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        height: 1.5,
      ),
    );
  }

  Widget _buildLocationStat(
      {required String value, required String label}) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: kNavy,
                fontWeight: FontWeight.w700,
                fontSize: 14)),
        const SizedBox(height: 3),
        Text(label,
            style:
                const TextStyle(color: kTextGrey, fontSize: 11)),
      ],
    );
  }

  Widget _buildVertDivider() =>
      Container(width: 1, height: 28, color: kBorder);

  // ─── Request Button ────────────────────────────────────────────────────────
  Widget _buildRequestButton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: kNavy,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Request',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}