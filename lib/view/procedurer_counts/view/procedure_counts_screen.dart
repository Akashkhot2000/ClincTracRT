// import 'package:clinicaltrac/api/data_locator.dart';
// import 'package:clinicaltrac/api/data_service.dart';
// import 'package:clinicaltrac/common/common_app_bar.dart';
// import 'package:clinicaltrac/common/common_loader.dart';
// import 'package:clinicaltrac/common/common_tab_veiw_widget.dart';
// import 'package:clinicaltrac/common/common_text_widget.dart';
// import 'package:clinicaltrac/common/common_textformfield.dart';
// import 'package:clinicaltrac/common/hardcoded.dart';
// import 'package:clinicaltrac/common/no_data_found_widget.dart';
// import 'package:clinicaltrac/common/nointernetwidget.dart';
// import 'package:clinicaltrac/main.dart';
// import 'package:clinicaltrac/model/data_response_model.dart';
// import 'package:clinicaltrac/view/procedurer_counts/model/all_rotation_list_model.dart';
// import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_detail_model.dart';
// import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_detail_request.dart';
// import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_model.dart';
// import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_request_model.dart';
// import 'package:clinicaltrac/view/procedurer_counts/view/procedure_count_detail_screen.dart';
// import 'package:clinicaltrac/view/procedurer_counts/view/procedure_count_steps_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:ios_keyboard_action/ios_keyboard_action.dart';
//
// class ProcedureCountScreen extends StatefulWidget {
//   ProcedureCountScreen({
//     Key? key,
//     required this.allRotation,
//   }) : super(key: key);
//   final AllRotation allRotation;
//
//   @override
//   State<ProcedureCountScreen> createState() => _ProcedureCountScreenState();
// }
//
// class _ProcedureCountScreenState extends State<ProcedureCountScreen> {
//   int pageNo = 1;
//   int lastpage = 1;
//   bool datanotFound = false;
//   List<ProcedureCountData> procedureCountData = [];
//   bool isDataLoaded = true;
//   bool isSearchClicked = false;
//
//   TextEditingController textController = TextEditingController();
//   TextEditingController searchTextController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final PageController _pageController = PageController();
//
//   void getProcedureCountList() async {
//     // if (pageNo == 1 || pageNo <= lastpage) {
//       setState(() {
//         isDataLoaded = true;
//       });
//       final DataService dataService = locator();
//
//       ProceduerCountRequest request = ProceduerCountRequest(
//         accessToken:  box.get(Hardcoded.hiveBoxKey)!.accessToken,
//         userId:  box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
//         RotationId: widget.allRotation.rotationId,
//         pageNo: pageNo.toString(),
//         RecordsPerPage: '10',
//       );
//       final DataResponseModel dataResponseModel =
//           await dataService.getProcedureCountList(request);
//       ProcedureCountModel procedureCountModel =
//           ProcedureCountModel.fromJson(dataResponseModel.data);
//       // lastpage =
//       //     (int.parse(procedureCountModel.pager.totalRecords!) / 10).ceil();
//       // if (procedureCountModel.pager.totalRecords == '0') {
//       //   setState(() {
//       //     datanotFound = true;
//       //   });
//       // } else {
//       //   setState(() {
//       //     datanotFound = false;
//       //   });
//       // }
//       setState(() {
//         // if (pageNo != 1) {
//           procedureCountData.addAll(procedureCountModel.data);
//         // } else {
//           procedureCountData = procedureCountModel.data;
//         // }
//         isDataLoaded = false;
//       });
//       getProcedureCountDetailsList();
//     // }
//   }
//
//   List<ProcedureCountDetail> procedureCountDetail = [];
//
//   void getProcedureCountDetailsList() async {
//     if (pageNo == 1 || pageNo <= lastpage) {
//       setState(() {
//         isDataLoaded = true;
//       });
//       final DataService dataService = locator();
//
//       ProcedureCountDetailRequest request = ProcedureCountDetailRequest(
//         accessToken:  box.get(Hardcoded.hiveBoxKey)!.accessToken,
//         userId:  box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
//         RotationId: widget.allRotation.rotationId,
//         procedureCategoryId: procedureCountData[_selectedIndex].pcId,
//         pageNo: pageNo.toString(),
//         RecordsPerPage: '5',
//         SearchText: searchTextController.text,
//       );
//       final DataResponseModel dataResponseModel =
//           await dataService.getProcedureCountDetails(request);
//       ProcedureCountDetailsModel procedureCountDetailsModel =
//           ProcedureCountDetailsModel.fromJson(dataResponseModel.data);
//       lastpage =
//           (int.parse(procedureCountDetailsModel.pager.totalRecords!) / 5)
//               .ceil();
//       if (procedureCountDetailsModel.pager.totalRecords == '0') {
//         setState(() {
//           datanotFound = true;
//         });
//       } else {
//         setState(() {
//           datanotFound = false;
//         });
//       }
//       setState(() {
//         if (pageNo != 1) {
//           procedureCountDetail.addAll(procedureCountDetailsModel.data);
//         } else {
//           procedureCountDetail = procedureCountDetailsModel.data;
//         }
//         isDataLoaded = false;
//       });
//     }
//   }
//
//   void _scrollListener() {
//     if (_scrollController.offset >=
//             _scrollController.position.maxScrollExtent &&
//         !_scrollController.position.outOfRange) {
//       pageNo += 1;
//       getProcedureCountDetailsList();
//     }
//   }
//
//   Future<void> pullToRefresh() async {
//     isDataLoaded = true;
//     pageNo = 1;
//     searchTextController.text = '';
//     getProcedureCountList();
// isSearchClicked = false;
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollListener);
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     getProcedureCountList();
//     _scrollController.addListener(_scrollListener);
//     super.initState();
//   }
//
//   int _selectedIndex = 0;
//   final searchFocusNode = FocusNode();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CommonAppBar(
//         titles: isSearchClicked
//             ? Padding(
//                 padding: const EdgeInsets.only(
//                   top: 5,
//                 ),
//                 child: Material(
//                   color: Colors.white,
//                   child: IOSKeyboardAction(
//                     label: 'DONE',
//                     focusNode: searchFocusNode,
//                     focusActionType: FocusActionType.done,
//                     onTap: () {},
//                     child: CommonSearchTextfield(
//                       focusNode: searchFocusNode,
//                       hintText: 'Search',
//                       textEditingController: searchTextController,
//                       onChanged: (value) {
//                         pageNo = 1;
//                         getProcedureCountDetailsList();
//                       },
//                     ),
//                   ),
//                 ),
//               )
//             : Text(
//                 "Procedure Count",
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 22,
//                     ),
//               ),
//         searchEnabeled: true,
//         image: !isSearchClicked
//             ? SvgPicture.asset(
//                 'assets/images/search.svg',
//               )
//             : SvgPicture.asset(
//                 'assets/images/closeicon.svg',
//               ),
//         onSearchTap: () {
//           setState(() {
//             isSearchClicked = !isSearchClicked;
//             searchTextController.text = '';
//             FocusScope.of(context).unfocus();
//             if (isSearchClicked == false) getProcedureCountDetailsList();
//           });
//         },
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: 40,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: procedureCountData.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _selectedIndex = index;
//                     });
//                     getProcedureCountDetailsList();
//                   },
//                   child: Container(
//                     height: globalHeight * 0.06,
//                     decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: index == _selectedIndex
//                                   ? Color(Hardcoded.primaryGreen)
//                                   : Color(0xFFBBBBC6),
//                               width: 2),),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                           bottom: 7,
//                           left: 15,
//                           right: procedureCountData.last.title.isNotEmpty
//                               ? 15
//                               : 0),
//                       child: Container(
//                         height: globalHeight * 0.06,
//                         child: Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                     bottom: globalHeight * 0.001),
//                                 child: Text(
//                                   procedureCountData[index].title,
//                                   textAlign: TextAlign.start,
//                                   style: TextStyle(
//                                     // letterSpacing: 1,
//                                     fontSize: 16,
//                                     color: index == _selectedIndex
//                                         ? Color(Hardcoded.primaryGreen)
//                                         : Color(0xFFBBBBC6),
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ]),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 0),
//           Visibility(
//             visible: isSearchClicked == false && isDataLoaded && pageNo == 1,
//             child: Padding(
//               padding: EdgeInsets.only(top: globalHeight * 0.3),
//               child: common_loader(),
//             ),
//             replacement: Visibility(
//               visible: !datanotFound,
//               replacement: Padding(
//                 padding: EdgeInsets.only(top: globalHeight * 0.3),
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: NoDataFoundWidget(
//                     title: "Procedure count details not available",
//                     // title: "No data found",
//                     imagePath: "assets/no_data_found.png",
//                   ),
//                 ),
//               ),
//               child: procedureCountDetail.isEmpty
//                   ? Center(
//                       child: NoDataFoundWidget(
//                         title: "Procedure count details not available",
//                         imagePath: "assets/no_data_found.png",
//                       ),
//                     )
//                   : Expanded(
//                       child: PageView.builder(
//                         controller: _pageController,
//                         itemCount: 1,
//                         physics: AlwaysScrollableScrollPhysics(),
//                         scrollDirection: Axis.vertical,
//                         onPageChanged: (index) {
//                           setState(() {
//                             _selectedIndex = index;
//                           });
//                         },
//                         itemBuilder: (context, index) {
//                           return RefreshIndicator(
//                             onRefresh: () => pullToRefresh(),
//                             color: Color(0xFFBBBBC6),
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                 boxShadow: <BoxShadow>[
//                                   BoxShadow(
//                                     color: Color.fromARGB(
//                                       24,
//                                       203,
//                                       204,
//                                       208,
//                                     ),
//                                     blurRadius: 35.0, // soften the shadow
//                                     spreadRadius: 10.0, //extend the shadow
//                                     offset: Offset(
//                                       15.0,
//                                       15.0,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               child: ProcedureCountDetailScreen(
//                                 procedureCountTopicId:
//                                     procedureCountData[index].pcId,
//                                 procedureCountDetail:
//                                     procedureCountDetail,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
