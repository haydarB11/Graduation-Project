import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import '../../../../utils.dart';
import '../school bill/widgets/loading_snackbar.dart';
import 'data/inventory_api_pdf.dart';
import 'data/niverntories_mode_pdf.dart';
import 'model.dart';
import 'school_card.dart';
import 'package:intl/intl.dart';
import 'widgets/exel_for_all_school.dart';
import 'widgets/pdf_allsellpoints.dart';
import 'widgets/school_view.dart';

class SchoolView extends StatefulWidget {
  final String type;
  const SchoolView({super.key, required this.type});

  @override
  State<SchoolView> createState() => _SchoolViewState();
}

class _SchoolViewState extends State<SchoolView> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is initialized

    fetchForPdf(_selectedStartDate, _selectedEnfDate).then((value) {
      inventorySortList = sortInventoryByPromoterId(pdfInventory);
    });
  }

  List<InventoryData> pdfInventory = [];
  List<InventoryData> inventorySortList = [];
  bool isPdfLoading = true;

  DateTime _selectedStartDate =
      DateTime.now().subtract(const Duration(days: 1));
  DateTime _selectedEnfDate = DateTime.now();
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

  List<InventoryData> sortInventoryByPromoterId(
      List<InventoryData> inventoryDataList) {
    // Sort the list of InventoryData objects based on the promoter.id
    inventoryDataList.sort(
        (a, b) => a.sellPoint.promoter.id.compareTo(b.sellPoint.promoter.id));
    return inventoryDataList;
  }

  Future<void> fetchForPdf(DateTime startDate, DateTime endDate) async {
    if (mounted) {
      setState(() {
        isPdfLoading = true; // Show loading indicator
      });
    }

    var formattedFdDate = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    var formattedEdDate = DateFormat('yyyy-MM-dd', 'en').format(endDate);
    if (startDate.isAfter(endDate)) {
      print(startDate);
      print(endDate);
      _showDateConflictDialog(
          context, S.of(context).startAfterEnd); // Start day is after end day
      return;
    }
    try {
      // Call your API method to fetch inventory data
      final fetchedInventory =
          await InventoryApi.fetchInventoryData(startDate, endDate);

      // Update the state to populate pdfInventory
      print('Inventory data fetched successfully.');
      if (mounted) {
        setState(() {
          pdfInventory = fetchedInventory;
          isPdfLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        isPdfLoading = false;
      }

      // Handle any errors or exceptions here
      print('Error fetching inventory data: $e');
    } finally {
      if (mounted) {
        setState(() {
          isPdfLoading = false; // Hide loading indicator
        });
      }
    }
  }

  Future<void> _generateAllSchoolsPdf() async {
    // Show the loading snackbar with a small delay
    LoadingSnackbar.show(context);

    // Introduce a delay before starting PDF generation
    await Future.delayed(const Duration(milliseconds: 200));
    // Create an instance of PdfGenerator
    try {
      await PdfForAll.generatePdf(pdfInventory, _selectedStartDate,
          _selectedEnfDate); // Call the PDF generation method

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

  Future<void> _generateAllSchoolsexcel() async {
    try {
      await ExcelGeneratorAllSchool.generateExcelForAllExcel(
          pdfInventory, _selectedStartDate, _selectedEnfDate);
    } catch (e) {
      print('Error generating PDF: $e');

      print(e);
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked =
        await DateSelect.selectDate(context, _selectedStartDate);
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEnfDate ??
          DateTime
              .now(), // Use the current date as the initialDate if _selectedEnfDate is null
      firstDate: DateTime(2023), // Set your desired firstDate
      lastDate: DateTime(2100), // Set the lastDate to the current date
    );
    if (picked != null && picked != _selectedEnfDate) {
      setState(() {
        _selectedEnfDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(S.of(context).schoolList, style: Styles.textStyle18),
      ),
      body: Container(
        decoration: const BoxDecoration(color: hBackgroundColor),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 5),
              child: DateContainer(
                context: context,
                label: S.of(context).startDate,
                dateText:
                    DateFormat('yyyy-MM-dd', 'en').format(_selectedStartDate),
                onPressed: () {
                  _selectStartDate(context);
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: DateContainer(
                context: context,
                label: S.of(context).endDate,
                dateText:
                    DateFormat('yyyy-MM-dd', 'en').format(_selectedEnfDate),
                onPressed: () async {
                  await _selectEndDate(context);
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 15, right: 15),
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !isPdfLoading,
                      child: ElevatedButton(
                        onPressed: () {
                          fetchForPdf(_selectedStartDate, _selectedEnfDate);
                        },
                        child: Text(
                          S.of(context).fetchData,
                          style: Styles.textStyle14.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: isPdfLoading
                          ? const SpinKitFoldingCube(
                              color: hBackgroundColor,
                              size: 35,
                            )
                          : //
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white),
                              onPressed: () {
                                if (pdfInventory.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          title: Text(S.of(context).noData));
                                    },
                                  );
                                } else {
                                  _generateAllSchoolsPdf();
                                }
                              },
                              child: Text(
                                S.of(context).generatePdf,
                                style: Styles.textStyle14.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: !isPdfLoading,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: () {
                          if (pdfInventory.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text(S.of(context).noData));
                              },
                            );
                          } else {
                            _generateAllSchoolsexcel();
                          }
                        },
                        child: Text(
                          S.of(context).generateExcelFile,
                          style: Styles.textStyle14.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Visibility(
                    //     visible: !isPdfLoading,
                    //     child: ElevatedButton(
                    //         onPressed: () async {
                    //           PdfForAll.gneratePrmoter(inventorySortList,
                    //               _selectedStartDate, _selectedEnfDate);
                    //         },
                    //         child: Text("All Promoter"))),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SchoolViewToEx(
                                    type: widget.type,
                                  )),
                        );
                      },
                      child: Text("عرض نقاط البيع ",
                          style: Styles.textStyle14.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
