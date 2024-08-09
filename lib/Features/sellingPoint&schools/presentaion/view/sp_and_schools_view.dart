import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/data/api_server.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/data/school_model.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/widgets/school_card_sp.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/widgets/search_field.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/widgets/search_field_sp.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/widgets/sp_card.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SpSchoolsView extends StatefulWidget {
  @override
  State<SpSchoolsView> createState() => _SpSchoolsViewState();
}

class _SpSchoolsViewState extends State<SpSchoolsView> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController schoolTypeController = TextEditingController();
  final TextEditingController _searchControllerSp = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _dController = TextEditingController();
  final TextEditingController _promotersController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  //* school var
  List<School> _schools = [];
  List<School> _filteredSchools = [];
  late Future<List<dynamic>> drivers;
  late Future<List<dynamic>> promoters;

  bool _loading = true;
  //* sales point var
  List<SellPoint> _sellpoints = []; // Add this list
  List<SellPoint> _filttersellpoints = []; // Add this list
  bool _loadingSellPoints = true; // Add this boolean
  @override
  void initState() {
    super.initState();
    fetchAllSchools();
    fetchAllSellPoints();
    drivers = ApiService.fetchDrivers();
    promoters = ApiService.fetchPromoters();
  }

  Future<void> fetchAllSchools() async {
    final schools = await ApiService.fetchAllSchools();

    if (mounted) {
      setState(() {
        _schools = schools;
        _loading = false;
        _filteredSchools = schools;
      });
    }
  }

  void refreshSchoolsList() {
    fetchAllSchools();
  }

  void _filterSchools(String query) {
    setState(() {
      _filteredSchools = _schools.where((school) {
        final nameArabic = school.nameArabic.toLowerCase();
        final nameEnglish = school.nameEnglish.toLowerCase();
        final searchQuery = query.toLowerCase();
        return nameArabic.contains(searchQuery) ||
            nameEnglish.contains(searchQuery);
      }).toList();
    });
  }

  void _filterSp(String query) {
    setState(() {
      _filttersellpoints = _sellpoints.where((sellpoint) {
        final nameArabic = sellpoint.name.toLowerCase();
        final searchQuery = query.toLowerCase();
        return nameArabic.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> addSchool(
      {required String nameArabic,
      required String nameEnglish,
      required String region,
      required String type}) async {
    try {
      await ApiService.addSchool(
        nameArabic: nameArabic,
        nameEnglish: nameEnglish,
        region: region,
        type: type,
      );

      // Fetch schools again after adding a new school
      await fetchAllSchools();
      // print('Before showing snackbar');
      // Show a snackbar to indicate successful addition
      _showSnackBar(S.of(context).schoolAddedSuccessfully);
      // print('after showing snackbar');
    } catch (error) {
      // print('$error');
      _showSnackBar(S.of(context).schoolAddedSuccessfully);
    }
  }

  //*metod api sales point
  Future<void> fetchAllSellPoints() async {
    final sellPoints = await ApiService.fetchAllSellPoints();
    print('Fetched sell points: $sellPoints'); // Add this line

    if (mounted) {
      setState(() {
        _sellpoints = sellPoints;
        _loadingSellPoints = false;
        _filttersellpoints = _sellpoints;
      });
    }
  }

  void refreshSpList() {
    fetchAllSellPoints();
  }

  void _showAddSellPointDialog(BuildContext context) async {
    String name = '';
    String userName = '';
    String password = '';
    School? selectedSchool;
    int? schoolId;
    int? selectedDriverId;
    int? selectedPromotersrId;
    bool isSubmitting = false;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            S.of(context).addSellPoint,
            style: Styles.titleDialog,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => name = value,
                  decoration: InputDecoration(
                      labelText: S.of(context).name,
                      labelStyle: Styles.textStyle12),
                ),
                TextField(
                  onChanged: (value) => userName = value,
                  decoration: InputDecoration(
                      labelText: S.of(context).username,
                      labelStyle: Styles.textStyle12),
                ),
                TextField(
                  onChanged: (value) => password = value,
                  decoration: InputDecoration(
                      labelText: S.of(context).Password,
                      labelStyle: Styles.textStyle12),
                ),
                const SizedBox(height: 20),

                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _dController,
                    decoration: InputDecoration(
                        labelText: S.of(context).selectDriver,
                        labelStyle: Styles.textStyle12),
                  ),
                  suggestionsCallback: (pattern) async {
                    final List fetchedDrivers = await drivers;
                    return fetchedDrivers
                        .where((driver) =>
                            driver['name_en']
                                .toLowerCase()
                                .contains(pattern.toLowerCase()) ||
                            driver['name_ar']
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion?['name_en']),
                      subtitle: Text(suggestion['name_ar']),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      _dController.text = suggestion['name_en'];
                      selectedDriverId = suggestion['id'];
                    });
                    // print('Selected driver: ${suggestion['id']}');
                  },
                ),
                //*list promoters
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _promotersController,
                    decoration: InputDecoration(
                        labelText: S.of(context).selectPromoter,
                        labelStyle: Styles.textStyle12),
                  ),
                  suggestionsCallback: (pattern) async {
                    final List fetchedPromoters = await promoters;
                    return fetchedPromoters
                        .where((promoter) =>
                            promoter['name_en']
                                .toLowerCase()
                                .contains(pattern.toLowerCase()) ||
                            promoter['name_ar']
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['name_en']),
                      subtitle: Text(suggestion['name_ar']),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      _promotersController.text = suggestion['name_en'];
                      selectedPromotersrId = suggestion['id'];
                    });
                    // print('Selected promoter: ${suggestion['id']}');
                  },
                ),
                TypeAheadField<School>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _schoolController,
                    decoration: InputDecoration(
                        labelText: S.of(context).school,
                        labelStyle: Styles.textStyle12,
                        hintText: S.of(context).searchForSchool,
                        hintStyle: Styles.textStyle12),
                  ),
                  suggestionsCallback: (pattern) async {
                    return _schools.where((school) =>
                        school.nameEnglish
                            .toLowerCase()
                            .contains(pattern.toLowerCase()) ||
                        school.nameArabic
                            .toLowerCase()
                            .contains(pattern.toLowerCase()));
                  },
                  itemBuilder: (context, School school) {
                    return ListTile(
                      title: Text(school.nameArabic),
                    );
                  },
                  onSuggestionSelected: (School school) {
                    setState(() {
                      _schoolController.text = school.nameEnglish;
                      selectedSchool = school;
                      schoolId = school.id;
                      print(schoolId);
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (name.isNotEmpty &&
                    userName.isNotEmpty &&
                    password.isNotEmpty &&
                    selectedSchool != null &&
                    selectedDriverId != null &&
                    selectedPromotersrId != null) {
                  await ApiService.addSellPoint(
                    name: name,
                    userName: userName,
                    password: password,
                    schoolId: schoolId,
                    driverId: selectedDriverId,
                    managerId: 1, // Assuming you have a manager ID
                    promoterId:
                        selectedPromotersrId, // Assuming you have a promoter ID
                  );

                  Navigator.of(context).pop(); // Close the dialog
                  _schoolController.clear();
                  _dController.clear();
                  _promotersController.clear();
                  fetchAllSellPoints();
                  // Refresh the sell points list after adding
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        title: Text(S.of(context).sellPointAdded,
                            style: Styles.titleDialog),
                        content: Text(
                          S.of(context).sellPointAddedSuccessfully,
                          style: Styles.textStyle16,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text(S.of(context).ok,
                                style: Styles.styleCanselButton),
                          ),
                        ],
                      );
                    },
                  );
                } else if (name.isEmpty ||
                    userName.isEmpty ||
                    password.isEmpty ||
                    selectedSchool == null ||
                    selectedDriverId == null ||
                    selectedPromotersrId == null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(S.of(context).invalidDate),
                        content: Text(S.of(context).insertAllDataToAdd),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text(S.of(context).ok,
                                style: Styles.styleCanselButton),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text(
                S.of(context).add,
                style: Styles.textStyle16.copyWith(
                    fontWeight: FontWeight.bold, color: Styles.addIconColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _dController.clear();
                _schoolController.clear(); // Close the dialog
              },
              child: Text(
                S.of(context).cancel,
                style: Styles.textStyle16.copyWith(
                    fontWeight: FontWeight.bold, color: kBlueLightColor),
              ),
            ),
          ],
        );
      },
    );
  }

  bool isLoadingSc = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).tPointsofsaleandschools,
              style: Styles.textStyle20.copyWith(color: Colors.white)),
          backgroundColor: kBlueColor,
          elevation: 0, // Remove the shadow
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
          bottom: TabBar(
            indicatorColor: kBlueLightColor,
            tabs: [
              Tab(
                child: InkWell(
                  child: Image.asset(
                    'assets/images/sp.png',
                    // ignore: deprecated_member_use
                    color: kShadowColor,
                  ),
                ),
              ),
              const Tab(
                icon: Icon(
                  Icons.school,
                  color: kShadowColor,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          // Sales Points Screen

          _loadingSellPoints
              ? FadeInDown(
                  duration: Duration(microseconds: 500),
                  child: const Center(
                    child: SpinKitSpinningLines(
                      size: 35,
                      color: hBackgroundColor,
                    ),
                  ),
                )
              : Container(
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SearchFieldSp(
                            searchController: _searchControllerSp,
                            onchange: (value) {
                              _filterSp(value);
                            },
                          )),
                      // List of Sales Points

                      Expanded(
                        child: _filttersellpoints.isEmpty
                            ? Center(
                                child: Text(S.of(context).noSellPointFound,
                                    style: Styles.textStyle20),
                              )
                            : ListView.builder(
                                itemCount: _filttersellpoints.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var sellPoint = _filttersellpoints[index];

                                  return SpCard(
                                    sellPoint: sellPoint,
                                    refreshSpList: refreshSpList,
                                    drivers: drivers,
                                    promoters: promoters,
                                    schools: _schools,
                                  );
                                },
                              ),
                      ),
                      // Add Sales Point Button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(kBlueColor),
                            ),
                            onPressed: () {
                              _showAddSellPointDialog(context);
                            },
                            child: Text(
                              S.of(context).addSellPoint,
                              style: Styles.textStyle14
                                  .copyWith(color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),

          // Schools Screen
          _loading
              ? const Center(
                  child: SpinKitSpinningLines(
                    size: 35,
                    color: hBackgroundColor,
                  ),
                )
              : Container(
                  child: Column(
                    children: [
                      // Search TextField
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SearchField(
                            onchange: _filterSchools,
                            searchController: _searchController,
                          )),
                      // List of Schools
                      Expanded(
                        child: _filteredSchools.isEmpty
                            ? Center(
                                child: Text(
                                  S.of(context).noSchoolsFound,
                                  style: Styles.textStyle20,
                                ),
                              )
                            : ListView.builder(
                                itemCount: _filteredSchools.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var school = _filteredSchools[index];

                                  return SchoolCard(
                                    school: school,
                                    refreshSchoolsList: refreshSchoolsList,
                                  );
                                },
                              ),
                      ),
                      // Add School Button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(kBlueColor),
                          ),
                          onPressed: () async {
                            BuildContext dialogContext = context;
                            showDialog(
                              context: context,
                              builder: (context) {
                                String nameArabic = '';
                                String nameEnglish = '';
                                String region = '';

                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  title: Text(
                                    S.of(context).addSchool,
                                    style: Styles.titleDialog,
                                  ),
                                  content: Form(
                                    key: _formKey,
                                    child: (isLoadingSc)
                                        ? CircularProgressIndicator()
                                        : SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  onChanged: (value) =>
                                                      nameArabic = value,
                                                  decoration: InputDecoration(
                                                      labelText: S
                                                          .of(context)
                                                          .nameArabic,
                                                      labelStyle:
                                                          Styles.textStyle12),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return S
                                                          .of(context)
                                                          .pleaseEnterNameArabic;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                TextFormField(
                                                  onChanged: (value) =>
                                                      nameEnglish = value,
                                                  decoration: InputDecoration(
                                                      labelText: S
                                                          .of(context)
                                                          .nameEnglish,
                                                      labelStyle:
                                                          Styles.textStyle12),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return S
                                                          .of(context)
                                                          .pleaseEnterNameEnglish;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                TextFormField(
                                                  onChanged: (value) =>
                                                      region = value,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          S.of(context).region,
                                                      labelStyle:
                                                          Styles.textStyle12),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return S
                                                          .of(context)
                                                          .pleaseEnterRegion;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                DropdownButtonFormField<String>(
                                                  value: 'school',
                                                  // Set initial value
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      // Update the selected school type value
                                                      schoolTypeController
                                                          .text = newValue!;
                                                    });
                                                  },
                                                  items: const [
                                                    DropdownMenuItem<String>(
                                                      value: 'school',
                                                      child: Text('School'),
                                                    ),
                                                    DropdownMenuItem<String>(
                                                      value: 'kindergarten',
                                                      child:
                                                          Text('Kindergarten'),
                                                    ),
                                                  ],
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText:
                                                              'School Type'),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            isLoadingSc = true;
                                          });
                                          await addSchool(
                                              nameArabic: nameArabic,
                                              nameEnglish: nameEnglish,
                                              region: region,
                                              type: schoolTypeController.text);
                                          // ignore: use_build_context_synchronously
                                          setState(() {
                                            isLoadingSc = false;
                                          });
                                          // Close the dialog
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(dialogContext).pop();
                                          /*Exception has occurred.
FlutterError (Looking up a deactivated widget's ancestor is unsafe.
At this point the state of the widget's element tree is no longer stable.
To safely refer to a widget's ancestor in its dispose() method, 
save a reference to the ancestor by calling dependOnInheritedWidgetOfExactType() 
in the widget's didChangeDependencies() method.)*/
                                        }
                                      },
                                      child: Text(
                                        S.of(context).add,
                                        style: Styles.textStyle16.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Styles.addIconColor),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                        child: Text(
                                          S.of(context).cancel,
                                          style: Styles.textStyle16.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: kBlueLightColor),
                                        ))
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            S.of(context).addSchool,
                            style: Styles.textStyle14
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ]),
      ),
    );
  }
}
