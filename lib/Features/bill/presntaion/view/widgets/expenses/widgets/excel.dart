import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';

import '../data/inventories _model.dart';

class ExcelGenerator {
  static Future<void> generateExcel(List<SchoolBill> allBill) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Headers
    sheet.appendRow([
      'Category Name',
      'اسم الصنف',
      'عدد المرتجعات',
    ]);
    num totalPrice = 0;
    num totalExpenses = 0;
    // Data
    for (var bill in allBill) {
      totalPrice += bill.totalPrice;
      totalExpenses += bill.totalExpenses;
      for (final category in bill.inventoryCategory) {
        sheet.appendRow([
          category.category?.nameEn ?? 'Unknown Category Name',
          category.category?.nameAr ?? 'اسم الصنف غير معروف',
          category.amount ?? 0,
        ]);
      }
    }
    sheet.appendRow(["مبلغ الكميات المتبقية الكلي", totalPrice]);

    final fileBytes = excel.encode();
    final appDocDir = await getApplicationSupportDirectory();
    final excelPath = '${appDocDir.path}/m.xlsx';
    final excelFile = File(excelPath);
    await excelFile.writeAsBytes(fileBytes!);

    // Step 8: Open the generated Excel file for viewing
    final result = await OpenFile.open(excelPath);

    print('Excel file generated and saved.');
  }
}
