import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shamseenfactory/Features/bill/presntaion/view/widgets/bills.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

import 'card_id.dart';

class BillRE extends StatefulWidget {
  final String type;
  const BillRE({super.key, required this.type});

  @override
  State<BillRE> createState() => _BillREState();
}

class _BillREState extends State<BillRE> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cheackName();
  }

  bool isRaw = false;
  String nameT = '';
  String pngs = '';
  void cheackName() {
    if (widget.type == 'raw') {
      setState(() {
        nameT = 'متجر';
        pngs = 'assets/images/store.png';
        isRaw = true;
      });
    } else if (widget.type == 'default') {
      setState(() {
        nameT = 'وجبات';
        pngs = 'assets/images/l.png';
      });
    }
  }

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
                          title: nameT,
                          pngSrc: pngs,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DisplayBillsScreen(
                                  type: widget.type,
                                ),
                              ),
                            );
                          },
                        ),
                        Visibility(
                          visible: !isRaw, // Hide this card if isRaw is true
                          child: CustomBillCard(
                            title: S.of(context).returns,
                            pngSrc: 'assets/images/M.png',
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayBillsScreen(
                                    type: 'returns',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Visibility(
                          visible: !isRaw, // Hide this card if isRaw is true
                          child: CustomBillCard(
                            title: S.of(context).expenses,
                            pngSrc: 'assets/images/Ae.png',
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayBillsScreen(
                                    type: 'expenses',
                                  ),
                                ),
                              );
                            },
                          ),
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
