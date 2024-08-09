import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/cheack_model.dart';
import 'package:intl/intl.dart';

class GnerateCheackPdf {
  static Future<void> generatePdf(
      List<SchoolData> allBills, DateTime date, String name) async {
    final pdf = pw.Document(
      pageMode: PdfPageMode.fullscreen,
    );
    var dateF = DateFormat('yyyy-MM-dd', 'en').format(date);
    const double customCellPadding = 2.0;
    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
    final columnWidths = <int, pw.TableColumnWidth>{
      // Define your column widths here as before
      0: const pw.FixedColumnWidth(
          60), // Increase the width of the first column to 150 points
      // 1: const pw.FixedColumnWidth(100), // Width of the second column
      // 2: const pw.FixedColumnWidth(160), // Width of the third column
      // 3: const pw.FixedColumnWidth(100), // Width of the third column
      // 4: const pw.FixedColumnWidth(160), // Width of the third column
      // 5: const pw.FixedColumnWidth(140), // Width of the third column
      // 6: const pw.FixedColumnWidth(100), // Width of the third column
      // 7: const pw.FixedColumnWidth(120), // Width of the third column
      // 8: const pw.FixedColumnWidth(100), // Width of the third column
      // 9: const pw.FixedColumnWidth(120),
      // 10: const pw.FixedColumnWidth(400),
    };
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat(
        842.0,
        595.0,
        marginAll: 2.0,
      ),
      textDirection: pw.TextDirection.rtl,
      build: (context) => [
        pw.Table.fromTextArray(
          data: <List<String>>[
            <String>[
              'فرق',
              "ستور السبت",
              "قيمة الجرد الحالي",
              "تاريخ الجرد الحالي",
              "قيمة الظرف",
              "مناقلة مرسلة",
              "الحالات الاقتصادية",
              "عينات المشرف",
              "قيمة عينات الطبيب",
              "قيمة عينات الادارة",
              "قيمة المرتجعات",
              'قيمة الفاتورة',
              "مناقلة مستقبلة",
              "فواتير خارجية",
              "فواتير الستور",
              "تاريخ الجرد السابق",
              "قيمة الجرد السابق",
              " السائق",
              " المندوب",
              ' المدرسة',
            ],
            //Data Rows
            ...allBills.mapIndexed((index, element) {
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
              final externalBills = element.externalBill;
              final DoctorExpens = element.doctorReturns;
              final mangerExpenses = element.mangerReturns;
              final driverName = element.driver;
              final sentBills = element.sentBills;
              final receivedBills = element.receivedBills;
              final expensesTotal = element.expenses;
              final billTotal = element.bill;
              final cashTotal = element.cash;
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
              return [
                differenceTotal.toStringAsFixed(0),
                satstore.toStringAsFixed(0), // bill saturday
                currentTotal.toStringAsFixed(0),
                currentDateFormat,
                cashTotal.toStringAsFixed(0),
                sentBills.toStringAsFixed(0),
                ecstate.toStringAsFixed(0), //eco state
                expensesTotal.toStringAsFixed(0),
                DoctorExpens.toStringAsFixed(0),
                mangerExpenses.toStringAsFixed(0),
                returnsTotal.toStringAsFixed(0), //! returnss
                billTotal.toStringAsFixed(0),
                receivedBills.toStringAsFixed(0),
                externalBills.toStringAsFixed(0),
                storeBills.toStringAsFixed(0),
                previousDateFormat,
                previousTotal.toStringAsFixed(0),
                driverName,
                promoterName,
                schoolName,
              ];
            })
          ],
          headerStyle: pw.TextStyle(
            font: pw.Font.ttf(ttfBold),
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
          ),
          cellStyle: pw.TextStyle(
            font: pw.Font.ttf(ttfBold),
            fontSize: 8,

            // fontWeight: pw.FontWeight.bold,
          ),
          cellAlignment: pw.Alignment.center,
          border: pw.TableBorder.all(
            color: PdfColors.black,
            width: 0.5,
          ),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          cellPadding: const pw.EdgeInsets.all(5),
          rowDecoration: const pw.BoxDecoration(),
          columnWidths: columnWidths,
          tableWidth: pw.TableWidth.max,
        ),
      ],
    ));

    final pdfBytes = await pdf.save();
    final appDocDir = await getApplicationSupportDirectory();
    final pdfPath = '${appDocDir.path}/  $name تقرير التحقق من النسب.pdf';
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);

    final result = await OpenFile.open(pdfPath);
  }
//Cash:ظرف
// Bill:فاتورك
// Exoen:غينات
// Returns مرتج
}
