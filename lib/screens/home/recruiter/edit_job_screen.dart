import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:careers/widgets/text_field_input.dart';
import 'package:careers/utils/colors.dart';
import 'package:careers/utils/dropdown_data.dart';

class EditJobScreen extends StatefulWidget {
  final String jobId;
  final Map<String, dynamic> jobData;

  const EditJobScreen({Key? key, required this.jobId, required this.jobData}) : super(key: key);

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  late TextEditingController _title;
  late TextEditingController _company;
  late TextEditingController _stipend;
  late TextEditingController _companyDesc;
  late TextEditingController _roleOverview;
  late TextEditingController _roleDesc;
  late TextEditingController _qualifications;
  late String? selectedIndustry;
  late String? selectedField;
  late List<String> selectedSkills;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final data = widget.jobData;
    _title = TextEditingController(text: data['title']);
    _company = TextEditingController(text: data['company']);
    _stipend = TextEditingController(text: data['stipend']);
    _companyDesc = TextEditingController(text: data['companyDescription']);
    _roleOverview = TextEditingController(text: data['roleOverview']);
    _roleDesc = TextEditingController(text: data['roleDescription']);
    _qualifications = TextEditingController(text: data['qualifications']);
    selectedIndustry = data['industry'];
    selectedField = data['field'];
    selectedSkills = List<String>.from(data['skills'] ?? []);
  }

  Future<void> saveChanges() async {
    setState(() => isSaving = true);
    final updatedData = {
      'title': _title.text.trim(),
      'company': _company.text.trim(),
      'stipend': _stipend.text.trim(),
      'companyDescription': _companyDesc.text.trim(),
      'roleOverview': _roleOverview.text.trim(),
      'roleDescription': _roleDesc.text.trim(),
      'qualifications': _qualifications.text.trim(),
      'industry': selectedIndustry ?? '',
      'field': selectedField ?? '',
      'skills': selectedSkills,
    };

    await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).update(updatedData);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job updated')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> fields = selectedIndustry != null ? fieldMap[selectedIndustry!] ?? [] : [];
    List<String> skills = selectedField != null ? skillsMap[selectedField!] ?? [] : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Job', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextFieldInput(textEditingController: _title, hintText: 'Job Title', textInputType: TextInputType.text),
          const SizedBox(height: 12),
          TextFieldInput(textEditingController: _company, hintText: 'Company Name', textInputType: TextInputType.text),
          const SizedBox(height: 12),
          TextFieldInput(textEditingController: _stipend, hintText: 'Stipend', textInputType: TextInputType.text),
          const SizedBox(height: 12),
          DropdownSearch<String>(
            items: industryOptions,
            selectedItem: selectedIndustry,
            onChanged: (val) => setState(() {
              selectedIndustry = val;
              selectedField = null;
              selectedSkills = [];
            }),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(border: OutlineInputBorder(), hintText: "Select Industry"),
            ),
          ),
          const SizedBox(height: 12),
          DropdownSearch<String>(
            items: fields,
            selectedItem: selectedField,
            onChanged: (val) => setState(() {
              selectedField = val;
              selectedSkills = [];
            }),
            enabled: selectedIndustry != null,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(border: OutlineInputBorder(), hintText: "Select Field"),
            ),
          ),
          const SizedBox(height: 12),
          DropdownSearch<String>.multiSelection(
            items: skills,
            selectedItems: selectedSkills,
            onChanged: (val) => setState(() => selectedSkills = val),
            enabled: selectedField != null,
            popupProps: const PopupPropsMultiSelection.menu(showSearchBox: true),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(border: OutlineInputBorder(), hintText: "Select Skills"),
            ),
          ),
          const SizedBox(height: 12),
          TextFieldInput(textEditingController: _companyDesc, hintText: 'Company Description', textInputType: TextInputType.multiline),
          const SizedBox(height: 12),
          TextFieldInput(textEditingController: _roleOverview, hintText: 'Role Overview', textInputType: TextInputType.multiline),
          const SizedBox(height: 12),
          TextFieldInput(textEditingController: _roleDesc, hintText: 'Role Description', textInputType: TextInputType.multiline),
          const SizedBox(height: 12),
          TextFieldInput(textEditingController: _qualifications, hintText: 'Qualifications', textInputType: TextInputType.multiline),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isSaving ? null : saveChanges,
            style: ElevatedButton.styleFrom(backgroundColor: backgroundColor, padding: const EdgeInsets.all(14)),
            child: isSaving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ]),
      ),
    );
  }
}
