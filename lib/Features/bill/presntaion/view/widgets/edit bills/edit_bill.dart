import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/edit%20bills/bill_edit_details.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/school%20bill/school_details.dart';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class DisplayeditBillsBySchoolScreen extends StatefulWidget {
  final String type;

  const DisplayeditBillsBySchoolScreen({required this.type});

  @override
  _DisplayBillsBySchoolScreenState createState() =>
      _DisplayBillsBySchoolScreenState();
}

class _DisplayBillsBySchoolScreenState
    extends State<DisplayeditBillsBySchoolScreen> {
  final TextEditingController _searchController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  List<School> _schools = [];
  bool _isLoading = false;
  List<School> _filteredSchools = [];

  @override
  void initState() {
    super.initState();
    _fetchBillsByDateAndSchool(_selectedDate);
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
        _fetchBillsByDateAndSchool(_selectedDate);
      });
    }
  }

  void refrech() {
    _fetchBillsByDateAndSchool(_selectedDate);
  }

  Future<void> _fetchBillsByDateAndSchool(DateTime selectedDate) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.Request(
        'POST',
        Uri.parse('$baseUrl/bill/schools/get-all'),
      );

      final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
      final String formattedDate = formatter.format(selectedDate);
      print('$formattedDate');

      request.headers.addAll({'Content-Type': 'application/json'});
      request.body = '{"date":"$formattedDate" ,"type":"${widget.type}"}';
      //formattedDate
      //  DateFormat('yyyy-MM-dd').format(selectedDate)
      http.StreamedResponse response = await request.send();
      print(request.body);
      print(response.statusCode);
      if (mounted) {
        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var jsonData = json.decode(responseBody);

          List<School> fetchedSchools = [];
          for (var schoolData in jsonData['data']) {
            fetchedSchools.add(School.fromJson(schoolData));
          }

          if (mounted) {
            setState(() {
              _schools = fetchedSchools;
              _filteredSchools = _schools;
              _isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _isLoading = false; // Clear the data if an error occurs
            });
          }
          print(response.reasonPhrase);
          _showErrorSnackBar('Error: ${response.reasonPhrase}');
        }
      }
    } catch (error) {
      print('Error fetching data in fetch: $error');
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
            child: Text(S.of(context).select, style: Styles.textStyle14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBlueLightColor,
          title: Text(
            S.of(context).editBill,
            style: Styles.textStyle20.copyWith(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 15,
            ),
            _buildDateContainer(
              S.of(context).theDate,
              DateFormat('yyyy-MM-dd', 'en').format(_selectedDate),
              () => _selectDate(context),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                // Call a function to filter the _drivers list based on the entered text
                filterSchoold(value);
              },
              decoration: InputDecoration(
                labelText: S.of(context).searchBySchoolName,
                labelStyle: Styles.textStyle12,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            Expanded(
                child: _isLoading
                    ? const Center(
                        child: SpinKitSpinningLines(
                          size: 35,
                          color: hBackgroundColor,
                        ),
                      )
                    : _filteredSchools.isEmpty
                        ? Center(
                            child: Text(S.of(context).noSchoolsAvailable),
                          )
                        : ListView.builder(
                            itemCount: _filteredSchools.length, // Add
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
                                                SchoolDetailsBillScreen(
                                                  schoolId: school.id,
                                                  selectedDate: _selectedDate,
                                                  type: widget.type,
                                                )),
                                      );
                                    },
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    school.nameEn,
                                                    style: Styles.textStyle14,
                                                  ),
                                                  Text(
                                                    school.nameAr,
                                                    style: Styles.textStyle14,
                                                  ),
                                                  Text(
                                                    school.region,
                                                    style: Styles.textStyle14,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              } else {
                                // Handle the case when there are no sell points
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SchoolDetailsBillScreen(
                                                schoolId: school.id,
                                                selectedDate: _selectedDate,
                                                type: widget.type,
                                              )),
                                    );
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(school.nameEn),
                                          Text(school.nameAr),
                                          Text(school.region),
                                          Text(S
                                              .of(context)
                                              .noSellPointsAvailable),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ))
          ],
        ));
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
  final List<BillCategory> billCategories;

  Bill(
      {required this.id,
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

    return Bill(
      id: json['id'] ?? 0,
      total: json['total'] ?? 0,
      totalquantity: json['total_quantity'] ?? 0.0,
      billCategories: billCategories,
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

  // Future<void> generateSchoolPdf(
  //   School school,
  //   String driverName,
  //   String promoterName,
  // ) async {
  //   final pdf = pw.Document();
  //   final ttfBold =
  //       await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
  //   final List<String> tableHeaders = [
  //     'English Category Name',
  //     'Arabic Category Name',
  //     'Quantity',
  //     'Amount'
  //   ];

  //   final List<List<String>> tableData = [
  //     tableHeaders, // This is the header row
  //     for (var sellPoint in school.sellPoints)
  //       for (var bill in sellPoint.bills)
  //         for (var category in bill.billCategories)
  //           [
  //             category.category.nameEn,
  //             category.category.nameAr,
  //             category.amount.toString(),
  //             category.totalPrice.toString(),
  //           ],
  //   ];
  //   pdf.addPage(
  //     pw.Page(
  //       textDirection: pw.TextDirection.rtl,
  //       build: (context) {
  //         return pw.Column(
  //           // mainAxisAlignment: pw.MainAxisAlignment.center,
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Text('SHAMSEEN FOODSTUFF CATERING',
  //                     style: pw.TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: pw.FontWeight.bold,
  //                         font: pw.Font.ttf(ttfBold))),
  //                 pw.Text('شمسين لخدمات التموين بالموادالغذائية',
  //                     style: pw.TextStyle(
  //                         fontSize: 16, font: pw.Font.ttf(ttfBold)),
  //                     textDirection: pw.TextDirection.rtl),
  //               ],
  //             ),
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Text('Phone: 775533',
  //                     style: const pw.TextStyle(fontSize: 14)),
  //                 pw.Text('Fax: 123456',
  //                     style: const pw.TextStyle(fontSize: 14)),
  //                 pw.Text('TRN: 789654',
  //                     style: const pw.TextStyle(fontSize: 14)),
  //               ],
  //             ),
  //             pw.SizedBox(height: 10),
  //             pw.Column(children: [
  //               pw.Text('School Name (Arabic): ${school.nameAr}'),
  //               pw.Text('School Name (Engilish): ${school.nameEn}'),
  //             ]),
  //             pw.SizedBox(height: 20),
  //             pw.Table(
  //               border: null,
  //               columnWidths: {
  //                 0: const pw.FlexColumnWidth(),
  //                 1: const pw.FlexColumnWidth(),
  //                 2: const pw.FlexColumnWidth(),
  //               },
  //               children: [
  //                 pw.TableRow(
  //                   decoration:
  //                       const pw.BoxDecoration(color: PdfColors.grey300),
  //                   children: [
  //                     pw.Text('اسم السائق',
  //                         style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
  //                         textDirection: pw.TextDirection.rtl),
  //                     pw.Text('الموقع',
  //                         style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
  //                         textDirection: pw.TextDirection.rtl),
  //                     pw.Text('اسم المندوب',
  //                         style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
  //                         textDirection: pw.TextDirection.rtl),
  //                   ],
  //                 ),
  //                 // Driver, Region, and Promoter Info
  //                 pw.TableRow(
  //                   children: [
  //                     pw.Text(driverName,
  //                         style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
  //                         textDirection: pw.TextDirection.rtl),
  //                     pw.Text(school.region,
  //                         style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
  //                         textDirection: pw.TextDirection.rtl),
  //                     pw.Text(promoterName,
  //                         style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
  //                         textDirection: pw.TextDirection.rtl),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             pw.Table.fromTextArray(
  //               data: tableData,
  //               headerStyle: pw.TextStyle(
  //                   fontWeight: pw.FontWeight.bold, font: pw.Font.ttf(ttfBold)),
  //               cellAlignment: pw.Alignment.center,
  //               cellStyle: pw.TextStyle(
  //                 font: pw.Font.ttf(ttfBold),
  //               ),
  //             ),
  //             pw.SizedBox(height: 20),
  //             // Display the total_quantity and total as plain text
  //             pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.end,
  //                 mainAxisAlignment: pw.MainAxisAlignment.end,
  //                 children: [
  //                   pw.Text(
  //                     'Total Quantity: ${school.sellPoints[0].total_quantity}',
  //                     style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
  //                     textDirection: pw.TextDirection.rtl,
  //                   ),
  //                   pw.Text(
  //                     'Total: ${school.sellPoints[0].total}',
  //                     style: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
  //                     textDirection: pw.TextDirection.rtl,
  //                   ),
  //                 ]),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  //   final pdfBytes = await pdf.save();
  //   final appDocDir = await getApplicationDocumentsDirectory();
  //   final pdfPath = '${appDocDir.path}/my_pdfs.pdf';
  //   final pdfFile = File(pdfPath);
  //   await pdfFile.writeAsBytes(pdfBytes);
  //   final result = OpenFile.open(pdfPath);

  //   print('PDFs generated and saved to: $pdfPath');
  // }
