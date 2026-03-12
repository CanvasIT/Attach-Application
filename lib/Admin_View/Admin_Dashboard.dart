import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'SF Pro Text',
      ),
      home: const DashboardScreen(),
    );
  }
}

// ── Data model ─────────────────────────────────────────────────
class WeeklyData {
  final String day;
  final double value;
  WeeklyData(this.day, this.value);
}

// ── Screen ─────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color _navy    = Color(0xFF1B2D70);
  static const Color _navyLight = Color(0xFFEEF1FA);
  static const Color _green   = Color(0xFF22C55E);
  static const Color _red     = Color(0xFFE53935);

  int _bottomIndex = 0;
  String? _selectedAnalysis;
  String? _selectedDate;

  final List<String> _analysisTypes = [
    'Daily', 'Weekly', 'Monthly', 'Yearly',
  ];
  final List<String> _dateOptions = [
    'Today', 'This Week', 'This Month', 'Last Month', 'This Year',
  ];

  final List<WeeklyData> _weeklyConsultations = [
    WeeklyData('Su', 3),
    WeeklyData('Mo', 8),
    WeeklyData('Tu', 5),
    WeeklyData('We', 12),
    WeeklyData('Th', 7),
    WeeklyData('Fr', 10),
    WeeklyData('Sa', 6),
  ];

  final List<WeeklyData> _weeklyPosts = [
    WeeklyData('Su', 2),
    WeeklyData('Mo', 5),
    WeeklyData('Tu', 4),
    WeeklyData('We', 9),
    WeeklyData('Th', 6),
    WeeklyData('Fr', 7),
    WeeklyData('Sa', 3),
  ];

  double get _highestConsult =>
      _weeklyConsultations.map((e) => e.value).reduce(max);
  double get _todayConsult => _weeklyConsultations.last.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Navy header ──────────────────────────────────
          Container(
            color: _navy,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('9:41',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                        Row(children: const [
                          Icon(Icons.signal_cellular_alt, color: Colors.white, size: 15),
                          SizedBox(width: 4),
                          Icon(Icons.wifi, color: Colors.white, size: 15),
                          SizedBox(width: 4),
                          Icon(Icons.battery_full, color: Colors.white, size: 17),
                        ]),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const Expanded(
                          child: Text('Dashboard',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Body ────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Profile row ──────────────────────────
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: _navyLight,
                        child: const Icon(Icons.person_outline, color: _navy, size: 22),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dr. Fatima Matrook',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _navy)),
                          Text('Admin Dashboard',
                              style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Filter + Export row ──────────────────
                  Row(
                    children: [
                      // Analysis dropdown
                      Expanded(
                        child: _DropdownField(
                          hint: 'Select Analysis Type',
                          value: _selectedAnalysis,
                          items: _analysisTypes,
                          onChanged: (v) => setState(() => _selectedAnalysis = v),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Date dropdown
                      Expanded(
                        child: _DropdownField(
                          hint: 'Select Date',
                          value: _selectedDate,
                          items: _dateOptions,
                          onChanged: (v) => setState(() => _selectedDate = v),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Circle Export button
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: _green,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x3322C55E),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.upload_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Section 1 label ──────────────────────
                  _SectionLabel(label: 'Overview'),
                  const SizedBox(height: 10),

                  // ── 4 stat cards 2x2 grid ────────────────
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.55,
                    children: const [
                      _StatCard(
                        title: 'Total Posts',
                        value: '128',
                        pct: '+12.5%',
                        sub: 'Since last month',
                        icon: Icons.post_add_outlined,
                        positive: true,
                      ),
                      _StatCard(
                        title: 'Total Requests',
                        value: '340',
                        pct: '+8.2%',
                        sub: 'Since last month',
                        icon: Icons.question_answer_outlined,
                        positive: true,
                      ),
                      _StatCard(
                        title: 'Doctors',
                        value: '47',
                        pct: '-3.1%',
                        sub: 'Since last month',
                        icon: Icons.medical_services_outlined,
                        positive: false,
                      ),
                      _StatCard(
                        title: 'Students',
                        value: '512',
                        pct: '+5.7%',
                        sub: 'Since last month',
                        icon: Icons.school_outlined,
                        positive: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ── Weekly Consultations chart ───────────
                  _SectionLabel(label: 'Weekly Consultations'),
                  const SizedBox(height: 10),
                  _ChartCard(
                    weeklyData: _weeklyConsultations,
                    highestVal: _highestConsult,
                    bestLabel: 'Best Day',
                    todayLabel: 'Today',
                    todayVal: _todayConsult,
                    bestVal: _highestConsult,
                    unit: 'Requests',
                  ),

                  const SizedBox(height: 22),

                  // ── Monthly Performance ──────────────────
                  _SectionLabel(label: 'Monthly Performance'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _GaugeCard(
                          title: 'New Students',
                          current: 350,
                          goal: 500,
                          color: _red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _GaugeCard(
                          title: 'New Doctors',
                          current: 38,
                          goal: 50,
                          color: _green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ── Latest Consultation ──────────────────
                  _SectionLabel(label: 'Latest Consultation'),
                  const SizedBox(height: 10),
                  _ConsultationCard(
                    studentName: 'Zainab Hasan',
                    topic: 'Quantitative Research',
                    language: 'Arabic • English',
                    consultId: '#CON-4832',
                    status: 'Active',
                  ),

                  const SizedBox(height: 22),

                  // ── Weekly Posts chart ───────────────────
                  _SectionLabel(label: 'Weekly Posts Activity'),
                  const SizedBox(height: 10),
                  _BarChartCard(data: _weeklyPosts),
                ],
              ),
            ),
          ),

          // ── Bottom nav ───────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_outlined,          label: 'Home',          index: 0, selected: _bottomIndex, onTap: (i) => setState(() => _bottomIndex = i)),
                _NavItem(icon: Icons.person_add_outlined,    label: 'Sign In Req',   index: 1, selected: _bottomIndex, onTap: (i) => setState(() => _bottomIndex = i)),
                _NavItem(icon: Icons.assignment_outlined,    label: 'Staff Req',     index: 2, selected: _bottomIndex, onTap: (i) => setState(() => _bottomIndex = i)),
                _NavItem(icon: Icons.notifications_outlined, label: 'Notifications', index: 3, selected: _bottomIndex, onTap: (i) => setState(() => _bottomIndex = i)),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            height: 22,
            child: Center(
              child: Container(
                width: 100,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.12),
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

// ── Section label ──────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: const Color(0xFF1B2D70), borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1B2D70))),
      ],
    );
  }
}

// ── Dropdown field ─────────────────────────────────────────────
class _DropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
          isExpanded: true,
          style: const TextStyle(fontSize: 12, color: Color(0xFF1B2D70)),
          onChanged: onChanged,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        ),
      ),
    );
  }
}

// ── Stat card ──────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String pct;
  final String sub;
  final IconData icon;
  final bool positive;

  const _StatCard({
    required this.title,
    required this.value,
    required this.pct,
    required this.sub,
    required this.icon,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF1B2D70);
    final pctColor = positive ? const Color(0xFF22C55E) : const Color(0xFFE53935);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(title,
                    style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF1FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 15, color: navy),
              ),
            ],
          ),
          Text(value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: navy)),
          Row(
            children: [
              Icon(positive ? Icons.arrow_upward : Icons.arrow_downward, size: 11, color: pctColor),
              const SizedBox(width: 2),
              Text(pct, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: pctColor)),
              const SizedBox(width: 4),
              Flexible(
                child: Text(sub,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 9, color: Colors.grey)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Chart card (area) ──────────────────────────────────────────
class _ChartCard extends StatelessWidget {
  final List<WeeklyData> weeklyData;
  final double highestVal;
  final String bestLabel;
  final String todayLabel;
  final double todayVal;
  final double bestVal;
  final String unit;

  const _ChartCard({
    required this.weeklyData,
    required this.highestVal,
    required this.bestLabel,
    required this.todayLabel,
    required this.todayVal,
    required this.bestVal,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          // Day labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weeklyData
                .map((d) => Text(d.day, style: const TextStyle(fontSize: 11, color: Colors.grey)))
                .toList(),
          ),
          const SizedBox(height: 8),
          // Area chart
          SizedBox(
            height: 100,
            child: CustomPaint(
              size: const Size(double.infinity, 100),
              painter: _AreaPainter(weeklyData, highestVal),
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 12),
          _InfoRow(label: bestLabel,  value: '${bestVal.toStringAsFixed(0)} $unit'),
          const SizedBox(height: 6),
          _InfoRow(label: todayLabel, value: '${todayVal.toStringAsFixed(0)} $unit'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1B2D70))),
      ],
    );
  }
}

