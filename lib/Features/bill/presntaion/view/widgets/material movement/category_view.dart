import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/material%20movement/category_details.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'data/category_model.dart';

class CategoryView extends StatefulWidget {
  final String type;
  const CategoryView({super.key, required this.type});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

//*varibles
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  //! Apis
  Future<void> fetchData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    String s = widget.type == "raw" ? "damage" : "store";

    try {
      print(s);
      final response = await http.get(
        Uri.parse(
            '$baseUrl/category/get-all-with-specific-properties/?type=$s'),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        if (mounted) {
          setState(() {
            categories =
                data.map((category) => Category.fromJson(category)).toList();
            filteredCategories = List.from(categories);
            isLoading = false; // Set loading to false when data is loaded
          });
        }
      } else {
        print('Failed to load categories');
        if (mounted) {
          setState(() {
            isLoading = false; // Set loading to false on error
          });
        }
      }
    } catch (e) {
      print('Error fetching categories: $e');
      if (mounted) {
        setState(() {
          isLoading = false; // Set loading to false on error
        });
      }
    }
  }

//todo:
  void filterCategories(String query) {
    setState(() {
      filteredCategories = categories
          .where((category) =>
              category.nameAr.toLowerCase().contains(query.toLowerCase()) ||
              category.nameEn.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).allCategory,
            style: Styles.textStyle20.copyWith(color: Colors.white),
          ),
          backgroundColor: kBlueLightColor,
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onChanged: filterCategories,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  labelText: S.of(context).searchByName,
                  labelStyle: Styles.textStyle12,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: SpinKitFoldingCube(
                      color: hBackgroundColor,
                      size: 35,
                    ))
                  : filteredCategories.isEmpty
                      ? Center(
                          child: Text(S.of(context).notFound),
                        )
                      : ListView.builder(
                          itemCount: filteredCategories.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: hBackgroundColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              padding: const EdgeInsets.all(16.0),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryDetailsScreen(
                                        filteredCategories[index].id.toString(),
                                        filteredCategories[index].nameEn,
                                        filteredCategories[index].nameAr,
                                        type: widget.type,
                                      ),
                                    ),
                                  );
                                },
                                leading: const Icon(Icons.food_bank),
                                title: Text(
                                  filteredCategories[index].nameAr,
                                  style: Styles.textStyle14,
                                ), // Display the Arabic name
                                subtitle: Text(
                                  filteredCategories[index].nameEn,
                                  style: Styles.textStyle14,
                                ), // Display the English name
                                // You can customize the ListTile to display more information if needed
                              ),
                            );
                          },
                        ),
            ),
          ],
        ));
  }
}

class build_data_container extends StatelessWidget {
  const build_data_container({
    super.key,
    required this.context,
    required this.label,
    required this.dateText,
    required this.onPressed,
  });

  final BuildContext context;
  final String label;
  final String dateText;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              const SizedBox(height: 4.0),
              Text(
                dateText,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onPressed,
            // style: ElevatedButton.styleFrom(
            //   primary: kActiveIconColor,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            // ),
            child: Text(S.of(context).select,
                style:
                    Styles.textStyle16.copyWith(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
/*  build_data_container(
              context: context,
              label: S.of(context).endDate,
              dateText: DateFormat('yyyy-MM-dd', 'en').format(_selectedTowDate),
              onPressed: () => _selectTowDate(context),
            ),
            
              DateTime _selectedOneDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _selectedTowDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedOneDate) {
      setState(() {
        _selectedOneDate = picked;
      });
    }
  }

  Future<void> _selectTowDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTowDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedTowDate) {
      setState(() {
        _selectedTowDate = picked;
        // fetchCategoryTotals(_selectedOneDate, _selectedTowDate);
      });
    }
  }

            
            */
