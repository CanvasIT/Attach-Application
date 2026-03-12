import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: const DoctorProfileScreen(),
    );
  }
}

enum FieldState { pending, approved, declined }

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});
  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  static const Color _navy = Color(0xFF1B2D70);

  FieldState _professionalState = FieldState.pending;
  FieldState _degreeState = FieldState.pending;

  void _setField(String field, FieldState state) => setState(() =>
      field == 'professional' ? _professionalState = state : _degreeState = state);

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
                        const Text('Doctor Profile',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Scrollable body ───────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Big bordered card ─────────────────────
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE8E8E8), width: 1.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Doctor ID + Active badge
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Doctor ID: 5454524',
                                  style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F0F0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text('Active',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF555555))),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),

                        // ── Profile row ───────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xFFF0F0F0),
                                child: Icon(Icons.person_outline, color: Colors.grey.shade400, size: 28),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Dr. Fatima Matrook',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF111111))),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6A817),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text('Doctor',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),

                        // ── Doctor Information label ──────────────
                        const Padding(
                          padding: EdgeInsets.fromLTRB(14, 14, 14, 10),
                          child: Text('Doctor Information',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111111))),
                        ),

                        // ── Form fields ───────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _NormalField(label: 'Doctor Name', value: 'Brooklyn Simmons'),
                              const SizedBox(height: 10),
                              _NormalField(label: 'Email', value: 'example@gmail.com'),
                              const SizedBox(height: 10),
                              _NormalField(label: 'Password', obscure: true),
                              const SizedBox(height: 10),
                              _NormalField(label: 'Date of Birthday', hint: 'DD / MM / YYYY'),
                              const SizedBox(height: 10),
                              _DashField(label: 'Country'),
                              const SizedBox(height: 10),
                              _ReviewField(
                                label: 'Professional Role:',
                                state: _professionalState,
                                onApprove: () => _setField('professional', FieldState.approved),
                                onDecline: () => _setField('professional', FieldState.declined),
                                onReset: () => _setField('professional', FieldState.pending),
                              ),
                              const SizedBox(height: 10),
                              _DashField(label: 'Primary field:'),
                              const SizedBox(height: 10),
                              _DashField(label: 'Sub-discipline / Speciality :'),
                              const SizedBox(height: 10),
                              _DashField(label: 'Name of Institution / Hospital / Organization:'),
                              const SizedBox(height: 10),
                              _ReviewField(
                                label: 'Highest Degree:',
                                state: _degreeState,
                                onApprove: () => _setField('degree', FieldState.approved),
                                onDecline: () => _setField('degree', FieldState.declined),
                                onReset: () => _setField('degree', FieldState.pending),
                              ),
                              const SizedBox(height: 10),
                              _DashField(label: 'Experience:'),
                              const SizedBox(height: 10),
                              _DashField(label: 'Approximate Number of Publications:'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom buttons ────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
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
                      minimumSize: const Size(0, 48),
                      side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF555555))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _navy,
                      elevation: 0,
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Update',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),

          // Home bar
          Container(
            color: Colors.white,
            height: 24,
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

// ── Normal text field ──────────────────────────────────────────
class _NormalField extends StatelessWidget {
  final String label;
  final String? value;
  final String? hint;
  final bool obscure;

  const _NormalField({required this.label, this.value, this.hint, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE8E8E8)),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: Color(0xFFAAAAAA), fontWeight: FontWeight.w500)),
          const SizedBox(height: 3),
          Text(
            obscure ? '••• ••• •••' : (value ?? hint ?? ''),
            style: TextStyle(
              fontSize: 13,
              color: value != null ? const Color(0xFF222222) : const Color(0xFFBBBBBB),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dash placeholder field ─────────────────────────────────────
class _DashField extends StatelessWidget {
  final String label;
  const _DashField({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE8E8E8)),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: Color(0xFFAAAAAA), fontWeight: FontWeight.w500)),
          const SizedBox(height: 3),
          const Text('- - - - - - - - - -',
              style: TextStyle(fontSize: 13, color: Color(0xFFCCCCCC), letterSpacing: 1)),
        ],
      ),
    );
  }
}

// ── Interactive review field ───────────────────────────────────
class _ReviewField extends StatelessWidget {
  final String label;
  final FieldState state;
  final VoidCallback onApprove;
  final VoidCallback onDecline;
  final VoidCallback onReset;

  const _ReviewField({
    required this.label,
    required this.state,
    required this.onApprove,
    required this.onDecline,
    required this.onReset,
  });

  Color get _borderColor {
    switch (state) {
      case FieldState.approved: return const Color(0xFF2E7D32);
      case FieldState.declined: return const Color(0xFFE53935);
      case FieldState.pending:  return const Color(0xFFE6A817);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 10, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 11, color: Color(0xFFAAAAAA), fontWeight: FontWeight.w500)),
                const SizedBox(height: 3),
                const Text('- - - - - - - - - -',
                    style: TextStyle(fontSize: 13, color: Color(0xFFCCCCCC), letterSpacing: 1)),
              ],
            ),
          ),
          if (state == FieldState.pending) ...[
            GestureDetector(
              onTap: onApprove,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.check, color: Color(0xFF2E7D32), size: 20),
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDecline,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, color: Color(0xFFE53935), size: 20),
              ),
            ),
          ] else ...[
            GestureDetector(
              onTap: onReset,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.edit_outlined, color: Colors.grey.shade400, size: 18),
              ),
            ),
          ],
        ],
      ),
    );
  }
}