// ── Gauge card ─────────────────────────────────────────────────
class _GaugeCard extends StatelessWidget {
  final String title;
  final int current;
  final int goal;
  final Color color;
  const _GaugeCard({required this.title, required this.current, required this.goal, required this.color});

  @override
  Widget build(BuildContext context) {
    final progress = (current / goal).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          const SizedBox(height: 14),
          SizedBox(
            width: 80, height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 9,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                Text(current.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text('Goal: $goal',
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

// ── Consultation card ──────────────────────────────────────────
class _ConsultationCard extends StatelessWidget {
  final String studentName;
  final String topic;
  final String language;
  final String consultId;
  final String status;

  const _ConsultationCard({
    required this.studentName,
    required this.topic,
    required this.language,
    required this.consultId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFEEF1FA),
            child: const Icon(Icons.person_outline, color: Color(0xFF1B2D70), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(studentName,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF111111))),
                const SizedBox(height: 3),
                Text(topic,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(language,
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF1FA),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF1B2D70).withOpacity(0.25)),
                ),
                child: Text(status,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF1B2D70))),
              ),
              const SizedBox(height: 6),
              Text(consultId,
                  style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Bar chart card ─────────────────────────────────────────────
class _BarChartCard extends StatelessWidget {
  final List<WeeklyData> data;
  const _BarChartCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxVal = data.map((e) => e.value).reduce(max);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Y labels
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: ['10', '7', '4', '0']
                    .map((l) => SizedBox(
                          height: 28,
                          child: Text(l, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                        ))
                    .toList(),
              ),
              const SizedBox(width: 8),
              // Bars
              Expanded(
                child: SizedBox(
                  height: 112,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: data.map((d) {
                      final frac = (d.value / maxVal).clamp(0.0, 1.0);
                      final isMax = d.value == maxVal;
                      return Container(
                        width: 10,
                        height: 100 * frac,
                        decoration: BoxDecoration(
                          color: isMax
                              ? const Color(0xFF1B2D70)
                              : const Color(0xFFEEF1FA),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(width: 24),
              ...data.map((d) => Text(d.day,
                  style: const TextStyle(fontSize: 10, color: Colors.grey))),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Area chart painter ─────────────────────────────────────────
class _AreaPainter extends CustomPainter {
  final List<WeeklyData> data;
  final double maxVal;
  _AreaPainter(this.data, this.maxVal);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final linePaint = Paint()
      ..color = const Color(0xFF1B2D70)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x441B2D70), Color(0x001B2D70)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final n = data.length;
    final pts = <Offset>[];
    for (int i = 0; i < n; i++) {
      final x = (i / (n - 1)) * size.width;
      final y = size.height - (data[i].value / maxVal) * size.height * 0.9;
      pts.add(Offset(x, y));
    }

    final fill = Path()..moveTo(pts.first.dx, size.height);
    for (final p in pts) fill.lineTo(p.dx, p.dy);
    fill.lineTo(pts.last.dx, size.height);
    fill.close();
    canvas.drawPath(fill, fillPaint);

    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) line.lineTo(pts[i].dx, pts[i].dy);
    canvas.drawPath(line, linePaint);

    final dot = Paint()..color = const Color(0xFF1B2D70)..style = PaintingStyle.fill;
    final dotBg = Paint()..color = Colors.white..style = PaintingStyle.fill;
    for (final p in pts) {
      canvas.drawCircle(p, 5, dotBg);
      canvas.drawCircle(p, 3.5, dot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ── Nav item ───────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selected;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSel = index == selected;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: isSel ? const Color(0xFF1B2D70) : Colors.grey.shade400,
              size: 22),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: isSel ? const Color(0xFF1B2D70) : Colors.grey.shade400,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.normal)),
        ],
      ),
    );
  }
}