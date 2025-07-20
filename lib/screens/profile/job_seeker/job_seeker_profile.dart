import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:careers/widgets/text_field_input.dart';
import 'package:careers/utils/dropdown_data.dart';
import 'package:careers/screens/login/login_screen.dart';

class EducationEntry {
  final TextEditingController degree;
  final TextEditingController specialization;
  final TextEditingController year;

  EducationEntry({
    String degree = '',
    String specialization = '',
    String year = '',
  }) : this.degree = TextEditingController(text: degree),
       this.specialization = TextEditingController(text: specialization),
       this.year = TextEditingController(text: year);

  Map<String, dynamic> toJson() => {
    'degree': degree.text.trim(),
    'specialization': specialization.text.trim(),
    'year': year.text.trim(),
  };

  static EducationEntry fromJson(Map<String, dynamic> json) => EducationEntry(
    degree: json['degree'] ?? '',
    specialization: json['specialization'] ?? '',
    year: json['year'] ?? '',
  );
}

class WorkExperienceEntry {
  final TextEditingController company;
  final TextEditingController position;
  String? startMonth;
  String? startYear;
  String? endMonth;
  String? endYear;

  WorkExperienceEntry({
    String company = '',
    String position = '',
    this.startMonth,
    this.startYear,
    this.endMonth,
    this.endYear,
  }) : this.company = TextEditingController(text: company),
       this.position = TextEditingController(text: position);

  Map<String, dynamic> toJson() => {
    'company': company.text.trim(),
    'position': position.text.trim(),
    'start_month': startMonth,
    'start_year': startYear,
    'end_month': endMonth,
    'end_year': endYear,
  };

  static WorkExperienceEntry fromJson(Map<String, dynamic> json) =>
      WorkExperienceEntry(
        company: json['company'] ?? '',
        position: json['position'] ?? '',
        startMonth: json['start_month'],
        startYear: json['start_year'],
        endMonth: json['end_month'],
        endYear: json['end_year'],
      );
}

class JobSeekerProfileScreen extends StatefulWidget {
  const JobSeekerProfileScreen({Key? key}) : super(key: key);

  @override
  State<JobSeekerProfileScreen> createState() => _JobSeekerProfileScreenState();
}

