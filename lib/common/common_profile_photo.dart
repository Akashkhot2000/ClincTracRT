// ignore_for_file: sort_child_properties_last, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_const_constructors, camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, must_be_immutable, unnecessary_import

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class commonProfilePhoto extends StatefulWidget {
  bool isEdit;
  TextEditingController? ImageLink;
  String LocalPath;
  TextEditingController? base64Image;
  bool isLocal;
  double radius;

  commonProfilePhoto(
      {required this.isEdit,
      this.ImageLink,
      required this.LocalPath,
      required this.isLocal,
      required this.radius,
      this.base64Image});

  @override
  State<commonProfilePhoto> createState() => _commonProfilePhotoState();
}

class _commonProfilePhotoState extends State<commonProfilePhoto> {
  final ImagePicker _picker = ImagePicker();
  bool isImageLoaded = false;
  File? image = File('');

  String url = '';

  void _showPermissionAlertDialog() async {
    var storageStatus = await Permission.camera.status;
    if (storageStatus.isDenied || storageStatus.isPermanentlyDenied) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Information"),
          content: const Text(
              "Allow Clinical TRAC to access storage OR Camera permission to get photo and upload."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                //checkLocation();
                pickimage();
              },
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(14),
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      );
    } else {
      pickimage();
    }
  }

  // getPhotoPermission() async{
  //   var photoStatus = await Permission.photos.status;
  //   var cameraStatus = await Permission.camera.status;
  //   if (photoStatus.isDenied || photoStatus.isPermanentlyDenied || cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
  //     await openAppSettings();
  // }else{
  //     pickimage();
  //   }
  // }

  Future<void> pickimage() async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color(Hardcoded.white),
          child: Container(
            width: globalWidth * 0.8,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Update profile photo',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                ),
                // Divider(color: Colors.grey,),
                SizedBox(
                  height: globalHeight * 0.02,
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    final XFile? imagei =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (imagei != null) {
                      setState(
                        () async {
                          image = File(imagei.path);
                          String newpath = await _cropImage(imagei.path);
                          image = File(newpath);
                          widget.isLocal = true;
                          isImageLoaded = true;
                          List<int> imageBytes = image!.readAsBytesSync();
                          widget.base64Image!.text = "data:image/png;base64," +
                              base64Encode(imageBytes);
                        },
                      );
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      AppHelper.buildErrorSnackbar(
                          context, 'Image not selected');
                    }
                  },
                  child: Text(
                    'Gallery',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black54),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    final XFile? imagei = await _picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (imagei != null) {
                      setState(
                        () async {
                          image = File(imagei.path);
                          String newpath = await _cropImage(imagei.path);
                          image = File(newpath);
                          widget.isLocal = true;
                          isImageLoaded = true;
                          List<int> imageBytes = image!.readAsBytesSync();
                          widget.base64Image!.text = "data:image/png;base64," +
                              base64Encode(imageBytes);
                        },
                      );
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      AppHelper.buildErrorSnackbar(
                        context,
                        'Image not selected',
                      );
                    }
                  },
                  child: Text(
                    'Camera',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> _cropImage(String path) async {
    // print("May File PAth$path");
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatioPresets: <CropAspectRatioPreset>[CropAspectRatioPreset.square],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop image',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Theme.of(context).scaffoldBackgroundColor,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: false,
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Crop Image',
      ),
    );

    if (croppedFile != null) {
      setState(() {
        image = croppedFile;
      });
    }
    return image!.path;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isEdit ? 20 : 0.0,
            ),
            child: CircleAvatar(
              backgroundColor: Color(Hardcoded.white),
              radius: widget.radius,
              child: Visibility(
                visible: !widget.isLocal,
                child: Container(
                  width: 100.34,
                  height: 100.34,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.5, color: Colors.green),
                          borderRadius: BorderRadius.circular(50))),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: widget.radius,
                    child: ClipOval(
                      child: Image(
                        image: widget.ImageLink!.text.isNotEmpty
                            ? NetworkImage(widget.ImageLink!.text.trim())
                            : AssetImage('assets/default-user.png')
                                as ImageProvider,
                        loadingBuilder: (BuildContext context, Widget child,
                            loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  // child: ClipRRect(
                  //   borderRadius: BorderRadius.circular(50),
                  //   child: CachedNetworkImage(
                  //     fit: BoxFit.fill,
                  //     imageUrl: widget.ImageLink!.text!.trim(),
                  //     placeholder: (context, url) => CircularProgressIndicator(
                  //       color: Colors.green,
                  //     ),
                  //     errorWidget: (context, url, error) => Image.asset(
                  //       'assets/default-user.png',
                  //       fit: BoxFit.fill,
                  //     ),
                  //   ),
                  // ),

                  // child: CircleAvatar(
                  //   radius: widget.radius,
                  //   backgroundImage: NetworkImage(
                  //     widget.ImageLink!.text.trim(),
                  //   ),
                  // child: ClipOval(
                  //   child: Image.network(
                  //     widget.ImageLink!.text.trim(),
                  //     width: widget.radius * 2,
                  //     height: widget.radius * 2,
                  //     fit: BoxFit.cover,
                  //     loadingBuilder: (BuildContext context, Widget child,
                  //         ImageChunkEvent? loadingProgress) {
                  //       if (loadingProgress == null) {
                  //         AssetImage('assets/default-user.png');
                  //         return child;
                  //       } else {
                  //         // Image is still loading, show a placeholder (you can customize this)
                  //         return Center(
                  //           child: CircularProgressIndicator(
                  //             color: Colors.green,
                  //           ),
                  //         );
                  //       }
                  //     },
                  //   ),
                  // ),

                  // child: CircleAvatar(
                  //   radius: widget.radius,
                  //   backgroundImage: NetworkImage(
                  //     widget.ImageLink!.text
                  //         .trim(), // Trim to remove potential whitespaces
                  //   ),
                  // ),

                  // child: CircleAvatar(
                  //   radius: widget.radius,
                  //   backgroundImage: NetworkImage(
                  //     '${widget.ImageLink!.text}',
                  //   ),
                  // ),
                  // child: Image.asset(
                  //   "assets/default-user.png",
                  //   fit: BoxFit.cover,
                  // ),
                ),
                replacement: Visibility(
                  visible: !isImageLoaded,
                  child: Image.asset(
                    '${widget.LocalPath!}',
                    fit: BoxFit.contain,
                    height: 50,
                  ),
                  replacement: CircleAvatar(
                    radius: widget.radius,
                    backgroundImage: FileImage(
                      image!,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isEdit,
            child: GestureDetector(
              onTap: () {
                _showPermissionAlertDialog();
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Color(Hardcoded.primaryGreen),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/images/editPhoto.svg',
                    height: 60,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
