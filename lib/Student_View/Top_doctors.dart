import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Colour tokens ─────────────────────────────────────────────
const Color kNavy    = Color(0xFF1A2D5A);
const Color kNavyMid = Color(0xFF243A6B);
const Color kBg      = Color(0xFFF0F3FA);
const Color kWhite   = Color(0xFFFFFFFF);
const Color kBorder  = Color(0xFFDDE2EF);
const Color kGrey    = Color(0xFF9AA3B8);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:           Colors.transparent,
      statusBarIconBrightness:  Brightness.light,
    ),
  );
  runApp(const AttachApp());
}

class AttachApp extends StatelessWidget {
  const AttachApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'DMSans',
          scaffoldBackgroundColor: kWhite,
        ),
        home: const TopDoctorPage(),
      );
}

// ─────────────────────────────────────────────────────────────
//  TOP DOCTOR PAGE
// ─────────────────────────────────────────────────────────────
class TopDoctorPage extends StatefulWidget {
  const TopDoctorPage({super.key});
  @override
  State<TopDoctorPage> createState() => _TopDoctorPageState();
}

class _TopDoctorPageState extends State<TopDoctorPage> {
  bool _isGrid = false;

  // Sample doctor data
  final List<Map<String, dynamic>> _doctors = List.generate(6, (i) => {
    'role':         'Role',
    'location':     'Location',
    'degree':       'Degree',
    'field':        'Field Name',
    'experience':   '7 Year',
    'publications': '500+',
    'citations':    '340',
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: kWhite,
        body: Column(
          children: [

            // ── Navy zone: status bar + app bar ────────────
            Container(
              color: kNavy,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Status bar row
                    _StatusBar(),
                    // App bar
                    _AppBar(onBack: () {}),
                  ],
                ),
              ),
            ),

            // ── Scrollable body ─────────────────────────────
            Expanded(
              child: Column(
                children: [

                  // Search bar
                  _SearchBar(),

                  // Filter row: category dropdown + list/grid toggles
                  _FilterRow(
                    isGrid:   _isGrid,
                    onList:   () => setState(() => _isGrid = false),
                    onGrid:   () => setState(() => _isGrid = true),
                  ),

                  // Results count
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Showing 13500 Results',
                        style: TextStyle(
                          fontSize:   12.5,
                          fontWeight: FontWeight.w500,
                          color:      kNavy.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),

                  // Cards list / grid
                  Expanded(
                    child: _isGrid
                        ? _DoctorGrid(doctors: _doctors)
                        : _DoctorList(doctors: _doctors),
                  ),
                ],
              ),
            ),

            // ── Bottom bar ──────────────────────────────────
            _BottomBar(),

            // ── Home indicator ──────────────────────────────
            Container(
              height: 34,
              color:  kWhite,
              alignment: Alignment.center,
              child: Container(
                width: 110, height: 4,
                decoration: BoxDecoration(
                  color:        kGrey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  STATUS BAR  (white icons row inside navy zone)
// ─────────────────────────────────────────────────────────────
class _StatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 6, 22, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              fontSize:      12,
              fontWeight:    FontWeight.w600,
              color:         kWhite,
              letterSpacing: -0.2,
            ),
          ),
          Row(
            children: [
              // Signal bars
              _SignalBars(),
              const SizedBox(width: 6),
              // WiFi
              const Icon(Icons.wifi, color: kWhite, size: 16),
              const SizedBox(width: 6),
              // Battery
              _BatteryIcon(),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignalBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _bar(5,  1.0),
        const SizedBox(width: 2),
        _bar(8,  1.0),
        const SizedBox(width: 2),
        _bar(11, 1.0),
        const SizedBox(width: 2),
        _bar(14, 0.4),
      ],
    );
  }

  Widget _bar(double h, double op) => Opacity(
        opacity: op,
        child: Container(
          width: 3, height: h,
          decoration: BoxDecoration(
            color:        kWhite,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
}

class _BatteryIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22, height: 11,
          decoration: BoxDecoration(
            border: Border.all(
                color: kWhite.withOpacity(0.6), width: 1.5),
            borderRadius: BorderRadius.circular(2.5),
          ),
          padding: const EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              color:        kWhite,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
        Container(
          width: 2, height: 5,
          color: kWhite.withOpacity(0.5),
          margin: const EdgeInsets.only(left: 1.5),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  APP BAR  — navy bg, back arrow, "Top Doctor" title
// ─────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final VoidCallback onBack;
  const _AppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
      child: Row(
        children: [
          // Back button  32×32  rounded 8px
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color:        Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.chevron_left,
                color: kWhite,
                size:  26,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Top Doctor',
            style: TextStyle(
              fontSize:   18,
              fontWeight: FontWeight.w700,
              color:      kWhite,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SEARCH BAR  — white bg, kBg fill, border kBorder
// ─────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color:        kBg,
          border:       Border.all(color: kBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border:           InputBorder.none,
                  hintText:         'Search',
                  hintStyle:        TextStyle(
                    color:    kGrey,
                    fontSize: 13.5,
                  ),
                  isDense:          true,
                  contentPadding:   EdgeInsets.zero,
                ),
                style: const TextStyle(
                  color:    kNavy,
                  fontSize: 13.5,
                ),
              ),
            ),
            const Icon(Icons.search, color: kNavy, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FILTER ROW  — Category dropdown + List/Grid toggle buttons
// ─────────────────────────────────────────────────────────────
class _FilterRow extends StatelessWidget {
  final bool isGrid;
  final VoidCallback onList;
  final VoidCallback onGrid;
  const _FilterRow({
    required this.isGrid,
    required this.onList,
    required this.onGrid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: [

          // Category dropdown
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color:        kWhite,
                border:       Border.all(color: kBorder, width: 1.2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontSize:   13,
                        fontWeight: FontWeight.w500,
                        color:      kGrey,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down,
                      color: kGrey, size: 20),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // List toggle
          _ToggleBtn(
            active:  !isGrid,
            onTap:   onList,
            icon:    Icons.format_list_bulleted,
          ),

          const SizedBox(width: 10),

          // Grid toggle
          _ToggleBtn(
            active:  isGrid,
            onTap:   onGrid,
            icon:    Icons.grid_view_rounded,
          ),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final bool        active;
  final VoidCallback onTap;
  final IconData    icon;
  const _ToggleBtn({
    required this.active,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 40, height: 40,
        decoration: BoxDecoration(
          color:        active ? kNavy : kWhite,
          border:       Border.all(
            color: active ? kNavy : kBorder,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size:  18,
          color: active ? kWhite : kGrey,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  DOCTOR LIST  — vertical scrollable list of DoctorBlock cards
// ─────────────────────────────────────────────────────────────
class _DoctorList extends StatelessWidget {
  final List<Map<String, dynamic>> doctors;
  const _DoctorList({required this.doctors});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding:     const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount:   doctors.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child:   _DoctorBlock(doc: doctors[i], compact: false),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  DOCTOR GRID  — 2-column grid
// ─────────────────────────────────────────────────────────────
class _DoctorGrid extends StatelessWidget {
  final List<Map<String, dynamic>> doctors;
  const _DoctorGrid({required this.doctors});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding:    const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:   2,
        crossAxisSpacing: 12,
        mainAxisSpacing:  12,
        childAspectRatio: 0.72,
      ),
      itemCount:   doctors.length,
      itemBuilder: (ctx, i) =>
          _DoctorBlock(doc: doctors[i], compact: true),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  DOCTOR BLOCK  — info card (top) + stats row (bottom)
// ─────────────────────────────────────────────────────────────
class _DoctorBlock extends StatelessWidget {
  final Map<String, dynamic> doc;
  final bool                 compact; // true = grid mode
  const _DoctorBlock({required this.doc, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Info card ───────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color:  kWhite,
            border: Border.all(color: kBorder),
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16)),
            boxShadow: const [
              BoxShadow(
                color:      Color(0x120D1C40),
                blurRadius: 8,
                offset:     Offset(0, 2),
              ),
            ],
          ),
          child: compact
              ? _GridCardTop(doc: doc)
              : _ListCardTop(doc: doc),
        ),

        // ── Stats row ────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color:  kWhite,
            border: Border(
              left:   BorderSide(color: kBorder),
              right:  BorderSide(color: kBorder),
              bottom: BorderSide(color: kBorder),
            ),
            borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16)),
            boxShadow: const [
              BoxShadow(
                color:      Color(0x0D1A2D5A),
                blurRadius: 10,
                offset:     Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                  value: doc['experience'],
                  label: 'Experience',
                  compact: compact),
              _StatDivider(),
              _StatItem(
                  value: doc['publications'],
                  label: 'Publications',
                  compact: compact),
              _StatDivider(),
              _StatItem(
                  value: doc['citations'],
                  label: 'Citations',
                  compact: compact),
            ],
          ),
        ),
      ],
    );
  }
}

// ── List mode card top ─────────────────────────────────────────
class _ListCardTop extends StatelessWidget {
  final Map<String, dynamic> doc;
  const _ListCardTop({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder  74×84
          _ImagePlaceholder(width: 74, height: 84),
          const SizedBox(width: 12),
          // Info
          Expanded(child: _DocInfo(doc: doc, compact: false)),
        ],
      ),
    );
  }
}

// ── Grid mode card top ─────────────────────────────────────────
class _GridCardTop extends StatelessWidget {
  final Map<String, dynamic> doc;
  const _GridCardTop({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder full-width  h:76
          _ImagePlaceholder(width: double.infinity, height: 76),
          const SizedBox(height: 8),
          _DocInfo(doc: doc, compact: true),
        ],
      ),
    );
  }
}

// ── Doctor info text block ─────────────────────────────────────
class _DocInfo extends StatelessWidget {
  final Map<String, dynamic> doc;
  final bool compact;
  const _DocInfo({required this.doc, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doc['role'] as String,
          style: TextStyle(
            fontSize:   compact ? 12.5 : 14,
            fontWeight: FontWeight.w700,
            color:      kNavy,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          doc['location'] as String,
          style: TextStyle(
            fontSize:   compact ? 10.5 : 12,
            color:      kGrey,
          ),
        ),
        Text(
          doc['degree'] as String,
          style: TextStyle(
            fontSize:   compact ? 10.5 : 12,
            color:      kGrey,
          ),
        ),
        const SizedBox(height: 8),
        // Field button
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 14,
            vertical:   compact ? 4 : 5,
          ),
          decoration: BoxDecoration(
            color:        kNavy,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            doc['field'] as String,
            style: TextStyle(
              fontSize:   compact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color:      kWhite,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Image placeholder ─────────────────────────────────────────
class _ImagePlaceholder extends StatelessWidget {
  final double width;
  final double height;
  const _ImagePlaceholder({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color:        kBg,
        border:       Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, color: kGrey, size: 26),
          const SizedBox(height: 4),
          Text(
            'No Image\nPreview',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:   7,
              color:      kGrey,
              height:     1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat item ─────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool   compact;
  const _StatItem({
    required this.value,
    required this.label,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize:   compact ? 11 : 13,
            fontWeight: FontWeight.w700,
            color:      kNavy,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(
            fontSize: compact ? 9 : 10.5,
            color:    kGrey,
          ),
        ),
      ],
    );
  }
}

// ── Stat divider ──────────────────────────────────────────────
class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1, height: 28,
        color: kBorder,
      );
}

// ─────────────────────────────────────────────────────────────
//  BOTTOM BAR  — Sort by + Filters
// ─────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        border: Border(top: BorderSide(color: kBorder)),
        boxShadow: const [
          BoxShadow(
            color:      Color(0x0F1A2D5A),
            blurRadius: 12,
            offset:     Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: _BarButton(
              icon:  Icons.sort,
              label: 'Sort by',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _BarButton(
              icon:  Icons.tune,
              label: 'Filters',
            ),
          ),
        ],
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final String   label;
  const _BarButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color:        kWhite,
          border:       Border.all(color: kBorder, width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: kNavy, size: 17),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                fontSize:   13.5,
                fontWeight: FontWeight.w600,
                color:      kNavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}