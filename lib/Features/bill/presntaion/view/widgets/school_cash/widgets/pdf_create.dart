import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PdfGenerator {
  final List<Map<String, dynamic>> categories;
  final double totalPrice;
  final String name;
  final DateTime selectedOneDate;
  final DateTime selectedTowDate;

  PdfGenerator({
    required this.categories,
    required this.totalPrice,
    required this.name,
    required this.selectedOneDate,
    required this.selectedTowDate,
  });

  Future<void> generateAndShowCategoryPDF() async {
    final pdf = pdfWidgets.Document();
    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
    // Define table headers
    final tableHeaders = ['التاريخ', 'العدد', 'السعر الاجمالي'];

    // Create a list of rows for the table
    final List<List> tableData = categories.map((category) {
      return [
        category['date'].toString().substring(0, 10),
        category['total_quantity'].toString(),
        category['total'].toString(),
      ];
    }).toList();
    var s1 = DateFormat('yyyy-MM-dd', 'en').format(selectedOneDate);
    var s2 = DateFormat('yyyy-MM-dd', 'en').format(selectedTowDate);
    pdf.addPage(pdfWidgets.MultiPage(
      textDirection: pdfWidgets.TextDirection.rtl,
      build: (context) => [
        pdfWidgets.Text(
          'حساب  : $name',
          style: pdfWidgets.TextStyle(
              fontSize: 18, font: pdfWidgets.Font.ttf(ttfBold)),
          textDirection: pdfWidgets.TextDirection.rtl,
        ),
        pdfWidgets.Text("$s1--$s2"),
        pdfWidgets.SizedBox(height: 20),
        pdfWidgets.Table.fromTextArray(
          context: context,
          headers: tableHeaders,
          headerStyle: pdfWidgets.TextStyle(
            font: pdfWidgets.Font.ttf(ttfBold),
          ),
          headerDecoration:
              const pdfWidgets.BoxDecoration(color: PdfColors.grey300),
          data: tableData,
          cellStyle: pdfWidgets.TextStyle(
            font: pdfWidgets.Font.ttf(ttfBold),
          ),
          border: pdfWidgets.TableBorder.all(width: 1),
          cellAlignment: pdfWidgets.Alignment.center,
          cellHeight: 30,
          cellAlignments: {
            0: pdfWidgets.Alignment.centerLeft,
            1: pdfWidgets.Alignment.center,
            2: pdfWidgets.Alignment.center,
          },
        ),
        pdfWidgets.Text(
          'المجموع الكلي :${totalPrice.toStringAsFixed(2)}', // Display the calculated total price
          style: pdfWidgets.TextStyle(
            fontSize: 16,
            font: pdfWidgets.Font.ttf(ttfBold),
          ),
          textDirection: pdfWidgets.TextDirection.rtl,
        ),
      ],
    ));

    // Save and view the PDF
    final pdfBytes = await pdf.save();
    final appDocDir = await getApplicationSupportDirectory();
    final pdfPath = '${appDocDir.path}/حساب $name  بين$s1-$s2.pdf';
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);
    final result = OpenFile.open(pdfPath);

    print('PDFs generated and saved to: $pdfPath');
  }
}
