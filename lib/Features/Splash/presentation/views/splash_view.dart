import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shamseenfactory/core/utils/app_router.dart';
import 'package:shamseenfactory/core/utils/assets.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

@override
class _SplashViewState extends State<SplashView> {
  bool _checkedAuthentication = false;

  void initState() {
    super.initState();
    navigateToHome();
  }

  void _checkAuthentication() async {
    final hasToken = await _retrieveStoredToken();
    final router = GoRouter.of(context);

    if (!_checkedAuthentication) {
      _checkedAuthentication = true;

      if (hasToken) {
        router.pushReplacement(AppRouter.kHomeView);
      } else {
        router.pushReplacement(AppRouter.klogin);
      }
    }
  }

  Future<bool> _retrieveStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            body: SizedBox(
                width: w,
                height: h,
                child: Stack(children: [
                  FadeInDown(
                    delay: const Duration(milliseconds: 100),
                    child: Container(
                      width: w,
                      height: h / 2,
                      decoration: const BoxDecoration(
                          color: hBackgroundColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(1000),
                              bottomLeft: Radius.circular(1000))),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: 60,
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: SizedBox(
                        width: w / 1.5,
                        height: h / 10,
                        child: Center(
                          child: Text(
                            "Hello manger",
                            style: Styles.textStyle20
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 130,
                    left: 60,
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      child: SizedBox(
                        width: w / 1.5,
                        height: h / 10,
                        child: Center(
                          child: Text(
                            "Welcom Back",
                            style: Styles.textStyle20
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 220,
                    left: 75,
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 900),
                      child: Spin(
                        delay: const Duration(milliseconds: 1000),
                        child: SizedBox(
                          width: w / 1.6,
                          height: h / 3.3,
                          child: Center(
                              child: Image.asset("assets/images/logo.png")),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 70,
                    left: 80,
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 1300),
                      child: SizedBox(
                        width: w / 1.6,
                        height: h / 19,
                        child: const Center(
                          child: Text(
                            "Wait Moment Beautiful...",
                            style: Styles.textStyle20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 155,
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 1500),
                      child: SizedBox(
                        width: w / 5,
                        height: h / 15,
                        child: Center(
                            child: SpinKitFoldingCube(
                          size: 35,
                          itemBuilder: (BuildContext context, int index) {
                            return const DecoratedBox(
                              decoration: BoxDecoration(
                                color: kBlueLightColor,
                              ),
                            );
                          },
                        )),
                      ),
                    ),
                  ),
                ]))));
  }

  void navigateToHome() {
    Future.delayed(const Duration(seconds: 5), () {
      // GoRouter.of(context).pushReplacement(AppRouter.klogin);
      _checkAuthentication();
    });
  }
}
//  Scaffold(
//       body: SizedBox(
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               MyAssets.splashimage,
//               width: 200,
//             ),
//             const SizedBox(height: deafultpadding * 3),
//             SpinKitPouringHourGlassRefined(
//               color: Colors.orange,
//               size: 50,
//             )
//           ],
//         ),
//       ),
//     );
// child: Scaffold(
//               body: SizedBox(
//             width: w,
//             height: h,
//             child: Stack(children: [
//               FadeInDown(
//                 delay: const Duration(milliseconds: 100),
//                 child: Container(
//                   width: w,
//                   height: h / 2,
//                   decoration: const BoxDecoration(
//                       color: Colors.orange,
//                       borderRadius: BorderRadius.only(
//                           bottomRight: Radius.circular(1000),
//                           bottomLeft: Radius.circular(1000))),
//                 ),
//               ),
    
//     )
// Scaffold(
//       body: SizedBox(
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               MyAssets.splashImage,
//               width: 200,
//             ),
//             const SizedBox(height: deafultpadding * 3),
//             SpinKitPouringHourGlassRefined(
//               color: Colors.orange,
//               size: 50,
//             )
//           ],
//         ),
//       ),
//     );