import 'package:flutter/material.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/prmoter%20bills/widgets/detail_row.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class PromoterDetailScreen extends StatelessWidget {
  final Map<String, dynamic> promoter;

  PromoterDetailScreen(this.promoter);

  @override
  Widget build(BuildContext context) {
    var promoterName = promoter['name_ar'] ?? '';
    var promoterPhone = promoter['phone'] ?? "";
    var sellPoints = promoter['sell_points'] ?? "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueLightColor,
        title: Text(
          S.of(context).promoterDetails,
          style: Styles.textStyle20.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${S.of(context).promoter} ${promoterName ?? 'unknow'}',
              style: Styles.textStyle20,
            ),
            DetailRow(label: S.of(context).Phone, value: promoterPhone),
            // _buildDetailRow(S.of(context).username, promoterUser),
            const Divider(),
            Text(S.of(context).sellPoints, style: Styles.textStyle20),
            Column(
              children: [
                for (var sellPoint in sellPoints)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                            title: Text(
                              sellPoint['name'] ?? 'N/A',
                              style: Styles.textStyle18,
                            ),
                            subtitle: Text(
                              sellPoint['school']['name_ar'] ?? 'N/A',
                              style: Styles.textStyle16,
                            )),
                        const Divider(),
                        Text("${S.of(context).billsF} : ",
                            style: Styles.textStyle18),
                        for (var bill in sellPoint['bills'])
                          if (bill != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    '${S.of(context).billF}:  ${bill['id'] ?? 'N/A'}',
                                    style: Styles.textStyle14,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${S.of(context).amount}: ${bill['total_quantity'] ?? 'N/A'}',
                                        style: Styles.textStyle14,
                                      ),
                                      Text(
                                        "${S.of(context).totalPrice}: ${bill['total'] ?? 'N/A'}",
                                        style: Styles.textStyle14,
                                      )
                                    ],
                                  ),
                                ),
                                Text(
                                  S.of(context).billCategories,
                                  style: Styles.textStyle18,
                                ),
                                for (var billCategory
                                    in bill['bill_categories'])
                                  if (billCategory != null)
                                    Card(
                                      child: ListTile(
                                        title: Text(
                                          '${S.of(context).categoryName} ${billCategory['category']['name_ar'] ?? 'N/A'}',
                                          style: Styles.textStyle14,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${S.of(context).amount}: ${billCategory['amount'] ?? 'N/A'}',
                                              style: Styles.textStyle14,
                                            ),
                                            Text(
                                              "${S.of(context).price}: ${billCategory['category']['price'] ?? 'N/A'}",
                                              style: Styles.textStyle14,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                const Divider(
                                  color: kActiveIconColor,
                                ),
                                const Divider()
                              ],
                            ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
