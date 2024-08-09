import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/data/api_server.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/data/school_model.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'package:http/http.dart' as http;

class SpCard extends StatefulWidget {
  final SellPoint sellPoint;
  final Future<List<dynamic>> drivers; // Use Future here
  final Future<List<dynamic>> promoters; // Use Future here
  final List<School> schools; // Add this parameter
  final VoidCallback refreshSpList;
  const SpCard(
      {required this.sellPoint,
      required this.refreshSpList,
      required this.drivers,
      required this.promoters,
      required this.schools});

  @override
  State<SpCard> createState() => _SpCardState();
}

class _SpCardState extends State<SpCard> {
  TextEditingController _dController = TextEditingController();
  TextEditingController _pController = TextEditingController();

  Future<List<DropdownMenuItem<String>>> _buildPromoterDropdownItems() async {
    final List<DropdownMenuItem<String>> items = [];
    final List fetchedPromoters =
        await widget.promoters; // Use the passed promoters

    for (var promoter in fetchedPromoters) {
      items.add(DropdownMenuItem(
        value: promoter['id'].toString(),
        child: Text(promoter['name_ar']),
      ));
    }

    return items;
  }

  Future<List<DropdownMenuItem<String>>> _buildDriverDropdownItems() async {
    final List<DropdownMenuItem<String>> items = [];
    final List fetchedDrivers = await widget.drivers; // Use the passed drivers

    for (var driver in fetchedDrivers) {
      items.add(DropdownMenuItem(
        value: driver['id'].toString(),
        child: Text(driver['name_ar']),
      ));
    }

    return items;
  }

