import 'dart:math' as math;
import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  static const Color _navy = Color(0xFF1B2F72);

  final List<TextEditingController> _controllers = List.generate(
    4,
    (i) => TextEditingController(text: i < 3 ? ['0', '8', '4'][i] : ''),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onVerifyPressed() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Show the success bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.35),
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      builder: (_) => const _RegisterSuccessSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Nav bar ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: _navy, size: 28),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const Text(
                    'Verification',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111111),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),

            // ── Centered content ─────────────────────────────
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Badge icon
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CustomPaint(painter: _BadgePainter()),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'Verification Code',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111111),
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'We have sent the verification code to',
                        style: TextStyle(fontSize: 13.5, color: Color(0xFF999999)),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'examole@email.com',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: _navy,
                        ),
                      ),

                      const SizedBox(height: 36),

                      // OTP row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, _buildOtpBox),
                      ),

                      const SizedBox(height: 36),

                      // Verify button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _onVerifyPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _navy,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Resend
                      RichText(
                        text: const TextSpan(
                          text: "Didn't received the code? ",
                          style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
                          children: [
                            TextSpan(
                              text: 'Resend',
                              style: TextStyle(
                                color: _navy,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    final bool isEmpty = _controllers[index].text.isEmpty;
    return Container(
      width: 68,
      height: 68,
      margin: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: isEmpty ? const Color(0xFFEBEBEB) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? _navy
              : const Color(0xFFE8E8E8),
          width: 1.5,
        ),
        boxShadow: isEmpty
            ? []
            : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: _navy,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            setState(() {});
            if (value.isNotEmpty && index < 3) {
              _focusNodes[index].unfocus();
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index].unfocus();
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Register Success bottom sheet
// ─────────────────────────────────────────────────────────────
class _RegisterSuccessSheet extends StatelessWidget {
  const _RegisterSuccessSheet();

  static const Color _navy = Color(0xFF1B2F72);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(28, 14, 28, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          const Text(
            'Register Success',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111111),
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 12),

          // Description
          const Text(
            'Congratulation! Your account already account\nPlease login',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF999999),
              height: 1.65,
            ),
          ),

          const SizedBox(height: 30),

          // Login button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _navy,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Badge / seal painter
// ─────────────────────────────────────────────────────────────
class _BadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width * 0.44;
    const int points = 16;

    final sealPaint = Paint()
      ..color = const Color(0xFF1B2F72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final double angle = (i * math.pi / points) - math.pi / 2;
      final double rad = (i % 2 == 0) ? r : r * 0.88;
      final double x = cx + rad * math.cos(angle);
      final double y = cy + rad * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, sealPaint);

    final checkPaint = Paint()
      ..color = const Color(0xFF1B2F72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final checkPath = Path()
      ..moveTo(cx - r * 0.35, cy + r * 0.02)
      ..lineTo(cx - r * 0.08, cy + r * 0.28)
      ..lineTo(cx + r * 0.38, cy - r * 0.25);

    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