class _JobSeekerProfileScreenState extends State<JobSeekerProfileScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  bool isEditing = false;
  bool isLoading = true;

  final simpleFields = [
    'first_name',
    'last_name',
    'linkedinurl',
    'githuburl',
    'dob',
  ];
  final controllers = <String, TextEditingController>{};
  Map<String, dynamic> profileData = {};

  String? selectedState;
  String? selectedCity;
  List<EducationEntry> educationEntries = [];
  List<WorkExperienceEntry> workEntries = [];
  List<String> selectedSkills = [];
  final TextEditingController _resumeUrlController = TextEditingController();

  // --- NEW: State for experience flag ---
  bool hasExperience = false;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final List<String> years = List.generate(
    60,
    (index) => (DateTime.now().year - index).toString(),
  );

  @override
  void initState() {
    super.initState();
    for (var field in simpleFields) {
      controllers[field] = TextEditingController();
    }
    _loadProfile();
  }

  @override
  void dispose() {
    // ... dispose logic is fine ...
    controllers.forEach((_, controller) => controller.dispose());
    for (var entry in educationEntries) {
      entry.degree.dispose();
      entry.specialization.dispose();
      entry.year.dispose();
    }
    for (var entry in workEntries) {
      entry.company.dispose();
      entry.position.dispose();
    }
    _resumeUrlController.dispose();
    super.dispose();
  }

  // --- UPDATED: Load profile now handles has_experience ---
  Future<void> _loadProfile() async {
    if (userId == null) {
      if (mounted) setState(() => isLoading = false);
      return;
    }
    try {
      final profileDoc = await FirebaseFirestore.instance
          .collection('job_seekers')
          .doc(userId)
          .get();
      if (mounted && profileDoc.exists) {
        profileData = profileDoc.data()!;
        for (var field in simpleFields) {
          controllers[field]?.text = profileData[field]?.toString() ?? '';
        }
        selectedState = profileData['state'];
        selectedCity = profileData['city'];
        selectedSkills = List<String>.from(profileData['skills'] ?? []);
        _resumeUrlController.text = profileData['resume_url'] ?? '';

        // --- Correctly read the has_experience flag ---
        hasExperience = profileData['has_experience'] ?? false;

        educationEntries = (profileData['education'] as List? ?? [])
            .map((edu) => EducationEntry.fromJson(edu))
            .toList();
        workEntries = (profileData['work_experience'] as List? ?? [])
            .map((work) => WorkExperienceEntry.fromJson(work))
            .toList();
      }
    } catch (e) {
      print("Error loading profile: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --- UPDATED: Save profile now handles has_experience ---
  Future<void> _saveProfile() async {
    if (userId == null) return;
    setState(() => isLoading = true);
    try {
      final dataToSave = {
        for (var field in simpleFields) field: controllers[field]!.text.trim(),
        'state': selectedState,
        'city': selectedCity,
        'education': educationEntries.map((e) => e.toJson()).toList(),
        'skills': selectedSkills,
        'resume_url': _resumeUrlController.text.trim(),
        'name':
            "${controllers['first_name']!.text.trim()} ${controllers['last_name']!.text.trim()}"
                .trim(),
        // --- Correctly save the has_experience flag ---
        'has_experience': hasExperience,
        'work_experience': hasExperience
            ? workEntries.map((w) => w.toJson()).toList()
            : [],
      };
      await FirebaseFirestore.instance
          .collection('job_seekers')
          .doc(userId)
          .set(dataToSave, SetOptions(merge: true));
      await _loadProfile();
      if (mounted) {
        setState(() {
          isEditing = false;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save profile: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && !isEditing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Personal Information"),
                  buildField("First Name", "first_name"),
                  buildField("Last Name", "last_name"),
                  buildField("LinkedIn URL", "linkedinurl"),
                  buildField("GitHub URL", "githuburl"),
                  buildField("Birthdate", "dob", datePicker: true),
                  buildDropdown(
                    "State",
                    stateCityMap.keys.toList(),
                    selectedState,
                    (v) => setState(() {
                      selectedState = v;
                      selectedCity = null;
                    }),
                  ),
                  buildDropdown(
                    "City",
                    selectedState == null ? [] : stateCityMap[selectedState!]!,
                    selectedCity,
                    (v) => setState(() => selectedCity = v),
                  ),
                  const SizedBox(height: 16),
                  _buildEducationSection(),
                  const SizedBox(height: 16),
                  _buildWorkSection(),
                  const SizedBox(height: 16),
                  _buildSkillsSection(),
                  const SizedBox(height: 16),
                  _buildResumeSection(),
                ],
              ),
            ),
          ),
          _buildFooterButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    String displayName =
        "${controllers['first_name']?.text ?? ''} ${controllers['last_name']?.text ?? ''}"
            .trim();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName.isEmpty ? "User Profile" : displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  profileData['email'] ??
                      FirebaseAuth.instance.currentUser?.email ??
                      "No email",
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  profileData['phoneNo'] ?? "No phone provided",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => setState(() => isEditing = true),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Education"),
        if (educationEntries.isEmpty && !isEditing)
          const Text("No education details provided."),
        ...educationEntries.asMap().entries.map((entry) {
          int idx = entry.key;
          EducationEntry edu = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isEditing)
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            setState(() => educationEntries.removeAt(idx)),
                      ),
                    ),
                  buildSubField("Degree", edu.degree, isEditing),
                  buildSubField(
                    "Specialization",
                    edu.specialization,
                    isEditing,
                  ),
                  buildSubField("Year of Completion", edu.year, isEditing),
                ],
              ),
            ),
          );
        }).toList(),
        if (isEditing)
          Align(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Education"),
              onPressed: () =>
                  setState(() => educationEntries.add(EducationEntry())),
            ),
          ),
        const Divider(height: 28),
      ],
    );
  }

  // --- UPDATED: Work section now uses the `hasExperience` flag ---
  Widget _buildWorkSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Work Experience"),
        // In edit mode, show the Yes/No buttons
        if (isEditing)
          Row(
            children: ['Yes', 'No'].map((label) {
              final selected =
                  (hasExperience && label == 'Yes') ||
                  (!hasExperience && label == 'No');
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () =>
                        setState(() => hasExperience = label == 'Yes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selected
                          ? Colors.deepPurple
                          : Colors.grey[200],
                      foregroundColor: selected ? Colors.white : Colors.black,
                    ),
                    child: Text(label),
                  ),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 12),
        // Display logic based on hasExperience flag
        if (!hasExperience)
          const Text("No work experience provided.")
        else
          ...workEntries.asMap().entries.map((entry) {
            int idx = entry.key;
            WorkExperienceEntry work = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isEditing)
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              setState(() => workEntries.removeAt(idx)),
                        ),
                      ),
                    buildSubField("Company", work.company, isEditing),
                    buildSubField("Position", work.position, isEditing),
                    const SizedBox(height: 8),
                    const Text(
                      "Duration",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    isEditing
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: buildSubDropdown(
                                      "Start Month",
                                      months,
                                      work.startMonth,
                                      (v) =>
                                          setState(() => work.startMonth = v),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: buildSubDropdown(
                                      "Start Year",
                                      years,
                                      work.startYear,
                                      (v) => setState(() => work.startYear = v),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: buildSubDropdown(
                                      "End Month",
                                      months,
                                      work.endMonth,
                                      (v) => setState(() => work.endMonth = v),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: buildSubDropdown(
                                      "End Year",
                                      years,
                                      work.endYear,
                                      (v) => setState(() => work.endYear = v),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Text(
                            (work.startMonth != null || work.startYear != null)
                                ? "${work.startMonth ?? ''} ${work.startYear ?? ''} - ${work.endMonth ?? ''} ${work.endYear ?? ''}"
                                : "Not provided",
                            style: TextStyle(
                              color:
                                  (work.startMonth == null &&
                                      work.startYear == null)
                                  ? Colors.grey
                                  : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                  ],
                ),
              ),
            );
          }).toList(),
        if (isEditing && hasExperience)
          Align(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Experience"),
              onPressed: () =>
                  setState(() => workEntries.add(WorkExperienceEntry())),
            ),
          ),
        const Divider(height: 28),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Skills"),
        if (selectedSkills.isEmpty && !isEditing)
          const Text("No skills provided."),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: selectedSkills
              .map(
                (s) => Chip(
                  label: Text(s),
                  onDeleted: isEditing
                      ? () => setState(() => selectedSkills.remove(s))
                      : null,
                  deleteIconColor: Colors.red,
                ),
              )
              .toList(),
        ),
        if (isEditing)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Add skill and press enter",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty &&
                    !selectedSkills.contains(value.trim())) {
                  setState(() {
                    selectedSkills.add(value.trim());
                  });
                }
              },
            ),
          ),
        const Divider(height: 28),
      ],
    );
  }

  Widget _buildResumeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Resume"),
        buildSubField("Resume URL", _resumeUrlController, isEditing),
        const Divider(height: 28),
      ],
    );
  }

  Widget _buildFooterButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: isEditing
          ? Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                        isLoading = true;
                      });
                      _loadProfile();
                    },
                    child: const Text("Cancel"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: isLoading
                        ? const SizedBox.shrink()
                        : const Icon(Icons.save),
                    label: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save"),
                    onPressed: isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ),
              ],
            )
          : ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Logout"),
            ),
    );
  }

  Widget buildField(String label, String key, {bool datePicker = false}) {
    final ctl = controllers[key]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        isEditing
            ? datePicker
                  ? GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.tryParse(ctl.text) ?? DateTime(2000),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(
                            () => ctl.text = picked
                                .toIso8601String()
                                .split('T')
                                .first,
                          );
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFieldInput(
                          textEditingController: ctl,
                          hintText: "Select Date",
                          textInputType: TextInputType.datetime,
                        ),
                      ),
                    )
                  : TextFieldInput(
                      textEditingController: ctl,
                      hintText: "Enter $label",
                      textInputType: TextInputType.text,
                    )
            : Text(
                ctl.text.isEmpty ? "Not provided" : ctl.text,
                style: TextStyle(
                  color: ctl.text.isEmpty ? Colors.grey : Colors.black87,
                  fontSize: 16,
                ),
              ),
        const Divider(height: 28),
      ],
    );
  }

  Widget buildSubField(
    String label,
    TextEditingController ctl,
    bool isEditing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        isEditing
            ? TextFieldInput(
                textEditingController: ctl,
                hintText: "Paste ${label.toLowerCase()} here",
                textInputType: TextInputType.url,
              )
            : Text(
                ctl.text.isEmpty ? "Not provided" : ctl.text,
                style: TextStyle(
                  color: ctl.text.isEmpty ? Colors.grey : Colors.blue,
                  fontSize: 16,
                  decoration: ctl.text.isEmpty
                      ? null
                      : TextDecoration.underline,
                ),
              ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget buildDropdown(
    String label,
    List<String> options,
    String? selected,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        isEditing
            ? DropdownButtonFormField<String>(
                value: selected,
                isExpanded: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Select $label",
                ),
                items: options
                    .map(
                      (o) => DropdownMenuItem(
                        value: o,
                        child: Text(o, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              )
            : Text(
                selected ?? "Not provided",
                style: TextStyle(
                  color: selected == null ? Colors.grey : Colors.black87,
                  fontSize: 16,
                ),
              ),
        const Divider(height: 28),
      ],
    );
  }

  Widget buildSubDropdown(
    String label,
    List<String> options,
    String? selected,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selected,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      isExpanded: true,
      items: options
          .map(
            (o) => DropdownMenuItem(
              value: o,
              child: Text(o, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
