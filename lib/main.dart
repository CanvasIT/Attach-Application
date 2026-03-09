import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Common_View/Registration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'DMSans',
        scaffoldBackgroundColor: const Color(0xFFF2F4F7),
      ),
      home: const LoginScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// SCREEN 1 — Login
// ─────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _showForgotPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ForgotPasswordSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1B4B),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D1B4B).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.medical_services_outlined,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(height: 28),
              const Text('Hello Again!',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D1B4B),
                      letterSpacing: -0.5)),
              const SizedBox(height: 6),
              const Text('Welcome back! Please Enter Your Details.',
                  style: TextStyle(fontSize: 13.5, color: Color(0xFF9098A3))),
              const SizedBox(height: 36),
              _FieldLabel('Email'),
              _InputField(
                controller: _emailCtrl,
                hint: 'Enter your email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _FieldLabel('Password'),
              _InputField(
                controller: _passwordCtrl,
                hint: 'Enter your password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF9098A3),
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (v) =>
                                setState(() => _rememberMe = v ?? false),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            side: const BorderSide(
                                color: Color(0xFFBEC5CF), width: 1.5),
                            activeColor: const Color(0xFF0D1B4B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Remember me',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFF9098A3))),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _showForgotPassword,
                    child: const Text('Forgot password?',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D1B4B))),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _PrimaryButton(label: 'Sign in', onPressed: () {}),
              const SizedBox(height: 28),
              Row(children: [
                const Expanded(
                    child: Divider(color: Color(0xFFDDE2E8), thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Or continue with',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade500)),
                ),
                const Expanded(
                    child: Divider(color: Color(0xFFDDE2E8), thickness: 1)),
              ]),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialButton(
                      icon: const Icon(Icons.apple,
                          size: 24, color: Color(0xFF1A1A2E)),
                      onTap: () {}),
                  const SizedBox(width: 14),
                  _SocialButton(
                      icon: _FacebookIcon(),
                      onTap: () {}),
                  const SizedBox(width: 14),
                  _SocialButton(
                      icon: const Text('G',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4285F4))),
                      onTap: () {}),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF9098A3)),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const RegistrationScreen()),
  );
},
                          child: const Text('Sign Up',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D1B4B))),
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
}

// ─────────────────────────────────────────────
// BOTTOM SHEET 1 — Forgot Password
// ─────────────────────────────────────────────
class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({super.key});

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onReset() {
    final email = _emailCtrl.text.trim().isEmpty
        ? 'smith@example.com'
        : _emailCtrl.text.trim();
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VerifyEmailSheet(email: email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SheetWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetHandle(),
          const Text('Forgot Password',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D1B4B))),
          const SizedBox(height: 6),
          const Text('Enter your email .',
              style: TextStyle(fontSize: 13, color: Color(0xFF9098A3))),
          const SizedBox(height: 22),
          _FieldLabel('Your Email'),
          _InputField(
            controller: _emailCtrl,
            hint: 'examples@gmail.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _PrimaryButton(label: 'Reset Password', onPressed: _onReset),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BOTTOM SHEET 2 — Verify Email (OTP)
// ─────────────────────────────────────────────
class VerifyEmailSheet extends StatefulWidget {
  final String email;
  const VerifyEmailSheet({super.key, required this.email});

  @override
  State<VerifyEmailSheet> createState() => _VerifyEmailSheetState();
}

class _VerifyEmailSheetState extends State<VerifyEmailSheet> {
  final List<TextEditingController> _otpCtrls =
      List.generate(4, (_) => TextEditingController(text: '0'));
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _otpCtrls) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onVerify() {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreatePasswordSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SheetWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetHandle(),
          const Text('Check Your Email',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D1B4B))),
          const SizedBox(height: 6),
          Text(
            'We sent a password reset link to ${widget.email}',
            style: const TextStyle(fontSize: 13, color: Color(0xFF9098A3)),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              return Padding(
                padding: EdgeInsets.only(right: i < 3 ? 12 : 0),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: TextField(
                    controller: _otpCtrls[i],
                    focusNode: _focusNodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D1B4B)),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: Color(0xFFDDE2E8), width: 1.8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: Color(0xFFDDE2E8), width: 1.8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: Color(0xFF0D1B4B), width: 1.8),
                      ),
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 3) {
                        _focusNodes[i + 1].requestFocus();
                      }
                    },
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          _PrimaryButton(label: 'Verify Email', onPressed: _onVerify),
          const SizedBox(height: 18),
          Center(
            child: RichText(
              text: TextSpan(
                text: "Didn't receive the email? ",
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF9098A3)),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        for (final c in _otpCtrls) c.text = '0';
                      },
                      child: const Text('Click to Resend',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D1B4B))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom + 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BOTTOM SHEET 3 — Create New Password
