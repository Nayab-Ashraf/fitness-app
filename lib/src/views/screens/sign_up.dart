import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/auth_service.dart'; // Make sure this import points to your new file
import 'edit_profile.dart';
import 'sign_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // --- Controllers to capture user input ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isLoading = false; // To show a spinner while loading

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // --- UPDATED SIGN UP LOGIC ---
  void _handleSignUp() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirm = _confirmController.text.trim();

    // 1. Basic Validation
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields"), backgroundColor: Colors.red),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match"), backgroundColor: Colors.red),
      );
      return;
    }

    // 2. Start Loading
    setState(() {
      _isLoading = true;
    });

    // 3. Call the Auth Service (The file we just made)
    String res = await AuthService().signUpUser(
      email: email,
      password: password,
      name: name,
    );

    // 4. Stop Loading
    setState(() {
      _isLoading = false;
    });

    // 5. Handle Result
    if (res == "success") {
      // Success!
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account Created! Please verify your email."),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to Edit Profile (or Login)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
      );
    } else {
      // Error (e.g., Email bad format, already in use)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please enter your details below',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),

                // --- 1. Full Name ---
                _buildInputField("Full Name", Icons.person_outline, _nameController, false),
                const SizedBox(height: 20),

                // --- 2. Email or Phone ---
                _buildInputField("Email", Icons.email_outlined, _emailController, false),
                const SizedBox(height: 20),

                // --- 3. Password ---
                _buildInputField("Password", Icons.lock_outline, _passwordController, true),
                const SizedBox(height: 20),

                // --- 4. Confirm Password ---
                _buildInputField("Confirm Password", Icons.lock_outline, _confirmController, true),
                const SizedBox(height: 50),

                // --- Sign Up Button ---
                GestureDetector(
                  onTap: _isLoading ? null : _handleSignUp, // Disable tap if loading
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/button_gradient_bg.png'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white) // Show spinner
                        : const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // --- Footer ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInScreen()),
                        );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widget to build the Text Fields ---
  Widget _buildInputField(
      String hint, IconData icon, TextEditingController controller, bool isPassword) {
    return Container(
      width: double.infinity,
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/grey_buttion.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            icon: Icon(icon, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}