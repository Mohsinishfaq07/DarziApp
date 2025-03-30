import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Utils/Service/AuthService.dart';
import 'package:tailor_app/Utils/Snackbar/Snackbar.dart';
import 'package:tailor_app/View/Auth/ForgotPassword/Forgotpassword.dart';
import 'package:tailor_app/View/Home/HomeScreen.dart';
import 'package:tailor_app/View/Auth/Signup/SignupScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _isLoading = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = await _auth.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (user != null && mounted) {
        showSnackBar("Success", "Logged in Successfully");
        Get.offAll(() => Homescreen());
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _googleLogin() async {
    final user = await _auth.signInWithGoogle();
    if (user != null) Get.offAll(() => Homescreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child:  Center(
  child: SizedBox(
    width: 360, // Reduced max width of card
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Slightly smaller border
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 20), // Reduced horizontal margin
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Reduced padding inside the card
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome Back!",
                style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue.shade700), // Reduced font
              ),
              const SizedBox(height: 8),
              Text(
                "Please login to continue",
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey.shade600), // Slightly smaller text
              ),
              const SizedBox(height: 18),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email, color: Colors.blue.shade700),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), // Slightly smaller radius
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value!.isEmpty ? "Email can't be empty" : null,
              ),
              const SizedBox(height: 12),

              // Password Field with Toggle Visibility
              TextFormField(
                controller: _passwordController,
                obscureText: _hidePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
                  suffixIcon: IconButton(
                    icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility, color: Colors.blue.shade700),
                    onPressed: () => setState(() => _hidePassword = !_hidePassword),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), // Consistent radius
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value!.isEmpty ? "Password can't be empty" : null,
              ),
              const SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.to(() => Forgotpassword()),
                  child: Text("Forgot Password?", style: GoogleFonts.poppins(color: Colors.red.shade600)),
                ),
              ),
              const SizedBox(height: 10),

              // Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32), // Slightly reduced button size
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.blue.shade700,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Login", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),

              const SizedBox(height: 12),

              // OR Divider
              Row(
                children: [
                  Expanded(child: Divider(thickness: 1, color: Colors.grey.shade400)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text("OR", style: GoogleFonts.poppins(color: Colors.grey.shade600)),
                  ),
                  Expanded(child: Divider(thickness: 1, color: Colors.grey.shade400)),
                ],
              ),
              const SizedBox(height: 12),

              // Google Login Button
              ElevatedButton.icon(
                onPressed: _googleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Smaller button
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.blue.shade700),
                ),
                icon: Image.asset('assets/googleicon.png', height: 22), // Slightly reduced icon size
                label: Text("Login with Google",
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)),
              ),

              const SizedBox(height: 8),

              // Signup Link
              TextButton(
                onPressed: () => Get.to(() => const SignupScreen()),
                child: Text(
                  "Don't have an account? Sign up",
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.blue.shade700), // Slightly smaller text
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
),

              ),
            ),
          );
        },
      ),
    );
  }
}
