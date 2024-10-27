import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebRedirectionWithLoadingScreen extends StatefulWidget {
  WebRedirectionWithLoadingScreen(
      {Key? key,
      required this.url,
      required this.onSuccess,
      required this.onFail,
      required this.onError,
      required this.screenTitle})
      : super(key: key);
  final String url;
  dynamic Function() onSuccess;

  dynamic Function() onFail;

  dynamic Function() onError;

  String screenTitle;

  @override
  State<WebRedirectionWithLoadingScreen> createState() =>
      _WebRedirectionWithLoadingScreenState();
}

class _WebRedirectionWithLoadingScreenState
    extends State<WebRedirectionWithLoadingScreen> {
  late final WebViewController _controller;
  // bool loading = true;
  int progresss = 0;

  // void startTimer() {
  //   // setState(() {
  //   //   loading = true;
  //   // });
  //   // Future.delayed(const Duration(seconds: 2), () {
  //    if(mounted){ setState(() {
  //       loading = false;
  //     });
  //   }
  //      // });
  // }

  // void stopTimer() {
  //   setState(() {
  //     loading = false;
  //   });
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      //..setBackgroundColor(Color(0xFFEF9116))
      ..setBackgroundColor(Color(0xFFFFFFFF))
      ..getScrollPosition()
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
            progresss = progress;
          },
          onPageStarted: (String url) {
            // debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) async {
            // debugPrint('Page finished loading: $url');

            final webPageData =
                await controller.runJavaScriptReturningResult('''
          // Your JavaScript code to extract data here
          // For example, to read the page title:
          'Page Title: ' + document.currentScript
        ''');
            // print("\n\n\nobject\n\n");
            // print("$webPageData");
          },
          onWebResourceError: (WebResourceError error) {
            // debugPrint('''Page resource error: code: ${error.errorCode} description: ${error.description} errorType: ${error.errorType} isForMainFrame: ${error.isForMainFrame} ''');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Barcode',
        onMessageReceived: (JavaScriptMessage message) {
          // print('Received message from JavaScript: ${message.message}');
          WebViewResponseModel webViewResponseModel = WebViewResponseModel.fromJson(jsonDecode(message.message));
          if (webViewResponseModel.payload!.statusType!.compareTo("Success") ==
              0) {
          // if(progresss == 100){  stopTimer();}
            //Success
            widget.onSuccess();
            Navigator.pop(context);
          } else if (webViewResponseModel.payload!.statusType!
                  .compareTo("Cancel") ==
              0) {
            widget.onFail();
            Navigator.pop(context);
          } else if (webViewResponseModel.payload!.statusType!
                  .compareTo("Error") ==
              0) {
            // Navigator.pop(context);
            widget.onError();
            Navigator.pop(context);
          }
        },
      )
      ..loadRequest(
        Uri.parse('${widget.url}'),
      );

    // ..loadRequest(Uri.parse('https://rt.clinicaltrac.net/redirect/SkJZTnRvN3A='));
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    _controller = controller;
  }

  final webViewKey = GlobalKey<_WebRedirectionWithLoadingScreenState>();

  @override
  Widget build(BuildContext context) {
    return NoInternet(
      child: Scaffold(
        appBar: CommonAppBar(
          titles: Text("${widget.screenTitle}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  )),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: WebViewWidget(
            key: webViewKey,
            controller: _controller,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
      Factory<OneSequenceGestureRecognizer>(
      () => EagerGestureRecognizer(),
      ),}
            // gestureRecognizers: Set()
            //   ..add(Factory<VerticalDragGestureRecognizer>(
            //       () => VerticalDragGestureRecognizer()))
            //   ..add(Factory<HorizontalDragGestureRecognizer>(
            //       () => HorizontalDragGestureRecognizer()))
            //   ..add(
            //       Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
            //   ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer())),
          ),
        ),
      ),
    );
  }
}

class WebViewResponseModel {
  int? status;
  bool? success;
  String? message;
  Payload? payload;

  WebViewResponseModel({this.status, this.success, this.message, this.payload});

  WebViewResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    payload =
        json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    return data;
  }
}

class Payload {
  String? type;
  String? statusType;
  String? erroMsg;

  Payload({this.type, this.statusType, this.erroMsg});

  Payload.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    statusType = json['StatusType'];
    erroMsg = json['ErroMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Type'] = this.type;
    data['StatusType'] = this.statusType;
    data['ErroMsg'] = this.erroMsg;
    return data;
  }
}
