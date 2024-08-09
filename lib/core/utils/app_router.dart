import 'package:go_router/go_router.dart';
import 'package:shamseenfactory/Features/Sales_epresentative/presentaion/view/sales_epresentative_view.dart';
import 'package:shamseenfactory/Features/Splash/presentation/views/splash_view.dart';
import 'package:shamseenfactory/Features/bill/bill_all.dart';

import 'package:shamseenfactory/Features/driver/presentaion/view/driver_view_screen.dart';
import 'package:shamseenfactory/Features/goods/goods_view.dart';
import 'package:shamseenfactory/Features/home/presentaion/view/home_view.dart';
import 'package:shamseenfactory/Features/login/login_view.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/sp_and_schools_view.dart';


abstract class AppRouter {
  static const kHomeView = '/homeView';
  static const kDriverView =
      '/lib/Features/driver/presentaion/view/driver_view_screen.dart';
  static const kschoolDriver =
      '/lib/Features/driver/presentaion/view/widgets/sp_driver_view.dart';
  static const ksalesEpresentativeView =
      '/lib/Features/Sales_epresentative/presentaion/view/sales_epresentative_view.dart.dart';
  static const kschoolSales =
      '/lib/Features/Sales_epresentative/presentaion/view/widgets/school_sales_view.dart';
  static const kBillView = '/lib/Features/bill/presntaion/view/bill_view.dart';
  static const kSpc =
      '/lib/Features/sellingPoint&schools/presentaion/view/sp_and_schools_view.dart';
  static const kgoodsview = '/lib/Features/goods/goods_view.dart';
  static const kEditBill =
      '/lib/Features/bill/presntaion/view/widgets/edit_bill.dart';
  static const klogin = '/lib/Features/login/login_view.dart';
  static const kspachview =
      '/lib/Features/Splash/presentation/views/splash_view.dart';
  static const kDisplayBills =
      '/lib/Features/bill/presntaion/view/widgets/bills.dart';
  static const kDirverBill =
      '/lib/Features/bill/presntaion/view/widgets/driver_bills.dart';
  static const kSchollBill =
      '/lib/Features/bill/presntaion/view/widgets/school_bills.dart';
  static const ktotal = '/lib/Features/bill/presntaion/view/total_bills.dart';
  static const pbill =
      '/lib/Features/bill/presntaion/view/widgets/promoter.dart';
  static const towdate =
      '/lib/Features/bill/presntaion/view/widgets/bill_tow_date.dart';
  static const allbilltowdate =
      '/lib/Features/bill/presntaion/view/widgets/bill_all_towdate.dart';
  static const totalBills =
      '/lib/Features/bill/presntaion/view/widgets/display_total.dart';
  static const kcategoryview =
      '/lib/Features/bill/presntaion/view/widgets/material movement/category_view.dart';
  static const allbill = '/lib/Features/bill/bill_all.dart';
  static final router = GoRouter(routes: [
    GoRoute(
      path: kspachview,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: klogin,
      builder: (context, state) => LoginHomePage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: kHomeView,
      builder: (context, state) => HomeView(),
    ),
    GoRoute(
      path: kDriverView,
      builder: (context, state) => DriverView(),
    ),
    GoRoute(
      path: ksalesEpresentativeView,
      builder: (context, state) => SalesEpresentative(),
    ),
    // GoRoute(
    //   path: kDisplayBills,
    //   builder: (context, state) => DisplayBillsScreen(),
    // ),
    // GoRoute(
    //   path: kDirverBill,
    //   builder: (context, state) => DisplayBillsByDriversScreen(),
    // ),
    GoRoute(path: kSpc, builder: (context, state) => SpSchoolsView()),
    GoRoute(
      path: kgoodsview,
      builder: (context, state) => const GoodsView(),
    ),
    // GoRoute(
    //   path: kEditBill,
    //   builder: (context, state) => (DisplayeditBillsBySchoolScreen()),
    // ),
    // GoRoute(
    //   path: kSchollBill,
    //   builder: (context, state) => DisplayBillsBySchoolScreen(),
    // ),
    // GoRoute(
    //   path: ktotal,
    //   builder: (context, state) => TotalScreen(),
    // ),
    // GoRoute(path: pbill, builder: (context, state) => PromoterBillScreen()),
    // GoRoute(
    //   path: towdate,
    //   builder: (context, state) => TotalTowdateScreen(),
    // ),
    // GoRoute(
    //   path: totalBills,
    //   builder: (context, state) => DisplayBillsTotalScreen(),
    // ),
    // GoRoute(
    //   path: allbilltowdate,
    //   builder: (context, state) => DisplayBillsBySchoolTotalScreen(),
    // ),
    // GoRoute(
    //   path: kcategoryview,
    //   builder: (context, state) => const CategoryView(),
    // ),
    GoRoute(path:allbill,builder: (context, state) => BillAll(), )
  ]);
}
