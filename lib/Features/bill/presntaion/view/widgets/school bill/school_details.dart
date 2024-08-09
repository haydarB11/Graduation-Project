import 'package:flutter/material.dart';
import 'package:shamseenfactory/Features/bill/utils.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import '../../../../../../generated/l10n.dart';
import 'data/school_bills_model.dart';

class SchoolDetailsScreen extends StatelessWidget {
  final School school;

  const SchoolDetailsScreen({required this.school});

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
              DetailRow(label: S.of(context).schoolName, value: school.nameAr),

              const SizedBox(height: 10),
              // _buildDetailRow('School ID', school.id),
              DetailRow(
                  label: "${S.of(context).region}:", value: school.region),
              const SizedBox(height: 10),
              DetailRow(label: "${S.of(context).type}:", value: school.type),
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
                        DetailRow(
                            label: S.of(context).sellPointName,
                            value: sellPoint.name),
                        DetailRow(
                            label: "${S.of(context).total}:",
                            value: totalAmount),
                        DetailRow(
                            label: "${S.of(context).totalQuantity}:",
                            value: totalQuantity),
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
                                              DetailRow(
                                                  label: S
                                                      .of(context)
                                                      .categoryName,
                                                  value:
                                                      category.category.nameAr),
                                              DetailRow(
                                                  label: 'الكمية:',
                                                  value: category.amount),
                                              DetailRow(
                                                  label:
                                                      "${S.of(context).totalPrice}:",
                                                  value: category.totalPrice),
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
}
