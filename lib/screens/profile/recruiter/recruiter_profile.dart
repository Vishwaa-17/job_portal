import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:careers/screens/login/login_screen.dart';
import 'package:careers/widgets/text_field_input.dart';
import 'package:careers/utils/dropdown_data.dart';

class RecruiterProfileScreen extends StatefulWidget {
  const RecruiterProfileScreen({super.key});

  @override
  State<RecruiterProfileScreen> createState() => _RecruiterProfileScreenState();
}

class _RecruiterProfileScreenState extends State<RecruiterProfileScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  bool isEditing = false;
  bool isLoading = true;

  // --- UPDATED to use snake_case for consistency ---
  final fields = ['first_name', 'last_name', 'linkedinurl', 'dob'];
  final Map<String, TextEditingController> controllers = {};
  Map<String, dynamic> profileData = {};

  String? selectedState;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    for (var field in fields) {
      controllers[field] = TextEditingController();
    }
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (userId == null) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('recruiters')
        .doc(userId)
        .get();
    if (mounted && doc.exists) {
      profileData = doc.data() ?? {};

      for (var field in fields) {
        controllers[field]?.text = profileData[field]?.toString() ?? '';
      }
      selectedState = profileData['state'];
      selectedCity = profileData['city'];
    }
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _saveChanges() async {
    if (userId == null) return;
    setState(() => isLoading = true);

    final updatedData = {
      for (var field in fields) field: controllers[field]?.text.trim(),
      'state': selectedState,
      'city': selectedCity,
    };

    await FirebaseFirestore.instance
        .collection('recruiters')
        .doc(userId)
        .set(updatedData, SetOptions(merge: true));

    await _loadProfile(); // Reload data to reflect changes

    if (mounted) {
      setState(() {
        isEditing = false;
        isLoading = false;
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.tryParse(controllers['dob']!.text) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controllers['dob']!.text = picked.toIso8601String().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- UPDATED to read from controllers with snake_case keys ---
    final name =
        "${controllers['first_name']?.text ?? ''} ${controllers['last_name']?.text ?? ''}"
            .trim();
    final email = profileData['email'] ?? '';
    final phone = profileData['phoneNo'] ?? '';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
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
                              name.isNotEmpty ? name : "Recruiter",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              email.isNotEmpty ? email : "No email",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              phone.isNotEmpty ? phone : "No phone",
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
                ),

                // Fields
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- UPDATED to use snake_case keys ---
                        _buildField("First Name", "first_name"),
                        _buildField("Last Name", "last_name"),
                        _buildField("LinkedIn URL", "linkedinurl"),
                        _buildField("Birthdate", "dob"),
                        _buildDropdowns(),
                      ],
                    ),
                  ),
                ),

                // Buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (isEditing)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() => isEditing = false);
                                  _loadProfile(); // Revert changes
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                child: const Text("Cancel"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                child: const Text("Save Changes"),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 12),
                      if (!isEditing)
                        ElevatedButton(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text("Logout"),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // --- HELPER WIDGETS ---
  // No major changes needed here as they use the `key` argument
  Widget _buildField(String label, String key) {
    // ... implementation remains the same
    final value = controllers[key]?.text ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        isEditing
            ? (key == 'dob'
                  ? GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFieldInput(
                          textEditingController: controllers[key]!,
                          hintText: "Select Date",
                          textInputType: TextInputType.datetime,
                        ),
                      ),
                    )
                  : TextFieldInput(
                      textEditingController: controllers[key]!,
                      hintText: "Enter $label",
                      textInputType: key.contains('url')
                          ? TextInputType.url
                          : TextInputType.text,
                    ))
            : Text(
                value.isNotEmpty ? value : "Not provided",
                style: TextStyle(
                  color: value.isEmpty ? Colors.grey : Colors.black87,
                  fontSize: 16,
                ),
              ),
        const Divider(height: 28),
      ],
    );
  }

  Widget _buildDropdowns() {
    // ... implementation remains the same
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("State", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        isEditing
            ? DropdownButtonFormField<String>(
                value: selectedState,
                hint: const Text("Select State"),
                items: stateCityMap.keys
                    .map(
                      (state) => DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  selectedState = value;
                  selectedCity = null;
                }),
              )
            : Text(
                selectedState?.isNotEmpty == true
                    ? selectedState!
                    : "Not provided",
                style: TextStyle(
                  color: selectedState == null ? Colors.grey : Colors.black87,
                  fontSize: 16,
                ),
              ),
        const Divider(height: 28),
        const Text("City", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        isEditing
            ? DropdownButtonFormField<String>(
                value: selectedCity,
                hint: const Text("Select City"),
                items:
                    (selectedState != null
                            ? stateCityMap[selectedState!] ?? []
                            : <String>[])
                        .map(
                          (city) => DropdownMenuItem<String>(
                            value: city,
                            child: Text(city),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => selectedCity = value),
              )
            : Text(
                selectedCity?.isNotEmpty == true
                    ? selectedCity!
                    : "Not provided",
                style: TextStyle(
                  color: selectedCity == null ? Colors.grey : Colors.black87,
                  fontSize: 16,
                ),
              ),
        const Divider(height: 28),
      ],
    );
  }
}
