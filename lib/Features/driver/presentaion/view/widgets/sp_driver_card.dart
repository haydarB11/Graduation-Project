import 'package:flutter/material.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';

class SpDriverCard extends StatelessWidget {
  final String namesp;

  const SpDriverCard({required this.namesp});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(deafultpadding),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(deafultpadding),
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 30,
          child: Image.asset('assets/images/sp.png', color: kBlueColor),
        ),
        title: Text(namesp, style: Styles.textStyle16),
      ),
    );
  }
}
