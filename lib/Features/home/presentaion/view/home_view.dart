import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:shamseenfactory/Features/home/presentaion/manger/cubit/lan_cubit.dart';
import 'package:shamseenfactory/Features/home/presentaion/view/widgets/category_card.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/app_router.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/core/utils/widgets/custom_text.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/constants.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: FadeInDown(
          delay: const Duration(milliseconds: 100),
          child: Stack(
            children: <Widget>[
              Container(
                height: size.height * 0.45,
                decoration: const BoxDecoration(
                  color: hBackgroundColor,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: deafultpadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: deafultpadding * 0.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: 52,
                              width: 52,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF2BEA1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: kBackgroundColor,
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            onSelected: (selectedLanguageCode) {
                              final languageCubit = context
                                  .read<LocaleCubit>()
                                  .changeLanguage(selectedLanguageCode);
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                  value: 'en',
                                  textStyle: Styles.textStyle12
                                      .copyWith(color: Colors.black),
                                  child: const Text('English')),
                              PopupMenuItem<String>(
                                  value: 'ar',
                                  textStyle: Styles.textStyle12
                                      .copyWith(color: Colors.black),
                                  child: const Text('العربية')),
                            ],
                            child: Container(
                              alignment: Alignment.center,
                              height: 52,
                              width: 52,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF2BEA1),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset("assets/images/menu.png"),
                            ),
                          ),
                        ],
                      ),
                      // Positioned(
                      //     bottom: 20,
                      //     left: 0,
                      //     right: 0,
                      //     child: Center(
                      //       child: ElevatedButton(
                      //         onPressed: () {
                      //           print("PK..");
                      //           // Perform logout logic here
                      //           _logout(context);
                      //         },
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor:
                      //               Colors.red, // Change color as needed
                      //         ),
                      //         child: Text(
                      //           "Log out",
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //       ),
                      //     )),
                      const SizedBox(
                        height: deafultpadding,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 52,
                        width: 52,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF2BEA1),
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                            onTap: () {
                              _logout(context);
                            },
                            child: Image.asset(
                              "assets/images/logout.png",
                              height: 30,
                              width: 30,
                            )),
                      ),
                      const SizedBox(
                        height: deafultpadding * 2,
                      ),
                      Text(
                        S.of(context).welcom,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        S.of(context).welcom2,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: .8,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: <Widget>[
                            CategoryCard(
                              title: S.of(context).cdriver,
                              pngSrc: "assets/images/driver.png",
                              press: () {
                                GoRouter.of(context)
                                    .push(AppRouter.kDriverView);
                              },
                            ),
                            CategoryCard(
                              title: S.of(context).csalesexp,
                              pngSrc: "assets/images/Sales_epresentative.png",
                              press: () {
                                GoRouter.of(context)
                                    .push(AppRouter.ksalesEpresentativeView);
                              },
                            ),
                            CategoryCard(
                                title: S.of(context).csellingpoint,
                                pngSrc: "assets/images/selling_point.png",
                                press: () {
                                  GoRouter.of(context).push(AppRouter.kSpc);
                                }),
                            CategoryCard(
                              title: S.of(context).cGoods,
                              pngSrc: "assets/images/goods.png",
                              press: () {
                                GoRouter.of(context).push(AppRouter.kgoodsview);
                              },
                            ),
                            CategoryCard(
                              title: S.of(context).cbill,
                              pngSrc: "assets/images/bill.png",
                              press: () {
                                GoRouter.of(context).push(AppRouter.allbill);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    // Clear the stored token or user data
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token'); // Replace with the actual key you're using

    // Navigate to the login view
    GoRouter.of(context).pushReplacement(AppRouter.klogin);
  }
}
