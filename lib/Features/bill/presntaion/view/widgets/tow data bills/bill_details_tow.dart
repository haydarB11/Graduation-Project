import 'package:flutter/material.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/tow%20data%20bills/bill_all_towdate.dart';
import 'package:intl/intl.dart';
// Update this import to the correct path
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class SchoolDetailsTowDateScreen extends StatelessWidget {
  final School school;

  const SchoolDetailsTowDateScreen({required this.school});

  @override
  Widget build(BuildContext context) {
    int totalAmount = 0;
    int totalQuantity = 0;

    // Iterate through sell points
    for (var sellPoint in school.sellPoints) {
      // Iterate through bills for each sell point
      for (var bill in sellPoint.bills) {
        totalAmount += bill.total.toInt();
        totalQuantity += bill.totalquantity;
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueLightColor,
        title: Text(
          S.of(context).schoolDetails,
          style: Styles.textStyle20.copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(S.of(context).schoolName, school.nameAr),

              const SizedBox(height: 10),
              // _buildDetailRow('School ID', school.id),
              _buildDetailRow(S.of(context).region, school.region),
              const SizedBox(height: 10),
              _buildDetailRow(S.of(context).type, school.type),
              const SizedBox(height: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: school.sellPoints.map((sellPoint) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          S.of(context).sellPointName,
                          sellPoint.name,
                        ),
                        _buildDetailRow(S.of(context).total, totalAmount),
                        _buildDetailRow(
                            S.of(context).totalQuantity, totalQuantity),
                        if (sellPoint.bills.isNotEmpty)
                          const SizedBox(height: 20),
                        Text(S.of(context).bill, style: Styles.textStyle18),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: sellPoint.bills.map((bill) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text('${S.of(context).billF} #${bill.id}',
                                    style: Styles.textStyle16),
                                Text(
                                    "${S.of(context).theDate}: ${DateFormat('yyyy-MM-dd', 'en').format(bill.date)}",
                                    style: Styles.textStyle16),
                                if (bill.billCategories.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: Text('No category',
                                        style: Styles.textStyle14),
                                  )
                                else
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        bill.billCategories.map((category) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              border: Border.all(
                                                  color: hBackgroundColor)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildDetailRow(
                                                  S.of(context).categoryName,
                                                  category.category.nameAr),
                                              _buildDetailRow(
                                                  'الكمية', category.amount),
                                              _buildDetailRow(
                                                  S.of(context).totalPrice,
                                                  category.totalPrice),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Styles.textStyle14,
          ),
          Flexible(
            child: Text('$value',
                style: Styles.textStyle14,
                overflow: TextOverflow.ellipsis,
                maxLines: 1),
          ),
        ],
      ),
    );
  }
}
