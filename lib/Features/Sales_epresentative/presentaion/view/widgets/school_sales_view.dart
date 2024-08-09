import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:shamseenfactory/Features/Sales_epresentative/data/models/promoter.dart';
import 'package:shamseenfactory/Features/Sales_epresentative/data/models/promoter_server.dart';
import 'package:shamseenfactory/Features/Sales_epresentative/presentaion/view/widgets/school_sales_card.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class SchoolManagementScreenSales extends StatefulWidget {
  final Promoter promoter;

  const SchoolManagementScreenSales({required this.promoter});

  @override
  _SchoolManagementScreenState createState() => _SchoolManagementScreenState();
}

final TextEditingController _selectControllerSp = TextEditingController();
List<SellPoint> _sellPoint = [];
List<SellPoint> _sellPointp = [];
bool _isLoading = false;

class _SchoolManagementScreenState extends State<SchoolManagementScreenSales> {
  void initState() {
    super.initState();
    fetchSp();
    fetchSpforP();
  }

  Future<void> fetchSp() async {
    try {
      final sellPoint = await PromoterService.fetchAllSellPoints();
      if (mounted) {
        setState(() {
          _sellPoint = sellPoint;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          print("all sellll   $_sellPoint");
        });
      }
      print(e);
    }
  }

  Future<void> fetchSpforP() async {
    try {
      setState(() {
        _isLoading = true; // Set loading state to true
      });
      final sellPoint =
          await PromoterService.fetchAllSellPointsPromoter(widget.promoter.id);
      if (mounted) {
        setState(() {
          _sellPointp = sellPoint;
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

  void _showSellPointSelection(BuildContext context, Promoter p) {
    final dialogContext = context;
    int id = 0;

    // Placeholder value

    showDialog(
      context: dialogContext, // Use the stored context
      builder: (BuildContext context) {
        final availableSellPoints = _sellPoint
            .where((sp) => !_sellPointp.any((s) => s.id == sp.id))
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
                autofocus: false,
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
                return availableSellPoints.where((sp) =>
                    sp.name.toLowerCase().contains(pattern.toLowerCase()));
              },
              itemBuilder: (context, suggestion) {
                return ListTile(title: Text(suggestion.name));
              },
              onSuggestionSelected: (SellPoint sp) {
                setState(() {
                  print(_selectControllerSp.text);
                  id = sp.id;
                  _selectControllerSp.text = sp.name;
                });
              },
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    print(availableSellPoints);
                    print("finall pid ${p.id} sellp ${id}");
                    await PromoterService.sendUpdateRequest(
                        promoterId: p.id, sellpointId: id);
                    // ignore: use_build_context_synchronously
                    setState(() {
                      _selectControllerSp.clear();
                    });

                    Navigator.of(dialogContext).pop();
                    setState(() {
                      fetchSpforP();
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
                            S.of(context).addSuccess,
                            style: Styles.titleDialog,
                          ),

                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                S.of(context).yes,
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
                                  widget.promoter.nameEn,
                                  style: Styles.textStyle20,
                                )
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(S.of(context).tAllSchoolsforthisSalesepresentative,
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
                    : _sellPointp.isEmpty
                        ? Center(
                            child: Text(
                              S.of(context).noSellPointsForPromoter,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _sellPointp.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SchoolSalesCard(
                                schoolName: _sellPointp[index].name,
                                location: _sellPointp[index].user,
                                onDelete: () {},
                              );
                            },
                          ),
              ))
              // Close Container
            ], // Close Column children
          ), // Close Column
        ), // Close Container
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showSellPointSelection(context, widget.promoter);
          },
          backgroundColor: Colors.lightGreen,
          child: const Icon(Icons.add),
        ),
      ),
    ); // Close Scaffold
  } // Close build method
}
