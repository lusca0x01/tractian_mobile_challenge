import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// The [ConnectivityChecker] class is responsible for monitoring the device's
/// network connectivity status and checking whether the device has access
/// to a network connection.
///
/// It uses the connectivity_plus package to listen for connectivity
/// changes and manually verifies connectivity by attempting to resolve the API
/// URL.
///
/// This class is a Singleton, but it's preferably to use the instance present
/// on the Config class.
class ConnectivityChecker {
  ConnectivityChecker._internal(this.apiURL);

  static ConnectivityChecker? _instance;

  /// Constructs a singleton instance of [ConnectivityChecker] with API URL as
  /// a parameter.
  ///
  /// [ConnectivityChecker] is designed to work as a singleton.
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

  /// Provides a stream of the current internet connection status. Listeners
  /// can subscribe to this stream to be notified of any changes in
  /// connectivity.
  Stream<bool> get isConnectedStream => _connectedController.stream;

  /// Initializes the connectivity checker by subscribing to connectivity
  /// changes using the connectivity_plus package.
  ///
  /// Calls the [checkConnection] method to perform an initial check of the
  /// connection status.
  Future<void> initialize() async {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_connectionChange);
    await checkConnection();
  }

  void _connectionChange(List<ConnectivityResult> result) async {
    await checkConnection();
  }

  /// Checks whether the device is connected to the internet by attempting to
  /// resolve the IP address of the API URL using [InternetAddress.lookup].
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
