// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:careers/resources/auth_methods.dart';
// import 'package:careers/screens/login/login_screen.dart';
// import 'package:careers/screens/registration/registration_choice.dart';
// import 'package:careers/utils/colors.dart';
// import 'package:careers/utils/utils.dart';

// class SignupContactScreen extends StatefulWidget {
//   const SignupContactScreen({super.key});

//   @override
//   State<SignupContactScreen> createState() => _SignupContactScreenState();
// }

// class _SignupContactScreenState extends State<SignupContactScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   bool _isLoading = false;
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void signUpUser() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     String res = await AuthMethods().signUpUser(
//       email: _emailController.text.trim(),
//       phoneNo: _phoneController.text.trim(),
//       password: _passwordController.text.trim(),
//     );

//     setState(() => _isLoading = false);

//     if (res == 'success') {
//       if (!mounted) return;
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => const RegistrationChoiceScreen(),
//         ),
//       );
//     } else if (res.contains('email-already-in-use')) {
//       showSnackBar('Email already registered', context);
//     } else {
//       showSnackBar('Some error occurred. Please try again.', context);
//     }
//   }

//   void navigateToLogin() {
//     Navigator.of(context).push(
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         title: const Text(
//           'Registration',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: navigateToLogin,
//             child: const Text(
//               'Login',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: backgroundColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Email Field
//                       const Text(
//                         'Email',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 6),
//                       TextFormField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: const InputDecoration(
//                           hintText: 'example@gmail.com',
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Required';
//                           }
//                           final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//                           if (!emailRegex.hasMatch(value)) {
//                             return 'Enter a valid email';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 25),

//                       // Phone Number
//                       const Text(
//                         'Phone Number',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 14,
//                             ),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey.shade300),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Text("🇮🇳 +91", style: TextStyle(fontSize: 16)),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _phoneController,
//                               keyboardType: TextInputType.phone,
//                               maxLength: 10,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.digitsOnly,
//                                 LengthLimitingTextInputFormatter(10),
//                               ],
//                               decoration: const InputDecoration(
//                                 hintText: '0123456789',
//                                 border: OutlineInputBorder(),
//                                 counterText: '',
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Required';
//                                 }
//                                 if (value.length != 10) {
//                                   return 'Enter a 10-digit number';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 25),

//                       // Password
//                       const Text(
//                         'Password',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 6),
//                       TextFormField(
//                         controller: _passwordController,
//                         obscureText: !_isPasswordVisible,
//                         decoration: InputDecoration(
//                           hintText: 'Enter password',
//                           border: const OutlineInputBorder(),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _isPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isPasswordVisible = !_isPasswordVisible;
//                               });
//                             },
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Required';
//                           }
//                           if (value.length < 6) {
//                             return 'Minimum 6 characters';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 25),

//                       // Confirm Password
//                       const Text(
//                         'Confirm Password',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 6),
//                       TextFormField(
//                         controller: _confirmPasswordController,
//                         obscureText: !_isConfirmPasswordVisible,
//                         decoration: InputDecoration(
//                           hintText: 'Re-enter password',
//                           border: const OutlineInputBorder(),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _isConfirmPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
//                               });
//                             },
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Confirm your password';
//                           }
//                           if (value != _passwordController.text) {
//                             return 'Passwords do not match';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Sign Up Button
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
//               child: InkWell(
//                 onTap: signUpUser,
//                 borderRadius: BorderRadius.circular(30),
//                 child: Container(
//                   width: double.infinity,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: backgroundColor,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: _isLoading
//                       ? const Center(
//                           child: CircularProgressIndicator(color: Colors.white),
//                         )
//                       : const Center(
//                           child: Text(
//                             'Sign Up',
//                             style: TextStyle(fontSize: 18, color: Colors.white),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// File: signup_contact_screen.dart
// FULL UPDATED CODE - COPY/PASTE THIS ENTIRE FILE

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:careers/resources/auth_methods.dart';
import 'package:careers/screens/login/login_screen.dart';
import 'package:careers/screens/registration/registration_choice.dart';
import 'package:careers/utils/colors.dart';
import 'package:careers/utils/utils.dart';

class SignupContactScreen extends StatefulWidget {
  const SignupContactScreen({super.key});

  @override
  State<SignupContactScreen> createState() => _SignupContactScreenState();
}

class _SignupContactScreenState extends State<SignupContactScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- vvvvvvvv THIS FUNCTION IS UPDATED vvvvvvvv ---
  void signUpUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Grab the values to pass them forward
    final email = _emailController.text.trim();
    final phoneNo = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    // Use the simple auth-only sign up method
    // (Ensure your AuthMethods has a simple signUpWithEmailAndPassword method)
    String res = await AuthMethods().signUpWithEmailAndPassword(
      email: email,
      password: password,
    );

    setState(() => _isLoading = false);

    if (res == 'success') {
      if (!mounted) return;
      // Navigate and PASS THE DATA to the next screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => RegistrationChoiceScreen(
            email: email,      // Pass the email
            phoneNo: phoneNo,  // Pass the phone number
          ),
        ),
      );
    } else {
      showSnackBar(res, context);
    }
  }
  // --- ^^^^^^^^ THIS FUNCTION IS UPDATED ^^^^^^^^ ---

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The build method does not need any changes.
    // Your UI is perfect.
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Registration',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: navigateToLogin,
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 18,
                color: backgroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Field
                      const Text(
                        'Email',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'example@gmail.com',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      // Phone Number
                      const Text(
                        'Phone Number',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text("🇮🇳 +91", style: TextStyle(fontSize: 16)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: const InputDecoration(
                                hintText: '0123456789',
                                border: OutlineInputBorder(),
                                counterText: '',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (value.length != 10) {
                                  return 'Enter a 10-digit number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Password
                      const Text(
                        'Password',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (value.length < 6) {
                            return 'Minimum 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      // Confirm Password
                      const Text(
                        'Confirm Password',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Re-enter password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Sign Up Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: InkWell(
                onTap: signUpUser,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : const Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}