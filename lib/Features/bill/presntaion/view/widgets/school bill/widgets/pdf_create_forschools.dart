import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import '../data/school_bills_model.dart';

class PdfGeneratorOneSchool {
  final School school;
  final String driverName;
  final String promoterName;
  final DateTime selectedDate;

  PdfGeneratorOneSchool({
    required this.school,
    required this.driverName,
    required this.promoterName,
    required this.selectedDate,
  });

  Future<void> generateSchoolPdf() async {
    final pdf = pw.Document();
    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
    final List<String> tableHeaders = [
      'English Category Name',
      'الاسم',
      'الكمية',
      'السعر الكلي'
    ];

    final List<List<String>> tableData = [
      tableHeaders, // This is the header row
      for (var sellPoint in school.sellPoints)
        for (var bill in sellPoint.bills)
          for (var category in bill.billCategories)
            [
              category.category.nameEn,
              category.category.nameAr,
              category.amount.toString(),
              category.totalPrice.toString(),
            ],
    ];
    int totalQuantity = 0;
    int totalBillAmount = 0;
    var formattedDate = '';
    // Calculate the total quantity and total bill amount
    for (var sellPoint in school.sellPoints) {
      for (var bill in sellPoint.bills) {
        formattedDate = bill.date;
        if (formattedDate.isNotEmpty) {
          formattedDate = formattedDate.substring(0, 10);
        } else {
          formattedDate = '';
        }
        totalQuantity += bill.totalquantity;
        totalBillAmount += bill.total.toInt();
      }
    }

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'SHAMSEEN FOODSTUFF CATERING',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  font: pw.Font.ttf(ttfBold),
                ),
              ),
              pw.Text(
                'شمسين لخدمات التموين بالمواد الغذائية',
                style: pw.TextStyle(
                  fontSize: 14,
                  font: pw.Font.ttf(ttfBold),
                ),
                textDirection: pw.TextDirection.rtl,
              ),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Phone: 065384357',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'Fax: 065384357',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'TRN: 100334461900003',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
          pw.SizedBox(height: 10),

          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(school.nameAr,
                style: pw.TextStyle(fontSize: 12, font: pw.Font.ttf(ttfBold)),
                textDirection: pw.TextDirection.rtl),
            pw.Text(' ${school.nameEn}',
                style: pw.TextStyle(fontSize: 12, font: pw.Font.ttf(ttfBold))),
            pw.Center(
              child: pw.Text(
                "The Date: ${formattedDate.toString()}",
                style: pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 12),
              ),
            ),
          ]),
          pw.SizedBox(height: 5),
          pw.Table(
            border: null,
            columnWidths: {
              0: const pw.FlexColumnWidth(),
              1: const pw.FlexColumnWidth(),
              2: const pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Text('اسم السائق',
                      style:
                          pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 8),
                      textDirection: pw.TextDirection.rtl),
                  pw.Text(
                    'الموقع',
                    style:
                        pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 8),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.Text('اسم المندوب',
                      style:
                          pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 8),
                      textDirection: pw.TextDirection.rtl),
                ],
              ),

              // Driver, Region, and Promoter Info
              pw.TableRow(
                children: [
                  pw.Text(driverName,
                      style:
                          pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 8),
                      textDirection: pw.TextDirection.rtl),
                  pw.Text(school.region,
                      style:
                          pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 8),
                      textDirection: pw.TextDirection.rtl),
                  pw.Text(promoterName,
                      style:
                          pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 8),
                      textDirection: pw.TextDirection.rtl),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 3),

          pw.SizedBox(height: 5),
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
              ),
              cellPadding: const pw.EdgeInsets.all(0)),
          pw.SizedBox(height: 5),
          pw.Divider(),
          // Display the total_quantity and total as plain text
          if (school.sellPoints.isNotEmpty)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'Total Quantity: $totalQuantity',
                  style: pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 15),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.Text(
                  'Total price: $totalBillAmount',
                  style: pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 15),
                  textDirection: pw.TextDirection.rtl,
                ),
              ],
            ),
        ],
      ),
    );
    final pdfBytes = await pdf.save();
    final appDocDir = await getApplicationSupportDirectory();
    final pdfPath =
        '${appDocDir.path}/pdf_for_${school.nameEn}_$formattedDate.pdf';
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);
    final result = OpenFile.open(pdfPath);

    print('PDFs generated and saved to: $pdfPath');
  }
}
