import 'package:flutter/material.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/school_cash/SchoolBillsScreen.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';

import '../data/school_model.dart';

class SchoolListItem extends StatelessWidget {
  final School school;
  final String type;
  SchoolListItem({required this.school, required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0, // Add elevation for a shadow effect
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.school, color: kBlueColor), // School icon
        title: Text(
          school.nameAr,
          style: Styles.textStyle18,
        ),
        subtitle: Text(
          school.nameEn,
          style: Styles.textStyle16,
        ),
        trailing: const Icon(Icons.arrow_forward_ios), // Right arrow icon
        onTap: () {
          print(school.id);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SchoolBillsScreen(
                  schoolId: school.id, name: school.nameAr, type: type),
            ),
          );
          // Add any action you want when a school item is tapped
          // For example, navigate to a school details screen
        },
      ),
    );
  }
}
