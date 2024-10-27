import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class common_loader extends StatefulWidget {
  common_loader({this.padding = 50, this.durationInSec = 5, this.size = 50});
  double? padding;
  int? durationInSec;
  double? size;

  @override
  State<common_loader> createState() => _common_loaderState();
}

class _common_loaderState extends State<common_loader> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: widget.durationInSec!), () {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
    return Visibility(
      visible: isLoading,
      child: Padding(
        padding: EdgeInsets.all(widget.padding!),
        child: SpinKitFadingCircle(
          color: Color(Hardcoded.primaryGreen),
          size: widget.size!,
        ),
      ),
      replacement: Text(
        "Data could not be retrieved",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
      ),
    );
  }
}
