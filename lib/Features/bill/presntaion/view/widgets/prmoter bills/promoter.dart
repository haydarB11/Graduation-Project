import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart' show DateFormat;
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/prmoter%20bills/prmoter_bills_details.dart';
import 'package:shamseenfactory/Features/bill/utils.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class PromoterBillScreen extends StatefulWidget {
  final String type;

  const PromoterBillScreen({required this.type});

  @override
  _PromoterBillScreenState createState() => _PromoterBillScreenState();
}

class _PromoterBillScreenState extends State<PromoterBillScreen> {
  List<dynamic> promoterData = [];

  bool isLoading = false;

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        fetchPromoterBills(_selectedDate);
      });
    }
  }

  List<dynamic> filteredPromoterData = [];

  void updateSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPromoterData = promoterData;
      } else {
        filteredPromoterData = promoterData.where((promoter) {
          final promoterName = promoter['name_ar'].toString().toLowerCase();
          final promoterNameEn = promoter['name_en'].toString().toLowerCase();
          final queryLower = query.toLowerCase();
          return promoterName.contains(queryLower) ||
              promoterNameEn.contains(queryLower);
        }).toList();
      }
    });
  }

  Future<void> fetchPromoterBills(DateTime selectedDate) async {
    setState(() {
      isLoading = true;
    });

    try {
      var request = http.Request(
        'POST',
        Uri.parse('$baseUrl/bill/promoters/get-all'),
      );
      final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
      final String formattedDate = formatter.format(selectedDate);
      request.headers.addAll({'Content-Type': 'application/json'});
      request.body = '{"date": "$formattedDate","type":"${widget.type}"}';

      http.StreamedResponse response = await request.send();
      print(request.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> responseData = json.decode(responseBody);

        if (mounted) {
          setState(() {
            promoterData = responseData['data'];
            filteredPromoterData = promoterData;
            isLoading = false;
          });
        }
      } else {
        print(response.reasonPhrase);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
          ),
        );
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (error) {
      print('Error during API request: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPromoterBills(_selectedDate);
// Initialize filtered data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).promoterBills,
          style: Styles.textStyle20.copyWith(color: Colors.white),
        ),
        backgroundColor: kBlueLightColor,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          DateContainer(
            context: context,
            label: S.of(context).theDate,
            dateText: DateFormat('yyyy-MM-dd', 'en').format(_selectedDate),
            onPressed: () => _selectDate(context),
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: S.of(context).searchByPromoterName,
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (value) {
              // Call a function to update the search results
              updateSearchResults(value);
            },
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: SpinKitSpinningLines(
                    size: 35,
                    color: hBackgroundColor,
                  ))
                : filteredPromoterData.isEmpty
                    ? const Center(child: Text('No matching promoters found.'))
                    : ListView.builder(
                        itemCount: filteredPromoterData.length,
                        itemBuilder: (context, index) {
                          var promoter = filteredPromoterData[index];
                          var sellPoints = promoter['sell_points'];
                          return Card(
                            child: ListTile(
                              hoverColor: Colors.grey,
                              title: Text(
                                promoter['name_ar'] ?? "",
                                style: Styles.textStyle16,
                              ),
                              subtitle: Text(
                                promoter['name_en'] ?? '',
                                style: Styles.textStyle16,
                              ),
                              trailing:
                                  const Icon(Icons.arrow_circle_right_rounded),
                              onTap: () {
                                print('Sell points tapped: $sellPoints');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PromoterDetailScreen(promoter),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
