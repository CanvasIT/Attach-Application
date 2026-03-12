import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF5F5F5)),
      home: const NotificationsScreen(),
    );
  }
}

// ── Model ──────────────────────────────────────────────────────
class NotifItem {
  final String id;
  final String title;
  final String body;
  final String time;
  final Color iconColor;
  final IconData icon;
  final String? highlight; // e.g. order number

  NotifItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.iconColor,
    required this.icon,
    this.highlight,
  });
}

// ── Screen ─────────────────────────────────────────────────────
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const Color _navy = Color(0xFF1B2D70);

  final List<NotifItem> _notifications = [
    NotifItem(
      id: '1',
      title: 'Received Order',
      body: 'Thank you! Your order #546567 has been placed successfully.',
      time: '1 min ago',
      iconColor: Color(0xFF1B2D70),
      icon: Icons.store_outlined,
      highlight: '#546567',
    ),
    NotifItem(
      id: '2',
      title: 'Discount Offer',
      body: 'Hurry! Get up to 50% off on selected items. Shop now!',
      time: '1 min ago',
      iconColor: Color(0xFF2E7D32),
      icon: Icons.local_offer_outlined,
    ),
    NotifItem(
      id: '3',
      title: 'Seasonal Sale',
      body: "Our Sale is live! Grab your favorite deals before they're gone!",
      time: '1 min ago',
      iconColor: Color(0xFFF59E0B),
      icon: Icons.wb_sunny_outlined,
    ),
    NotifItem(
      id: '4',
      title: 'Cart Reminder',
      body: "Our Sale is live! Grab your favorite deals before they're gone!",
      time: '1 min ago',
      iconColor: Color(0xFFE53935),
      icon: Icons.shopping_cart_outlined,
    ),
    NotifItem(
      id: '5',
      title: 'Cart Reminder',
      body: "Our Sale is live! Grab your favorite deals before they're gone!",
      time: '1 min ago',
      iconColor: Color(0xFF00897B),
      icon: Icons.shopping_cart_outlined,
    ),
  ];

  void _dismiss(String id) {
    setState(() => _notifications.removeWhere((n) => n.id == id));
  }

  @override
  Widget build(BuildContext context) {
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
                        const Text('Notifications',
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

          // ── Notifications list ────────────────────────────
          Expanded(
            child: _notifications.isEmpty
                ? _buildEmpty()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final item = _notifications[index];
                      return _NotifCard(
                        key: ValueKey(item.id),
                        item: item,
                        onDismiss: () => _dismiss(item.id),
                      );
                    },
                  ),
          ),

          // Home bar
          Container(
            color: const Color(0xFFF5F5F5),
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

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 52, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text('No notifications',
              style: TextStyle(
                  fontSize: 14, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

// ── Notification Card Widget ───────────────────────────────────
class _NotifCard extends StatelessWidget {
  final NotifItem item;
  final VoidCallback onDismiss;

  const _NotifCard({
    super.key,
    required this.item,
    required this.onDismiss,
  });

  // Build body text with highlighted order number
  Widget _buildBody() {
    if (item.highlight == null) {
      return Text(
        item.body,
        style: const TextStyle(
            fontSize: 12, color: Color(0xFF888888), height: 1.55),
      );
    }

    final parts = item.body.split(item.highlight!);
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            fontSize: 12, color: Color(0xFF888888), height: 1.55),
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: item.highlight,
            style: const TextStyle(
                color: Color(0xFF1B2D70), fontWeight: FontWeight.w700),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 10, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon circle
              Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: item.iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: Colors.white, size: 18),
              ),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A))),
                    const SizedBox(height: 4),
                    _buildBody(),
                    const SizedBox(height: 6),
                    Text(item.time,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFFBBBBBB))),
                  ],
                ),
              ),

              // Dismiss button
              GestureDetector(
                onTap: onDismiss,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.close,
                      size: 16, color: Colors.grey.shade400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
