import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ── Screen ─────────────────────────────────────────────────────
class DoctorRegistrationScreen extends StatefulWidget {
  final String role; // 'doctor' or 'student'
  
  const DoctorRegistrationScreen({super.key, required this.role});

  @override
  State<DoctorRegistrationScreen> createState() => _DoctorRegistrationScreenState();
}

class _DoctorRegistrationScreenState extends State<DoctorRegistrationScreen> {
  static const Color _navy = Color(0xFF1B2D70);

  int _step = 1;

  // Step 1 controllers
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _pwdCtrl     = TextEditingController();
  final _cpwdCtrl    = TextEditingController();
  DateTime? _dob;
  String? _country;
  final _stateCtrl   = TextEditingController();

  bool _showPwd  = false;
  bool _showCpwd = false;

  // Step 2 state
  String? _role;
  String? _field;
  final _subCtrl = TextEditingController();
  final _instCtrl = TextEditingController();
  String? _degree;
  String? _experience;
  String? _publications;
  bool _agreed = false;

  //error messages
  String? _nameError;
  String? _emailError;
  String? _pwdError;
  String? _cpwdError;
  String? _dobError;
  String? _countryError;
  String? _stateError;
  String? _roleError;
  String? _fieldError;
  String? _agreedError;

  bool _validateStep1(){
    setState(() {
      _nameError = _nameCtrl.text.isEmpty ? 'Name is required' : null;
      _emailError = _emailCtrl.text.isEmpty ? 'Email is required' : null;
      _pwdError = _pwdCtrl.text.isEmpty ? 'Password is required' : null;
      _cpwdError = _cpwdCtrl.text.isEmpty ? 'Confirm password is required' : null;
      if(_pwdError==null && _cpwdError==null && _pwdCtrl.text != _cpwdCtrl.text){
        _cpwdError = 'Passwords do not match';
      }
      _dobError = _dob == null ? 'Date of birth is required' : null;
      _countryError = _country == null ? 'Country is required' : null;
      _stateError = _stateCtrl.text.isEmpty ? 'State/Region is required' : null;
    });
    return [_nameError, _emailError, _pwdError, _cpwdError, _dobError, _countryError, _stateError].every((e) => e == null);
  }

bool _validateStep2() {
  setState(() {
    _roleError   = _role == null  ? 'Professional role is required' : null;
    _fieldError  = _field == null ? 'Primary field is required'     : null;
    _agreedError = !_agreed       ? 'You must agree to the Terms of Service' : null;
  });
  return _roleError == null && _fieldError == null && _agreedError == null;
}

Future<void> _register() async {
  if (!_validateStep2()) return;

  try {
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailCtrl.text.trim(),
      password: _pwdCtrl.text.trim(),
    );

    final uid = userCredential.user!.uid;

    await FirebaseFirestore.instance.collection('doctors').doc(uid).set({
      'name':          _nameCtrl.text.trim(),
      'email':         _emailCtrl.text.trim(),
      'DOB':           _dob?.toIso8601String(),
      'country':       _country,
      'state':         _stateCtrl.text.trim(),
      'role':          _role,
      'field':         _field,
      'subDiscipline': _subCtrl.text.trim(),
      'institution':   _instCtrl.text.trim(),
      'degree':        _degree,
      'experience':    _experience,
      'publications':  _publications,
      'userType':      'doctor',
      'createdAt':     DateTime.now().toIso8601String(),
      'verified':      false,
    });

    await userCredential.user!.sendEmailVerification();
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle, color: Color(0xFF1B2D70), size: 64),
            SizedBox(height: 16),
            Text('Account Created!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text(
              'A verification email has been sent to your inbox. Please verify your email before signing in.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
            ),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');

  } on FirebaseAuthException catch (e) {
    String? message;
    if (e.code == 'weak-password') {
      setState(() { _pwdError = 'Password is too weak, minimum 6 characters.'; _step = 1; });
    } else if (e.code == 'email-already-in-use') {
      message = 'An account already exists for that email.';
    } else {
      message = 'Something went wrong, please try again later.';
    }
    if (message != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
  


  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _pwdCtrl.dispose();
    _cpwdCtrl.dispose(); _stateCtrl.dispose(); _subCtrl.dispose();
    _instCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1B2D70),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Status bar
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('9:41',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF111111))),
                    Row(children: [
                      Icon(Icons.signal_cellular_alt, color: Colors.grey.shade800, size: 16),
                      const SizedBox(width: 4),
                      Icon(Icons.wifi, color: Colors.grey.shade800, size: 16),
                      const SizedBox(width: 4),
                      Icon(Icons.battery_full, color: Colors.grey.shade800, size: 18),
                    ]),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _step == 1
                  ? _buildStep1(key: const ValueKey(1))
                  : _buildStep2(key: const ValueKey(2)),
            ),
          ),

          // Home bar
          Container(
            color: Colors.white,
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

  // ── Step 1 ─────────────────────────────────────────────────
  Widget _buildStep1({Key? key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Logo(),
          const SizedBox(height: 14),
          const Text('Create Account',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF111111))),
          const SizedBox(height: 4),
          Text('Start with create your account',
              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade400)),
          const SizedBox(height: 16),
          _StepProgress(step: 1, total: 2),
          const SizedBox(height: 20),

          _FieldLabel('Full Name'),
          _InputField(controller: _nameCtrl, hint: 'Full Name', icon: Icons.person_outline, errorText: _nameError),
          _FieldLabel('Email'),
          _InputField(controller: _emailCtrl, hint: 'example@gmail.com', icon: Icons.email_outlined, errorText: _emailError),
          _FieldLabel('Password'),
          _PasswordField(controller: _pwdCtrl, show: _showPwd,
              onToggle: () => setState(() => _showPwd = !_showPwd), errorText: _pwdError),
          _FieldLabel('Confirm Password'),
          _PasswordField(controller: _cpwdCtrl, show: _showCpwd,
              onToggle: () => setState(() => _showCpwd = !_showCpwd), errorText: _cpwdError),
          _FieldLabel('Date of Birthday'),
          _DateField(value: _dob, onTap: _pickDate, errorText: _dobError),
          _FieldLabel('Country'),
          GestureDetector(
            onTap: () {
              showCountryPicker(
                context: context,
                onSelect: (country) {
                  setState(() { _country = country.name; _countryError = null; });
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _countryError != null ? Colors.red : const Color(0xFFE8E8E8),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Icon(Icons.flag_outlined,
                          color: _countryError != null ? Colors.red.shade200 : Colors.grey.shade300, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        _country ?? '------------',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: _country != null ? const Color(0xFF222222) : Colors.grey.shade300,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400, size: 20),
                    ],
                  ),
                ),
                if (_countryError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 10),
                    child: Text(_countryError!, style: const TextStyle(fontSize: 11.5, color: Colors.red)),
                  )
                else
                  const SizedBox(height: 10),
              ],
            ),
          ),
          _FieldLabel('State/Region'),
          _InputField(
           controller: _stateCtrl,
           hint: '-----------',
           icon: Icons.location_on_outlined,
           errorText: _stateError),
          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () { if (_validateStep1()) setState(() => _step = 2); },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2D70),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Next',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 2 ─────────────────────────────────────────────────
  Widget _buildStep2({Key? key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Logo(),
          const SizedBox(height: 14),
          const Text('Create Account',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF111111))),
          const SizedBox(height: 4),
          Text('Start with create your account',
              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade400)),
          const SizedBox(height: 16),
          _StepProgress(step: 2, total: 2),
          const SizedBox(height: 20),

          _FieldLabel('Professional Role'),
          _DropdownField<String>(
            value: _role, hint: 'Role', icon: Icons.person_outline,
            items: ['Doctor','Specialist','Researcher','Surgeon','General Practitioner'],
            errorText: _roleError,
            onChanged: (v) => setState(() { _role = v; _roleError = null; }),
          ),
          _FieldLabel('Primary Field'),
          _DropdownField<String>(
            value: _field, hint: 'Field', icon: Icons.local_hospital_outlined,
            items: ['Medicine','Surgery','Pediatrics','Cardiology','Neurology','Oncology','Psychiatry'],
            errorText: _fieldError,
            onChanged: (v) => setState(() { _field = v; _fieldError = null; }),
          ),
          _FieldLabel('Sub-discipline / Speciality'),
          _InputField(controller: _subCtrl, hint: 'Optional', icon: Icons.list_alt_outlined),
          _FieldLabel('Name of Institution/ Hospital/Organization'),
          _InputField(controller: _instCtrl, hint: 'Name', icon: Icons.business_outlined),
          _FieldLabel('Highest Degree'),
          _DropdownField<String>(
            value: _degree, hint: 'Degree', icon: Icons.school_outlined,
            items: ["Bachelor's","Master's",'PhD','MD','MBBS'],
            onChanged: (v) => setState(() => _degree = v),
          ),
          _FieldLabel('Experience'),
          _DropdownField<String>(
            value: _experience, hint: 'Experience', icon: Icons.access_time_outlined,
            items: ['Less than 1 year','1-3 years','3-5 years','5-10 years','10+ years'],
            onChanged: (v) => setState(() => _experience = v),
          ),
          _FieldLabel('Approximate Number of Publications'),
          _DropdownField<String>(
            value: _publications, hint: 'Publications', icon: Icons.menu_book_outlined,
            items: ['0','1-5','6-10','11-20','20+'],
            onChanged: (v) => setState(() => _publications = v),
          ),

          const SizedBox(height: 8),

          // Terms checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20, height: 20,
                child: Checkbox(
                  value: _agreed,
                  onChanged: (v) => setState(() { _agreed = v ?? false; _agreedError = null; }),
                  activeColor: const Color(0xFF1B2D70),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5),
                    children: const [
                      TextSpan(text: 'By this, I have read the '),
                      TextSpan(text: 'Terms of Services',
                          style: TextStyle(color: Color(0xFF1B2D70), fontWeight: FontWeight.w600)),
                      TextSpan(text: ' and I agree on them'),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (_agreedError != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(_agreedError!, style: const TextStyle(fontSize: 11.5, color: Colors.red)),
            ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2D70),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Registration',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),

          const SizedBox(height: 14),

          Center(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 12.5, color: Color(0xFF888888)),
                children: [
                  TextSpan(text: 'You already have an account? '),
                  TextSpan(text: 'Sign In',
                      style: TextStyle(color: Color(0xFF1B2D70), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable widgets ───────────────────────────────────────────

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52, height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF1B2D70),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.monitor_heart_outlined, color: Colors.white, size: 26),
    );
  }
}

