import 'package:flutter/material.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';

class SchoolSalesCard extends StatelessWidget {
  final String schoolName;
  final String ?location;
  final VoidCallback onDelete;

  const SchoolSalesCard({
    required this.schoolName,
    required this.location,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(deafultpadding),
        leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 30,
            child: Image.asset('assets/images/sp.png', color: kBlueColor)),
        title: Text(schoolName, style: Styles.textStyle16),
        subtitle: Text(location!, style: Styles.textStyle12),
      ),
    );
  }
}
