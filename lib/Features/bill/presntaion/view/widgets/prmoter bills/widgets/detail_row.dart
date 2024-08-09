
import 'package:flutter/material.dart';
import 'package:shamseenfactory/core/utils/styles.dart';

class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final  value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Styles.textStyle16),
          Text('$value', style: Styles.textStyle16),
        ],
      ),
    );
  }
}
