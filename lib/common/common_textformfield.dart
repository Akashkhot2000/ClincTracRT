import 'dart:ffi';

import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextfield extends StatefulWidget {
  ///
  const CommonTextfield({
    Key? key,
    this.textEditingController,
    this.buildCounter,
    this.sufix,
    this.maxLines,
    this.minLines,
    this.inputText,
    this.hintText,
    this.enabled = true,
    this.inputFormatters,
    this.keyboardType,
    this.onChanged,
    this.initialValue,
    this.onTap,
    this.maxlength,
    this.readOnly = false,
    this.textInputAction,
    this.textCapitalization,
    this.obscureText,
    this.focusNode,
    this.autoFocus,
    this.overflow,
    this.validation,
    this.iscalenderField = false,
    this.textColor,
  }) : super(key: key);

  ///
  final TextEditingController? textEditingController;
  final InputCounterWidgetBuilder? buildCounter;

  final Widget? sufix;

  final bool iscalenderField;

  final int? maxLines;

  final int? minLines;

  final String? inputText;

  final String? hintText;

  final bool? enabled;

  final List<TextInputFormatter>? inputFormatters;

  final TextInputType? keyboardType;

  final void Function(String)? onChanged;

  final String? initialValue;

  final void Function()? onTap;

  final int? maxlength;

  final bool? readOnly;

  final bool? obscureText;

  final bool? autoFocus;

  final FocusNode? focusNode;
  final Color? textColor;

  /// text Capitalization
  final TextCapitalization? textCapitalization;

  final String? Function(String?)? validation;

  final TextInputAction? textInputAction;

  final TextOverflow? overflow;

  @override
  State<CommonTextfield> createState() => _CommonTextfieldState();
}

class _CommonTextfieldState extends State<CommonTextfield> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.inputText != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 2, left: 0),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 4,
                      ),
                      child: Text(
                        "${widget.inputText}",
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Color(Hardcoded.textColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        Visibility(
          visible: widget.enabled! || widget.iscalenderField,
          child: TextFormField(
            buildCounter: widget.buildCounter,
            autofocus: widget.autoFocus!,
            focusNode: widget.focusNode,
            onTap: widget.onTap,
            validator: widget.validation,
            textCapitalization:
                widget.textCapitalization ?? TextCapitalization.sentences,
            // Capital first letter
            readOnly: widget.readOnly ?? false,
            onChanged: widget.onChanged,
            inputFormatters: widget.inputFormatters,
            controller: widget.textEditingController,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLength: widget.maxlength,
            maxLines: widget.maxLines ?? 1,
            minLines: widget.minLines,

            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Color(Hardcoded.textColor),
                  overflow: TextOverflow.ellipsis,
                ),

            obscureText: widget.obscureText ?? false,
            initialValue: widget.initialValue,
            enabled: widget.enabled,
            decoration: InputDecoration(
              suffixIcon: widget.sufix,
              errorStyle: TextStyle(fontStyle: FontStyle.italic),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.red),
              ),
              fillColor: widget.enabled! && widget.readOnly! == false
                  ? Color(Hardcoded.textFieldBg)
                  : Color(Hardcoded.textFieldBgDisabled),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                  color: widget.textColor == null
                      ? Color(Hardcoded.greyText)
                      : widget.textColor),
              contentPadding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 17,
                bottom: 17,
              ),
              filled: true,

              // border: OutlineInputBorder()
            ),
          ),
          replacement: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 17,
                    bottom: 17,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: widget.enabled! && widget.readOnly! == false
                        ? Color(Hardcoded.textFieldBg)
                        : Color(Hardcoded.textFieldBgDisabled),
                  ),
                  child: Text(
                    widget.textEditingController!.text.isNotEmpty
                        ? widget.textEditingController!.text
                        : widget.hintText!,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Color(Hardcoded.textColor),
                          overflow: widget.overflow,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CommonSearchTextfield extends StatefulWidget {
  ///
  const CommonSearchTextfield({
    Key? key,
    this.textEditingController,
    this.sufix,
    this.prifix,
    this.maxLines,
    this.hintText,
    this.enabled,
    this.inputFormatters,
    this.keyboardType,
    this.onChanged,
    this.initialValue,
    this.onTap,
    this.maxlength,
    this.readOnly,
    this.textInputAction,
    this.textCapitalization,
    this.obscureText,
    this.autoFocus = true,
    this.focusNode,
    this.fillColor,
  }) : super(key: key);

  ///
  final TextEditingController? textEditingController;

  final Widget? sufix;

  final Widget? prifix;

  final int? maxLines;

  final String? hintText;

  final bool? enabled;

  final List<TextInputFormatter>? inputFormatters;

  final TextInputType? keyboardType;

  final void Function(String)? onChanged;

  final String? initialValue;

  final void Function()? onTap;

  final int? maxlength;

  final bool? readOnly;
  final bool autoFocus;

  final bool? obscureText;

  final FocusNode? focusNode;
  final Color? fillColor;

  /// text Capitalization
  final TextCapitalization? textCapitalization;

  final TextInputAction? textInputAction;

  @override
  State<CommonSearchTextfield> createState() => _CommonSearchTextfieldState();
}

class _CommonSearchTextfieldState extends State<CommonSearchTextfield> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: TextFormField(
        autofocus: widget.autoFocus == false ? false : widget.autoFocus,
        focusNode: widget.focusNode,
        onTap: widget.onTap,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.sentences,
        // Capital first letter
        readOnly: widget.readOnly ?? false,
        onChanged: widget.onChanged,
        inputFormatters: widget.inputFormatters,
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        maxLength: widget.maxlength,
        maxLines: widget.maxLines ?? 1,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: Color(Hardcoded.textColor),
            ),

        obscureText: widget.obscureText ?? false,
        initialValue: widget.initialValue,
        enabled: widget.enabled,
        decoration: InputDecoration(
          prefixIcon: widget.prifix,
          suffixIcon: widget.sufix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          fillColor: widget.fillColor != null
              ? widget.fillColor
              : Color(Hardcoded.textFieldBg),
          // fillColor: Color(Hardcoded.textFieldBg),
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.only(
            left: 20,
            right: 10,
            top: 0,
            bottom: 0,
          ),

          filled: true,

          // border: OutlineInputBorder()
        ),
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }
}

