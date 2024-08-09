import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

import '../model.dart';
import '../school_card.dart';

class SchoolViewToEx extends StatefulWidget {
  final String type;
  const SchoolViewToEx({super.key, required this.type});

  @override
  State<SchoolViewToEx> createState() => _SchoolViewToExState();
}

class _SchoolViewToExState extends State<SchoolViewToEx> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is initialized
    fetchAllSchool();
  }

  List<School> allSchool = [];
  List<School> filteredSchools = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  Future<void> fetchAllSchool() async {
    try {
      final data = await SchoolsApi.getAllSchools();
      if (mounted) {
        setState(() {
          allSchool = data;
          filteredSchools = allSchool;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print(e);
    }
  }

  void filterSchools(String query) {
    setState(() {
      filteredSchools = allSchool
          .where((school) =>
              (school.nameAr?.toLowerCase().contains(query.toLowerCase()) ??
                  false))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(S.of(context).schoolList, style: Styles.textStyle18),
      ),
      body: Container(
        decoration: const BoxDecoration(color: hBackgroundColor),
        child: Column(
          children: [

            TextField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: searchController,
              onChanged: filterSchools,
              decoration: InputDecoration(
                labelText: S.of(context).searchSellPoints,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            Expanded(
              child: Center(
                child: isLoading
                    ? const SpinKitFoldingCube(
                        color: Colors.white,
                        size: 35,
                      ) // Show loading indicator
                    : filteredSchools.isEmpty
                        ? Text(S
                            .of(context)
                            .noSchoolsFound) // Show message when no data is available
                        : ListView.builder(
                            itemCount: filteredSchools.length,
                            itemBuilder: (context, index) {
                              final schoolData = filteredSchools[index];
                              return SchoolCard(
                                schoolId: schoolData.id,
                                schoolArName: schoolData.nameAr ?? 'N/A',
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
