import 'dart:developer';
import 'dart:io';
import 'dart:async';

class ConnectionChecker {
  ConnectionChecker._internal(this.apiURL);

  static ConnectionChecker? _instance;

  factory ConnectionChecker(String apiURL) {
    _instance ??= ConnectionChecker._internal(apiURL);
    return _instance!;
  }

  final String apiURL;
  bool _isConnected = false;

  Future<void> initialize() async {
    _isConnected = await checkConnection();
  }

  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup(apiURL);
      _isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      log("Internet connection status: $_isConnected",
          name: "ConnectionChecker");
    } on SocketException catch (e) {
      log("SocketException: $e", name: "ConnectionChecker");
      _isConnected = false;
    }
    return _isConnected;
  }

  bool get isConnected => _isConnected;
}
