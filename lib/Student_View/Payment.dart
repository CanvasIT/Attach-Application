import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Constants ────────────────────────────────────────────────────────────────
const kNavy   = Color(0xFF1A2D5A);
const kBgGrey = Color(0xFFF0F3FA);
const kBorder = Color(0xFFDDE2EF);
const kGrey   = Color(0xFF9AA3B8);
const kGreen  = Color(0xFF27AE75);
const kRed    = Color(0xFFE74C3C);

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaymentPage(),
    ));

// ══════════════════════════════════════════════════════════════════════════════
// SCREEN 12 — Payment
// ══════════════════════════════════════════════════════════════════════════════
class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGrey,
      appBar: _navyAppBar(context, 'Payment'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor card
                  _DoctorCard(),
                  const SizedBox(height: 18),
                  // Payment summary
                  const Text('Payment Summary',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: kNavy)),
                  const SizedBox(height: 12),
                  _SummaryRow(label: 'Subtotal', value: '\$45.00'),
                  const SizedBox(height: 7),
                  _SummaryRow(
                      label: 'Discount applied',
                      value: '-\$20.00',
                      valueColor: kRed),
                  const Divider(color: kBorder, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Total Amount',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: kNavy)),
                      Text('\$25.00',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: kNavy)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _BottomCta(
            label: 'Confirm Payment',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PaymentMethodPage())),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SCREEN 13 — Payment Method (options list)
// ══════════════════════════════════════════════════════════════════════════════
class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _navyAppBar(context, 'Payment Method'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Debit & Credit Card
                  _SectionHeading('Debit & Credit Card'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _OptionCard(children: [
                      _MethodRow(
                        icon: Icons.credit_card_outlined,
                        label: 'Add Card',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const SavedCardsPage())),
                      ),
                    ]),
                  ),
                  // More Payment Options
                  _SectionHeading('More Payment Options'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _OptionCard(children: [
                      _MethodRow(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Google Pay'),
                      _MethodRow(
                          icon: Icons.apple_outlined,
                          label: 'Apple Pay'),
                      _MethodRow(
                          icon: Icons.send_outlined,
                          label: 'Paypal',
                          isLast: true),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          _BottomCta(label: 'Confirm Payment', onTap: () {}),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SCREEN 14 — Saved Cards
// ══════════════════════════════════════════════════════════════════════════════
class SavedCardsPage extends StatefulWidget {
  const SavedCardsPage({super.key});

  @override
  State<SavedCardsPage> createState() => _SavedCardsPageState();
}

class _SavedCardsPageState extends State<SavedCardsPage> {
  int _selectedCard = 1; // 0=Visa, 1=Master

  final List<Map<String, String>> _cards = [
    {
      'holder': 'Alexa Smith',
      'type': 'Visa',
      'number': 'Visa \u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022 788',
      'expiry': 'Expiry Date: 08/29',
    },
    {
      'holder': 'Alexa Smith',
      'type': 'Master',
      'number': 'Master \u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022 6556',
      'expiry': 'Expiry Date: 08/29',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGrey,
      appBar: _navyAppBar(context, 'Payment Method'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              itemCount: _cards.length,
              itemBuilder: (_, i) => _CardItem(
                card: _cards[i],
                isSelected: _selectedCard == i,
                onTap: () => setState(() => _selectedCard = i),
                onDelete: () => setState(() => _cards.removeAt(i)),
              ),
            ),
          ),
          _BottomCta(
            label: 'Add Payment Method',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CongratsPage())),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SCREEN 15 — Congratulations
// ══════════════════════════════════════════════════════════════════════════════
class CongratsPage extends StatelessWidget {
  const CongratsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Light status bar (dark icons on white)
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                children: [
                  // ── Hero circle ───────────────────────────
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kNavy,
                      border: Border.all(
                          color: kNavy.withOpacity(.2), width: 8),
                      boxShadow: [
                        BoxShadow(
                          color: kNavy.withOpacity(.12),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: kGreen, size: 42),
                  ),
                  const SizedBox(height: 18),

                  // ── Titles ────────────────────────────────
                  const Text('Congratulations!',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: kNavy)),
                  const SizedBox(height: 6),
                  const Text('Your appointment successfully booked !',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: kGrey)),
                  const SizedBox(height: 20),

                  // ── Booking card ──────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: kBorder),
                      boxShadow: [
                        BoxShadow(
                            color: kNavy.withOpacity(.06),
                            blurRadius: 10,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Column(
                      children: [
                        // Doctor row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 54,
                              height: 60,
                              decoration: BoxDecoration(
                                color: kBgGrey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: kBorder),
                              ),
                              child: const Icon(Icons.image_outlined,
                                  color: kGrey, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Dr. Alexa\nSmith',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: kNavy,
                                        height: 1.35)),
                                const SizedBox(height: 3),
                                const Text('Location · Degree',
                                    style: TextStyle(
                                        fontSize: 11, color: kGrey)),
                                const SizedBox(height: 7),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: kNavy,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: const Text('Field Name',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 1, color: kBgGrey,
                        ),
                        const SizedBox(height: 12),
                        // Appointment row
                        Row(
                          children: const [
                            Icon(Icons.access_time_outlined,
                                color: kGrey, size: 18),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Appointment',
                                    style:
                                        TextStyle(fontSize: 10, color: kGrey)),
                                SizedBox(height: 2),
                                Text('12 January, 2027, 12 AM to 5 PM',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: kNavy)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Two buttons ───────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (r) => r.isFirst);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: kBorder, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: kBgGrey,
                    ),
                    child: const Text('Back to Home',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: kNavy)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Add Calender',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
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

// ══════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ══════════════════════════════════════════════════════════════════════════════

// ─── Navy AppBar helper ───────────────────────────────────────────────────────
PreferredSizeWidget _navyAppBar(BuildContext context, String title) {
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
    title: Text(title,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700)),
    centerTitle: false,
  );
}

// ─── Doctor Card ──────────────────────────────────────────────────────────────
class _DoctorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
        boxShadow: [
          BoxShadow(
              color: kNavy.withOpacity(.06),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 62,
            decoration: BoxDecoration(
              color: kBgGrey,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kBorder),
            ),
            child: const Icon(Icons.image_outlined, color: kGrey, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dr. Alexa Smith',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kNavy)),
              const SizedBox(height: 2),
              const Text('Location · Degree',
                  style: TextStyle(fontSize: 11, color: kGrey)),
              const SizedBox(height: 7),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: kNavy,
                    borderRadius: BorderRadius.circular(7)),
                child: const Text('Field Name',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Summary Row ──────────────────────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: kGrey)),
        Text(value,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: valueColor ?? kNavy)),
      ],
    );
  }
}

