import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// No need to import the other screen here, as we are making this one self-contained with a dialog.

class ApplicantsListScreen extends StatefulWidget {
  final String jobId;

  const ApplicantsListScreen({super.key, required this.jobId});

  @override
  State<ApplicantsListScreen> createState() => _ApplicantsListScreenState();
}

class _ApplicantsListScreenState extends State<ApplicantsListScreen> {
  List<Map<String, dynamic>> applicants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadApplicants();
  }

  Future<void> loadApplicants() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    final snapshot = await FirebaseFirestore.instance
        .collection('applications')
        .where('jobId', isEqualTo: widget.jobId)
        .where('status', isEqualTo: 'Pending')
        .get();

    final List<Map<String, dynamic>> temp = [];
    for (var doc in snapshot.docs) {
      final applicationData = doc.data();
      if (applicationData['userData'] != null) {
        temp.add({...applicationData, 'applicationId': doc.id});
      }
    }
    
    if (mounted) {
      setState(() {
        applicants = temp;
        _isLoading = false;
      });
    }
  }

  // --- THIS FUNCTION IS THE MAIN FIX ---
  // It now correctly handles saving the accepted applicant's profile.
  Future<void> updateStatus(String applicantId, String status, [Map<String, dynamic>? userProfile]) async {
    final docRef = FirebaseFirestore.instance.collection('applications').doc(applicantId);

    // First, update the application status to "Accepted" or "Rejected"
    await docRef.update({'status': status});

    // If the status is "Accepted", we copy the profile to the new location.
    if (status == 'Accepted') {
      // Ensure we have a valid profile to save
      if (userProfile == null || userProfile['uid'] == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error: Could not accept applicant due to missing profile data.")),
          );
        }
        return; // Stop execution if data is invalid
      }

      // Get the reference to the subcollection
      final acceptedRef = FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.jobId)
          .collection('accepted_applicants');

      // Create a new document using the applicant's UID, and set the data
      // This will store the full profile (name, email, phone, skills, etc.)
      await acceptedRef.doc(userProfile['uid']).set(userProfile);
    }

    // After updating, refresh the list of pending applicants.
    loadApplicants();
  }

  // --- The rest of the functions for the pop-up dialog are correct ---

  Future<void> _showApplicantDetailsDialog(Map<String, dynamic> applicantData) async {
    final userData = applicantData['userData'] ?? {};
    final name = ("${userData['first_name'] ?? userData['name'] ?? ''} ${userData['last_name'] ?? ''}").trim();
    final email = userData['email'] ?? 'Not provided';
    final phoneNo = userData['phoneNo'] ?? 'Not provided';
    final resumeLink = applicantData['resumeLink'] ?? '';
    final coverLetter = applicantData['coverLetter'] ?? 'No cover letter provided.';
    final skills = (userData['skills'] as List<dynamic>? ?? []);
    final education = (userData['education'] as List<dynamic>? ?? []);
    final experience = (userData['experience'] as List<dynamic>? ?? []);

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(name.isNotEmpty ? name : "Applicant Details"),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Contact Information"),
                  _buildDetailRow(Icons.email, "Email", email),
                  _buildDetailRow(Icons.phone, "Phone", phoneNo),
                  const Divider(height: 24),
                  
                  _buildSectionTitle("Application Details"),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.link, color: Colors.deepPurple),
                    title: const Text("Resume Link"),
                    subtitle: Text(resumeLink.isNotEmpty ? resumeLink : "Not provided", style: const TextStyle(color: Colors.blue)),
                    onTap: () => _launchURL(context, resumeLink),
                  ),
                  const SizedBox(height: 8),
                  const Text("Cover Letter", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(coverLetter, style: const TextStyle(height: 1.4)),
                  const Divider(height: 24),

                  if (skills.isNotEmpty) ...[
                    _buildSectionTitle("Skills"),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: skills.map((skill) => Chip(label: Text(skill.toString()))).toList(),
                    ),
                    const Divider(height: 24),
                  ],

                  if (experience.isNotEmpty) ...[
                    _buildSectionTitle("Work Experience"),
                    ...experience.map<Widget>((exp) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.work, color: Colors.deepPurple),
                          title: Text(exp['position'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${exp['company'] ?? 'N/A'} • ${exp['duration'] ?? 'N/A'}"),
                        )),
                    const Divider(height: 24),
                  ],

                  if (education.isNotEmpty) ...[
                    _buildSectionTitle("Education"),
                    ...education.map<Widget>((edu) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.school, color: Colors.deepPurple),
                          title: Text(edu['degree'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${edu['institution'] ?? 'N/A'} • ${edu['year_of_completion'] ?? 'N/A'}"),
                        )),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      subtitle: Text(value, style: const TextStyle(fontSize: 15)),
    );
  }

  void _launchURL(BuildContext context, String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No URL provided.")));
      return;
    }
    final Uri? uri = Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not launch $urlString")));
    }
  }

  // --- The `buildApplicantCard` is also corrected to call `updateStatus` properly ---
  Widget buildApplicantCard(Map<String, dynamic> applicantData) {
    final userData = applicantData['userData'] ?? {};
    final name = ("${userData['first_name'] ?? userData['name'] ?? ''} ${userData['last_name'] ?? ''}").trim();
    final email = userData['email'] ?? '';
    final applicantId = applicantData['applicationId'];

    return InkWell(
      onTap: () => _showApplicantDetailsDialog(applicantData),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (email.isNotEmpty) Text(email, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                      const SizedBox(height: 4),
                      const Text(
                        "Tap to view full profile",
                        style: TextStyle(fontSize: 12, color: Colors.deepPurple, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    // Corrected call: Pass the userData map
                    onPressed: () => updateStatus(applicantId, "Accepted", userData),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text("Accept"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    // Corrected call: No userData needed for rejection
                    onPressed: () => updateStatus(applicantId, "Rejected"),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text("Reject"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Applicants")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : applicants.isEmpty
              ? const Center(child: Text("No pending applicants found."))
              : RefreshIndicator(
                  onRefresh: loadApplicants,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: applicants.length,
                    itemBuilder: (context, index) {
                      return buildApplicantCard(applicants[index]);
                    },
                  ),
                ),
    );
  }
}