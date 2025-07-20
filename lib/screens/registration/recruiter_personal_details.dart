

import 'package:flutter/material.dart';
import 'package:careers/widgets/text_field_input.dart';
import 'package:careers/utils/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:careers/resources/auth_methods.dart';
import 'package:careers/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:careers/screens/home/recruiter/recruiter_home.dart';
import 'package:careers/utils/dropdown_data.dart';

class RecruiterPersonalDetailsScreen extends StatefulWidget {
  // --- vvvvvvvv THIS IS UPDATED vvvvvvvv ---
  // We no longer need userType, but we DO need email and phoneNo
  final String email;
  final String phoneNo;

  const RecruiterPersonalDetailsScreen({
    super.key,
    required this.email,
    required this.phoneNo,
  });
  // --- ^^^^^^^^ THIS IS UPDATED ^^^^^^^^ ---

  @override
  State<RecruiterPersonalDetailsScreen> createState() =>
      _RecruiterPersonalDetailsScreenState();
}

class _RecruiterPersonalDetailsScreenState
    extends State<RecruiterPersonalDetailsScreen> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _dob = TextEditingController();

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
    _firstName.dispose();
    _lastName.dispose();
    _dob.dispose();
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
      _dob.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  // --- vvvvvvvv THIS FUNCTION IS THE MAIN FIX vvvvvvvv ---
  void _validateAndSubmit() async {
    setState(() {
      showFirstNameError = _firstName.text.trim().isEmpty;
      showLastNameError = _lastName.text.trim().isEmpty;
      showGenderError = selectedGender.isEmpty;
      showStateError = selectedState == null;
      showCityError = selectedCity == null;
    });

    if (showFirstNameError ||
        showLastNameError ||
        showGenderError ||
        showStateError ||
        showCityError) return;

    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        showSnackBar("User not logged in. Please try again.", context);
        setState(() => isLoading = false); // Stop loading on error
        return;
      }

      // We call the save method with ALL the data, including
      // the email and phoneNo that were passed to this screen.
      await AuthMethods().saveRecruiterPersonalDetails(
        uid: user.uid,
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        dob: _dob.text.trim(),
        gender: selectedGender,
        state: selectedState!,
        city: selectedCity!,
        email: widget.email,      // Use the email passed to the widget
        phoneNo: widget.phoneNo,  // Use the phone number passed to the widget
      );

      // This part is correct
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RecruiterHome()),
        (route) => false,
      );
    } catch (e) {
      showSnackBar("Error: ${e.toString()}", context);
    } finally {
      // This will run even if there's an error, which is good.
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
  // --- ^^^^^^^^ THIS FUNCTION IS THE MAIN FIX ^^^^^^^^ ---

  @override
  Widget build(BuildContext context) {
    List<String> cityList =
        selectedState != null ? stateCityMap[selectedState!] ?? [] : [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Recruiter Personal Details",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel("First Name *"),
              TextFieldInput(
                textEditingController: _firstName,
                hintText: 'Enter First Name',
                textInputType: TextInputType.name,
              ),
              if (showFirstNameError) _buildErrorText("First name is required"),
              const SizedBox(height: 16),

              _buildFieldLabel("Last Name *"),
              TextFieldInput(
                textEditingController: _lastName,
                hintText: 'Enter Last Name',
                textInputType: TextInputType.name,
              ),
              if (showLastNameError) _buildErrorText("Last name is required"),
              const SizedBox(height: 16),

              _buildFieldLabel("Date of Birth"),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: TextFieldInput(
                    textEditingController: _dob,
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
                        onPressed: () => setState(() {
                          selectedGender = gender;
                          showGenderError = false;
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.deepPurple
                              : Colors.deepPurple[100],
                          foregroundColor:
                              isSelected ? Colors.white : Colors.deepPurple,
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
                selectedItem: selectedState,
                onChanged: (value) {
                  setState(() {
                    selectedState = value;
                    selectedCity = null;
                    showStateError = false;
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "Select State",
                    border: OutlineInputBorder(),
                  ),
                ),
                popupProps: const PopupProps.menu(showSearchBox: true),
              ),
              if (showStateError) _buildErrorText("State is required"),
              const SizedBox(height: 16),

              _buildFieldLabel("City *"),
              DropdownSearch<String>(
                items: cityList,
                selectedItem: selectedCity,
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                    showCityError = false;
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "Select City",
                    border: OutlineInputBorder(),
                  ),
                ),
                popupProps: const PopupProps.menu(showSearchBox: true),
              ),
              if (showCityError) _buildErrorText("City is required"),
              const SizedBox(height: 30),

              GestureDetector(
                onTap: isLoading ? null : _validateAndSubmit,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isLoading ? Colors.grey : backgroundColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit",
                          style:
                              TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500));
  }

  Widget _buildErrorText(String msg) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(msg, style: const TextStyle(color: Colors.red)),
    );
  }
}