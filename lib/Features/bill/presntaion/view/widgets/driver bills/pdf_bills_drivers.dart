import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import 'driver_bills.dart';
import 'driver_model.dart';

class PDFGenerator {
  final List<Driver> drivers;

  PDFGenerator(this.drivers);

  Future<void> generate() async {
    final pdf = pw.Document();
    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');

    // Define a custom TextStyle with increased font size
    final cellTextStyle = pw.TextStyle(
      font: pw.Font.ttf(ttfBold),
      fontSize: 16, // Adjust the font size as needed
    );

    for (final driver in drivers) {
      final List<String> tableHeaders = ['الاسم', 'الكمية', 'السعر الكلي'];
      final List<List<String>> tableData = [
        tableHeaders, // This is the header row
        for (var sellPoint in driver.sellPoints)
          for (var bill in sellPoint.bills)
            for (var category in bill.billCategories)
              [
                category.category.nameAr,
                category.amount.toString(),
                category.totalPrice.toString(),
              ],
      ];
      pdf.addPage(
        pw.MultiPage(
          textDirection: pw.TextDirection.rtl,
          build: (context) => [
            pw.Text('Driver Name: ${driver.nameAr}',
                style: pw.TextStyle(font: pw.Font.ttf(ttfBold))),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(),
              data: tableData,
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                font: pw.Font.ttf(ttfBold),
                fontSize: 12,
              ),
              cellAlignment: pw.Alignment.center,
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellStyle: pw.TextStyle(
                font: pw.Font.ttf(ttfBold),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    final pdfBytes = await pdf.save();
    final appDocDir = await getApplicationSupportDirectory();
    final pdfPath = '${appDocDir.path}/all_driver_bills.pdf';
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);

    final result = await OpenFile.open(pdfPath);

    print('All Schools PDF generated and saved to: $pdfPath');
  }
}
