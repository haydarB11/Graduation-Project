import 'package:flutter/material.dart';
import 'package:shamseenfactory/core/utils/styles.dart';

class SearchFieldGoods extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String) onchange; // New callback

  const SearchFieldGoods({
    required this.searchController,
    required this.onchange, // Pass the callback
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
                border: Border.all(color: Colors.white38)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: onchange,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search by name (Arabic/English)',
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
