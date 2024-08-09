// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;
 
      return instance;
    });
  } 

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null, 'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `hello`
  String get welcom {
    return Intl.message(
      'hello',
      name: 'welcom',
      desc: '',
      args: [],
    );
  }

  /// `Good Day`
  String get welcom2 {
    return Intl.message(
      'Good Day',
      name: 'welcom2',
      desc: '',
      args: [],
    );
  }

  /// `Driver`
  String get cdriver {
    return Intl.message(
      'Driver',
      name: 'cdriver',
      desc: '',
      args: [],
    );
  }

  /// `Sales epresentative`
  String get csalesexp {
    return Intl.message(
      'Sales epresentative',
      name: 'csalesexp',
      desc: '',
      args: [],
    );
  }

  /// `selling points`
  String get csellingpoint {
    return Intl.message(
      'selling points',
      name: 'csellingpoint',
      desc: '',
      args: [],
    );
  }

  /// `Goods`
  String get cGoods {
    return Intl.message(
      'Goods',
      name: 'cGoods',
      desc: '',
      args: [],
    );
  }

  /// `bills`
  String get cbill {
    return Intl.message(
      'bills',
      name: 'cbill',
      desc: '',
      args: [],
    );
  }

  /// `All driver`
  String get tAllDriver {
    return Intl.message(
      'All driver',
      name: 'tAllDriver',
      desc: '',
      args: [],
    );
  }

  /// `All sales point for this driver`
  String get tAllSchoolsforthisdriver {
    return Intl.message(
      'All sales point for this driver',
      name: 'tAllSchoolsforthisdriver',
      desc: '',
      args: [],
    );
  }

  /// `All Sales epresentative`
  String get tAllSalesepresentative {
    return Intl.message(
      'All Sales epresentative',
      name: 'tAllSalesepresentative',
      desc: '',
      args: [],
    );
  }

  /// `All Schools for this Sales epresentative`
  String get tAllSchoolsforthisSalesepresentative {
    return Intl.message(
      'All Schools for this Sales epresentative',
      name: 'tAllSchoolsforthisSalesepresentative',
      desc: '',
      args: [],
    );
  }

  /// `Points of sale and schools`
  String get tPointsofsaleandschools {
    return Intl.message(
      'Points of sale and schools',
      name: 'tPointsofsaleandschools',
      desc: '',
      args: [],
    );
  }

  /// `All Goods`
  String get tAllGoods {
    return Intl.message(
      'All Goods',
      name: 'tAllGoods',
      desc: '',
      args: [],
    );
  }

  /// `total`
  String get total {
    return Intl.message(
      'total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Total Screen`
  String get totalScreen {
    return Intl.message(
      'Total Screen',
      name: 'totalScreen',
      desc: '',
      args: [],
    );
  }

  /// `Promoter Bills`
  String get promoterBills {
    return Intl.message(
      'Promoter Bills',
      name: 'promoterBills',
      desc: '',
      args: [],
    );
  }

  /// `Search by Promoter Name`
  String get searchByPromoterName {
    return Intl.message(
      'Search by Promoter Name',
      name: 'searchByPromoterName',
      desc: '',
      args: [],
    );
  }

  /// `Edit bill`
  String get editBill {
    return Intl.message(
      'Edit bill',
      name: 'editBill',
      desc: '',
      args: [],
    );
  }

  /// `Fetch Bills`
  String get fetchBills {
    return Intl.message(
      'Fetch Bills',
      name: 'fetchBills',
      desc: '',
      args: [],
    );
  }

  /// `Add New Driver`
  String get addNewDriver {
    return Intl.message(
      'Add New Driver',
      name: 'addNewDriver',
      desc: '',
      args: [],
    );
  }

  /// `Add New Category`
  String get addNewCategory {
    return Intl.message(
      'Add New Category',
      name: 'addNewCategory',
      desc: '',
      args: [],
    );
  }

  /// `No sell points available for this driver.`
  String get noSellPointsForDriver {
    return Intl.message(
      'No sell points available for this driver.',
      name: 'noSellPointsForDriver',
      desc: '',
      args: [],
    );
  }

  /// `Select a Sell Point`
  String get selectSellPoint {
    return Intl.message(
      'Select a Sell Point',
      name: 'selectSellPoint',
      desc: '',
      args: [],
    );
  }

  /// `Search Sell Points`
  String get searchSellPoints {
    return Intl.message(
      'Search Sell Points',
      name: 'searchSellPoints',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Edit Bills`
  String get editBills {
    return Intl.message(
      'Edit Bills',
      name: 'editBills',
      desc: '',
      args: [],
    );
  }

  /// `Search for promoter`
  String get searchForPromoter {
    return Intl.message(
      'Search for promoter',
      name: 'searchForPromoter',
      desc: '',
      args: [],
    );
  }

  /// `Add New Promoter`
  String get addNewPromoter {
    return Intl.message(
      'Add New Promoter',
      name: 'addNewPromoter',
      desc: '',
      args: [],
    );
  }

  /// `Promoter added successfully`
  String get promoterAddedSuccessfully {
    return Intl.message(
      'Promoter added successfully',
      name: 'promoterAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to add Promoter`
  String get failedToAddPromoter {
    return Intl.message(
      'Failed to add Promoter',
      name: 'failedToAddPromoter',
      desc: '',
      args: [],
    );
  }

  /// `Failed to add promoter. Check your internet connection`
  String get checkInternetConnection {
    return Intl.message(
      'Failed to add promoter. Check your internet connection',
      name: 'checkInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `No sell points available for this promoter.`
  String get noSellPointsForPromoter {
    return Intl.message(
      'No sell points available for this promoter.',
      name: 'noSellPointsForPromoter',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Insert all data to add`
  String get insertAllDataToAdd {
    return Intl.message(
      'Insert all data to add',
      name: 'insertAllDataToAdd',
      desc: '',
      args: [],
    );
  }

  /// `Invalid data`
  String get invalidDate {
    return Intl.message(
      'Invalid data',
      name: 'invalidDate',
      desc: '',
      args: [],
    );
  }

  /// `Sell Point added successfully!`
  String get sellPointAddedSuccessfully {
    return Intl.message(
      'Sell Point added successfully!',
      name: 'sellPointAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Sell Point Added`
  String get sellPointAdded {
    return Intl.message(
      'Sell Point Added',
      name: 'sellPointAdded',
      desc: '',
      args: [],
    );
  }

  /// `Select promoter`
  String get selectPromoter {
    return Intl.message(
      'Select promoter',
      name: 'selectPromoter',
      desc: '',
      args: [],
    );
  }

  /// `Select Driver`
  String get selectDriver {
    return Intl.message(
      'Select Driver',
      name: 'selectDriver',
      desc: '',
      args: [],
    );
  }

  /// `Search for a school`
  String get searchForSchool {
    return Intl.message(
      'Search for a school',
      name: 'searchForSchool',
      desc: '',
      args: [],
    );
  }

  /// `School`
  String get school {
    return Intl.message(
      'School',
      name: 'school',
      desc: '',
      args: [],
    );
  }

  /// `Add Sell Point`
  String get addSellPoint {
    return Intl.message(
      'Add Sell Point',
      name: 'addSellPoint',
      desc: '',
      args: [],
    );
  }

  /// `Add school`
  String get addSchool {
    return Intl.message(
      'Add school',
      name: 'addSchool',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete school`
  String get failedToDeleteSchool {
    return Intl.message(
      'Failed to delete school',
      name: 'failedToDeleteSchool',
      desc: '',
      args: [],
    );
  }

  /// `School deleted successfully`
  String get schoolDeletedSuccessfully {
    return Intl.message(
      'School deleted successfully',
      name: 'schoolDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this school?`
  String get confirmDeleteSchool {
    return Intl.message(
      'Are you sure you want to delete this school?',
      name: 'confirmDeleteSchool',
      desc: '',
      args: [],
    );
  }

  /// `Delete School`
  String get deleteSchool {
    return Intl.message(
      'Delete School',
      name: 'deleteSchool',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this school?`
  String get areYouSureDeleteSchool {
    return Intl.message(
      'Are you sure you want to delete this school?',
      name: 'areYouSureDeleteSchool',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete sale point`
  String get failedToDeleteSp {
    return Intl.message(
      'Failed to delete sale point',
      name: 'failedToDeleteSp',
      desc: '',
      args: [],
    );
  }

  /// `Sale point deleted successfully`
  String get spDeletedSuccessfully {
    return Intl.message(
      'Sale point deleted successfully',
      name: 'spDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this sale point?`
  String get confirmDeleteSp {
    return Intl.message(
      'Are you sure you want to delete this sale point?',
      name: 'confirmDeleteSp',
      desc: '',
      args: [],
    );
  }

  /// `Delete sale point`
  String get deleteSp {
    return Intl.message(
      'Delete sale point',
      name: 'deleteSp',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this category?`
  String get confirmDeleteCategory {
    return Intl.message(
      'Are you sure you want to delete this category?',
      name: 'confirmDeleteCategory',
      desc: '',
      args: [],
    );
  }

  /// `Deletion Failed`
  String get deletionFailed {
    return Intl.message(
      'Deletion Failed',
      name: 'deletionFailed',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting category: The category has been successfully deleted.`
  String get errorDeletingCategory {
    return Intl.message(
      'Error deleting category: The category has been successfully deleted.',
      name: 'errorDeletingCategory',
      desc: '',
      args: [],
    );
  }

  /// `Deletion Successful`
  String get deletionSuccessful {
    return Intl.message(
      'Deletion Successful',
      name: 'deletionSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Deletion`
  String get confirmDeletion {
    return Intl.message(
      'Confirm Deletion',
      name: 'confirmDeletion',
      desc: '',
      args: [],
    );
  }

  /// `School added successfully`
  String get schoolAddedSuccessfully {
    return Intl.message(
      'School added successfully',
      name: 'schoolAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Pick Image`
  String get pickImage {
    return Intl.message(
      'Pick Image',
      name: 'pickImage',
      desc: '',
      args: [],
    );
  }

  /// `Please pick an image before proceeding`
  String get pleasePickImage {
    return Intl.message(
      'Please pick an image before proceeding',
      name: 'pleasePickImage',
      desc: '',
      args: [],
    );
  }

  /// `Visibility`
  String get visibility {
    return Intl.message(
      'Visibility',
      name: 'visibility',
      desc: '',
      args: [],
    );
  }

  /// `Source`
  String get source {
    return Intl.message(
      'Source',
      name: 'source',
      desc: '',
      args: [],
    );
  }

  /// `External`
  String get external {
    return Intl.message(
      'External',
      name: 'external',
      desc: '',
      args: [],
    );
  }

  /// `Internal`
  String get internal {
    return Intl.message(
      'Internal',
      name: 'internal',
      desc: '',
      args: [],
    );
  }

  /// `School Type`
  String get schoolType {
    return Intl.message(
      'School Type',
      name: 'schoolType',
      desc: '',
      args: [],
    );
  }

  /// `Kindergarten`
  String get kindergarten {
    return Intl.message(
      'Kindergarten',
      name: 'kindergarten',
      desc: '',
      args: [],
    );
  }

  /// `Store`
  String get store {
    return Intl.message(
      'Store',
      name: 'store',
      desc: '',
      args: [],
    );
  }

  /// `Damage`
  String get damage {
    return Intl.message(
      'Damage',
      name: 'damage',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid price`
  String get pleaseEnterValidPrice {
    return Intl.message(
      'Please enter a valid price',
      name: 'pleaseEnterValidPrice',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid name`
  String get pleaseEnterValidName {
    return Intl.message(
      'Please enter a valid name',
      name: 'pleaseEnterValidName',
      desc: '',
      args: [],
    );
  }

  /// `Category Name (English)`
  String get categoryNameEnglish {
    return Intl.message(
      'Category Name (English)',
      name: 'categoryNameEnglish',
      desc: '',
      args: [],
    );
  }

  /// `Category Name (Arabic)`
  String get categoryNameArabic {
    return Intl.message(
      'Category Name (Arabic)',
      name: 'categoryNameArabic',
      desc: '',
      args: [],
    );
  }

  /// `Edit Category`
  String get editCategory {
    return Intl.message(
      'Edit Category',
      name: 'editCategory',
      desc: '',
      args: [],
    );
  }

  /// `Display Bills by Schools`
  String get displayBillsBySchools {
    return Intl.message(
      'Display Bills by Schools',
      name: 'displayBillsBySchools',
      desc: '',
      args: [],
    );
  }

  /// `Display Bills two dates`
  String get displayBillsTwoDate {
    return Intl.message(
      'Display Bills two dates',
      name: 'displayBillsTwoDate',
      desc: '',
      args: [],
    );
  }

  /// `Display Bills by Promoters`
  String get displayBillsByPromoters {
    return Intl.message(
      'Display Bills by Promoters',
      name: 'displayBillsByPromoters',
      desc: '',
      args: [],
    );
  }

  /// `Display Bills by Drivers`
  String get displayBillsByDrivers {
    return Intl.message(
      'Display Bills by Drivers',
      name: 'displayBillsByDrivers',
      desc: '',
      args: [],
    );
  }

  /// `Select a category to display bills`
  String get selectCategoryToDisplayBills {
    return Intl.message(
      'Select a category to display bills',
      name: 'selectCategoryToDisplayBills',
      desc: '',
      args: [],
    );
  }

  /// `Display Bills`
  String get displayBills {
    return Intl.message(
      'Display Bills',
      name: 'displayBills',
      desc: '',
      args: [],
    );
  }

  /// `No schools found`
  String get noSchoolsFound {
    return Intl.message(
      'No schools found',
      name: 'noSchoolsFound',
      desc: '',
      args: [],
    );
  }

  /// `No sell point found`
  String get noSellPointFound {
    return Intl.message(
      'No sell point found',
      name: 'noSellPointFound',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get noData {
    return Intl.message(
      'No data',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Category Totals`
  String get categoryTotals {
    return Intl.message(
      'Category Totals',
      name: 'categoryTotals',
      desc: '',
      args: [],
    );
  }

  /// `Search by school name`
  String get searchBySchoolName {
    return Intl.message(
      'Search by school name',
      name: 'searchBySchoolName',
      desc: '',
      args: [],
    );
  }

  /// `Bills by School`
  String get billsBySchool {
    return Intl.message(
      'Bills by School',
      name: 'billsBySchool',
      desc: '',
      args: [],
    );
  }

  /// `Generate PDFs for All Schools`
  String get generatePdfsForAllSchools {
    return Intl.message(
      'Generate PDFs for All Schools',
      name: 'generatePdfsForAllSchools',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get selectDate {
    return Intl.message(
      'Select Date',
      name: 'selectDate',
      desc: '',
      args: [],
    );
  }

  /// `No Sell Points Available`
  String get noSellPointsAvailable {
    return Intl.message(
      'No Sell Points Available',
      name: 'noSellPointsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Generate PDF`
  String get generatePdf {
    return Intl.message(
      'Generate PDF',
      name: 'generatePdf',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message(
      'Password',
      name: 'Password',
      desc: '',
      args: [],
    );
  }

  /// `Enter Password`
  String get enterPassword {
    return Intl.message(
      'Enter Password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect Password`
  String get incorrectPassword {
    return Intl.message(
      'Incorrect Password',
      name: 'incorrectPassword',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get Phone {
    return Intl.message(
      'Phone',
      name: 'Phone',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get region {
    return Intl.message(
      'Region',
      name: 'region',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Name (Arabic)`
  String get nameArabic {
    return Intl.message(
      'Name (Arabic)',
      name: 'nameArabic',
      desc: '',
      args: [],
    );
  }

  /// `Name (English)`
  String get nameEnglish {
    return Intl.message(
      'Name (English)',
      name: 'nameEnglish',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Delete`
  String get confirmDelete {
    return Intl.message(
      'Confirm Delete',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this driver?`
  String get sureD {
    return Intl.message(
      'Are you sure you want to delete this driver?',
      name: 'sureD',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this promoter?`
  String get SuerP {
    return Intl.message(
      'Are you sure you want to delete this promoter?',
      name: 'SuerP',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a name (Arabic)`
  String get pleaseEnterNameArabic {
    return Intl.message(
      'Please enter a name (Arabic)',
      name: 'pleaseEnterNameArabic',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a name (English)`
  String get pleaseEnterNameEnglish {
    return Intl.message(
      'Please enter a name (English)',
      name: 'pleaseEnterNameEnglish',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a region`
  String get pleaseEnterRegion {
    return Intl.message(
      'Please enter a region',
      name: 'pleaseEnterRegion',
      desc: '',
      args: [],
    );
  }

  /// `Delete Success`
  String get deleteSuccess {
    return Intl.message(
      'Delete Success',
      name: 'deleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Search for driver`
  String get searchForDriver {
    return Intl.message(
      'Search for driver',
      name: 'searchForDriver',
      desc: '',
      args: [],
    );
  }

  /// `Add Success`
  String get addSuccess {
    return Intl.message(
      'Add Success',
      name: 'addSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Bills`
  String get bills {
    return Intl.message(
      'Bills',
      name: 'bills',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `School Details`
  String get schoolDetails {
    return Intl.message(
      'School Details',
      name: 'schoolDetails',
      desc: '',
      args: [],
    );
  }

  /// `Bills`
  String get bill {
    return Intl.message(
      'Bills',
      name: 'bill',
      desc: '',
      args: [],
    );
  }

  /// `This school has no sell points.`
  String get noSellPoints {
    return Intl.message(
      'This school has no sell points.',
      name: 'noSellPoints',
      desc: '',
      args: [],
    );
  }

  /// `The Date`
  String get theDate {
    return Intl.message(
      'The Date',
      name: 'theDate',
      desc: '',
      args: [],
    );
  }

  /// `Search by Driver Name`
  String get searchByDriverName {
    return Intl.message(
      'Search by Driver Name',
      name: 'searchByDriverName',
      desc: '',
      args: [],
    );
  }

  /// `Bills by Drivers`
  String get billsByDrivers {
    return Intl.message(
      'Bills by Drivers',
      name: 'billsByDrivers',
      desc: '',
      args: [],
    );
  }

  /// `Driver Details bill`
  String get driverDetails {
    return Intl.message(
      'Driver Details bill',
      name: 'driverDetails',
      desc: '',
      args: [],
    );
  }

  /// `Promoter Details bills`
  String get promoterDetails {
    return Intl.message(
      'Promoter Details bills',
      name: 'promoterDetails',
      desc: '',
      args: [],
    );
  }

  /// `Between Two Dates`
  String get betweenTwoDates {
    return Intl.message(
      'Between Two Dates',
      name: 'betweenTwoDates',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get endDate {
    return Intl.message(
      'End Date',
      name: 'endDate',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get startDate {
    return Intl.message(
      'Start Date',
      name: 'startDate',
      desc: '',
      args: [],
    );
  }

  /// `Date Conflict`
  String get dateConflict {
    return Intl.message(
      'Date Conflict',
      name: 'dateConflict',
      desc: '',
      args: [],
    );
  }

  /// `Start day cannot be the same as the end day.`
  String get startEndConflict {
    return Intl.message(
      'Start day cannot be the same as the end day.',
      name: 'startEndConflict',
      desc: '',
      args: [],
    );
  }

  /// `Start day cannot be after the end day.`
  String get startAfterEnd {
    return Intl.message(
      'Start day cannot be after the end day.',
      name: 'startAfterEnd',
      desc: '',
      args: [],
    );
  }

  /// `Display Total in Date`
  String get displayTotalInDate {
    return Intl.message(
      'Display Total in Date',
      name: 'displayTotalInDate',
      desc: '',
      args: [],
    );
  }

  /// `School Details and Bills`
  String get schoolDetailsAndBills {
    return Intl.message(
      'School Details and Bills',
      name: 'schoolDetailsAndBills',
      desc: '',
      args: [],
    );
  }

  /// `No bills available for this date.`
  String get noBillsAvailableForDate {
    return Intl.message(
      'No bills available for this date.',
      name: 'noBillsAvailableForDate',
      desc: '',
      args: [],
    );
  }

  /// `Delete this bill`
  String get deleteThisBill {
    return Intl.message(
      'Delete this bill',
      name: 'deleteThisBill',
      desc: '',
      args: [],
    );
  }

  /// `Add Category`
  String get addCategory {
    return Intl.message(
      'Add Category',
      name: 'addCategory',
      desc: '',
      args: [],
    );
  }

  /// `Edit Amount`
  String get editAmount {
    return Intl.message(
      'Edit Amount',
      name: 'editAmount',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Delete Selected Categories`
  String get deleteSelectedCategories {
    return Intl.message(
      'Delete Selected Categories',
      name: 'deleteSelectedCategories',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the selected categories?`
  String get confirmDeleteCategories {
    return Intl.message(
      'Are you sure you want to delete the selected categories?',
      name: 'confirmDeleteCategories',
      desc: '',
      args: [],
    );
  }

  /// `Generate Excel file`
  String get generateExcelFile {
    return Intl.message(
      'Generate Excel file',
      name: 'generateExcelFile',
      desc: '',
      args: [],
    );
  }

  /// `Movement of Material`
  String get movementOfMaterial {
    return Intl.message(
      'Movement of Material',
      name: 'movementOfMaterial',
      desc: '',
      args: [],
    );
  }

  /// `School Account`
  String get schoolAccount {
    return Intl.message(
      'School Account',
      name: 'schoolAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sell Points`
  String get sellPoints {
    return Intl.message(
      'Sell Points',
      name: 'sellPoints',
      desc: '',
      args: [],
    );
  }

  /// `Sell Point Name:`
  String get sellPointName {
    return Intl.message(
      'Sell Point Name:',
      name: 'sellPointName',
      desc: '',
      args: [],
    );
  }

  /// `Total Quantity`
  String get totalQuantity {
    return Intl.message(
      'Total Quantity',
      name: 'totalQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Category Name:`
  String get categoryName {
    return Intl.message(
      'Category Name:',
      name: 'categoryName',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get totalPrice {
    return Intl.message(
      'Total Price',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Bill`
  String get billF {
    return Intl.message(
      'Bill',
      name: 'billF',
      desc: '',
      args: [],
    );
  }

  /// `Bills`
  String get billsF {
    return Intl.message(
      'Bills',
      name: 'billsF',
      desc: '',
      args: [],
    );
  }

  /// `Driver Name:`
  String get driverName {
    return Intl.message(
      'Driver Name:',
      name: 'driverName',
      desc: '',
      args: [],
    );
  }

  /// `Driver ID`
  String get driverID {
    return Intl.message(
      'Driver ID',
      name: 'driverID',
      desc: '',
      args: [],
    );
  }

  /// `Promoter`
  String get promoter {
    return Intl.message(
      'Promoter',
      name: 'promoter',
      desc: '',
      args: [],
    );
  }

  /// `Bill categories`
  String get billCategories {
    return Intl.message(
      'Bill categories',
      name: 'billCategories',
      desc: '',
      args: [],
    );
  }

  /// `No matching school found.`
  String get noMatchingSchoolFound {
    return Intl.message(
      'No matching school found.',
      name: 'noMatchingSchoolFound',
      desc: '',
      args: [],
    );
  }

  /// `School Name:`
  String get schoolName {
    return Intl.message(
      'School Name:',
      name: 'schoolName',
      desc: '',
      args: [],
    );
  }

  /// `Percentage`
  String get percentage {
    return Intl.message(
      'Percentage',
      name: 'percentage',
      desc: '',
      args: [],
    );
  }

  /// `All category`
  String get allCategory {
    return Intl.message(
      'All category',
      name: 'allCategory',
      desc: '',
      args: [],
    );
  }

  /// `Not Found`
  String get notFound {
    return Intl.message(
      'Not Found',
      name: 'notFound',
      desc: '',
      args: [],
    );
  }

  /// `Category Details`
  String get categoryDetails {
    return Intl.message(
      'Category Details',
      name: 'categoryDetails',
      desc: '',
      args: [],
    );
  }

  /// `Fetch Data`
  String get fetchData {
    return Intl.message(
      'Fetch Data',
      name: 'fetchData',
      desc: '',
      args: [],
    );
  }

  /// `School List`
  String get schoolList {
    return Intl.message(
      'School List',
      name: 'schoolList',
      desc: '',
      args: [],
    );
  }

  /// `Search by Name`
  String get searchByName {
    return Intl.message(
      'Search by Name',
      name: 'searchByName',
      desc: '',
      args: [],
    );
  }

  /// `No schools available.`
  String get noSchoolsAvailable {
    return Intl.message(
      'No schools available.',
      name: 'noSchoolsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `School Bills`
  String get schoolBills {
    return Intl.message(
      'School Bills',
      name: 'schoolBills',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get noDataAvailable {
    return Intl.message(
      'No data available',
      name: 'noDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this bill?`
  String get confirmDeleteBill {
    return Intl.message(
      'Are you sure you want to delete this bill?',
      name: 'confirmDeleteBill',
      desc: '',
      args: [],
    );
  }

  /// `Total Price for All Categories:`
  String get totalPriceForAllCategories {
    return Intl.message(
      'Total Price for All Categories:',
      name: 'totalPriceForAllCategories',
      desc: '',
      args: [],
    );
  }

  /// `Categories in Bill:`
  String get categoriesInBill {
    return Intl.message(
      'Categories in Bill:',
      name: 'categoriesInBill',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Source`
  String get unknownSource {
    return Intl.message(
      'Unknown Source',
      name: 'unknownSource',
      desc: '',
      args: [],
    );
  }

  /// `English Name:`
  String get englishName {
    return Intl.message(
      'English Name:',
      name: 'englishName',
      desc: '',
      args: [],
    );
  }

  /// `No categories selected for deletion`
  String get noCategoriesSelectedForDeletion {
    return Intl.message(
      'No categories selected for deletion',
      name: 'noCategoriesSelectedForDeletion',
      desc: '',
      args: [],
    );
  }

  /// `Enter Amount`
  String get enterAmount {
    return Intl.message(
      'Enter Amount',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Select category`
  String get selectCategory {
    return Intl.message(
      'Select category',
      name: 'selectCategory',
      desc: '',
      args: [],
    );
  }

  /// `Generating PDF... Please wait.`
  String get generatingPDF {
    return Intl.message(
      'Generating PDF... Please wait.',
      name: 'generatingPDF',
      desc: '',
      args: [],
    );
  }

  /// `Meals`
  String get meals {
    return Intl.message(
      'Meals',
      name: 'meals',
      desc: '',
      args: [],
    );
  }

  /// `Select category`
  String get selectcategory {
    return Intl.message(
      'Select category',
      name: 'selectcategory',
      desc: '',
      args: [],
    );
  }

  /// `All points for this school must be deleted`
  String get mustdeletesell {
    return Intl.message(
      'All points for this school must be deleted',
      name: 'mustdeletesell',
      desc: '',
      args: [],
    );
  }

  /// `This point of sale contains invoices. Are you sure you want to delete them?`
  String get confirmDeleteSpWithBills {
    return Intl.message(
      'This point of sale contains invoices. Are you sure you want to delete them?',
      name: 'confirmDeleteSpWithBills',
      desc: '',
      args: [],
    );
  }

  /// `Total price of returns:`
  String get totalpriceofsamples {
    return Intl.message(
      'Total price of returns:',
      name: 'totalpriceofsamples',
      desc: '',
      args: [],
    );
  }

  /// `The total price of the samples:`
  String get Thetotalpriceofthesamples {
    return Intl.message(
      'The total price of the samples:',
      name: 'Thetotalpriceofthesamples',
      desc: '',
      args: [],
    );
  }

  /// `Invoice categories`
  String get invoicecategories {
    return Intl.message(
      'Invoice categories',
      name: 'invoicecategories',
      desc: '',
      args: [],
    );
  }

  /// `category`
  String get category {
    return Intl.message(
      'category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `No matching driver found.`
  String get noMatchingDriverFound {
    return Intl.message(
      'No matching driver found.',
      name: 'noMatchingDriverFound',
      desc: '',
      args: [],
    );
  }

  /// `Returns`
  String get returns {
    return Intl.message(
      'Returns',
      name: 'returns',
      desc: '',
      args: [],
    );
  }

  /// `Expenses`
  String get expenses {
    return Intl.message(
      'Expenses',
      name: 'expenses',
      desc: '',
      args: [],
    );
  }

  /// `Number of Returns:`
  String get numberOfReturns {
    return Intl.message(
      'Number of Returns:',
      name: 'numberOfReturns',
      desc: '',
      args: [],
    );
  }

  /// `Number of Samples`
  String get numberOfSamples {
    return Intl.message(
      'Number of Samples',
      name: 'numberOfSamples',
      desc: '',
      args: [],
    );
  }

  /// `Total Price of Samples`
  String get totalPriceOfSamples {
    return Intl.message(
      'Total Price of Samples',
      name: 'totalPriceOfSamples',
      desc: '',
      args: [],
    );
  }

  /// `Total Price of Returns`
  String get totalPriceOfReturns {
    return Intl.message(
      'Total Price of Returns',
      name: 'totalPriceOfReturns',
      desc: '',
      args: [],
    );
  }

  /// `Check the proportions`
  String get check {
    return Intl.message(
      'Check the proportions',
      name: 'check',
      desc: '',
      args: [],
    );
  }

  /// `All Bills`
  String get allBills {
    return Intl.message(
      'All Bills',
      name: 'allBills',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect Bills`
  String get incorrectBills {
    return Intl.message(
      'Incorrect Bills',
      name: 'incorrectBills',
      desc: '',
      args: [],
    );
  }

  /// `Correct Bills`
  String get correctBills {
    return Intl.message(
      'Correct Bills',
      name: 'correctBills',
      desc: '',
      args: [],
    );
  }

  /// `Plus Bills`
  String get plusBills {
    return Intl.message(
      'Plus Bills',
      name: 'plusBills',
      desc: '',
      args: [],
    );
  }

  /// `display total`
  String get displaytotal {
    return Intl.message(
      'display total',
      name: 'displaytotal',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}