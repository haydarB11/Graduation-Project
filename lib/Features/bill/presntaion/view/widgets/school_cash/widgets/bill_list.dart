import 'package:flutter/material.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'package:intl/intl.dart';

class BillListView extends StatelessWidget {
  const BillListView({
    super.key,
    required this.bills,
    required this.context,
  });

  final List<Map<String, dynamic>> bills;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    if (bills.isEmpty) {
      // Display a message when there is no data
      return Center(
        child: Text(
          S.of(context).noData,
          style: Styles.textStyle18,
        ),
      );
    } else {
      return ListView.builder(
        itemCount: bills.length,
        itemBuilder: (context, index) {
          final bill = bills[index];
          String date = '';
          if (bill['date'] != null && bill['date'].toString().length >= 10) {
            date = bill['date'].toString().substring(0, 10);
          }

          return Card(
            elevation: 2, // Add elevation for a card-like appearance
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.all(10), // Add padding for better spacing
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: Styles.textStyle16),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Count: ${bill['total_quantity']}',
                    style: Styles.textStyle14,
                  ),
                  Text(
                    'Total Price: ${bill['total']}',
                    style: Styles.textStyle14,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
