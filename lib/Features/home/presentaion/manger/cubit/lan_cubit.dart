import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shamseenfactory/Features/home/presentaion/manger/cubit/state_lan.dart';
import 'package:shamseenfactory/Features/home/presentaion/manger/lan_helper.dart';


class LocaleCubit extends Cubit<ChangeLocaleState> {
  LocaleCubit() : super(ChangeLocaleState(locale: const Locale('en')));

  Future<void> getSavedLanguage() async {
    final String cachedLanguageCode =
        await LanguageCacheHelper().getCachedLanguageCode();

    emit(ChangeLocaleState(locale: Locale(cachedLanguageCode)));
  }

  Future<void> changeLanguage(String languageCode) async {
    await LanguageCacheHelper().cacheLanguageCode(languageCode);
    emit(ChangeLocaleState(locale: Locale(languageCode)));
  }
}