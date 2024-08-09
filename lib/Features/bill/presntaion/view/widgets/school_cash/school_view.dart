import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/school_cash/widgets/school_list.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'dart:convert';

import 'data/api_school.dart';
import 'data/school_model.dart';

class SchoolListScreen extends StatefulWidget {
  final String type;

  const SchoolListScreen({required this.type});
  @override
  _SchoolListScreenState createState() => _SchoolListScreenState();
}

class _SchoolListScreenState extends State<SchoolListScreen> {
  List<School> schools = [];
  List<School> filteredSchools = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSchools();
  }

  void _filterSchools(String query) {
    setState(() {
      filteredSchools = schools.where((school) {
        final nameEn = school.nameEn.toLowerCase();
        final nameAr = school.nameAr.toLowerCase();
        final searchQuery = query.toLowerCase();
        return nameEn.contains(searchQuery) || nameAr.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _fetchSchools() async {
    try {
      final List<School> fetchedSchools = await SchoolApi.fetchSchools();
      if (mounted) {
        setState(() {
          schools = fetchedSchools;
          filteredSchools = fetchedSchools;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching schools: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).schoolList,
            style: Styles.textStyle20.copyWith(color: Colors.white),
          ),
          backgroundColor: kBlueLightColor,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: S.of(context).searchByName,
                  labelStyle: Styles.textStyle12,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: _filterSchools,
              ),
            ),
            isLoading
                ? const Center(
                    child: SpinKitSpinningLines(
                      size: 35,
                      color: hBackgroundColor,
                    ),
                  )
                : filteredSchools.isNotEmpty
                    ? Expanded(
                        child: FadeInDown(
                          duration: const Duration(milliseconds: 500),
                          child: ListView.builder(
                            itemCount: filteredSchools.length,
                            itemBuilder: (context, index) {
                              final school = filteredSchools[index];
                              return SchoolListItem(
                                school: school,
                                type: widget.type,
                              );
                            },
                          ),
                        ),
                      )
                    : Center(
                        child: Text(S.of(context).noSchoolsFound),
                      ),
          ],
        ));
  }
}
