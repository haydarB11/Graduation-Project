import 'package:flutter/material.dart';

import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'package:intl/intl.dart';
import '../../../../utils.dart';
import 'driver_model.dart';

class DriverDetailsScreen extends StatelessWidget {
  final Driver driver;

  DriverDetailsScreen({required this.driver});
  double calculateTotalBills(Driver driver) {
    double total = 0.0;

    if (driver != null && driver.sellPoints != null) {
      // Iterate through the driver's sell points
      for (SellPoint sellPoint in driver.sellPoints) {
        if (sellPoint != null && sellPoint.bills != null) {
          // Iterate through the bills of the sell point
          for (Bill bill in sellPoint.bills) {
            if (bill != null) {
              // Add the total amount of the bill to the total
              total += bill.total ??
                  0.0; // Use 0.0 as the default value if total is null
            }
          }
        }
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueLightColor,
        title: Text(
          S.of(context).driverDetails,
          style: Styles.textStyle20.copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailRow(
                label: S.of(context).driverName,
                value: driver.nameAr,
              )
              // Text('${S.of(context).driverName}${driver.nameAr}',
              //     style: Styles.textStyle20)
              ,
              const SizedBox(height: 10),
              DetailRow(label: S.of(context).driverID, value: driver.id),
              DetailRow(label: S.of(context).Phone, value: driver.phone),
              DetailRow(
                label: "اجمالي الفواتير",
                value: calculateTotalBills(driver)
                    .toString(), // Calculate and display the total of all driver bills here
              ),
              const SizedBox(height: 20),
              Text(S.of(context).sellPoints, style: Styles.textStyle18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: driver.sellPoints.map((sellPoint) {
                  int totalAmount = 0;
                  int totalQuantity = 0;
                  for (var bill in sellPoint.bills) {
                    totalAmount += bill.total.toInt();
                    totalQuantity += bill.totalQuantity;
                  }

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
                          value: sellPoint.name,
                        ),
                        if (sellPoint.promoter != null)
                          DetailRow(
                              label: S.of(context).promoter,
                              value: sellPoint.promoter!.nameAr),
                        if (sellPoint.school != null)
                          Text(S.of(context).billsF, style: Styles.textStyle18),
                        DetailRow(
                            label: S.of(context).total, value: totalAmount),
                        DetailRow(
                            label: S.of(context).totalQuantity,
                            value: totalQuantity),
                        if (sellPoint.bills != null)
                          DetailRow(
                              label: "عدد الفواتير",
                              value: sellPoint.bills.length),
                        const Divider(
                          color: hBackgroundColor,
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: sellPoint.bills.map((bill) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${S.of(context).billF} #${bill.id}',
                                        style: Styles.textStyle16),
                                    Spacer(),
                                    Text(
                                      "${S.of(context).theDate}: ${bill.date.substring(0, 10)}",
                                      style: Styles.textStyle12,
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: bill.billCategories.map((category) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: hBackgroundColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildDetailRow(
                                                S.of(context).categoryName,
                                                category.category.nameAr),
                                            _buildDetailRow('سعر القطعة',
                                                category.category.price),
                                            // Display category name here
                                            _buildDetailRow(
                                                S.of(context).amount,
                                                category.amount),
                                            _buildDetailRow(
                                                S.of(context).totalPrice,
                                                category.totalPrice),
                                            // Divider()
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
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
