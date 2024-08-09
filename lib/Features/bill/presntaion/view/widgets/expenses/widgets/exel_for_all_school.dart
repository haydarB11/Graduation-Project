import 'dart:io';

import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import '../data/niverntories_mode_pdf.dart';

class ExcelGeneratorAllSchool {
  static Future<void> generateExcelForAllExcel(
      List<InventoryData> all, DateTime startDate, DateTime endDate) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];
    const double customCellPadding = 2.0;
    var sd = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    var ed = DateFormat('yyyy-MM-dd', 'en').format(endDate);
    String Sd = '';
    if (sd == ed) {
      Sd = "تقرير الجرد في  $sd ";
    } else {
      Sd = "تقرير الجرد بين $sd -- $ed";
    }
    sheet.appendRow(
      [
        "اسم المدرسة",
        "اسم السائق",
        "اسم المندوب",
        'المجموع الكلي',
        'السعر الكلي',
      ],
    );
    for (var bill in all) {
      // ignore: avoid_single_cascade_in_expression_statements
      sheet.appendRow([
        bill.sellPoint.name,
        bill.sellPoint.driver.nameAr,
        bill.sellPoint.promoter.nameAr,
        bill.totalAmount.toStringAsFixed(0),
        bill.totalPrice.toStringAsFixed(0)
      ]);
      
      // sheet.appendRow([bill.sellPoint.driver.nameAr]);
      // sheet.appendRow([bill.sellPoint.promoter.nameAr]);
      // sheet.appendRow([bill.totalAmount.toStringAsFixed(0)]);
      // sheet.appendRow([bill.totalPrice.toStringAsFixed(0)]);
      // sheet.appendRow([
      //   'Category Name',
      //   'اسم الصنف',
      //   'عدد المرتجعات',
      // ]);

      // for (var category in bill.inventoryCategory) {
      //   num totalPrice = category.amount * category.category.price;
      //   sheet.appendRow([
      //     category.category.nameEn,
      //     category.category.nameAr,
      //     category.amount,
      //     totalPrice.toString()
      //   ]);
      // }
      // sheet.appendRow([""]);
      // sheet.appendRow([""]);
      // sheet.appendRow([""]);
      // sheet.appendRow([""]);
      // sheet.appendRow([""]);
    }
    final fileBytes = excel.encode();
    final appDocDir = await getApplicationSupportDirectory();
    final excelPath = '${appDocDir.path}/  $Sd.xlsx';
    final excelFile = File(excelPath);
    await excelFile.writeAsBytes(fileBytes!);
    final result = await OpenFile.open(excelPath);
  }
}
