import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Constants ────────────────────────────────────────────────────────────────
const kNavy     = Color(0xFF1A2D5A);
const kBgGrey   = Color(0xFFF0F3FA);
const kTextGrey = Color(0xFF9AA3B8);
const kBorder   = Color(0xFFDDE2EF);

// ─── Entry Point ──────────────────────────────────────────────────────────────
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ListOfDoctorsPage(),
  ));
}

// ─── Doctor Model ─────────────────────────────────────────────────────────────
class DoctorModel {
  final String role;
  final String location;
  final String degree;
  final String fieldName;
  final String experience;
  final String publications;
  final String citations;
  final bool isOnline;

  const DoctorModel({
    required this.role,
    required this.location,
    required this.degree,
    required this.fieldName,
    required this.experience,
    required this.publications,
    required this.citations,
    this.isOnline = true,
  });
}

final List<DoctorModel> _doctors = List.generate(
  7,
  (_) => const DoctorModel(
    role: 'Role',
    location: 'Location',
    degree: 'Degree',
    fieldName: 'Field Name',
    experience: '7 Year',
    publications: '500+',
    citations: '340',
  ),
);

// ─── Page ──────────────────────────────────────────────────────────────────────
class ListOfDoctorsPage extends StatefulWidget {
  const ListOfDoctorsPage({super.key});

  @override
  State<ListOfDoctorsPage> createState() => _ListOfDoctorsPageState();
}

class _ListOfDoctorsPageState extends State<ListOfDoctorsPage> {
  bool _isCardView = true; // true = grid/card, false = list
  int _selectedTab = 1;    // 0=Home,1=ListOfDr,2=MyRequest,3=Chat

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGrey,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTopControls(),
          Expanded(
            child: _isCardView ? _buildCardView() : _buildListView(),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_isCardView) _buildSortFilterBar(),
          _buildBottomNav(),
        ],
      ),
    );
  }

  // ─── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: kNavy,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: kNavy,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      leading: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
      ),
      title: Text(
        _isCardView ? 'List of Doctors' : 'List of Doctor',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false,
    );
  }

  // ─── Search + Filter row ───────────────────────────────────────────────────
  Widget _buildTopControls() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        children: [
          // Search bar
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: kBgGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kBorder),
            ),
            child: const Row(
              children: [
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: 13.5, color: kNavy),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: kTextGrey, fontSize: 13.5),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.search_rounded, color: kNavy, size: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Filter row
          Row(
            children: [
              // Category dropdown
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kBorder, width: 1.2),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text('Category',
                            style: TextStyle(
                                color: kTextGrey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          color: kTextGrey, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // List toggle
              _ViewToggleBtn(
                icon: Icons.format_list_bulleted_rounded,
                isActive: !_isCardView,
                onTap: () => setState(() => _isCardView = false),
              ),
              const SizedBox(width: 8),
              // Grid/Card toggle
              _ViewToggleBtn(
                icon: Icons.grid_view_rounded,
                isActive: _isCardView,
                onTap: () => setState(() => _isCardView = true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Card View ─────────────────────────────────────────────────────────────
  Widget _buildCardView() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      itemCount: 2, // show 2 cards as in screenshot
      itemBuilder: (_, i) => _DoctorCardBlock(doctor: _doctors[i]),
    );
  }

  // ─── List View ─────────────────────────────────────────────────────────────
  Widget _buildListView() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: ListView.separated(
          shrinkWrap: false,
          itemCount: 7,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: kBorder, thickness: 1),
          itemBuilder: (_, i) => _DoctorListRow(doctor: _doctors[i]),
        ),
      ),
    );
  }

  // ─── Sort + Filter bar ─────────────────────────────────────────────────────
  Widget _buildSortFilterBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: kNavy.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.sort_rounded, size: 18, color: kNavy),
              label: const Text('Sort by',
                  style: TextStyle(
                      color: kNavy,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: kBorder, width: 1.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.tune_rounded, size: 18, color: kNavy),
              label: const Text('Filters',
                  style: TextStyle(
                      color: kNavy,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: kBorder, width: 1.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bottom Navigation ─────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final tabs = [
      {'icon': Icons.home_rounded,       'label': 'Home'},
      {'icon': Icons.grid_view_rounded,  'label': 'List of Dr'},
      {'icon': Icons.assignment_outlined,'label': 'My Request'},
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
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w400,
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

// ─── Doctor Card Block (card view) ────────────────────────────────────────────
class _DoctorCardBlock extends StatelessWidget {
  final DoctorModel doctor;
  const _DoctorCardBlock({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // ── Info card ──────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border.all(color: kBorder),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Container(
                  width: 74,
                  height: 90,
                  decoration: BoxDecoration(
                    color: kBgGrey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kBorder),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined,
                          color: kTextGrey, size: 26),
                      const SizedBox(height: 4),
                      Text('No Image Preview',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 7.5,
                              color: kTextGrey.withOpacity(0.8))),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(doctor.role,
                              style: const TextStyle(
                                  color: kNavy,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14)),
                          if (doctor.isOnline)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: kNavy,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('Online',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(doctor.location,
                          style: const TextStyle(
                              color: kTextGrey, fontSize: 12)),
                      Text(doctor.degree,
                          style: const TextStyle(
                              color: kTextGrey, fontSize: 12)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: kNavy,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(doctor.fieldName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ── Stats row ──────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border(
                left: BorderSide(color: kBorder),
                right: BorderSide(color: kBorder),
                bottom: BorderSide(color: kBorder),
                top: BorderSide(color: kBgGrey),
              ),
              boxShadow: [
                BoxShadow(
                  color: kNavy.withOpacity(0.07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatWithIcon(
                  icon: Icons.person,
                  value: doctor.experience,
                  label: 'Experience',
                ),
                Container(width: 1, height: 30, color: kBorder),
                _StatWithIcon(
                  icon: Icons.group,
                  value: doctor.publications,
                  label: 'Publications',
                ),
                Container(width: 1, height: 30, color: kBorder),
                _StatWithIcon(
                  icon: Icons.format_quote,
                  value: doctor.citations,
                  label: 'Citations',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Doctor List Row (list view) ──────────────────────────────────────────────
class _DoctorListRow extends StatelessWidget {
  final DoctorModel doctor;
  const _DoctorListRow({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          // Circular avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: kBgGrey,
              shape: BoxShape.circle,
              border: Border.all(color: kBorder),
            ),
            child: Icon(Icons.image_outlined, color: kTextGrey, size: 20),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor.role,
                    style: const TextStyle(
                        color: kNavy,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(doctor.location,
                    style: const TextStyle(
                        color: kTextGrey, fontSize: 11.5)),
              ],
            ),
          ),
          // Online badge
          if (doctor.isOnline)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: kNavy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Online',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }
}

// ─── Stat with Icon ───────────────────────────────────────────────────────────
class _StatWithIcon extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatWithIcon(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: kNavy, size: 22),
        const SizedBox(height: 3),
        Text(value,
            style: const TextStyle(
                color: kNavy, fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 1),
        Text(label,
            style: const TextStyle(color: kTextGrey, fontSize: 10)),
      ],
    );
  }
}

// ─── View Toggle Button ───────────────────────────────────────────────────────
class _ViewToggleBtn extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  const _ViewToggleBtn(
      {required this.icon, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? kNavy : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isActive ? kNavy : kBorder, width: 1.2),
        ),
        child: Icon(icon,
            color: isActive ? Colors.white : kTextGrey, size: 20),
      ),
    );
  }
}