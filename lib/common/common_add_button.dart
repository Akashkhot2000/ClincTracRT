import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class commonAddButton extends StatelessWidget {
  Function() onTap;
  commonAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color(Hardcoded.orange),
      child: Center(child: SvgPicture.asset('assets/images/add_orange.svg')),
      onPressed: onTap,
    );
  }
}
