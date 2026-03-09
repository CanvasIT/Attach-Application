import 'package:flutter/material.dart';


class StudentRegistrationScreen extends StatefulWidget {
  const StudentRegistrationScreen({super.key});

  @override
  State<StudentRegistrationScreen> createState() => _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState extends State<StudentRegistrationScreen> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _showDob = false;

  static const Color _navy = Color(0xFF1B2F72);
  static const Color _grey = Color(0xFFF2F2F2);
  static const Color _hintColor = Color(0xFFBBBBBB);
  static const Color _labelColor = Color(0xFF222222);
  static const Color _subtitleColor = Color(0xFFAAAAAA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Logo
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _navy,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: _StethoscopeIcon()),
              ),

              const SizedBox(height: 20),

              // Title
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Start with create your account.',
                style: TextStyle(
                  fontSize: 13,
                  color: _subtitleColor,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 24),

              // Full Name
              _buildLabel('Full Name'),
              _buildTextField(
                hint: 'Fatima Matrook',
                prefixIcon: Icons.person_outline,
              ),

              const SizedBox(height: 16),

              // Email
              _buildLabel('Email'),
              _buildTextField(
                hint: 'example@gmail.com',
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // Password
              _buildLabel('Password'),
              _buildTextField(
                hint: '••••••••••',
                prefixIcon: Icons.lock_outline,
                obscureText: !_showPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: _hintColor,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _showPassword = !_showPassword),
                ),
              ),

              const SizedBox(height: 16),

              // Confirm Password
              _buildLabel('Confirm Password'),
              _buildTextField(
                hint: '••••••••••',
                prefixIcon: Icons.lock_outline,
                obscureText: !_showConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _showConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: _hintColor,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                ),
              ),

              const SizedBox(height: 16),

              // Date of Birthday
              _buildLabel('Date of Birthday'),
              _buildTextField(
                hint: '** / ** / ****',
                prefixIcon: Icons.lock_outline,
                suffixIcon: Icon(
                  Icons.calendar_month_outlined,
                  color: _hintColor,
                  size: 20,
                ),
                keyboardType: TextInputType.datetime,
              ),

              const SizedBox(height: 16),

              // Major
              _buildLabel('Major'),
              _buildTextField(
                hint: '------------',
                prefixIcon: Icons.person_outline,
              ),

              const SizedBox(height: 16),

              // Country
              _buildLabel('Country'),
              _buildTextField(
                hint: '------------',
                prefixIcon: Icons.flag_outlined,
              ),

              const SizedBox(height: 28),

              // Registration Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Registration',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Or continue with
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(fontSize: 12, color: _subtitleColor),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
                ],
              ),

              const SizedBox(height: 20),

              // Social buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(
                    child: const Icon(Icons.apple, size: 24, color: Colors.black),
                  ),
                  const SizedBox(width: 16),
                  _buildSocialButton(
                    child: _FacebookIcon(),
                  ),
                  const SizedBox(width: 16),
                  _buildSocialButton(
                    child: _GoogleIcon(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Sign In
              Center(
                child: RichText(
                  text: const TextSpan(
                    text: 'You already have an account? ',
                    style: TextStyle(
                      fontSize: 13,
                      color: _subtitleColor,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign In',
                        style: TextStyle(
                          color: _navy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _labelColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      child: TextField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: Color(0xFF444444)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFBBBBBB),
            fontSize: 14,
          ),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFFBBBBBB), size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSocialButton({required Widget child}) {
    return Container(
      width: 64,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
      ),
      child: Center(child: child),
    );
  }
}

// Stethoscope icon
class _StethoscopeIcon extends StatelessWidget {
  const _StethoscopeIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _StethoscopePainter(),
    );
  }
}

class _StethoscopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    canvas.drawCircle(Offset(w * 0.22, h * 0.18), w * 0.07, dotPaint);
    canvas.drawCircle(Offset(w * 0.78, h * 0.18), w * 0.07, dotPaint);

    final path = Path()
      ..moveTo(w * 0.22, h * 0.18)
      ..lineTo(w * 0.22, h * 0.52)
      ..quadraticBezierTo(w * 0.22, h * 0.76, w * 0.50, h * 0.76)
      ..moveTo(w * 0.78, h * 0.18)
      ..lineTo(w * 0.78, h * 0.52)
      ..quadraticBezierTo(w * 0.78, h * 0.76, w * 0.50, h * 0.76);

    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(w * 0.50, h * 0.84), w * 0.10, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Facebook icon
class _FacebookIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _FacebookPainter(),
    );
  }
}

class _FacebookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1877F2);
    final w = size.width;
    final h = size.height;

    // Circle background
    canvas.drawCircle(Offset(w / 2, h / 2), w / 2, paint);

    // f letter
    final textPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    // Simple "f" shape
    path.moveTo(w * 0.58, h * 0.38);
    path.lineTo(w * 0.52, h * 0.38);
    path.quadraticBezierTo(w * 0.46, h * 0.38, w * 0.46, h * 0.44);
    path.lineTo(w * 0.46, h * 0.50);
    path.lineTo(w * 0.40, h * 0.50);
    path.lineTo(w * 0.40, h * 0.58);
    path.lineTo(w * 0.46, h * 0.58);
    path.lineTo(w * 0.46, h * 0.78);
    path.lineTo(w * 0.54, h * 0.78);
    path.lineTo(w * 0.54, h * 0.58);
    path.lineTo(w * 0.60, h * 0.58);
    path.lineTo(w * 0.62, h * 0.50);
    path.lineTo(w * 0.54, h * 0.50);
    path.lineTo(w * 0.54, h * 0.45);
    path.quadraticBezierTo(w * 0.54, h * 0.42, w * 0.57, h * 0.42);
    path.lineTo(w * 0.60, h * 0.42);
    path.close();

    canvas.drawPath(path, textPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Google icon
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _GooglePainter(),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w * 0.45;

    // Red arc (top-right)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.52, 1.57, false,
      Paint()
        ..color = const Color(0xFFEA4335)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.12
        ..strokeCap = StrokeCap.round,
    );
    // Blue arc (left)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      1.05, 1.57, false,
      Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.12
        ..strokeCap = StrokeCap.round,
    );
    // Yellow arc (bottom)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.62, 1.05, false,
      Paint()
        ..color = const Color(0xFFFBBC05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.12
        ..strokeCap = StrokeCap.round,
    );
    // Green arc (bottom-right to right)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.67, 0.78, false,
      Paint()
        ..color = const Color(0xFF34A853)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.12
        ..strokeCap = StrokeCap.round,
    );

    // Horizontal bar
    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(center.dx + radius, center.dy),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = w * 0.12
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
