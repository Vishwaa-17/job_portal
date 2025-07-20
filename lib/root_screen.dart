// --- vvvvvv THIS IMPORT SECTION IS NOW CORRECTED vvvvvv ---

import 'package:careers/providers/user_provider.dart';
import 'package:careers/responsive/mobile_screen_layout.dart';
import 'package:careers/responsive/responsive_screen_layout.dart';
import 'package:careers/responsive/web_screen_layout.dart';
import 'package:careers/screens/home/recruiter/recruiter_home.dart';
import 'package:careers/screens/login/login_screen.dart';
import 'package:careers/screens/registration/registration_choice.dart';
import 'package:careers/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- FIX #1: ADDED THIS REQUIRED IMPORT

// The invalid 'package:careers/models/package.dart'; or similar has been removed.
// The stray `import 'package.dart';` has been deleted.

// --- ^^^^^^ THIS IMPORT SECTION IS NOW CORRECTED ^^^^^^ ---


class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
    // Use a small delay to ensure the build method has run once.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUser();
    });
  }

  Future<void> _checkUser() async {
    // This check is crucial for async operations in initState.
    if (!mounted) return;

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final uid = currentUser.uid;

      // Check both collections simultaneously for efficiency
      final jobSeekerFuture = FirebaseFirestore.instance.collection('job_seekers').doc(uid).get();
      final recruiterFuture = FirebaseFirestore.instance.collection('recruiters').doc(uid).get();

      final List<DocumentSnapshot> results = await Future.wait([jobSeekerFuture, recruiterFuture]);
      
      final jobSeekerSnap = results[0];
      final recruiterSnap = results[1];

      // Check if the widget is still in the tree before navigating
      if (!mounted) return;

      if (jobSeekerSnap.exists) {
        // Load user into provider before navigating
        await Provider.of<UserProvider>(context, listen: false).refreshUser();
        if (!mounted) return; // Check again after await

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      } else if (recruiterSnap.exists) {
        // Load user into provider before navigating
        await Provider.of<UserProvider>(context, listen: false).refreshUser();
        if (!mounted) return; // Check again after await

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RecruiterHome()),
        );
      } else {
        // This handles the case where a user created an account but closed the app.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => RegistrationChoiceScreen(
            email: currentUser.email ?? '', // Pass the user's email
            phoneNo: currentUser.phoneNumber ?? '', // Pass phone (likely empty), but it satisfies the requirement
          )),
        );
      }
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}