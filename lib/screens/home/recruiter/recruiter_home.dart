import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:careers/widgets/job_card.dart';
import 'post_job_screen.dart';
import 'recruiter_job_detail.dart';
import 'package:careers/screens/profile/recruiter/recruiter_profile.dart';

class RecruiterHome extends StatefulWidget {
  const RecruiterHome({super.key});

  @override
  State<RecruiterHome> createState() => _RecruiterHomeState();
}

class _RecruiterHomeState extends State<RecruiterHome> {
  String recruiterName = "Recruiter";

  // Renamed for clarity
  Future<void> _loadRecruiterName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('recruiters')
          .doc(uid)
          .get();

      if (mounted && snapshot.exists) {
        final data = snapshot.data()!;
        // Reads snake_case keys which is now the standard
        final firstName = data['first_name'] ?? '';
        final lastName = data['last_name'] ?? '';
        final finalName = "$firstName $lastName".trim();
        setState(() {
          recruiterName = finalName.isNotEmpty ? finalName : "Recruiter";
        });
      }
    } catch (e) {
      print("Error fetching recruiter name: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRecruiterName();
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RecruiterProfileScreen(),
                  ),
                );
                _loadRecruiterName(); // Refresh name when returning from profile
              },
              child: CircleAvatar(
                backgroundColor: Colors.deepPurple,
                radius: 22,
                child: Text(
                  recruiterName.isNotEmpty
                      ? recruiterName[0].toUpperCase()
                      : "R",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  recruiterName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add a Job Opening",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PostJobScreen()),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "Post a Job",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Posted Jobs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(thickness: 1.2),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('jobs')
                    .where('recruiterId', isEqualTo: currentUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  final jobDocs = snapshot.data?.docs ?? [];
                  if (jobDocs.isEmpty) {
                    return const Center(
                      child: Text("You haven't posted any jobs yet."),
                    );
                  }
                  return ListView.builder(
                    itemCount: jobDocs.length,
                    itemBuilder: (context, index) {
                      final doc = jobDocs[index];
                      final jobData = doc.data();
                      return RecruiterJobCard(
                        jobData: jobData,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecruiterJobDetail(job: doc),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
