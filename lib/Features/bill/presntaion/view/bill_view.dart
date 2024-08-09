import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/Check%20the%20proportions/cheack_screen.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/bills_r_e.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/card_id.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/total/display_total.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/edit%20bills/edit_bill.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/expenses/school_view_ex.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/material%20movement/category_view.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/percentage/percentage.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/school_cash/school_view.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class BillScreen extends StatelessWidget {
  final String type;

  BillScreen({required this.type});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueColor,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [kBlueLightColor, kBlueColor],
          begin: FractionalOffset(0.0, 0.4),
          end: Alignment.topRight,
        )),
        padding: const EdgeInsets.only(
          top: deafultpadding * 2,
          left: deafultpadding,
          right: deafultpadding,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    GoRouter.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                    height:
                        60), // Add spacing between the back arrow and the cards
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 5)),
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                      //! edit bill 
                        CustomBillCard(
                          title: S.of(context).editBill,
                          pngSrc: 'assets/images/edit.png',
                          press: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DisplayeditBillsBySchoolScreen(type: type),
                            ));
                          },
                        ),
                        //! total
                        CustomBillCard(
                          title: S.of(context).total,
                          pngSrc: 'assets/images/total.png',
                          press: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DisplayBillsTotalScreen(type: type),
                            ));
                          },
                        ),
                        //! expens return deafult
                        CustomBillCard(
                          title: S.of(context).bills,
                          pngSrc: 'assets/images/bill.png',
                          press: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BillRE(type: type),
                            ));
                          },
                        ),
                        CustomBillCard(
                          title: S.of(context).movementOfMaterial,
                          pngSrc: 'assets/images/mot.png',
                          press: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CategoryView(type: type),
                            ));
                          },
                        ),
                        CustomBillCard(
                          title: S.of(context).schoolAccount,
                          pngSrc: 'assets/images/sc.png',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SchoolListScreen(
                                        type: type,
                                      )),
                            );
                          },
                        ),
                        CustomBillCard(
                          title: S.of(context).percentage,
                          pngSrc: 'assets/images/b.png',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => percentage(
                                        type: type,
                                      )),
                            );
                          },
                        ),
                        CustomBillCard(
                          title: "الجرد",
                          pngSrc: 'assets/images/i.png',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SchoolView(
                                        type: type,
                                      )),
                            );
                          },
                        ),
                        CustomBillCard(
                          title: S.of(context).check,
                          pngSrc: 'assets/images/check.png',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheackScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
