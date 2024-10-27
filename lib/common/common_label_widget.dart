import 'package:flutter/material.dart';

class common_label_widget extends StatelessWidget {
  String text;
  bool? isRequired;
  common_label_widget({required this.text, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Color(0XFF5F6377),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
        children: <TextSpan>[
          TextSpan(
            text: isRequired! ? '*' : "",
            style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
