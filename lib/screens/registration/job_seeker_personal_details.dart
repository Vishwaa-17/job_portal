import 'package:flutter/material.dart';
import 'package:careers/widgets/text_field_input.dart';
import 'package:careers/utils/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:careers/utils/utils.dart';
import 'package:careers/utils/dropdown_data.dart';
import 'package:careers/screens/registration/job_seeker_work_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobSeekerPersonalDetailsScreen extends StatefulWidget {
  final String email;
  final String phoneNo;

  const JobSeekerPersonalDetailsScreen({
    super.key,
    required this.email,
    required this.phoneNo,
  });

  @override
  State<JobSeekerPersonalDetailsScreen> createState() =>
      _JobSeekerPersonalDetailsScreenState();
}

class _JobSeekerPersonalDetailsScreenState
    extends State<JobSeekerPersonalDetailsScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? selectedState;
  String? selectedCity;
  String selectedGender = '';
  bool isLoading = false;

  bool showFirstNameError = false;
  bool showLastNameError = false;
  bool showGenderError = false;
  bool showStateError = false;
  bool showCityError = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  void _validateAndContinue() {
    setState(() {
      showFirstNameError = _firstNameController.text.trim().isEmpty;
      showLastNameError = _lastNameController.text.trim().isEmpty;
      showGenderError = selectedGender.isEmpty;
      showStateError = selectedState == null;
      showCityError = selectedCity == null;
    });

    if (showFirstNameError || showLastNameError || showGenderError || showStateError || showCityError) {
      return;
    }
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showSnackBar("User not logged in. Please restart.", context);
      return;
    }

    // --- vvvvvv THIS IS THE CORRECTED DATA MAP vvvvvv ---
    final Map<String, dynamic> personalDetails = {
      'uid': user.uid,
      // Use the correct snake_case keys that your AuthMethods expects
      'first_name': _firstNameController.text.trim(), 
      'last_name': _lastNameController.text.trim(),
      'dob': _dobController.text.trim(),
      'gender': selectedGender,
      'state': selectedState!,
      'city': selectedCity!,
      'email': widget.email,
      'phoneNo': widget.phoneNo,
    };
    // --- ^^^^^^ THIS IS THE CORRECTED DATA MAP ^^^^^^ ---

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobSeekerWorkDetailsScreen(
          personalDetails: personalDetails,
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    List<String> cityList =
        selectedState != null ? stateCityMap[selectedState!] ?? [] : [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Personal Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel("First Name *"),
              TextFieldInput(
                textEditingController: _firstNameController,
                hintText: 'Enter Your First Name',
                textInputType: TextInputType.name,
              ),
              if (showFirstNameError) _buildErrorText("First name is required"),
              const SizedBox(height: 16),

              _buildFieldLabel("Last Name *"),
              TextFieldInput(
                textEditingController: _lastNameController,
                hintText: 'Enter Your Last Name',
                textInputType: TextInputType.name,
              ),
              if (showLastNameError) _buildErrorText("Last name is required"),
              const SizedBox(height: 16),
              
              _buildFieldLabel("Date of Birth"),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: TextFieldInput(
                    textEditingController: _dobController,
                    hintText: 'DD/MM/YYYY',
                    textInputType: TextInputType.datetime,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildFieldLabel("Gender *"),
              Row(
                children: ['Male', 'Female', 'Other'].map((gender) {
                  final isSelected = selectedGender == gender;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () => setState(() { selectedGender = gender; showGenderError = false; }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? Colors.deepPurple : Colors.deepPurple[100],
                          foregroundColor: isSelected ? Colors.white : Colors.deepPurple,
                        ),
                        child: Text(gender),
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (showGenderError) _buildErrorText("Gender is required"),
              const SizedBox(height: 16),
              _buildFieldLabel("State *"),
              DropdownSearch<String>(
                items: stateCityMap.keys.toList(),
                onChanged: (value) => setState(() { selectedState = value; selectedCity = null; showStateError = false; }),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(hintText: "Select State", border: OutlineInputBorder()),
                ),
                popupProps: const PopupProps.menu(showSearchBox: true),
              ),
              if (showStateError) _buildErrorText("State is required"),
              const SizedBox(height: 16),
              _buildFieldLabel("City *"),
              DropdownSearch<String>(
                items: cityList,
                onChanged: (value) => setState(() { selectedCity = value; showCityError = false; }),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(hintText: "Select City", border: OutlineInputBorder()),
                ),
                popupProps: const PopupProps.menu(showSearchBox: true),
              ),
              if (showCityError) _buildErrorText("City is required"),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: isLoading ? null : _validateAndContinue,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: isLoading ? Colors.grey : backgroundColor, borderRadius: BorderRadius.circular(30)),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Continue", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500));
  }

  Widget _buildErrorText(String msg) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(msg, style: const TextStyle(color: Colors.red)),
    );
  }
}