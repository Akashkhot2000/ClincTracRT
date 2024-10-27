// import 'package:clinicaltrac/common/hardcoded.dart';
// import 'package:clinicaltrac/view/midterm_evaluation/model/midterm_eval_list_model.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class MidtermEvalContainer extends StatelessWidget {
//   const MidtermEvalContainer(
//       {super.key, required this.color, required this.midtermEval});
//
//   ///color to paint on date circular Container
//   final Color color;
//
//   final MidtermEval midtermEval;
//
//   String convertDate(String input) {
//     DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
//
//     DateTime now = dateFormat.parse(input);
//     String formattedDate = DateFormat('MMM dd, yyyy').format(now);
//     // String formattedTime = DateFormat('hh:mm aa').format(now);
//     return formattedDate;
//   }
//
//   String getMonthString(int monthInInt) {
//     switch (monthInInt) {
//       case 1:
//         return 'Jan';
//
//       case 2:
//         return 'Feb';
//       case 3:
//         return 'Mar';
//       case 4:
//         return 'Apr';
//       case 5:
//         return 'May';
//       case 6:
//         return 'Jun';
//       case 7:
//         return 'Jul';
//       case 8:
//         return 'Aug';
//       case 9:
//         return 'Sep';
//       case 10:
//         return 'Oct';
//       case 11:
//         return 'Nov';
//       case 12:
//         return 'Dec';
//     }
//     return '';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6, top: 6, right: 15, left: 15),
//       child: Container(
//         margin: EdgeInsets.all(0.5),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             stops: [0.5, .5],
//             begin: Alignment.center,
//             end: Alignment.topLeft,
//             colors: [
//               Color(Hardcoded.blue),
//               Color(Hardcoded.blue), // top Right part
//             ],
//           ),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Builder(builder: (context) {
//           return Stack(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         blurRadius: 8,
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 1,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.white),
//                 child: Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             height: 65,
//                             width: 65,
//                             decoration: BoxDecoration(
//                               color: color.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(50),
//                               // shape: BoxShape.circle
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     midtermEval.evaluationDate.day.toString(),
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleLarge!
//                                         .copyWith(
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 19,
//                                             color: color),
//                                   ),
//                                   Text(
//                                     getMonthString(
//                                         midtermEval.evaluationDate.month),
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleLarge!
//                                         .copyWith(
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 13,
//                                             color: color),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                     left: 5,
//                                     right: 0,
//                                     top: 5,
//                                   ),
//                                   child: Text(
//                                     midtermEval.rotationName,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleLarge!
//                                         .copyWith(
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 14,
//                                         ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 5,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                     left: 5,
//                                     right: 0,
//                                   ),
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Student signature: ',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .titleLarge!
//                                             .copyWith(
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 11,
//                                                 color: Colors.black54),
//                                       ),
//                                       // Expanded(
//                                       //   child: Text(
//                                       //     midtermEval.dateOfStudentSignature != null
//                                       //         ? DateFormat("MMM dd, yyyy").format(midtermEval
//                                       //             .dateOfStudentSignature!)
//                                       //         : '-',
//                                       //     maxLines: 2,
//                                       //     overflow: TextOverflow.ellipsis,
//                                       //     style: Theme.of(context)
//                                       //         .textTheme
//                                       //         .titleLarge!
//                                       //         .copyWith(
//                                       //           fontWeight: FontWeight.w500,
//                                       //           fontSize: 11,
//                                       //         ),
//                                       //   ),
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 5,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                     left: 5,
//                                     right: 0,
//                                   ),
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Instructor signature: ',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .titleLarge!
//                                             .copyWith(
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 11,
//                                                 color: Colors.black54),
//                                       ),
//                                       // Expanded(
//                                       //   child: Text(
//                                       //     midtermEval.dateOfInstructorSignature != null
//                                       //         ? convertDate(midtermEval
//                                       //             .dateOfInstructorSignature)
//                                       //         : '-',
//                                       //     maxLines: 1,
//                                       //     overflow: TextOverflow.ellipsis,
//                                       //     style: Theme.of(context)
//                                       //         .textTheme
//                                       //         .titleLarge!
//                                       //         .copyWith(
//                                       //           fontWeight: FontWeight.w500,
//                                       //           fontSize: 11,
//                                       //         ),
//                                       //   ),
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//     ;
//   }
// }
//
//
//
//
//
// /*
//  // The end action pane is the one at the right or the bottom side.
//             endActionPane: ActionPane(
//               extentRatio: 0.4,
//               motion: ScrollMotion(),
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {},
//                     child: Container(
//                       color: Color(Hardcoded.blue),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             child: SvgPicture.asset(
//                               'assets/images/signof.svg',
//                             ),
//                           ),
//                           Text(
//                             "Signoff",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleLarge!
//                                 .copyWith(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 14,
//                                   color: Color(Hardcoded.white),
//                                 ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {},
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Color(Hardcoded.blue),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             child: SvgPicture.asset(
//                               'assets/images/view_d.svg',
//                             ),
//                           ),
//                           Text(
//                             "View",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleLarge!
//                                 .copyWith(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 14,
//                                   color: Color(Hardcoded.white),
//                                 ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 /// Delete
//                 //   Expanded(
//                 //     child: GestureDetector(
//                 //       onTap: () {
//                 //         Navigator.pushNamed(context, Routes.addDrInteractionScreen,
//                 //             arguments: AddViewDrIntgeractionData(
//                 //                 drIntractionAction: DrIntractionAction.edit,
//                 //                 drIntraction: null));
//                 //       },
//                 //       child: Container(
//                 //         decoration: BoxDecoration(
//                 //             color: Color(Hardcoded.blue),
//                 //             boxShadow: [
//                 //               BoxShadow(
//                 //                   blurRadius: 8,
//                 //                   color: Colors.grey.withOpacity(0.3),
//                 //                   spreadRadius: 1,
//                 //                   offset: const Offset(0, 3))
//                 //             ],
//                 //             borderRadius: BorderRadius.only(
//                 //               topRight: Radius.circular(20),
//                 //               bottomRight: Radius.circular(20),
//                 //             )),
//                 //         child: Column(
//                 //           mainAxisAlignment: MainAxisAlignment.center,
//                 //           children: [
//                 //             Container(
//                 //               child: SvgPicture.asset(
//                 //                 'assets/images/delete_d.svg',
//                 //               ),
//                 //             ),
//                 //             Text(
//                 //               "Delete",
//                 //               style:
//                 //                   Theme.of(context).textTheme.titleLarge!.copyWith(
//                 //                         fontWeight: FontWeight.w500,
//                 //                         fontSize: 14,
//                 //                         color: Color(Hardcoded.white),
//                 //                       ),
//                 //             )
//                 //           ],
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ),
//               ],
//             ), */