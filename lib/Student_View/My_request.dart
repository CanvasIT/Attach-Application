import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Constants ────────────────────────────────────────────────────────────────
const kNavy    = Color(0xFF1A2D5A);
const kBgGrey  = Color(0xFFF0F3FA);
const kBorder  = Color(0xFFDDE2EF);
const kGrey    = Color(0xFF9AA3B8);
const kGreen   = Color(0xFF27AE75);
const kYellow  = Color(0xFFF5A623);
const kRed     = Color(0xFFE74C3C);

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyRequestPage(),
    ));

// ─── Enums ────────────────────────────────────────────────────────────────────
enum RequestStatus { pending, approved, declined }

// ─── Model ────────────────────────────────────────────────────────────────────
class RequestModel {
  final String consultationId;
  final String doctorName;
  final String location;
  final String degree;
  final String fieldName;
  final String appointment;
  final RequestStatus status;

  const RequestModel({
    required this.consultationId,
    required this.doctorName,
    required this.location,
    required this.degree,
    required this.fieldName,
    required this.appointment,
    required this.status,
  });
}

// ─── Sample Data ──────────────────────────────────────────────────────────────
final List<RequestModel> _allRequests = [
  const RequestModel(
    consultationId: '#RS23454',
    doctorName: 'Dr. Alexa Smith',
    location: 'Location',
    degree: 'Degree',
    fieldName: 'Field Name',
    appointment: '12 January, 2027, 12 AM to 5 PM',
    status: RequestStatus.pending,
  ),
  const RequestModel(
    consultationId: '#RS23454',
    doctorName: 'Dr. Alexa Smith',
    location: 'Location',
    degree: 'Degree',
    fieldName: 'Field Name',
    appointment: '12 January, 2027, 12 AM to 5 PM',
    status: RequestStatus.declined,
  ),
  const RequestModel(
    consultationId: '#RS23454',
    doctorName: 'Dr. Alexa Smith',
    location: 'Location',
    degree: 'Degree',
    fieldName: 'Field Name',
    appointment: '12 January, 2027, 12 AM to 5 PM',
    status: RequestStatus.approved,
  ),
  const RequestModel(
    consultationId: '#RS23454',
    doctorName: 'Dr. Alexa Smith',
    location: 'Location',
    degree: 'Degree',
    fieldName: 'Field Name',
    appointment: '15 January, 2027, 9 AM to 2 PM',
    status: RequestStatus.declined,
  ),
  const RequestModel(
    consultationId: '#RS23455',
    doctorName: 'Dr. Alexa Smith',
    location: 'Location',
    degree: 'Degree',
    fieldName: 'Field Name',
    appointment: '20 January, 2027, 10 AM to 3 PM',
    status: RequestStatus.approved,
  ),
  const RequestModel(
    consultationId: '#RS23456',
    doctorName: 'Dr. Alexa Smith',
    location: 'Location',
    degree: 'Degree',
    fieldName: 'Field Name',
    appointment: '22 January, 2027, 8 AM to 1 PM',
    status: RequestStatus.pending,
  ),
];

// ─── Page ─────────────────────────────────────────────────────────────────────
class MyRequestPage extends StatefulWidget {
  const MyRequestPage({super.key});

  @override
  State<MyRequestPage> createState() => _MyRequestPageState();
}

