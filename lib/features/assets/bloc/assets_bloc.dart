import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile_challenge/core/connection_checker/connectivity_checker.dart';
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

    _isConnectedStreamSubscription =
        connectivityChecker.isConnectedStream.listen((event) {
      if ((tree?.rootNodes.isEmpty ?? true) && event) {
        add(const FetchAssetsEvent());
      }
    });
  }

  final String id;
  final ApiService apiService;
  final ConnectivityChecker connectivityChecker;
  Tree? tree;
  List<LocationModel> locationsList = [];
  List<ComponentModel> componentsList = [];
  List<AssetModel> assetsList = [];
  StreamSubscription? _isConnectedStreamSubscription;

  Future<void> _onFetchAssetsEvent(
      FetchAssetsEvent event, Emitter<AssetsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      if (!connectivityChecker.isConnected) {
        emit(state.copyWith(isLoading: false, tree: null));
        return;
      }

      final data = await Future.wait(
          [apiService.getLocations(id), apiService.getAssets(id)]);

      locationsList = data[0]
          .map((locations) => LocationModel(
              id: locations["id"],
              name: locations["name"],
              parentId: locations["parentId"]))
          .toList();

      componentsList = data[1]
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

      assetsList = data[1]
          .where((item) => item["sensorType"] == null)
          .map((asset) => AssetModel(
                id: asset["id"],
                name: asset["name"],
                parentId: asset["parentId"],
                locationId: asset["locationId"],
              ))
          .toList();

      tree = Tree.generateTree(id, locationsList, assetsList, componentsList);

      emit(state.copyWith(tree: tree, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, tree: null));
    }
  }

  void _onEnergySensorFilterEvent(
      EnergySensorFilterEvent event, Emitter<AssetsState> emit) async {
    emit(state.copyWith(
      energySensorFilter: !state.energySensorFilter,
      isLoading: true,
    ));

    emit(state.copyWith(
      tree: _apllyFilters(),
      isLoading: false,
    ));
  }

  void _onCriticalFilterEvent(
      CriticalFilterEvent event, Emitter<AssetsState> emit) async {
    emit(state.copyWith(
      criticalFilter: !state.criticalFilter,
      isLoading: true,
    ));

    emit(state.copyWith(
      tree: _apllyFilters(),
      isLoading: false,
    ));
  }

  void _onSearchFilterEvent(
      SearchFilterEvent event, Emitter<AssetsState> emit) {
    emit(state.copyWith(
      searchTextFilter: event.searchText,
      isLoading: true,
    ));

    emit(state.copyWith(
      tree: _apllyFilters(),
      isLoading: false,
    ));
  }

  Tree? _apllyFilters() {
    Tree? filteredTree = tree;

    if (state.energySensorFilter) {
      filteredTree = filteredTree?.filterBy((node) => node.isEnergy);
    }

    if (state.criticalFilter) {
      filteredTree = filteredTree?.filterBy((node) => node.isCritical);
    }

    if (state.searchTextFilter.isNotEmpty) {
      filteredTree = filteredTree?.filterBy((node) => node.value
          .toLowerCase()
          .contains(state.searchTextFilter.toLowerCase()));
    }

    return filteredTree;
  }

  @override
  Future<void> close() async {
    await _isConnectedStreamSubscription?.cancel();
    return super.close();
  }
}
