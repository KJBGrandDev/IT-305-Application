import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added Firebase Auth

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Email + password controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // --- Theme Colors ---
  // Dark Radioactive Charcoal
  static const Color background = Color(0xFF181A12);
  // Desaturated Olive Green
  static const Color inputField = Color(0xFF515525);
  static const Color inputFieldText = Color.fromARGB(255, 156, 152, 86);
  static const Color inputFieldBorder = Color.fromARGB(255, 57, 54, 21);
  static const Color inputFieldActualText = Color.fromARGB(255, 160, 210, 103);
  // Muted Rusty Copper
  static const Color primaryButton = Color(0xFF8E5139);
  // Pale Sickly Sage
  static const Color textHeader = Color(0xFFC6CC7D);
  // Faded Moss
  static const Color supportingText = Color(0xFF8D9352);
  // Sickly Green
  static const Color highlightText = Color.fromARGB(255, 130, 217, 103);

  // --- Firebase Sign In Logic ---
  Future<void> signIn() async {
    try {
      // Show loading circle
      showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Authenticate
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Pop loading circle
      if (mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {

      if (mounted) Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication failed')),
      );
    }
  }

  // Clean up controllers
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Added to prevent keyboard overflow errors
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.monitor_heart_outlined,
                  size: 170,
                  color: textHeader,
                ),

                const SizedBox(height: 25),

                Text(
                  'H A B I T    \nW A S T E L A N D',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 52,
                    color: const Color(0xFFC6CC7D),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                const Text(
                  'The wasteland doesn\'t care about your motivation.',
                  style: TextStyle(fontSize: 16, color: supportingText),
                ),

                const SizedBox(height: 50),

                // Email Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: inputField,
                      border: Border.all(color: inputFieldBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _emailController, // Hooked up controller
                        style: const TextStyle(color: inputFieldActualText),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: TextStyle(color: inputFieldText),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Password Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: inputField,
                      border: Border.all(color: inputFieldBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _passwordController, // Hooked up controller
                        style: const TextStyle(color: inputFieldActualText),
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: inputFieldText),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Sign In Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap:
                        signIn, // Makes the button trigger the sign in logic!
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primaryButton,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: textHeader,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Register Line
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member? ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: supportingText,
                      ),
                    ),
                    Text(
                      'Register now',
                      style: TextStyle(
                        color: highlightText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
