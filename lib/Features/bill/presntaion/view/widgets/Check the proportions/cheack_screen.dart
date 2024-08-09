import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:intl/intl.dart';

import '../../../../../../constants.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../utils.dart';
import 'data/cheack_api.dart';
import 'data/cheack_model.dart';
import 'widgets/cheack_excel.dart';
import 'widgets/cheack_pdf.dart';

class CheackScreen extends StatefulWidget {
  const CheackScreen({super.key});

  @override
  State<CheackScreen> createState() => _CheackScreenState();
}

class _CheackScreenState extends State<CheackScreen> {
  DateTime endDay = DateTime.now();

  DateTime startDay = DateTime.now().subtract(const Duration(days: 1));
  bool isloading = false;
  List<SchoolData> allBills = [];
  List<SchoolData> IncorrectBills = [];
  List<SchoolData> correctBills = [];
  List<SchoolData> plusBills = [];
  Future<void> selectDateF(BuildContext context) async {
    try {
      final DateTime? picked = await DateSelect.selectDate(context, startDay);
      if (picked != null && picked != startDay) {
        if (mounted) {
          setState(() {
            startDay = picked;
            // _fetchBill().then((value) {
            //   IncorrectBills.clear();
            //   correctBills.clear();
            //   plusBills.clear();
            //   _incorrectinvoices(allBills);
            //   _plussinvoices(allBills);
            //   _correctinvoices(allBills);
            // });
          });
        }
      }
    } catch (e) {
      // Handle any errors that occur during date selection, such as user cancellation.
      print('Error selecting date: $e');
    }
  }

  Future<void> selectDateE(BuildContext context) async {
    try {
      final DateTime? picked = await DateSelect.selectDate(context, endDay);
      if (picked != null && picked != endDay) {
        if (mounted) {
          setState(() {
            endDay = picked;
            // _fetchBill().then((value) {
            //   IncorrectBills.clear();
            //   correctBills.clear();
            //   plusBills.clear();
            //   _incorrectinvoices(allBills);
            //   _plussinvoices(allBills);
            //   _correctinvoices(allBills);
            // });
          });
        }
      }
    } catch (e) {
      // Handle any errors that occur during date selection, such as user cancellation.
      print('Error selecting date: $e');
    }
  }

  Future<void> _fetchBill() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    try {
      final List<SchoolData> bills = await Api.fetchData(startDay, endDay);
      if (mounted) {
        if (bills != null) {
          setState(() {
            allBills = bills;
            isloading = false;
          });
        } else {
          print("it is null");
          // Handle the case where the response data is null or not in the expected format.
          // You can show an error message or take appropriate action.
        }
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      print(e);
    }
  }

  Future<void> _getBills() async {
    if (startDay.isAfter(endDay)) {
      DateConflictDialog.show(context, S.of(context).startAfterEnd);
    } else {
      await _fetchBill().then((value) {
        IncorrectBills.clear();
        correctBills.clear();
        plusBills.clear();
        _incorrectinvoices(allBills);
        _plussinvoices(allBills);
        _correctinvoices(allBills);
      });
    }
  }

  Future<void> _incorrectinvoices(List<SchoolData> allbills) async {
    for (var element in allbills) {
      if (element.difference < 0) {
        IncorrectBills.add(element);
      }
    }
    print(" this Incorrect : ${IncorrectBills.length}");
  }

  Future<void> _plussinvoices(List<SchoolData> allbills) async {
    for (var element in allbills) {
      if (element.difference > 0) {
        plusBills.add(element);
      }
    }
    print("Plus bills:${plusBills.length}");
  }

  Future<void> _correctinvoices(List<SchoolData> allbills) async {
    for (var element in allbills) {
      if (element.difference == 0) {
        correctBills.add(element);
      }
    }
    print(" this correct:${correctBills.length}");
  }

  @override
  void initState() {
    super.initState();
    // _fetchBill().then((value) {
    //   _incorrectinvoices(allBills);
    //   _plussinvoices(allBills);
    //   _correctinvoices(allBills);
    //   print(" this Incorrect${IncorrectBills.length}");
    //   print(" this correct${correctBills.length}");
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          S.of(context).check,
          style: Styles.textStyle18,
        ),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DateContainer(
            context: context,
            dateText: DateFormat('yyyy-MM-dd', 'en').format(startDay),
            label: S.of(context).selectDate,
            onPressed: () => selectDateF(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DateContainer(
            context: context,
            dateText: DateFormat('yyyy-MM-dd', 'en').format(endDay),
            label: S.of(context).selectDate,
            onPressed: () => selectDateE(context),
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              await _getBills();
            },
            child: Text(S.of(context).fetchBills,
                style: Styles.textStyle14.copyWith(color: Colors.grey))),
        Container(
          margin:
              const EdgeInsets.only(top: 10, bottom: 0, left: 15, right: 15),
          height: 300,
          width: 400,
          decoration: const BoxDecoration(
              color: hBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: isloading
              ? Center(
                  child: SpinKitSpinningLines(
                    size: 35,
                    color: Colors.white,
                  ),
                )
              : allBills.isEmpty
                  ? Center(
                      child: Text(
                        S.of(context).noData,
                        style: Styles.textStyle20.copyWith(color: Colors.white),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  await GnerateCheackPdf.generatePdf(
                                      allBills, startDay, "كل الفواتير");
                                },
                                child: Text("كل الفواتير",
                                    style: Styles.textStyle14
                                        .copyWith(color: Colors.grey))),
                            const SizedBox(
                              height: 5,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  await GnerateCheackPdf.generatePdf(
                                      IncorrectBills, startDay, "النواقص");
                                },
                                child: Text(
                                  "الفواتير غير الصحيحة",
                                  style: Styles.textStyle14
                                      .copyWith(color: Colors.grey),
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (correctBills.isNotEmpty) {
                                    await GnerateCheackPdf.generatePdf(
                                        correctBills, startDay, "الصحيحة");
                                  } else {
                                    NoData.showNoData(context);
                                  }
                                },
                                child: Text(
                                  "الفواتير الصحيحة",
                                  style: Styles.textStyle14
                                      .copyWith(color: Colors.grey),
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (plusBills.isNotEmpty) {
                                    await GnerateCheackPdf.generatePdf(
                                        plusBills, startDay, "الزوائد");
                                  } else {
                                    NoData.showNoData(context);
                                  }
                                },
                                child: Text(
                                  "الفواتير الزائدة",
                                  style: Styles.textStyle14
                                      .copyWith(color: Colors.grey),
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (allBills.isNotEmpty) {
                                    try {
                                      await ExcelGenerator.generateExcel(
                                        allBills,
                                      );
                                    } on Exception catch (e) {
                                      print(e);
                                      // TODO
                                    }
                                  } else {
                                    NoData.showNoData(context);
                                  }
                                },
                                child: Text(
                                  "Excel",
                                  style: Styles.textStyle14
                                      .copyWith(color: Colors.grey),
                                )),
                          ]),
                    ),
        )
      ]),
    );
  }
}
//  showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: Text(
//                             S.of(context).noData,
//                             style: Styles.titleDialog,
//                           ),
//                         ),
//                       );