// ─── Section Heading ──────────────────────────────────────────────────────────
class _SectionHeading extends StatelessWidget {
  final String text;
  const _SectionHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(text,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: kNavy)),
    );
  }
}

// ─── Option Card (rounded container for list rows) ────────────────────────────
class _OptionCard extends StatelessWidget {
  final List<Widget> children;
  const _OptionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
        boxShadow: [
          BoxShadow(
              color: kNavy.withOpacity(.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(children: children),
    );
  }
}

// ─── Method Row (inside option card) ─────────────────────────────────────────
class _MethodRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isLast;

  const _MethodRow({
    required this.icon,
    required this.label,
    this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: isLast
            ? null
            : const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: kBgGrey, width: 1))),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: kBgGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: kNavy, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: kNavy))),
            const Icon(Icons.chevron_right_rounded,
                color: kGrey, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Card Item (screen 14) ────────────────────────────────────────────────────
class _CardItem extends StatelessWidget {
  final Map<String, String> card;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CardItem({
    required this.card,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? kNavy : kBorder,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
                color: kNavy.withOpacity(.07),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: kBgGrey,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.credit_card_outlined,
                  color: kNavy, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(card['holder']!,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: kNavy)),
                  const SizedBox(height: 2),
                  Text(card['number']!,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: kNavy)),
                  const SizedBox(height: 2),
                  Text(card['expiry']!,
                      style: const TextStyle(
                          fontSize: 10, color: kGrey)),
                ],
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: kGrey, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom CTA ───────────────────────────────────────────────────────────────
class _BottomCta extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _BottomCta({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: kNavy,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13)),
          ),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}