import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:shamseenfactory/Features/driver/data/dirver_api.dart';
import 'package:shamseenfactory/Features/driver/data/models/driver_model.dart';
import 'package:shamseenfactory/Features/driver/presentaion/view/widgets/add_driver_dialog.dart';
import 'package:shamseenfactory/Features/driver/presentaion/view/widgets/driver_card.dart';
import 'package:shamseenfactory/Features/driver/presentaion/view/widgets/search_field.dart';
import 'package:shamseenfactory/Features/driver/presentaion/view/widgets/sp_driver_view.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'package:shamseenfactory/core/utils/styles.dart';

class DriverView extends StatefulWidget {
  DriverView({super.key});

  @override
  State<DriverView> createState() => _DriverViewState();
}

class _DriverViewState extends State<DriverView> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  List<Driver> _drivers = [];
  List<Driver> _fitterdrivers = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchAllDrivers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  void _filterDrivers(String query) {
    final searchQuery = query.toLowerCase();

    setState(() {
      if (searchQuery.isEmpty) {
        // If the search query is empty, show all drivers
        _fitterdrivers = List.from(_drivers);
      } else {
        // Filter drivers based on search query
        _fitterdrivers = _drivers.where((driver) {
          final nameArabic = driver.nameAr.toLowerCase();
          final nameEnglish = driver.nameEn.toLowerCase();
          return nameArabic.contains(searchQuery) ||
              nameEnglish.contains(searchQuery);
        }).toList();
      }
    });
  }

  Future<void> _fetchAllDrivers() async {
    try {
      print('try');
      final drivers = await DriversApi.fetchAllDrivers();

      if (mounted) {
        setState(() {
          _drivers = drivers;
          _isLoading = false;
          _fitterdrivers = drivers; // ? this filtter ... 
          print("this filtter$_fitterdrivers");
        });
      }
    } catch (error) {
      print('An error occurred while fetching drivers: $error');

      setState(() {
        _isLoading = false;
      });
      
      
      
      
      void setStateIfMounted(f) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void refreshDriverList() {
    _fetchAllDrivers();
  }

  Future<void> generatePDF(List<Driver> drivers) async {
    try {
      final pdf = pw.Document();
      final ttfBold =
          await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
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
              pw.Text('Phone: 065384357',
                  style: const pw.TextStyle(fontSize: 14)),
              pw.Text('Fax: 065384357',
                  style: const pw.TextStyle(fontSize: 14)),
              pw.Text('TRN: 100334461900003',
                  style: const pw.TextStyle(fontSize: 14)),
            ],
          ),
          pw.SizedBox(height: 15),
          pw.Text("Driver user name and password",
              style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  font: pw.Font.ttf(ttfBold))),
          pw.SizedBox(height: 25),
          pw.Table.fromTextArray(
            headerAlignment: pw.Alignment.center,
            cellAlignment: pw.Alignment.center,
            headerDecoration: const pw.BoxDecoration(
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(5)),
              color: PdfColors.grey300,
            ),
            headerHeight: 25,
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
            },
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, font: pw.Font.ttf(ttfBold)),
            cellStyle: pw.TextStyle(
              font: pw.Font.ttf(ttfBold),
            ),
            headers: [
              'Driver Name (Ar)',
              'Driver Name (En)',
              'User',
              'Password'
            ],
            data: List<List<String>>.generate(
              drivers.length,
              (index) => [
                drivers[index].nameAr,
                drivers[index].nameEn,
                drivers[index].user,
                drivers[index].password,
              ],
            ),
          )
        ],
      ));
      // pw.Page(
      //   textDirection: pw.TextDirection.rtl,
      //   build: (context) {
      //     return pw.Column(children: [
      //
      //       )
      //     ]);
      //   },
      // ),
      final pdfBytes = await pdf.save();
      final appDocDir = await getApplicationSupportDirectory();
      final pdfPath = '${appDocDir.path}/driver.pdf';
      print(pdfPath);
      final pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(pdfBytes);
      final result = OpenFile.open(pdfPath);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  kBlueLightColor,
                  kBlueColor,
                ], begin: FractionalOffset(0.0, 0.4), end: Alignment.topRight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: deafultpadding * 2,
                      left: deafultpadding,
                      right: deafultpadding,
                    ),
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            GoRouter.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Text(
                              S.of(context).tAllDriver,
                              style: Styles.textStyle20
                                  .copyWith(color: Colors.white),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                generatePDF(_drivers);
                              },
                              child: Text(
                                S.of(context).generatePdf,
                                style: Styles.textStyle16.copyWith(
                                    // color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            // TextButton(
                            //   onPressed: () {
                            //     generatePDF(_drivers);
                            //   },
                            //   child: Text(
                            //     S.of(context).generatePdf,
                            //     style: Styles.textStyle16.copyWith(
                            //         color: Colors.white,
                            //         fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: deafultpadding,
                        ),
                        SearchField(
                          searchController: searchController,
                          onchange: _filterDrivers, // Call the search method
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: FadeInDown(
                      delay: const Duration(milliseconds: 100),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(70)),
                        ),
                        child: _isLoading
                            ? const Center(
                                child: SpinKitSpinningLines(
                                size: 35,
                                color: hBackgroundColor,
                              ))
                            : _buildDriverList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: SizedBox(
              height: 30,
              width: 50,
              child: FloatingActionButton(
                onPressed: () {
                  _showAddDriverDialog(context);
                },
                backgroundColor: Colors.lightGreen,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriverList() {
    // Apply search filter if search query is not empty

    if (_fitterdrivers.isEmpty) {
      return Center(
        child: Text(
          'No drivers found',
          style: Styles.textStyle20.copyWith(color: kActiveIconColor),
        ),
      );
    }

    return ListView.builder(
      itemCount: _fitterdrivers.length,
      itemBuilder: (context, index) {
        final driver = _fitterdrivers[index];
        return DriverCard(
          driver: driver,
          refreshDriverList: refreshDriverList,
        );
      },
    );
  }

  void _showSellPoints(BuildContext context, Driver driver) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SchoolManagementScreen(driver: driver),
      ),
    );
  }

  // void _showAddDriverDialog(BuildContext context) async {
  //   final newDriver = await showDialog<Driver>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       Driver? _newDriver;
  //       return AlertDialog(
  //         title: Text('Add New Driver'),
  //         content: AddDriverDialog(
  //           onDriverAdded: (driver) {
  //             _newDriver = driver;
  //           },
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context, _newDriver);
  //             },
  //             child: Text('Add'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context, null);
  //             },
  //             child: Text('Cancel'),
  //           ),
  //         ],
  //       );
  //     },
  //   );

  //   if (newDriver != null) {
  //     try {
  //       await DriversApi.addDriver(
  //         nameAr: newDriver.nameAr,
  //         nameEn: newDriver.nameEn,
  //         user: newDriver.user,
  //         password: newDriver.password,
  //         phone: newDriver.phone,
  //       );

  //       // ignore: use_build_context_synchronously
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Driver added successfully'),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //       _fetchAllDrivers(); // Refresh driver list after successful addition
  //     } catch (error) {
  //       if (error is HttpException) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content:
  //                 Text('Failed to add driver. Check your internet connection.'),
  //             duration: Duration(seconds: 2),
  //           ),
  //         );
  //       } else if (error
  //           .toString()
  //           .toLowerCase()
  //           .contains('no address associated with hostname')) {
  //         // Handle this error case if needed
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Failed to add driver: $error'),
  //             duration: Duration(seconds: 2),
  //           ),
  //         );
  //       }
  //     }
  //   }
  // }
  void _showAddDriverDialog(BuildContext context) async {
    try {
      final newDriver = await showDialog<Driver>(
        context: context,
        builder: (BuildContext context) {
          return AddDriverDialog(
            onDriverAdded: (driver) async {
              try {
                await DriversApi.addDriver(
                  nameAr: driver.nameAr,
                  nameEn: driver.nameEn,
                  user: driver.user,
                  password: driver.password,
                  phone: driver.phone,
                );

                // ignore: use_build_context_synchronously
                Navigator.pop(
                    context, driver); // Close the dialog and return the driver

                _scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(
                    content: Text('Driver added successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );

                // Refresh driver list after successful addition
                _fetchAllDrivers();
              } catch (error) {
                Navigator.pop(context, driver);
                // Handle error cases during driver addition
                String errorMessage = 'An error occurred';
                if (error is SocketException) {
                  errorMessage = 'No internet connection';
                } else if (error is HttpException) {
                  errorMessage = 'Failed to add driver: Server error';
                } else {
                  errorMessage = 'Failed to add driver: $error';
                }
                print("this form add error ${errorMessage}");
                _scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    content: Text("$errorMessage"),
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            },
          );
        },
      );

      if (newDriver != null) {
        // The driver was added and the dialog was closed
        // You can handle any additional logic here if needed
      }
    } catch (error) {
      // Handle errors related to opening the dialog here, if necessary
    }
  }
}

Widget myDialog(BuildContext context, String errorMessage) {
  return AlertDialog(
    title: const Text('Error'),
    content: Text(errorMessage),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('OK'),
      ),
    ],
  );
}
