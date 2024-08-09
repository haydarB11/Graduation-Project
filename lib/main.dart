import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shamseenfactory/Features/home/presentaion/manger/cubit/lan_cubit.dart';
import 'package:shamseenfactory/Features/home/presentaion/manger/cubit/state_lan.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/app_router.dart';
import 'package:shamseenfactory/generated/l10n.dart';
import 'Features/Sales_epresentative/cubit/promoter_cubit.dart';
import 'core/utils/cache/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CasheHelper.casheInit();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocaleCubit()..getSavedLanguage(),
        ),

// Provide DriversCubit
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, ChangeLocaleState>(
      builder: (context, state) {
        return MaterialApp.router(
            locale: state.locale,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            theme: ThemeData(
              fontFamily: "Cairo",
              scaffoldBackgroundColor: kBackgroundColor,
              textTheme:
                  Theme.of(context).textTheme.apply(displayColor: kTextColor),
              useMaterial3: true,
            ),
            routerConfig: AppRouter.router,
            title: 'Manger App',
            debugShowCheckedModeBanner: false,
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              for (var locale in supportedLocales) {
                if (deviceLocale != null &&
                    deviceLocale.languageCode == locale.languageCode) {
                  return deviceLocale;
                }
              }
            });
      },
    );
  }
}
