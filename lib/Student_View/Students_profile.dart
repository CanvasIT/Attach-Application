import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Colour tokens ─────────────────────────────────────────────
const Color kNavy   = Color(0xFF1A2D5A);
const Color kBg     = Color(0xFFF5F7FC);
const Color kWhite  = Color(0xFFFFFFFF);
const Color kBorder = Color(0xFFE8ECF4);
const Color kGrey   = Color(0xFF9AA3B8);
const Color kGold   = Color(0xFFF0B429);
const Color kFieldBg= Color(0xFFF0F3FA);
const Color kSubText= Color(0xFF6B7A99);
const Color kHint   = Color(0xFFC4CBDB);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:          Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AttachApp());
}

class AttachApp extends StatelessWidget {
  const AttachApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'PublicSans'),
        home: const StudentProfileEditPage(),
      );
}

// ─────────────────────────────────────────────────────────────
//  STUDENT PROFILE EDIT PAGE
// ─────────────────────────────────────────────────────────────
class StudentProfileEditPage extends StatefulWidget {
  const StudentProfileEditPage({super.key});
  @override
  State<StudentProfileEditPage> createState() =>
      _StudentProfileEditPageState();
}

class _StudentProfileEditPageState
    extends State<StudentProfileEditPage> {
  // Controllers — pre-filled with existing data
  final _nameCtrl    = TextEditingController(text: 'Brooklyn Simmons');
  final _majorCtrl   = TextEditingController(text: 'Computer Science');
  final _gpaCtrl     = TextEditingController(text: '3.85 / 4.00');
  final _langCtrl    = TextEditingController(text: 'English');
  final _descCtrl    = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _majorCtrl.dispose();
    _gpaCtrl.dispose();
    _langCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: kBg,
        body: Column(
          children: [

            // ── Navy zone: status bar + app bar ────────────
            Container(
              color: kNavy,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    _StatusBar(),
                    _AppBar(onBack: () => Navigator.maybePop(context)),
                  ],
                ),
              ),
            ),

