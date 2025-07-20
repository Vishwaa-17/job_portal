import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AcceptedApplicantsScreen extends StatelessWidget {
  final String jobId;

  const AcceptedApplicantsScreen({super.key, required this.jobId});

  Future<List<Map<String, dynamic>>> fetchAcceptedApplicants() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(jobId)
        .collection('accepted_applicants')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Widget buildApplicantCard(Map<String, dynamic> userData) {
    final name =
        "${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}".trim();
    final email = userData['email'] ?? '';
    final phone = userData['phone'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                if (email.isNotEmpty)
                  Text(email, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                if (phone.isNotEmpty)
                  Text(phone, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accepted Applicants"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAcceptedApplicants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final accepted = snapshot.data ?? [];

          if (accepted.isEmpty) {
            return const Center(child: Text("No accepted applicants."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: accepted.length,
            itemBuilder: (context, index) =>
                buildApplicantCard(accepted[index]),
          );
        },
      ),
    );
  }
}