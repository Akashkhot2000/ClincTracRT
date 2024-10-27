// // ignore_for_file: must_be_immutable
//
// import 'package:flutter/material.dart';
//
// class CommonTextWidget extends StatelessWidget {
//    CommonTextWidget({Key? key,
//     this.title,
//     this.subTitle,
//   }) : super(key: key);
// String? title;
// String? subTitle;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(padding: EdgeInsets.only(bottom: 3),child:
//     RichText(
//       maxLines: 1,
//       text: TextSpan(
//         text: "${title}: ",
//         style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500,fontSize: 12,color: Color(0xFFBBBBC6)),
//         children: <TextSpan>[
//           TextSpan(
//             text:"${subTitle}".length > 11 ? "${subTitle}".substring(0, 11)+'...' : "${subTitle}", style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500,fontSize: 12,color: Colors.black),),
//         ],
//       ),),
//     );
//   }
// }
