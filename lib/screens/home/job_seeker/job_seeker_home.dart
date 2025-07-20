import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:careers/screens/home/job_seeker/search_screen.dart';
import 'package:careers/widgets/job_card.dart'; 
import 'package:careers/screens/home/job_seeker/job_detail_screen.dart';
import 'package:careers/screens/profile/job_seeker/job_seeker_profile.dart';

// --- CONVERTED TO A STATEFUL WIDGET FOR EFFICIENCY ---
class JobSeekerHome extends StatefulWidget {
  const JobSeekerHome({super.key});

  @override
  State<JobSeekerHome> createState() => _JobSeekerHomeState();
}

class _JobSeekerHomeState extends State<JobSeekerHome> {
  String _userName = "User";
  String _userInitial = "U";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // --- FETCHES USER DATA ONLY ONCE ---
  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance.collection('job_seekers').doc(uid).get();
      
      if (mounted && snapshot.exists) {
        final data = snapshot.data()!;
        final firstName = data['first_name'] as String? ?? '';
        final lastName = data['last_name'] as String? ?? '';
        final finalName = "$firstName $lastName".trim();

        setState(() {
          _userName = finalName.isNotEmpty ? finalName : "User";
          _userInitial = finalName.isNotEmpty ? finalName[0].toUpperCase() : "U";
          _isLoading = false;
        });
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error loading user data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,
        automaticallyImplyLeading: false,
        title: _isLoading
            ? const LinearProgressIndicator() // Show loading bar in AppBar
            : Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      // When returning from profile, refresh the name
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const JobSeekerProfileScreen()),
                      );
                      _loadUserData();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 22,
                      child: Text(
                        _userInitial,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Welcome", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Text(
                        _userName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchBar(context),
            const SizedBox(height: 30),
            const Text(
              "Applied Jobs",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Divider(thickness: 1.2),
            const SizedBox(height: 12),
            Expanded(child: _buildAppliedJobs(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Text("Search by title, skill or company", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppliedJobs(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('applications').where('userId', isEqualTo: userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("You haven't applied to any jobs yet."));
        }
        final jobs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final jobSnapshot = jobs[index];
            final jobData = jobSnapshot.data();
            final jobId = jobData['jobId'] ?? jobSnapshot.id;
            final status = jobData['status'] ?? 'Pending';
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppliedJobCard(
                jobData: jobData['jobData'] ?? {},
                status: status,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => JobDetailScreen(jobId: jobId, jobData: jobData['jobData'] ?? {}))),
              ),
            );
          },
        );
      },
    );
  }
}