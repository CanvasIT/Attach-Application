import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Info',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'SF Pro Text',
      ),
      home: const PostInfoScreen(),
    );
  }
}

class PostInfoScreen extends StatefulWidget {
  const PostInfoScreen({super.key});

  @override
  State<PostInfoScreen> createState() => _PostInfoScreenState();
}

class _PostInfoScreenState extends State<PostInfoScreen> {
  static const Color _navy = Color(0xFF1B2D70);

  String? _selectedResearchType;
  String? _selectedLanguage;
  DateTime? _fromDate;
  DateTime? _toDate;

  final List<String> _researchTypes = [
    'Professor',
    'Associate Professor',
    'Assistant Professor',
    'Lecturer / Instructor',
    'Adjunct Faculty',
    'Principal Investigator (PI)',
    'Research Scientist',
    'Research Fellow',
    'Postdoctoral Researcher (Postdoc)',
    'Graduate Researcher (Master\'s / PhD)',
    'Research Assistant',
    'Research Coordinator / Project Coordinator',
    'Clinician / Practitioner',
    'Consultant / Specialist (Professional)',
  ];

  final List<String> _languages = [
    'English',
    'Arabic',
    'French',
    'Spanish',
    'German',
  ];

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _fromDate : _toDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _navy,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Navy status bar + nav ──────────────────────────
          Container(
            color: _navy,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Status bar time & icons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('9:41',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        Row(children: [
                          Icon(Icons.signal_cellular_alt,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Icon(Icons.wifi, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Icon(Icons.battery_full,
                              color: Colors.white, size: 18),
                        ]),
                      ],
                    ),
                  ),
                  // Nav bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 6, 18, 14),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left,
                              color: Colors.white, size: 28),
                          onPressed: () => Navigator.maybePop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 4),
                        const Text('Post Info',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: -0.2)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Scrollable content ─────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Consultation ID row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Doctor ID: 5454524',
                          style:
                              TextStyle(fontSize: 12.5, color: Colors.grey)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: _navy.withOpacity(0.10),
                          border: Border.all(
                              color: _navy.withOpacity(0.25), width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Active',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _navy)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Profile card
                  _ShadowCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 21,
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(Icons.person,
                              color: Colors.grey, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Role',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF222222))),
                            SizedBox(height: 2),
                            Text('Location — Degree',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Section title
                  const Text('Fill Your Post Details',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _navy)),

                  const SizedBox(height: 16),

                  // Type Of Research — Dropdown
                  _buildLabel('Type Of Research'),
                  _DropdownField(
                    hint: 'Type Of Research...',
                    value: _selectedResearchType,
                    items: _researchTypes,
                    onChanged: (v) =>
                        setState(() => _selectedResearchType = v),
                  ),

                  const SizedBox(height: 14),

                  // Research Language — Dropdown
                  _buildLabel('Research Language'),
                  _DropdownField(
                    hint: 'Research Language...',
                    value: _selectedLanguage,
                    items: _languages,
                    onChanged: (v) =>
                        setState(() => _selectedLanguage = v),
                  ),

                  const SizedBox(height: 14),

                  // Number of Students Required
                  _buildLabel('Number of Students Required'),
                  _ShadowField(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF333333)),
                      decoration: _inputDec(
                          'Number of Students Required...', null),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Research Date
                  _buildLabel('Research Date'),
                  Row(
                    children: [
                      const SizedBox(
                        width: 40,
                        child: Text('From:',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333))),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(context, true),
                          child: _ShadowCard(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 13),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  _fromDate != null
                                      ? _formatDate(_fromDate)
                                      : 'From date...',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: _fromDate != null
                                          ? const Color(0xFF333333)
                                          : Colors.grey.shade400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const SizedBox(
                        width: 40,
                        child: Text('To:',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333))),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(context, false),
                          child: _ShadowCard(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 13),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  _toDate != null
                                      ? _formatDate(_toDate)
                                      : 'End date...',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: _toDate != null
                                          ? const Color(0xFF333333)
                                          : Colors.grey.shade400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Research Summary
                  _buildLabel('Research Summary'),
                  _ShadowField(
                    child: Stack(
                      children: [
                        TextField(
                          maxLines: 4,
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF333333)),
                          decoration: _inputDec('Research Summary...', null)
                              .copyWith(
                                  contentPadding: const EdgeInsets.all(14)),
                        ),
                        const Positioned(
                          bottom: 8,
                          right: 12,
                          child: Text('0/0',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Research Details
                  _buildLabel('Research Details'),
                  _ShadowField(
                    child: Stack(
                      children: [
                        TextField(
                          maxLines: 7,
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF333333)),
                          decoration: _inputDec(
                                  'Student will view this if you accepted him',
                                  null)
                              .copyWith(
                                  contentPadding: const EdgeInsets.all(14)),
                        ),
                        const Positioned(
                          bottom: 8,
                          right: 12,
                          child: Text('0/0',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Bottom buttons (FIXED: color moved inside BoxDecoration) ───
          Container(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(0, 50),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF555555))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _navy,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(0, 50),
                    ),
                    child: const Text('Post',
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333))),
    );
  }

  InputDecoration _inputDec(String hint, Widget? suffix) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          TextStyle(fontSize: 13, color: Colors.grey.shade400),
      border: InputBorder.none,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      suffixIcon: suffix,
    );
  }
}

// ── Shadow card wrapper ────────────────────────────────────────
class _ShadowCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const _ShadowCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Shadow field (no internal padding override) ───────────────
class _ShadowField extends StatelessWidget {
  final Widget child;

  const _ShadowField({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Dropdown field ────────────────────────────────────────────
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
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
          icon: const Icon(Icons.keyboard_arrow_down,
              color: Colors.grey, size: 20),
          isExpanded: true,
          style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
              fontFamily: 'SF Pro Text'),
          onChanged: onChanged,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),
      ),
    );
  }
}