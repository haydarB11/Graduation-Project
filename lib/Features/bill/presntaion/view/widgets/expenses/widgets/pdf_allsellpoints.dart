import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import '../data/niverntories_mode_pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PdfForAll {
  static Future<void> generatePdf(List<InventoryData> inventoryData,
      DateTime startDate, DateTime endDate) async {
    final pdf = pw.Document();
    const double customCellPadding = 2.0;
    var sd = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    var ed = DateFormat('yyyy-MM-dd', 'en').format(endDate);
    String Sd = '';
    if (sd == ed) {
      Sd = "تقرير الجرد في  $sd ";
    } else {
      Sd = "تقرير الجرد بين $sd -- $ed";
    }
    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
    for (var element in inventoryData) {
      final promoterName = element.sellPoint.promoter.nameAr;
      final driverName = element.sellPoint.driver.nameAr;
      final sellPointName = element.sellPoint.name;
      final totalprice = element.totalPrice;
      final total_amount = element.totalAmount;
      final List<String> tableHeaders = [
        'English Category Name',
        'الاسم',
        'الكمية',
        'السعر الكلي'
      ];
      final List<List<String>> tableData = [
        tableHeaders,
        for (var category in element.inventoryCategory)
          [
            category.category.nameEn,
            category.category.nameAr,
            category.amount.toString(),
            ((category.category.price) * (category.amount)).toStringAsFixed(2)
          ]
      ];

      // Create a PDF page
      pdf.addPage(pw.MultiPage(
          textDirection: pw.TextDirection.rtl,
          build: (pw.Context context) => [
                pw.Center(
                  child: pw.Text("فاتورة الجرد",
                      style: pw.TextStyle(
                          fontSize: 10, font: pw.Font.ttf(ttfBold))),
                ),
                pw.Center(
                    child: pw.Text(Sd,
                        style: pw.TextStyle(
                            fontSize: 10, font: pw.Font.ttf(ttfBold)))),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(children: [
                        pw.Text(
                          "اسم المدرسة: ${sellPointName}",
                          style: pw.TextStyle(
                              fontSize: 10, font: pw.Font.ttf(ttfBold)),
                        ),
                        pw.Text("القيمةالاجمالية : ${totalprice}",
                            style: pw.TextStyle(
                                fontSize: 10, font: pw.Font.ttf(ttfBold))),
                        pw.Text("العدد الاجمالي : ${total_amount}",
                            style: pw.TextStyle(
                                fontSize: 10, font: pw.Font.ttf(ttfBold))),
                      ]),
                      pw.Column(children: [
                        pw.Text("اسم السائق : ${driverName}",
                            style: pw.TextStyle(
                                fontSize: 10, font: pw.Font.ttf(ttfBold))),
                        pw.Text("اسم المندوب : ${promoterName}",
                            style: pw.TextStyle(
                                fontSize: 10, font: pw.Font.ttf(ttfBold)))
                      ])
                    ]),
                pw.Table.fromTextArray(
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
                    ))
              ]));
    }
    {
      // Generate the PDF as a Uint8List
      final pdfBytes = await pdf.save();
      final appDocDir = await getApplicationSupportDirectory();
      final pdfPath = '${appDocDir.path}/$Sd .pdf';
      final pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(pdfBytes);

      final result = await OpenFile.open(pdfPath);

      print('School PDF generated and saved to: $pdfPath');
    }
  }

  static Future<void> gneratePrmoter(List<InventoryData> allprmoter,
      DateTime startDate, DateTime endDate) async {
    const double customCellPadding = 2.0;
    var sd = DateFormat('yyyy-MM-dd', 'en').format(startDate);
    var ed = DateFormat('yyyy-MM-dd', 'en').format(endDate);
    String Sd = '';
    if (sd == ed) {
      Sd = "تقرير الجرد في  $sd ";
    } else {
      Sd = "تقرير الجرد بين $sd -- $ed";
    }
    final promoterMap = <int, List<InventoryData>>{};
    for (var data in allprmoter) {
      final promoterId = data.sellPoint.promoter.id;

      if (!promoterMap.containsKey(promoterId)) {
        promoterMap[promoterId] = [];
      }
      promoterMap[promoterId]?.add(data);
    }
    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
    for (var promoterId in promoterMap.keys) {
      final pdf = pw.Document();
      final promoterInventory = promoterMap[promoterId];
      final promoterName =
          promoterInventory?[0].sellPoint.promoter.nameAr; // Get promoter name

      pdf.addPage(pw.MultiPage(
          textDirection: pw.TextDirection.rtl,
          build: (pw.Context context) => [
                pw.Table.fromTextArray(
                  data: <List<String>>[
                    <String>['', "اسم المدرسة'", "اسم المندوب", 'الجرد'],
                    ...promoterInventory!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final element = entry.value;
                      final totalprice = element.totalPrice.toStringAsFixed(2);
                      final promoterName = element.sellPoint.promoter.nameAr;
                      final sellPointName = element.sellPoint.name;
                      final n = (index + 1).toString();
                      return [n, sellPointName, promoterName, totalprice];
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
                  // columnWidths: columnWidths,
                  tableWidth: pw.TableWidth.max,
                )
              ]));
      final pdfBytes = await pdf.save();
      final appDocDir = await getApplicationSupportDirectory();
      final pdfPath = '${appDocDir.path}/Promoter$promoterName$Sd .pdf';
      final pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(pdfBytes);

      final result = await OpenFile.open(pdfPath);

      print('School $promoterId PDF generated and saved to: $pdfPath');
    }
  }
}
