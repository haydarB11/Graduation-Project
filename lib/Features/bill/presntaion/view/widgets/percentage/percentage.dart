import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:shamseenfactory/Features/bill/utils.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../school bill/widgets/loading_snackbar.dart';
import 'data/percentage_model.dart';
import 'widgets/excel.dart';
import 'widgets/pdf.dart';

class percentage extends StatefulWidget {
  final String type;
  const percentage({super.key, required this.type});

  @override
  State<percentage> createState() => _percentageState();
}

class _percentageState extends State<percentage> {
//*varibles
  DateTime startDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime endDate = DateTime.now();
  List<School>? schools;
  Future<List<School>>? _fetchSchoolsFuture;
  final ExcelGenerator excelGenerator = ExcelGenerator();
  @override
  void initState() {
    super.initState();

    _fetchSchoolsFuture = fetchSchools(startDate, endDate);
  }

//!method

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await DateSelect.selectDate(context, startDate);
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await DateSelect.selectDate(context, endDate);
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  Future<List<School>> fetchSchools(
      DateTime startDate, DateTime endDate) async {
    final url = Uri.parse('$baseUrl/bill/balance/get-all');
    final formattedStartDate = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    final formattedEndDate = DateFormat('yyyy-MM-dd', 'en').format(endDate);
    if (endDate.isBefore(startDate)) {
      // Show an error dialog and return an empty list
      DialogHelper.showDateConflictDialog(context, S.of(context).startAfterEnd);
      (context);
      return [];
    }
    if (kDebugMode) {
      print('API Request Date: $formattedStartDate - $formattedEndDate');
    }

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'start': formattedStartDate,
          'end': formattedEndDate,
          'type': widget.type
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (kDebugMode) {
        print('API Response Status Code: ${response.statusCode}');
        print(
          jsonEncode({
            'start': formattedStartDate,
            'end': formattedEndDate,
            'type': widget.type
          }),
        );
      }

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            final List<dynamic> jsonData = json.decode(response.body)['data'];
            schools =
                jsonData.map((school) => School.fromJson(school)).toList();
          });
        }

        // Debug: Print the school list
        print('School List:');
        for (final school in schools!) {
          print('Name: ${school.nameEn}');
          // Print other relevant fields

          if (school.sellPoints != null && school.sellPoints.isNotEmpty) {
            // Access properties of the 'sellPoints' array here
            for (final sellPoint in school.sellPoints) {
              if (kDebugMode) {
                print('Driver: ${sellPoint.driver.nameEn}');
                print('Promoter: ${sellPoint.promoter.nameEn}');
              }

              // Access other properties of 'sellPoint'
            }
          } else {
            // Handle the case where 'sellPoints' is null or empty
            if (kDebugMode) {
              print('No sell points available for this school.');
            }
          }
        }

        return schools!;
      } else {
        if (kDebugMode) {
          print('API Error: Failed to fetch schools');
        }

        throw Exception('Failed to fetch schools');
      }
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e');
      }

      throw Exception('Failed to fetch schools');
    }
  }

  Future<void> generateExcelFile(List<School> schools) async {
    try {
      // Call generateAllSchoolsExcel and provide the required parameters (schools, startDate)
      await excelGenerator.generateAllSchoolsExcel(schools, startDate);

      // Handle any additional actions after generating the Excel file if needed
    } catch (error) {
      // Handle errors here
      print('Error generating Excel: $error');
    }
  }

  Future<void> _generateAllSchoolsPdf() async {
    // Show the loading snackbar with a small delay
    LoadingSnackbar.show(context);

    // Introduce a delay before starting PDF generation
    await Future.delayed(Duration(milliseconds: 200));

    try {
      final pdfGenerator = PdfGenerator();
      final pdfBytes =
          await pdfGenerator.generatePdfReport(schools!, startDate, endDate);

      // Save or display the PDF here if needed

      // Hide the snackbar
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } catch (error) {
      // Handle any errors during PDF generation
      print('Error generating PDF: $error');

      // Hide the snackbar
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).percentage,
          style: Styles.textStyle20.copyWith(color: Colors.white),
        ),
        backgroundColor: kBlueLightColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DateContainer(
              context: context,
              label: S.of(context).startDate,
              dateText: DateFormat('yyyy-MM-dd', 'en').format(startDate),
              onPressed: () => _selectStartDate(context),
            ),
            const SizedBox(
              height: 10,
            ),
            DateContainer(
              context: context,
              label: S.of(context).endDate,
              dateText: DateFormat('yyyy-MM-dd', 'en').format(endDate),
              onPressed: () => _selectEndDate(context),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _fetchSchoolsFuture = fetchSchools(startDate, endDate);
                  });
                },
                child: Text(
                  S.of(context).fetchData,
                  style: Styles.textStyle16,
                )),
            const SizedBox(
              height: 15,
            ),
            FutureBuilder<List<School>>(
                // Replace with your actual data-fetching future
                future: _fetchSchoolsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Display a loading indicator while waiting for data
                    return const SpinKitSpinningLines(
                      size: 35,
                      color: hBackgroundColor,
                    );
                  } else if (snapshot.hasError) {
                    // Display an error message if an error occurred
                    return Text(
                      'Error: ${snapshot.error}',
                      style: Styles.textStyle14,
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Display a message when there is no data
                    return Text(
                      S.of(context).noData,
                      style: Styles.textStyle18,
                    );
                  } else {
                    // Display your data when it's available
                    final schools = snapshot.data;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (schools!.isNotEmpty) {
                              _generateAllSchoolsPdf();
                            }
                          },
                          child: Row(
                            children: [
                              Text(S.of(context).generatePdf,
                                  style: Styles.textStyle14),
                              Image.asset(
                                'assets/images/pdf.png',
                                width: 20,
                                height: 20,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (schools!.isNotEmpty) {
                              generateExcelFile(schools);
                            }
                          },
                          child: Row(
                            children: [
                              Text(S.of(context).generateExcelFile,
                                  style: Styles.textStyle14),
                              Image.asset(
                                'assets/images/excel.png',
                                width: 20,
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}

class DialogHelper {
  static Future<void> showDateConflictDialog(
      BuildContext context, String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog won't dismiss when tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).dateConflict),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).ok),
            ),
          ],
        );
      },
    );
  }
}
