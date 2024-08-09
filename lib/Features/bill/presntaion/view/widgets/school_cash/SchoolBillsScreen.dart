import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/school_cash/widgets/bill_list.dart';
import 'package:shamseenfactory/Features/bill/utils.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'widgets/pdf_create.dart';

class SchoolBillsScreen extends StatefulWidget {
  final int schoolId; // Pass the school ID to this screen
  final String name;
  final String type;
  SchoolBillsScreen(
      {required this.schoolId, required this.name, required this.type});

  @override
  State<SchoolBillsScreen> createState() => _SchoolBillsScreenState();
}

class _SchoolBillsScreenState extends State<SchoolBillsScreen> {
  List<Map<String, dynamic>> bills = [];
  DateTime _selectedOneDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _selectedTowDate = DateTime.now();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchBills(_selectedOneDate, _selectedTowDate);
  }

  Future<void> _showDateConflictDialog(
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

  Future<void> _fetchBills(DateTime startDate, DateTime endDate) async {
    var formattedFdDate = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    var formattedEdDate = DateFormat('yyyy-MM-dd', 'en').format(endDate);
    if (startDate.isAfter(endDate)) {
      _showDateConflictDialog(
          context, S.of(context).startAfterEnd); // Start day is after end day
      return;
    }
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bill/total/get-all/${widget.schoolId}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "start": DateFormat('yyyy-MM-dd', 'en').format(startDate),
          "end": DateFormat('yyyy-MM-dd', 'en').format(endDate),
          "type": widget.type
        }),
      );
      print(json.encode({
        "start": DateFormat('yyyy-MM-dd', 'en').format(startDate),
        "end": DateFormat('yyyy-MM-dd', 'en').format(endDate),
        "type": widget.type
      }));
      print(widget.type);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        if (mounted) {
          setState(() {
            bills = List<Map<String, dynamic>>.from(data);
            // Set isLoading to false when the API call is successful
            isLoading = false;
          });
        }
      } else {
        print('Failed to fetch bills: ${response.reasonPhrase}');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching bills: $e');
    }
  }

  Future<void> generateExcel(
      List<Map<String, dynamic>> data, double totalprice) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Headers
    sheet.appendRow([
      'التاريخ',
      'الكمية',
      'السعر',
    ]);

    // Data
    for (final categoryDetail in data) {
      sheet.appendRow([
        categoryDetail['date'].toString().substring(0, 10),
        categoryDetail['total_quantity'].toString(),
        categoryDetail['total'].toString(),
      ]);
    }
    sheet.appendRow(['المبلغ الكلي', totalprice.toString()]);

    final fileBytes = excel.encode();
    final appDocDir = await getApplicationSupportDirectory();
    final excelPath = '${appDocDir.path}/category_report.xlsx';
    final excelFile = File(excelPath);
    await excelFile.writeAsBytes(fileBytes!);
    final result = OpenFile.open(excelPath);

    // Display or use the generated Excel file as needed
    print('Excel file generated and saved to: $excelPath');
  }

  Future<void> _selectTowDate(BuildContext context) async {
    final DateTime? picked =
        await DateSelect.selectDate(context, _selectedTowDate);
    if (picked != null && picked != _selectedTowDate) {
      setState(() {
        _selectedTowDate = picked;
        _fetchBills(_selectedOneDate, _selectedTowDate);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await DateSelect.selectDate(context, _selectedOneDate);
    if (picked != null && picked != _selectedOneDate) {
      setState(() {
        _selectedOneDate = picked;
      });
    }
  }

  double calculateTotalPrice(List<Map<String, dynamic>> categories) {
    double total = 0.0;
    for (final category in categories) {
      final num totalPriceInt = category['total'];
      final double totalPrice =
          totalPriceInt.toDouble(); // Convert to double if needed
      total += totalPrice;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = calculateTotalPrice(bills);
    PdfGenerator pdfGenerator = PdfGenerator(
      categories: bills,
      totalPrice: totalPrice,
      name: widget.name,
      selectedOneDate: _selectedOneDate,
      selectedTowDate: _selectedTowDate,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueLightColor,
        title: Text(
          S.of(context).schoolBills,
          style: Styles.textStyle20.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          DateContainer(
            context: context,
            label: S.of(context).startDate,
            dateText: DateFormat('yyyy-MM-dd', 'en').format(_selectedOneDate),
            onPressed: () => _selectDate(context),
          ),
          const SizedBox(
            height: 5,
          ),
          DateContainer(
            context: context,
            label: S.of(context).endDate,
            dateText: DateFormat('yyyy-MM-dd', 'en').format(_selectedTowDate),
            onPressed: () => _selectTowDate(context),
          ),
          const SizedBox(
            height: 5,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Call fetchCategoryDetails  with selected dates when the button is pressed
                _fetchBills(_selectedOneDate, _selectedTowDate);
              },
              child: Text(S.of(context).fetchData, style: Styles.textStyle14),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (bills.isNotEmpty) {
                    generateExcel(bills, totalPrice);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          S.of(context).noData,
                          style: Styles.titleDialog,
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Text(
                      S.of(context).generateExcelFile,
                      style: Styles.textStyle14,
                    ),
                    Image.asset(
                      'assets/images/excel.png',
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
                onPressed: () async {
                  if (pdfGenerator.categories.isNotEmpty) {
                    await pdfGenerator.generateAndShowCategoryPDF();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          S.of(context).noData,
                          style: Styles.titleDialog,
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Text(S.of(context).generatePdf, style: Styles.textStyle14),
                    Image.asset(
                      'assets/images/pdf.png',
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
          if (isLoading)
            const SpinKitSpinningLines(
              size: 35,
              color: hBackgroundColor,
            )
          else
            Expanded(
              child: BillListView(bills: bills, context: context),
            ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${S.of(context).totalPrice}: ${totalPrice.toStringAsFixed(2)}', // Use your calculated total price here
              style: Styles.textStyle16,
            ),
          ),
        ],
      ),
    );
  }
}

//  pdfWidgets.Page(

//         build: (context) {
//           return pdfWidgets.Column(
//             crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
//             children: [
//               pdfWidgets.Text(
//                 'حساب مدرسة : ${widget.name}',
//                 style: pdfWidgets.TextStyle(
//                     fontSize: 18, font: pdfWidgets.Font.ttf(ttfBold)),
//               ),
//               pdfWidgets.Text("$s1--$s2"),
//               pdfWidgets.SizedBox(height: 20),
//               pdfWidgets.Table.fromTextArray(
//                 context: context,
//                 headers: tableHeaders,
//                 headerStyle: pdfWidgets.TextStyle(
//                   font: pdfWidgets.Font.ttf(ttfBold),
//                 ),
//                 data: tableData,
//                 cellStyle: pdfWidgets.TextStyle(
//                   font: pdfWidgets.Font.ttf(ttfBold),
//                 ),
//                 border: pdfWidgets.TableBorder.all(width: 1),
//                 cellAlignment: pdfWidgets.Alignment.center,
//                 cellHeight: 30,
//                 cellAlignments: {
//                   0: pdfWidgets.Alignment.centerLeft,
//                   1: pdfWidgets.Alignment.center,
//                   2: pdfWidgets.Alignment.center,
//                 },
//               ),
//               pdfWidgets.Text(
//                 'المجموع الكلي :$totalPrice', // Display the calculated total price
//                 style: pdfWidgets.TextStyle(
//                   fontSize: 16,
//                   font: pdfWidgets.Font.ttf(ttfBold),
//                 ),
//                 textDirection: pdfWidgets.TextDirection.rtl,
//               ),
//             ],
//           );
//         },
//       ),