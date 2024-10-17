import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile_challenge/core/connection_checker/connectivity_checker.dart';
import 'package:tractian_mobile_challenge/core/api/api_service.dart';
import 'package:tractian_mobile_challenge/features/home/bloc/home_event.dart';
import 'package:tractian_mobile_challenge/features/home/bloc/home_state.dart';
import 'package:tractian_mobile_challenge/features/home/models/company_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.connectivityChecker, required this.apiService})
      : super(const HomeState()) {
    on<FetchCompaniesEvent>(_onFetchCompaniesEvent);

    _isConnectedStreamSubscription =
        connectivityChecker.isConnectedStream.listen((event) {
      add(const FetchCompaniesEvent());
    });
  }

  final ApiService apiService;
  final ConnectivityChecker connectivityChecker;
  StreamSubscription? _isConnectedStreamSubscription;

  Future<void> _onFetchCompaniesEvent(
      FetchCompaniesEvent event, Emitter<HomeState> emit) async {
    if (!connectivityChecker.isConnected) {
      emit(state.copyWith(isLoading: false, companiesList: []));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final data = (await apiService.getCompanies())
          .map((companyMap) => CompanyModel.fromMap(companyMap))
          .toList();

      emit(state.copyWith(companiesList: data, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  @override
  Future<void> close() async {
    await _isConnectedStreamSubscription?.cancel();
    return super.close();
  }
}