class CommonGreyField extends StatefulWidget {
  ///
  const CommonGreyField(
      {Key? key,
      this.textEditingController,
      this.sufix,
      this.maxLines,
      this.hintText,
      this.enabled = true,
      this.inputFormatters,
      this.keyboardType,
      this.onChanged,
      this.initialValue,
      this.onTap,
      this.maxlength,
      this.readOnly,
      this.textInputAction,
      this.textCapitalization,
      this.obscureText,
      this.align = TextAlign.center})
      : super(key: key);

  ///
  final TextEditingController? textEditingController;

  final Widget? sufix;

  final int? maxLines;

  final String? hintText;

  final bool? enabled;

  final List<TextInputFormatter>? inputFormatters;

  final TextInputType? keyboardType;

  final void Function(String)? onChanged;

  final String? initialValue;

  final void Function()? onTap;

  final int? maxlength;

  final bool? readOnly;

  final bool? obscureText;

  final TextAlign? align;

  /// text Capitalization
  final TextCapitalization? textCapitalization;

  final TextInputAction? textInputAction;

  @override
  State<CommonGreyField> createState() => _CommonGreyFieldState();
}

class _CommonGreyFieldState extends State<CommonGreyField> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: TextFormField(
        onTap: widget.onTap,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.sentences,
        // Capital first letter
        readOnly: widget.readOnly ?? false,
        onChanged: widget.onChanged,
        inputFormatters: widget.inputFormatters,
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        maxLength: widget.maxlength,
        maxLines: widget.maxLines ?? 1,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: Color(Hardcoded.textColor),
            fontSize: 13),
        textAlign: widget.align!,
        obscureText: widget.obscureText ?? false,
        initialValue: widget.initialValue,
        enabled: widget.enabled,
        decoration: InputDecoration(
          suffixIcon: widget.sufix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          //fillColor: widget.enabled! ? Color(Hardcoded.textFieldBg) : Color(Hardcoded.textFieldBgDisabled),
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: 10,
          ),

          //filled: true,

          // border: OutlineInputBorder()
        ),
      ),
    );
  }
}
