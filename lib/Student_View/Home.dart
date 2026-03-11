import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}

// ─── Constants ───────────────────────────────────────────────────────────────
const kNavy = Color(0xFF1A2D5A);
const kNavyLight = Color(0xFF243A6B);
const kBgGrey = Color(0xFFF4F6FA);
const kCardGrey = Color(0xFFEEF0F5);
const kTextGrey = Color(0xFF9AA0AE);
const kGreen = Color(0xFF2ECC71);

// ─── Home Page ────────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGrey,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildCategorySection(),
                    const SizedBox(height: 20),
                    _buildTopDoctorSection(),
                    const SizedBox(height: 20),
                    _buildPostSection(),
                    const SizedBox(height: 20),
                    _buildDoctorsSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: kNavy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Fatima Matrook',
                  style: TextStyle(
                    color: kNavy,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              _iconButton(Icons.notifications_outlined),
              const SizedBox(width: 8),
              _iconButton(Icons.tune_outlined),
            ],
          ),
          const SizedBox(height: 12),
          // Search bar
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: kBgGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                SizedBox(width: 12),
                Icon(Icons.search, color: kTextGrey, size: 20),
                SizedBox(width: 8),
                Text('Search', style: TextStyle(color: kTextGrey, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: kBgGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: kNavy, size: 20),
    );
  }

  // ─── Category Section ──────────────────────────────────────────────────────
  Widget _buildCategorySection() {
    final categories = [
      {'icon': Icons.medication_outlined, 'label': 'Medicine'},
      {'icon': Icons.biotech_outlined, 'label': 'Lab Test'},
      {'icon': Icons.local_hospital_outlined, 'label': 'Healthcare'},
      {'icon': Icons.local_offer_outlined, 'label': 'Best Offer'},
      {'icon': Icons.favorite_outline, 'label': 'Wellness'},
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Category',
                style: TextStyle(
                    color: kNavy, fontWeight: FontWeight.w700, fontSize: 16)),
            Text('See all',
                style: TextStyle(
                    color: kNavy.withOpacity(0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final cat = categories[i];
              return Column(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: kNavy.withOpacity(0.07),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(cat['icon'] as IconData, color: kNavy, size: 26),
                  ),
                  const SizedBox(height: 6),
                  Text(cat['label'] as String,
                      style: const TextStyle(fontSize: 11, color: kNavy)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Top Doctor Section ────────────────────────────────────────────────────
  Widget _buildTopDoctorSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Top Doctor',
                style: TextStyle(
                    color: kNavy, fontWeight: FontWeight.w700, fontSize: 16)),
            Row(
              children: [
                Icon(Icons.format_list_bulleted, color: kNavy.withOpacity(0.5), size: 20),
                const SizedBox(width: 8),
                Icon(Icons.grid_view_rounded, color: kNavy, size: 20),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) => _buildDoctorCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorCard() {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kNavy.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: kCardGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person, color: kTextGrey, size: 24),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Role',
                        style: TextStyle(
                            color: kNavy,
                            fontWeight: FontWeight.w700,
                            fontSize: 12)),
                    Text('Location',
                        style: TextStyle(color: kTextGrey, fontSize: 10)),
                    Text('Degree',
                        style: TextStyle(color: kTextGrey, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 28,
            decoration: BoxDecoration(
              color: kNavy,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text('Field Name',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatMini(value: '10Y', label: 'Experience'),
              _StatMini(value: '306', label: 'Publications'),
              _StatMini(value: '148', label: 'Citations'),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Post Section ──────────────────────────────────────────────────────────
  Widget _buildPostSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Post',
            style: TextStyle(
                color: kNavy, fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 14),
        _buildPostCard(),
        const SizedBox(height: 12),
        _buildPostCard(),
      ],
    );
  }

  Widget _buildPostCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kNavy.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: kNavy,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Research',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                Row(
                  children: [
                    const Icon(Icons.favorite_border,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text('1k',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          // Content area with donut charts
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: kBgGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildDonutChart(0.7, kNavy),
                    const SizedBox(width: 12),
                    _buildDonutChart(0.45, kNavy.withOpacity(0.6)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: kNavy,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart(double progress, Color color) {
    return SizedBox(
      width: 52,
      height: 52,
      child: CustomPaint(
        painter: _DonutPainter(progress: progress, color: color),
      ),
    );
  }

  // ─── Doctors Section ───────────────────────────────────────────────────────
  Widget _buildDoctorsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Doctors',
                style: TextStyle(
                    color: kNavy, fontWeight: FontWeight.w700, fontSize: 16)),
            Text('See all',
                style: TextStyle(
                    color: kNavy.withOpacity(0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 14),
        _buildDoctorListCard(),
        const SizedBox(height: 12),
        _buildDoctorListCard(),
      ],
    );
  }

  Widget _buildDoctorListCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kNavy.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor image placeholder
              Container(
                width: 64,
                height: 80,
                decoration: BoxDecoration(
                  color: kCardGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: kTextGrey, size: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Role',
                            style: TextStyle(
                                color: kNavy,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: kGreen.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Online',
                              style: TextStyle(
                                  color: kGreen,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text('Location',
                        style: TextStyle(color: kTextGrey, fontSize: 12)),
                    const Text('Degree',
                        style: TextStyle(color: kTextGrey, fontSize: 12)),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 28,
                      decoration: BoxDecoration(
                        color: kNavy,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Field Name',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: kBgGrey),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(value: '7 Year', label: 'Experience'),
              _Divider(),
              _StatItem(value: '500+', label: 'Publications'),
              _Divider(),
              _StatItem(value: '340', label: 'Citations'),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Bottom Nav ────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final tabs = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.list_alt_rounded, 'label': 'List of Dr'},
      {'icon': Icons.assignment_outlined, 'label': 'My Request'},
      {'icon': Icons.chat_bubble_outline_rounded, 'label': 'Chat'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: kNavy.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final selected = i == _selectedTab;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tabs[i]['icon'] as IconData,
                      color: selected ? kNavy : kTextGrey,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tabs[i]['label'] as String,
                      style: TextStyle(
                        color: selected ? kNavy : kTextGrey,
                        fontSize: 10,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: selected ? 20 : 0,
                      height: 3,
                      decoration: BoxDecoration(
                        color: kNavy,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _StatMini extends StatelessWidget {
  final String value;
  final String label;
  const _StatMini({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: kNavy, fontWeight: FontWeight.w700, fontSize: 11)),
        Text(label,
            style: const TextStyle(color: kTextGrey, fontSize: 9)),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: kNavy, fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: kTextGrey, fontSize: 11)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: kBgGrey,
    );
  }
}

// ─── Donut Chart Painter ──────────────────────────────────────────────────────
class _DonutPainter extends CustomPainter {
  final double progress;
  final Color color;

  _DonutPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = math.min(cx, cy) - 4;
    const strokeWidth = 7.0;

    // Background track
    final trackPaint = Paint()
      ..color = kCardGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(cx, cy), radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    // Center text
    final tp = TextPainter(
      text: TextSpan(
        text: '${(progress * 100).toInt()}%',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
        canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.progress != progress || old.color != color;
}