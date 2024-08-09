import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shamseenfactory/Features/Sales_epresentative/data/models/promoter.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'package:shamseenfactory/Features/Sales_epresentative/presentaion/view/widgets/school_sales_view.dart';
import 'package:http/http.dart' as http;

class SalesEpresentativeCard extends StatelessWidget {
  final Promoter promoter;
  final VoidCallback refreshPrometerList;

  const SalesEpresentativeCard({
    required this.promoter,
    required this.refreshPrometerList,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 15, right: 40, left: 10),
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
        title: Text(
          promoter.nameEn,
          style: Styles.textStyle16.copyWith(
            color: kTextColor,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              promoter.nameAr,
              style: Styles.textStyle12.copyWith(
                color: Colors.black,
              ),
            ),
            Text(
              '${S.of(context).Password}:   ${promoter.password}',
              style: Styles.textStyle12.copyWith(
                color: Colors.black,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SchoolManagementScreenSales(promoter: promoter),
                  ),
                );
                print("object");
              },
              icon: Icon(
                Icons.edit,
                color: Styles.editIconColor,
              ),
            ),
            IconButton(
              onPressed: () {
                _deletePromoter(context, promoter.id);
              },
              icon: Icon(
                Icons.delete,
                color: Styles.delteIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deletePromoter(BuildContext context, int promoterId) async {
    String enteredPassword = '';
    final currentContext = context;
    bool showPassword = false;
    final passwordFieldController = TextEditingController();

    final confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            S.of(context).confirmDelete,
            style: Styles.titleDialog,
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(S.of(context).SuerP),
                TextField(
                  controller: passwordFieldController,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    hintText: S.of(context).enterPassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        print('Before setState - showPassword: $showPassword');
                        setState(() {
                          //   // Use the StateSetter from StatefulBuilder
                          showPassword = !showPassword;
                        });
                        print('After setState - showPassword: $showPassword');
                      },
                      child: Icon(
                        // ignore: dead_code
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    enteredPassword = value;
                  },
                ),
              ],
            );
          }),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child:
                  Text(S.of(context).cancel, style: Styles.styleCanselButton),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child:
                  Text(S.of(context).delete, style: Styles.styledeleteButton),
            ),
          ],
        );
      },
    );
    // await _performDeleteapi(promoterId);

    if (confirm == true) {
      try {
        // Fetch the driver by ID

        if (promoter != null && promoter.password == enteredPassword) {
          await deletePromoter(promoterId);
          refreshPrometerList();

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
                  S.of(context).success,
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

Future<void> deletePromoter(int promoterId) async {
  try {
    final response =
        await http.delete(Uri.parse('$baseUrl/promoters/$promoterId'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['data'] == 'deleted') {
        // setState(() {
        //   _promoters.removeWhere((promoter) => promoter.id == promoterId);
        // });
      } else {
        print('Failed to delete promoter');
      }
    } else {
      print('Failed to delete promoter');
    }
  } catch (error) {
    print('An error occurred: $error');
  }
}
