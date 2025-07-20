import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:careers/widgets/job_card.dart';
import 'package:careers/screens/home/job_seeker/job_detail_screen.dart';

class JobListScreen extends StatefulWidget {
  final String? keyword;
  final String? location;

  const JobListScreen({
    Key? key,
    this.keyword,
    this.location,
  }) : super(key: key);

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  List<Map<String, dynamic>> jobResults = [];
  List<String> jobIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    final keyword = widget.keyword?.trim() ?? '';
    final location = widget.location?.trim() ?? '';

    final Set<String> seenIds = {};
    final List<Map<String, dynamic>> allJobs = [];
    final List<String> allIds = [];

    if (keyword.isEmpty && location.isEmpty) {
      setState(() {
        jobResults = [];
        jobIds = [];
        isLoading = false;
      });
      return;
    }

    if (keyword.isNotEmpty && location.isNotEmpty) {
      final words = keyword.split(" ");
      for (String word in words) {
        final snapshot = await FirebaseFirestore.instance
            .collection('jobs')
            .where('keywords', arrayContains: word)
            .where('location', isEqualTo: location)
            .get();

        for (var doc in snapshot.docs) {
          if (!seenIds.contains(doc.id)) {
            allJobs.add(doc.data());
            allIds.add(doc.id);
            seenIds.add(doc.id);
          }
        }
      }
    } else if (keyword.isNotEmpty) {
      final words = keyword.split(" ");
      for (String word in words) {
        final snapshot = await FirebaseFirestore.instance
            .collection('jobs')
            .where('keywords', arrayContains: word)
            .get();

        for (var doc in snapshot.docs) {
          if (!seenIds.contains(doc.id)) {
            allJobs.add(doc.data());
            allIds.add(doc.id);
            seenIds.add(doc.id);
          }
        }
      }
    } else if (location.isNotEmpty) {
      final snapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where('location', isEqualTo: location)
          .get();

      for (var doc in snapshot.docs) {
        if (!seenIds.contains(doc.id)) {
          allJobs.add(doc.data());
          allIds.add(doc.id);
          seenIds.add(doc.id);
        }
      }
    }

    setState(() {
      jobResults = allJobs;
      jobIds = allIds;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Jobs',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobResults.isEmpty
              ? const Center(child: Text("No matching jobs found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jobResults.length,
                  itemBuilder: (context, index) {
                    final job = jobResults[index];
                    final jobId = jobIds[index];

                    return JobSeekerJobCard(
                      jobData: job,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailScreen(
                              jobId: jobId,
                              jobData: job,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
