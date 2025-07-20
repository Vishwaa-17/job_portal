import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ------------------------------
/// Recruiter Job Card
/// ------------------------------
class RecruiterJobCard extends StatelessWidget {
  final Map<String, dynamic> jobData;
  final VoidCallback? onTap;

  const RecruiterJobCard({
    Key? key,
    required this.jobData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildJobInfo(jobData)),
            const SizedBox(width: 12),
            _buildCompanyLogo(jobData),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------
/// Job Seeker Job Card
/// ------------------------------
class JobSeekerJobCard extends StatelessWidget {
  final Map<String, dynamic> jobData;
  final VoidCallback? onTap;

  const JobSeekerJobCard({
    Key? key,
    required this.jobData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildJobInfo(jobData)),
            const SizedBox(width: 12),
            _buildCompanyLogo(jobData),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------
/// Applied Job Card (For status view)
/// ------------------------------
class AppliedJobCard extends StatelessWidget {
  final Map<String, dynamic> jobData;
  final String status;
  final VoidCallback? onTap;

  const AppliedJobCard({
    Key? key,
    required this.jobData,
    required this.status,
    this.onTap,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildJobInfo(jobData),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: statusColor),
                      borderRadius: BorderRadius.circular(20),
                      color: statusColor.withOpacity(0.1),
                    ),
                    child: Text(
                      status[0].toUpperCase() + status.substring(1),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildCompanyLogo(jobData),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------
/// Shared Helpers
/// ------------------------------
Widget _buildCompanyLogo(Map<String, dynamic> data) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: (data['companyLogo'] != null && data['companyLogo'].toString().isNotEmpty)
        ? Image.network(
            data['companyLogo'],
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 48,
              height: 48,
              color: Colors.grey.shade200,
              child: const Icon(Icons.business, color: Colors.grey),
            ),
          )
        : Container(
            width: 48,
            height: 48,
            color: Colors.grey.shade200,
            child: const Icon(Icons.business, color: Colors.grey),
          ),
  );
}

Widget _buildJobInfo(Map<String, dynamic> data) {
  final title = data['title'] ?? '[No Title]';
  final company = data['company'] ?? '[Company]';
  final location = data['location'] ?? 'N/A';
  final experience = data['experience'] ?? "${data['experienceMin'] ?? ''} - ${data['experienceMax'] ?? ''} yrs";
  final stipend = data['stipend'] ?? "₹${data['stipendMin'] ?? ''} - ₹${data['stipendMax'] ?? ''}";

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text(company, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      const SizedBox(height: 12),
      Row(
        children: [
          const Icon(Icons.work_outline, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Text(experience, style: const TextStyle(fontSize: 12)),
        ],
      ),
      const SizedBox(height: 4),
      Row(
        children: [
          const Icon(Icons.currency_rupee, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Text(stipend, style: const TextStyle(fontSize: 12)),
        ],
      ),
      const SizedBox(height: 4),
      Row(
        children: [
          const Icon(Icons.location_on, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Text(location, style: const TextStyle(fontSize: 12)),
        ],
      ),
    ],
  );
}
