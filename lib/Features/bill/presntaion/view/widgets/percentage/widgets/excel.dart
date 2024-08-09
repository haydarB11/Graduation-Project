import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../data/percentage_model.dart';

class ExcelGenerator {
  Future<void> generateAllSchoolsExcel(
      List<School> schools, DateTime startDate) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Add header row to the Excel sheet
      sheet.appendRow([
        'النسبة',
        'صافي الفاتورة',
        'الظرف',
        'العينات',
        'المرتجعات',
        'الفاتورة',
        'المنطقة',
        'اسم المندوب',
        'اسم السائق',
        'اسم المدرسة',
        'الرقم'
      ]);

      // Add data rows to the Excel sheet
      for (int index = 0; index < schools.length; index++) {
        final school = schools[index];

        // Calculate percentage value
        final percentageValue =
            (school.totals.toInt() - (school.totalPrice + school.spExpenses)) !=
                    0
                ? (school.sellPoints.first.envelopes.isNotEmpty
                        ? school.sellPoints.first.envelopes.first.cash
                        : 0) /
                    (school.totals.toInt() -
                        (school.totalPrice + school.spExpenses))
                : 0;

        sheet.appendRow([
          percentageValue.toStringAsFixed(2) + '%',
          (school.totals.toInt() - (school.totalPrice + school.spExpenses))
              .toString(),
          school.cash.toString() ?? '',
          school.spExpenses.toString(),
          school.totalPrice.toString(),
          school.totals.toString(),
          school.region,
          school.sellPoints.isNotEmpty
              ? school.sellPoints.first.promoter.nameAr
              : 'لايوجد مندوب',
          school.sellPoints.isNotEmpty
              ? school.sellPoints.first.driver.nameAr
              : 'لايوجد سائق',
          school.nameAr,
          (index + 1).toString(),
        ]);
      }

      // Get the application's support directory
      final fileBytes = excel.encode();
      final appDocDir = await getApplicationSupportDirectory();
      final formattedStartDate =
          startDate.toString().replaceAll(RegExp(r'[ :]+'), '_');
      final excelPath =
          '${appDocDir.path}/excel_percentage_in_$formattedStartDate.xlsx';
      final excelFile = File(excelPath);
      await excelFile.writeAsBytes(fileBytes!);

      // Open the generated Excel file
      final result = await OpenFile.open(excelPath);
    } catch (error) {
      // Handle any errors during Excel generation
      print('Error generating Excel: $error');
    }
  }
}
