import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatefulWidget {
  NoInternet({Key? key, required this.child}) : super(key: key);
  Widget child;

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  bool? isInternetConnected = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      // print('source $_source');
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          isInternetConnected = _source.values.toList()[0] ? true : false;
          break;
        case ConnectivityResult.wifi:
          isInternetConnected = _source.values.toList()[0] ? true : false;
          break;
        case ConnectivityResult.none:
          // isInternetConnected = null;
          // break;
        default:
          isInternetConnected = false;
      }
      // 2.
      if (mounted) {
        setState(() {});
      }
      // 3.
    });
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  @override
  Widget build(BuildContext context) {
    return isInternetConnected == null
        ? Scaffold(
            body: Center(child: common_loader()),
          )
        : isInternetConnected!
            ? widget.child
            : Scaffold(
                body: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "NO INTERNET",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please check your network connection.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                )),
              );
  }
}
