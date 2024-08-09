import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/material%20movement/category_view.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'dart:io';

import '../../../../utils.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryNameAr;
  final String type;
  CategoryDetailsScreen(this.categoryId, this.categoryName, this.categoryNameAr,
      {required this.type});

  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
//* varibels
  List<Map<String, dynamic>> categoryDetailsList = [];
  bool isLoading = false;
  DateTime _selectedOneDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _selectedTowDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchCategoryDetails(_selectedOneDate, _selectedTowDate).then((_) {
      // After fetchCategoryDetails completes, call calex
      calex();
      print(widget.categoryId);
    });
  }

//! Apis
  Future<void> fetchCategoryDetails(
      DateTime startDate, DateTime endDate) async {
    var formattedFdDate = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    var formattedEdDate = DateFormat('yyyy-MM-dd', 'en').format(endDate);
    if (startDate.isAfter(endDate)) {
      _showDateConflictDialog(
          context, S.of(context).startAfterEnd); // Start day is after end day
      return;
    }
    setState(() {
      isLoading = true;
    });
    final headers = {'Content-Type': 'application/json'};

    final request = http.Request(
      'POST',
      Uri.parse('$baseUrl/bill/get-all/category/${widget.categoryId}'),
    );
    print(widget.categoryId);
    request.headers.addAll(headers); // Add custom headers
    request.body = jsonEncode({
      "start": DateFormat('yyyy-MM-dd', 'en').format(startDate),
      "end": DateFormat('yyyy-MM-dd', 'en').format(endDate),
    });
    print(request.body);
    try {
      final response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString())['data'];
        if (responseData.isNotEmpty) {
          final List<Map<String, dynamic>> categoryDetails =
              responseData.values.toList().cast<Map<String, dynamic>>();
          setState(() {
            categoryDetailsList = categoryDetails;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            // Handle the case when no data is found
            categoryDetailsList = [];
          });
        }
      }
    } catch (e) {
      print('Error fetching category details: $e');
      setState(() {
        isLoading = false;
        categoryDetailsList = [];
      });
    }
  }

  //Todo: method
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
        lastDate: DateTime(2100));
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

  Future<void> generateExcelFile(List<Map<String, dynamic>> data) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1']; // Change the sheet name as needed
    sheet.setColAutoFit(0);
    sheet.setColAutoFit(1);

