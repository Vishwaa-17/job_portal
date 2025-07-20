import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> jobData;
  final String jobId;

  const JobDetailScreen({
    Key? key,
    required this.jobData,
    required this.jobId,
  }) : super(key: key);

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool hasApplied = false;
  bool isClosed = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkIfApplied();
    checkIfClosed();
  }

  Future<void> checkIfApplied() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final existingApp = await FirebaseFirestore.instance
        .collection('applications')
        .where('userId', isEqualTo: userId)
        .where('jobId', isEqualTo: widget.jobId)
        .get();
    if (mounted && existingApp.docs.isNotEmpty) {
      setState(() => hasApplied = true);
    }
  }

  Future<void> checkIfClosed() async {
    final snapshot = await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).get();
    if (mounted && snapshot.exists && snapshot.data()?['isClosed'] == true) {
      setState(() => isClosed = true);
    }
  }

  // --- THIS IS THE FINAL, CORRECTED LOGIC ---

  // The dialog's only job is to collect data and call applyToJob.
  void _showApplyDialog() {
    final formKey = GlobalKey<FormState>();
    final resumeLinkController = TextEditingController();
    final coverLetterController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Apply to ${widget.jobData['title']}"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                TextFormField(
                  controller: resumeLinkController,
                  decoration: const InputDecoration(labelText: 'Resume Link*', border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.trim().isEmpty || !(Uri.tryParse(v.trim())?.isAbsolute ?? false)) ? 'Please enter a valid URL' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: coverLetterController,
                  decoration: const InputDecoration(labelText: 'Cover Letter*', alignLabelWithHint: true, border: OutlineInputBorder()),
                  maxLines: 5,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Cover letter is required' : null,
                ),
              ]),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: const Text('Submit Application'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // The button press now does TWO things:
                  // 1. Close the dialog immediately.
                  Navigator.of(dialogContext).pop();
                  // 2. Call the function that handles the logic.
                  applyToJob(
                    resumeLink: resumeLinkController.text.trim(),
                    coverLetter: coverLetterController.text.trim(),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // This function now handles ALL state changes and UI feedback (snackbars).
  Future<void> applyToJob({required String resumeLink, required String coverLetter}) async {
    // 1. Set loading state and rebuild the main screen. THIS IS NOW SAFE.
    setState(() => _isLoading = true);

    String? errorMessage;
    bool success = false;

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final userSnapshot = await FirebaseFirestore.instance.collection('job_seekers').doc(userId).get();

      if (!userSnapshot.exists) {
        errorMessage = "Profile incomplete or not found";
      } else {
        final userData = userSnapshot.data();
        final applicationsRef = FirebaseFirestore.instance.collection('applications');
        
        await applicationsRef.add({
          'jobId': widget.jobId, 'userId': userId, 'jobData': widget.jobData,
          'userData': userData, 'status': 'Pending', 'appliedAt': Timestamp.now(),
          'resumeLink': resumeLink, 'coverLetter': coverLetter,
        });
        success = true;
      }
    } catch (e) {
      errorMessage = "An error occurred: ${e.toString()}";
    }

    // 2. After all async work is done, update the final state and show feedback.
    if (!mounted) return; // Final safety check

    setState(() {
      if (success) {
        hasApplied = true;
      }
      _isLoading = false;
    });

    // 3. Show the appropriate snackbar.
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Application submitted successfully!"), backgroundColor: Colors.green),
      );
    } else if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  // The build method remains unchanged.
  @override
  Widget build(BuildContext context) {
    // ... no changes needed here ...
    final job = widget.jobData;
    final stipendMin = job['stipendMin']?.toString() ?? '';
    final stipendMax = job['stipendMax']?.toString() ?? '';
    final experienceMin = job['experienceMin']?.toString() ?? '';
    final experienceMax = job['experienceMax']?.toString() ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Job Details", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.6,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          Text(job['title'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(job['company'] ?? '', style: const TextStyle(fontSize: 16, color: Colors.deepPurple)),
          const SizedBox(height: 4),
          Text("Job ID: ${widget.jobId}", style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 16),
          Row(children: [
            const Icon(Icons.location_on, size: 20, color: Colors.deepPurple), const SizedBox(width: 6),
            Text(job['location'] ?? '', style: const TextStyle(fontSize: 14)), const SizedBox(width: 20),
            const Icon(Icons.work_outline, size: 20, color: Colors.deepPurple), const SizedBox(width: 6),
            Text(job['experience'] ?? (experienceMin.isNotEmpty && experienceMax.isNotEmpty ? "$experienceMin–$experienceMax yrs" : "N/A"), style: const TextStyle(fontSize: 14)),
          ]),
          const SizedBox(height: 16), const Divider(height: 1.5),
          if ((job['skills'] as List<dynamic>? ?? []).isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text("Skills Required", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)), const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: (job['skills'] as List<dynamic>).map((skill) => Chip(label: Text(skill.toString(), style: const TextStyle(fontSize: 13)), backgroundColor: Colors.grey.shade200, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))).toList(),
            ),
            const SizedBox(height: 16), const Divider(height: 1.5),
          ],
          if (stipendMin.isNotEmpty || stipendMax.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text("Stipend", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)), const SizedBox(height: 6),
            Text("₹$stipendMin - ₹$stipendMax", style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16), const Divider(height: 1.5),
          ],
          _buildSection("Company Description", job['companyDescription']),
          _buildSection("Role Overview", job['roleOverview']),
          _buildSection("Role Description", job['roleDescription']),
          _buildSection("Qualifications", job['qualifications']),
          _buildSection("Industry", job['industry']),
          _buildSection("Field", job['field']),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isClosed ? Colors.grey : hasApplied ? Colors.deepPurple.shade100 : Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: (hasApplied || isClosed || _isLoading) ? null : _showApplyDialog,
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : Text(isClosed ? "Applications Closed" : hasApplied ? "Applied" : "Apply Now",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isClosed ? Colors.white : hasApplied ? Colors.deepPurple : Colors.white)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String? content) {
    if (content == null || content.trim().isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 16),
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)), const SizedBox(height: 6),
      Text(content, style: const TextStyle(fontSize: 14, height: 1.4)), const SizedBox(height: 16),
      const Divider(height: 1.5),
    ]);
  }
}