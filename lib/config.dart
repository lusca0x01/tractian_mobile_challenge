import 'dart:developer';

import 'package:tractian_mobile_challenge/connection_checker.dart';
import 'package:tractian_mobile_challenge/core/api/api_service.dart';
import 'package:tractian_mobile_challenge/features/home/models/company_model.dart';

class Config {
  static const String baseURL = String.fromEnvironment('BASE_URL');
  static ApiService? apiService;
  static ConnectionChecker? connectionChecker;

  static Future<void> init() async {
    if (baseURL.isEmpty) {
      throw Exception("Error: The URL must be provided");
    }

    connectionChecker = ConnectionChecker(baseURL);

    apiService = ApiService(baseURL);
    await _fetchAll();
  }

  static Future<void> _fetchAll() async {
    try {
      final companiesList = (await apiService?.getCompanies())
          ?.map((company) => CompanyModel.fromMap(company))
          .toList();

      if (companiesList == null) {
        throw Exception("Error fetching companies");
      }
    } catch (e) {
      log('Error fetching data: $e');
      throw Exception("Error during data fetching");
    }
  }
}
