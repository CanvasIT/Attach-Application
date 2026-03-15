import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Request',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF5F5F5)),
      home: const DoctorRequestScreen(),
    );
  }
}

// ── Model ──────────────────────────────────────────────────────
enum DoctorStatus { unreviewed, approved, declined }

class DoctorRequest {
  final String id;
  final String name;
  final String email;
  final String date;
  final DoctorStatus status;

  const DoctorRequest({
    required this.id,
    required this.name,
    required this.email,
    required this.date,
    required this.status,
  });
}

// ── Screen ─────────────────────────────────────────────────────
class DoctorRequestScreen extends StatefulWidget {
  const DoctorRequestScreen({super.key});
  @override
  State<DoctorRequestScreen> createState() => _DoctorRequestScreenState();
}

class _DoctorRequestScreenState extends State<DoctorRequestScreen> {
  static const Color _navy = Color(0xFF1B2D70);

  int _selectedTab = 0;
  final List<String> _tabs = ['All', 'Un reviewed', 'Approved', 'Declined'];

  final List<DoctorRequest> _requests = const [
    DoctorRequest(
      id: '65555',
      name: 'Doctor Name',
      email: 'example@gmail.com',
      date: '20 July, 2027, 5:30 PM',
      status: DoctorStatus.unreviewed,
    ),
    DoctorRequest(
      id: '65555',
      name: 'Doctor Name',
      email: 'Dr Email',
      date: '20 July, 2027, 5:30 PM',
      status: DoctorStatus.approved,
    ),
    DoctorRequest(
      id: '65555',
      name: 'Doctor Name',
      email: 'Dr Email',
      date: '20 July, 2027, 5:30 PM',
      status: DoctorStatus.declined,
    ),
  ];

  List<DoctorRequest> get _filtered {
    switch (_selectedTab) {
      case 1: return _requests.where((r) => r.status == DoctorStatus.unreviewed).toList();
      case 2: return _requests.where((r) => r.status == DoctorStatus.approved).toList();
      case 3: return _requests.where((r) => r.status == DoctorStatus.declined).toList();
      default: return _requests;
    }
  }

  Color _headerColor(DoctorStatus s) {
    switch (s) {
      case DoctorStatus.unreviewed: return const Color(0xFFE6A817);
      case DoctorStatus.approved:   return const Color(0xFF2E7D32);
      case DoctorStatus.declined:   return const Color(0xFFC62828);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                    padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('9:41',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                        Row(children: const [
                          Icon(Icons.signal_cellular_alt, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Icon(Icons.wifi, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Icon(Icons.battery_full, color: Colors.white, size: 18),
                        ]),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 6, 18, 14),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                          onPressed: () => Navigator.maybePop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 4),
                        const Text('Doctor Request',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Column(
                    children: [
                      // Search bar
                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFEBEBEB)),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 1))],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(fontSize: 13, color: Color(0xFF444444)),
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Tabs
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
                        ),
                        child: Row(
                          children: List.generate(_tabs.length, (i) {
                            final active = _selectedTab == i;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedTab = i),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: active ? _navy : Colors.transparent,
                                      width: 2.5,
                                    ),
                                  ),
                                ),
                                child: Text(_tabs[i],
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                                      color: active ? _navy : Colors.grey,
                                    )),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Cards
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text('No requests found',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade400)))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) => _DoctorCard(
                            request: filtered[i],
                            headerColor: _headerColor(filtered[i].status),
                          ),
                        ),
                ),
              ],
            ),
          ),

          // Home bar
          Container(
            color: const Color(0xFFF5F5F5),
            height: 28,
            child: Center(
              child: Container(
                width: 110, height: 4,
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

// ── Doctor Card Widget ─────────────────────────────────────────
class _DoctorCard extends StatelessWidget {
  final DoctorRequest request;
  final Color headerColor;

  const _DoctorCard({required this.request, required this.headerColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Colored header
          Container(
            color: headerColor,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Doctor ID: ${request.id}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                Text(request.date,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              ],
            ),
          ),

          // White body
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 21,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person_outline, color: Colors.grey, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                    const SizedBox(height: 2),
                    Text(request.email,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
