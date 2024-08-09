import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamseenfactory/Features/driver/data/dirver_api.dart';
import 'package:shamseenfactory/Features/driver/data/models/driver_model.dart';
import 'package:shamseenfactory/Features/driver/presentaion/view/widgets/add_driver_dialog.dart';
import 'package:shamseenfactory/Features/driver/presentaion/view/widgets/driver_card.dart';
import 'package:shamseenfactory/Features/driver/presentaion/view/widgets/search_field.dart';
import 'package:shamseenfactory/Features/driver/presentaion/view/widgets/sp_driver_view.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class DriverList extends StatefulWidget {
  @override
  State<DriverList> createState() => _DriverListState();
}

class _DriverListState extends State<DriverList> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchSubject = PublishSubject<String>();
  final TextEditingController searchController = TextEditingController();
  List<Driver> _drivers = [];
  List<Driver> _fitterdrivers = [];
  bool _isLoading = true;

  void initState() {
    super.initState();
    _fetchAllDrivers();
    _searchSubject
        .debounceTime(Duration(milliseconds: 500))
        .listen((searchQuery) {
      _filterDrivers(searchQuery);
    });
  }

  void dispose() {
    searchController.dispose();
    _searchSubject.close();
    super.dispose();
  }

  void _filterDrivers(String query) {
    _searchSubject.add(query);
    setState(() {
      _fitterdrivers = _drivers.where((driver) {
        final nameArabic = driver.nameAr.toLowerCase();
        final nameEnglish = driver.nameEn.toLowerCase();
        final searchQuery = query.toLowerCase();
        return nameArabic.contains(searchQuery) ||
            nameEnglish.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _fetchAllDrivers() async {
    try {
      final drivers = await DriversApi.fetchAllDrivers();
      setState(() {
        _drivers = drivers;
        _isLoading = false;
        _fitterdrivers = drivers;
      });
    } catch (error) {
      print('An error occurred while fetching drivers: $error');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void refreshDriverList() {
    _fetchAllDrivers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [kBlueLightColor, kBlueColor],
            begin: FractionalOffset(0.0, 0.4),
            end: Alignment.topRight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: deafultpadding * 2,
                left: deafultpadding,
                right: deafultpadding),
            height: 200,
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
                  height: 30,
                ),
                Text(
                  S.of(context).tAllDriver,
                  style: Styles.textStyle20.copyWith(color: Colors.white),
                ),
                const SizedBox(
                  height: deafultpadding,
                ),
                SearchField(
                  searchController: searchController,
                  onchange: _filterDrivers,
                  
                )
              ],
            ),
          ),
          Expanded(
            child: FadeInDown(
              delay: const Duration(milliseconds: 100),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(70)),
                ),
                child: _isLoading
                    ? const Center(
                        child: SpinKitSpinningLines(
                          size: 35,
                          color: hBackgroundColor,
                        ),
                      )
                    : _buildDriverList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverList() {
    if (_fitterdrivers.isEmpty) {
      return Center(
        child: Text(
          'No drivers found.',
          style: Styles.textStyle20.copyWith(color: kActiveIconColor),
        ),
      );
    }

    return ListView.builder(
      itemCount: _fitterdrivers.length,
      itemBuilder: (context, index) {
        final driver = _fitterdrivers[index];
        return DriverCard(
          driver: driver,
          refreshDriverList: refreshDriverList,
        );
      },
    );
  }
}
