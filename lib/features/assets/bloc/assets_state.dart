import 'package:equatable/equatable.dart';
import 'package:tractian_mobile_challenge/core/tree/tree.dart';

class AssetsState extends Equatable {
  const AssetsState({
    this.isLoading = true,
    this.searchTextFilter = "",
    this.energySensorFilter = false,
    this.criticalFilter = false,
    this.tree,
  });

  final bool isLoading;
  final String searchTextFilter;
  final bool energySensorFilter;
  final bool criticalFilter;
  final Tree? tree;

  AssetsState copyWith({
    bool? isLoading,
    String? searchTextFilter,
    bool? energySensorFilter,
    bool? criticalFilter,
    Tree? tree,
  }) {
    return AssetsState(
      isLoading: isLoading ?? this.isLoading,
      searchTextFilter: searchTextFilter ?? this.searchTextFilter,
      energySensorFilter: energySensorFilter ?? this.energySensorFilter,
      criticalFilter: criticalFilter ?? this.criticalFilter,
      tree: tree ?? this.tree,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, searchTextFilter, energySensorFilter, criticalFilter, tree];
}
