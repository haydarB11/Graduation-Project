import 'dart:io';

import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/Check%20the%20proportions/data/cheack_model.dart';

class ExcelGenerator {
  static Future<void> generateExcel(List<SchoolData> allBills) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];
    sheet.appendRow([
      'الفرق',
      "الحالات الاقتصادية",
      "فواتير الستور",
      "ستور السبت",
      "قيمة الجرد الحالي",
      "تاريخ الجرد الحالي",
      "قيمة الجرد السابق",
      "تاريخ الجرد السابق",
      "قيمة المرتجعات",
      "قيمة عينات الادارة",
      "قيمة عينات الطبيب",
      " عينات المشرف",
      "مناقلة مستقبلة",
      "مناقلة مرسلة",
      "فواتير خارجية",
      'قيمة الفاتورة',
      "قيمة الظرف",
      "اسم السائق",
      "اسم المندوب",
      'اسم المدرسة',
    ]);
    for (var element in allBills) {
      final differenceTotal = element.difference;
      final ecstate = element.ex_eco;
      final storeBills = element.store;
      final satstore = element.storeSat;
      final currentTotal = element.currentInventoryTotal;

      final currentDate = element.currentInventoryDate;
      final currentDateFormat;
      final previousTotal = element.previousInventoryTotal;
      final previousDate = element.previousInventoryDate;
      final previousDateFormat;
      final returnsTotal = element.returns;
      final DoctorExpens = element.doctorReturns;
      final mangerExpenses = element.mangerReturns;

      final expensesTotal = element.expenses;
      final externalBills = element.externalBill;
      final sentBills = element.sentBills;
      final receivedBills = element.receivedBills;
      final billTotal = element.bill;
      final cashTotal = element.cash;
      final driverName = element.driver;
      final promoterName = element.promoter;
      final schoolName = element.schoolName;
      if (currentDate.isNotEmpty) {
        currentDateFormat = currentDate.substring(0, 10);
      } else {
        currentDateFormat = '';
      }
      if (previousDate.isNotEmpty) {
        previousDateFormat = previousDate.substring(0, 10);
      } else {
        previousDateFormat = '';
      }
      sheet.appendRow([
        differenceTotal.toStringAsFixed(0),
        ecstate.toStringAsFixed(0),
        storeBills.toStringAsFixed(0),
        satstore.toStringAsFixed(0),
        currentTotal.toStringAsFixed(0),
        currentDateFormat,
        previousTotal.toStringAsFixed(0),
        previousDateFormat,
        returnsTotal.toStringAsFixed(0),
        mangerExpenses.toStringAsFixed(0),
        DoctorExpens.toStringAsFixed(0),
        expensesTotal.toStringAsFixed(0),
        receivedBills.toStringAsFixed(0),
        sentBills.toStringAsFixed(0),
        externalBills.toStringAsFixed(0),
        billTotal.toStringAsFixed(0),
        cashTotal.toStringAsFixed(0),
        driverName,
        promoterName,
        schoolName,
      ]);
    }
    final fileBytes = excel.encode();
    final appDocDir = await getApplicationSupportDirectory();
    final excelPath = '${appDocDir.path}/تقرير التحقق من النسب.xlsx';
    final excelFile = File(excelPath);
    await excelFile.writeAsBytes(fileBytes!);

    // Step 8: Open the generated Excel file for viewing
    final result = await OpenFile.open(excelPath);

    print('Excel file generated and saved.');
  }
}
