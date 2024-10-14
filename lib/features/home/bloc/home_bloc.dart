import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile_challenge/core/api/api_service.dart';
import 'package:tractian_mobile_challenge/features/home/bloc/home_event.dart';
import 'package:tractian_mobile_challenge/features/home/bloc/home_state.dart';
import 'package:tractian_mobile_challenge/features/home/models/company_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this.apiService) : super(const HomeState()) {
    on<FetchCompaniesEvent>(_onFetchCompaniesEvent);
    on<HomeInitEvent>(_onHomeInitEvent);
  }

  final ApiService? apiService;

  Future<void> _onHomeInitEvent(
      HomeInitEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final data = (await apiService?.getCompanies())
          ?.map((companyMap) => CompanyModel.fromMap(companyMap))
          .toList();

      if (data == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      add(FetchCompaniesEvent(data));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onFetchCompaniesEvent(
      FetchCompaniesEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(companiesList: event.companiesList));
  }
}
