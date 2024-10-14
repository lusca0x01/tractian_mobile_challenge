import 'package:equatable/equatable.dart';
import 'package:tractian_mobile_challenge/features/home/models/company_model.dart';

class HomeState extends Equatable {
  const HomeState({this.isLoading = true, this.companiesList = const []});

  final bool isLoading;
  final List<CompanyModel> companiesList;

  HomeState copyWith({List<CompanyModel>? companiesList, bool? isLoading}) {
    return HomeState(
        companiesList: companiesList ?? this.companiesList,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [companiesList, isLoading];
}
