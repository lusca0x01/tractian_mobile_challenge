import 'dart:developer';

import 'package:tractian_mobile_challenge/connectivity_checker.dart';
import 'package:tractian_mobile_challenge/core/api/api_service.dart';
import 'package:tractian_mobile_challenge/features/home/models/company_model.dart';

class Config {
  static const String baseURL = String.fromEnvironment('BASE_URL');
  static late ApiService apiService;
  static late ConnectivityChecker connectivityChecker;

  static Future<void> init() async {
    if (baseURL.isEmpty) {
      throw Exception("Error: The URL must be provided");
    }

    connectivityChecker = ConnectivityChecker(baseURL);
    await connectivityChecker.initialize();
    apiService = ApiService(baseURL);

    if (connectivityChecker.isConnected) await _fetchAll();
  }

  static Future<void> _fetchAll() async {
    try {
      final companiesList = (await apiService.getCompanies())
          .map((company) => CompanyModel.fromMap(company))
          .toList();

      final futureAssets =
          companiesList.map((company) => apiService.getAssets(company.id!));
      final futureLocations =
          companiesList.map((company) => apiService.getLocations(company.id!));

      await Future.wait([...futureAssets, ...futureLocations]);
    } catch (e) {
      log('Error fetching data: $e');
      throw Exception("Error during data fetching");
    }
  }
}
