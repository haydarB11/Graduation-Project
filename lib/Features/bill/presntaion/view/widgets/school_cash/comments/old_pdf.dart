// void _generateAndShowCategoryPDF(
//       List<Map<String, dynamic>> categories, double totalPrice) async {
//     final pdf = pdfWidgets.Document();
//     final ttfBold =
//         await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
//     // Define table headers
//     final tableHeaders = ['الصنف', 'العدد', 'السعر الاجمالي'];

//     // Create a list of rows for the table
//     final List<List> tableData = categories.map((category) {
//       return [
//         category['name_ar'],
//         category['count'].toString(),
//         category['category_total_price'].toString(),
//       ];
//     }).toList();
//     var s1 = DateFormat('yyyy-MM-dd', 'en').format(_selectedOneDate);
//     var s2 = DateFormat('yyyy-MM-dd', 'en').format(_selectedTowDate);
//     pdf.addPage(pdfWidgets.MultiPage(
//       textDirection: pdfWidgets.TextDirection.rtl,
//       build: (context) => [
//         pdfWidgets.Text(
//           'حساب  : ${widget.name}',
//           style: pdfWidgets.TextStyle(
//               fontSize: 18, font: pdfWidgets.Font.ttf(ttfBold)),
//           textDirection: pdfWidgets.TextDirection.rtl,
//         ),
//         pdfWidgets.Text("$s1--$s2"),
//         pdfWidgets.SizedBox(height: 20),
//         pdfWidgets.Table.fromTextArray(
//           context: context,
//           headers: tableHeaders,
//           headerStyle: pdfWidgets.TextStyle(
//             font: pdfWidgets.Font.ttf(ttfBold),
//           ),
//           headerDecoration:
//               const pdfWidgets.BoxDecoration(color: PdfColors.grey300),
//           data: tableData,
//           cellStyle: pdfWidgets.TextStyle(
//             font: pdfWidgets.Font.ttf(ttfBold),
//           ),
//           border: pdfWidgets.TableBorder.all(width: 1),
//           cellAlignment: pdfWidgets.Alignment.center,
//           cellHeight: 30,
//           cellAlignments: {
//             0: pdfWidgets.Alignment.centerLeft,
//             1: pdfWidgets.Alignment.center,
//             2: pdfWidgets.Alignment.center,
//           },
//         ),
//         pdfWidgets.Text(
//           'المجموع الكلي :${totalPrice.toStringAsFixed(2)}', // Display the calculated total price
//           style: pdfWidgets.TextStyle(
//             fontSize: 16,
//             font: pdfWidgets.Font.ttf(ttfBold),
//           ),
//           textDirection: pdfWidgets.TextDirection.rtl,
//         ),
//       ],
//     ));

//     // Save and view the PDF
//     final pdfBytes = await pdf.save();
//     final appDocDir = await getApplicationSupportDirectory();
//     final pdfPath = '${appDocDir.path}/حساب ${widget.name}  بين$s1-$s2.pdf';
//     final pdfFile = File(pdfPath);
//     await pdfFile.writeAsBytes(pdfBytes);
//     final result = OpenFile.open(pdfPath);

//     print('PDFs generated and saved to: $pdfPath');
//   }
