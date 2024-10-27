import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:oktoast/oktoast.dart';

class AppHelper {
  /// gives the Snackbar
  static buildToast(
    BuildContext context,
    String? message,
    Color color, {
    int durationMultiplier = 1,
  }) {
    showToast(
      message!,
      context: context,
      position: ToastPosition.bottom,
      backgroundColor: color,
      radius: 13.0,
      animationCurve: Curves.easeIn,
      textStyle: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
    );
  }

  static CommonLoader() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..maskType = EasyLoadingMaskType.clear
      ..userInteractions = false;

    EasyLoading.show(
      maskType: EasyLoadingMaskType.clear,
      status: 'Loading....',
    );
  }

  ///
  static MaterialColor createMaterialColor(Color color) {
    final List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (final double strength in strengths) {
      final num nStrength = strength;
      final double ds = 0.5 - nStrength;
      swatch[(nStrength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  static Future<void> log(
    Object log,
  ) async {
    print(log);
  }

  /// gives the Snackbar
  static buildErrorSnackbar(
    BuildContext context,
    String? message, {
    int durationMultiplier = 1,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(
          seconds: 3 * durationMultiplier,
        ),
        content: Text(message!),
      ),
    );
  }
}

class NetworkConnectivity {
  NetworkConnectivity._();
  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;
  void initialise() async {
    ConnectivityResult result = await _networkConnectivity.checkConnectivity();
    _checkStatus(result);
    _networkConnectivity.onConnectivityChanged.listen((result) {
      // print(result);
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}
