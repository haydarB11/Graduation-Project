import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart' show DateFormat;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/driver%20bills/driver_details.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/driver%20bills/pdf_bills_drivers.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'driver_model.dart';

class DisplayBillsByDriversScreen extends StatefulWidget {
  final String type;

  const DisplayBillsByDriversScreen({required this.type});
  @override
  _DisplayBillsByDriversScreenState createState() =>
      _DisplayBillsByDriversScreenState();
}

class _DisplayBillsByDriversScreenState
    extends State<DisplayBillsByDriversScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Inside your _DisplayBillsByDriversScreenState class

  DateTime _selectedDate = DateTime.now();
  List<Driver> _drivers = []; // Populate this with API response
  bool _isLoading = false;
  List<Driver> _filteredDrivers = [];
  String? _errorMessage;
  String laseType = "Returns";

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
        fetchBillsByDate(_selectedDate);
      });
    }
  }

  void filterDrivers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDrivers =
            _drivers; // Show all drivers when search query is empty
      } else {
        _filteredDrivers = _drivers
            .where((driver) =>
                driver.nameAr.toLowerCase().contains(query.toLowerCase()) ||
                driver.nameEn.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> fetchBillsByDate(DateTime selectedDate) async {
    setState(() {
      _isLoading = true;
    });

    try {
      const String apiUrl = '$baseUrl/bill/drivers/get-all';
      final Map<String, String> headers = {'Content-Type': 'application/json'};

      final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
      final String formattedDate = formatter.format(selectedDate);
      final String requestBody =
          '{"date": "$formattedDate","type":"${widget.type}"}';

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBody,
      );
      print(requestBody);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> driverDataList = jsonResponse['data'];

        final List<Driver> parsedDrivers = driverDataList.map((driverData) {
          return Driver.fromJson(driverData);
        }).toList();

        if (mounted) {
          setState(() {
            _drivers = parsedDrivers;
            _filteredDrivers = _drivers;
            _isLoading = false;
          });
        }
      } else {
        print('API call failed: ${response.reasonPhrase}');
        _showErrorSnackBar('Error: ${response.reasonPhrase}');
        if (mounted) {
          setState(() {
            _drivers = [];
            _isLoading = false; // Clear the data if an error occurs
          });
        }
      }
    } catch (error) {
      _showErrorSnackBar('An error occurred. Please try again later.');
      print('Error: $error');
      if (mounted) {
        setState(() {
          _drivers = []; // Clear the data if an error occurs
        });
      }
    } finally {
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

  @override
  void initState() {
    super.initState();
    _filteredDrivers = _drivers;
    fetchBillsByDate(_selectedDate);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueLightColor,
        title: Text(
          S.of(context).billsByDrivers,
          style: Styles.textStyle20.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
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
              filterDrivers(value);
            },
            decoration: InputDecoration(
              labelText: S.of(context).searchByDriverName,
              labelStyle: Styles.textStyle12,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () async {
              final pdfGenerator = PDFGenerator(_drivers);
              await pdfGenerator.generate();
            },
            child: Text('Generate PDF'),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: SpinKitSpinningLines(
                    size: 35,
                    color: hBackgroundColor,
                  ))
                : _filteredDrivers.isEmpty
                    ? Center(
                        child: Text(
                          S.of(context).noMatchingDriverFound,
                          style: Styles.textStyle18,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredDrivers.length,
                        itemBuilder: (context, index) {
                          final driver = _filteredDrivers[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DriverDetailsScreen(driver: driver),
                                ),
                              );
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      driver.nameAr,
                                      style: Styles.textStyle16,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${S.of(context).sellPoints} : ",
                                      style: Styles.textStyle18
                                          .copyWith(color: kActiveIconColor),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (final sellPoint
                                            in driver.sellPoints)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "-${sellPoint.name}",
                                                style: Styles.textStyle14,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

  // Future<void> fetchBillsByDate(DateTime selectedDate) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     const String apiUrl = '$baseUrl/bill/drivers/get-all';
  //     final Map<String, String> headers = {'Content-Type': 'application/json'};

  //     final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
  //     final String formattedDate = formatter.format(selectedDate);
  //     final String requestBody =
  //         '{"date": "$formattedDate","type":"${widget.type}"}';
  //     print(requestBody);
  //     final http.Response response = await http.post(Uri.parse(apiUrl),
  //         headers: headers, body: requestBody);
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       final jsonResponse = json.decode(response.body);
  //       final List<dynamic> driverDataList = jsonResponse['data'];

  //       final List<Driver> parsedDrivers = driverDataList.map((driverData) {
  //         final List<dynamic> sellPointList = driverData['sell_points'];
  //         final List<SellPoint> parsedSellPoints =
  //             sellPointList.map((sellPointData) {
  //           final Promoter? promoter = sellPointData['promoter'] != null
  //               ? Promoter(
  //                   nameAr: sellPointData['promoter']['name_ar'] ?? '',
  //                   nameEn: sellPointData['promoter']['name_en'] ?? '',
  //                   user: sellPointData['promoter']['user'] ?? '',
  //                   password: sellPointData['promoter']['password'] ?? '',
  //                   phone: sellPointData['promoter']['phone'] ?? '',
  //                 )
  //               : null;

  //           final School? school = sellPointData['school'] != null
  //               ? School(
  //                   id: sellPointData['school']['id'] ?? 0,
  //                   nameAr: sellPointData['school']['name_ar'] ?? '',
  //                   nameEn: sellPointData['school']['name_en'] ?? '',
  //                   region: sellPointData['school']['region'] ?? '',
  //                   type: sellPointData['school']['type'] ?? '',
  //                 )
  //               : null;

  //           final List<dynamic> billList = sellPointData['bills'];
  //           final List<Bill> parsedBills = billList.map((billData) {
  //             final List<dynamic> categoryList = billData['bill_categories'];
  //             final List<BillCategory> parsedCategories =
  //                 categoryList.map((categoryData) {
  //               return BillCategory(
  //                 id: categoryData['id'] ?? 0,
  //                 nameAr: categoryData['category'] != null
  //                     ? categoryData['category']['name_ar'] ?? ''
  //                     : '',
  //                 nameEn: categoryData['category'] != null
  //                     ? categoryData['category']['name_en'] ?? ''
  //                     : '',
  //                 amount: categoryData['amount'] ?? 0,
  //                 totalPrice: categoryData['total_price'] ?? 0,
  //               );
  //             }).toList();

  //             return Bill(
  //               id: billData['id'] ?? 0,
  //               billCategories: parsedCategories,
  //               total: billData['total'] ?? 0.0,
  //               totalQuantity: billData['total_quantity'] ?? 0,
  //             );
  //           }).toList();

  //           return SellPoint(
  //             id: sellPointData['id'] ?? 0,
  //             name: sellPointData['name'] ?? '',
  //             promoter: promoter,
  //             school: school,
  //             bills: parsedBills,
  //             total: sellPointData['total'] ?? 0,
  //             totalQuantity: sellPointData['total_quantity'] ?? 0,
  //           );
  //         }).toList();

  //         return Driver(
  //           id: driverData['id'] ?? 0,
  //           nameAr: driverData['name_ar'] ?? '',
  //           nameEn: driverData['name_en'] ?? '',
  //           user: driverData['user'] ?? '',
  //           password: driverData['password'] ?? '',
  //           phone: driverData['phone'] ?? '',
  //           sellPoints: parsedSellPoints,
  //         );
  //       }).toList();

  //       if (mounted) {
  //         setState(() {
  //           _drivers = parsedDrivers;
  //           _filteredDrivers = _drivers;
  //           _isLoading = false;
  //         });
  //       }
  //     } else {
  //       print('API call failed: ${response.reasonPhrase}');
  //       _showErrorSnackBar('Error: ${response.reasonPhrase}');
  //       if (mounted) {
  //         setState(() {
  //           _drivers = [];
  //           _isLoading = false; // Clear the data if an error occurs
  //         });
  //       }
  //     }
  //   } catch (error) {
  //     _showErrorSnackBar('An error occurred. Please try again later.');
  //     print('Error: $error');
  //     if (mounted) {
  //       setState(() {
  //         _drivers = []; // Clear the data if an error occurs
  //       });
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }