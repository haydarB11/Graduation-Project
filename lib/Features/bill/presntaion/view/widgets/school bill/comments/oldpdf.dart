//  Future<void> generateAllSchoolsPdf(List<School> schools) async {
//     const double customCellPadding = 2.0;
//     final pdf = pw.Document();
//     final ttfBold =
//         await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');

//     for (var school in schools) {
//       final promoterName = school.sellPoints.isNotEmpty
//           ? school.sellPoints[0].promoterName ?? 'Unknown Promoter'
//           : 'Unknown Promoter';

//       final driverName = school.sellPoints.isNotEmpty
//           ? school.sellPoints[0].driverName ?? 'Unknown Driver'
//           : 'Unknown Driver';
//       final List<String> tableHeaders = [
//         'English Category Name',
//         'الاسم',
//         'الكمية',
//         'السعر الكلي'
//       ];
//       int totalQuantity = 0;
//       int totalBillAmount = 0;
//       int bid = 0;
//       // Calculate the total quantity and total bill amount
//       for (var sellPoint in school.sellPoints) {
//         for (var bill in sellPoint.bills) {
//           totalQuantity += bill.totalquantity;
//           totalBillAmount += bill.total.toInt();
//           bid = bill.id;
//         }
//       }

//       final List<List<String>> tableData = [
//         tableHeaders, // This is the header row
//         for (var sellPoint in school.sellPoints)
//           for (var bill in sellPoint.bills)
//             for (var category in bill.billCategories)
//               [
//                 category.category.nameEn,
//                 category.category.nameAr,
//                 category.amount.toString(),
//                 category.totalPrice.toString(),
//               ],
//       ];
//       final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
//       final String formattedDate = formatter.format(_selectedDate);
//       pdf.addPage(
//         pw.MultiPage(
//           textDirection: pw.TextDirection.rtl,
//           build: (context) => [
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text(
//                   'SHAMSEEN FOODSTUFF CATERING',
//                   style: const pw.TextStyle(
//                     fontSize: 10,
//                   ),
//                 ),
//                 pw.Text(
//                   'شمسين لخدمات التموين بالمواد الغذائية',
//                   style: pw.TextStyle(
//                     fontSize: 10,
//                     font: pw.Font.ttf(ttfBold),
//                   ),
//                   textDirection: pw.TextDirection.rtl,
//                 ),
//               ],
//             ),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text(
//                   'Phone: 065384357',
//                   style: const pw.TextStyle(fontSize: 6),
//                 ),
//                 pw.Text(
//                   'Fax: 065384357',
//                   style: const pw.TextStyle(fontSize: 6),
//                 ),
//                 pw.Text(
//                   'TRN: 100334461900003',
//                   style: const pw.TextStyle(fontSize: 6),
//                 ),
//               ],
//             ),
//             pw.SizedBox(height: 10),
//             pw.Row(children: [
//               pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(school.nameAr,
//                         style: pw.TextStyle(
//                             fontSize: 10, font: pw.Font.ttf(ttfBold)),
//                         textDirection: pw.TextDirection.rtl),
//                     pw.Text(' ${school.nameEn}',
//                         style: const pw.TextStyle(
//                           fontSize: 10,
//                         )),
//                   ]),
//               pw.Spacer(),
//               pw.Column(children: [
//                 pw.Text(
//                   "Tax invoice",
//                   style: pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 10),
//                 ),
//                 pw.Text(
//                   "Invoice number: $bid",
//                   style: pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 10),
//                 ),
//                 pw.Text(
//                   "Invoice date: $formattedDate",
//                   style: pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 10),
//                 ),
//               ])
//             ]),

//             pw.SizedBox(height: 5),
//             pw.Table(
//               border: null,
//               columnWidths: {
//                 0: const pw.FlexColumnWidth(),
//                 1: const pw.FlexColumnWidth(),
//                 2: const pw.FlexColumnWidth(),
//               },
//               children: [
//                 pw.TableRow(
//                   decoration: const pw.BoxDecoration(color: PdfColors.grey300),
//                   children: [
//                     pw.Text('اسم السائق',
//                         style: pw.TextStyle(
//                             font: pw.Font.ttf(ttfBold), fontSize: 8),
//                         textDirection: pw.TextDirection.rtl),
//                     pw.Text(
//                       'الموقع',
//                       style:
//                           pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 8),
//                       textDirection: pw.TextDirection.rtl,
//                     ),
//                     pw.Text('اسم المندوب',
//                         style: pw.TextStyle(
//                             font: pw.Font.ttf(ttfBold), fontSize: 8),
//                         textDirection: pw.TextDirection.rtl),
//                   ],
//                 ),
//                 // Driver, Region, and Promoter Info
//                 pw.TableRow(
//                   children: [
//                     pw.Text(driverName,
//                         style: pw.TextStyle(
//                             font: pw.Font.ttf(ttfBold), fontSize: 8),
//                         textDirection: pw.TextDirection.rtl),
//                     pw.Text(school.region,
//                         style: pw.TextStyle(
//                             font: pw.Font.ttf(ttfBold), fontSize: 8),
//                         textDirection: pw.TextDirection.rtl),
//                     pw.Text(promoterName,
//                         style: pw.TextStyle(
//                             font: pw.Font.ttf(ttfBold), fontSize: 8),
//                         textDirection: pw.TextDirection.rtl),
//                   ],
//                 ),
//               ],
//             ),
//             pw.SizedBox(height: 5),
//             pw.Table.fromTextArray(
//                 data: tableData,
//                 headerStyle: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   font: pw.Font.ttf(ttfBold),
//                   fontSize: 12,
//                 ),
//                 cellAlignment: pw.Alignment.center,
//                 headerDecoration:
//                     const pw.BoxDecoration(color: PdfColors.grey300),
//                 cellStyle: pw.TextStyle(
//                   font: pw.Font.ttf(ttfBold),
//                   fontSize: 12,
//                 ),
//                 cellPadding: const pw.EdgeInsets.all(0)),
//             pw.SizedBox(height: 5),
//             pw.Divider(),
//             // Display the total_quantity and total as plain text
//             if (school.sellPoints.isNotEmpty)
//               pw.Row(
//                 crossAxisAlignment: pw.CrossAxisAlignment.end,
//                 mainAxisAlignment: pw.MainAxisAlignment.end,
//                 children: [
//                   pw.Text(
//                     'Total Quantity: ${totalQuantity}',
//                     style:
//                         pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 12),
//                     textDirection: pw.TextDirection.rtl,
//                   ),
//                   pw.SizedBox(width: 25),
//                   pw.Text(
//                     'Total price: ${totalBillAmount}',
//                     style:
//                         pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 12),
//                     textDirection: pw.TextDirection.rtl,
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       );
//     }

