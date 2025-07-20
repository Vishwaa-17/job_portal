import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:careers/widgets/text_field_input.dart';
import 'package:careers/utils/colors.dart';
import 'package:careers/screens/home/recruiter/recruiter_home.dart';
import 'package:careers/utils/dropdown_data.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _jobTitle = TextEditingController();
  final _companyName = TextEditingController();
  final _companyUrl = TextEditingController();
  final _companyLogoUrl = TextEditingController();
  final _stipend = TextEditingController();
  final _companyDescription = TextEditingController();
  final _roleOverview = TextEditingController();
  final _roleDescription = TextEditingController();
  final _qualifications = TextEditingController();

  String? selectedState;
  String? selectedCity;
  String? selectedIndustry;
  String? selectedField;
  List<String> selectedSkills = [];
  String? selectedExperience;

  bool isLoading = false;

  final List<String> experienceOptions = [
    'Fresher', '0-1 years', '1-2 years', '2-5 years', '5+ years'
  ];

  Future<void> _postJob() async {
    if (_jobTitle.text.isEmpty ||
        _companyName.text.isEmpty ||
        selectedState == null ||
        selectedCity == null ||
        _companyLogoUrl.text.isEmpty ||
        selectedExperience == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => isLoading = true);
    final recruiterId = FirebaseAuth.instance.currentUser!.uid;

    try {
      /// Generate keywords (Preserve original casing)
      final Set<String> keywordSet = {
        _jobTitle.text.trim(),
        _companyName.text.trim(),
        if (selectedIndustry != null) selectedIndustry!.trim(),
        if (selectedField != null) selectedField!.trim(),
        ...selectedSkills.map((e) => e.trim()),
      };

      final jobData = {
        'title': _jobTitle.text.trim(),
        'company': _companyName.text.trim(),
        'companyUrl': _companyUrl.text.trim(),
        'companyLogo': _companyLogoUrl.text.trim(),
        'location': "$selectedCity, $selectedState",
        'skills': selectedSkills,
        'stipend': _stipend.text.trim(),
        'experience': selectedExperience,
        'companyDescription': _companyDescription.text.trim(),
        'roleOverview': _roleOverview.text.trim(),
        'roleDescription': _roleDescription.text.trim(),
        'qualifications': _qualifications.text.trim(),
        'industry': selectedIndustry ?? '',
        'field': selectedField ?? '',
        'recruiterId': recruiterId,
        'postedAt': Timestamp.now(),
        'status': 'open',
        'keywords': keywordSet.toList(),
      };

      await FirebaseFirestore.instance.collection('jobs').add(jobData);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RecruiterHome()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> fields = selectedIndustry != null
        ? fieldMap[selectedIndustry!] ?? []
        : [];

    List<String> skills = selectedField != null
        ? skillsMap[selectedField!] ?? []
        : [];

    List<String> cities = selectedState != null
        ? stateCityMap[selectedState!] ?? []
        : [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Post a Job",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabel("Job Title *"),
              TextFieldInput(
                textEditingController: _jobTitle,
                hintText: "Enter job title",
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 16),

              buildLabel("Company Name *"),
              TextFieldInput(
                textEditingController: _companyName,
                hintText: "Company",
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 16),

              buildLabel("Company Logo URL *"),
              TextFieldInput(
                textEditingController: _companyLogoUrl,
                hintText: "https://logo.clearbit.com/google.com",
                textInputType: TextInputType.url,
              ),
              const SizedBox(height: 16),

              buildLabel("Company URL"),
              TextFieldInput(
                textEditingController: _companyUrl,
                hintText: "https://...",
                textInputType: TextInputType.url,
              ),
              const SizedBox(height: 16),

              buildLabel("State *"),
              DropdownSearch<String>(
                items: stateCityMap.keys.toList(),
                selectedItem: selectedState,
                onChanged: (val) {
                  setState(() {
                    selectedState = val;
                    selectedCity = null;
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select State",
                  ),
                ),
              ),
              const SizedBox(height: 16),

              buildLabel("City *"),
              DropdownSearch<String>(
                items: cities,
                selectedItem: selectedCity,
                onChanged: (val) => setState(() => selectedCity = val),
                enabled: selectedState != null,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select City",
                  ),
                ),
              ),
              const SizedBox(height: 16),

              buildLabel("Industry"),
              DropdownSearch<String>(
                items: industryOptions,
                selectedItem: selectedIndustry,
                onChanged: (val) {
                  setState(() {
                    selectedIndustry = val;
                    selectedField = null;
                    selectedSkills = [];
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select Industry",
                  ),
                ),
              ),
              const SizedBox(height: 16),

              buildLabel("Field"),
              DropdownSearch<String>(
                items: fields,
                selectedItem: selectedField,
                onChanged: (val) {
                  setState(() {
                    selectedField = val;
                    selectedSkills = [];
                  });
                },
                enabled: selectedIndustry != null,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select Field",
                  ),
                ),
              ),
              const SizedBox(height: 16),

              buildLabel("Skills"),
              DropdownSearch<String>.multiSelection(
                items: skills,
                selectedItems: selectedSkills,
                onChanged: (val) => setState(() => selectedSkills = val),
                enabled: selectedField != null,
                popupProps: const PopupPropsMultiSelection.menu(showSearchBox: true),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select Skills",
                  ),
                ),
              ),
              const SizedBox(height: 16),

              buildLabel("Experience Required *"),
              DropdownSearch<String>(
                items: experienceOptions,
                selectedItem: selectedExperience,
                onChanged: (val) => setState(() => selectedExperience = val),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select Experience",
                  ),
                ),
              ),
              const SizedBox(height: 16),

              buildLabel("Stipend Range"),
              TextFieldInput(
                textEditingController: _stipend,
                hintText: "₹10,000 - ₹20,000",
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 16),

              buildLabel("Company Description"),
              TextFieldInput(
                textEditingController: _companyDescription,
                hintText: "About the company",
                textInputType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),

              buildLabel("Role Overview"),
              TextFieldInput(
                textEditingController: _roleOverview,
                hintText: "Summary of role",
                textInputType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),

              buildLabel("Role Description"),
              TextFieldInput(
                textEditingController: _roleDescription,
                hintText: "Detailed responsibilities",
                textInputType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),

              buildLabel("Qualifications"),
              TextFieldInput(
                textEditingController: _qualifications,
                hintText: "Education, certificates",
                textInputType: TextInputType.multiline,
              ),
              const SizedBox(height: 30),

              GestureDetector(
                onTap: isLoading ? null : _postJob,
                child: Container(
                  width: double.infinity,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                      : const Text(
                          "Post Job",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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