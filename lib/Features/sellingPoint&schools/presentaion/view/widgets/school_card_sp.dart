import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/data/api_server.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/data/school_model.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/sp_and_schools_view.dart';
import 'package:http/http.dart' as http;
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class SchoolCard extends StatefulWidget {
  final School school;
  final VoidCallback refreshSchoolsList; // Callback function
  SchoolCard({required this.school, required this.refreshSchoolsList});

  @override
  State<SchoolCard> createState() => _SchoolCardState();
}

class _SchoolCardState extends State<SchoolCard> {
  int s = 6;
  final _formKey = GlobalKey<FormState>();

  Future<http.Response> updateSchool(
    int schoolId,
    String nameArabic,
    String nameEnglish,
    String type,
    String region,
  ) async {
    final url = Uri.parse('$baseUrl/schools/edit/$schoolId');
    final Map<String, String> headers = {
      'Content-Type': 'application/json', // Specify the content type as JSON
    };

    final Map<String, dynamic> requestBody = {
      'name_ar': nameArabic,
      'name_en': nameEnglish,
      'type': type,
      'region': region,
    };

    final http.Request request = http.Request('PUT', url)
      ..headers.addAll(headers)
      ..body = jsonEncode(requestBody); // Convert the request body to JSON

    final http.StreamedResponse response = await request.send();

    // Read and return the response

    // Read and return the response
    return await http.Response.fromStream(response);
  }

// ...

  Future<void> showEditSchoolDialog(BuildContext context, School school) async {
    final TextEditingController nameArabicController = TextEditingController();
    final TextEditingController nameEnglishController = TextEditingController();
    final TextEditingController regionController = TextEditingController();

// Initialize the text fields with the current values
    nameArabicController.text = school.nameArabic;
    nameEnglishController.text = school.nameEnglish;
    regionController.text = school.region;
    String? selectedType = school.type; // Initialize with the current type

// Check if selectedType is null and assign a default value if needed

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Edit School'),
            content: Form(
              key: _formKey, // Associate the form with the _formKey
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: nameArabicController,
                    decoration: InputDecoration(
                        labelText: S.of(context).nameArabic,
                        labelStyle: Styles.textStyle12),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.of(context).pleaseEnterNameArabic;
                      }
                      return null; // Return null for no validation error
                    },
                  ),
                  TextFormField(
                    controller: nameEnglishController,
                    decoration: InputDecoration(
                        labelText: S.of(context).nameEnglish,
                        labelStyle: Styles.textStyle12),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.of(context).pleaseEnterNameEnglish;
                      }
                      return null; // Return null for no validation error
                    },
                  ),
                  TextFormField(
                    controller: regionController,
                    decoration: InputDecoration(
                        labelText: S.of(context).region,
                        labelStyle: Styles.textStyle12),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.of(context).pleaseEnterRegion;
                      }
                      return null; // Return null for no validation error
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedType ??
                        'school', // Provide a default value if selectedType is null
                    items: [
                      DropdownMenuItem<String>(
                        value: 'school',
                        child: Text(S.of(context).school),
                      ),
                      DropdownMenuItem<String>(
                        value: 'kindergarten',
                        child: Text(S.of(context).kindergarten),
                      ),
                    ],
                    onChanged: (value) {
                      // Update the selected type when the user makes a selection
                      selectedType = value!;
                    },
                    decoration: InputDecoration(
                      labelText: S.of(context).type, // Translate "type"
                      labelStyle: Styles.textStyle12,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  S.of(context).cancel,
                  style: Styles.styleCanselButton,
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await updateSchool(
                      school.id,
                      nameArabicController.text,
                      nameEnglishController.text,
                      selectedType!, // Use the selected type
                      regionController.text,
                    );
                    print(response.statusCode);
                    if (response.statusCode == 200) {
                      // School updated successfully
                      print('School updated successfully');
                      Navigator.of(context).pop();
                      if (mounted) {
                        setState(() {
                          widget.refreshSchoolsList();
                        });
                      }
                    } else {
                      // Handle the error
                      print(
                          'Failed to update school: ${response.reasonPhrase}');
                    }
                  } else {
                    print('hjgjgjg');
                  }
                },
                child: Text(
                  S.of(context).save,
                  style: Styles.styledeleteButton,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(right: 40, left: 10, top: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(deafultpadding),
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 30,
          child: const Icon(Icons.school, color: kBlueColor),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.school.nameEnglish,
              style: Styles.textStyle16,
            ),
            Text(
              widget.school.nameArabic,
              style: Styles.textStyle16,
            ),
          ],
        ),
        subtitle: Text(widget.school.region, style: Styles.textStyle12),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                print(baseUrl);
                showEditSchoolDialog(context, widget.school);
              },
              icon: const Icon(Icons.edit),
              color: Colors.green,
            ),
            IconButton(
              onPressed: () async {
                if (widget.school.sellPoints.isNotEmpty) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        title: Text(
                          S.of(context).mustdeletesell,
                          style: Styles.titleDialog,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              S.of(context).cancel,
                              style: Styles.styleCanselButton,
                            ),
                          )
                        ],
                      );
                    },
                  );
                }
                if (widget.school.sellPoints.isEmpty) {
                  // ignore: use_build_context_synchronously
                  final shouldDelete = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        title: Text(
                          S.of(context).deleteSchool,
                          style: Styles.titleDialog,
                        ),
                        content: Text(S.of(context).areYouSureDeleteSchool,
                            style: Styles.textStyle18),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true); // Delete
                            },
                            child: Text(
                              S.of(context).delete,
                              style: Styles.styledeleteButton,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false); // Don't delete
                            },
                            child: Text(
                              S.of(context).cancel,
                              style: Styles.styleCanselButton,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                  if (shouldDelete == true) {
                    try {
                      await ApiService.deleteSchool(widget.school.id);

                      widget
                          .refreshSchoolsList(); // Trigger the callback to refresh the list

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(S.of(context).schoolDeletedSuccessfully),
                        ),
                      );
                    } catch (error) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).failedToDeleteSchool),
                        ),
                      );
                    }
                  }
                }
              },
              icon: Icon(
                Icons.delete,
                color: Styles.delteIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