// Add headers to the sheet
    sheet.appendRow([
      'اسم المدرسة',
      "school Name",
      'الكمية',
      'المبلغ الكلي',
      "عدد المرتجعات",
      "السعر الاجمالي للمرتجعات",
      "عدد العينات",
      "السعر الاجمالي للعينات"
    ]);
    // Add data to the

    int totalQuantity = 0;
    double totalPrice = 0.0;

    for (final categoryDetail in data) {
      final countValue = int.tryParse(categoryDetail['count'].toString());

      if (countValue != null) {
        totalQuantity += countValue;
      }

      final categoryTotalPrice =
          double.tryParse(categoryDetail['category_total_price'].toString()) ??
              0.0;
      totalPrice += categoryTotalPrice;
      sheet.appendRow([
        categoryDetail['name_ar'].toString(),
        categoryDetail['name_en'].toString(),
        categoryDetail['count'].toString(),
        categoryDetail['category_total_price'] ?? 0,
        categoryDetail['countReturns'] ?? 0,
        categoryDetail['category_total_price_returns'] ?? 0,
        categoryDetail['countExpenses'] ?? 0,
        categoryDetail['category_total_price_expenses'] ?? 0
      ]);
    }
    sheet.appendRow(['العدد الاجمالي', totalQuantity]);
    sheet.appendRow(['السعر الكلي', totalPrice]);
    sheet.appendRow(['عدد العينات الكلي ', totalExpenseCount]);
    sheet.appendRow(['سعر العينات الكلي ', totalExpensePrice]);
    sheet.appendRow(['عدد المرتجعات الكلي ', totalReturnsCount]);
    sheet.appendRow(['سعر المرتجعات الكلي ', totalReturnsPrice]);
    final fileBytes = excel.encode();
    final appDocDir = await getApplicationSupportDirectory();
    final formattedCategoryName = widget.categoryName.replaceAll(' ', '_');
    final formattedStartDate =
        DateFormat('yyyy-MM-dd', "en").format(_selectedOneDate);
    final formattedEndDate =
        DateFormat('yyyy-MM-dd', "en").format(_selectedTowDate);

    final excelPath =
        '${appDocDir.path}/movement_${formattedCategoryName}_between_${formattedStartDate}_${formattedEndDate}.xlsx';
    final excelFile = File(excelPath);

    await excelFile.writeAsBytes(fileBytes!);

    // Open the Excel fileSS
    final result = OpenFile.open(excelPath);
  }

  Future<void> generatePDF(
    List<Map<String, dynamic>> data,
    String name,
    String namear,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final pdf = pw.Document();
    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');

    final formattedStartDate = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    final formattedEndDate = DateFormat('yyyy-MM-dd', 'en').format(endDate);

    final headers = [
      'الرقم',
      'اسم المدرسة',
      "school Name",
      'الكمية',
      'المبلغ الكلي',
      "عدد المرتجعات",
      "السعر الاجمالي للمرتجعات",
      "عدد العينات",
      "السعر الاجمالي للعينات"
    ];

    // Create a table with all data
    final tableData = data.asMap().entries.map((entry) {
      final index = entry.key + 1; // Adding 1 to start index at 1
      final categoryDetail = entry.value;
      return [
        index.toString(),
        categoryDetail['name_ar'].toString(),
        categoryDetail['name_en'].toString(),
        categoryDetail['count'].toString(),
        categoryDetail['category_total_price'] ?? 0,
        categoryDetail['countReturns'] ?? 0,
        categoryDetail['category_total_price_returns'] ?? 0,
        categoryDetail['countExpenses'] ?? 0,
        categoryDetail['category_total_price_expenses'] ?? 0
      ];
    }).toList();

    final columnWidths = <int, pw.TableColumnWidth>{
      0: const pw.FixedColumnWidth(50), // Index column width
      1: const pw.FixedColumnWidth(200),
      2: const pw.FixedColumnWidth(200),
      3: const pw.FixedColumnWidth(80),
      4: const pw.FixedColumnWidth(80),
      5: const pw.FixedColumnWidth(80),
      6: const pw.FixedColumnWidth(80),
      7: const pw.FixedColumnWidth(80),
    };
    final table = pw.Table.fromTextArray(
        headers: headers,
        data: tableData,
        columnWidths: columnWidths,
        border: pw.TableBorder.all(),
        cellStyle: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
        headerStyle: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            font: pw.Font.ttf(ttfBold)),
        cellPadding: const pw.EdgeInsets.all(2));

    // Calculate the sum of count and total price
    // Calculate the sum of count and total price
    int totalQuantity = 0;
    double totalPrice = 0.0;

    for (final categoryDetail in data) {
      // Use int.tryParse to convert 'count' to an integer
      final countValue = int.tryParse(categoryDetail['count'].toString());

      if (countValue != null) {
        totalQuantity += countValue;
      } else {
        // Handle the case where the 'count' value is not a valid integer
        print('Invalid count value: ${categoryDetail['count']}');
      }

      // Convert the 'category_total_price' to double before adding
      final categoryTotalPrice =
          double.tryParse(categoryDetail['category_total_price'].toString()) ??
              0.0;
      totalPrice += categoryTotalPrice;
    }

    pdf.addPage(pw.MultiPage(
      textDirection: pw.TextDirection.rtl,
      build: (context) => [
        pw.Text(
          'اسم المادة $name  $namear',
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            font: pw.Font.ttf(ttfBold),
          ),
        ),
        pw.Text(
          'تاريخ البدأ: $formattedStartDate',
          style: pw.TextStyle(
            fontSize: 10,
            font: pw.Font.ttf(ttfBold),
          ),
        ),
        pw.Text(
          'تاريخ الانتهاء: $formattedEndDate',
          style: pw.TextStyle(
            fontSize: 10,
            font: pw.Font.ttf(ttfBold),
          ),
        ),
        table,
        pw.SizedBox(height: 6),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(children: [
            pw.Text('الكمية الإجمالية: $totalQuantity',
                style: pw.TextStyle(
                  font: pw.Font.ttf(ttfBold),
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                textDirection: pw.TextDirection.rtl),
            pw.Text('السعر الإجمالي: ${totalPrice.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  font: pw.Font.ttf(ttfBold),
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                textDirection: pw.TextDirection.rtl),
          ]),
          pw.Column(children: [
            pw.Text(
              "عدد العينات الكلي $totalExpenseCount",
              style: pw.TextStyle(
                font: pw.Font.ttf(ttfBold),
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
            ),
            pw.Text(
              "سعر العينات الكلي $totalExpensePrice",
              style: pw.TextStyle(
                font: pw.Font.ttf(ttfBold),
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ]),
          pw.Column(children: [
            pw.Text(
              "عدد المرتجعات الكلي $totalReturnsCount",
              style: pw.TextStyle(
                font: pw.Font.ttf(ttfBold),
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
            ),
            pw.Text(
              "سعر المرتجعات الكلي $totalReturnsPrice",
              style: pw.TextStyle(
                font: pw.Font.ttf(ttfBold),
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ])
        ]),
      ],
    ));
    final pdfBytes = await pdf.save();
    final appDocDir = await getApplicationSupportDirectory();
    final pdfPath =
        '${appDocDir.path}/${widget.categoryName}${formattedStartDate}_$formattedEndDate.pdf';
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);

    final result = await OpenFile.open(pdfPath);
    print('PDF generated and saved to: $pdfPath');
  }

  num totalExpenseCount = 0;
  num totalExpensePrice = 0.0;
  num totalReturnsCount = 0;
  num totalReturnsPrice = 0.0;

  void calex() {
    for (Map<String, dynamic> categoryDetail in categoryDetailsList) {
      // Calculate total expenses

      totalExpenseCount += categoryDetail['countExpenses'] ?? 0;
      totalExpensePrice +=
          categoryDetail['category_total_price_expenses'] ?? 0.0;

      // Calculate total returns
      totalReturnsCount += categoryDetail['countReturns'] ?? 0;
      totalReturnsPrice +=
          categoryDetail['category_total_price_returns'] ?? 0.0;
    }

    print('Total Expense Count: $totalExpenseCount');
    print('Total Expense Price: $totalExpensePrice');
    print('Total Returns Count: $totalReturnsCount'); // Corrected variable name
    print('Total Returns Price: $totalReturnsPrice');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBlueLightColor,
          title: Text(
            S.of(context).categoryDetails,
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
              width: 5,
            ),
            ElevatedButton(
              onPressed: () async {
                // Call fetchCategoryDetails  with selected dates when the button is pressed
                await fetchCategoryDetails(_selectedOneDate, _selectedTowDate);
              },
              child: Text(S.of(context).fetchData, style: Styles.textStyle14),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (categoryDetailsList.isNotEmpty) {
                          generatePDF(
                              categoryDetailsList,
                              widget.categoryName,
                              widget.categoryNameAr,
                              _selectedOneDate,
                              _selectedTowDate);
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

                        print(widget.categoryName);
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
                  ],
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (categoryDetailsList.isNotEmpty) {
                      generateExcelFile(categoryDetailsList);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(S.of(context).noData),
                        ),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Text(S.of(context).generateExcelFile,
                          style: Styles.textStyle14),
                      Image.asset(
                        'assets/images/excel.png', // Replace with the path to your Excel icon
                        width: 20,
                        height: 20,
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            isLoading
                ? const Center(
                    child: SpinKitSpinningLines(
                      size: 35,
                      color: hBackgroundColor,
                    ),
                  )
                : categoryDetailsList.isNotEmpty
                    ? Expanded(
                        child: FadeInDown(
                          duration: const Duration(milliseconds: 500),
                          child: ListView.builder(
                            itemCount: categoryDetailsList.length,
                            itemBuilder: (context, index) {
                              final categoryDetail = categoryDetailsList[index];
                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: DetailRow(
                                      label: S.of(context).schoolName,
                                      value: categoryDetail['name_ar'] ?? ""),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DetailRow(
                                          label: S.of(context).totalQuantity,
                                          value:
                                              categoryDetail['count'] ?? " "),
                                      DetailRow(
                                        label: S.of(context).numberOfReturns,
                                        value:
                                            categoryDetail['countReturns'] ?? 0,
                                      ),
                                      DetailRow(
                                        label:
                                            S.of(context).totalPriceOfReturns,
                                        value: categoryDetail[
                                                'category_total_price_returns'] ??
                                            0,
                                      ),
                                      DetailRow(
                                          label: S.of(context).numberOfSamples,
                                          value:
                                              categoryDetail['countExpenses'] ??
                                                  0),
                                      DetailRow(
                                          label:
                                              S.of(context).totalPriceOfSamples,
                                          value: categoryDetail[
                                                  'category_total_price_expenses'] ??
                                              0),
                                      const Divider(
                                        color: kBlueLightColor,
                                      ),
                                      DetailRow(
                                        label: S.of(context).totalPrice,
                                        value: categoryDetail[
                                                'category_total_price'] ??
                                            0,
                                        textColor: kActiveIconColor,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Center(
                        child: Text(S.of(context).noData),
                      ),
          ],
        ));
  }
}