  Future<void> updateSellPoint(int sellPointId, int driverId, int promoterId,
      String sellPointName, String password, String user) async {
    final Uri uri = Uri.parse('$baseUrl/managers/sell-points/update');

    final Map<String, dynamic> data = {
      "sell_point_id": sellPointId,
      "promoter_id": promoterId,
      "driver_id": driverId,
      "name": sellPointName,
      "password": password,
      "user": user
    };

    final http.Response response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
      },
      body: jsonEncode(data), // Encode the data as JSON
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Sell point updated successfully');
      print(response.body); // This will print the response body from the server
    } else {
      print('Failed to update sell point: ${response.reasonPhrase}');
    }
  }

  void _showEditSellPointDialog(BuildContext context) async {
    TextEditingController nameController =
        TextEditingController(text: widget.sellPoint.name ?? '');
    TextEditingController userNameController =
        TextEditingController(text: widget.sellPoint.user ?? '');
    TextEditingController passwordController =
        TextEditingController(text: widget.sellPoint.password ?? '');
    TextEditingController schoolname =
        TextEditingController(text: widget.sellPoint.school?.nameArabic);
    School? selectedSchool = widget.sellPoint.school;
    int? selectedDriverId = widget.sellPoint.driverid;
    int? selectedPromoterId = widget.sellPoint.promoterid;
    _dController.text =
        widget.sellPoint.driver?.nameArabic ?? 'Driver Name Not Available';
    _pController.text =
        widget.sellPoint.promoter?.nameArabic ?? 'Promoter Name Not Available';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Sell Point',
            style: Styles.titleDialog,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: schoolname, // Set the controller here
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: S.of(context).schoolName,
                    labelStyle: Styles.textStyle12,
                  ),
                ),
                TextFormField(
                  controller: nameController, // Set the controller here

                  decoration: InputDecoration(
                    labelText: S.of(context).name,
                    labelStyle: Styles.textStyle12,
                  ),
                ),
                TextFormField(
                  controller: userNameController, // Set the controller here

                  decoration: InputDecoration(
                    labelText: S.of(context).username,
                    labelStyle: Styles.textStyle12,
                  ),
                ),
                TextFormField(
                  controller: passwordController, // Set the controller here

                  decoration: InputDecoration(
                    labelText: S.of(context).Password,
                    labelStyle: Styles.textStyle12,
                  ),
                ),
                FutureBuilder<List<DropdownMenuItem<String>>>(
                  future: _buildPromoterDropdownItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While data is being fetched, you can return a loading indicator or placeholder.
                      return const CircularProgressIndicator(); // Replace with your loading UI.
                    } else if (snapshot.hasError) {
                      // Handle error if the data fetch fails.
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Data has been successfully fetched, so you can build the dropdown.
                      return DropdownButtonFormField<String>(
                        value: selectedPromoterId?.toString(),
                        items: snapshot.data, // Use the data from the snapshot
                        onChanged: (value) {
                          setState(() {
                            selectedPromoterId = int.parse(value!);
                          });
                        },
                        decoration: InputDecoration(
                          labelText: S.of(context).selectPromoter,
                          labelStyle: Styles.textStyle12,
                        ),
                      );
                    }
                  },
                ),
                FutureBuilder<List<DropdownMenuItem<String>>>(
                  future: _buildDriverDropdownItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While data is being fetched, you can return a loading indicator or placeholder.
                      return CircularProgressIndicator(); // Replace with your loading UI.
                    } else if (snapshot.hasError) {
                      // Handle error if the data fetch fails.
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Data has been successfully fetched, so you can build the dropdown.
                      return DropdownButtonFormField<String>(
                        value: selectedDriverId != null
                            ? selectedDriverId.toString()
                            : null,
                        items: snapshot.data, // Use the data from the snapshot
                        onChanged: (value) {
                          setState(() {
                            selectedDriverId = int.parse(value!);
                          });
                        },
                        decoration: InputDecoration(
                          labelText: S.of(context).selectDriver,
                          labelStyle: Styles.textStyle12,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                S.of(context).cancel,
                style: Styles.styleCanselButton,
              ),
            ),
            TextButton(
              onPressed: () async {
                // Validate the user input and handle errors if necessary

                // Call the API to update the sell point
                try {
                  await updateSellPoint(
                      widget.sellPoint.id, // Pass the sell point's ID
                      selectedDriverId ??
                          widget.sellPoint
                              .driverid, // Use selectedDriverId if available, otherwise use the current driver ID
                      selectedPromoterId ??
                          widget.sellPoint
                              .promoterid, // Use selectedPromoterId if available, otherwise use the current promoter ID
                      nameController.text, // Use the edited name
                      passwordController.text, // Use the edited password
                      userNameController.text);
                  if (mounted) {
                    setState(() {
                      widget.refreshSpList();
                    });
                  }
                } catch (e) {}

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text(
                S.of(context).save,
                style: Styles.styleCanselButton,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(right: 40, left: 10, top: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(deafultpadding),
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 30,
          child: Image.asset(
            'assets/images/sp.png',
            color: kBlueColor,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sellPoint.name ?? 'N/A', // Handle null value
              style: Styles.textStyle16,
            ),
            Text(
              widget.sellPoint.school != null
                  ? widget.sellPoint.school!.nameArabic ?? 'No Name Available'
                  : 'No School Available',
              style: Styles.textStyle16,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${S.of(context).Password}:${widget.sellPoint.password}",
              style: Styles.textStyle14,
            ),
            Text(
              "${S.of(context).username}:${widget.sellPoint.user}",
              style: Styles.textStyle14,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                _showEditSellPointDialog(context);
              },
              icon: Icon(
                Icons.edit,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () async {
                // ignore: use_build_context_synchronously
                final shouldDelete = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        S.of(context).deleteSp,
                      ),
                      content: widget.sellPoint.bills.isNotEmpty
                          ? Text(
                              S.of(context).confirmDeleteSpWithBills,
                              style: Styles.textStyle14
                                  .copyWith(color: Colors.red.withOpacity(0.6)),
                            )
                          : Text(S.of(context).confirmDeleteSp),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false); // Don't delete
                          },
                          child: Text(
                            S.of(context).cancel,
                            style: Styles.styleCanselButton,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true); // Delete
                          },
                          child: Text(
                            S.of(context).delete,
                            style: Styles.styledeleteButton,
                          ),
                        ),
                      ],
                    );
                  },
                );
                if (shouldDelete == true) {
                  try {
                    await ApiService.deleteSellPoint(widget.sellPoint.id);

                    widget
                        .refreshSpList(); // Trigger the callback to refresh the list

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.of(context).spDeletedSuccessfully),
                      ),
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.of(context).failedToDeleteSp),
                      ),
                    );
                  }
                }
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/**
// void _showEditSellPointDialog(BuildContext context, SellPoint sellPoint) {
//   String name = sellPoint.name;
//   String userName = sellPoint.user;
//   String password = sellPoint.password;
//   // Initialize other variables if needed (e.g., selectedSchool, selectedDriverId, etc.)

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         title: Text(
//           S.of(context).editSellPoint, // Replace with your localization key
//           style: Styles.titleDialog,
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(
//                 onChanged: (value) => name = value,
//                 controller: TextEditingController(text: name),
//                 decoration: InputDecoration(
//                   labelText: S.of(context).name, // Replace with your localization key
//                   labelStyle: Styles.textStyle12,
//                 ),
//               ),
//               TextField(
//                 onChanged: (value) => userName = value,
//                 controller: TextEditingController(text: userName),
//                 decoration: InputDecoration(
//                   labelText: S.of(context).username, // Replace with your localization key
//                   labelStyle: Styles.textStyle12,
//                 ),
//               ),
//               TextField(
//                 onChanged: (value) => password = value,
//                 controller: TextEditingController(text: password),
//                 decoration: InputDecoration(
//                   labelText: S.of(context).Password, // Replace with your localization key
//                   labelStyle: Styles.textStyle12,
//                 ),
//               ),
//               // Add any other fields you want to edit
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               // Make your API call to update the sell point information here
//               try {
//                 await updateSellPoint(
//                   sellPoint.id, // Assuming you have an ID property in SellPoint
//                    name,
//                    userName,
//                   : password,

//                   // Add other parameters if needed
//                 );

//                 Navigator.of(context).pop(); // Close the dialog

//                 // Show a snackbar to indicate successful update

//               } catch (error) {
//                 // Handle error if the update fails

//               }
//             },
//             child: Text(
//               S.of(context).save, // Replace with your localization key
//               style: Styles.textStyle16.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Styles.addIconColor,
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             child: Text(
//               S.of(context).cancel, // Replace with your localization key
//               style: Styles.textStyle16.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: kBlueLightColor,
//               ),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }
 */