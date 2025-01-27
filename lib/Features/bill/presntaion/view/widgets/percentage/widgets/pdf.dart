import 'dart:io';
import 'package:dartx/dartx.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../data/percentage_model.dart';

class PdfGenerator {
  Future<void> generatePdfReport(
      List<School> schools, DateTime startDate, DateTime endDate) async {
    var sd = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    var ed = DateFormat('yyyy-MM-dd', 'en').format(endDate);
    String Sd = '';
    if (sd == ed) {
      Sd = "تقرير النسب في  $sd ";
    } else {
      Sd = "تقرير النسب بين $sd -- $ed";
    }

    final pdf = pw.Document();
    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
    final columnWidths = <int, pw.TableColumnWidth>{
      // Define your column widths here as before
      0: const pw.FixedColumnWidth(
          180), // Increase the width of the first column to 150 points
      1: const pw.FixedColumnWidth(200), // Width of the second column
      2: const pw.FixedColumnWidth(200), // Width of the third column
      3: const pw.FixedColumnWidth(200), // Width of the third column
      4: const pw.FixedColumnWidth(250), // Width of the third column
      5: const pw.FixedColumnWidth(200), // Width of the third column
      6: const pw.FixedColumnWidth(210), // Width of the third column
      7: const pw.FixedColumnWidth(210), // Width of the third column
      8: const pw.FixedColumnWidth(210), // Width of the third column
      9: const pw.FixedColumnWidth(480),
      10: const pw.FixedColumnWidth(160) // Width of the third column
      // Add more columns and widths as needed
    };

    pdf.addPage(pw.MultiPage(
      textDirection: pw.TextDirection.rtl,
      build: (context) => [
        pw.Header(
          level: 0,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                Sd,
                style: pw.TextStyle(
                  font: pw.Font.ttf(ttfBold),
                  fontSize: 18,
                ),
              ),
              pw.Text(
                "تقرير النسب في تاريخ",
                style: pw.TextStyle(
                  font: pw.Font.ttf(ttfBold),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
            context: context,
            data: <List<String>>[
              // Header row
              <String>[
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
              ],
              // Data rows
              ...schools.mapIndexed((index, school) {
                try {
                  final sellPoints = school.sellPoints;
                  if (sellPoints.isNotEmpty) {
                    final cash = school.cash;
                    final totals = school.totals;
                    final totalPrice = school.totalPrice;
                    final spExpenses = school.spExpenses;

                    final percentageValue =
                        (totals.toInt() - (totalPrice + spExpenses)) != 0
                            ? (cash /
                                    (totals.toInt() -
                                        (totalPrice + spExpenses))) *
                                100
                            : 0;

                    final formattedPercentage =
                        '${percentageValue.toStringAsFixed(2)}%';

                    return <String>[
                      formattedPercentage,
                      (totals.toInt() - (totalPrice + spExpenses)).toString(),
                      cash.toString(),
                      spExpenses.toString(),
                      totalPrice.toString(),
                      totals.toString(),
                      school.region,
                      school.sellPoints.first.promoter.nameAr,
                      school.sellPoints.first.driver.nameAr,
                      school.nameAr,
                      (index + 1).toString(),
                    ];
                  }

                  // Handle the case where necessary data is missing
                  return <String>[
                    "0", // Placeholder for percentage
                    (school.totals.toInt() -
                            (school.totalPrice + school.spExpenses))
                        .toString(),
                    "0", // Placeholder for 'الظرف'
                    school.spExpenses.toString(), // Placeholder for 'العينات'
                    school.totalPrice.toString(), // Placeholder for 'المرتجعات'
                    school.totals.toString(), // Placeholder for 'الفاتورة'
                    school.region,
                    school.sellPoints.isNotEmpty
                        ? school.sellPoints.first.promoter.nameAr
                        : 'لايوجد مندوب', // Placeholder for promoter name
                    school.sellPoints.isNotEmpty
                        ? school.sellPoints.first.driver.nameAr
                        : 'لايوجد سائق', // Placeholder for driver name
                    school.nameAr,
                    (index + 1).toString(),
                  ];
                } catch (e) {
                  // Handle any other errors that may occur during calculation
                  print('Error calculating percentage: $e');
                  // Return a row with placeholder values in case of an error
                  return <String>[
                    'Error', // Placeholder for percentage in case of an error
                    'N/A', // Placeholder for 'صافي الفاتورة'
                    'N/A', // Placeholder for 'الظرف'
                    'N/A', // Placeholder for 'العينات'
                    'N/A', // Placeholder for 'المرتجعات'
                    'N/A', // Placeholder for 'الفاتورة'
                    school.region,
                    school.sellPoints.isNotEmpty
                        ? school.sellPoints.first.promoter.nameAr
                        : 'N/A', // Placeholder for promoter name
                    school.sellPoints.isNotEmpty
                        ? school.sellPoints.first.driver.nameAr
                        : 'N/A', // Placeholder for driver name
                    school.nameAr,
                    (index + 1).toString(),
                  ];
                }
              }),
            ],
            headerStyle: pw.TextStyle(
              font: pw.Font.ttf(ttfBold),
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: pw.TextStyle(
              fontSize: 8,
              font: pw.Font.ttf(ttfBold),
            ),
            cellAlignment: pw.Alignment.center,
            border: pw.TableBorder.all(
              color: PdfColors.black,
              width: 0.5,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            rowDecoration: const pw.BoxDecoration(),
            columnWidths: columnWidths,
            tableWidth: pw.TableWidth.max,
            cellPadding: const pw.EdgeInsets.all(5))
        // Other table properties as before
      ],
    ));

    // Save the PDF to a file
    final pdfBytes = await pdf.save();
    final appDocDir = await getApplicationSupportDirectory();
    final pdfPath = '${appDocDir.path}/تقرير النسب_.pdf';
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);

    // Open the PDF file
    final result = await OpenFile.open(pdfPath);
  }
}
