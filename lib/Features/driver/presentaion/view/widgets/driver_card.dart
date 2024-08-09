import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shamseenfactory/Features/driver/data/dirver_api.dart';
import 'package:shamseenfactory/Features/driver/data/models/driver_model.dart';
import 'package:shamseenfactory/Features/driver/presentaion/view/widgets/sp_driver_view.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/data/api_server.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class DriverCard extends StatelessWidget {
  final Driver driver;
  final VoidCallback refreshDriverList;
  DriverCard({required this.driver, required this.refreshDriverList});
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: SafeArea(
        child: Card(
          margin: const EdgeInsets.only(top: 10, right: 50, left: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          child: ListTile(
            contentPadding: const EdgeInsets.all(deafultpadding * 0.5),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 30,
              child: const Icon(Icons.person, color: Colors.black38),
            ),
            title: Text(driver.nameEn,
                style: Styles.textStyle16
                    .copyWith(color: kTextColor, fontWeight: FontWeight.bold)),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(driver.nameAr,
                    style: Styles.textStyle12.copyWith(
                      color: Colors.black,
                    )),
                Text("Password:${driver.password}",
                    style: Styles.textStyle12.copyWith(
                      color: Colors.black,
                    ))
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SchoolManagementScreen(driver: driver),
                      ),
                    );
                    // Implement edit functionality here
                  },
                  icon: Icon(Icons.edit, color: Styles.editIconColor),
                ),
                IconButton(
                  onPressed: () {
                    // context.read<DriversCubit>().deleteDriver(driver.id);
                    _deleteDriver(context, driver.id);
                    ApiService.fetchDrivers();
                  },
                  icon: Icon(Icons.delete, color: Styles.delteIconColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteDriver(BuildContext context, int driverId) async {
    String enteredPassword = '';
    bool showPassword = false;
    final currentContext = context;
    final confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            S.of(context).confirmDelete,
            style: Styles.textStyle18.copyWith(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.of(context).enterPassword,
                    style: Styles.textStyle16,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      enteredPassword = value;
                    },
                    obscureText: !showPassword, // Use the showPassword state
                    decoration: InputDecoration(
                      labelText: S.of(context).Password,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          print(
                              'Before setState - showPassword: $showPassword');
                          setState(() {
                            // Use the StateSetter from StatefulBuilder
                            showPassword = !showPassword;
                          });
                          print('After setState - showPassword: $showPassword');
                        },
                        child: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                S.of(context).cancel,
                style: Styles.styleCanselButton,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                S.of(context).delete,
                style: Styles.styledeleteButton,
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        // Fetch the driver by ID

        if (driver != null && driver.password == enteredPassword) {
          await DriversApi.deleteDriver(driverId);
          refreshDriverList();

          // Show success dialog
          if (!currentContext.mounted) return;
          showDialog<void>(
            context: currentContext,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: Text(
                  S.of(context).deleteSuccess,
                  style: Styles.titleDialog,
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      S.of(context).ok,
                      style: Styles.styleCanselButton,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Show error dialog for incorrect password
          if (!context.mounted) return;
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: Text(
                  S.of(context).incorrectPassword,
                  style: Styles.titleDialog,
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      S.of(context).ok,
                      style: Styles.styleCanselButton,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (error) {
        print("Error deleting driver: $error");
        // Show error dialog
        // ...
      }
    }
  }
}
