import 'dart:developer';

import 'package:tractian_mobile_challenge/core/connection_checker/connectivity_checker.dart';
import 'package:tractian_mobile_challenge/core/api/api_service.dart';
import 'package:tractian_mobile_challenge/features/home/models/company_model.dart';

/// The [Config] class is responsible for setting up the environment and
/// initializing core services such as the connectivity checker and the API
/// service.
///
/// It provides an interface to the [ApiService] and [ConnectivityChecker]
/// instances.
class Config {
  static const String baseURL = String.fromEnvironment('BASE_URL');
  static late ApiService apiService;
  static late ConnectivityChecker connectivityChecker;

  /// This method is responsible for initializing necessary components such
  /// as onnectivity checker and the API service. It ensures that a valid
  /// baseURL is provided, sets up the required services, and preloads data
  /// if the device is connected to the internet.
  static Future<void> init() async {
    if (baseURL.isEmpty) {
      throw Exception("Error: The URL must be provided");
    }

    connectivityChecker = ConnectivityChecker(baseURL);
    await connectivityChecker.initialize();
    apiService = ApiService(baseURL);

    if (connectivityChecker.isConnected) await _fetchAll();
  }

  /// This method is responsible for making multiple API requests in bulk to
  /// retrieve data in a concurrent and efficient manner. It loads data for
  /// companies, assets, and locations asynchronously and handles potential
  /// errors during the data fetching process.
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
      log('Error fetching data: $e', name: "Config");
    }
  }
}