class _StepProgress extends StatelessWidget {
  final int step;
  final int total;
  const _StepProgress({required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = step / total;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Step $step of $total',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
            Text('${(pct * 100).toInt()}% Complete',
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF888888))),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 9,
            backgroundColor: const Color(0xFFE8E8E8),
            color: const Color(0xFF1B2D70),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111111))),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? errorText;
  const _InputField({required this.controller, required this.hint, required this.icon, this.errorText});

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            border: Border.all(color: hasError ? Colors.red : const Color(0xFFE8E8E8), width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(icon, color: hasError ? Colors.red.shade200 : Colors.grey.shade300, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: 13.5, color: Color(0xFF222222)),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 13.5),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 14),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(errorText!, style: const TextStyle(fontSize: 11.5, color: Colors.red)),
          )
        else
          const SizedBox(height: 10),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool show;
  final VoidCallback onToggle;
  final String? errorText;
  const _PasswordField({required this.controller, required this.show, required this.onToggle, this.errorText});

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            border: Border.all(color: hasError ? Colors.red : const Color(0xFFE8E8E8), width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(Icons.lock_outline, color: hasError ? Colors.red.shade200 : Colors.grey.shade300, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: !show,
                  style: const TextStyle(fontSize: 13.5, color: Color(0xFF222222)),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(show ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: Colors.grey.shade300, size: 18),
                onPressed: onToggle,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40),
              ),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(errorText!, style: const TextStyle(fontSize: 11.5, color: Colors.red)),
          )
        else
          const SizedBox(height: 10),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime? value;
  final VoidCallback onTap;
  final String? errorText;
  const _DateField({required this.value, required this.onTap, this.errorText});

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final label = value != null
        ? '${value!.day.toString().padLeft(2, '0')} / ${value!.month.toString().padLeft(2, '0')} / ${value!.year}'
        : '** / ** / ****';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              border: Border.all(color: hasError ? Colors.red : const Color(0xFFE8E8E8), width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    color: hasError ? Colors.red.shade200 : Colors.grey.shade300, size: 18),
                const SizedBox(width: 10),
                Text(label,
                    style: TextStyle(
                        fontSize: 13.5,
                        color: value != null ? const Color(0xFF222222) : Colors.grey.shade300)),
                const Spacer(),
                Icon(Icons.keyboard_arrow_down,
                    color: hasError ? Colors.red.shade200 : Colors.grey.shade300, size: 20),
              ],
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(errorText!, style: const TextStyle(fontSize: 11.5, color: Colors.red)),
          )
        else
          const SizedBox(height: 10),
      ],
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final IconData icon;
  final List<T> items;
  final void Function(T?) onChanged;
  final String? errorText;

  const _DropdownField({
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        border: Border.all(color: hasError ? Colors.red : const Color(0xFFE8E8E8), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(icon, color: hasError ? Colors.red.shade200 : Colors.grey.shade300, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                hint: Text(hint,
                    style: TextStyle(fontSize: 13.5, color: Colors.grey.shade300)),
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400, size: 20),
                isExpanded: true,
                style: const TextStyle(fontSize: 13.5, color: Color(0xFF222222), fontFamily: 'Poppins'),
                onChanged: onChanged,
                items: items.map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(item.toString()),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(errorText!, style: const TextStyle(fontSize: 11.5, color: Colors.red)),
          )
        else
          const SizedBox(height: 10),
      ],
    );
  }
}
