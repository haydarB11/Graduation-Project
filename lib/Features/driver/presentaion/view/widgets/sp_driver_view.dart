import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:shamseenfactory/Features/driver/data/dirver_api.dart';
import 'package:shamseenfactory/Features/driver/data/models/driver_model.dart';
import 'package:shamseenfactory/Features/driver/presentaion/view/widgets/sp_driver_card.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class SchoolManagementScreen extends StatefulWidget {
  final Driver driver;

  const SchoolManagementScreen({required this.driver});

  @override
  State<SchoolManagementScreen> createState() => _SchoolManagementScreenState();
}

final TextEditingController _selectControllerSp = TextEditingController();
List<SellPoint> _sellPoint = [];
List<SellPoint> _sellPointd = [];
bool _isLoading = false;

class _SchoolManagementScreenState extends State<SchoolManagementScreen> {
  void initState() {
    super.initState();
    fetchSp();
    fetchSpforD();
  }

  Future<void> fetchSp() async {
    try {
      final sellPoint = await DriversApi.fetchAllSellPoints();
      if (mounted) {
        setState(() {
          _sellPoint = sellPoint;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          print(_sellPoint);
        });
      }
      print(e);
    }
  }

  Future<void> fetchSpforD() async {
    try {
      setState(() {
        _isLoading = true; // Set loading state to true
      });

      final sellPointd =
          await DriversApi.fetchAllSellPointsDriver(widget.driver.id);
      if (mounted) {
        setState(() {
          _sellPointd = sellPointd;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          print(_sellPoint);
        });
      }
      print(e);
    }
  }

  void _showSellPointSelection(BuildContext context, Driver d) {
    final dialogContext = context;
    List<int> ids = [];

    // Placeholder value

    showDialog(
      context: dialogContext, // Use the stored context
      builder: (BuildContext context) {
        final availableSellPoints = _sellPoint
            .where((sp) => !_sellPointd.any((s) => s.id == sp.id))
            .toList();
        return SingleChildScrollView(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text(
              S.of(context).selectSellPoint,
              style: Styles.textStyle18.copyWith(fontWeight: FontWeight.bold),
            ),
            content: TypeAheadField<SellPoint>(
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: true,
                controller: _selectControllerSp,
                decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: hBackgroundColor),
                    ),
                    labelText: S.of(context).searchSellPoints,
                    labelStyle:
                        Styles.textStyle14.copyWith(color: Colors.black54)),
              ),
              suggestionsCallback: (pattern) async {
                return availableSellPoints
                    .where((sp) =>
                        sp.name.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(title: Text(suggestion.name));
              },
              onSuggestionSelected: (SellPoint sp) {
                setState(() {
                  print(_selectControllerSp.text);
                  ids.add(sp.id);
                  _selectControllerSp.text = sp.name;
                });
              },
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    await DriversApi.addSellPointToDriver(
                        driverId: d.id, ids: ids);
                    // ignore: use_build_context_synchronously
                    Navigator.of(dialogContext).pop();
                    setState(() {
                      fetchSpforD();
                    });
                    final outerContext = dialogContext;
                    // ignore: use_build_context_synchronously
                    showDialog<void>(
                      context: outerContext,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          // <-- SEE HERE
                          title: Text(
                            S.of(context).success,
                            style: Styles.titleDialog,
                          ),

                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                'Yes',
                                style: Styles.styleCanselButton,
                              ),
                              onPressed: () {
                                Navigator.of(outerContext).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );

                    // Fetch updated data from the server

                    _selectControllerSp.clear();

                    // Successful operation, you might want to show a success message
                  } catch (error) {
                    print(error);
                    // An error occurred, you might want to show an error message
                    print('Error adding sell point: $error');
                  }
                },
                child: Text(
                  S.of(context).add,
                  style: TextStyle(color: Styles.addIconColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _selectControllerSp.clear();
                },
                child: Text(S.of(context).cancel),
              )
              // Other buttons...
            ],
          ),
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
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
                        Expanded(child: Container()),
                        Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: hBackgroundColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.grey[200],
                                ),
                                Text(
                                  maxLines: 1,
                                  widget.driver.nameEn,
                                  style: Styles.textStyle16,
                                )
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(S.of(context).tAllSchoolsforthisdriver,
                        style: Styles.textStyle20.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: deafultpadding,
                    ),
                    // SearchField(),
                  ], // Close Column children
                ), // Close Column
              ),
              const SizedBox(
                height: deafultpadding,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: deafultpadding),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(35),
                          topLeft: Radius.circular(35))),
                  child: _isLoading
                      ? const Center(
                          child: SpinKitSpinningLines(
                          size: 35,
                          color: hBackgroundColor,
                        ))
                      : _sellPointd.isEmpty
                          ? Center(
                              child: Text(
                                S.of(context).noSellPointsForDriver,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _sellPointd.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SpDriverCard(
                                    namesp: _sellPointd[index].name);
                              },
                            ),
                ),
              ),
              // Close Container
            ], // Close Column children
          ), // Close Column
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showSellPointSelection(context, widget.driver);
          },
          backgroundColor: Colors.lightGreen,
          child: const Icon(Icons.add),
        ), // Close Container
      ),
    ); // Close Scaffold
  }
}
