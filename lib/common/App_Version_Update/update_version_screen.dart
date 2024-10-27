import 'package:app_version_update/data/models/app_version_result.dart';
import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// ```AppVersionUpdate.showAlertUpdate()``` AlertDialog widget
// ignore: must_be_immutable
class UpdateVersionDialogScreen extends Container {
  String? title;
  String? content;
  bool? mandatory;
  String? updateButtonText;
  String? cancelButtonText;
  ButtonStyle? updateButtonStyle;
  ButtonStyle? cancelButtonStyle;
  AppVersionResult? appVersionResult;
  Color? backgroundColor;
  TextStyle? titleTextStyle;
  TextStyle? contentTextStyle;
  TextStyle? cancelTextStyle;
  TextStyle? updateTextStyle;

  UpdateVersionDialogScreen(
      {this.title,
        this.content,
        this.mandatory,
        this.updateButtonText,
        this.cancelButtonText,
        this.updateButtonStyle,
        this.updateTextStyle,
        this.appVersionResult,
        this.backgroundColor,
        this.cancelButtonStyle,
        this.cancelTextStyle,
        this.contentTextStyle,
        this.titleTextStyle,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: backgroundColor!,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        title: Center(
          child: Text(
            title!,
            style: titleTextStyle ??
                const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700),
          ),
        ),
        content: Text(
          content!,
          textAlign: TextAlign.center,
          style: contentTextStyle ??
              const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400),
        ),
        actions: [
          mandatory!
              ? const SizedBox.shrink()
              : TextButton(
              style: cancelButtonStyle,
              onPressed: () => Navigator.pop(context),
              child: Text(
                cancelButtonText!,
                style: cancelTextStyle,
              )),
          mandatory == true ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [Padding( padding:  EdgeInsets.only(left: globalWidth * 0.1,right: globalWidth * 0.1),child:TextButton(
              style: updateButtonStyle,
              onPressed: () => launchUrl(Uri.parse(appVersionResult!.storeUrl!),
                  mode: LaunchMode.externalApplication),
              child: Text(
                updateButtonText!,
                style: updateTextStyle,
              )))]):TextButton(
              style: updateButtonStyle,
              onPressed: () => launchUrl(Uri.parse(appVersionResult!.storeUrl!),
                  mode: LaunchMode.externalApplication),
              child: Text(
                updateButtonText!,
                style: updateTextStyle,
              ))
        ]);
  }
}
