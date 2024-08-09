import 'package:flutter/material.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

final DateTime now = DateTime.now();

class DateSelect {
  static Future<DateTime?> selectDate(
      BuildContext context, DateTime currentDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    return picked;
  }
}

class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.textColor = Colors.black, // Default text color
  });

  final String label;
  final value;
  final Color textColor; // Optional text color
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Styles.textStyle14.copyWith(color: textColor),
          ),
          Flexible(
            child: Text('$value',
                style: Styles.textStyle14.copyWith(color: textColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 1),
          ),
        ],
      ),
    );
  }
}

class DateContainer extends StatelessWidget {
  const DateContainer({
    super.key,
    required this.context,
    required this.label,
    required this.dateText,
    required this.onPressed,
  });

  final BuildContext context;
  final String label;
  final String dateText;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Styles.textStyle14,
              ),
              const SizedBox(height: 4.0),
              Text(
                dateText,
                style: Styles.textStyle16,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(S.of(context).select,
                style:
                    Styles.textStyle14.copyWith(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class DateConflictDialog {
  static Future<void> show(BuildContext context, String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog won't dismiss when tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              S.of(context).dateConflict), // Replace with your localization key
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  Text(S.of(context).ok), // Replace with your localization key
            ),
          ],
        );
      },
    );
  }
}

class NoData {
  static Future<void> showNoData(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            S.of(context).noData,
            style: Styles.titleDialog,
          ),
          // content: Text(S.of(context).noSellPoints),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                S.of(context).ok,
                style: Styles.styleCanselButton,
              ),
            ),
          ],
        );
      },
    );
  }
}
