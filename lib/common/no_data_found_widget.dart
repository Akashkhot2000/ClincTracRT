import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoDataFoundWidget extends StatelessWidget {
   NoDataFoundWidget({Key? key,required this.imagePath,required this.title, this.isVisible}) : super(key: key);
  String imagePath;
String title;
bool? isVisible;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child:Column(
      children: [
        // SvgPicture.asset(imagePath),
        Image.asset(imagePath,height: 100,),
        Padding(padding: EdgeInsets.only(top: 10),child:  Text(title,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),)
      ],),
    );
  }
}

// Center(
// child: Padding(padding: EdgeInsets.only(top:globalHeight* 0.15),child:NoDataFoundWidget(
// imagePath: "assets/images/defaultschool.png",
// title: "Rotations not available",
// ),),)