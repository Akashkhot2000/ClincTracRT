import 'package:flutter/material.dart';

class NullCheckWidget extends StatefulWidget {
  NullCheckWidget({Key? key, this.child, this.childNull, this.varia}) : super(key: key);
  Widget? child;
  Widget? childNull;
  String? varia;

  @override
  State<NullCheckWidget> createState() => _NullCheckWidgetState();
}

class _NullCheckWidgetState extends State<NullCheckWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.varia == null ? widget.childNull ?? SizedBox.shrink():widget.child!;
  }
}
