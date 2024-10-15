import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityChecker {
  ConnectivityChecker._internal(this.apiURL);

  static ConnectivityChecker? _instance;

  factory ConnectivityChecker(String apiURL) {
    _instance ??= ConnectivityChecker._internal(apiURL);
    return _instance!;
  }

  final String apiURL;
  bool isConnected = false;
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  final StreamController<bool> _connectedController =
      StreamController<bool>.broadcast();
  Stream<bool> get isConnectedStream => _connectedController.stream;

  Future<void> initialize() async {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_connectionChange);
    await checkConnection();
  }

  void _connectionChange(List<ConnectivityResult> result) async {
    await checkConnection();
  }

  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup(apiURL.split("//")[1]);
      isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      log("Internet connection status: $isConnected",
          name: "ConnectivityChecker");
    } on SocketException catch (e) {
      log("SocketException: $e", name: "ConnectivityChecker");
      isConnected = false;
    }

    _connectedController.add(isConnected);
    return isConnected;
  }

  void dispose() async {
    await _connectedController.close();
    await _connectivitySubscription?.cancel();
  }
}
