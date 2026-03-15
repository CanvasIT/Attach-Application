import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF0F0F0)),
      home: const StudentProfileScreen(),
    );
  }
}

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool _overviewOpen = true;
  bool _educationOpen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Column(
        children: [
          // ── Status bar ────────────────────────────────────
          Container(
            color: const Color(0xFFF0F0F0),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('9:41',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111111))),
                        Row(children: const [
                          Icon(Icons.signal_cellular_alt,
                              color: Color(0xFF111111), size: 16),
                          SizedBox(width: 4),
                          Icon(Icons.wifi, color: Color(0xFF111111), size: 16),
                          SizedBox(width: 4),
                          Icon(Icons.battery_full,
                              color: Color(0xFF111111), size: 18),
                        ]),
                      ],
                    ),
                  ),

                  // ── Top nav ────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 14, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left,
                              color: Color(0xFF333333), size: 28),
                          onPressed: () => Navigator.maybePop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        Row(
                          children: [
                            Icon(Icons.favorite_border,
                                color: Colors.grey.shade600, size: 22),
                            const SizedBox(width: 16),
                            Icon(Icons.refresh,
                                color: Colors.grey.shade600, size: 22),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Scrollable body ───────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Image preview section ─────────────────
                  Container(
                    color: const Color(0xFFF0F0F0),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        // Two overlapping rounded squares
                        SizedBox(
                          width: 120,
                          height: 110,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC8CCDA),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDFE2EA),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No Image Preview',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),

                  // ── White card body ───────────────────────
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + Online
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Student Name',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111111))),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF43A047),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text('Online',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF388E3C))),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Major tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E6B30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Major',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),

                        const SizedBox(height: 18),

                        // ── Overview accordion ────────────
                        _AccordionCard(
                          icon: Icons.article_outlined,
                          title: 'Overview...',
                          isOpen: _overviewOpen,
                          onToggle: () =>
                              setState(() => _overviewOpen = !_overviewOpen),
                          description: 'Description',
                        ),

                        const SizedBox(height: 12),

                        // ── Education accordion ───────────
                        _AccordionCard(
                          icon: Icons.school_outlined,
                          title: 'Education',
                          isOpen: _educationOpen,
                          onToggle: () =>
                              setState(() => _educationOpen = !_educationOpen),
                          description: 'Description',
                        ),

                        const SizedBox(height: 4),

                        // ── Stats row ─────────────────────
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFFF0F0F0)),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Row(
                            children: [
                              _StatItem(value: 'BH', label: 'Country'),
                              _StatDivider(),
                              _StatItem(value: '3.45', label: 'GPA'),
                              _StatDivider(),
                              _StatItem(value: 'AR | EN', label: 'Research Lang'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom buttons (FIXED: color moved inside BoxDecoration) ──
          Container(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      elevation: 0,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Decline',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E6B30),
                      elevation: 0,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Approve',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),

          // Home bar
          Container(
            color: Colors.white,
            height: 28,
            child: Center(
              child: Container(
                width: 110,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Accordion Card ─────────────────────────────────────────────
class _AccordionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isOpen;
  final VoidCallback onToggle;
  final String description;

  const _AccordionCard({
    required this.icon,
    required this.title,
    required this.isOpen,
    required this.onToggle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header — grey background
          GestureDetector(
            onTap: onToggle,
            child: Container(
              color: const Color(0xFFF0F0F0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF222222))),
                  ),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(Icons.keyboard_arrow_down,
                        color: Colors.grey.shade400, size: 20),
                  ),
                ],
              ),
            ),
          ),

          // Description body — white, animated
          AnimatedCrossFade(
            firstChild: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Text(
                description,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                    height: 1.6),
              ),
            ),
            secondChild: const SizedBox(width: double.infinity, height: 0),
            crossFadeState: isOpen
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

// ── Stat item ──────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111))),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1, height: 32, color: const Color(0xFFF0F0F0));
  }
}