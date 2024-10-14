import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

// As the API only has 3 GET routes, I will prefer to make it monolithic
class ApiService {
  ApiService._internal(this._apiURL);

  factory ApiService(String apiURL) {
    _instance ??= ApiService._internal(apiURL);
    return _instance!;
  }

  final Duration _cacheDuration =
      const Duration(seconds: 5); // Arbitrary cache duration

  final String _apiURL;
  static ApiService? _instance;

  final List<Map<String, String?>> _companiesMemo = [];
  final List<Map<String, String?>> _locationsMemo = [];
  final List<Map<String, String?>> _assetsMemo = [];

  Future<List<Map<String, String?>>> getCompanies() async {
    try {
      if (_companiesMemo.isNotEmpty) {
        return _companiesMemo;
      }

      final response = await http.get(Uri.parse("$_apiURL/companies"));

      if (response.statusCode == 200) {
        final decodedList =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));

        _companiesMemo.addAll(decodedList.map((map) {
          return map.map((key, value) => MapEntry(key, value?.toString()));
        }));

        _clearCache(_companiesMemo);
        return _companiesMemo;
      } else {
        throw Exception('Failed to load companies: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching companies: $e');
      return [];
    }
  }

  Future<List<Map<String, String?>>> getLocations(String id) async {
    try {
      if (_locationsMemo.isNotEmpty) {
        return _locationsMemo;
      }

      final response =
          await http.get(Uri.parse("$_apiURL/companies/$id/locations"));

      if (response.statusCode == 200) {
        final decodedList =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));

        _locationsMemo.addAll(decodedList.map((map) {
          return map.map((key, value) => MapEntry(key, value?.toString()));
        }));

        _clearCache(_locationsMemo);
        return _locationsMemo;
      } else {
        throw Exception('Failed to load locations: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching locations: $e');
      return [];
    }
  }

  Future<List<Map<String, String?>>> getAssets(String id) async {
    try {
      if (_assetsMemo.isNotEmpty) {
        return _assetsMemo;
      }

      final response =
          await http.get(Uri.parse("$_apiURL/companies/$id/assets"));

      if (response.statusCode == 200) {
        final decodedList =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));

        _assetsMemo.addAll(decodedList.map((map) {
          return map.map((key, value) => MapEntry(key, value?.toString()));
        }));

        _clearCache(_assetsMemo);
        return _assetsMemo;
      } else {
        throw Exception('Failed to load assets: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching assets: $e');
      return [];
    }
  }

  void _clearCache(List<Map<String, String?>> memo) {
    Timer(_cacheDuration, () => memo.clear());
  }
}
