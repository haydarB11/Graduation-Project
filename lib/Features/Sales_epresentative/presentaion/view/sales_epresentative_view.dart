import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shamseenfactory/Features/Sales_epresentative/data/models/promoter.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/app_router.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:shamseenfactory/Features/Sales_epresentative/presentaion/view/widgets/add_prometer_dailog.dart';
import 'package:shamseenfactory/Features/Sales_epresentative/presentaion/view/widgets/sales_card.dart';
import 'package:shamseenfactory/Features/Sales_epresentative/presentaion/view/widgets/search_field_sales.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SalesEpresentative extends StatefulWidget {
  @override
  _SalesEpresentativeState createState() => _SalesEpresentativeState();
}

class _SalesEpresentativeState extends State<SalesEpresentative> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController searchController = TextEditingController();
  List<Promoter> _promoters = [];
  List<Promoter> _filteredPromoters = [];
  String _searchQuery = '';
  bool _isLoading = true; // Initially set to true to show loading indicator

  @override
  void initState() {
    super.initState();
    fetchPromoters();
  }

  void refreshpromoter() {
    fetchPromoters();
  }

  Future<void> fetchPromoters() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/promoters/'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final promotersList = jsonData['data'] as List;
        final promoters = promotersList.map((data) {
          return Promoter.fromJson(data);
        }).toList();
        if (mounted) {
          setState(() {
            _promoters = promoters;
            _filteredPromoters = promoters;
            _isLoading = false; // Data fetched, hide loading indicator
          });
        }
      } else {
        print('Failed to fetch promoters');
      }
    } catch (error) {
      if (error is ClientException) {
        print('Connection issue: ${error.message}');

        // Handle connection issue, maybe retry or show a message to the user
      } else {
        print('An error occurred: $error');
      }

      void setStateIfMounted(f) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
      // Error occurred, hide loading indicator
    }
    // await Future.delayed(Duration(seconds: 2));
  }

  Future<void> addPromoter({
    required String nameAr,
    required String nameEn,
    required String user,
    required String password,
    required String phone,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        "name_ar": nameAr,
        "name_en": nameEn,
        "user": user,
        "password": password,
        "phone": phone,
      };

      final response = await http.post(Uri.parse('$baseUrl/promoters/register'),
          body: jsonEncode(requestData),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
      } else {
        print('Failed to add promoter');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  void searchPromoters(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        _filteredPromoters = _promoters;
      } else {
        final trimmedQuery = _searchQuery.trim().toLowerCase();
        _filteredPromoters = _promoters
            .where((promoter) =>
                promoter.nameAr.toLowerCase().contains(trimmedQuery) ||
                promoter.nameEn.toLowerCase().contains(trimmedQuery))
            .toList();
      }
    });
  }

  void _showAddPromoterDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPromoterDailog(
          onPromoterAdded: (newPromoter) async {
            try {
              await addPromoter(
                nameAr: newPromoter.nameAr,
                nameEn: newPromoter.nameEn,
                user: newPromoter.user,
                password: newPromoter.password,
                phone: newPromoter.phone,
              );
              // Navigator.of(context).pop();
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(S.of(context).promoterAddedSuccessfully),
                  duration: const Duration(seconds: 2),
                ),
              );
              fetchPromoters();
            } catch (error) {
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(S.of(context).promoterAddedSuccessfully),
                  duration: const Duration(seconds: 2),
                ),
              );

              if (error is HttpException) {
                scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).checkInternetConnection),
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else {
                if (error
                    .toString()
                    .toLowerCase()
                    .contains('no address associated with hostname')) {
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).checkInternetConnection),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('${S.of(context).failedToAddPromoter} $error'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            }
          },
        );
      },
    );
  }

  Future<void> generatePromotersPDF(List<Promoter> promoters) async {
    final pdf = pw.Document();

    final ttfBold =
        await rootBundle.load('assets/fonts/Hacen Tunisia Bold Regular.ttf');
    pdf.addPage(pw.MultiPage(
      textDirection: pw.TextDirection.rtl,
      build: (context) => [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('SHAMSEEN FOODSTUFF CATERING',
                style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    font: pw.Font.ttf(ttfBold))),
            pw.Text('شمسين لخدمات التموين بالموادالغذائية',
                style: pw.TextStyle(fontSize: 16, font: pw.Font.ttf(ttfBold)),
                textDirection: pw.TextDirection.rtl),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Phone: 065384357',
                style: const pw.TextStyle(fontSize: 14)),
            pw.Text('Fax: 065384357', style: const pw.TextStyle(fontSize: 14)),
            pw.Text('TRN: 100334461900003',
                style: const pw.TextStyle(fontSize: 14)),
          ],
        ),
        pw.SizedBox(height: 15),
        pw.Text("Promoter user name and password",
            style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                font: pw.Font.ttf(ttfBold))),
        pw.Table.fromTextArray(
          headerAlignment: pw.Alignment.center,
          cellAlignment: pw.Alignment.center,
          headerDecoration: pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          headerHeight: 25,
          cellHeight: 30,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.center,
            2: pw.Alignment.center,
            3: pw.Alignment.center,
            4: pw.Alignment.center,
          },
          headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold, font: pw.Font.ttf(ttfBold)),
          cellStyle: pw.TextStyle(
            font: pw.Font.ttf(ttfBold),
          ),
          headers: [
            'Promoter Name (Ar)',
            'Promoter Name (En)',
            'User',
            'Password'
          ],
          data: List<List<String>>.generate(
            promoters.length,
            (index) => [
              promoters[index].nameAr,
              promoters[index].nameEn,
              promoters[index].user,
              promoters[index].password,
            ],
          ),
        )
      ],
    ));

    final pdfBytes = await pdf.save();
    final appDocDir = await getApplicationSupportDirectory();
    final pdfPath = '${appDocDir.path}/promoter_user_and_password.pdf';
    print(pdfPath);
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);
    final result = OpenFile.open(pdfPath);

    // Open the PDF using a PDF viewer app on Android
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [kBlueLightColor, kBlueColor],
                  begin: FractionalOffset(0.0, 0.4),
                  end: Alignment.topRight),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: deafultpadding * 2,
                      left: deafultpadding,
                      right: deafultpadding),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          GoRouter.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                      // const SizedBox(
                      //   height: 30,
                      // ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              S.of(context).tAllSalesepresentative,
                              style: Styles.textStyle20
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                generatePromotersPDF(_promoters);
                              },
                              child: Text(
                                S.of(context).generatePdf,
                                style: Styles.textStyle16.copyWith(
                                    // color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     generatePromotersPDF(_promoters);
                          //   },
                          //   child: Text(
                          //     S.of(context).generatePdf,
                          //     style: Styles.textStyle16.copyWith(
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: deafultpadding,
                      ),
                      SearchField(
                        searchController: searchController,
                        onchange: searchPromoters,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(70)),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: SpinKitSpinningLines(
                            size: 35,
                            color: hBackgroundColor,
                          ))
                        : ListView.builder(
                            itemCount: _filteredPromoters.length,
                            itemBuilder: (context, index) {
                              return SalesEpresentativeCard(
                                  promoter: _filteredPromoters[index],
                                  refreshPrometerList: refreshpromoter);
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: SizedBox(
            height: 30,
            width: 50,
            child: FloatingActionButton(
              onPressed: () {
                _showAddPromoterDialog(context);
              },
              backgroundColor: Colors.lightGreen,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