class _MyRequestPageState extends State<MyRequestPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _tabLabels = [
    'All Request',
    'Pending',
    'Approved',
    'Declined',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Filter requests by tab + search
  List<RequestModel> _filteredRequests(int tabIndex) {
    List<RequestModel> list;
    switch (tabIndex) {
      case 1:
        list = _allRequests
            .where((r) => r.status == RequestStatus.pending)
            .toList();
        break;
      case 2:
        list = _allRequests
            .where((r) => r.status == RequestStatus.approved)
            .toList();
        break;
      case 3:
        list = _allRequests
            .where((r) => r.status == RequestStatus.declined)
            .toList();
        break;
      default:
        list = List.from(_allRequests);
    }
    if (_searchQuery.isNotEmpty) {
      list = list.where((r) {
        return r.doctorName.toLowerCase().contains(_searchQuery) ||
            r.consultationId.toLowerCase().contains(_searchQuery) ||
            r.fieldName.toLowerCase().contains(_searchQuery);
      }).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGrey,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchAndTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                _tabLabels.length,
                (i) => _buildCardList(i),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── AppBar ──────────────────────────────────────────────────────────────
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
      title: const Text(
        'My Request',
        style: TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
      ),
      centerTitle: false,
    );
  }

  // ─── Search + Tabs ───────────────────────────────────────────────────────
  Widget _buildSearchAndTabs() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: kBgGrey,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: kBorder),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 11),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 13, color: kNavy),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: kGrey, fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 11),
                    child: Icon(Icons.search_rounded, color: kNavy, size: 20),
                  ),
                ],
              ),
            ),
          ),
          // Tab bar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: kNavy,
            unselectedLabelColor: kGrey,
            labelStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500),
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(color: kNavy, width: 2.5),
              insets: EdgeInsets.zero,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: kBorder,
            padding: const EdgeInsets.only(left: 0),
            tabs: _tabLabels
                .map((l) => Tab(text: l, height: 38))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ─── Card List per tab ───────────────────────────────────────────────────
  Widget _buildCardList(int tabIndex) {
    return AnimatedBuilder(
      animation: _searchController,
      builder: (_, __) {
        final items = _filteredRequests(tabIndex);
        if (items.isEmpty) {
          return _buildEmptyState();
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          itemCount: items.length,
          itemBuilder: (_, i) => _RequestCard(
            request: items[i],
            onDetailsTap: () => _showResearchDetailsSheet(context),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.description_outlined, size: 56, color: kGrey.withOpacity(.4)),
          const SizedBox(height: 14),
          const Text('No requests found',
              style: TextStyle(
                  color: kGrey, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // ─── Bottom Navigation ───────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: kNavy.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, -3))
        ],
        border: const Border(top: BorderSide(color: kBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Home', active: false),
              _NavItem(
                  icon: Icons.grid_view_rounded,
                  label: 'List of Dr',
                  active: false),
              _NavItem(
                  icon: Icons.assignment_outlined,
                  label: 'My Request',
                  active: true),
              _NavItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Chat',
                  active: false),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Research Details Bottom Sheet ──────────────────────────────────────
  void _showResearchDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.38),
      builder: (_) => const _ResearchDetailsSheet(),
    );
  }
}

// ─── Request Card Widget ──────────────────────────────────────────────────────
class _RequestCard extends StatelessWidget {
  final RequestModel request;
  final VoidCallback onDetailsTap;

  const _RequestCard({required this.request, required this.onDetailsTap});

  Color get _statusColor {
    switch (request.status) {
      case RequestStatus.pending:
        return kYellow;
      case RequestStatus.approved:
        return kGreen;
      case RequestStatus.declined:
        return kRed;
    }
  }

  String get _statusLabel {
    switch (request.status) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.declined:
        return 'Declined';
    }
  }

  bool get _isDeclined => request.status == RequestStatus.declined;
  bool get _isApproved => request.status == RequestStatus.approved;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isDeclined ? 0.52 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
          boxShadow: [
            BoxShadow(
                color: kNavy.withOpacity(.07),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(14)),
                border: Border(
                    bottom: BorderSide(color: kBgGrey, width: 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Consultation ID ${request.consultationId}',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: kNavy),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Details badge (approved only)
                  if (_isApproved) ...[
                    GestureDetector(
                      onTap: onDetailsTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: kNavy,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Details',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                  // Status badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: _isApproved
                          ? _statusColor
                          : _statusColor.withOpacity(.07),
                      borderRadius: BorderRadius.circular(20),
                      border: _isApproved
                          ? null
                          : Border.all(color: _statusColor, width: 1.5),
                    ),
                    child: Text(
                      _statusLabel,
                      style: TextStyle(
                          color: _isApproved ? Colors.white : _statusColor,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder with optional delete icon
                  SizedBox(
                    width: 64,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // top spacer so delete icon has room
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: 64,
                            height: 72,
                            decoration: BoxDecoration(
                              color: kBgGrey,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kBorder),
                            ),
                            child: const Icon(Icons.image_outlined,
                                color: kGrey, size: 26),
                          ),
                        ),
                        if (_isDeclined)
                          Positioned(
                            top: 0,
                            right: -5,
                            child: Container(
                              width: 21,
                              height: 21,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: kBorder),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(.06),
                                      blurRadius: 4)
                                ],
                              ),
                              child: const Icon(Icons.delete_outline_rounded,
                                  color: kGrey, size: 13),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Doctor info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(request.doctorName,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: kNavy)),
                        const SizedBox(height: 2),
                        Text('${request.location} · ${request.degree}',
                            style: const TextStyle(
                                fontSize: 11,
                                color: kGrey,
                                height: 1.5)),
                        const SizedBox(height: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isDeclined
                                ? kNavy.withOpacity(.6)
                                : kNavy,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(request.fieldName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Appointment row ────────────────────────
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: kBgGrey, width: 1)),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(14)),
              ),
              child: RichText(
                text: TextSpan(
                  style:
                      const TextStyle(fontSize: 11, color: kGrey, height: 1.4),
                  children: [
                    const TextSpan(text: 'Appointment: '),
                    TextSpan(
                      text: request.appointment,
                      style: const TextStyle(
                          color: kNavy, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Research Details Bottom Sheet ───────────────────────────────────────────
class _ResearchDetailsSheet extends StatefulWidget {
  const _ResearchDetailsSheet();

  @override
  State<_ResearchDetailsSheet> createState() => _ResearchDetailsSheetState();
}

class _ResearchDetailsSheetState extends State<_ResearchDetailsSheet> {
  bool _overviewExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFD0D6E8),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Text(
              'Research Details',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: kNavy),
            ),
          ),
          const Divider(height: 1, color: kBorder),

          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview accordion trigger
                GestureDetector(
                  onTap: () =>
                      setState(() => _overviewExpanded = !_overviewExpanded),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: kBorder),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.description_outlined,
                            color: kNavy, size: 18),
                        const SizedBox(width: 9),
                        const Expanded(
                          child: Text('Overview...',
                              style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: kNavy)),
                        ),
                        AnimatedRotation(
                          turns: _overviewExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: kGrey,
                              size: 22),
                        ),
                      ],
                    ),
                  ),
                ),

                // Accordion content
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 280),
                  crossFadeState: _overviewExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 10, 4, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Professional Role:',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: kNavy,
                                height: 1.6)),
                        Text('Professor',
                            style: TextStyle(
                                fontSize: 12.5, color: kGrey, height: 1.6)),
                        Text('Primary Field:',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: kNavy,
                                height: 1.6)),
                        Text('Health & Life Sciences',
                            style: TextStyle(
                                fontSize: 12.5, color: kGrey, height: 1.6)),
                        Text('Sub-Discipline:',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: kNavy,
                                height: 1.6)),
                        Text('any....',
                            style: TextStyle(
                                fontSize: 12.5, color: kGrey, height: 1.6)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                const Text('Description',
                    style: TextStyle(fontSize: 13, color: kGrey)),
              ],
            ),
          ),

          // Buttons
          Padding(
            padding: EdgeInsets.fromLTRB(
                18, 10, 18, MediaQuery.of(context).padding.bottom + 18),
            child: Column(
              children: [
                // Cancel
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC4CCDB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 10),
                // Pay
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Pay',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Nav Item Widget ──────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem(
      {required this.icon, required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? kNavy : kGrey, size: 24),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: active ? kNavy : kGrey,
                  fontSize: 9.5,
                  fontWeight:
                      active ? FontWeight.w700 : FontWeight.w400)),
          const SizedBox(height: 2),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: active ? 18 : 0,
            height: 3,
            decoration: BoxDecoration(
              color: kNavy,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}