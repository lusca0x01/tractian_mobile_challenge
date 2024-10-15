import 'package:equatable/equatable.dart';
import 'package:tractian_mobile_challenge/features/assets/assets.dart';

class AssetsState extends Equatable {
  const AssetsState({
    this.isLoading = true,
    this.energySensorFilter = false,
    this.criticalFilter = false,
    this.locationsList = const [],
    this.assetsList = const [],
    this.componentsList = const [],
  });

  final bool isLoading;
  final bool energySensorFilter;
  final bool criticalFilter;
  final List<LocationModel> locationsList;
  final List<AssetModel> assetsList;
  final List<ComponentModel> componentsList;

  AssetsState copyWith({
    bool? isLoading,
    bool? energySensorFilter,
    bool? criticalFilter,
    List<LocationModel>? locationsList,
    List<AssetModel>? assetsList,
    List<ComponentModel>? componentsList,
  }) {
    return AssetsState(
      isLoading: isLoading ?? this.isLoading,
      energySensorFilter: energySensorFilter ?? this.energySensorFilter,
      criticalFilter: criticalFilter ?? this.criticalFilter,
      locationsList: locationsList ?? this.locationsList,
      assetsList: assetsList ?? this.assetsList,
      componentsList: componentsList ?? this.componentsList,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        energySensorFilter,
        criticalFilter,
        locationsList,
        assetsList,
        componentsList,
      ];
}
