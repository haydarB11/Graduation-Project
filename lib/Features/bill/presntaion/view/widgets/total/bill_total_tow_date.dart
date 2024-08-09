import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

// Assuming you've defined the CategoryTotal class here

class TotalTowdateScreen extends StatefulWidget {
  final String type;
  TotalTowdateScreen({required this.type});
  @override
  _TotalScreenState createState() => _TotalScreenState();
}

class _TotalScreenState extends State<TotalTowdateScreen> {
  List<CategoryTotal> categoryTotals = [];
  bool isLoading = false;

  DateTime _selectedOneDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _selectedTowDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchCategoryTotals(_selectedOneDate, _selectedTowDate);
    print("this type ${widget.type}");
    // print(_selectedTowDate);
  }

  int calculateTotalPrice() {
    return categoryTotals.fold(
        0, (sum, total) => sum + total.totalPrice.toInt());
  }

  Future<void> generatePDF(List<CategoryTotal> categoryTotals) async {
    DateFormat('yyyy-MM-dd', 'en').format(_selectedOneDate);
    DateFormat('yyyy-MM-dd', 'en').format(_selectedTowDate);

    // textDirection: pw.TextDirection.rtl,
    final pdf = pw.Document();
    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20.0),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('SHAMSEEN FOODSTUFF CATERING',
                  style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      font: pw.Font.ttf(ttfBold))),
              pw.Text('شمسين لخدمات التموين بالموادالغذائية',
                  style: pw.TextStyle(fontSize: 16, font: pw.Font.ttf(ttfBold)),
                  textDirection: pw.TextDirection.rtl),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Phone: 065384357',
                  style: const pw.TextStyle(fontSize: 14)),
              pw.Text('Fax: 065384357',
                  style: const pw.TextStyle(fontSize: 14)),
              pw.Text('TRN: 100334461900003',
                  style: const pw.TextStyle(fontSize: 14)),
            ],
          ),
          pw.SizedBox(height: 10),
          // Title
          pw.Header(level: 0, text: 'Category Totals'),
          pw.SizedBox(height: 10),
          pw.Text(
              "Total "
              'Date:${DateFormat('yyyy-MM-dd', 'en').format(_selectedOneDate)} - ${DateFormat('yyyy-MM-dd', 'en').format(_selectedTowDate)}',
              style: pw.TextStyle(fontSize: 14, font: pw.Font.ttf(ttfBold))),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, font: pw.Font.ttf(ttfBold)),
            headerDecoration: const pw.BoxDecoration(
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
              color: PdfColors.grey300,
            ),
            cellStyle: pw.TextStyle(
              font: pw.Font.ttf(ttfBold),
            ),
            data: <List<String>>[
              <String>['الصنف', 'العدد', 'السعر الكلي'],
              ...categoryTotals.map((total) => [
                    total.nameAr, // Change this to the appropriate field
                    total.count.toString(),
                    total.totalPrice.toString(),
                  ]),
            ],
          ),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                'Total:',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, color: PdfColors.red),
              ),
              pw.Text(
                  categoryTotals
                      .fold(0, (sum, total) => sum + total.totalPrice.toInt())
                      .toString(),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  )),
            ],
          ),
          pw.Divider(height: 2, color: PdfColors.grey),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                'Total Quantity: ',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, color: PdfColors.red),
              ),
              pw.Text(
                  categoryTotals
                      .fold(0, (sum, total) => sum + total.count)
                      .toString(),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  )),
            ],
          ),
          pw.Divider(height: 2, color: PdfColors.grey),
        ],
      ),
    );
    final pdfBytes = await pdf.save();
    final appDocDir = await getApplicationSupportDirectory();
    final pdfPath =
        '${appDocDir.path}/totalcategory_between_$_selectedOneDate-$_selectedTowDate.pdf';
    print(pdfPath);
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);
    final result = OpenFile.open(pdfPath);
  }

  Future<void> generateExcel(List<CategoryTotal> categoryTotals) async {
    // Step 1: Create a new Excel document
    final excel = Excel.createExcel();

    // Step 2: Access the first sheet in the Excel document
    final sheet = excel['Sheet1'];

    // Step 3: Define headers for the Excel sheet
    sheet.appendRow(['Category', 'Count', 'Total Price']);

    // Step 4: Add data rows to the Excel sheet
    for (var total in categoryTotals) {
      // Create a new row with data from the CategoryTotal object
      List<String> rowData = [
        total.nameAr, // 'Category' column
        total.count.toString(), // 'Count' column
        total.totalPrice.toString(), // 'Total Price' column
      ];

      // Append the row to the Excel sheet
      sheet.appendRow(rowData);
    }

    // Step 5: Calculate the total sum of 'Total Price' column
    int totalSum = 0;
    for (var total in categoryTotals) {
      totalSum += total.totalPrice.toInt();
    }

    // Step 6: Add the total sum to the Excel sheet as a new row
    sheet.appendRow(['Total:', '', totalSum.toString()]);

    // Step 7: Save the Excel file to the device's storage
    final fileBytes = excel.encode();
    final appDocDir = await getApplicationSupportDirectory();
    final excelPath = '${appDocDir.path}/my_excel.xlsx';
    final excelFile = File(excelPath);
    await excelFile.writeAsBytes(fileBytes!);

    // Step 8: Open the generated Excel file for viewing
    final result = OpenFile.open(excelPath);
  }

  Future<void> fetchCategoryTotals(DateTime startDate, DateTime endDate) async {
    print("B$startDate");
    print(endDate);
    print(startDate);
    var formattedFdDate = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    var formattedEdDate = DateFormat('yyyy-MM-dd', 'en').format(endDate);
    if (startDate.isAfter(endDate)) {
      _showDateConflictDialog(
          context, S.of(context).startAfterEnd); // Start day is after end day
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });

      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse('$baseUrl/bill/total/get-all'));

      request.headers.addAll(headers);
      var formattedFDate = DateFormat('yyyy-MM-dd', 'en').format(startDate);
      var formattedSDate = DateFormat('yyyy-MM-dd', 'en').format(endDate);
      // Format the selectedDate
      print("one$formattedFDate");
      print("Tow$formattedSDate");
      request.body = json.encode({
        'start': formattedFDate,
        "end": formattedSDate,
        'type': widget.type
      });
      print("${request.body} \n the body is ${request.body}");
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonData = json.decode(responseBody);

        List<CategoryTotal> totals = [];
        for (var item in jsonData['data']) {
          totals.add(CategoryTotal.fromJson(item));
        }
        if (mounted) {
          setState(() {
            categoryTotals = totals;
            isLoading = false;
          });
        }
      } else {
        print(response.reasonPhrase);
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Failed to fetch data. ${response.reasonPhrase}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      // Handle general error (e.g., network connectivity issues)
      if (e is SocketException) {
        // Handle network error
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Network Error'),
              content: Text('Network error: ${e.message}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // Handle other errors (e.g., unexpected exceptions)
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred: $e'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  Future<void> _selectTowDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTowDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedTowDate) {
      setState(() {
        _selectedTowDate = picked;
        // fetchCategoryTotals(_selectedOneDate, _selectedTowDate);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedOneDate) {
      setState(() {
        _selectedOneDate = picked;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueLightColor,
        title: Text(
          S.of(context).total,
          style: Styles.textStyle20.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateContainer(
                    S.of(context).startDate,
                    DateFormat('yyyy-MM-dd', 'en').format(_selectedOneDate),
                    () => _selectDate(context),
                  ),
                  SizedBox(height: 16.0),
                  _buildDateContainer(
                    S.of(context).endDate,
                    DateFormat('yyyy-MM-dd', 'en').format(_selectedTowDate),
                    () => _selectTowDate(context),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () =>
                    fetchCategoryTotals(_selectedOneDate, _selectedTowDate),
                child:
                    Text(S.of(context).fetchBills, style: Styles.textStyle14),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (categoryTotals.isNotEmpty) {
                            generatePDF(categoryTotals);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  title: Text(
                                S.of(context).noData,
                                style: Styles.titleDialog,
                              )),
                            );
                          }
                        },
                        // style: ElevatedButton.styleFrom(
                        //   backgroundColor: kActiveIconColor,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: 20, vertical: 10),
                        // ),
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
                          if (categoryTotals.isNotEmpty) {
                            generateExcel(categoryTotals);
                          }
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                title: Text(
                              S.of(context).noData,
                              style: Styles.titleDialog,
                            )),
                          );
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
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? Center(
                    child: FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: const Center(
                        child: SpinKitSpinningLines(
                          size: 35,
                          color: hBackgroundColor,
                        ),
                      ),
                    ),
                  )
                : categoryTotals.isEmpty
                    ? Center(
                        child: Text(
                          S.of(context).noData,
                          style: Styles.textStyle20,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).categoryTotals,
                              style: Styles.textStyle20.copyWith(
                                color: kActiveIconColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: categoryTotals.length,
                              itemBuilder: (context, index) {
                                var total = categoryTotals[index];
                                return Column(
                                  children: [
                                    Card(
                                      elevation: 3,
                                      child: ListTile(
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              total.nameAr,
                                              style: Styles.textStyle14,
                                            ),
                                            Text(
                                              total.nameEn,
                                              style: Styles.textStyle14,
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${S.of(context).amount} : ${total.count}',
                                              style: Styles.textStyle14,
                                            ),
                                            Text(
                                              '${S.of(context).totalPrice} : ${total.totalPrice}',
                                              style: Styles.textStyle16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 2,
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  S.of(context).total,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  calculateTotalPrice().toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateContainer(
      String label, String dateText, Function()? onPressed) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.calendar_today),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              SizedBox(height: 4.0),
              Text(
                dateText,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onPressed,
            // style: ElevatedButton.styleFrom(
            //   primary: kActiveIconColor,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            // ),
            child: Text(S.of(context).select,
                style:
                    Styles.textStyle16.copyWith(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, String text, Function()? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      // style: ElevatedButton.styleFrom(
      //   primary: kActiveIconColor,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // ),
      child: Text(
        text,
        style: TextStyle(
          // color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CategoryTotal {
  final int id;
  final String nameAr;
  final String nameEn;
  final int count;
  final num totalPrice;

  CategoryTotal({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.count,
    required this.totalPrice,
  });

  factory CategoryTotal.fromJson(Map<String, dynamic> json) {
    return CategoryTotal(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      count: int.parse(json['count']),
      totalPrice: json['total_price'],
    );
  }
}
