// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // class LanguageCubit extends Cubit<Locale> {
// //   LanguageCubit() : super(Locale('en')); // Default locale is English

// //   void setLanguage(Locale newLocale) => emit(newLocale);
// // }
// class LanguageCubit extends Cubit<Locale> {
//   LanguageCubit() : super(Locale('en'));

//   void setLanguage(Locale newLocale) {
//   print('Setting language: ${newLocale.languageCode}');
//     emit(newLocale);
//     _saveLanguagePreference(newLocale.languageCode);
//   }

//   Future<void> _saveLanguagePreference(String languageCode) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
    
//     await prefs.setString('selectedLanguage', languageCode);
    
//   }

//   Future<void> loadSavedLanguage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final savedLanguage = prefs.getString('selectedLanguage');
//     if (savedLanguage != null) {
//      print('Loading saved language: $savedLanguage');
//       emit(Locale(savedLanguage));
//     }
//   }
// }
