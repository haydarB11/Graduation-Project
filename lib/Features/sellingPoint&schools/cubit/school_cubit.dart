import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shamseenfactory/Features/sellingPoint&schools/presentaion/view/data/school_model.dart';
import 'package:shamseenfactory/constants.dart';

class SpSchoolsCubit extends Cubit<SchoolsState> {
  List<School> _schools = []; // Add this field
  SpSchoolsCubit() : super(SchoolsInitial());

  Future<void> fetchAllSchools() async {
    try {
      emit(SchoolsLoading());
      final response = await http.get(Uri.parse('$baseUrl/schools/'));
      print('API Status Code: ${response.statusCode}');
      print('API Response: ${response.statusCode}\n${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<School> schools = (jsonData['data'] as List?)
                ?.map((schoolData) => School.fromJson(schoolData))
                .toList() ??
            [];

        emit(SchoolsLoaded(schools));
      } else {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Failed to load schools';
        emit(SchoolsError(errorMessage));
      }
    } catch (error) {
      print('$error');
      emit(SchoolsError('An error occurred: $error'));
    }
  }

  Future<void> addSchool({
    required String nameArabic,
    required String nameEnglish,
    required String region,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/schools/'),
        body: jsonEncode({
          'name_ar': nameArabic,
          'name_en': nameEnglish,
          'type': 'school',
          'region': region,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newSchool = School.fromJson(jsonData['data']);
        await fetchAllSchools();
        // Get the current list of schools and add the new school to it
        final currentState = state;
        if (currentState is SchoolsLoaded) {
          final updatedSchools = [...currentState.schools, newSchool];
          emit(SchoolsLoaded(updatedSchools));
        }
      } else {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Failed to add school';
        emit(SchoolsError(errorMessage));
      }
    } catch (error) {
      print('$error');
      emit(SchoolsError('An error occurred: $error'));
    }
  }
}

abstract class SchoolsState {}

class SchoolsInitial extends SchoolsState {}

class SchoolsLoading extends SchoolsState {}

class SchoolsLoaded extends SchoolsState {
  final List<School> schools;

  SchoolsLoaded(this.schools);
}

class SchoolsError extends SchoolsState {
  final String errorMessage;

  SchoolsError(this.errorMessage);
}
