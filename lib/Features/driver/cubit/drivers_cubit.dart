// import 'dart:convert';
// import 'dart:io';

// import 'package:bloc/bloc.dart';
// import 'package:http/http.dart' as http;
// import 'package:shamseenfactory/Features/driver/data/models/driver_model.dart';
// import 'package:shamseenfactory/constants.dart';

// class DriversCubit extends Cubit<DriversState> {
//   DriversCubit() : super(DriversLoading());
//   void refreshDriverList() {
//     fetchAllDrivers();
//   }

//   List<Driver> _originalDrivers = [];

//   Future<void> fetchAllDrivers() async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/drivers/'));
//       print('API Status Code: ${response.statusCode}'); //
//       print('API Response: ${response.statusCode}\n${response.body}');

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         final List<Driver> drivers = (jsonData['data'] as List)
//             .map((driverData) => Driver.fromJson(driverData))
//             .toList();
//         _originalDrivers = drivers;
//         emit(DriversLoaded(drivers));
//       } else {
//         final errorMessage =
//             json.decode(response.body)['message'] ?? 'Failed to load drivers';
//         emit(DriversError(errorMessage));
//       }
//     } catch (error) {
//       print('$error');
//       emit(DriversError('An error occurred: $error'));
//     }
//   }

//   Future<void> addDriver({
//     required String nameAr,
//     required String nameEn,
//     required String user,
//     required String password,
//     required String phone,
//   }) async {
//     try {
//       final Map<String, dynamic> requestData = {
//         "name_ar": nameAr,
//         "name_en": nameEn,
//         "user": user,
//         "password": password,
//         "phone": phone,
//       };

//       final response = await http.post(Uri.parse('$baseUrl/drivers/'),
//           body: jsonEncode(requestData),
//           headers: {'Content-Type': 'application/json'});

//       print('API Status Code: ${response.statusCode}'); //
//       print('API Response: ${response.statusCode}\n${response.body}');
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         final newDriver = Driver.fromJson(jsonData['data']);

//         final currentState = state;
//         if (currentState is DriversLoaded) {
//           final updatedDrivers = [...currentState.drivers, newDriver];
//           emit(DriversLoaded(updatedDrivers));
//         }
//       } else {
//         emit(DriversError('Failed to add driver'));
//       }
//     } catch (error) {
//       emit(DriversError('An error occurred: $error'));
//     }
//   }

//   Future<void> deleteDriver(int driverId) async {
//     try {
//       final response =
//           await http.delete(Uri.parse('$baseUrl/drivers/$driverId'));

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['data'] == 'deleted') {
//           final currentState = state;
//           if (currentState is DriversLoaded) {
//             final updatedDrivers = currentState.drivers
//                 .where((driver) => driver.id != driverId)
//                 .toList();
//             emit(DriversLoaded(updatedDrivers));
//           }
//         } else {
//           emit(DriversError('Failed to delete driver'));
//         }
//       } else {
//         emit(DriversError('Failed to delete driver'));
//       }
//     } catch (error) {
//       emit(DriversError('An error occurred: $error'));
//     }
//   }

//   // Store the original list of drivers
//   void searchDrivers(String query) {
//     final currentState = state;
//     if (currentState is DriversLoaded) {
//       if (query.isEmpty) {
//         // Reset to the original list when the search query is empty
//         emit(DriversLoaded(_originalDrivers));
//       } else {
//         final trimmedQuery = query.trim().toLowerCase();
//         final filteredDrivers = _originalDrivers
//             .where((driver) =>
//                 driver.nameAr.toLowerCase().contains(trimmedQuery) ||
//                 driver.nameEn.toLowerCase().contains(trimmedQuery))
//             .toList();

//         // Update isSearchResultsEmpty based on the search results

//         print('Search query: $query');
//         print('Filtered drivers: $filteredDrivers');

//         emit(DriversLoaded(filteredDrivers));
//       }
//     }
//   }

//   static Future<void> addSellPointToDriver(
//       {required int driverId, required List<int> ids}) async {
//     try {
//       final Map<String, dynamic> requestData = {
//         "driver_id": driverId,
//         "ids": ids
//       };
//       final url = Uri.parse('$baseUrl/managers/drivers/add-sell-points');

//       print("this form addd${requestData}");
//       final http.Response response = await http.put(url,
//           body: jsonEncode(requestData),
//           headers: {'Content-Type': 'application/json'});
//       print("bode afte encode${response.body}\n");
//       print("after encdoe $requestData");
//       print("this form addd${response.statusCode}");
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['data'] == 'updated') {
//           print("this addedd only");
//           // Successfully added sell points, emit a state or perform any necessary actions
//         } else {
//           throw Exception('Failed to update data');
//         }
//       } else {
//         throw HttpException(
//             'HTTP ${response.statusCode}: ${response.reasonPhrase}');
//       }
//     } catch (error) {
//       throw error;
//     }
//   }
// //  Future<void> addDriver({
// //     required String nameAr,
// //     required String nameEn,
// //     required String user,
// //     required String password,
// //     required String phone,
// //   }) async {
// //     try {
// //       final Map<String, dynamic> requestData = {
// //         "name_ar": nameAr,
// //         "name_en": nameEn,
// //         "user": user,
// //         "password": password,
// //         "phone": phone,
// //       };

// //       final response = await http.post(Uri.parse('$baseUrl/drivers/'),
// //           body: jsonEncode(requestData),
// //           headers: {'Content-Type': 'application/json'});

// //       print('API Status Code: ${response.statusCode}'); //
// //       print('API Response: ${response.statusCode}\n${response.body}');
// //       if (response.statusCode == 200) {
// //         final jsonData = json.decode(response.body);
// //         final newDriver = Driver.fromJson(jsonData['data']);

// //         final currentState = state;
// //         if (currentState is DriversLoaded) {
// //           final updatedDrivers = [...currentState.drivers, newDriver];
// //           emit(DriversLoaded(updatedDrivers));
// //         }
// //       } else {
// //         emit(DriversError('Failed to add driver'));
// //       }
// //     } catch (error) {
// //       emit(DriversError('An error occurred: $error'));
// //     }
// //   }

//   static Future<List<SellPoint>> fetchAllSellPoints() async {
//     try {
//       final response =
//           await http.get(Uri.parse('$baseUrl/managers/sell-points/get-all'));

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         final List<SellPoint> sellPoints = (jsonData['data'] as List)
//             .map((sellPointData) => SellPoint.fromJson(sellPointData))
//             .toList();
//         return sellPoints;
//       } else {
//         throw Exception('Failed to fetch sell points');
//       }
//     } catch (error) {
//       throw Exception('An error occurred: $error');
//     }
//   }
// }

// class DriversState {}

// class DriversLoading extends DriversState {}

// class DriversLoaded extends DriversState {
//   final List<Driver> drivers;

//   DriversLoaded(this.drivers);
// }

// class DriversError extends DriversState {
//   final String message;

//   DriversError(this.message);
// }
