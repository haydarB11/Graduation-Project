import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shamseenfactory/Features/Sales_epresentative/data/models/promoter.dart';
import 'package:shamseenfactory/Features/Sales_epresentative/data/models/promoter_server.dart';
import 'package:shamseenfactory/constants.dart';

class PromoterCubit extends Cubit<PromoterState> {
  final PromoterService _promoterService = PromoterService();

  PromoterCubit() : super(PromoterInitial());
  List<Promoter> _originalPromoters = [];

  Future<void> fetchPromoters() async {
    emit(PromoterLoading());
    try {
      final List<Promoter> promoters = await _promoterService.fetchPromoters();
      _originalPromoters = promoters;
      emit(PromoterLoaded(promoters));
    } catch (e) {
      print(e);
      emit(PromoterError(e.toString()));
    }
  }

  Future<void> deletePromoter(int promoterId) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/promoters/$promoterId'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] == 'deleted') {
          final currentState = state;
          if (currentState is PromoterLoaded) {
            final updatedPromoters = currentState.promoters
                .where((promoter) => promoter.id != promoterId)
                .toList();

            emit(PromoterLoaded(updatedPromoters));
          }
        } else {
          emit(PromoterError('Failed to delete promoter'));
        }
      } else {
        emit(PromoterError('Failed to delete promoter'));
      }
    } catch (error) {
      emit(PromoterError('An error occurred: $error'));
    }
  }

//   // ...
  Future<void> addPromoter({
    required String nameAr,
    required String nameEn,
    required String user,
    required String password,
    required String phone,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        "name_ar": nameAr,
        "name_en": nameEn,
        "user": user,
        "password": password,
        "phone": phone,
      };

      final response = await http.post(Uri.parse('$baseUrl/promoters/'),
          body: jsonEncode(requestData),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newPromoter = Promoter.fromJson(jsonData['data']);

        final currentState = state;

        if (currentState is PromoterLoaded) {
          final updatedPromoters = [...currentState.promoters, newPromoter];
          emit(PromoterLoaded(updatedPromoters));
        }
      } else {
        emit(PromoterError('Failed to add promoter'));
        print('Current state: $state');
      }
    } catch (error) {
      emit(PromoterError('An error occurred: $error'));
    }
  }

  void searchPromoters(String query) {
    final currentState = state;
    if (currentState is PromoterLoaded) {
      if (query.isEmpty) {
        emit(PromoterLoaded(_originalPromoters));
      } else {
        final trimmedQuery = query.trim().toLowerCase();
        final filteredPromoters = _originalPromoters
            .where((promoter) =>
                promoter.nameAr.toLowerCase().contains(trimmedQuery) ||
                promoter.nameEn.toLowerCase().contains(trimmedQuery))
            .toList();
        print('Search query: $query');
        print('Filtered drivers: $filteredPromoters');
        emit(PromoterLoaded(filteredPromoters));
      }
    }
  }
}

abstract class PromoterState {}

class PromoterInitial extends PromoterState {}

class PromoterLoading extends PromoterState {}

class PromoterLoaded extends PromoterState {
  final List<Promoter> promoters;

  PromoterLoaded(this.promoters);
}

class PromoterError extends PromoterState {
  final String error;

  PromoterError(this.error);
}