// ── Scrollable body ─────────────────────────────
    Expanded(
    child: Stack(
    children: [

                  // Content
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Student ID row
                        _IdRow(),

                        const SizedBox(height: 12),

                        // Profile hero
                        _ProfileHero(),

                        const SizedBox(height: 12),

                        // Upload photo section
                        _UploadPhotoSection(),

                        const SizedBox(height: 12),

                        // All 4 editable fields in one card
                        _FieldsCard(
                          nameCtrl:  _nameCtrl,
                          majorCtrl: _majorCtrl,
                          gpaCtrl:   _gpaCtrl,
                          langCtrl:  _langCtrl,
                        ),

                        const SizedBox(height: 12),

                        // Short Description
                        const Text(
                          'Short Description',
                          style: TextStyle(
                            fontSize:   14,
                            fontWeight: FontWeight.w700,
                            color:      kNavy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _DescriptionField(ctrl: _descCtrl),

                      ],
                    ),
                  ),

                  // Action bar pinned at bottom
                  Positioned(
                    left: 0, right: 0, bottom: 0,
                    child: _ActionBar(
                      onCancel: () => Navigator.maybePop(context),
                      onUpdate: () {},
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  STATUS BAR
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
              fontSize:      15,
              fontWeight:    FontWeight.w700,
              color:         kWhite,
              letterSpacing: -0.3,
            ),
          ),
          Row(
            children: [
              _SignalBars(),
              const SizedBox(width: 5),
              const Icon(Icons.wifi, color: kWhite, size: 15),
              const SizedBox(width: 5),
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
        _bar(4,  0.4),
        const SizedBox(width: 1.5),
        _bar(7,  0.6),
        const SizedBox(width: 1.5),
        _bar(10, 0.85),
        const SizedBox(width: 1.5),
        _bar(12, 1.0),
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
                color: kWhite.withOpacity(0.5), width: 1.5),
            borderRadius: BorderRadius.circular(2.5),
          ),
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              color:        kWhite,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        Container(
          width: 2, height: 5,
          color: kWhite.withOpacity(0.45),
          margin: const EdgeInsets.only(left: 1),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  APP BAR
// ─────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final VoidCallback onBack;
  const _AppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: const Icon(Icons.chevron_left,
                color: kWhite, size: 26),
          ),
          const SizedBox(width: 8),
          const Text(
            'My Profile',
            style: TextStyle(
              fontSize:   19,
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
//  STUDENT ID ROW
// ─────────────────────────────────────────────────────────────
class _IdRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color:        kWhite,
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: kBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ID text
          const Text(
            'Student ID : 5454524',
            style: TextStyle(
              fontSize:   12.5,
              fontWeight: FontWeight.w500,
              color:      kSubText,
            ),
          ),
          // Active badge
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 11, vertical: 3),
            decoration: BoxDecoration(
              color:        const Color(0xFFEDF0F7),
              borderRadius: BorderRadius.circular(6),
              border:       Border.all(
                  color: const Color(0xFFDDE2EF)),
            ),
            child: const Text(
              'Active',
              style: TextStyle(
                fontSize:   11,
                fontWeight: FontWeight.w700,
                color:      kNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  PROFILE HERO  — avatar + name + role badge
// ─────────────────────────────────────────────────────────────
class _ProfileHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // Avatar circle
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            shape:  BoxShape.circle,
            color:  const Color(0xFFEDF0F7),
            border: Border.all(
                color: const Color(0xFFDDE2EF), width: 2),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: Color(0xFFA0AEC0),
            size:  28,
          ),
        ),

        const SizedBox(height: 6),

        // Name
        const Text(
          'Fatima Matrook',
          style: TextStyle(
            fontSize:   15,
            fontWeight: FontWeight.w700,
            color:      kNavy,
          ),
        ),

        const SizedBox(height: 5),

        // Student badge
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 13, vertical: 3),
          decoration: BoxDecoration(
            color:        kGold,
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Text(
            'Student',
            style: TextStyle(
              fontSize:   10.5,
              fontWeight: FontWeight.w700,
              color:      kWhite,
            ),
          ),
        ),

      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  UPLOAD PHOTO SECTION
// ─────────────────────────────────────────────────────────────
class _UploadPhotoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
      decoration: BoxDecoration(
        color:        kWhite,
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Your Profile Photo',
            style: TextStyle(
              fontSize:   12.5,
              fontWeight: FontWeight.w700,
              color:      kNavy,
            ),
          ),
          const SizedBox(height: 8),
          // Thumbnail
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 58, height: 58,
              decoration: BoxDecoration(
                color:        const Color(0xFFE2E6F0),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                    color: const Color(0xFFD4D9EA)),
              ),
              child: const Icon(
                Icons.image_outlined,
                color: Color(0xFFA0AEC0),
                size:  26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FIELDS CARD  — all 4 fields in one rounded card
// ─────────────────────────────────────────────────────────────
class _FieldsCard extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController majorCtrl;
  final TextEditingController gpaCtrl;
  final TextEditingController langCtrl;

  const _FieldsCard({
    required this.nameCtrl,
    required this.majorCtrl,
    required this.gpaCtrl,
    required this.langCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        kWhite,
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: kBorder),
      ),
      child: Column(
        children: [

          // Student Name
          _FieldRow(
            icon:       Icons.person_outline_rounded,
            label:      'Student Name',
            controller: nameCtrl,
            isLast:     false,
          ),

          // Major
          _FieldRow(
            icon:       Icons.school_outlined,
            label:      'Major',
            controller: majorCtrl,
            isLast:     false,
          ),

          // GPA
          _FieldRow(
            icon:       Icons.access_time_outlined,
            label:      'GPA',
            controller: gpaCtrl,
            isLast:     false,
          ),

          // Research Lang
          _FieldRow(
            icon:       Icons.language_outlined,
            label:      'Research Lang',
            controller: langCtrl,
            isLast:     true,
          ),

        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FIELD ROW — icon + label + editable input
// ─────────────────────────────────────────────────────────────
class _FieldRow extends StatelessWidget {
  final IconData                icon;
  final String                  label;
  final TextEditingController   controller;
  final bool                    isLast;

  const _FieldRow({
    required this.icon,
    required this.label,
    required this.controller,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(
                  color: Color(0xFFF0F3FA),
                  width: 1,
                ),
              ),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // Icon circle
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color:  kFieldBg,
              shape:  BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFFE0E6F0)),
            ),
            child: Icon(icon, color: kGrey, size: 16),
          ),

          const SizedBox(width: 12),

          // Label + input
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize:   11,
                    fontWeight: FontWeight.w600,
                    color:      kGrey,
                  ),
                ),
                const SizedBox(height: 2),
                TextField(
                  controller: controller,
                  style: const TextStyle(
                    fontSize:   13.5,
                    fontWeight: FontWeight.w600,
                    color:      kNavy,
                  ),
                  decoration: InputDecoration(
                    isDense:        true,
                    contentPadding: EdgeInsets.zero,
                    border:         InputBorder.none,
                    hintText:       '- - - - - - - -',
                    hintStyle: const TextStyle(
                      fontSize:      13,
                      fontWeight:    FontWeight.w400,
                      color:         kHint,
                      letterSpacing: 1,
                    ),
                  ),
                  cursorColor: kNavy,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SHORT DESCRIPTION FIELD
// ─────────────────────────────────────────────────────────────
class _DescriptionField extends StatelessWidget {
  final TextEditingController ctrl;
  const _DescriptionField({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 82),
      decoration: BoxDecoration(
        color:        kWhite,
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: kBorder),
      ),
      padding: const EdgeInsets.all(13),
      child: TextField(
        controller:   ctrl,
        maxLines:     null,
        style: const TextStyle(
          fontSize:   13,
          color:      kNavy,
          height:     1.6,
        ),
        decoration: const InputDecoration(
          isDense:        true,
          contentPadding: EdgeInsets.zero,
          border:         InputBorder.none,
          hintText:       'Type Here...',
          hintStyle: TextStyle(
            color:    kHint,
            fontSize: 13,
          ),
        ),
        cursorColor: kNavy,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ACTION BAR  — Cancel + Update
// ─────────────────────────────────────────────────────────────
class _ActionBar extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onUpdate;
  const _ActionBar({
    required this.onCancel,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:  kWhite,
        border: const Border(
            top: BorderSide(color: kBorder)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        children: [

          // Cancel
          Expanded(
            child: GestureDetector(
              onTap: onCancel,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color:        kWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(0xFFE0E6F0),
                      width: 1.5),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize:   14,
                    fontWeight: FontWeight.w700,
                    color:      kSubText,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Update
          Expanded(
            child: GestureDetector(
              onTap: onUpdate,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color:        kNavy,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color:      Color(0x461A2D5A),
                      blurRadius: 18,
                      offset:     Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize:   14,
                    fontWeight: FontWeight.w700,
                    color:      kWhite,
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}