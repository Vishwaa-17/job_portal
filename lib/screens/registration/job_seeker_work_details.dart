import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:careers/resources/auth_methods.dart'; // Import AuthMethods
import 'package:careers/screens/home/job_seeker/job_seeker_home.dart';
import 'package:careers/utils/colors.dart';
import 'package:careers/utils/utils.dart';

class JobSeekerWorkDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> personalDetails;

  const JobSeekerWorkDetailsScreen({
    super.key,
    required this.personalDetails,
  });

  @override
  State<JobSeekerWorkDetailsScreen> createState() =>
      _JobSeekerWorkDetailsScreenState();
}

class _JobSeekerWorkDetailsScreenState
    extends State<JobSeekerWorkDetailsScreen> {
  bool hasExperience = false;
  bool isLoading = false;

  // Each entry is a map of controllers and selected values
  final List<Map<String, dynamic>> workEntries = [];

  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final List<String> years =
      List.generate(60, (index) => (DateTime.now().year - index).toString());
      
  final Map<int, String?> companyErrors = {};
  final Map<int, String?> positionErrors = {};
  final Map<int, String?> timeErrors = {};

  @override
  void initState() {
    super.initState();
    // Start with one empty entry if user says "Yes"
    _addWorkEntry(); 
  }

  void _addWorkEntry() {
    setState(() {
      workEntries.add({
        'company': TextEditingController(),
        'position': TextEditingController(),
        'startMonth': null,
        'startYear': null,
        'endMonth': null,
        'endYear': null,
      });
    });
  }

  void _removeWorkEntry(int index) {
    // Dispose controllers before removing to prevent memory leaks
    (workEntries[index]['company'] as TextEditingController).dispose();
    (workEntries[index]['position'] as TextEditingController).dispose();
    setState(() {
      workEntries.removeAt(index);
    });
  }

  Future<void> _validateAndSubmit() async {
    setState(() {
      isLoading = true;
      companyErrors.clear();
      positionErrors.clear();
      timeErrors.clear();
    });
    
    bool isValid = true;

    if (hasExperience) {
      if (workEntries.isEmpty) {
        // If they say yes but add no entries, add one back for them to fill.
        _addWorkEntry();
        showSnackBar("Please add at least one work experience.", context);
        isValid = false;
      }

      for (int i = 0; i < workEntries.length; i++) {
        final entry = workEntries[i];
        if ((entry['company'] as TextEditingController).text.trim().isEmpty) {
          companyErrors[i] = 'Company name is required';
          isValid = false;
        }
        if ((entry['position'] as TextEditingController).text.trim().isEmpty) {
          positionErrors[i] = 'Position is required';
          isValid = false;
        }
        if (entry['startMonth'] == null || entry['startYear'] == null) {
          timeErrors[i] = 'Complete duration is required';
          isValid = false;
        }
      }
    }

    if (!isValid) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in');

      // Prepare the experience data to be saved
      final List<Map<String, dynamic>> experienceData = hasExperience
          ? workEntries.map((entry) => {
              'company': (entry['company'] as TextEditingController).text.trim(),
              'position': (entry['position'] as TextEditingController).text.trim(),
              'start_month': entry['startMonth'],
              'start_year': entry['startYear'],
              'end_month': entry['endMonth'],
              'end_year': entry['endYear'],
            }).toList()
          : [];

      // Create the final complete profile map
      final Map<String, dynamic> finalProfileData = {
        ...widget.personalDetails, // Personal details from previous screen
        'has_experience': hasExperience,
        'work_experience': experienceData, // Changed key to match profile screen
      };

      // Call the single save method from AuthMethods
      await AuthMethods().saveJobSeekerPersonalDetails(
        uid: finalProfileData['uid'],
        firstName: finalProfileData['first_name'],
        lastName: finalProfileData['last_name'],
        dob: finalProfileData['dob'],
        gender: finalProfileData['gender'],
        state: finalProfileData['state'],
        city: finalProfileData['city'],
        email: finalProfileData['email'],
        phoneNo: finalProfileData['phoneNo'],
      );

      // Now save the work details separately using update to merge
      await FirebaseFirestore.instance.collection('job_seekers').doc(userId).update({
        'has_experience': hasExperience,
        'work_experience': experienceData,
      });

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const JobSeekerHome()),
        (route) => false,
      );
    } catch (e) {
      showSnackBar("Failed to save data: ${e.toString()}", context);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    for (var entry in workEntries) {
      (entry['company'] as TextEditingController).dispose();
      (entry['position'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Work Experience', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Do you have any work experience?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Row(
                children: ['Yes', 'No'].map((label) {
                  final selected = (hasExperience && label == 'Yes') || (!hasExperience && label == 'No');
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () => setState(() => hasExperience = label == 'Yes'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selected ? backgroundColor : Colors.grey[200],
                          foregroundColor: selected ? Colors.white : Colors.black,
                        ),
                        child: Text(label),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              if (hasExperience) ...[
                const Divider(thickness: 1, height: 20),
                ...workEntries.asMap().entries.map((entry) {
                  final i = entry.key;
                  final work = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(i > 0) Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () => _removeWorkEntry(i)),
                      ),
                      _buildLabeledTextField("Company Name *", work['company'], companyErrors[i]),
                      _buildLabeledTextField("Position *", work['position'], positionErrors[i]),
                      const Text("Time Duration *", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Row(children: [
                        Expanded(child: _buildDropdown(months, work['startMonth'], (val) => setState(() => work['startMonth'] = val), "Start Month")),
                        const SizedBox(width: 8),
                        Expanded(child: _buildDropdown(years, work['startYear'], (val) => setState(() => work['startYear'] = val), "Start Year")),
                      ]),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(child: _buildDropdown(months, work['endMonth'], (val) => setState(() => work['endMonth'] = val), "End Month")),
                        const SizedBox(width: 8),
                        Expanded(child: _buildDropdown(years, work['endYear'], (val) => setState(() => work['endYear'] = val), "End Year")),
                      ]),
                      if (timeErrors[i] != null) Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 12),
                        child: Text(timeErrors[i]!, style: const TextStyle(color: Colors.red, fontSize: 14)),
                      ),
                      if(i < workEntries.length - 1) const Divider(thickness: 1, height: 32),
                    ],
                  );
                }).toList(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _addWorkEntry,
                    icon: const Icon(Icons.add),
                    label: const Text("Add More Experience"),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              GestureDetector(
                onTap: isLoading ? null : _validateAndSubmit,
                child: Container(
                  width: double.infinity, height: 50,
                  decoration: BoxDecoration(color: isLoading ? Colors.grey : backgroundColor, borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  child: isLoading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Finish Registration", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller, String? errorText) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)), const SizedBox(height: 6),
      TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Enter ${label.toLowerCase()}', border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(12), errorText: errorText
        ),
      ), const SizedBox(height: 12),
    ]);
  }

  Widget _buildDropdown(List<String> items, String? selectedItem, ValueChanged<String?> onChanged, String hint) {
    return DropdownSearch<String>(
      items: items, selectedItem: selectedItem, onChanged: onChanged,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: hint, border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
        ),
      ),
       popupProps: const PopupProps.menu(showSearchBox: true, fit: FlexFit.loose),
    );
  }
}