import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class StudentRegistrationScreen extends StatefulWidget {
  const StudentRegistrationScreen({super.key});

  @override
  State<StudentRegistrationScreen> createState() => _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState extends State<StudentRegistrationScreen> {

  // Text editing controllers for the input fields
final _nameCtrl = TextEditingController();
final _emailCtrl = TextEditingController();
final _passwordCtrl = TextEditingController();
final _confirmPasswordCtrl = TextEditingController();
final _majorCtrl = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  DateTime? _selectedDob;
  // we store the selected country as a string, we could also store it as a Country object if we want to access more information about the country later, but for now we just need the name of the country for the registration process, so we can keep it simple and just store it as a string
  String? _selectedCountry;
  // error messages for form validation, we can use these variables to store the error messages for each field and display them in the UI if the validation fails, this allows us to provide feedback to the user about what they need to fix in order to successfully register, and it also helps us keep track of the validation state of each field in a clear and organized way
  //String? means that the variable can either hold a string value or be null, this is useful for error messages because if there is no error, we can set the variable to null, and if there is an error, we can set it to the appropriate error message, this way we can easily check if there is an error by checking if the variable is null or not, and we can also display the error message in the UI when it is not null
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _majorError;
  String? _dobError;
  String? _countryError;

  static const Color _navy = Color(0xFF1B2F72);
  static const Color _grey = Color(0xFFF2F2F2);
  static const Color _hintColor = Color(0xFFBBBBBB);
  static const Color _labelColor = Color(0xFF222222);
  static const Color _subtitleColor = Color(0xFFAAAAAA);

  @override
void dispose() {
  // Dispose the controllers when the widget is removed from the widget tree
  _nameCtrl.dispose();
  _emailCtrl.dispose();
  _passwordCtrl.dispose();
  _confirmPasswordCtrl.dispose();
  _majorCtrl.dispose();
  super.dispose();
}

//_pickDate is an asynchronous function that shows a date picker dialog to the user and waits for them to select a date, once the user selects a date, it updates the _selectedDob variable with the chosen date, and if the user cancels the dialog, it does nothing and keeps the _selectedDob variable unchanged. This function is used to allow the user to select their date of birth during the registration process.
Future<void> _pickDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate: DateTime(2000),
    firstDate: DateTime(1950),
    lastDate: DateTime.now(),
  );
  if (picked != null) {
    setState(() => _selectedDob = picked);
  }
}
bool _validate(){
  setState(() {
    // we check if each field is empty and set the corresponding error message if it is, otherwise we set the error message to null, this allows us to provide feedback to the user about which fields are missing and need to be filled in order to successfully register, and it also helps us keep track of the validation state of each field in a clear and organized way
    _nameError=_nameCtrl.text.trim().isEmpty? 'Please enter your full name' : null;
    _emailError=_emailCtrl.text.trim().isEmpty? 'Please enter your email' : null;
    _passwordError=_passwordCtrl.text.trim().isEmpty? 'Please enter your password' : null;
    _confirmPasswordError=_confirmPasswordCtrl.text.trim().isEmpty? 'Please confirm your password' : null;
    _majorError=_majorCtrl.text.trim().isEmpty? 'Please enter your major' : null;
    _dobError=_selectedDob == null? 'Please select your date of birth' : null;
    _countryError=_selectedCountry == null? 'Please select your country' : null;
  });
  // we return true if all error messages are null, which means that all fields are valid and the user can proceed with the registration process, otherwise we return false to indicate that there are validation errors that need to be fixed before the user can successfully register
  return _nameError == null &&
      _emailError == null &&
      _passwordError == null &&
      _confirmPasswordError == null &&
      _majorError == null &&
      _dobError == null &&
      _countryError == null;
}
//async means that this function takes time to complete and we want to wait for it to finish
//await means wait here for this operation to complete before moving on to the next line of code, if we don't use await, the function will return immediately and the user may not be created yet when we try to access the user data, so we want to make sure that the user is created before we do anything else
//Future means that this function will return a value in the future, in this case it will return void when it is done, but it may take some time to complete because it needs to communicate with the firebase servers to create the user, so we want to use Future to indicate that this function is asynchronous and may take some time to complete
//we used async, await, and Future to handle the asynchronous nature of the createUserWithEmailAndPassword function from the FirebaseAuth instance, which is used to create a new user with an email and password in Firebase Authentication. This function returns a Future that completes when the user creation process is finished, and we want to wait for it to complete before proceeding with any further actions, such as navigating to another screen or displaying a success message. By using async and await, we can write asynchronous code in a more readable and sequential manner, making it easier to understand the flow of the program.
Future<void> createUserWithEmailAndPassword() async {
  // we call the _validate function to check if all the input fields are valid before attempting to create the user, if the validation fails, we return early from the function and do not proceed with the user creation process, this helps us prevent unnecessary calls to the Firebase Authentication API and provides a better user experience by giving immediate feedback about what needs to be fixed in the form before trying to register.
  if(!_validate())
    return;
// we check if the password and confirm password fields match, if they don't match, we set the _confirmPasswordError variable to an appropriate error message and return early from the function, this allows us to provide specific feedback to the user about what went wrong with their input and prevents them from trying to register with mismatched passwords, which would result in an authentication error from Firebase.
  if (_passwordCtrl.text.trim() != _confirmPasswordCtrl.text.trim()) {
  setState(() => _confirmPasswordError = 'Passwords do not match.');
  return;
}


  try{
 final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: _emailCtrl.text.trim(),
   password: _passwordCtrl.text.trim(),
   );

   //we save the UID so we can save it as an ID for the student record in Firestore
   final uid=userCredential.user!.uid;

   await FirebaseFirestore.instance.collection('students').doc(uid).set({
    'name': _nameCtrl.text.trim(),
    'email': _emailCtrl.text.trim(),
    'major': _majorCtrl.text.trim(),
    'DOB': _selectedDob?.toIso8601String(),
    'country': _selectedCountry,
    'createdAt': DateTime.now().toIso8601String(),
    'role': 'student',
   });

await userCredential.user!.sendEmailVerification();
await FirebaseAuth.instance.signOut();

   // after successfully creating the user and saving their information in Firestore, we show a dialog to the user indicating that their account has been created successfully, and we also inform them that they will be redirected to the sign-in page shortly, this provides a positive feedback loop for the user and lets them know that their registration was successful before navigating them to the next step in the authentication process.
   //we use showDialog to display a modal dialog on top of the user screen. The context parameter is required to know where to display the dialog in the widget tree, and the barrierDismissible: false means that the user cannot dismiss the dialog by tapping outside of it, they have to wait for the automatic redirection to the sign-in page. The builder parameter is a function that returns the widget tree for the dialog, in this case we return an AlertDialog with a custom shape and content that includes an icon, a title, and a message to inform the user about the successful account creation.
   //the widget tree is various UI elements that make up the content of the dialog, we use a Column to arrange the icon, title, and message vertically, and we use SizedBox to add spacing between them for better visual separation. The Icon widget displays a check circle icon to indicate success, the Text widgets display the title and message with appropriate styling to convey the information clearly to the user.
   showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.check_circle, color: Color(0xFF1B2F72), size: 64),
        SizedBox(height: 16),
        Text(
          'Account Created!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
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
Navigator.pushReplacementNamed(context, '/login');

  } //catch only catches exceptions of type FirebaseAuthException, which are specific to authentication errors that may occur when using Firebase Authentication. This allows us to handle authentication-related errors separately from other types of exceptions that may occur in the app, and provide more specific feedback to the user about what went wrong during the registration process.
  on FirebaseAuthException catch (e) {
    //message? becase message could be null
    String? message;
    if (e.code == 'weak-password') {
      setState(() {
        _passwordError = 'The password provided is too weak, it should be at least 6 characters long.';
      });
    } else if (e.code == 'email-already-in-use') {
      message='The account already exists for that email.';
    } else {
      message='something went wrong, please try again later.';
    }
    // we check if the message variable is not null before showing the SnackBar, this is because in the case of a weak password error, we set the _passwordError variable to display the error message directly below the password field, so we don't want to show a SnackBar for that specific error, but for other errors like email already in use or general errors, we want to show a SnackBar with the appropriate message to inform the user about what went wrong during the registration process.
    if(message!=null)
    {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));}

  }
}
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
                controller: _nameCtrl,
                hint: 'Fatima Matrook',
                prefixIcon: Icons.person_outline,
                // we pass the error text to the text field, if it is provided, otherwise it will be null and the text field will not display any error message, this allows us to show specific error messages for each input field based on the validation results
                errorText: _nameError,
              ),

              const SizedBox(height: 16),

              // Email
              _buildLabel('Email'),
              _buildTextField(
                controller: _emailCtrl,
                hint: 'example@gmail.com',
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
              ),

              const SizedBox(height: 16),

              // Password
              _buildLabel('Password'),
              _buildTextField(
                controller: _passwordCtrl,
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
                errorText: _passwordError,
              ),

              const SizedBox(height: 16),

              // Confirm Password
              _buildLabel('Confirm Password'),
              _buildTextField(
                controller: _confirmPasswordCtrl,
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
                errorText: _confirmPasswordError,
              ),

              const SizedBox(height: 16),

              // Date of Birthday
              _buildLabel('Date of Birthday'),
              GestureDetector(
  onTap: _pickDate,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _dobError != null ? Colors.red : const Color(0xFFEEEEEE),
            width: _dobError != null ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined, color: _hintColor, size: 20),
            const SizedBox(width: 12),
            Text(
              _selectedDob == null
                  ? '** / ** / ****'
                  : '${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}',
              style: TextStyle(
                fontSize: 14,
                color: _selectedDob == null ? _hintColor : const Color(0xFF444444),
              ),
            ),
          ],
        ),
      ),
      if (_dobError != null)
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: Text(
            _dobError!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
    ],
  ),
),


              const SizedBox(height: 16),

              // Major
              _buildLabel('Major'),
              _buildTextField(
                controller: _majorCtrl,
                hint: '------------',
                prefixIcon: Icons.person_outline,
                errorText: _majorError,
              ),

              const SizedBox(height: 16),

              // Country
              _buildLabel('Country'),
              GestureDetector(
  onTap: () {
    showCountryPicker(
      context: context,
      onSelect: (country) {
        setState(() {
          _selectedCountry = country.name;
          _countryError = null;
        });
      },
    );
  },
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _countryError != null ? Colors.red : const Color(0xFFEEEEEE),
            width: _countryError != null ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const Icon(Icons.flag_outlined, color: _hintColor, size: 20),
            const SizedBox(width: 12),
            Text(
              _selectedCountry ?? '------------',
              style: TextStyle(
                fontSize: 14,
                color: _selectedCountry == null ? _hintColor : const Color(0xFF444444),
              ),
            ),
          ],
        ),
      ),
      if (_countryError != null)
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: Text(
            _countryError!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
    ],
  ),
),


              const SizedBox(height: 28),

              // Registration Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async{
                    await createUserWithEmailAndPassword();
                  },
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
    //controller is optional because we may want to use the same text field widget for different fields, and not all of them may need a controller, for example, if we want to use the same text field widget for a read-only field that displays some information, we may not need a controller for that field, so we can make it optional and only provide it when we need it
    //text editing controllers are used to control the text that is entered in the text field, we can use them to get the current value of the text field, or to set a new value for the text field, or to listen for changes in the text field, so they are useful for handling user input and updating the UI accordingly
    TextEditingController? controller,
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? errorText,
  }) {
    return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: errorText != null ? Colors.red : const Color(0xFFEEEEEE),
          width: errorText != null ? 1.5 : 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: Color(0xFF444444)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFFBBBBBB), size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    ),
    if (errorText != null)
      Padding(
        padding: const EdgeInsets.only(top: 4, left: 4),
        child: Text(
          errorText,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      ),
  ],
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
