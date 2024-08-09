import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/bill_view.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/card_id.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class BillAll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: kBlueColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kBlueLightColor, kBlueColor],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: deafultpadding,
          vertical: deafultpadding,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: deafultpadding), // Add spacing
              Text(
                S.of(context).selectcategory,
                style: Styles.textStyle18.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: deafultpadding * 2),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 70),
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1, // Square items
                      crossAxisSpacing: deafultpadding,
                      mainAxisSpacing: deafultpadding,
                      children: [
                        CustomBillCard(
                          title: S.of(context).store,
                          pngSrc: 'assets/images/store.png',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BillScreen(type: "raw"),
                              ),
                            );
                          },
                        ),
                        CustomBillCard(
                          title: S.of(context).meals,
                          pngSrc: 'assets/images/l.png',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BillScreen(type: "default"),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
