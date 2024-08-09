import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/total/bill_total_tow_date.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/total/total_bills.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/app_router.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class DisplayBillsTotalScreen extends StatelessWidget {
  final String type;
  DisplayBillsTotalScreen({required this.type});

  @override
  Widget build(BuildContext context) {
    bool isvisible = type != 'raw';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueLightColor,
        title: Text(
          S.of(context).displayBills,
          style: Styles.textStyle20.copyWith(color: Colors.white),
        ),
      ),
      body: Center(
          child: isvisible
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).selectCategoryToDisplayBills,
                      style: Styles.textStyle20.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                      visible: isvisible,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TotalTowdateScreen(type: "default"),
                            ),
                          );
                        },
                        child: const Text(
                          "عرض الاجمالي",
                          style: Styles.textStyle16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: isvisible,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TotalTowdateScreen(type: "expenses"),
                            ),
                          );
                        },
                        child: const Text(
                          "عرض اجمالي عينات المشرف",
                          style: Styles.textStyle16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: isvisible,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TotalTowdateScreen(type: "expens_manager"),
                            ),
                          );
                        },
                        child: const Text(
                          "عرض اجمالي عينات الادارة",
                          style: Styles.textStyle16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TotalTowdateScreen(type: "expens_doctor"),
                          ),
                        );
                      },
                      child: const Text(
                        "عرض اجمالي عينات الطبيب",
                        style: Styles.textStyle16,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TotalTowdateScreen(type: "returns"),
                          ),
                        );
                      },
                      child: const Text(
                        "عرض اجمالي عينات المرتجعات",
                        style: Styles.textStyle16,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TotalTowdateScreen(type: "expens_eco"),
                          ),
                        );
                      },
                      child: const Text(
                        "عرض اجمالي عينات الحالات الاقتصادية",
                        style: Styles.textStyle16,
                      ),
                    )
                  ],
                )
              : ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TotalTowdateScreen(type: type),
                      ),
                    );
                  },
                  child: const Text(
                    "عرض اجمالي عينات  الستور",
                    style: Styles.textStyle16,
                  ),
                )),
    );
  }
}
