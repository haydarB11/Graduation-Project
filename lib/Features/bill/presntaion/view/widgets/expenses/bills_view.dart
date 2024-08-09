import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shamseenfactory/Features/bill/utils.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'data/inventories _model.dart';
import 'widgets/excel.dart';
import 'widgets/pdf.dart';

class BillsEx extends StatefulWidget {
  int id;
  String name;
  BillsEx({required this.id, required this.name});

  @override
  State<BillsEx> createState() => _BillsExState();
}

class _BillsExState extends State<BillsEx> {
  @override
  void initState() {
    super.initState();
    _fetchSchoolBillData();
    print(widget.id);
  }

  DateTime _selectedOneDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _selectedTowDate = DateTime.now();
  bool isloading = false;
  List<SchoolBill> allbill = [];
  final ApiManager apiManager = ApiManager();
  Future<void> _selectOneDate(BuildContext context) async {
    final DateTime? picked =
        await DateSelect.selectDate(context, _selectedOneDate);
    if (picked != null && picked != _selectedOneDate) {
      if (picked.isAfter(_selectedTowDate)) {
        // ignore: use_build_context_synchronously
        DateConflictDialog.show(context, S.of(context).startAfterEnd);
      } else {
        setState(() {
          _selectedOneDate = picked;
        });
      }
    }
  }

  Future<void> _selectTowDate(BuildContext context) async {
    final DateTime? picked =
        await DateSelect.selectDate(context, _selectedTowDate);
    if (picked != null && picked != _selectedTowDate) {
      if (picked.isBefore(_selectedOneDate)) {
        // Show date conflict dialog and prevent fetching data
        // ignore: use_build_context_synchronously
        DateConflictDialog.show(context, S.of(context).startAfterEnd);
      } else {
        setState(() {
          _selectedTowDate = picked;
        });
      }
    }
  }

  Future<void> _fetchSchoolBillData() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    try {
      final List<SchoolBill> schoolBills = await apiManager.fetchSchoolBillData(
        _selectedOneDate,
        _selectedTowDate,
        widget.id,
      );
      if (mounted) {
        if (schoolBills != null) {
          setState(() {
            allbill = schoolBills;
            isloading = false;
          });
          print(allbill.length);
        } else {
          print("it is null");
          // Handle the case where the response data is null or not in the expected format.
          // You can show an error message or take appropriate action.
        }
      }
      // Handle schoolBills data here, e.g., update UI or state.
      print('Fetched school bill data: $schoolBills');
    } catch (e) {
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
      // Handle errors here, e.g., show an error message to the user.
      print('Error fetching school bill data: $e');
      print("i am in catch in bill view");
    }
  }

  Future<void> generateExcel(List<SchoolBill> allBill) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Headers
    sheet.appendRow([
      'Category Name',
      'اسم الصنف',
      'عدد المرتجعات',
      'عدد العينات',
    ]);
    num totalPrice = 0;
    num totalExpenses = 0;
    // Data
    for (var bill in allBill) {
      totalPrice = bill.totalPrice;
      totalExpenses = bill.totalExpenses;
      for (final category in bill.inventoryCategory) {
        sheet.appendRow([
          category.category?.nameEn ?? 'Unknown Category Name',
          category.category?.nameAr ?? 'اسم الصنف غير معروف',
          category.amount ?? 0,
          category.spExpenses ?? 0,
        ]);
      }
    }
    sheet.appendRow(["مبلغ المرتجعات الكلي", totalPrice]);
    sheet.appendRow(["مبلع العينات الكلي", totalExpenses]);
    final fileBytes = excel.encode();
    final appDocDir = await getApplicationSupportDirectory();
    final excelPath = '${appDocDir.path}/m.xlsx';
    final excelFile = File(excelPath);
    await excelFile.writeAsBytes(fileBytes!);

    // Step 8: Open the generated Excel file for viewing
    final result = OpenFile.open(excelPath);

    print('Excel file generated and saved.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: Styles.textStyle16,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateContainer(
              context: context,
              dateText: DateFormat('yyyy-MM-dd', 'en').format(_selectedOneDate),
              label: S.of(context).startDate,
              onPressed: () => _selectOneDate(context),
            ),
            const SizedBox(height: 10),
            DateContainer(
              context: context,
              dateText: DateFormat('yyyy-MM-dd', 'en').format(_selectedTowDate),
              label: S.of(context).endDate,
              onPressed: () => _selectTowDate(context),
            ),
            const SizedBox(height: 5),
            Center(
              child: ElevatedButton(
                onPressed: () => _fetchSchoolBillData(),
                child: Text(
                  S.of(context).fetchBills,
                  style: Styles.textStyle14,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (allbill.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            S.of(context).noData,
                            style: Styles.titleDialog,
                          ),
                        ),
                      );
                    } else {
                      final pdfGenerator = PdfGenerator(
                        allBill: allbill,
                        selectedOneDate: _selectedOneDate,
                        selectedTowDate: _selectedTowDate,
                        schoolName: widget.name,
                      );

                      await pdfGenerator.generatePDF();
                    }

                    // Optionally, you can add code here to handle the generated PDF, such as displaying it or saving it to a file.
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
                  onPressed: () async {
                    if (allbill.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            S.of(context).noData,
                            style: Styles.titleDialog,
                          ),
                        ),
                      );
                    } else {
                      await ExcelGenerator.generateExcel(allbill);
                    }

                    // Optionally, you can add code here to handle the generated PDF, such as displaying it or saving it to a file.
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
            ),
            const SizedBox(height: 5),
            DetailRow(
              label: "عدد الفواتير",
              value: allbill.length,
            ),
            isloading
                ? const Center(
                    child: SpinKitFoldingCube(
                      color: kActiveIconColor,
                      size: 35,
                    ),
                  )
                : allbill.isEmpty
                    ? Center(
                        child: Text(
                          S.of(context).noData,
                          style: Styles.textStyle14,
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const Divider(color: Colors.black, thickness: 4),
                          itemCount: allbill.length,
                          itemBuilder: (context, index) {
                            final schoolBill = allbill[index];
                            return Card(
                              elevation: 3,
                              color: hBackgroundColor,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          const EdgeInsets.all(deafultpadding),
                                      color: Colors.white,
                                      child: DetailRow(
                                          label: "Bill Id #",
                                          value: allbill[index].id),
                                    ),
                                    DetailRow(
                                      label: "مبلغ الكميات المتبقية الكلي:",
                                      value: schoolBill.totalPrice,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(S.of(context).invoicecategories,
                                        style: Styles.textStyle16),
                                    const SizedBox(height: 10),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          schoolBill.inventoryCategory.length,
                                      itemBuilder: (context, categoryIndex) {
                                        final category = schoolBill
                                            .inventoryCategory[categoryIndex];
                                        return Card(
                                          elevation: 2,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: ListTile(
                                            title: Text(
                                                '${S.of(context).category} ${categoryIndex + 1}:',
                                                style: Styles.textStyle14),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DetailRow(
                                                    label: S
                                                        .of(context)
                                                        .categoryName,
                                                    value: category
                                                            .category?.nameAr ??
                                                        'Unknown Category Name'),
                                                DetailRow(
                                                    label: "الكمية المتبقية:",
                                                    value: category.amount
                                                        .toInt()),
                                                DetailRow(
                                                    label: S
                                                        .of(context)
                                                        .totalpriceofsamples,
                                                    value: category
                                                        .calculateAmountTotalPrice()),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
