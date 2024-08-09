import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

import '../data/inventories _model.dart';

class PdfGenerator {
  final List<SchoolBill> allBill;
  final DateTime selectedOneDate;
  final DateTime selectedTowDate;
  final String schoolName;

  PdfGenerator({
    required this.allBill,
    required this.selectedOneDate,
    required this.selectedTowDate,
    required this.schoolName,
  });

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
    List<String> categoryNamesAr = [];
    List<String> categoryNamesEn = [];
    List<num> amounts = [];
    List<num> spExpensesList = [];
    num totalPrice = 0;
    num totalExpenses = 0;
    for (var bill in allBill) {
      totalPrice += bill.totalPrice;
      totalExpenses += bill.totalExpenses;
      for (final category in bill.inventoryCategory) {
        categoryNamesAr.add(category.category?.nameAr ?? "اسم الصنف غير معروف");
        categoryNamesEn
            .add(category.category?.nameEn ?? 'Unknown Category Name');
        amounts.add(category.amount);
        spExpensesList.add(category.spExpenses);
      }
    }
    final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
    final String formatOneDate = formatter.format(selectedOneDate);
    final String formatTowDate = formatter.format(selectedTowDate);

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        build: (context) => [
          pw.Text(
            " الفواتير بين ",
            style: pw.TextStyle(
              font: pw.Font.ttf(ttfBold),
              fontSize: 12,
            ),
            textDirection: pw.TextDirection.rtl,
          ),
          pw.Text(
            "$formatOneDate -- $formatTowDate",
            style: pw.TextStyle(
              font: pw.Font.ttf(ttfBold),
              fontSize: 12,
            ),
            textDirection: pw.TextDirection.ltr,
          ),
          pw.Text(
            "اسم المدرسة: $schoolName",
            style: pw.TextStyle(
              font: pw.Font.ttf(ttfBold),
              fontSize: 12,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Table.fromTextArray(
            data: [
              [
                'Category Name',
                "اسم الصنف",
                'الكمية المتبقية',
              ],
              for (var i = 0; i < categoryNamesEn.length; i++)
                [
                  categoryNamesEn[i],
                  categoryNamesAr[i],
                  amounts[i].toInt(),
                ]
            ],
            headerStyle: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellStyle: pw.TextStyle(
              font: pw.Font.ttf(ttfBold),
              fontSize: 12,
            ),
            cellPadding: const pw.EdgeInsets.all(1),
          ),
          pw.SizedBox(height: 5),
          pw.Divider(),
          pw.Divider(),
          pw.Text(
            " مبلغ الكميات المتبقية الكلي: ${totalPrice.toStringAsFixed(2)}",
            style: pw.TextStyle(
              font: pw.Font.ttf(ttfBold),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
    final pdfBytes = await pdf.save();
    final appDocDir = await getApplicationSupportDirectory();
    final pdfPath =
        '${appDocDir.path}/تقرير المرتجعات و العينات  لمدرسة $schoolName.pdf';
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);

    final result = await OpenFile.open(pdfPath);

    print('School PDF generated and saved to: $pdfPath');
    // Now you can save the pdfBytes to a file or display it as needed.
  }
}
//*this old

  // Future<void> generatePDF(List<SchoolBill> allBill) async {
  //   final pdf = pw.Document();
  //   final ttfBold =
  //       await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
  //   List<String> categoryNamesAr = [];
  //   List<String> categoryNamesEn = [];
  //   List<num> amounts = [];
  //   List<num> spExpensesList = [];
  //   num totalPrice = 0;
  //   num totalExpenses = 0;
  //   for (var bill in allBill) {
  //     totalPrice = bill.totalPrice;
  //     totalExpenses = bill.totalExpenses;
  //     for (final category in bill.inventoryCategory) {
  //       categoryNamesAr.add(category.category?.nameAr ?? "اسم الصنف غير معروف");
  //       categoryNamesEn
  //           .add(category.category?.nameEn ?? 'Unknown Category Name');
  //       amounts.add(category.amount);
  //       spExpensesList.add(category.spExpenses);
  //     }
  //   }
  //   final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
  //   final String formatOneDate = formatter.format(_selectedOneDate);
  //   final String formatTowDate = formatter.format(_selectedTowDate);

  //   pdf.addPage(
  //     pw.MultiPage(
  //       textDirection: pw.TextDirection.rtl,
  //       build: (context) => [
  //         pw.Text(
  //           " الفواتير بين ",
  //           style: pw.TextStyle(
  //             font: pw.Font.ttf(ttfBold),
  //             fontSize: 12,
  //           ),
  //           textDirection: pw.TextDirection.rtl,
  //         ),
  //         pw.Text(
  //           "$formatOneDate -- $formatTowDate",
  //           style: pw.TextStyle(
  //             font: pw.Font.ttf(ttfBold),
  //             fontSize: 12,
  //           ),
  //           textDirection: pw.TextDirection.ltr,
  //         ),
  //         pw.Text(
  //           "اسم المدرسة: ${widget.name}",
  //           style: pw.TextStyle(
  //             font: pw.Font.ttf(ttfBold),
  //             fontSize: 12,
  //           ),
  //         ),
  //         pw.SizedBox(height: 5),
  //         pw.Table.fromTextArray(
  //           data: [
  //             ['Category Name', "اسم الصنف", 'عدد المرتجعات', 'عدد العينات'],
  //             for (var i = 0; i < categoryNamesEn.length; i++)
  //               [
  //                 categoryNamesEn[i],
  //                 categoryNamesAr[i],
  //                 amounts[i],
  //                 spExpensesList[i],
  //               ]
  //           ],
  //           headerStyle: pw.TextStyle(font: pw.Font.ttf(ttfBold)),
  //           headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
  //           cellStyle: pw.TextStyle(
  //             font: pw.Font.ttf(ttfBold),
  //             fontSize: 12,
  //           ),
  //           cellPadding: const pw.EdgeInsets.all(1),
  //         ),
  //         pw.SizedBox(height: 5),
  //         pw.Divider(),
  //         pw.Divider(),
  //         pw.Text(
  //           " مبلغ المرتجعات الكلي: ${totalPrice.toStringAsFixed(2)}",
  //           style: pw.TextStyle(
  //             font: pw.Font.ttf(ttfBold),
  //             fontSize: 12,
  //           ),
  //         ),
  //         pw.Text(
  //           "مبلع العينات الكلي: ${totalExpenses.toStringAsFixed(2)}",
  //           style: pw.TextStyle(
  //             font: pw.Font.ttf(ttfBold),
  //             fontSize: 12,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  //   final pdfBytes = await pdf.save();
  //   final appDocDir = await getApplicationSupportDirectory();
  //   final pdfPath =
  //       '${appDocDir.path}/تقرير المرتجعات و العينات  لمدرسة ${widget.name}.pdf';
  //   final pdfFile = File(pdfPath);
  //   await pdfFile.writeAsBytes(pdfBytes);

  //   // ignore: unused_local_variable
  //   final result = await OpenFile.open(pdfPath);

  //   print('School PDF generated and saved to: $pdfPath');
  //   // Now you can save the pdfBytes to a file or display it as needed.
  // }
