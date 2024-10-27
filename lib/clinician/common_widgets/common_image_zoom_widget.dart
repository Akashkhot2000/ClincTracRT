// ignore_for_file: must_be_immutable, public_member_api_docs, avoid_redundant_argument_values

import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

///
class ImageZoomScreen extends StatefulWidget {
  String? imagename;
  String? image;

  ///
  ImageZoomScreen({
    Key? key,
    this.imagename,
    this.image,
  }) : super(key: key);

  @override
  State<ImageZoomScreen> createState() => _ImageZoomScreenState();
}

class _ImageZoomScreenState extends State<ImageZoomScreen> {
  TransformationController controller = TransformationController();
  String velocity = "VELOCITY";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
       titles: Text("Image",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            )),

      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: InteractiveViewer(
            clipBehavior: Clip.none,
            minScale: 1.0,
            maxScale: 4.0,
            // boundaryMargin: const EdgeInsets.all(
            //   double.infinity,),
            constrained: true,
            child:FadeInImage
                .assetNetwork(
              placeholder:
              'assets/default-user.png',
              image: widget.image!,
              fit:
              BoxFit.contain,
              height: globalHeight,
              width: globalWidth,
            ),
          ),
        ),
      ),
    );
  }
}
