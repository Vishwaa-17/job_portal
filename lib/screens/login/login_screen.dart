import 'package:careers/resources/auth_methods.dart';
import 'package:careers/screens/home/job_seeker/job_seeker_home.dart';
import 'package:careers/screens/home/recruiter/recruiter_home.dart';
import 'package:careers/screens/signup/signup_screen.dart';
import 'package:careers/utils/colors.dart';
import 'package:careers/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final res = await AuthMethods().loginUser(email: email, password: password);

    if (res == 'success') {
      try {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid == null) {
          showSnackBar("Login failed: No UID found", context);
          return;
        }

        // ✅ Check if user is a job seeker
        final jobSeekerSnap = await FirebaseFirestore.instance
            .collection('job_seekers') // ✅ Corrected collection name
            .doc(uid)
            .get();

        if (jobSeekerSnap.exists) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const JobSeekerHome()),
          );
          return;
        }

        // ✅ Check if user is a recruiter
        final recruiterSnap = await FirebaseFirestore.instance
            .collection('recruiters') // ✅ Corrected collection name
            .doc(uid)
            .get();

        if (recruiterSnap.exists) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const RecruiterHome()),
          );
          return;
        }

        showSnackBar("User profile not found in database", context);
      } catch (e) {
        showSnackBar("Error fetching user profile: ${e.toString()}", context);
      }
    } else {
      showSnackBar(res, context);
    }

    setState(() => _isLoading = false);
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignupContactScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 64),
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 6),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      if (!isValidEmail(value.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 6),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      if (value.trim().length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  InkWell(
                    onTap: _isLoading ? null : loginUser,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  ),

                  const SizedBox(height: 250),

                  Container(
                    color: const Color(0xfff5f5f5),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "New here?",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                            ),
                            Text(
                              'Create an Account',
                              style: TextStyle(color: backgroundColor, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: navigateToSignup,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: backgroundColor),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(color: backgroundColor, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
