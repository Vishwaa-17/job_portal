
import 'package:careers/screens/home/recruiter/applicants_list_screen.dart';
import 'package:careers/screens/home/recruiter/accepted_applicants_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecruiterJobDetail extends StatefulWidget {
  final QueryDocumentSnapshot job;

  const RecruiterJobDetail({Key? key, required this.job}) : super(key: key);

  @override
  State<RecruiterJobDetail> createState() => _RecruiterJobDetailState();
}

class _RecruiterJobDetailState extends State<RecruiterJobDetail> {
  late Map<String, dynamic> data;
  bool isClosed = false;

  @override
  void initState() {
    super.initState();
    data = widget.job.data() as Map<String, dynamic>;
    isClosed = data['isClosed'] == true;
  }

  Future<void> closeApplications() async {
    await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.job.id)
        .update({'isClosed': true});
    setState(() {
      isClosed = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Applications have been closed for this job.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stipendMin = data['stipendMin']?.toString() ?? '';
    final stipendMax = data['stipendMax']?.toString() ?? '';
    final experienceMin = data['experienceMin']?.toString() ?? '';
    final experienceMax = data['experienceMax']?.toString() ?? '';

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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                Text(data['title'] ?? '',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(data['company'] ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.deepPurple)),
                const SizedBox(height: 4),
                Text("Job ID: ${widget.job.id}",
                    style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const Icon(Icons.location_on, size: 20, color: Colors.deepPurple),
                    const SizedBox(width: 6),
                    Text(data['location'] ?? '', style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 20),
                    const Icon(Icons.work_outline, size: 20, color: Colors.deepPurple),
                    const SizedBox(width: 6),
                    Text(
                      data['experience'] ??
                          (experienceMin.isNotEmpty && experienceMax.isNotEmpty
                              ? "$experienceMin–$experienceMax yrs"
                              : "N/A"),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1.5),

                if ((data['skills'] as List<dynamic>? ?? []).isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text("Skills Required",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (data['skills'] as List<dynamic>)
                        .map((skill) => Chip(
                              label: Text(skill.toString(),
                                  style: const TextStyle(fontSize: 13)),
                              backgroundColor: Colors.grey.shade200,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1.5),
                ],

                if (stipendMin.isNotEmpty || stipendMax.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text("Stipend",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text("₹$stipendMin - ₹$stipendMax",
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 16),
                  const Divider(height: 1.5),
                ],

                _buildSection("Company Description", data['companyDescription']),
                _buildSection("Role Overview", data['roleOverview']),
                _buildSection("Role Description", data['roleDescription']),
                _buildSection("Qualifications", data['qualifications']),
                _buildSection("Industry", data['industry']),
                _buildSection("Field", data['field']),
              ],
            ),
          ),

          /// Bottom Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApplicantsListScreen(jobId: widget.job.id),
                        ),
                      );
                    },
                    child: const Text(
                      "See Applicants",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AcceptedApplicantsScreen(jobId: widget.job.id),
                        ),
                      );
                    },
                    child: const Text(
                      "See Accepted Applicants",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                if (!isClosed)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: closeApplications,
                      icon: const Icon(Icons.lock_outline, color: Colors.white),
                      label: const Text(
                        "Close Applications",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSection(String title, String? content) {
    if (content == null || content.trim().isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(content, style: const TextStyle(fontSize: 14, height: 1.4)),
        const SizedBox(height: 16),
        const Divider(height: 1.5),
      ],
    );
  }
}