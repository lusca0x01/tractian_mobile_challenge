import 'package:tractian_mobile_challenge/features/home/models/company_model.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeInitEvent extends HomeEvent {
  const HomeInitEvent();
}

class FetchCompaniesEvent extends HomeEvent {
  const FetchCompaniesEvent(this.companiesList);

  final List<CompanyModel> companiesList;
}
