//
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:clinicaltrac/common/common-pop_up.dart';
// import 'package:clinicaltrac/common/common_app_bar.dart';
// import 'package:clinicaltrac/view/web_redirect_loading_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
//
// // Import for iOS features.
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
//
// class WebRedirectionScreen extends StatefulWidget {
//   WebRedirectionScreen(
//       {Key? key, required this.url,required this.onSuccess,required this. onError,required this.onFail,required this.screenTitle})
//       : super(key: key);
//   final String url;
//   dynamic Function() onSuccess ;
//   dynamic Function() onFail;
//   dynamic Function() onError ;
//   String screenTitle;
//
//   @override
//   State<WebRedirectionScreen> createState() => _WebRedirectionScreenState();
// }
//
// class _WebRedirectionScreenState extends State<WebRedirectionScreen> {
//   late final WebViewController _controller;
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }
//
//     final WebViewController controller =
//     WebViewController.fromPlatformCreationParams(params);
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     //..setBackgroundColor(Color(0xFFEF9116))
//       ..setBackgroundColor(Color(0xFFFFFFFF))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             debugPrint('WebView is loading (progress : $progress%)');
//           },
//           onPageStarted: (String url) {
//             debugPrint('Page started loading: $url');
//           },
//           onPageFinished: (String url) async {
//             debugPrint('Page finished loading: $url');
//
//             final webPageData = await controller.runJavaScriptReturningResult('''
//           // Your JavaScript code to extract data here
//           // For example, to read the page title:
//           'Page Title: ' + document.currentScript
//         ''');
//             print("\n\n\nobject\n\n");
//             print("$webPageData");
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint(
//                 '''Page resource error: code: ${error.errorCode} description: ${error.description} errorType: ${error.errorType} isForMainFrame: ${error.isForMainFrame} ''');
//           },
//           onNavigationRequest:  (NavigationRequest
//           request) async {
//             Navigator.pushReplacement(
//               context,
//               // MaterialPageRoute(builder: (context) => WebRedirectionScreen(url: 'https://rt.clinicaltrac.net/redirect/SkJZTnRvN3A=')),
//               MaterialPageRoute(
//                   builder: (context) =>
//                       WebRedirectionWithLoadingScreen(
//                         url: '${request.url}',
//                         screenTitle: widget.screenTitle,
//                         onSuccess: (){
//                           // Navigator.pop(context);
//                           widget.onSuccess();
//                         },
//                         onFail: (){
//                           widget.onFail();
//
//                         },
//                         onError: (){
//                           Navigator.pop(context);
//                           common_alert_pop(context, '${"OOP's"}\nSomething went wrong', 'assets/images/error_Icon.svg', () {Navigator.pop(context);});
//                           widget.onError();
//                         },
//                       )),
//             );
//             // ).then((_) => Navigator.pop(context));
//
//             return NavigationDecision
//                 .navigate;
//           },
//
//           //     (NavigationRequest request){
//           //   if (request.url.startsWith('https://rt.clinicaltrac.net/webRedirect.html?status=Cancel&type=daily/weekly')) {
//           //           debugPrint('blocking navigation to ${request.url}');
//           //           return NavigationDecision.prevent;
//           //         }
//           //         debugPrint('allowing navigation to ${request.url}');
//           //         return NavigationDecision.navigate;
//           // }
//           //   onNavigationRequest: (NavigationRequest request) {
//           //     if (request.url.startsWith('https://www.youtube.com/')) {
//           //       debugPrint('blocking navigation to ${request.url}');
//           //       return NavigationDecision.prevent;
//           //     }
//           //     debugPrint('allowing navigation to ${request.url}');
//           //     return NavigationDecision.navigate;
//           //   },
//           //   onUrlChange: (UrlChange change) {
//           //     debugPrint('url change to ${change.url}');
//           //   },
//         ),
//       )
//       ..addJavaScriptChannel(
//         'Barcode',
//         onMessageReceived: (JavaScriptMessage message) {
//           print('Received message from JavaScript: ${message.message}');
//
//
//
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         },
//       )
//
//       ..loadRequest(
//         Uri.parse('${widget.url}'),
//       );
//     // ..loadRequest(Uri.parse('https://rt.clinicaltrac.net/redirect/SkJZTnRvN3A='));
//     if (controller.platform is AndroidWebViewController) {
//       AndroidWebViewController.enableDebugging(true);
//       (controller.platform as AndroidWebViewController)
//           .setMediaPlaybackRequiresUserGesture(false);
//     }
//     _controller = controller;
//   }
//   _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//   final webViewKey = GlobalKey<_WebRedirectionScreenState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: CommonAppBar(
//       //   titles: Text("Web View",
//       //       textAlign: TextAlign.center,
//       //       style: Theme.of(context).textTheme.titleLarge!.copyWith(
//       //         fontWeight: FontWeight.w600,
//       //         fontSize: 22,
//       //       )),
//       // ),
//       body: WebViewWidget(
//         key: webViewKey,
//         controller: _controller,
//         gestureRecognizers: Set()
//           ..add(Factory<VerticalDragGestureRecognizer>(
//                   () => VerticalDragGestureRecognizer()))
//         ..add(Factory<HorizontalDragGestureRecognizer>(
//                 () => HorizontalDragGestureRecognizer()))
//           ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
//           ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer())),
//       ),
//     );
//   }
//
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// // import 'dart:async';
// // import 'dart:convert';
// // import 'dart:io';
// // import 'dart:typed_data';
// //
// // import 'package:clinicaltrac/common/common_app_bar.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/gestures.dart';
// // import 'package:flutter/material.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
// // import 'package:webview_flutter_android/webview_flutter_android.dart';
// //
// // // Import for iOS features.
// // import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// //
// // class WebRedirectionScreen extends StatefulWidget {
// //   const WebRedirectionScreen(
// //       {Key? key, required this.url, this.navigationRequestCallback})
// //       : super(key: key);
// //   final String url;
// //   final NavigationRequestCallback? navigationRequestCallback;
// //
// //   @override
// //   State<WebRedirectionScreen> createState() => _WebRedirectionScreenState();
// // }
// //
// // class _WebRedirectionScreenState extends State<WebRedirectionScreen> {
// //   late final WebViewController _controller;
// //
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     late final PlatformWebViewControllerCreationParams params;
// //     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
// //       params = WebKitWebViewControllerCreationParams(
// //         allowsInlineMediaPlayback: true,
// //         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
// //       );
// //     } else {
// //       params = const PlatformWebViewControllerCreationParams();
// //     }
// //
// //     final WebViewController controller =
// //         WebViewController.fromPlatformCreationParams(params);
// //     controller
// //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
// //       //..setBackgroundColor(Color(0xFFEF9116))
// //       ..setBackgroundColor(Color(0xFFFFFFFF))
// //       ..setNavigationDelegate(
// //         NavigationDelegate(
// //           onProgress: (int progress) {
// //             debugPrint('WebView is loading (progress : $progress%)');
// //           },
// //           onPageStarted: (String url) {
// //             debugPrint('Page started loading: $url');
// //           },
// //           onPageFinished: (String url) {
// //             debugPrint('Page finished loading: $url');
// //           },
// //           onWebResourceError: (WebResourceError error) {
// //             debugPrint(
// //                 '''Page resource error: code: ${error.errorCode} description: ${error.description} errorType: ${error.errorType} isForMainFrame: ${error.isForMainFrame} ''');
// //           },
// //           onNavigationRequest: widget.navigationRequestCallback,
// //           //     (NavigationRequest request){
// //           //   if (request.url.startsWith('https://rt.clinicaltrac.net/webRedirect.html?status=Cancel&type=daily/weekly')) {
// //           //           debugPrint('blocking navigation to ${request.url}');
// //           //           return NavigationDecision.prevent;
// //           //         }
// //           //         debugPrint('allowing navigation to ${request.url}');
// //           //         return NavigationDecision.navigate;
// //           // }
// //           //   onNavigationRequest: (NavigationRequest request) {
// //           //     if (request.url.startsWith('https://www.youtube.com/')) {
// //           //       debugPrint('blocking navigation to ${request.url}');
// //           //       return NavigationDecision.prevent;
// //           //     }
// //           //     debugPrint('allowing navigation to ${request.url}');
// //           //     return NavigationDecision.navigate;
// //           //   },
// //           //   onUrlChange: (UrlChange change) {
// //           //     debugPrint('url change to ${change.url}');
// //           //   },
// //         ),
// //       )
// //       ..addJavaScriptChannel(
// //         'Toaster',
// //         onMessageReceived: (JavaScriptMessage message) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text(message.message)),
// //           );
// //         },
// //       )
// //       ..loadRequest(
// //         Uri.parse(widget.url),
// //       );
// //     // ..loadRequest(Uri.parse('https://rt.clinicaltrac.net/redirect/SkJZTnRvN3A='));
// //     if (controller.platform is AndroidWebViewController) {
// //       AndroidWebViewController.enableDebugging(true);
// //       (controller.platform as AndroidWebViewController)
// //           .setMediaPlaybackRequiresUserGesture(false);
// //     }
// //     _controller = controller;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: CommonAppBar(
// //         titles: Text("Web View",
// //             textAlign: TextAlign.center,
// //             style: Theme.of(context).textTheme.titleLarge!.copyWith(
// //                   fontWeight: FontWeight.w600,
// //                   fontSize: 22,
// //                 )),
// //       ),
// //       body: WebViewWidget(
// //         controller: _controller,
// //         gestureRecognizers: Set()
// //           ..add(Factory<VerticalDragGestureRecognizer>(
// //               () => VerticalDragGestureRecognizer()))
// //           // ..add(Factory<HorizontalDragGestureRecognizer>(
// //           //         () => HorizontalDragGestureRecognizer()))
// //           ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
// //           ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer())),
// //       ),
// //     );
// //   }
// // }
