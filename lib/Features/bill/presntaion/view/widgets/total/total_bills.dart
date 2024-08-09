import 'dart:io';
import 'package:animate_do/animate_do.dart';
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
import 'package:excel/excel.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import '../../../../../../generated/l10n.dart';

// Assuming you've defined the CategoryTotal class here

class TotalScreen extends StatefulWidget {
  final String type;
  TotalScreen({required this.type});
  @override
  _TotalScreenState createState() => _TotalScreenState();
}

class _TotalScreenState extends State<TotalScreen> {
  List<CategoryTotal> categoryTotals = [];
  bool isLoading = false;

  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    fetchCategoryTotals(_selectedDate);
    print(widget.type);
  }

  int calculateTotalPrice() {
    return categoryTotals.fold(
        0, (sum, total) => sum + total.totalPrice.toInt());
  }

  Widget _buildDateContainer(
      String label, String dateText, Function()? onPressed) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              const SizedBox(height: 4.0),
              Text(
                dateText,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
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

  Future<void> generatePDF(List<CategoryTotal> categoryTotals) async {
    final pdf = pw.Document();

    // Load custom fonts
    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20.0),
        build: (context) => [
          // Header
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'SHAMSEEN FOODSTUFF CATERING',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  font: pw.Font.ttf(ttfBold),
                ),
              ),
              pw.Text(
                'شمسين لخدمات التموين بالموادالغذائية',
                style: pw.TextStyle(
                  fontSize: 16,
                  font: pw.Font.ttf(ttfBold),
                ),
                textDirection: pw.TextDirection.rtl,
              ),
            ],
          ),

          // Information Section
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

          pw.Text(
            'Date: ${DateFormat('yyyy-MM-dd', 'en').format(_selectedDate)}',
            style: pw.TextStyle(fontSize: 14, font: pw.Font.ttf(ttfBold)),
          ),
          pw.SizedBox(height: 10),
          pw.Text("Type : ${widget.type}",
              style: pw.TextStyle(fontSize: 14, font: pw.Font.ttf(ttfBold))),
          pw.SizedBox(height: 10),
          // Table
          pw.Table.fromTextArray(
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              font: pw.Font.ttf(ttfBold),
            ),
            cellStyle: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
            border: pw.TableBorder.all(),
            headerDecoration: const pw.BoxDecoration(
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
              color: PdfColors.grey300,
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
          // Totals
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                'Total:',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red,
                ),
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

// Add a Divider
          pw.Divider(height: 2, color: PdfColors.grey),

          pw.SizedBox(height: 10),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                'Total Quantity: ',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red,
                ),
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

// Add another Divider
          pw.Divider(height: 2, color: PdfColors.grey),
        ],
      ),
    );

    final pdfBytes = await pdf.save();
    final appDocDir = await getApplicationSupportDirectory();
    final pdfPath = '${appDocDir.path}/totalcategory.pdf';
    print(pdfPath);
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);
    final result = OpenFile.open(pdfPath);
  }

  Future<void> fetchCategoryTotals(DateTime selectedDate) async {
    try {
      setState(() {
        isLoading = true;
      });

      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse('$baseUrl/bill/total/get-all'));

      request.headers.addAll(headers);
      var formattedDate = DateFormat('yyyy-MM-dd', 'en').format(selectedDate);
      // Format the selectedDate
      print(formattedDate);
      request.body = json.encode({'date': formattedDate, 'type': widget.type});

      http.StreamedResponse response = await request.send();
      print("get total one date");
      print(request.body);
      print(response.statusCode);
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
        }
      }
    } catch (e) {
      if (e is SocketException) {
        print('Network error: ${e.message}');
      }
      print(e);
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        fetchCategoryTotals(_selectedDate);
      });
    }
  }

  Future<void> generateExcel(List<CategoryTotal> categoryTotals) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Define headers
    sheet.appendRow(['Category', 'Count', 'Total Price']);

    // Add data rows
    for (var total in categoryTotals) {
      sheet.appendRow([total.nameAr, total.count.toDouble(), total.totalPrice]);
    }
    final totalSum = categoryTotals.fold<int>(
        0, (sum, total) => sum + total.totalPrice.toInt());

    // Add the total sum to the Excel sheet
    sheet.appendRow(['Total:', '', totalSum]);
    // Save the Excel file
    final fileBytes = excel.encode();
    final appDocDir = await getApplicationSupportDirectory();
    final excelPath = '${appDocDir.path}/excel_total$_selectedDate.xlsx';
    final excelFile = File(excelPath);
    await excelFile.writeAsBytes(fileBytes!);

    // Open the generated Excel file
    final res0ult = OpenFile.open(excelPath);
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
        body: Column(children: [
          const SizedBox(
            height: 15,
          ),
          _buildDateContainer(
            S.of(context).startDate,
            DateFormat('yyyy-MM-dd', 'en').format(_selectedDate),
            () => _selectDate(context),
          ),

          const SizedBox(height: 16),
          ButtonBar(
            alignment:
                MainAxisAlignment.spaceEvenly, // Adjust alignment as needed
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
                        ),
                      ),
                    );
                  }
                },

                // ),
                child: Row(
                  children: [
                    Text(
                      S.of(context).generatePdf,
                      style: Styles.textStyle14,
                    ),
                    Image.asset(
                      'assets/images/pdf.png',
                      width: 20,
                      height: 20,
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (categoryTotals.isNotEmpty) {
                    generateExcel(categoryTotals);
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
            ],
          ),

          // ElevatedButton(
          //   onPressed: () => fetchCategoryTotals(_selectedDate),
          //   style: ElevatedButton.styleFrom(
          //     primary: kActiveIconColor,
          //   ),
          //   child: Text('Fetch Bills'),
          // ),
          Expanded(
              child: isLoading
                  ? FadeInDown(
                      duration: const Duration(microseconds: 500),
                      child: const Center(
                        child: SpinKitSpinningLines(
                          size: 35,
                          color: hBackgroundColor,
                        ),
                      ),
                    )
                  : categoryTotals.isEmpty // Check if the list is empty
                      ? Center(
                          child: Text(
                            S.of(context).noData,
                            style: Styles.textStyle20,
                          ),
                        ) // Display message if no data found

                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).categoryTotals,
                                style: Styles.textStyle20
                                    .copyWith(color: kActiveIconColor),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView.builder(
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
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  total.nameEn,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 5),
                                              ],
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${S.of(context).amount}: ${total.count}',
                                                  style: Styles.textStyle14,
                                                ),
                                                Text(
                                                  '${S.of(context).totalPrice} ${total.totalPrice}',
                                                  style: Styles.textStyle14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                            color: Colors.grey, thickness: 2),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    S.of(context).total,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    calculateTotalPrice().toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                            ],
                          ),
                        ))
        ]));
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
      id: json['id'] ??
          0, // Provide a default value (e.g., 0) for missing/null 'id'
      nameAr: json['name_ar'] ??
          'Unknown', // Provide a default value for missing/null 'name_ar'
      nameEn: json['name_en'] ??
          'Unknown', // Provide a default value for missing/null 'name_en'
      count: json['count'] != null
          ? int.parse(json['count'].toString())
          : 0, // Use 0 as a fallback value for missing/null 'count'
      totalPrice: json['total_price'] != null
          ? num.parse(json['total_price'].toString())
          : 0, // Use 0 as a fallback value for missing/null 'total_price'
    );
  }
}
