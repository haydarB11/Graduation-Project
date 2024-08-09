import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/school%20bill/school_details.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import '../../../../utils.dart';
import 'data/api_class.dart';
import 'data/school_bills_model.dart';
import 'widgets/error_snackbar.dart';
import 'widgets/loading_snackbar.dart';
import 'widgets/pdf_create_allschools.dart';
import 'widgets/pdf_create_forschools.dart';

class DisplayBillsBySchoolScreen extends StatefulWidget {
  final String type;

  DisplayBillsBySchoolScreen({required this.type});
  @override
  _DisplayBillsBySchoolScreenState createState() =>
      _DisplayBillsBySchoolScreenState();
}

class _DisplayBillsBySchoolScreenState
    extends State<DisplayBillsBySchoolScreen> {
  final TextEditingController _searchController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  List<School> _schools = [];
  bool _isLoading = false;
  List<School> _filteredSchools = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchBillsByDateAndSchool(_selectedDate);
    print("from schoool bill");
    print(widget.type);

    print(widget.type);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await DateSelect.selectDate(context, _selectedDate);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _fetchBillsByDateAndSchool(_selectedDate);
      });
    }
  }

  Future<void> _fetchBillsByDateAndSchool(DateTime selectedDate) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final List<School> fetchedSchools = await _apiService
          .fetchBillsByDateAndSchool(selectedDate, widget.type);
      if (mounted) {
        setState(() {
          _schools = fetchedSchools;
          _filteredSchools = _schools;
          _isLoading = false;
        });
      }

      print(_filteredSchools.length);
      print("this all");
      print(fetchedSchools.length);
    } catch (error) {
      print('Error fetching data: $error');
      ErrorSnackbar.show(context, 'An error occurred. Please try again later.');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void filterSchoold(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSchools =
            _schools; // Show all drivers when search query is empty
      } else {
        _filteredSchools = _schools
            .where((school) =>
                school.nameAr.toLowerCase().contains(query.toLowerCase()) ||
                school.nameEn.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _generateAllSchoolsPdf() async {
    // Show the loading snackbar with a small delay
    LoadingSnackbar.show(context);

    // Introduce a delay before starting PDF generation
    await Future.delayed(const Duration(milliseconds: 200));
    final pdfGenerator = PdfGenerator(
        _schools, widget.type); // Create an instance of PdfGenerator
    try {
      await pdfGenerator
          .generateAllSchoolsPdf(); // Call the PDF generation method

      // Save or display the PDF here if needed

      // Hide the snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } catch (error) {
      // Handle any errors during PDF generation
      print('Error generating PDF: $error');

      // Hide the snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueLightColor,
        title: Text(
          S.of(context).billsBySchool,
          style: Styles.textStyle20.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              print(_filteredSchools.length);
              _generateAllSchoolsPdf();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).generatePdfsForAllSchools,
                  style: Styles.textStyle14,
                ),
                Image.asset(
                  'assets/images/pdf.png',
                  width: 20,
                  height: 20,
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          DateContainer(
              context: context,
              label: S.of(context).theDate,
              dateText: DateFormat('yyyy-MM-dd', 'en').format(_selectedDate),
              onPressed: () => _selectDate(context)),
          const SizedBox(height: 15),
          TextField(
            controller: _searchController,
            onChanged: (value) {
              filterSchoold(value);
            },
            decoration: InputDecoration(
              labelText: S.of(context).searchBySchoolName,
              labelStyle: Styles.textStyle12,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: SpinKitSpinningLines(
                      size: 35,
                      color: hBackgroundColor,
                    ),
                  )
                : _filteredSchools.isEmpty
                    ? Center(child: Text(S.of(context).noSchoolsFound))
                    : ListView.builder(
                        itemCount: _filteredSchools.length,
                        itemBuilder: (context, index) {
                          final school = _filteredSchools[index];
                          final driverName = school.sellPoints.isNotEmpty
                              ? school.sellPoints[0].driverName ??
                                  'Unknown Driver'
                              : 'N/A';
                          final promoterName = school.sellPoints.isNotEmpty
                              ? school.sellPoints[0].promoterName ??
                                  'Unknown Promoter'
                              : 'N/A';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SchoolDetailsScreen(school: school),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(school.nameEn,
                                        style: Styles.textStyle16),
                                    Text(school.nameAr,
                                        style: Styles.textStyle16),
                                    Text(school.region,
                                        style: Styles.textStyle16),
                                    if (school.sellPoints.isEmpty)
                                      Text(S.of(context).noSellPointsAvailable,
                                          style: Styles.textStyle16),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (school.sellPoints.isNotEmpty) {
                                          final pdfGenerator =
                                              PdfGeneratorOneSchool(
                                            school: school,
                                            driverName: driverName,
                                            promoterName: promoterName,
                                            selectedDate: _selectedDate,
                                          );
                                          pdfGenerator.generateSchoolPdf();
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(S
                                                    .of(context)
                                                    .noSellPointsAvailable),
                                                content: Text(
                                                    S.of(context).noSellPoints),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child:
                                                        Text(S.of(context).ok),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            S.of(context).generatePdf,
                                            style: Styles.textStyle14,
                                          ),
                                          Image.asset(
                                            'assets/images/pdf.png',
                                            width: 20,
                                            height: 20,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
