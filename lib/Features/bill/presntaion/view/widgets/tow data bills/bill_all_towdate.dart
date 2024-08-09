import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/tow%20data%20bills/bill_details_tow.dart';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class DisplayBillsBySchoolTotalScreen extends StatefulWidget {
  final String type;

  const DisplayBillsBySchoolTotalScreen({required this.type});

  @override
  _DisplayBillsBySchoolTotalScreenState createState() =>
      _DisplayBillsBySchoolTotalScreenState();
}

class _DisplayBillsBySchoolTotalScreenState
    extends State<DisplayBillsBySchoolTotalScreen> {
  final TextEditingController _searchController = TextEditingController();

  DateTime _selectedOneDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _selectedTowDate = DateTime.now();
  List<School> _schools = [];
  bool _isLoading = false;
  List<School> _filteredSchools = [];

  @override
  void initState() {
    super.initState();
    _fetchBillsByDateAndSchool(_selectedOneDate, _selectedTowDate);
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

  void _showLoadingSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16.0),
            Text(
              S.of(context).generatingPDF,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: kActiveIconColor, // Customize the background color
        duration: const Duration(minutes: 1), // Adjust the duration as needed
      ),
    );
  }

  Future<void> _fetchBillsByDateAndSchool(
      DateTime startDate, DateTime endDate) async {
    var formattedFdDate = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    var formattedEdDate = DateFormat('yyyy-MM-dd', 'en').format(endDate);
    if (formattedFdDate == formattedEdDate) {
      _showDateConflictDialog(context, S.of(context).startEndConflict);
      return; // Return early to prevent the network request
    } else if (startDate.isAfter(endDate)) {
      _showDateConflictDialog(
          context, S.of(context).startAfterEnd); // Start day is after end day
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.Request(
        'POST',
        Uri.parse('$baseUrl/bill/schools/get-all'),
      );
      var formattedFDate = DateFormat('yyyy-MM-dd', 'en').format(startDate);
      var formattedSDate = DateFormat('yyyy-MM-dd', 'en').format(endDate);

      request.headers.addAll({'Content-Type': 'application/json'});
      request.body =
          '{"start":"$formattedFDate","end":"$formattedSDate","type":"${widget.type}" }';
      //formattedDate
      //  DateFormat('yyyy-MM-dd').format(selectedDate)
      print("the body ${request.body}");
      http.StreamedResponse response = await request.send();
      print(request.body);

      if (mounted) {
        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var jsonData = json.decode(responseBody);

          List<School> fetchedSchools = [];
          for (var schoolData in jsonData['data']) {
            fetchedSchools.add(School.fromJson(schoolData));
          }
          print(responseBody);
          if (mounted) {
            setState(() {
              _schools = fetchedSchools;
              _filteredSchools = _schools;
              _isLoading = false;
            });
          }
        } else {
          print(response.reasonPhrase);
          _showErrorSnackBar('Error: ${response.reasonPhrase}');
        }
      }
    } catch (error) {
      print('Error fetching data: $error');
      _showErrorSnackBar('An error occurred. Please try again later.');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void filterSchoold(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSchools =
            _schools; // Show all drivers when search query is empty
      } else {
        _filteredSchools = _schools
            .where((school) =>
                school.nameAr.toLowerCase().contains(query.toLowerCase()) ||
                school.nameEn.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> generateSchoolPdf(
    School school,
    String driverName,
    String promoterName,
  ) async {
    final pdf = pw.Document();
    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
    final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
    final String formattedDate = formatter.format(_selectedOneDate);
    final String formattedDatet = formatter.format(_selectedTowDate);

    for (var sellPoint in school.sellPoints) {
      sellPoint.bills.sort((a, b) => a.date.compareTo(b.date));
      for (var bill in sellPoint.bills) {
        final List<List<String>> tableData = [
          ['English Category Name', 'الاسم', 'الكمية', 'السعر الكلي'],
        ];
        for (var category in bill.billCategories) {
          tableData.add([
            category.category.nameEn,
            category.category.nameAr,
            category.amount.toString(),
            category.totalPrice.toString(),
          ]);
        }

        int totalQuantity = bill.totalquantity;
        int totalBillAmount = bill.total.toInt();

        pdf.addPage(pw.MultiPage(
          textDirection: pw.TextDirection.rtl,
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
                    style:
                        pw.TextStyle(fontSize: 16, font: pw.Font.ttf(ttfBold)),
                    textDirection: pw.TextDirection.rtl),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Phone: 065384357',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'Fax: 065384357',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'TRN: 100334461900003',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(school.nameAr,
                      style: pw.TextStyle(
                          fontSize: 12, font: pw.Font.ttf(ttfBold)),
                      textDirection: pw.TextDirection.rtl),
                  pw.Text(' ${school.nameEn}',
                      style: pw.TextStyle(
                          fontSize: 12, font: pw.Font.ttf(ttfBold))),
                  pw.Center(
                    child: pw.Text(
                      formatter.format(bill.date),
                      style: pw.TextStyle(
                          font: pw.Font.ttf(ttfBold), fontSize: 12),
                    ),
                  ),
                ]),
            pw.SizedBox(height: 20),
            pw.Table(
              border: null,
              columnWidths: {
                0: const pw.FlexColumnWidth(),
                1: const pw.FlexColumnWidth(),
                2: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Text('اسم المندوب',
                        style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                        textDirection: pw.TextDirection.rtl),
                    pw.Text('الموقع',
                        style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                        textDirection: pw.TextDirection.rtl),
                    pw.Text('اسم السائق',
                        style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                        textDirection: pw.TextDirection.rtl),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text(driverName,
                        style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                        textDirection: pw.TextDirection.rtl),
                    pw.Text(school.region,
                        style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                        textDirection: pw.TextDirection.rtl),
                    pw.Text(promoterName,
                        style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                        textDirection: pw.TextDirection.rtl),
                  ],
                ),
              ],
            ),
            pw.Table.fromTextArray(
              data: tableData,
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, font: pw.Font.ttf(ttfBold)),
              cellAlignment: pw.Alignment.center,
              cellStyle: pw.TextStyle(
                font: pw.Font.ttf(ttfBold),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total Quantity: $totalQuantity',
                    style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.Text(
                    'Total price: $totalBillAmount',
                    style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                    textDirection: pw.TextDirection.rtl,
                  ),
                ]),
          ],
        ));
      }
    }

    final pdfBytes = await pdf.save();
    final appDocDir = await getApplicationSupportDirectory();
    final name = "فواتير ${school.nameAr} - $formattedDate إلى $formattedDatet";

    final pdfPath = '${appDocDir.path}/$name.pdf';
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);
    final result = OpenFile.open(pdfPath);

    print('PDFs generated and saved to: $pdfPath');
  }

  Future<void> generateAllSchoolsPdf(List<School> schools) async {
    final pdf = pw.Document();
    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');

    for (var school in schools) {
      final promoterName = school.sellPoints.isNotEmpty
          ? school.sellPoints[0].promoterName ?? 'Unknown Promoter'
          : 'Unknown Promoter';

      final driverName = school.sellPoints.isNotEmpty
          ? school.sellPoints[0].driverName ?? 'Unknown Driver'
          : 'Unknown Driver';
      final List<String> tableHeaders = [
        'English Category Name',
        'Arabic Category Name',
        'Quantity',
        'Amount'
      ];

      final List<List<String>> tableData = [
        tableHeaders, // This is the header row
        for (var sellPoint in school.sellPoints)
          for (var bill in sellPoint.bills)
            for (var category in bill.billCategories)
              [
                category.category.nameEn,
                category.category.nameAr,
                category.amount.toString(),
                category.totalPrice.toString(),
              ],
      ];
      int totalQuantity = 0;
      int totalBillAmount = 0;
      for (var sellPoint in school.sellPoints) {
        for (var bill in sellPoint.bills) {
          totalQuantity += bill.totalquantity;
          totalBillAmount += bill.total.toInt();
        }
      }
      final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
      final String formattedDate = formatter.format(_selectedOneDate);
      final String formattedDatet = formatter.format(_selectedTowDate);
      pdf.addPage(pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
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
              pw.Text(
                'Phone: 065384357',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'Fax: 065384357',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'TRN: 100334461900003',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(school.nameAr,
                style: pw.TextStyle(fontSize: 12, font: pw.Font.ttf(ttfBold)),
                textDirection: pw.TextDirection.rtl),
            pw.Text(' ${school.nameEn}',
                style: pw.TextStyle(fontSize: 12, font: pw.Font.ttf(ttfBold))),
            pw.Center(
              child: pw.Text(
                "$formattedDate -- $formattedDatet",
                style: pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 12),
              ),
            ),
          ]),
          pw.SizedBox(height: 20),
          pw.Table(
            border: null,
            columnWidths: {
              0: const pw.FlexColumnWidth(),
              1: const pw.FlexColumnWidth(),
              2: const pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Text('اسم المندوب',
                      style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                      textDirection: pw.TextDirection.rtl),
                  pw.Text('الموقع',
                      style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                      textDirection: pw.TextDirection.rtl),
                  pw.Text('اسم السائق',
                      style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                      textDirection: pw.TextDirection.rtl),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(driverName,
                      style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                      textDirection: pw.TextDirection.rtl),
                  pw.Text(school.region,
                      style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                      textDirection: pw.TextDirection.rtl),
                  pw.Text(promoterName,
                      style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                      textDirection: pw.TextDirection.rtl),
                ],
              ),
            ],
          ),
          pw.Table.fromTextArray(
            data: tableData,
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, font: pw.Font.ttf(ttfBold)),
            cellAlignment: pw.Alignment.center,
            cellStyle: pw.TextStyle(
              font: pw.Font.ttf(ttfBold),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'Total Quantity: $totalQuantity',
                  style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.Text(
                  'Total price: ${totalBillAmount}',
                  style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
                  textDirection: pw.TextDirection.rtl,
                ),
              ]),
        ],
      ));
    }
    final pdfBytes = await pdf.save();
    final appDocDir = await getApplicationSupportDirectory();
    final pdfPath = '${appDocDir.path}/all_schools_bills.pdf';
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);
    final result = await OpenFile.open(pdfPath);
    print('All Schools PDF generated and saved to: $pdfPath');
  }

  Future<void> _generateAllSchoolsPdf() async {
    // Show the loading snackbar with a small delay
    _showLoadingSnackbar(context);

    // Introduce a delay before starting PDF generation
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final pdfBytes = await generateAllSchoolsPdf(_schools);

      // Save or display the PDF here if needed

      // Hide the snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } catch (error) {
      // Handle any errors during PDF generation
      print('Error generating PDF: $error');

      // Hide the snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueLightColor,
        title: Text(
          S.of(context).betweenTwoDates,
          style: Styles.textStyle20.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
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
                const SizedBox(height: 16.0),
                _buildDateContainer(
                  S.of(context).endDate,
                  DateFormat('yyyy-MM-dd', 'en').format(_selectedTowDate),
                  () => _selectTowDate(context),
                ),
              ],
            ),
          ),
          // SizedBox(height: 20.0),
          Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              _buildActionButton(
                context,
                S.of(context).generatePdfsForAllSchools,
                () {
                  print(_filteredSchools.length);
                  _generateAllSchoolsPdf();
                },
              ),
              const SizedBox(
                width: 5,
              ),
              _buildActionButton(
                context,
                S.of(context).fetchBills,
                () => _fetchBillsByDateAndSchool(
                    _selectedOneDate, _selectedTowDate),
              ),
            ],
          ),
          // SizedBox(height: 15.0),
          TextField(
            controller: _searchController,
            onChanged: (value) {
              filterSchoold(value);
            },
            decoration: InputDecoration(
              labelText: S.of(context).searchBySchoolName,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 15.0),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: SpinKitSpinningLines(
                      size: 35,
                      color: hBackgroundColor,
                    ),
                  )
                : _filteredSchools.isEmpty
                    ? Center(child: Text(S.of(context).noMatchingSchoolFound))
                    : ListView.builder(
                        itemCount: _filteredSchools.length,
                        itemBuilder: (context, index) {
                          final school = _filteredSchools[index];
                          if (school.sellPoints.isNotEmpty) {
                            final driverName =
                                school.sellPoints[0].driverName ??
                                    'Unknown Driver';
                            final promoterName =
                                school.sellPoints[0].promoterName ??
                                    'Unknown Promoter';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SchoolDetailsTowDateScreen(
                                      school: school,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(school.nameAr,
                                          style: Styles.textStyle16),
                                      Text(school.region,
                                          style: Styles.textStyle16),
                                      ElevatedButton(
                                        onPressed: () {
                                          generateSchoolPdf(
                                              school, promoterName, driverName);
                                        },
                                        // style: ElevatedButton.styleFrom(
                                        //   primary: kActiveIconColor,
                                        //   shape: RoundedRectangleBorder(
                                        //     borderRadius:
                                        //         BorderRadius.circular(10),
                                        //   ),
                                        // ),
                                        child: Text(
                                          S.of(context).generatePdf,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SchoolDetailsTowDateScreen(
                                      school: school,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(school.nameEn,
                                          style: Styles.textStyle16),
                                      Text(school.nameAr,
                                          style: Styles.textStyle16),
                                      Text(school.region,
                                          style: Styles.textStyle16),
                                      Text(
                                        S.of(context).noSellPointsAvailable,
                                        style: Styles.textStyle16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
          ),
        ],
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
            child: Text(
              S.of(context).select,
              style: const TextStyle(
                // color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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
        style: const TextStyle(
          // color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class School {
  final int id;
  final String nameAr;
  final String nameEn;
  final String region;
  final String type;

  final List<SellPoint> sellPoints;

  School({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.region,
    required this.type,
    required this.sellPoints,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    List<SellPoint> sellPoints = [];
    if (json['sell_points'] != null) {
      for (var sellPointData in json['sell_points']) {
        sellPoints.add(SellPoint.fromJson(sellPointData));
      }
    }

    return School(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      region: json['region'] ?? '',
      type: json['type'] ?? '',
      sellPoints: sellPoints,
    );
  }
}

class SellPoint {
  final int id;
  final String name;
  final List<Bill> bills;
  final int total;
  final int total_quantity;
  final String driverName;
  final String promoterName;

  SellPoint({
    required this.total,
    required this.total_quantity,
    required this.id,
    required this.name,
    required this.bills,
    required this.driverName,
    required this.promoterName,
  });

  factory SellPoint.fromJson(Map<String, dynamic> json) {
    List<Bill> bills = [];
    if (json['bills'] != null) {
      for (var billData in json['bills']) {
        bills.add(Bill.fromJson(billData));
      }
    }
    final driverName = json['driver']?['name_ar'] ?? 'Unknown Driver';
    final promoterName = json['promoter']?['name_ar'] ?? 'Unknown Promoter';

    return SellPoint(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      total: json['total'] ?? 0,
      total_quantity: json['total_quantity'] ?? 0,
      bills: bills,
      driverName: driverName,
      promoterName: promoterName,
    );
  }
}

class Bill {
  final int id;
  final num total;
  final int totalquantity;
  final DateTime date;
  final List<BillCategory> billCategories;

  Bill(
      {required this.id,
      required this.date,
      required this.billCategories,
      required this.total,
      required this.totalquantity});

  factory Bill.fromJson(Map<String, dynamic> json) {
    List<BillCategory> billCategories = [];
    if (json['bill_categories'] != null) {
      for (var categoryData in json['bill_categories']) {
        billCategories.add(BillCategory.fromJson(categoryData));
      }
    }
    DateTime date = DateTime.parse(json['date']);
    return Bill(
      id: json['id'] ?? 0,
      total: json['total'] ?? 0,
      totalquantity: json['total_quantity'] ?? 0,
      billCategories: billCategories,
      date: date,
    );
  }
}

class BillCategory {
  final int id;
  final int amount;
  final num totalPrice;
  final Category category;

  BillCategory({
    required this.id,
    required this.amount,
    required this.totalPrice,
    required this.category,
  });

  factory BillCategory.fromJson(Map<String, dynamic> json) {
    return BillCategory(
      id: json['id'] ?? 0,
      amount: json['amount'] ?? 0,
      totalPrice: json['total_price'] ?? 0,
      category: Category.fromJson(json['category'] ?? {}),
    );
  }
}

class Category {
  final int id;
  final String nameAr;
  final String nameEn;
  final double price;
  final String photo;
  final String source;
  final String type;
  final String schoolType;
  final bool visibility;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
    required this.photo,
    required this.source,
    required this.type,
    required this.schoolType,
    required this.visibility,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final priceValue = json['price'];
    double parsedPrice = priceValue is num ? priceValue.toDouble() : 0.0;

    return Category(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      price: parsedPrice,
      photo: json['photo'] ?? '',
      source: json['source'] ?? '',
      type: json['type'] ?? '',
      schoolType: json['school_type'] ?? '',
      visibility: json['visibility'] ?? false,
    );
  }
}
