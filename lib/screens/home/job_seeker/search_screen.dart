import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:careers/utils/colors.dart';
import 'package:careers/screens/home/job_seeker/job_list_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  List<String> allKeywords = [];
  List<String> allLocations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
  }

  Future<void> fetchDropdownData() async {
    final snapshot = await FirebaseFirestore.instance.collection('jobs').get();

    final Set<String> keywords = {};
    final Set<String> locations = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();

      if (data.containsKey('keywords')) {
        List<dynamic> jobKeywords = data['keywords'];
        keywords.addAll(jobKeywords.map((e) => e.toString().trim()));
      }

      if (data.containsKey('location')) {
        final location = data['location'];
        if (location != null) {
          locations.add(location.toString().trim());
        }
      }
    }

    setState(() {
      allKeywords = keywords.toList()..sort();
      allLocations = locations.toList()..sort();
      isLoading = false;
    });
  }

  void onSearch() {
    final keyword = _searchController.text.trim();
    final location = _locationController.text.trim();

    if (keyword.isEmpty && location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least a job keyword or location')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobListScreen(
          keyword: keyword.isEmpty ? null : keyword,
          location: location.isEmpty ? null : location,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 1,
        iconTheme: const IconThemeData(color: backgroundColor),
        centerTitle: true,
        title: const Text(
          'Search Jobs',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find your dream job!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownSearch<String>(
                    items: allKeywords,
                    selectedItem: _searchController.text.isEmpty ? null : _searchController.text,
                    onChanged: (val) => setState(() {
                      _searchController.text = val?.trim() ?? '';
                    }),
                    filterFn: (item, filter) => item.toLowerCase().contains(filter.toLowerCase()),
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      itemBuilder: (context, item, isSelected) => ListTile(title: Text(item)),
                      emptyBuilder: (context, searchEntry) {
                        return searchEntry.isEmpty
                            ? const SizedBox.shrink()
                            : const Center(child: Text('No data found'));
                      },
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: 'Search by job, company or skills',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderSide: BorderSide(color: backgroundColor)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: backgroundColor)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: backgroundColor, width: 2)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownSearch<String>(
                    items: allLocations,
                    selectedItem: _locationController.text.isEmpty ? null : _locationController.text,
                    onChanged: (val) => setState(() {
                      _locationController.text = val?.trim() ?? '';
                    }),
                    filterFn: (item, filter) => item.toLowerCase().contains(filter.toLowerCase()),
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      itemBuilder: (context, item, isSelected) => ListTile(title: Text(item)),
                      emptyBuilder: (context, searchEntry) {
                        return searchEntry.isEmpty
                            ? const SizedBox.shrink()
                            : const Center(child: Text('No data found'));
                      },
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: 'Location',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderSide: BorderSide(color: backgroundColor)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: backgroundColor)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: backgroundColor, width: 2)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onSearch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text('Search Jobs', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
