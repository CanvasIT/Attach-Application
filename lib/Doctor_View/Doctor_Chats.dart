import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: const ChatsScreen(),
    );
  }
}

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  static const Color _navy = Color(0xFF1B2D70);

  final List<String> _chats = List.generate(6, (_) => 'Student Name');
  final TextEditingController _searchController = TextEditingController();
  List<String> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = List.from(_chats);
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _chats
          .where((name) => name.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  // Status bar
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
                        Row(children: const [
                          Icon(Icons.signal_cellular_alt,
                              color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Icon(Icons.wifi, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Icon(Icons.battery_full,
                              color: Colors.white, size: 18),
                        ]),
                      ],
                    ),
                  ),
                  // Nav row
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
                        const Text('Chats',
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

          // ── Scrollable content ───────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEBEBEB)),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF444444)),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                  fontSize: 13, color: Colors.grey.shade400),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Icon(Icons.search,
                              color: Colors.grey.shade400, size: 20),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Section label
                  const Text('Chats',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111111))),

                  const SizedBox(height: 12),

                  // Chat list
                  ..._filtered.asMap().entries.map((entry) {
                    final index = entry.key;
                    final name = entry.value;
                    final isHighlighted = index < 2;
                    return _ChatItem(
                      name: name,
                      isHighlighted: isHighlighted,
                    );
                  }),
                ],
              ),
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

// ── Chat Item Widget ───────────────────────────────────────────
class _ChatItem extends StatelessWidget {
  final String name;
  final bool isHighlighted;

  const _ChatItem({required this.name, this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted
              ? const Color(0xFFE0E4F0)
              : const Color(0xFFEFEFEF),
          width: isHighlighted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isHighlighted ? 0.07 : 0.04),
            blurRadius: isHighlighted ? 10 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEF0F7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF8898BB),
                    size: 20,
                  ),
                ),

                const SizedBox(width: 12),

                // Name
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),

                // Chevron
                Icon(Icons.chevron_right,
                    color: Colors.grey.shade300, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
