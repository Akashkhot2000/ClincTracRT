import 'package:flutter/material.dart';

class NumberColorBox extends StatefulWidget {
   NumberColorBox({key,required this.text,required this.boxColor});
  String text;
  Color boxColor;
  @override
  State<NumberColorBox> createState() => _NumberColorBoxState();
}

class _NumberColorBoxState extends State<NumberColorBox> {
  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
      borderRadius: BorderRadius.circular(15.0), // Adjust the radius to get the desired curve
      child: Container(
        width: MediaQuery.of(context).size.width*0.11,
        height: MediaQuery.of(context).size.height*0.055,
        color: widget.boxColor,
        child: Center(child: Text(widget.text,style: TextStyle(color: Color(0xFF868998,
        ),fontWeight: FontWeight.w600,fontSize: 17
        ),),),
      ),
    );
  }
}
