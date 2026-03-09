import 'package:flutter/material.dart';
import '../Doctor_View/Registration_Doctor.dart';
import '../Student_View/Registration_Student.dart';
//change handle ontap i n line 121

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? _selectedRole; // null = none selected, 'doctor' or 'student'

  static const Color _navyBlue = Color(0xFF1B2F72);
  static const Color _greyBg = Color(0xFFE8E8E8);
  static const Color _greyText = Color(0xFF1B2F72);
  static const Color _subtitleColor = Color(0xFFAAAAAA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: _navyBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: _StethoscopeIcon(),
                  ),
                ),

                const SizedBox(height: 28),

                // Title
                const Text(
                  'Start Your Joureny',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 6),

                // Subtitle
                const Text(
                  'By Choosing You Role.',
                  style: TextStyle(
                    fontSize: 13,
                    color: _subtitleColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 48),

                // Doctor Button
                _RoleButton(
                  label: 'Doctor',
                  isSelected: _selectedRole == 'doctor',
                  onTap: () {
                    setState(() {
                      _selectedRole = _selectedRole == 'doctor' ? null : 'doctor';
                    });
                  },
                ),

                const SizedBox(height: 14),

                // Student Button
                _RoleButton(
                  label: 'Student',
                  isSelected: _selectedRole == 'student',
                  onTap: () {
                    setState(() {
                      _selectedRole = _selectedRole == 'student' ? null : 'student';
                    });
                  },
                ),

                const SizedBox(height: 48),

                // Continue Registration
                Center(
                  child: GestureDetector(
                   onTap: () {
  if (_selectedRole == null) return;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => _selectedRole == 'doctor'
          ? DoctorRegistrationScreen(role: 'doctor')
          : StudentRegistrationScreen(),
    ),
  );
},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Continue  Registration',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: _navyBlue,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: _navyBlue,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color _navyBlue = Color(0xFF1B2F72);
  static const Color _greyBg = Color(0xFFE8E8E8);

  const _RoleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? _navyBlue : _greyBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : _navyBlue,
              letterSpacing: 0.1,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

// Custom stethoscope icon painted with Canvas
class _StethoscopeIcon extends StatelessWidget {
  const _StethoscopeIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(32, 32),
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
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double w = size.width;
    final double h = size.height;

    // Left earpiece dot
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.22, h * 0.18), w * 0.06, dotPaint);

    // Right earpiece dot
    canvas.drawCircle(Offset(w * 0.78, h * 0.18), w * 0.06, dotPaint);

    // Left tube going down then curving right
    final path = Path();
    path.moveTo(w * 0.22, h * 0.18);
    path.lineTo(w * 0.22, h * 0.50);
    path.quadraticBezierTo(
      w * 0.22, h * 0.75,
      w * 0.50, h * 0.75,
    );

    // Right tube going down then curving left to meet center
    path.moveTo(w * 0.78, h * 0.18);
    path.lineTo(w * 0.78, h * 0.50);
    path.quadraticBezierTo(
      w * 0.78, h * 0.75,
      w * 0.50, h * 0.75,
    );

    canvas.drawPath(path, paint);

    // Chest piece circle
    canvas.drawCircle(Offset(w * 0.50, h * 0.80), w * 0.11, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
