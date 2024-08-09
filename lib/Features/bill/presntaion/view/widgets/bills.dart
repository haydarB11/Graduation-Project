import 'package:flutter/material.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/driver%20bills/driver_bills.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/prmoter%20bills/promoter.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/school%20bill/school_bills.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/tow%20data%20bills/bill_all_towdate.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class DisplayBillsScreen extends StatefulWidget {
  final String type;
  
  DisplayBillsScreen({required this.type,});

  @override
  State<DisplayBillsScreen> createState() => _DisplayBillsScreenState();
}

class _DisplayBillsScreenState extends State<DisplayBillsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.type);
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueLightColor,
        title: Text(
          S.of(context).displayBills,
          style: Styles.textStyle20.copyWith(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              S.of(context).selectCategoryToDisplayBills,
              style: Styles.textStyle20.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            //!school
            ElevatedButton(
              onPressed: () {
                // Navigate to display bills for schools
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayBillsBySchoolScreen(
                        type: widget.type, ),
                  ),
                );
              },
              child: Text(
                S.of(context).displayBillsBySchools,
                style: Styles.textStyle16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //!drivers
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayBillsByDriversScreen(
                        type: widget.type),
                  ),
                );
              },
              child: Text(
                S.of(context).displayBillsByDrivers,
                style: Styles.textStyle16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            //!prmoter
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PromoterBillScreen(type: widget.type),
                  ),
                );
              },
              child: Text(
                S.of(context).displayBillsByPromoters,
                style: Styles.textStyle16,
              ),
            ),
            //!Tow date
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DisplayBillsBySchoolTotalScreen(type: widget.type),
                  ),
                );
              },
              child: Text(
                S.of(context).displayBillsTwoDate,
                style: Styles.textStyle16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
