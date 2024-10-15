import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile_challenge/connectivity_checker.dart';
import 'package:tractian_mobile_challenge/core/api/api_service.dart';
import 'package:tractian_mobile_challenge/core/tree/tree.dart';
import 'package:tractian_mobile_challenge/features/assets/assets.dart';
import 'package:tractian_mobile_challenge/features/assets/bloc/assets_event.dart';
import 'package:tractian_mobile_challenge/features/assets/bloc/assets_state.dart';

class AssetsBloc extends Bloc<AssetsEvent, AssetsState> {
  AssetsBloc({
    required this.id,
    required this.connectivityChecker,
    required this.apiService,
  }) : super(const AssetsState()) {
    on<FetchAssetsEvent>(_onFetchAssetsEvent);
    on<EnergySensorFilterEvent>(_onEnergySensorFilterEvent);
    on<CriticalFilterEvent>(_onCriticalFilterEvent);
    on<SearchFilterEvent>(_onSearchFilterEvent);
  }

  final String id;
  final ApiService apiService;
  final ConnectivityChecker connectivityChecker;
  Tree? tree;

  Future<void> _onFetchAssetsEvent(
      FetchAssetsEvent event, Emitter<AssetsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final data = await Future.wait(
          [apiService.getLocations(id), apiService.getAssets(id)]);

      final List<LocationModel> locationsList = data[0]
          .map((locations) => LocationModel(
              id: locations["id"],
              name: locations["name"],
              parentId: locations["parentId"]))
          .toList();

      final List<ComponentModel> componentsList = data[1]
          .where((item) => item["sensorType"] != null)
          .map((component) => ComponentModel(
                id: component["id"],
                name: component["name"],
                parentId: component["parentId"],
                sensorId: component["sensorId"],
                sensorType: component["sensorType"],
                status: component["status"],
                gatewayId: component["gatewayId"],
                locationId: component["locationId"],
              ))
          .toList();
      final List<AssetModel> assetsList = data[1]
          .where((item) => item["sensorType"] == null)
          .map((asset) => AssetModel(
                id: asset["id"],
                name: asset["name"],
                parentId: asset["parentId"],
                locationId: asset["locationId"],
              ))
          .toList();

      tree = Tree.generateTree(id, locationsList, assetsList, componentsList);

      emit(state.copyWith(
          locationsList: locationsList,
          assetsList: assetsList,
          componentsList: componentsList,
          isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onEnergySensorFilterEvent(
      EnergySensorFilterEvent event, Emitter<AssetsState> emit) {
    emit(state.copyWith(
        energySensorFilter: !state.energySensorFilter, criticalFilter: false));
  }

  void _onCriticalFilterEvent(
      CriticalFilterEvent event, Emitter<AssetsState> emit) {
    emit(state.copyWith(
        criticalFilter: !state.criticalFilter, energySensorFilter: false));
  }

  void _onSearchFilterEvent(
      SearchFilterEvent event, Emitter<AssetsState> emit) {}
}
