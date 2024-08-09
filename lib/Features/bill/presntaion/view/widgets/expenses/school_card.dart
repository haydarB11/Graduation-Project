import 'package:flutter/material.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';

import 'bills_view.dart';

class SchoolCard extends StatelessWidget {
  final String? schoolArName;

  final int schoolId;
  const SchoolCard({required this.schoolArName, required this.schoolId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BillsEx(
                    id: schoolId,
                    name: schoolArName ?? "",
                  )),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(2),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(deafultpadding),
          leading: Image.asset(
            "assets/images/sp.png",
            color: Colors.black54,
          ),
          title: Text(schoolArName ?? "", style: Styles.textStyle16),
          trailing: const Icon(Icons.arrow_circle_right),
        ),
      ),
    );
  }
}
