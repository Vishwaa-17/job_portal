
import 'package:careers/utils/colors.dart';
import 'package:careers/screens/login/login_screen.dart';
import 'package:careers/screens/registration/job_seeker_personal_details.dart';
import 'package:careers/screens/registration/recruiter_personal_details.dart';
import 'package:flutter/material.dart';

class RegistrationChoiceScreen extends StatelessWidget {
  // --- FIX #1: DEFINE THE VARIABLES FOR THE CLASS HERE ---
  // These will hold the data passed from the previous screen.
  final String email;
  final String phoneNo;

  // --- FIX #2: ADD THEM TO THE CONSTRUCTOR ---
  const RegistrationChoiceScreen({
    Key? key,
    required this.email,
    required this.phoneNo,
  }) : super(key: key);

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // --- FIX #3: USE THE CLASS VARIABLES IN YOUR FUNCTION ---
  // Now, `email` and `phoneNo` are available here because they are
  // properties of this class.
  void handleChoice(BuildContext context, String userType) {
    if (userType == 'job_seeker') {
      Navigator.push(
        context,
        MaterialPageRoute(
          // Pass the data to the *next* screen
          builder: (_) => JobSeekerPersonalDetailsScreen(
            email: email,
            phoneNo: phoneNo,
          ),
        ),
      );
    } else if (userType == 'recruiter') {
      Navigator.push(
        context,
        MaterialPageRoute(
          // Pass the data to the *next* screen
          builder: (_) => RecruiterPersonalDetailsScreen(
            email: email,
            phoneNo: phoneNo,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // The build method was already correct. No changes needed here.
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Register As',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              GestureDetector(
                onTap: () => handleChoice(context, 'job_seeker'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  width: double.infinity,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Job Seeker',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create your profile to apply for jobs.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),

              GestureDetector(
                onTap: () => handleChoice(context, 'recruiter'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  width: double.infinity,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.business_center_outlined, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Recruiter',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Post jobs and find the right candidates.',
                style: TextStyle(color: Colors.black54),
              ),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () => navigateToLogin(context),
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: backgroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}