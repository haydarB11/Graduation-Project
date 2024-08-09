import 'package:flutter/material.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class SearchFieldSp extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String) onchange;

  const SearchFieldSp({
    required this.searchController,
    required this.onchange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white38),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: onchange,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: S.of(context).searchSellPoints,
                        hintStyle: Styles.textStyle12),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }
}