//     final pdfBytes = await pdf.save();
//     final appDocDir = await getApplicationSupportDirectory();
//     final pdfPath = '${appDocDir.path}/all_schools_bills.pdf';
//     final pdfFile = File(pdfPath);
//     await pdfFile.writeAsBytes(pdfBytes);

//     final result = await OpenFile.open(pdfPath);

//     print('All Schools PDF generated and saved to: $pdfPath');
//   }

  // Future<void> _generateAllSchoolsPdf() async {
  //   // Show the loading snackbar with a small delay
  //   _showLoadingSnackbar(context);

  //   // Introduce a delay before starting PDF generation
  //   await Future.delayed(const Duration(milliseconds: 200));

  //   try {
  //     final pdfBytes = await generateAllSchoolsPdf(_schools);

  //     // Save or display the PDF here if needed

  //     // Hide the snackbar
  //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //   } catch (error) {
  //     // Handle any errors during PDF generation
  //     print('Error generating PDF: $error');

  //     // Hide the snackbar
  //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //   }
  // // } 
  // void _showLoadingSnackbar(BuildContext context) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Row(
  //         children: [
  //           const SizedBox(
  //             width: 24.0,
  //             height: 24.0,
  //             child: CircularProgressIndicator(
  //               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  //             ),
  //           ),
  //           const SizedBox(width: 16.0),
  //           Text(
  //             S.of(context).generatingPDF,
  //             style: const TextStyle(
  //               fontSize: 16.0,
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //       backgroundColor: kActiveIconColor, // Customize the background color
  //       duration: const Duration(minutes: 1), // Adjust the duration as needed
  //     ),
  //   );
  // }
  //  Future<void> generateSchoolPdf(
  //   School school,
  //   String driverName,
  //   String promoterName,
  // ) async {
  //   final pdf = pw.Document(
  //     pageMode: PdfPageMode.fullscreen,
  //   );
  //   final ttfBold =
  //       await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
  //   final List<String> tableHeaders = [
  //     'English Category Name',
  //     'الاسم',
  //     'الكمية',
  //     'السعر الكلي'
  //   ];

  //   final List<List<String>> tableData = [
  //     tableHeaders, // This is the header row
  //     for (var sellPoint in school.sellPoints)
  //       for (var bill in sellPoint.bills)
  //         for (var category in bill.billCategories)
  //           [
  //             category.category.nameEn,
  //             category.category.nameAr,
  //             category.amount.toString(),
  //             category.totalPrice.toString(),
  //           ],
  //   ];
  //   int totalQuantity = 0;
  //   int totalBillAmount = 0;

  //   // Calculate the total quantity and total bill amount
  //   for (var sellPoint in school.sellPoints) {
  //     for (var bill in sellPoint.bills) {
  //       totalQuantity += bill.totalquantity;
  //       totalBillAmount += bill.total.toInt();
  //     }
  //   }
  //   final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
  //   final String formattedDate = formatter.format(_selectedDate);
  //   pdf.addPage(
  //     pw.MultiPage(
  //       textDirection: pw.TextDirection.rtl,
  //       build: (context) => [
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           children: [
  //             pw.Text(
  //               'SHAMSEEN FOODSTUFF CATERING',
  //               style: pw.TextStyle(
  //                 fontSize: 14,
  //                 fontWeight: pw.FontWeight.bold,
  //                 font: pw.Font.ttf(ttfBold),
  //               ),
  //             ),
  //             pw.Text(
  //               'شمسين لخدمات التموين بالمواد الغذائية',
  //               style: pw.TextStyle(
  //                 fontSize: 14,
  //                 font: pw.Font.ttf(ttfBold),
  //               ),
  //               textDirection: pw.TextDirection.rtl,
  //             ),
  //           ],
  //         ),
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //           children: [
  //             pw.Text(
  //               'Phone: 065384357',
  //               style: const pw.TextStyle(fontSize: 10),
  //             ),
  //             pw.Text(
  //               'Fax: 065384357',
  //               style: const pw.TextStyle(fontSize: 10),
  //             ),
  //             pw.Text(
  //               'TRN: 100334461900003',
  //               style: const pw.TextStyle(fontSize: 10),
  //             ),
  //           ],
  //         ),
  //         pw.SizedBox(height: 10),

  //         pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
  //           pw.Text(school.nameAr,
  //               style: pw.TextStyle(fontSize: 12, font: pw.Font.ttf(ttfBold)),
  //               textDirection: pw.TextDirection.rtl),
  //           pw.Text(' ${school.nameEn}',
  //               style: pw.TextStyle(fontSize: 12, font: pw.Font.ttf(ttfBold))),
  //           pw.Center(
  //             child: pw.Text(
  //               "The Date: $formattedDate",
  //               style: pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 12),
  //             ),
  //           ),
  //         ]),
  //         pw.SizedBox(height: 5),
  //         pw.Table(
  //           border: null,
  //           columnWidths: {
  //             0: const pw.FlexColumnWidth(),
  //             1: const pw.FlexColumnWidth(),
  //             2: const pw.FlexColumnWidth(),
  //           },
  //           children: [
  //             pw.TableRow(
  //               decoration: const pw.BoxDecoration(color: PdfColors.grey300),
  //               children: [
  //                 pw.Text('اسم المندوب',
  //                     style:
  //                         pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 8),
  //                     textDirection: pw.TextDirection.rtl),
  //                 pw.Text(
  //                   'الموقع',
  //                   style:
  //                       pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 8),
  //                   textDirection: pw.TextDirection.rtl,
  //                 ),
  //                 pw.Text('اسم السائق',
  //                     style:
  //                         pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 8),
  //                     textDirection: pw.TextDirection.rtl),
  //               ],
  //             ),

  //             // Driver, Region, and Promoter Info
  //             pw.TableRow(
  //               children: [
  //                 pw.Text(driverName,
  //                     style:
  //                         pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 8),
  //                     textDirection: pw.TextDirection.rtl),
  //                 pw.Text(school.region,
  //                     style:
  //                         pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 8),
  //                     textDirection: pw.TextDirection.rtl),
  //                 pw.Text(promoterName,
  //                     style:
  //                         pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 8),
  //                     textDirection: pw.TextDirection.rtl),
  //               ],
  //             ),
  //           ],
  //         ),
  //         pw.SizedBox(height: 3),

  //         pw.SizedBox(height: 5),
  //         pw.Table.fromTextArray(
  //             data: tableData,
  //             headerStyle: pw.TextStyle(
  //               fontWeight: pw.FontWeight.bold,
  //               font: pw.Font.ttf(ttfBold),
  //               fontSize: 12,
  //             ),
  //             cellAlignment: pw.Alignment.center,
  //             headerDecoration:
  //                 const pw.BoxDecoration(color: PdfColors.grey300),
  //             cellStyle: pw.TextStyle(
  //               font: pw.Font.ttf(ttfBold),
  //               fontSize: 12,
  //             ),
  //             cellPadding: const pw.EdgeInsets.all(0)),
  //         pw.SizedBox(height: 5),
  //         pw.Divider(),
  //         // Display the total_quantity and total as plain text
  //         if (school.sellPoints.isNotEmpty)
  //           pw.Column(
  //             crossAxisAlignment: pw.CrossAxisAlignment.end,
  //             mainAxisAlignment: pw.MainAxisAlignment.end,
  //             children: [
  //               pw.Text(
  //                 'Total Quantity: ${totalQuantity}',
  //                 style: pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 15),
  //                 textDirection: pw.TextDirection.rtl,
  //               ),
  //               pw.Text(
  //                 'Total price: ${totalBillAmount}',
  //                 style: pw.TextStyle(font: pw.Font.ttf(ttfBold), fontSize: 15),
  //                 textDirection: pw.TextDirection.rtl,
  //               ),
  //             ],
  //           ),
  //       ],
  //     ),
  //   );
  //   // pw.Page(
  //   final pdfBytes = await pdf.save();
  //   final appDocDir = await getApplicationSupportDirectory();
  //   final pdfPath =
  //       '${appDocDir.path}/pdf_for_${school.nameEn}_$_selectedDate.pdf';
  //   final pdfFile = File(pdfPath);
  //   await pdfFile.writeAsBytes(pdfBytes);
  //   final result = OpenFile.open(pdfPath);

  //   print('PDFs generated and saved to: $pdfPath');
  // }