// ─────────────────────────────────────────────
class CreatePasswordSheet extends StatefulWidget {
  const CreatePasswordSheet({super.key});

  @override
  State<CreatePasswordSheet> createState() => _CreatePasswordSheetState();
}

class _CreatePasswordSheetState extends State<CreatePasswordSheet> {
  final _oldPwdCtrl = TextEditingController();
  final _newPwdCtrl = TextEditingController();
  bool _hideOld = true;
  bool _hideNew = true;

  bool get _has8Chars => _newPwdCtrl.text.length >= 8;
  bool get _hasSpecial =>
      RegExp(r'[^A-Za-z0-9]').hasMatch(_newPwdCtrl.text);

  void _onUpdate() {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SuccessScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SheetWrapper(
      child: StatefulBuilder(
        builder: (context, setInner) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SheetHandle(),
              const Text('Create New Password',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D1B4B))),
              const SizedBox(height: 6),
              const Text('Enter your new password',
                  style:
                      TextStyle(fontSize: 13, color: Color(0xFF9098A3))),
              const SizedBox(height: 22),
              _FieldLabel('Old Password'),
              _InputField(
                controller: _oldPwdCtrl,
                hint: 'Enter old password',
                prefixIcon: Icons.lock_outline,
                obscureText: _hideOld,
                suffixIcon: IconButton(
                  icon: Icon(
                    _hideOld
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF9098A3),
                    size: 20,
                  ),
                  onPressed: () => setInner(() => _hideOld = !_hideOld),
                ),
              ),
              const SizedBox(height: 16),
              _FieldLabel('New Password'),
              _InputField(
                controller: _newPwdCtrl,
                hint: 'Enter new password',
                prefixIcon: Icons.lock_outline,
                obscureText: _hideNew,
                onChanged: (_) => setInner(() {}),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hideNew
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF9098A3),
                    size: 20,
                  ),
                  onPressed: () => setInner(() => _hideNew = !_hideNew),
                ),
              ),
              const SizedBox(height: 14),
              _ValidationHint(
                  met: _has8Chars, label: 'Must be at least 8 characters'),
              const SizedBox(height: 8),
              _ValidationHint(
                  met: _hasSpecial,
                  label: 'Must contain one special character'),
              const SizedBox(height: 24),
              _PrimaryButton(label: 'Update', onPressed: _onUpdate),
              SizedBox(
                  height:
                      MediaQuery.of(context).viewInsets.bottom + 16),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SCREEN 5 — Success
// ─────────────────────────────────────────────
class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0, 0.7,
            curve: Curves.elasticOut));
    _fade = CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.3, 1, curve: Curves.easeIn));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated checkmark circle
                ScaleTransition(
                  scale: _scale,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1B4B),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF0D1B4B).withOpacity(0.3),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check,
                        color: Colors.white, size: 42),
                  ),
                ),
                const SizedBox(height: 36),
                FadeTransition(
                  opacity: _fade,
                  child: Column(
                    children: [
                      const Text('Successfully Password Reset',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D1B4B),
                              letterSpacing: -0.3)),
                      const SizedBox(height: 12),
                      const Text(
                        'Your password has been successfully reset.\nClick below to log in magically.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF9098A3),
                            height: 1.6),
                      ),
                      const SizedBox(height: 48),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.arrow_back,
                                color: Color(0xFF0D1B4B), size: 18),
                            SizedBox(width: 8),
                            Text('Back to Login',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0D1B4B))),
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
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────

class _SheetWrapper extends StatelessWidget {
  final Widget child;
  const _SheetWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: child,
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFDDE2E8),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(label,
          style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E))),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              const TextStyle(color: Color(0xFFBEC5CF), fontSize: 14),
          prefixIcon:
              Icon(prefixIcon, color: const Color(0xFFBEC5CF), size: 20),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
                color: Color(0xFF0D1B4B), width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D1B4B),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          shadowColor: const Color(0xFF0D1B4B).withOpacity(0.4),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _ValidationHint extends StatelessWidget {
  final bool met;
  final String label;

  const _ValidationHint({required this.met, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = met ? const Color(0xFF22C55E) : const Color(0xFFE53935);
    return Row(
      children: [
        Icon(Icons.shield_outlined, size: 16, color: color),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(
                fontSize: 12.5, color: color, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 76,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: icon),
      ),
    );
  }
}

class _FacebookIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
          color: Color(0xFF1877F2), shape: BoxShape.circle),
      child: const Center(
        child: Text('f',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'serif')),
      ),
    );
  }
}
